Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C34BB528D12
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 20:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344840AbiEPSbg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 14:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344941AbiEPSbU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 14:31:20 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 153083E0FE
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 11:31:02 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 31so14860429pgp.8
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 11:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9C8bpp6d21XdJaEwrvELDm0aYiNE+NJR0NE35SfqoPw=;
        b=JOhFs1aNvRIY7bmGE74VDs+kZuh4q3JIlp+QrRMyFp/PLiOT8r/3UwgXQt6bqHPI65
         NNYmecm+jORBOX+gKz9WJLCJGXE8LtJQC5YL5L0PG2VmJTEBS8s7+BEqGJwsS/8+CAYW
         nVtpgMTT9AXF2n5UP9Os5QjiIR9UeLBr/gS7D8XWO4BYz4RxM7rWHE32W8yus+feXD/Q
         6c9Ngj5rWTW8OVkRdB4rlL0vYTmsqa2mDT/HwyIbkm1tp/SHRbUR9Gaw11RKuYsiNckv
         aWfNEoZFgG65UKfiNR9mOJwX/KkL4MaqZDcAOWzWPHerMRs6yhZwBq+5tbLfJvRRz/ie
         gAKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9C8bpp6d21XdJaEwrvELDm0aYiNE+NJR0NE35SfqoPw=;
        b=MnNcAfneCYAE2Maetq0lOoDiRAbt4lo1gvuPp5kKAUsnJA5n5tAu3liEqJj13xOmqm
         l5EjgeZJy7U5ylgEADeVfIjT6Zy1tRdrtPAm8EE8D7oWOAz7RwXhPYw7b4E97nhAW1iB
         2cS5vhTGY8GqziL7wg0KwYx9lBzGvUbiWaUhk5taDZvQacoZbWNOs/N/mgnG/9aoRD+U
         ImxZ4UZ3aMR8++xXc7Mce+s6tqJmrTDNCjhwc8Y7lstTwLppGKPtoDpn/QHXahW62/mb
         qjn7ya4yP5aIhOXRvdiQmrcU/kcpgFkhgcIWa3NlaJwXkxo2sKKwEHIx9PePbS+cA4p3
         vDZA==
X-Gm-Message-State: AOAM532J5q795FbGPsL+pjjAJWdHG7Wg6TKdjDWSQxvK8vacF9SVwDHZ
        BoeohbUGNUjKcfUhxwWzGrvo0TgvwSz7zJLfv/WLeA==
X-Google-Smtp-Source: ABdhPJyjaFJSIeFl9j5CO5O2cLnzJAk/+sTu7/7S9nAUSuITSTyO47ux8geJ/ybnqIcWYwvzYkotmXgpj/i/8Woz0+g=
X-Received: by 2002:a65:4581:0:b0:3f2:638f:6f76 with SMTP id
 o1-20020a654581000000b003f2638f6f76mr6735655pgq.324.1652725861290; Mon, 16
 May 2022 11:31:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220502233853.1233742-1-rananta@google.com> <878rri8r78.wl-maz@kernel.org>
 <CAJHc60xp=UQT_CX0zoiSjAmkS8JSe+NB5Gr+F5mmybjJAWkUtQ@mail.gmail.com>
 <878rriicez.wl-maz@kernel.org> <CAJHc60w1F7RAgJkv5PRuJtKjTw1gUaYmZk885AVhPLF2h6YbkQ@mail.gmail.com>
 <87ilq55swj.wl-maz@kernel.org>
