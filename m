Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D11C6C6DED
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 17:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbjCWQli (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 12:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjCWQlO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 12:41:14 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1E638B4A
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 09:39:11 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54352648c1eso223399487b3.9
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 09:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679589543;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HMDeQk5W8bWVLr99LDZ65KEOIjRuVjx2NV9NCNVytV0=;
        b=dKIqE29TCIqkXyZ2R0Ym+XZjJzyR6FoGiLUvXfVBgS90+qYgIWwCd/D0T6CiOwY17l
         1zaopVitBBJBfJW1TaqlY4J1s8hwi11GPKMKnyUMHct9V3j6c61SgUEiG2AoX2EmGJOQ
         5HKWewSRRu5F1Yhs962cVQbrTW71d5OgcAB6dmH1kq+2dZslHvBe5c8Vp0q9HbsRFZTN
         XsXpdrtRyfPfbBd9rqPsRJEdpCmbcq2H04nJDKfRUG2MGSl8ekCHmhQ1uV7J5W8qtOIs
         SZK9hwIEo77SRpVDaZAWW/M+tDGbARJb+1BhTiWDjjR1lNidDCEIKNSiQzCdV6+QVu4n
         g5mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679589543;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HMDeQk5W8bWVLr99LDZ65KEOIjRuVjx2NV9NCNVytV0=;
        b=UyS0mWAk4BvKI5fgx8GxN8+st5cWgWQ53PCQQzvkAId6K/5pAaYGHVVmVvUlDJIg6T
         LKelFGZNx+/Szq/VcDnAo84QBwKFvCdvtQVMGwlRUKCWGFG89TSdOubvkgVWdc4L/DUE
         /r4JIu+kK5L9E2NPTufk9GzeaMxNroMMkoCNcoSMQQMHKg0MNuq+5D/Wh5b7AG7PxaPb
         7dCVg2Z8Kf/3QzH2xoN8flTmO/vGXAJ1DDYPZexu+VejdySMN9zkgpSSQBb6VzaGIhSC
         2rVTWRiplWs3KdAHyRJJ745XXYIifYCVADZolUS8DzCTZWoFgpOlJMbNz0FRJfyGL60p
         A/fQ==
X-Gm-Message-State: AAQBX9c09+J6jI/JHyXRHg/5Kgm/Tniu13SYb5+yb5lxOsj3PBS/6Qku
        xf7M0znQ9uBDqxgC+F877W0pJkRwKJY=
X-Google-Smtp-Source: AKy350YhFvlX0ioOFgsAp70+MxQCivy/XMWeY+Go2PaiF2Ynhk6lYUQmwlsbYihK9T3FrUMTnI73XW5E/fw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:a782:0:b0:541:a17f:c77d with SMTP id
 e124-20020a81a782000000b00541a17fc77dmr2136221ywh.10.1679589543734; Thu, 23
 Mar 2023 09:39:03 -0700 (PDT)
Date:   Thu, 23 Mar 2023 09:39:02 -0700
In-Reply-To: <3b3a9ebc-b02e-a365-7f68-3da9189d062a@amd.com>
Mime-Version: 1.0
References: <20230120031047.628097-1-aik@amd.com> <20230120031047.628097-3-aik@amd.com>
 <Y9nL8iqhiL5+ALa2@google.com> <3b3a9ebc-b02e-a365-7f68-3da9189d062a@amd.com>
Message-ID: <ZByAptUXE+VMpn2x@google.com>
Subject: Re: [PATCH kernel v3 2/3] KVM: SEV: Enable data breakpoints in SEV-ES
From:   Sean Christopherson <seanjc@google.com>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Yury Norov <yury.norov@gmail.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sandipan Das <sandipan.das@amd.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Kees Cook <keescook@chromium.org>,
        Juergen Gross <jgross@suse.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 03, 2023, Alexey Kardashevskiy wrote:
> > Follow-up question: does KVM _have_ to wait until KVM_SEV_LAUNCH_UPDATE_VMSA to
> > set the flag?
> 
> Nope. Will repost soon as a reply to this mail.

Please, please do not post new versions In-Reply-To the previous version, and
especially not In-Reply-To a random mail buried deep in the thread.  b4, which
is imperfect but makes my life sooo much easier, gets confused by all the threading
and partial rerolls.  The next version also buries _this_ reply, which is partly
why I haven't responded until now.  I simply missed this the below questions because
I saw v4 and assumed all my feedback was addressed, i.e. that I could handle this
in the context of 6.4 and not earlier.

Continuing on that topic, please do not post a new version until open questions
from the previous version are resolved.  Posting a new version when there are
unresolved questions might feel like it helps things move faster, but more often
than not it has the comlete opposite effect.

> > > +/* enable/disable SEV-ES DebugSwap support */
> > > +static bool sev_es_debug_swap_enabled = true;
> > > +module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0644);
> > 
> > Module param needs 0444 permissions, i.e. shouldn't be writable after KVM is
> > loaded.  Though I don't know that providing a module param is warranted in this
> > case.
> > KVM provides module params for SEV and SEV-ES because there are legitimate
> > reasons to turn them off, but at a glance, I don't see why we'd want that for this
> > feature.
> 
> 
> /me confused. You suggested this in the first place for (I think) for the
> case if the feature is found to be broken later on so admins can disable it.

