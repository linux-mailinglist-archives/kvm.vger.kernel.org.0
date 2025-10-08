Return-Path: <kvm+bounces-59636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CEF1BC48C6
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 13:25:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0F1FE4F1B6E
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 11:25:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 283002F6191;
	Wed,  8 Oct 2025 11:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uvkPfaSQ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B382EC55B
	for <kvm@vger.kernel.org>; Wed,  8 Oct 2025 11:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759922742; cv=none; b=KrO+Z+zGZwSTP/4v6LQ/xsKHGjmX4J4G+VES+R6mCTca8xgtjhRLmXgz729pR1vsW2DXwgvpPQnHevJL5LCIYRwZLA1FH3lTJG+E7/59gRk9yojkmGz7CPoZZBFXP3criEUzW+t0SA/J4/dte+Z6HsjXjODC+HcmHTQgGsV8rGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759922742; c=relaxed/simple;
	bh=0QNN3tIVq8T2c5IFDVGhEWEWYxZIkYUzOSVKY3KuacU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tfd7ALr1+M9/HerTf9YAolzwV0HdReLvVgxdGFx5iYFzlPshb8AkBFR7PZWyvuarNdzCTKDadXOHRIdKw9Z3Qq8fEVLgsiuMJCLD85nKogcQWidQ87mfMttxezlWRo0hjKposDOUFuAAvMCwf1HtiXjy2WMvpnP8PRrpDQtKtL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uvkPfaSQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5090C4CEF4;
	Wed,  8 Oct 2025 11:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759922742;
	bh=0QNN3tIVq8T2c5IFDVGhEWEWYxZIkYUzOSVKY3KuacU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uvkPfaSQdAW5wGizHdWYr/+VZvqocEClsOBT5FbOZf81Ki4TrHkbKDgpREvsl6oFb
	 tMD7lJbehPj9apKweGRW8n4shCYzgy2dfTOdsNRLi2hiGbEM/N2IZEv/nNFpyMIHke
	 d4T6EFBum+E/PEkAL6eKOVKl9/WnkN3RjrYEYBMb76D5RTTEHPRyU1xKFqQ7Fp47wh
	 Y6lT4wFKBYUTVDZeLrRlxIXny0MzbFPP2muEnCrMn4lT/g8WcQgmXNxE01hTiEhAB5
	 JsL+5oHhgxECNwanlclKpe7RyN5+oyj0ipwi+Ef/sx1nM3r4EuWGarKeuMp6P83Mzl
	 fKd0Kar5Ps6/g==
Date: Wed, 8 Oct 2025 13:50:00 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Markus Armbruster <armbru@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>, 
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel <qemu-devel@nongnu.org>, kvm@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Nikunj A Dadhania <nikunj@amd.com>, 
	"Daniel P. Berrange" <berrange@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, 
	Zhao Liu <zhao1.liu@intel.com>, Michael Roth <michael.roth@amd.com>, 
	Roy Hopkins <roy.hopkins@randomman.co.uk>
Subject: Re: [PATCH v2 6/9] target/i386: SEV: Add support for enabling
 debug-swap SEV feature
Message-ID: <w4fwyzmq2a7of5wemzkxwwt4igvacjxnzecypyz4nbhuxvzz5v@oa5lql4qvpw7>
References: <cover.1758794556.git.naveen@kernel.org>
 <4f0f28154342d562e76107dfd60ed3a02665fbfe.1758794556.git.naveen@kernel.org>
 <871pnfjl0y.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871pnfjl0y.fsf@pond.sub.org>

On Tue, Oct 07, 2025 at 08:14:37AM +0200, Markus Armbruster wrote:
> "Naveen N Rao (AMD)" <naveen@kernel.org> writes:
> 
> > Add support for enabling debug-swap VMSA SEV feature in SEV-ES and
> > SEV-SNP guests through a new "debug-swap" boolean property on SEV guest
> > objects. Though the boolean property is available for plain SEV guests,
> > check_sev_features() will reject setting this for plain SEV guests.
> 
> Is this the sev_features && !sev_es_enabled() check there?

Yes, that's the one.

> 
> Does "reject setting this" mean setting it to true is rejected, or does
> it mean setting it to any value is rejected?

Right -- we don't allow this to be "enabled". Passing "debug-swap=off" 
should mostly be a no-op.