In-Reply-To: <87ilq55swj.wl-maz@kernel.org>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Mon, 16 May 2022 11:30:48 -0700
Message-ID: <CAJHc60zLt2ZtCR2=DgtS3XK8e7vQrocEO2rinW_hMb4o4-WhTg@mail.gmail.com>
Subject: Re: [PATCH v7 0/9] KVM: arm64: Add support for hypercall services selection
To:     Marc Zyngier <maz@kernel.org>
Cc:     Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 16, 2022 at 9:44 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 03 May 2022 22:09:29 +0100,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> >
> > On Tue, May 3, 2022 at 1:33 PM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > On Tue, 03 May 2022 19:49:13 +0100,
> > > Raghavendra Rao Ananta <rananta@google.com> wrote:
> > > >
> > > > Hi Marc,
> > > >
> > > > On Tue, May 3, 2022 at 10:24 AM Marc Zyngier <maz@kernel.org> wrote=
:
> > > > >
> > > > > On Tue, 03 May 2022 00:38:44 +0100,
> > > > > Raghavendra Rao Ananta <rananta@google.com> wrote:
> > > > > >
> > > > > > Hello,
> > > > > >
> > > > > > Continuing the discussion from [1], the series tries to add sup=
port
> > > > > > for the userspace to elect the hypercall services that it wishe=
s
> > > > > > to expose to the guest, rather than the guest discovering them
> > > > > > unconditionally. The idea employed by the series was taken from
> > > > > > [1] as suggested by Marc Z.
> > > > >
> > > > > As it took some time to get there, and that there was still a bun=
ch of
> > > > > things to address, I've taken the liberty to apply my own fixes t=
o the
> > > > > series.
> > > > >
> > > > > Please have a look at [1], and let me know if you're OK with the
> > > > > result. If you are, I'll merge the series for 5.19.
> > > > >
> > > > > Thanks,
> > > > >
> > > > >         M.
> > > > >
> > > > Thank you for speeding up the process; appreciate it. However, the
> > > > series's selftest patches have a dependency on Oliver's
> > > > PSCI_SYSTEM_SUSPEND's selftest patches [1][2]. Can we pull them in
> > > > too?
> > >
> > > Urgh... I guess this is the time to set some ground rules:
> > >
> > > - Please don't introduce dependencies between series, that's
> > >   unmanageable. I really need to see each series independently, and i=
f
> > >   there is a merge conflict, that's my job to fix (and I don't really
> > >   mind).
> > >
> > > - If there is a dependency between series, please post a version of
> > >   the required patches as a prefix to your series, assuming this
> > >   prefix is itself standalone. If it isn't, then something really is
> > >   wrong, and the series should be resplit.
> > >
> > > - You also should be basing your series on an *official* tag from
> > >   Linus' tree (preferably -rc1, -rc2 or -rc3), and not something
> > >   random like any odd commit from the KVM tree (I had conflicts while
> > >   applying this on -rc3, probably due to the non-advertised dependenc=
y
> > >   on Oliver's series).
> > >
> > Thanks for picking the dependency patches. I'll keep these mind the
> > next time I push changes.
> >
> > > >
> > > > aarch64/hypercalls.c: In function =E2=80=98guest_test_hvc=E2=80=99:
> > > > aarch64/hypercalls.c:95:30: error: storage size of =E2=80=98res=E2=
=80=99 isn=E2=80=99t known
> > > >    95 |         struct arm_smccc_res res;
> > > >       |                              ^~~
> > > > aarch64/hypercalls.c:103:17: warning: implicit declaration of funct=
ion
> > > > =E2=80=98smccc_hvc=E2=80=99 [-Wimplicit-function-declaration]
> > > >   103 |                 smccc_hvc(hc_info->func_id, hc_info->arg1, =
0,
> > > > 0, 0, 0, 0, 0, &res);
> > > >       |                 ^~~~~~~~~
> > > >
> > >
> > > I've picked the two patches, which means they will most likely appear
> > > twice in the history. In the future, please reach out so that we can
> > > organise this better.
> > >
> > > > Also, just a couple of readability nits in the fixed version:
> > > >
> > > > 1. Patch-2/9, hypercall.c:kvm_hvc_call_default_allowed(), in the
> > > > 'default' case, do you think we should probably add a small comment
> > > > that mentions we are checking for func_id in the PSCI range?
> > >
> > > Dumped a one-liner there.
> > >
> > > > 2. Patch-2/9, arm_hypercall.h, clear all the macros in this patch
> > > > itself instead of doing it in increments (unless there's some reaso=
n
> > > > that I'm missing)?
> > >
> > > Ah, rebasing leftovers, now gone.
> > >
> > > I've pushed an updated branch again, please have a look.
> > >
> > Thanks for addressing these. The series looks good now.
>
> Except it doesn't.
>
> I introduced a bug by overly simplifying kvm_arm_set_fw_reg_bmap(), as
> we have to allow userspace writing the *same* value. As it turns out,
> QEMU restores all the registers on each reboot. Which as the vcpus
> have all run. This in turns triggers another issue in QEMU, which
> instead of taking the hint ans stopping there, sends all the vcpus
> into the guest in one go with random states... Crap happens.
>
> I'll wear a brown paper bag for the rest of the day and add the
> following patch to the branch.
>
> Thanks,
>
>         M.
>
> From 528ada2811ba0bb2b2db5bf0f829b48c50f3c13c Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <maz@kernel.org>
> Date: Mon, 16 May 2022 17:32:54 +0100
> Subject: [PATCH] KVM: arm64: Fix hypercall bitmap writeback when vcpus ha=
ve
>  already run
>
> We generally want to disallow hypercall bitmaps being changed
> once vcpus have already run. But we must allow the write if
> the written value is unchanged so that userspace can rewrite
> the register file on reboot, for example.
>
> Without this, a QEMU-based VM will fail to reboot correctly.
>
> The original code was correct, and it is me that introduced
> the regression.
>
> Fixes: 05714cab7d63 ("KVM: arm64: Setup a framework for hypercall bitmap =
firmware registers")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hypercalls.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index ccbd3cefb91a..c9f401fa01a9 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -379,7 +379,8 @@ static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *v=
cpu, u64 reg_id, u64 val)
>
>         mutex_lock(&kvm->lock);
>
> -       if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags)) {
> +       if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags) &&
> +           val !=3D *fw_reg_bmap) {
>                 ret =3D -EBUSY;
>                 goto out;
>         }
Ha, not your fault. We have been going back and forth on this aspect
of the design. Thanks for correcting this.
However, since this changes the API behavior, I think we may have to
amend the documentation as well:

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rs=
t
index b5ccec4572d7..ab04979bf104 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -2615,7 +2615,8 @@ KVM_SET_ONE_REG.

 Note: These registers are immutable once any of the vCPUs of the VM has
 run at least once. A KVM_SET_ONE_REG in such a scenario will return
