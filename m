Return-Path: <kvm+bounces-68835-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cJG1FoyDcWk1IAAAu9opvQ
	(envelope-from <kvm+bounces-68835-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 02:55:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id F04A260942
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 02:55:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 09D5A7CA766
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 01:53:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DBBC36D4E2;
	Thu, 22 Jan 2026 01:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UC+pUItn"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5F036A008
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 01:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769046696; cv=none; b=aVPbqdzQGCXScSFZqazbx7L3wvkGpUgwdTgnDRl0xOeV3ktSS2t43p5qeV0YIa7QfO0GKljiKP4Bd3nIl2p48XA7hv+8rxI89jWUWBJlrjNMhlfsOaT6gvYcBkw3GrFyBXKcObFZnpyco0NZqc/2kzMS736Rkd80WIDYYz6VH8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769046696; c=relaxed/simple;
	bh=kru4MLF62w3A+jdnvhWCmKwiBmdez/Kn8rXJtr1NvEY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fznFzGS+sUgEk9Z5zZbBiozrILw3tei/StpL8rrKtaFr1zunfWfo8rsBpASU1yYCPv91F1+yL7+YkkmVan8Aqr8pZeUwZUmeYCWiW0Q87rL9+nuSkPYY1EHAPv9Eydj/hkHchhGjyvRoHlzKqq32Zb9PrBSdos6G2i1GXVeVFBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UC+pUItn; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 22 Jan 2026 01:51:10 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769046681;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zzHkBDVPkCJozUwpc417duPUsq6mwpGzLG69NvYJ6Kc=;
	b=UC+pUItn5c8c0VW+VDOjFqORxc2T11mc9y82PSyw80VJlyzzGoqhfuvf6sKmujDFZPXzGJ
	6kThlhpaoy5khvE3ofjIxxQdOE84o5l6Wk21mqYfrsVCbVvmm76pJqv5Yrws/hcqK/dg/x
	1+R2J5CG1ZpETh2yK+5+cH6QTUlCFVw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 6/8] KVM: x86: nSVM: Save/restore gPAT with
 KVM_{GET,SET}_NESTED_STATE
Message-ID: <wjetkt5qasq2reylgmu6hsrifkoh7drmu5655xoqyjowjlncri@j6aipt5y4mpb>
References: <20260115232154.3021475-1-jmattson@google.com>
 <20260115232154.3021475-7-jmattson@google.com>
 <CALMp9eRGSoQGu9R7CYqgRERY=x-_=59bHvEab-t519u8n6nmWA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALMp9eRGSoQGu9R7CYqgRERY=x-_=59bHvEab-t519u8n6nmWA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68835-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	DMARC_POLICY_ALLOW(0.00)[linux.dev,none];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns,linux.dev:dkim]
X-Rspamd-Queue-Id: F04A260942
X-Rspamd-Action: no action

