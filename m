Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D844F7AF40E
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 21:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbjIZTWm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 15:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjIZTWl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 15:22:41 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 416BB10A
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 12:22:34 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a1f12cf1ddso8708687b3.0
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 12:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695756153; x=1696360953; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vlKoIrDweWxepV1EInk7/WGP/2n5ZerlI/TlhSza/pw=;
        b=bi1ObI4pQiuzLQKMOeP+N1WOC+4ueySr4Eo/PVJZzjDvWwj6zqEReYNviXuYR52DTg
         qIHZyOMZFv0Jab0TIi+LXE6HSNlfXUcC+0dng+OrVNOH0CFOUfItLZLb0/Mxu2+u+L+7
         d4j4BlFa0sxenGmw6APVzA+M8AH3Hw7NpErFF6ZB26xbZMCqY6MRGUrTytFByVtYe4TV
         ZDsu2Y+3jcFDRtcpS18BNfX2kHpPFW74u/hoCl9e69DErUn8ibCLjQzufexBl2kp2G1u
         ObuHfJvtYeh160P/JfgLtGWHAJrOP+YCr+q0ypZXRJ3jVjIbgeABnJRl826308RSAlp8
         yRrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695756153; x=1696360953;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vlKoIrDweWxepV1EInk7/WGP/2n5ZerlI/TlhSza/pw=;
        b=hIMm1PKbK5ttC+iPZOJ6jl7CYBp0YNFtOEWIFY5N8XqKd0LwR1mPEoq/p9ZWCnAPUd
         fSe4uygaNfuytr/6ilPcVmkfkvF4lL0CXPhuA5IQ2af1BsY+TjbCeBkPXizz+cjzxnCG
         v8On38uOg3vCXJ5qMB2BDBC2UOSUZJxEdFoDLlkRrr+b+tx98W8B8Jdy7ElSAZAISPM3
         vI4egOBoHLlAgA3NkmIDMGgTeVlPWeVYr4GobfGAtjqp7nnKQUaJkTGKOzKZ5KjuyOJd
         lLFVzcVc4rz3g7I+dKbgvSdsIbk+QhxE/HeIZCRTq8LS5zV0GUdRpVXKPVqEzQnhJB/w
         UPDQ==
X-Gm-Message-State: AOJu0YzEiEcgqbfLShnkxpyA6Zsw2KhfMccgoqtXapIFgv6514DrPPoG
        N1EMy0+UanYJUosbYYej4sWuoQgwJBU=
X-Google-Smtp-Source: AGHT+IFOzYrsL6ZSkgSz+XAomqLjzsvojvJxTmXzGz3R0HGj2nO5a5oSQZAwXSnLto7FWADO+RO0OOZacPc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:732:b0:59b:b0b1:d75a with SMTP id
 bt18-20020a05690c073200b0059bb0b1d75amr66004ywb.4.1695756153418; Tue, 26 Sep
 2023 12:22:33 -0700 (PDT)
Date:   Tue, 26 Sep 2023 12:22:31 -0700
In-Reply-To: <ZRMHY83W/VPjYyhy@google.com>
Mime-Version: 1.0
References: <20230914010003.358162-1-tstachecki@bloomberg.net>
 <ZQKzKkDEsY1n9dB1@redhat.com> <ZQLOVjLtFnGESG0S@luigi.stachecki.net>
 <93592292-ab7e-71ac-dd72-74cc76e97c74@oracle.com> <ZQOsQjsa4bEfB28H@luigi.stachecki.net>
 <ZQQKoIEgFki0KzxB@redhat.com> <ZQRNmsWcOM1xbNsZ@luigi.stachecki.net>
 <ZRH7F3SlHZEBf1I2@google.com> <ZRJJtWC4ch0RhY/Y@luigi.stachecki.net> <ZRMHY83W/VPjYyhy@google.com>
Message-ID: <ZRMvd7ZKT6PXDLeK@google.com>
Subject: Re: [PATCH] x86/kvm: Account for fpstate->user_xfeatures changes
From:   Sean Christopherson <seanjc@google.com>
To:     Tyler Stachecki <stachecki.tyler@gmail.com>
Cc:     Leonardo Bras <leobras@redhat.com>,
        Dongli Zhang <dongli.zhang@oracle.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, dgilbert@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, dave.hansen@linux.intel.com, bp@alien8.de,
        Tyler Stachecki <tstachecki@bloomberg.net>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 26, 2023, Sean Christopherson wrote:
