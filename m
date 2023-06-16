Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBC1D7328A7
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 09:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243101AbjFPHS7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 03:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243483AbjFPHS6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 03:18:58 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 707661FE2
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 00:18:56 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-570022400b9so6538667b3.0
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 00:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686899935; x=1689491935;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kObMUupx48Q+LRubONskIMY0QpTTuKPxdMIShCUYkBM=;
        b=3W+XN/RCDmz+fR3BY/FB0NMC9qoIBZbKtmWoud6wljhUWIt/BqG5lw23aLYr4QN8Z+
         YWMBkru2yULYUY47Twmb66CF4eXjv3r+q5UUtiFBagqEZLj8LlgWlHskdnP/hnZwpQsf
         hrRHofvZi5uO6Bl6y+PzqGDLalhPwc4I/Za+geHWkvXKPyG5QdlNXKCx9SY4E8+ht0ZC
         YKkhWhG/3kfR5IpaWh3WuvjuzHQGI7Oribxt2d90WoSA7nEwvEHeuPcF0X3KBx3mZPov
         MLxVGVL63GU3MCv2SMP8ymYm2pHt4EwK0l1upzJq77ss4Kdnoya1N5+vJMPMRyVj5Nm7
         flxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686899935; x=1689491935;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kObMUupx48Q+LRubONskIMY0QpTTuKPxdMIShCUYkBM=;
        b=lKp2fz3ukdOYwf+3eHx70QEma3HvrThEbyzYXM2wXnp7p92YZ3S5dj51VaovhNuSSx
         ZdBdqeSd6XgaDtGfpITsLMSukEyU+L0mKpTU1TPkoKucam8fyV6piiu0mJ/ZSpMUKXw8
         W1ybZ9V5ZsO+GTcFfvVQA65U1UtrIEfcOziLc0obtaSjjRdUUfWRQPCbVgOSE0LpejQm
         0TGbWkSLfi/ubbSoFoWmt0+sJLavBEMo50ly4ZSFNg/q46qx+hUQIQJUFZtarcUexCRG
         xTQQlfDnEEiiOdBgXYfNGU2Asg+IY/vS4U1rfPC8ze08SCSpHpIWZP8TTd7Re42NagMc
         WOJA==
X-Gm-Message-State: AC+VfDwm3VBi+M4ugNYVihN400Akxv4EAIW5kWToKWmcz8iCHPkfXSeX
        soSJPvkzIlZwTFHaQ2GvIa4Z/FO2KSU=
X-Google-Smtp-Source: ACHHUZ4UKrTt8gtO6Kg+5QUMpXrFol5AdHMQKBS6omhxklQ5fn4AcApNYjGTp3Tr6s/ug4V7YNkLmeQgec8=
X-Received: from yuzhao.bld.corp.google.com ([2620:15c:183:202:e767:3e73:f240:e08c])
 (user=yuzhao job=sendgmr) by 2002:a81:440e:0:b0:56d:1f95:fde8 with SMTP id
 r14-20020a81440e000000b0056d1f95fde8mr386449ywa.4.1686899935606; Fri, 16 Jun
 2023 00:18:55 -0700 (PDT)
Date:   Fri, 16 Jun 2023 01:18:31 -0600
In-Reply-To: <1596005919-29365-5-git-send-email-chenhc@lemote.com>
Message-Id: <20230616071831.1452507-1-yuzhao@google.com>
Mime-Version: 1.0
References: <1596005919-29365-5-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Subject: Re: [PATCH 5/5] MAINTAINERS: Update KVM/MIPS maintainers
From:   Yu Zhao <yuzhao@google.com>
To:     chenhuacai@kernel.org, aleksandar.qemu.devel@gmail.com,
        tsbogend@alpha.franken.de
Cc:     jiaxun.yang@flygoat.com, kvm@vger.kernel.org,
        linux-mips@vger.kernel.org, pbonzini@redhat.com,
        robh+dt@kernel.org, zhangfx@lemote.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 28, 2020 at 23:58:20PM -0700, Huacai Chen wrote:
