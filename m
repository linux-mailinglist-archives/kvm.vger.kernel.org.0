Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9CAC76F429
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 22:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbjHCUqo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 16:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjHCUqk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 16:46:40 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 669D730EA
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 13:46:37 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5840614b13cso22906207b3.0
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 13:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691095596; x=1691700396;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lAj7Kn9ZVU1EdKyXKDleCAun0XcKoAg24+NEl4ASQzg=;
        b=MbkjwPCXOqlHnwsHwnZmTYoUDzajIuJh8MTGZfJeFxqPc1s9L4SYOjTBSPqMHeTTWQ
         4tGClw9RMUWaG/0kpzyWVJ+exdJ8EtbaTLcMebyCv8Z64xvzdARWSj2z3cgEFAg1ZrBG
         axRoWOIlWUW7JvTBvzUXIiM8XKB0W6Iyq2G6l69fxpxC3989tzSvWfqkNjehICVPCPxb
         L+Yx8+Z6F5dQ09wGn4qR6BoDTcodmbxBI1uvvgFfXfgXgdEZFW6ZB0R0kWAU3GJR8f0W
         ZzqC6hIlOKxyy+IS011UTebs6CnF37n/jgsB+FAtVzg5lL+asbcZY4uhyjAqGWT4Q5sF
         QmaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691095596; x=1691700396;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lAj7Kn9ZVU1EdKyXKDleCAun0XcKoAg24+NEl4ASQzg=;
        b=ACyjEJyllPF03Cn0mEzsS/Ai36ECmyw7JCimTkIxKp1/XbnR2qAFP2WqRy2OuMB/Ac
         HFh7ytu/NuVUkmT1QfbqKnxvJqMG1hUX5UHPC4H5llrr/mEGMZWj2C+Et7m5hCpW+lim
         32yTqG6Em8+spAoNGwZ7HWj3/ePPkhVCl9W6xYMuP8JQiahSnEB7XY5m6PvsEI0//HM9
         G8X7tXpxu5myuBKtqcjm5DbZ/TTmSVK04dUS+Qs2Lgz9uY3pk4eopP5aovg6sSsNCnGx
         sKQjcflkMK1p3xee5c7HneihfpNPKMTWbrnoEI7IGpKJ74pSVPsH3P2/e1LhXIkOmATI
         va9w==
X-Gm-Message-State: AOJu0YycFiW72Yppxd1neRp6sbYqcQedf2jiOxQzg6UBBUQTQoA6Tgao
        fjbA77P4P0IK22pRmp1uDFP8DbkHwwo=
X-Google-Smtp-Source: AGHT+IE+az8JE2LQ+ccKdt31OYl1qZEcHJ38Yw6hFrfDo6irLJ8JPMvMqhO24gEuy1eCM3BsxkN4YQzh/hY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:c81:b0:586:88d5:9434 with SMTP id
 cm1-20020a05690c0c8100b0058688d59434mr75210ywb.1.1691095596679; Thu, 03 Aug
 2023 13:46:36 -0700 (PDT)
Date:   Thu, 3 Aug 2023 20:46:35 +0000
In-Reply-To: <CALcu4rbFrU4go8sBHk3FreP+qjgtZCGcYNpSiEXOLm==qFv7iQ@mail.gmail.com>
Mime-Version: 1.0
References: <CALcu4rbFrU4go8sBHk3FreP+qjgtZCGcYNpSiEXOLm==qFv7iQ@mail.gmail.com>
Message-ID: <ZMwSKy09gsa/dL08@google.com>
Subject: Re: WARNING in kvm_arch_vcpu_ioctl_run
From:   Sean Christopherson <seanjc@google.com>
To:     Yikebaer Aizezi <yikebaer61@gmail.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, jarkko@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org
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

On Thu, Jul 27, 2023, Yikebaer Aizezi wrote:
> Hello, I'm sorry for the mistake in my previous email. I forgot to add
> a subject. This is my second attempt to send the message.
> 
> When using Healer to fuzz the latest Linux kernel, the following crash
> was triggered.
> 
> HEAD commit: fdf0eaf11452d72945af31804e2a1048ee1b574c (tag: v6.5-rc2)
> 
> git tree: upstream
> 
> console output:
> https://drive.google.com/file/d/1FiemC_AWRT-6EGscpQJZNzYhXZty6BVr/view?usp=drive_link
> kernel config: https://drive.google.com/file/d/1fgPLKOw7QbKzhK6ya5KUyKyFhumQgunw/view?usp=drive_link
> C reproducer: https://drive.google.com/file/d/1SiLpYTZ7Du39ubgf1k1BIPlu9ZvMjiWZ/view?usp=drive_link
> Syzlang reproducer:
> https://drive.google.com/file/d/1eWSmwvNGOlZNU-0-xsKhUgZ4WG2VLZL5/view?usp=drive_link
> Similar report:
> https://groups.google.com/g/syzkaller-bugs/c/C2ud-S1Thh0/m/z4iI7l_dAgAJ
> 
> If you fix this issue, please add the following tag to the commit:
> Reported-by: Yikebaer Aizezi <yikebaer61@gmail.com>
> 
> kvm: vcpu 129: requested lapic timer restore with starting count
> register 0x390=4241646265 (4241646265 ns) > initial count (296265111
> ns). Using initial count to start timer.
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 1977 at arch/x86/kvm/x86.c:11098
> kvm_arch_vcpu_ioctl_run+0x152f/0x1830 arch/x86/kvm/x86.c:11098

Well that's annoying.  The WARN is a sanity check that KVM doesn't somehow put
the guest into an uninitialized state while emulating the guest's APIC timer, but
I completely overlooked the fact that userspace can simply stuff the should-be-
impossible guest state. *sigh*

Sadly, I think the most reasonable thing to do is to simply drop the sanity check :-(

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0145d844283b..e9e262b244b8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11091,12 +11091,17 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
                        r = -EINTR;
                        goto out;
                }
+
                /*
-                * It should be impossible for the hypervisor timer to be in
-                * use before KVM has ever run the vCPU.
+                * Don't bother switching APIC timer emulation from the
+                * hypervisor timer to the software timer, the only way for the
+                * APIC timer to be active is if userspace stuffed vCPU state,
+                * i.e. put the vCPU and into a nonsensical state.  The only
+                * transition out of UNINITIALIZED (without more state stuffing
+                * from userspace) is an INIT, which will reset the local APIC
+                * and thus smother the timer anyways, i.e. APIC timer IRQs
+                * will be dropped no matter what.
                 */
-               WARN_ON_ONCE(kvm_lapic_hv_timer_in_use(vcpu));
-
                kvm_vcpu_srcu_read_unlock(vcpu);
                kvm_vcpu_block(vcpu);
                kvm_vcpu_srcu_read_lock(vcpu);