-a -EBUSY to userspace.
+a -EBUSY to userspace if there's an update in the bitmap. If there's no
+change in the value, it'll simply return a 0.

 (See Documentation/virt/kvm/arm/hypercalls.rst for more details.)

diff --git a/Documentation/virt/kvm/arm/hypercalls.rst
b/Documentation/virt/kvm/arm/hypercalls.rst
index 3e23084644ba..275f4dbe5792 100644
--- a/Documentation/virt/kvm/arm/hypercalls.rst
+++ b/Documentation/virt/kvm/arm/hypercalls.rst
@@ -91,9 +91,10 @@ desired bitmap back via SET_ONE_REG. The features
for the registers that
 are untouched, probably because userspace isn't aware of them, will be
 exposed as is to the guest.

-Note that KVM will not allow the userspace to configure the registers
-anymore once any of the vCPUs has run at least once. Instead, it will
-return a -EBUSY.
+Note that KVM will not allow the userspace to update the registers
+with a new value anymore once any of the vCPUs has run at least once,
+and will return a -EBUSY. However, a 'write' of the previously configured
+value is allowed and returns a 0.

 The pseudo-firmware bitmap register are as follows:

@@ -129,10 +130,10 @@ The pseudo-firmware bitmap register are as follows:

 Errors:

-    =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+    =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
     -ENOENT   Unknown register accessed.
-    -EBUSY    Attempt a 'write' to the register after the VM has started.
+    -EBUSY    Attempt to update the register bitmap after the VM has start=
ed.
     -EINVAL   Invalid bitmap written to the register.
-    =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+    =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

 .. [1] https://developer.arm.com/-/media/developer/pdf/ARM_DEN_0070A_Firmw=
are_interfaces_for_mitigating_CVE-2017-5715.pdf


Thank you.
Raghavendra
> --
> 2.34.1
>
>
> --
> Without deviation from the norm, progress is not possible.