On Thu, Jan 15, 2026 at 08:23:26PM -0800, Jim Mattson wrote:
> On Thu, Jan 15, 2026 at 3:22 PM Jim Mattson <jmattson@google.com> wrote:
> >
> > Add a 'flags' field to the SVM nested state header, and use bit 0 of the
> > flags to indicate that gPAT is stored in the nested state.
> >
> > If in guest mode with NPT enabled, store the current vmcb->save.g_pat value
> > into the vmcb save area of the nested state, and set the flag.
> >
> > Note that most of the vmcb save area in the nested state is populated with
> > dead (and potentially already clobbered) vmcb01 state. A few fields hold L1
> > state to be restored at VMEXIT. Previously, the g_pat field was in the
> > former category.
> >
> > Also note that struct kvm_svm_nested_state_hdr is included in a union
> > padded to 120 bytes, so there is room to add the flags field without
> > changing any offsets.
> >
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > ---
> >  arch/x86/include/uapi/asm/kvm.h |  3 +++
> >  arch/x86/kvm/svm/nested.c       | 13 ++++++++++++-
> >  2 files changed, 15 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> > index 7ceff6583652..80157b9597db 100644
> > --- a/arch/x86/include/uapi/asm/kvm.h
> > +++ b/arch/x86/include/uapi/asm/kvm.h
> > @@ -495,6 +495,8 @@ struct kvm_sync_regs {
> >
> >  #define KVM_STATE_VMX_PREEMPTION_TIMER_DEADLINE        0x00000001
> >
> > +#define KVM_STATE_SVM_VALID_GPAT       BIT(0)
> > +
> >  /* vendor-independent attributes for system fd (group 0) */
> >  #define KVM_X86_GRP_SYSTEM             0
> >  #  define KVM_X86_XCOMP_GUEST_SUPP     0
> > @@ -530,6 +532,7 @@ struct kvm_svm_nested_state_data {
> >
> >  struct kvm_svm_nested_state_hdr {
> >         __u64 vmcb_pa;
> > +       __u32 flags;
> >  };
> >
> >  /* for KVM_CAP_NESTED_STATE */
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index 5fb31faf2b46..c50fb7172672 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -1789,6 +1789,8 @@ static int svm_get_nested_state(struct kvm_vcpu *vcpu,
> >         /* First fill in the header and copy it out.  */
> >         if (is_guest_mode(vcpu)) {
> >                 kvm_state.hdr.svm.vmcb_pa = svm->nested.vmcb12_gpa;
> > +               if (nested_npt_enabled(svm))
> > +                       kvm_state.hdr.svm.flags |= KVM_STATE_SVM_VALID_GPAT;
> >                 kvm_state.size += KVM_STATE_NESTED_SVM_VMCB_SIZE;
> >                 kvm_state.flags |= KVM_STATE_NESTED_GUEST_MODE;
> >
> > @@ -1823,6 +1825,11 @@ static int svm_get_nested_state(struct kvm_vcpu *vcpu,
> >         if (r)
> >                 return -EFAULT;
> >
> > +       /*
> > +        * vmcb01->save.g_pat is dead now, so it is safe to overwrite it with
> > +        * vmcb02->save.g_pat, whether or not nested NPT is enabled.
> > +        */
> > +       svm->vmcb01.ptr->save.g_pat = svm->vmcb->save.g_pat;
> 
> Is this too disgusting? Should I extend the payload by 8 bytes
> instead? It seems like such a waste, since most of the save area is
> dead/unused. Maybe I could define a new sparse save state structure,
> with the ~200 bytes that are currently used, surrounded by padding for
> the other 500+ bytes. Then, I could just grab 8 bytes of the padding,
> and it wouldn't seem quite as hacky .

I think this would be cleaner than reusing the vmcb01 field.

One question though, if we decide to start doing save/restore for one of
the save area fields in vmcb01 in the currently unused 500+ bytes (i.e.
the padding), would this be a problem? IIUC the 8 bytes we'll use for
gPAT will overlap with an existing unused field.

> 
> >         if (copy_to_user(&user_vmcb->save, &svm->vmcb01.ptr->save,
> >                          sizeof(user_vmcb->save)))
> >                 return -EFAULT;
> > @@ -1904,7 +1911,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
> >                 goto out_free;
> >
> >         /*
> > -        * Validate host state saved from before VMRUN (see
> > +        * Validate host state saved from before VMRUN and gPAT (see
> >          * nested_svm_check_permissions).
> >          */
> >         __nested_copy_vmcb_save_to_cache(&save_cached, save);
> > @@ -1951,6 +1958,10 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
> >         if (ret)
> >                 goto out_free;
> >
> > +       if (is_guest_mode(vcpu) && nested_npt_enabled(svm) &&
> > +           (kvm_state.hdr.svm.flags & KVM_STATE_SVM_VALID_GPAT))
> > +               svm->vmcb->save.g_pat = save_cached.g_pat;
> > +
> >         svm->nested.force_msr_bitmap_recalc = true;
> >
> >         kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
> > --
> > 2.52.0.457.g6b5491de43-goog
> >

