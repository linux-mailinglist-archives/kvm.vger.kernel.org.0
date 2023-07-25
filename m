Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4A776211E
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 20:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbjGYSPO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 14:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbjGYSPM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 14:15:12 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1A110EF
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 11:15:11 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d05e334f436so5631815276.2
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 11:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690308910; x=1690913710;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pAZmELeq2ZhkyDgChb+RthHmv+q1lpfrw6foSOn/8ZY=;
        b=rldnnWH7w/HourUe/RcpHwlb69EnTTdPK/pDOa8OZfeDJ35pA6WgI3FFvgz7Wjl7x6
         98M310YVHhmfsVHJyCvBvyNc55l3cU8cn0/4gGT0AfkBYx9Uwj+M/TkJ/eJKoiYntE36
         Xj8BoGO0yZu8Q5LvMFeprTGpzBWUO4Lzfx2Wb0cSQj5fYvwYd/+vhSArQPxwdvsH9q6W
         PPWnYjEsWI2CzoXQWQC16CG4zFTZm4P/pBUKSRJOKCAhm8mqCiQIm7W8/bXxHKYWj9z4
         UjcWrpsMKdV9ZNjmW86cd2ztYi8qdoEAwtj4AbVpQokSZjJk5JZDjGBobeDfhd0+Kd1K
         4UVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690308910; x=1690913710;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pAZmELeq2ZhkyDgChb+RthHmv+q1lpfrw6foSOn/8ZY=;
        b=fphlnaC1xGDWGZzD7UrFwy9qY6rTSsLkoSNjXKVNteFNOXoxx5+DKlknGu05lZJ1Ut
         r5f9DXNmAQAeE7RJqIGJVGBDvUBsZMjil6c9Bx5vo5qWvWUi9zOf4gOIPwCdSmTxXROt
         +DkEQIxnMNzEU5Vkj3wWJ46wld1qr44exMWUOyZZbvEy8lSea4gPF5s4T9KMk46yA+rV
         7NW/KrurLSdXoF2FY39eqkkwUyZyxW/VbJCoAJcQSxKgLnyh8PyNZyOZxc/fMOdsz8F5
         d1+VM/ufL90iaHkInQHkPeKi8b6RwCyIXQCoJFE7aWT69gnqRDSK7HC7sq1d5+R3NEs7
         CVCA==
X-Gm-Message-State: ABy/qLaF7EeLLdarXtC+JzxXmhee3A87W7YUaRoOMVkuEVdAnHOoGIOq
        PNQ7yPXE8OniGAuGPCqxFeWZwG0PTMs=
X-Google-Smtp-Source: APBJJlFXrTcGU/9dXVrt8CbSBDCqA64SFKTYxJj7G92zNc7tdKvKFYWLRqCNhBTcCsblpCzONauc19v8DpM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:8d83:0:b0:d15:d6da:7e97 with SMTP id
 o3-20020a258d83000000b00d15d6da7e97mr24208ybl.3.1690308910326; Tue, 25 Jul
 2023 11:15:10 -0700 (PDT)
Date:   Tue, 25 Jul 2023 11:15:08 -0700
In-Reply-To: <c90d244a6b372322028d0e5b42d60fb1a23476da.camel@intel.com>
Mime-Version: 1.0
References: <20230721201859.2307736-1-seanjc@google.com> <20230721201859.2307736-20-seanjc@google.com>
 <c90d244a6b372322028d0e5b42d60fb1a23476da.camel@intel.com>
Message-ID: <ZMARLNcPwovmOZvg@google.com>
Subject: Re: [PATCH v4 19/19] KVM: VMX: Skip VMCLEAR logic during emergency
 reboots if CR4.VMXE=0
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chao Gao <chao.gao@intel.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 25, 2023, Kai Huang wrote:
> On Fri, 2023-07-21 at 13:18 -0700, Sean Christopherson wrote:
> > Bail from vmx_emergency_disable() without processing the list of loaded
> > VMCSes if CR4.VMXE=0, i.e. if the CPU can't be post-VMXON.  It should be
> > impossible for the list to have entries if VMX is already disabled, and
> > even if that invariant doesn't hold, VMCLEAR will #UD anyways, i.e.
> > processing the list is pointless even if it somehow isn't empty.
> > 
> > Assuming no existing KVM bugs, this should be a glorified nop.  The
> > primary motivation for the change is to avoid having code that looks like
> > it does VMCLEAR, but then skips VMXON, which is nonsensical.
> > 
> > Suggested-by: Kai Huang <kai.huang@intel.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 12 ++++++++++--
> >  1 file changed, 10 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 5d21931842a5..0ef5ede9cb7c 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -773,12 +773,20 @@ static void vmx_emergency_disable(void)
> >  
> >  	kvm_rebooting = true;
> >  
> > +	/*
> > +	 * Note, CR4.VMXE can be _cleared_ in NMI context, but it can only be
> > +	 * set in task context.  If this races with VMX is disabled by an NMI,
> > +	 * VMCLEAR and VMXOFF may #UD, but KVM will eat those faults due to
> > +	 * kvm_rebooting set.
> > +	 */
> 
> I am not quite following this comment.  IIUC this code path is only called from
> NMI context in case of emergency VMX disable.

The CPU that initiates the emergency reboot can invoke the callback from process
context, only responding CPUs are guaranteed to be handled via NMI shootdown.
E.g. `reboot -f` will reach this point synchronously.

> How can it race with "VMX is disabled by an NMI"?

Somewhat theoretically, a different CPU could panic() and do a shootdown of the
CPU that is handling `reboot -f`.
