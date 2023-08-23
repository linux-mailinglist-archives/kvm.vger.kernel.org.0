Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2D9D7861F9
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 23:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237039AbjHWVMk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 17:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236966AbjHWVMP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 17:12:15 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F121A10D8
        for <kvm@vger.kernel.org>; Wed, 23 Aug 2023 14:12:12 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-56357814339so6749099a12.3
        for <kvm@vger.kernel.org>; Wed, 23 Aug 2023 14:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692825132; x=1693429932;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=127o1e2ZxsfTG2EW1SJhGDYnNf5Ml57qeq2/F35dzqE=;
        b=Ive9zZUHDErpdUQi2NZvd6G1ojNJJRonif+ER4gKq0Z60ZAKPb3ovWD1JrhoM5YWpk
         wao8ZZecanMqLgoy/OcYOnNMyqBzXZp85ZhYv1XG6GmgwvrPykOplgFdUfLMq0mNmpOf
         TXbjvr7kRNoR+wtw9yhOlIxmXtJwPwkgSQQghWl3KSb6o20zlTmrDc7/EOWNulmK8TMH
         A0RFIsZABC3en1rQoynj0/hE4rXzhdQdaJI6mrpx8E/E9r2YOo8T4bIuoGWKuL7NXQ+H
         2433+oYlogtPt8qMuLdz52mNYRl3jjhPgcfgKlEOpfPYQl28hugcvsXbQuGKpbu8cKSC
         c5Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692825132; x=1693429932;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=127o1e2ZxsfTG2EW1SJhGDYnNf5Ml57qeq2/F35dzqE=;
        b=VuYQtAtm5oft9NWlK1VQNc/u+LbJF8/1a+Anwy5RzvJYwRM8X0aKyPnBSAtTrsEMeg
         uyHof0eH0g8WS56IBKZlt9TSF54Qit/JNbbrXmJWNhOEHhiZn4A42fvnp7jTE1hLuWVF
         vHUXrWp7AnCc/DkiEYB+9Ig438LQHJznd7D/CZ8BuPQwi8CEoxn4ygYP1H0WtuJhR8Jz
         xk2QBwZmLXsK8eAgQ/yIaO7jsQLqWOTLYo6qvNkFWKWqFhNm8KSc+OPBCVvxNijBzpRj
         rW4XSxGX4+dPRlg5i8e7cjYFjEJS08SNGVNdLRJwI5oO1cHelkfer3fT/rzi1Yk9maK1
         8RwQ==
X-Gm-Message-State: AOJu0YyEHIgBZGXNWzSEmIHps15jhRArzZBVb8Qp9Jq7uN8F00YrmKo9
        xcwCjkWRac88pPGzIGvYCMfViK5Bwno=
X-Google-Smtp-Source: AGHT+IEOss0Pqtl4PPt4AL02nTNq+RY7yG3+ZKLTb8MX+cqCzI2w6NaZCir+UlgaC4j8SMKGhG1++5XbElw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:3409:0:b0:569:50e1:5469 with SMTP id
 b9-20020a633409000000b0056950e15469mr2183757pga.9.1692825132353; Wed, 23 Aug
 2023 14:12:12 -0700 (PDT)
Date:   Wed, 23 Aug 2023 14:12:10 -0700
In-Reply-To: <bc6a9c1f-d41e-ef81-3029-04c2938b300c@amd.com>
Mime-Version: 1.0
References: <20230810234919.145474-1-seanjc@google.com> <bf3af7eb-f4ce-b733-08d4-6ab7f106d6e6@amd.com>
 <ZOTQ6izCUfrBh2oj@google.com> <d183c3f2-d94d-5f22-184d-eab80f9d0fe8@amd.com>
 <ZOZmFe7MT7zwrf/c@google.com> <bc6a9c1f-d41e-ef81-3029-04c2938b300c@amd.com>
Message-ID: <ZOZ2KqCIcleJxrTz@google.com>
Subject: Re: [PATCH 0/2] KVM: SVM: Fix unexpected #UD on INT3 in SEV guests
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wu Zongyo <wuzongyo@mail.ustc.edu.cn>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 23, 2023, Tom Lendacky wrote:
> On 8/23/23 15:03, Sean Christopherson wrote:
> > I think the best option is to add a "temporary" patch so that the fix for @stable
> > is short, sweet, and safe, and then do the can_emulate_instruction() cleanup that
> > I was avoiding.
> > 
> > E.g. this as patch 2/4 (or maybe 2/5) of this series:
> 
> 2/4 or 2/5? Do you mean 2/3 since there were only 2 patches in the series?

I am planning on adding more patches in v2 to cleanup the hack-a-fix. But after
writing the code, I think it's best to sqaush the hack-a-fix in with patch 1
(new full patch at the bottom, though it should be the same result as the earlier
delta patch).

> I'll apply the below patch in between patches 1 and 2 and re-test. Should
> have results in a week :)

Heh, maybe if we send enough emails we can get Wu's feedback before then :-)

