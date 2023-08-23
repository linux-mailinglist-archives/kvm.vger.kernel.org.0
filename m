Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 855F9786127
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 22:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233504AbjHWUDz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 16:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbjHWUDh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 16:03:37 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A902710CB
        for <kvm@vger.kernel.org>; Wed, 23 Aug 2023 13:03:35 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-58c9d29588aso76921107b3.0
        for <kvm@vger.kernel.org>; Wed, 23 Aug 2023 13:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692821015; x=1693425815;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=th8e6TC9xPZYrxbPJ5js0VMFWDqZ8UUtFj8+USRPgoI=;
        b=KCBjUZIREew2qLlMaVEPsMoTNz7fqXclZ0+diA9i2OdkxNNfuM5G0hzFNgFvUtLbco
         OflvTxoEHiAnGJ+8nt6pRXOJyv2QXaM2Ao39UFXLArgXoPRuqGko/p3213UpIgHN+4Qi
         bd26EeMwGRJxvNiyYiNy9aTsiIo44trKPfVqD5LsJ1xwwbxhvL3x47bTBVxXJis40Rb6
         5cn2Qkp4vA0tPwGjWaEnSMaznVCI8voqljc78Xy/zfO26AzWDmc7EHDad5Wrg/CcSHen
         rh/0eRVs9EqByM1pg/tvksBqIMs7t9jqVs1u+k/YHltNV/rPi0rTh+Up5dReBa+ndHXX
         973w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692821015; x=1693425815;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=th8e6TC9xPZYrxbPJ5js0VMFWDqZ8UUtFj8+USRPgoI=;
        b=V+oXk4QoveI2bLPHFNX5pJMtkvFrNt953dNgHXa7MxrdNjH6ZKZCDasWKo9C/q3agX
         CF9lrbOjTyIHgntHiARRnOLbzQjyLdD5yHuuZRc9UOrdIPodU/wD/PqA7Kgs+5XtgdmF
         XbvVh28AQOnHhFTZ0eqPYZNK/OttpXh8tR9dr1Li4XuknYaNR6P7gmf51qJ8/bZ89EnE
         Z3igx7sDZ3zmnoGF8nMLW5qmYCztfTRJEipG3NT75HWc3Vf1IZKNDhFTXiZNhkMXlK/N
         HPAJpMq7S76gCACB/llupyYYjgdzcM/r+KEf2G55fVJMruQDCkOt28L5GP+uoZp3lGGD
         PMvw==
X-Gm-Message-State: AOJu0YyMHqnQRdz+nErbGyZ2oKvj+ETvLYLNNZGaoM6VpzqrRHwHcmQT
        +a/Y1nsLIvhILnz9u0brxE8PlWfT8K0=
X-Google-Smtp-Source: AGHT+IE9EnnUWhfDP3f20K5tnvhxXMR1COyQM+6+OK6NQluLLFrs1u7AFy7wyWl468re/JPl8d2ipvCLrFY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:12c6:b0:d77:bcce:eb11 with SMTP id
 j6-20020a05690212c600b00d77bcceeb11mr87510ybu.10.1692821014935; Wed, 23 Aug
 2023 13:03:34 -0700 (PDT)
Date:   Wed, 23 Aug 2023 13:03:33 -0700
In-Reply-To: <d183c3f2-d94d-5f22-184d-eab80f9d0fe8@amd.com>
Mime-Version: 1.0
References: <20230810234919.145474-1-seanjc@google.com> <bf3af7eb-f4ce-b733-08d4-6ab7f106d6e6@amd.com>
 <ZOTQ6izCUfrBh2oj@google.com> <d183c3f2-d94d-5f22-184d-eab80f9d0fe8@amd.com>
Message-ID: <ZOZmFe7MT7zwrf/c@google.com>
Subject: Re: [PATCH 0/2] KVM: SVM: Fix unexpected #UD on INT3 in SEV guests
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wu Zongyo <wuzongyo@mail.ustc.edu.cn>
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

