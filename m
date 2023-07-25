Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27EEC761E04
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 18:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbjGYQFw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 12:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbjGYQFv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 12:05:51 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051C1211E
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 09:05:47 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-55c475c6da6so2606020a12.2
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 09:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690301146; x=1690905946;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kjapE+rCKmy4P5VPPxVo+ODABt8kwoerpZYMWCIKvUE=;
        b=LwsxLZ6AuVYhmtLCQOubxgsSk2SGUoAfIe0hne7HeGjZV0XGh64QIkV2zlXzbAnLeG
         kT3m8OHeyQw9nrZ1taSu34Tv5G12H9xzbEEIA3CgHW/JXKh7h4Wu1sIEnODxWRkuraGO
         1LyLFhJyUUIY0BuwYyRoMQ1YSyw7HqVNd68xzOUIE0OEl0CyZ3Fn6yKRY363qzKFgXAi
         LfGtgsQ/jm32boUoK3P8HSJtRgdhL1KOXmwlWvMMgJXossJ9wbHkRKUgp2q0ig5l0Zq7
         xmSB/JJc7Da1ato/gj2rSnD24hB3uBp4wkp8S7/TR/gCn8xgTrdUM+RyJ9Z9uRGBE4dM
         47Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690301146; x=1690905946;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kjapE+rCKmy4P5VPPxVo+ODABt8kwoerpZYMWCIKvUE=;
        b=lWPxeb2NPnD431sFvfcnZhcvzPIozt6WJBEBizTAVpjimvXHD6fZ62hYJ4AGRiAfYS
         VEzCESweJKemjkE6Y61OV2gowQbvUrxOJxp17BSnld/ibQL3geTujdtF0Hep07VjFwG3
         3vlw4Vce+vgoTVxcEo79Y/iofvLiHXnKhmnYu3TLsDUHxWcTDgAn7cE5Bsj06NRaVjWc
         628ZlhyC7DHiDQcRe/9Wsk9oNrnTXbWwjnP6j8ii/JVMjwR2qqil4Cv5qfcY37bLWNBb
         llrXagF29Z1pMpI79sFTHjZ9/6U3o11AEFyqaXMv8qjMx0H/bKpgrgFErbXLtOMV2kGq
         uq6g==
X-Gm-Message-State: ABy/qLad6r6GS+hDpIqrpXLWBliMuRFRI0EkoyvOi+TV/OGeMdHDUmW9
        aPicXl56SutCkZ67UoMOAPJjJKv5EiE=
X-Google-Smtp-Source: APBJJlHGaS5DZDQ6cJZl3UVRA7dtu3lyMT6BLjhuEPtr88IwuNDtXc+LBb78syThVbNsaXb6qjo4AYxA5zg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c409:b0:1b5:2871:cd1 with SMTP id
 k9-20020a170902c40900b001b528710cd1mr55353plk.0.1690301146436; Tue, 25 Jul
 2023 09:05:46 -0700 (PDT)
Date:   Tue, 25 Jul 2023 09:05:44 -0700
In-Reply-To: <6086d09d-f218-d962-18dc-7b1a0390f258@linux.intel.com>
Mime-Version: 1.0
References: <20230719144131.29052-1-binbin.wu@linux.intel.com>
 <20230719144131.29052-3-binbin.wu@linux.intel.com> <20230720235352.GH25699@ls.amr.corp.intel.com>
 <e84129b1-603b-a6c4-ade5-8cf529929675@linux.intel.com> <ZLqeUXerpNlri7Px@google.com>
 <6086d09d-f218-d962-18dc-7b1a0390f258@linux.intel.com>
Message-ID: <ZL/y2CKoJ/bTOR0M@google.com>
Subject: Re: [PATCH v10 2/9] KVM: x86: Add & use kvm_vcpu_is_legal_cr3() to
 check CR3's legality
From:   Sean Christopherson <seanjc@google.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        chao.gao@intel.com, kai.huang@intel.com, David.Laight@aculab.com,
        robert.hu@linux.intel.com, guang.zeng@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 24, 2023, Binbin Wu wrote:
> 
> 
> On 7/21/2023 11:03 PM, Sean Christopherson wrote:
> > On Fri, Jul 21, 2023, Binbin Wu wrote:
> > > 
> > > On 7/21/2023 7:53 AM, Isaku Yamahata wrote:
> > > > On Wed, Jul 19, 2023 at 10:41:24PM +0800,
> > > > Binbin Wu <binbin.wu@linux.intel.com> wrote:
> > > > 
> > > > > Add and use kvm_vcpu_is_legal_cr3() to check CR3's legality to provide
> > > > > a clear distinction b/t CR3 and GPA checks. So that kvm_vcpu_is_legal_cr3()
> > > > > can be adjusted according to new feature(s).
> > > > > 
> > > > > No functional change intended.
> > > > > 
> > > > > Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> > > > > ---
> > > > >    arch/x86/kvm/cpuid.h      | 5 +++++
> > > > >    arch/x86/kvm/svm/nested.c | 4 ++--
> > > > >    arch/x86/kvm/vmx/nested.c | 4 ++--
> > > > >    arch/x86/kvm/x86.c        | 4 ++--
> > > > >    4 files changed, 11 insertions(+), 6 deletions(-)
> > > > > 
> > > > > diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> > > > > index f61a2106ba90..8b26d946f3e3 100644
> > > > > --- a/arch/x86/kvm/cpuid.h
> > > > > +++ b/arch/x86/kvm/cpuid.h
> > > > > @@ -283,4 +283,9 @@ static __always_inline bool guest_can_use(struct kvm_vcpu *vcpu,
> > > > >    	return vcpu->arch.governed_features.enabled & kvm_governed_feature_bit(x86_feature);
> > > > >    }
> > > > > +static inline bool kvm_vcpu_is_legal_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
> > > > > +{
> > > > > +	return kvm_vcpu_is_legal_gpa(vcpu, cr3);
> > > > > +}
> > > > > +
> > > > The remaining user of kvm_vcpu_is_illegal_gpa() is one left.  Can we remove it
> > > > by replacing !kvm_vcpu_is_legal_gpa()?
> > > There are still two callsites of kvm_vcpu_is_illegal_gpa() left (basing on
> > > Linux 6.5-rc2), in handle_ept_violation() and nested_vmx_check_eptp().
> > > But they could be replaced by !kvm_vcpu_is_legal_gpa() and then remove
> > > kvm_vcpu_is_illegal_gpa().
> > > I am neutral to this.
> > I'm largely neutral on this as well, though I do like the idea of having only
> > "legal" APIs.  I think it makes sense to throw together a patch, we can always
> > ignore the patch if end we up deciding to keep kvm_vcpu_is_illegal_gpa().
> OK. Thanks for the advice.
> Should I send a seperate patch or add a patch to remove
> kvm_vcpu_is_illegal_gpa() in next version?

Add a patch in the next version, eliminating kvm_vcpu_is_illegal_gpa() without
the context of this series probably isn't worth the churn.