> On Mon, Sep 25, 2023, Tyler Stachecki wrote:
> > > @@ -1059,7 +1060,8 @@ static void copy_feature(bool from_xstate, struct membuf *to, void *xstate,
> > >   * It supports partial copy but @to.pos always starts from zero.
> > >   */
> > >  void __copy_xstate_to_uabi_buf(struct membuf to, struct fpstate *fpstate,
> > > -			       u32 pkru_val, enum xstate_copy_mode copy_mode)
> > > +			       u64 xfeatures, u32 pkru_val,
> > > +			       enum xstate_copy_mode copy_mode)
> > >  {
> > >  	const unsigned int off_mxcsr = offsetof(struct fxregs_state, mxcsr);
> > >  	struct xregs_state *xinit = &init_fpstate.regs.xsave;
> > > @@ -1083,7 +1085,7 @@ void __copy_xstate_to_uabi_buf(struct membuf to, struct fpstate *fpstate,
> > >  		break;
> > >  
> > >  	case XSTATE_COPY_XSAVE:
> > > -		header.xfeatures &= fpstate->user_xfeatures;
> > > +		header.xfeatures &= fpstate->user_xfeatures & xfeatures;
> > >  		break;
> > 
> > This changes the consideration of the xfeatures copied *into* the uabi buffer
> > with respect to the guest xfeatures IIUC (approx guest XCR0, less FP/SSE only).
> > 
> > IOW: we are still trimming guest xfeatures, just at the source...?
> 
> KVM *must* "trim" features when servicing KVM_GET_SAVE{2}, because that's been KVM's
> ABI for a very long time, and userspace absolutely relies on that functionality
> to ensure that a VM can be migrated within a pool of heterogenous systems so long
> as the features that are *exposed* to the guest are supported on all platforms.
> 
> Before the big FPU rework, KVM manually filled xregs_state and directly "trimmed"
> based on the guest supported XCR0 (see fill_xsave() below).
> 
> The major difference between my proposed patch and the current code is that KVM
> trims *only* at KVM_GET_XSAVE{2}, which in addition to being KVM's historical ABI,
> (see load_xsave() below), ensures that the *destination* can load state irrespective
> of the possibly-not-yet-defined guest CPUID model.

...

> > That being said: the patch that I gave siliently allows unacceptable things to
> > be accepted at the destination, whereas this maintains status-quo and signals
> > an error when the destination cannot wholly process the uabi buffer (i.e.,
> > asked to restore more state than the destination processor has present).
> > 
> > The downside of my approach is above -- the flip side, though is that this
> > approach requires a patch to be applied on the source. However, we cannot
> > apply a patch at the source until it is evacuated of VMs -- chicken and egg
> > problem...
> > 
> > Unless I am grossly misunderstanding things here -- forgive me... :-)
> 
> I suspect you're overlooking the impact on the destination.  Trimming features
> only when saving XSAVE state into the userspace buffer means that the destination
> will play nice with the "bad" snapshot.  It won't help setups where a VM is being
> migrated from a host with more XSAVE features to a host with fewer XSAVE features,
> but I don't see a sane way to retroactively fix that situation.  And IIUC, that's
> not the situation you're in (unless the Skylake host vs. Broadwell guests is only
> the test environment).

One clarification: this comment from Tyler's proposed patch is somewhat misleading.
 
I do think KVM should filter state only at KVM_GET_XSAVE, because otherwise any
off-by-default feature will have different behavior than on-by-default features,
e.g. restoring AMX state requires KVM_SET_CPUID, whereas every other features
depends only on host capabilities.


+       /*
+        * In previous kernels, kvm_arch_vcpu_create() set the guest's fpstate
+        * based on what the host CPU supported. Recent kernels changed this
+        * and only accept ustate containing xfeatures that the guest CPU is
+        * capable of supporting.
+        */
+       ustate->xsave.header.xfeatures &= user_xfeatures;


It's only the "realloc" path used when granting access to an off-by-default feature,
i.e. AMX, that skips initialize user_xfeatures.   __fpstate_reset() does initialize
user_xfeatures to the default set for guest state, i.e. the problem is not in
kvm_arch_vcpu_create().

The problem is specifically that KVM rejects KVM_SET_XSAVE if userspace limits
guest supported xfeatures via KVM_SET_CPUID.  In a perfect world, that would be
desirable, e.g. KVM's ABI when loading MSRs from userspace is to (mostly) honor
guest CPUID, but again this is a clear breakage of userspace.  I.e. QEMU does
KVM_SET_CPUID2, and *then* KVM_SET_XSAVE, which fails.  If QEMU reversed those,
KVM_SET_XSAVE would actually succeed.
 
There's another related oddity that will be fixed by my approach, assuming the realloc
change is also reverted (I missed that in my pasted patch).  Userspace *must* do
KVM_SET_CPUID{2} in order to load off-by-default state, whereas there is no such
requirement for on-by-default state.