On Wed, Aug 23, 2023, Tom Lendacky wrote:
> On 8/22/23 10:14, Sean Christopherson wrote:
> > On Tue, Aug 22, 2023, Tom Lendacky wrote:
> > > On 8/10/23 18:49, Sean Christopherson wrote:
> > > > Fix a bug where KVM injects a bogus #UD for SEV guests when trying to skip
> > > > an INT3 as part of re-injecting the associated #BP that got kinda sorta
> > > > intercepted due to a #NPF occuring while vectoring/delivering the #BP.
> > > > 
> > > > I haven't actually confirmed that patch 1 fixes the bug, as it's a
> > > > different change than what I originally proposed.  I'm 99% certain it will
> > > > work, but I definitely need verification that it fixes the problem
> > > > 
> > > > Patch 2 is a tangentially related cleanup to make NRIPS a requirement for
> > > > enabling SEV, e.g. so that we don't ever get "bug" reports of SEV guests
> > > > not working when NRIPS is disabled.
> > > > 
> > > > Sean Christopherson (2):
> > > >     KVM: SVM: Don't inject #UD if KVM attempts emulation of SEV guest w/o
> > > >       insn
> > > >     KVM: SVM: Require nrips support for SEV guests (and beyond)
> > > > 
> > > >    arch/x86/kvm/svm/sev.c |  2 +-
> > > >    arch/x86/kvm/svm/svm.c | 37 ++++++++++++++++++++-----------------
> > > >    arch/x86/kvm/svm/svm.h |  1 +
> > > >    3 files changed, 22 insertions(+), 18 deletions(-)
> > > 
> > > We ran some stress tests against a version of the kernel without this fix
> > > and we're able to reproduce the issue, but not reliably, after a few hours.
> > > With this patch, it has not reproduced after running for a week.
> > > 
> > > Not as reliable a scenario as the original reporter, but this looks like it
> > > resolves the issue.
> > 
> > Thanks Tom!  I'll apply this for v6.6, that'll give us plenty of time to change
> > course if necessary.
> 
> I may have spoke to soon...  When the #UD was triggered it was here:
> 
> [    0.118524] Spectre V2 : Enabling Restricted Speculation for firmware calls
> [    0.118524] Spectre V2 : mitigation: Enabling conditional Indirect Branch Prediction Barrier
> [    0.118524] Speculative Store Bypass: Mitigation: Speculative Store Bypass disabled via prctl
> [    0.118524] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
> [    0.118524] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.2.2-amdsos-build50-ubuntu-20.04+ #1
> [    0.118524] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
> [    0.118524] RIP: 0010:int3_selftest_ip+0x0/0x60
> [    0.118524] Code: b9 25 05 00 00 48 c7 c2 e8 7c 80 b0 48 c7 c6 fe 1c d3 b0 48 c7 c7 f0 7d da b0 e8 4c 2c 0b ff e8 75 da 15 ff 0f 0b 48 8d 7d f4 <cc> 90 90 90 90 83 7d f4 01 74 2f 80 3d 39 7f a8 00 00 74 24 b9 34
> 
> 
> Now (after about a week) we've encountered a hang here:
> 
> [    0.106216] Spectre V2 : Enabling Restricted Speculation for firmware calls
> [    0.106216] Spectre V2 : mitigation: Enabling conditional Indirect Branch Prediction Barrier
> [    0.106216] Speculative Store Bypass: Mitigation: Speculative Store Bypass disabled via prctl
> 
> It is in the very same spot and so I wonder if the return false (without
> queuing a #UD) is causing an infinite loop here that appears as a guest
> hang. Whereas, we have some systems running the first patch that you
> created that have not hit this hang.
> 
> But I'm not sure why or how this patch could cause the guest hang. I
> would think that the retry of the instruction would resolve everything
> and the guest would continue. Unfortunately, the guest was killed, so I'll
> try to reproduce and get a dump or trace points of the VM to see what is
> going on.

Gah, it's because x86_emulate_instruction() returns '1' and not '0' when
svm_can_emulate_instruction() returns false.  svm_update_soft_interrupt_rip()
would then continue with the injection, i.e. inject #BP on the INT3 RIP, not on
the RIP following the INT3, which would cause this check to fail

	if (regs->ip - INT3_INSN_SIZE != selftest)
		return NOTIFY_DONE;

and eventually send do_trap_no_signal() to die().

I distinctly remember seeing the return value problem when writing the patch, but
missed that it would result in KVM injecting the unexpected #BP.

I punted on trying to properly fix this by having can_emulate_instruction()
differentiate between "retry insn" and "inject exception", because that change
is painfully invasive and I though I could get away with the simple fix.  Drat.

I think the best option is to add a "temporary" patch so that the fix for @stable
is short, sweet, and safe, and then do the can_emulate_instruction() cleanup that
I was avoiding.

E.g. this as patch 2/4 (or maybe 2/5) of this series:

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7cb5ef5835c2..8457a36b44c1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -364,6 +364,8 @@ static void svm_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
                svm->vmcb->control.int_state |= SVM_INTERRUPT_SHADOW_MASK;
 
 }
+static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
+                                       void *insn, int insn_len);
 
 static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
                                           bool commit_side_effects)
@@ -384,6 +386,14 @@ static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
        }
 
        if (!svm->next_rip) {
+               /*
+                * FIXME: Drop this when kvm_emulate_instruction() does the
+                * right thing and treats "can't emulate" as outright failure
+                * for EMULTYPE_SKIP.
+                */
+               if (!svm_can_emulate_instruction(vcpu, EMULTYPE_SKIP, NULL, 0))
+                       return 0;
+
                if (unlikely(!commit_side_effects))
                        old_rflags = svm->vmcb->save.rflags;