Hrm, so I did.  Right, IIUC, this has guest visible effects, i.e. guest can
read/write DRs, and so the admin might want the ability to disable the feature.

Speaking of past me, no one answered my question about how this will interact
with SNP, where the VM can maniuplate the VMSA.

  : > @@ -604,6 +607,9 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
  : >       save->xss  = svm->vcpu.arch.ia32_xss;
  : >       save->dr6  = svm->vcpu.arch.dr6;
  : > 
  : > +     if (sev->debug_swap)
  : > +             save->sev_features |= SVM_SEV_FEAT_DEBUG_SWAP;
  : 
  : Resurrecting my objection to "AP Creation NAE event"[*], what happens if a hypervisor
  : supports GHCB_HV_FT_SNP_AP_CREATION but not DebugSwap?  IIUC, a guest can corrupt
  : host DRs by enabling DebugSwap in the VMSA of an AP vCPU, e.g. the CPU will load
  : zeros on VM-Exit if the host hasn't stuffed the host save area fields.
  : 
  : KVM can obviously just make sure to save its DRs if hardware supports DebugSwap,
  : but what if DebugSwap is buggy and needs to be disabled?  And what about the next
  : feature that can apparently be enabled by the guest?
  : 
  : [*] https://lore.kernel.org/all/YWnbfCet84Vup6q9@google.com

> And I was using it to verify "x86/debug: Fix stack recursion caused by DR7
> accesses" which is convenient but it is a minor thing.

...

> > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > index 60c7c880266b..6c54a3c9d442 100644
> > > --- a/arch/x86/kvm/svm/svm.c
> > > +++ b/arch/x86/kvm/svm/svm.c
> > > @@ -1190,7 +1190,8 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
> > >   	set_exception_intercept(svm, UD_VECTOR);
> > >   	set_exception_intercept(svm, MC_VECTOR);
> > >   	set_exception_intercept(svm, AC_VECTOR);
> > > -	set_exception_intercept(svm, DB_VECTOR);
> > > +	if (!sev_es_is_debug_swap_enabled())
> > > +		set_exception_intercept(svm, DB_VECTOR);
> > 
> > This is wrong.  KVM needs to intercept #DBs when debugging non-SEV-ES VMs.
> 
> Sorry, not following. The #DB intercept for non-SEV-ES is enabled here.

The helper in this version (v3) just queries whether or not the feature is enabled,
it doesn't differentiate between SEV-ES and other VM types.  I.e. loading KVM with
SEV-ES and DebugSwap enabled would break non-SEV-ES VMs running on the same host.

 +bool sev_es_is_debug_swap_enabled(void)
 +{
 +     return sev_es_debug_swap_enabled;
 +}

Looks like this was fixed in v4.

> > This _could_ be tied to X86_FEATURE_NO_NESTED_DATA_BP, but the KVM would need to
> > toggle the intercept depending on whether or not userspace wants to debug the
> > guest.
> > 
> > Similar to the DR7 interception, can this check sev_features directly?