One idea to make the original bug repro on every run would be to constantly
toggle nx_huge_pages between "off" and "force" while the guest is booting.  Toggling
nx_huge_pages should force KVM to rebuild the SPTEs and all but guarantee trying
to deliver the #BP will hit a #NPF.

--
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 8 Aug 2023 17:18:42 -0700
Subject: [PATCH 1/4] KVM: SVM: Don't inject #UD if KVM attempts to skip SEV
 guest insn

Don't inject a #UD if KVM attempts to "emulate" to skip an instruction
for an SEV guest, and instead resume the guest and hope that it can make
forward progress.  When commit 04c40f344def ("KVM: SVM: Inject #UD on
attempted emulation for SEV guest w/o insn buffer") added the completely
arbitrary #UD behavior, there were no known scenarios where a well-behaved
guest would induce a VM-Exit that triggered emulation, i.e. it was thought
that injecting #UD would be helpful.

However, now that KVM (correctly) attempts to re-inject INT3/INTO, e.g. if
a #NPF is encountered when attempting to deliver the INT3/INTO, an SEV
guest can trigger emulation without a buffer, through no fault of its own.
Resuming the guest and retrying the INT3/INTO is architecturally wrong,
e.g. the vCPU will incorrectly re-hit code #DBs, but for SEV guests there
is literally no other option that has a chance of making forward progress.

Drop the #UD injection for all "skip" emulation, not just those related to
INT3/INTO, even though that means that the guest will likely end up in an
infinite loop instead of getting a #UD (the vCPU may also crash, e.g. if
KVM emulated everything about an instruction except for advancing RIP).
There's no evidence that suggests that an unexpected #UD is actually
better than hanging the vCPU, e.g. a soft-hung vCPU can still respond to
IRQs and NMIs to generate a backtrace.

Reported-by: Wu Zongyo <wuzongyo@mail.ustc.edu.cn>
Closes: https://lore.kernel.org/all/8eb933fd-2cf3-d7a9-32fe-2a1d82eac42a@mail.ustc.edu.cn
Fixes: 6ef88d6e36c2 ("KVM: SVM: Re-inject INT3/INTO instead of retrying the instruction")
Cc: stable@vger.kernel.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 212706d18c62..f6adc43b315a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -364,6 +364,8 @@ static void svm_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
 		svm->vmcb->control.int_state |= SVM_INTERRUPT_SHADOW_MASK;
 
 }
+static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
+					void *insn, int insn_len);
 
 static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
 					   bool commit_side_effects)
@@ -384,6 +386,14 @@ static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
 	}
 
 	if (!svm->next_rip) {
+		/*
+		 * FIXME: Drop this when kvm_emulate_instruction() does the
+		 * right thing and treats "can't emulate" as outright failure
+		 * for EMULTYPE_SKIP.
+		 */
+		if (!svm_can_emulate_instruction(vcpu, EMULTYPE_SKIP, NULL, 0))
+			return 0;
+
 		if (unlikely(!commit_side_effects))
 			old_rflags = svm->vmcb->save.rflags;
 
@@ -4725,16 +4735,25 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
 	 * and cannot be decrypted by KVM, i.e. KVM would read cyphertext and
 	 * decode garbage.
 	 *
-	 * Inject #UD if KVM reached this point without an instruction buffer.
-	 * In practice, this path should never be hit by a well-behaved guest,
-	 * e.g. KVM doesn't intercept #UD or #GP for SEV guests, but this path
-	 * is still theoretically reachable, e.g. via unaccelerated fault-like
-	 * AVIC access, and needs to be handled by KVM to avoid putting the
-	 * guest into an infinite loop.   Injecting #UD is somewhat arbitrary,
-	 * but its the least awful option given lack of insight into the guest.
+	 * If KVM is NOT trying to simply skip an instruction, inject #UD if
+	 * KVM reached this point without an instruction buffer.  In practice,
+	 * this path should never be hit by a well-behaved guest, e.g. KVM
+	 * doesn't intercept #UD or #GP for SEV guests, but this path is still
+	 * theoretically reachable, e.g. via unaccelerated fault-like AVIC
+	 * access, and needs to be handled by KVM to avoid putting the guest
+	 * into an infinite loop.   Injecting #UD is somewhat arbitrary, but
+	 * its the least awful option given lack of insight into the guest.
+	 *
+	 * If KVM is trying to skip an instruction, simply resume the guest.
+	 * If a #NPF occurs while the guest is vectoring an INT3/INTO, then KVM
+	 * will attempt to re-inject the INT3/INTO and skip the instruction.
+	 * In that scenario, retrying the INT3/INTO and hoping the guest will
+	 * make forward progress is the only option that has a chance of
+	 * success (and in practice it will work the vast majority of the time).
 	 */
 	if (unlikely(!insn)) {
-		kvm_queue_exception(vcpu, UD_VECTOR);
+		if (!(emul_type & EMULTYPE_SKIP))
+			kvm_queue_exception(vcpu, UD_VECTOR);
 		return false;
 	}
 

base-commit: 240f736891887939571854bd6d734b6c9291f22e
-- 