> 
> > Though this SEV feature is called "Debug virtualization" in the APM, KVM
> > calls this "debug swap" so use the same name for consistency.
> >
> > Sample command-line:
> >   -machine q35,confidential-guest-support=sev0 \
> >   -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,debug-swap=on
> 
> Always appreciated in commit messages.
> 
> I get "cannot set up private guest memory for sev-snp-guest: KVM
> required".  If I add the obvious "-accel kvm", I get "-accel kvm:
> vm-type SEV-SNP not supported by KVM".  I figure that's because my
> hardware isn't capable.  The error message could be clearer.  Not this
> patch's fault.

SEV needs to be explicitly enabled in the BIOS:
https://github.com/AMDESE/AMDSEV/tree/snp-latest?tab=readme-ov-file#prepare-host

Be sure to enable SMEE first to be able to see the other options.

> 
> > Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> > Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
> > ---
> >  target/i386/sev.h |  1 +
> >  target/i386/sev.c | 20 ++++++++++++++++++++
> >  qapi/qom.json     |  6 +++++-
> >  3 files changed, 26 insertions(+), 1 deletion(-)
> >
> > diff --git a/target/i386/sev.h b/target/i386/sev.h
> > index 102546b112d6..8e09b2ce1976 100644
> > --- a/target/i386/sev.h
> > +++ b/target/i386/sev.h
> > @@ -45,6 +45,7 @@ bool sev_snp_enabled(void);
> >  #define SEV_SNP_POLICY_DBG      0x80000
> >  
> >  #define SVM_SEV_FEAT_SNP_ACTIVE     BIT(0)
> > +#define SVM_SEV_FEAT_DEBUG_SWAP     BIT(5)
> >  
> >  typedef struct SevKernelLoaderContext {
> >      char *setup_data;
> > diff --git a/target/i386/sev.c b/target/i386/sev.c
> > index 88dd0750d481..e9d84ea25571 100644
> > --- a/target/i386/sev.c
> > +++ b/target/i386/sev.c
> > @@ -319,6 +319,11 @@ sev_set_guest_state(SevCommonState *sev_common, SevState new_state)
> >      sev_common->state = new_state;
> >  }
> >  
> > +static bool is_sev_feature_set(SevCommonState *sev_common, uint64_t feature)
> > +{
> > +    return !!(sev_common->sev_features & feature);
> > +}
> > +
> >  static void sev_set_feature(SevCommonState *sev_common, uint64_t feature, bool set)
> >  {
> >      if (set) {
> > @@ -2744,6 +2749,16 @@ static int cgs_set_guest_policy(ConfidentialGuestPolicyType policy_type,
> >      return 0;
> >  }
> >  
> > +static bool sev_common_get_debug_swap(Object *obj, Error **errp)
> > +{
> > +    return is_sev_feature_set(SEV_COMMON(obj), SVM_SEV_FEAT_DEBUG_SWAP);
> > +}
> > +
> > +static void sev_common_set_debug_swap(Object *obj, bool value, Error **errp)
> > +{
> > +    sev_set_feature(SEV_COMMON(obj), SVM_SEV_FEAT_DEBUG_SWAP, value);
> > +}
> > +
> >  static void
> >  sev_common_class_init(ObjectClass *oc, const void *data)
> >  {
> > @@ -2761,6 +2776,11 @@ sev_common_class_init(ObjectClass *oc, const void *data)
> >                                     sev_common_set_kernel_hashes);
> >      object_class_property_set_description(oc, "kernel-hashes",
> >              "add kernel hashes to guest firmware for measured Linux boot");
> > +    object_class_property_add_bool(oc, "debug-swap",
> > +                                   sev_common_get_debug_swap,
> > +                                   sev_common_set_debug_swap);
> > +    object_class_property_set_description(oc, "debug-swap",
> > +            "enable virtualization of debug registers");
> >  }
> >  
> >  static void
> > diff --git a/qapi/qom.json b/qapi/qom.json
> > index 830cb2ffe781..df962d4a5215 100644
> > --- a/qapi/qom.json
> > +++ b/qapi/qom.json
> > @@ -1010,13 +1010,17 @@
> >  #     designated guest firmware page for measured boot with -kernel
> >  #     (default: false) (since 6.2)
> >  #
> > +# @debug-swap: enable virtualization of debug registers
> > +#     (default: false) (since 10.2)
> > +#
> 
> According to the commit message, setting @default-swap works only for
> SEV-ES and SEV-SNP guests, i.e. it fails for plain SEV guests.  Should
> we document this here?

Sure, we can add that.


Thanks,
Naveen