> James Hogan has become inactive for a long time and leaves KVM for MIPS
> orphan. I'm working on KVM/Loongson and attempt to make it upstream both
> in kernel and QEMU, while Aleksandar Markovic is already a maintainer of
> QEMU/MIPS. We are both interested in QEMU/KVM/MIPS, and we have already
> made some contributions in kernel and QEMU. If possible, we want to take
> the KVM/MIPS maintainership.
>
> Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> ---
>  MAINTAINERS | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index bddc79a..5f9c2fd 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9441,9 +9441,11 @@ F:	arch/arm64/kvm/
>  F:	include/kvm/arm_*
>
>  KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)
> +M:	Huacai Chen <chenhc@lemote.com>
> +M:	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
>  L:	linux-mips@vger.kernel.org
>  L:	kvm@vger.kernel.org
> -S:	Orphan
> +S:	Maintained
>  F:	arch/mips/include/asm/kvm*
>  F:	arch/mips/include/uapi/asm/kvm*
>  F:	arch/mips/kvm/

Hi,

Is kvm/mips still maintained? Thanks.

I tried v6.4-rc6 and hit the following crash. It seems it has been broken since

  commit 45c7e8af4a5e3f0bea4ac209eea34118dd57ac64
  Author: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
  Date:   Mon Mar 1 16:29:57 2021 +0100
  
      MIPS: Remove KVM_TE support
      
      After removal of the guest part of KVM TE (trap and emulate), also remove
      the host part.

which deletes kvm_mips_commpage_init() and leaves vcpu->arch.cop0 NULL.

(Or probably I've missed something.)

  $ sudo qemu-system-mips64el -M accel=kvm -nographic
  CPU 2 Unable to handle kernel paging request at virtual address 0000000000000300, epc == ffffffff81148288, ra == ffffffff81148228
  Oops[#1]:
  CPU: 2 PID: 339 Comm: qemu-system-mip Not tainted 6.4.0-rc6-00049-g62d8779610bb #3
  $ 0   : 0000000000000000 0000000034109ce1 0000000000400004 ffffffff81b50200
  $ 4   : 8000000001d71c00 0000000000000001 0000000000000000 0000000000000000
  $ 8   : 000000a64082989c 000000000000001f 000000000000000a 0000000000000060
  $12   : ffffffff81935390 eb0ffdb582d1ed00 0000000000000001 0000000000000000
  $16   : 0000000000000000 8000000005193330 8000000005193330 80000000058b6000
  $20   : 80000000058b4a00 ffffffff81b5f110 0000000000000000 ffffffffffffffff
  $24   : 0000000000000001 ffffffff811331a0
  $28   : 80000000021e8000 80000000021ebc90 000000fff1369160 ffffffff81148228
  Hi    : 0000000000000000
  Lo    : 00000000083e6217
  epc   : ffffffff81148288 kvm_vz_vcpu_setup+0xa8/0x2d8
  ra    : ffffffff81148228 kvm_vz_vcpu_setup+0x48/0x2d8
  Status: 34109ce3	KX SX UX KERNEL EXL IE
  Cause : 0080000c (ExcCode 03)
  BadVA : 0000000000000300
  PrId  : 000d9602 (Cavium Octeon III)
  Modules linked in:
  Process qemu-system-mip (pid: 339, threadinfo=0000000029889cef, task=0000000070662173, tls=000000fff1371140)
  Stack : 8000000005193330 80000000058b4a00 80000000058b4000 ffffffff81142184
          80000000021ebcd8 eb0ffdb582d1ed00 ffffffff81b50000 ffffffff81b50000
          800000000537e000 0000000000000000 800000000537e920 8000000005193330
          ffffffff81c10000 ffffffff8113fd94 0000000000000cc0 000000000ffdc000
          000000ffdc000000 000000ffdc000010 0000000000000255 8000000003416700
          8000000005923ff8 0000000000000000 0000000000000000 0000000000000000
          8000000004775000 800000004d91dd68 0000000000000000 eb0ffdb582d1ed00
          0000000000000801 0000000000000255 ffffffff81b526a8 0000000000000001
          0000000000000001 ffffffff812c4b84 8000000002238180 0000000000000255
          0000000000000000 eb0ffdb582d1ed00 000000ffdc000010 8000000003717200
          ...
  Call Trace:
  [<ffffffff81148288>] kvm_vz_vcpu_setup+0xa8/0x2d8
  [<ffffffff81142184>] kvm_arch_vcpu_create+0x12c/0x1c0
  [<ffffffff8113fd94>] kvm_vm_ioctl+0x5e4/0xda0
  [<ffffffff812ef070>] sys_ioctl+0xb8/0x100
  [<ffffffff81125930>] syscall_common+0x34/0x58
  
  Code: 3c040040  24840004  00441025 <fe020300> 40626001  3c04ff80  00441024  3c048000  7c42f803
  
  ---[ end trace 0000000000000000 ]---
