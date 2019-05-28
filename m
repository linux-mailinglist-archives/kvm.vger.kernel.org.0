Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3A012BF1F
	for <lists+kvm@lfdr.de>; Tue, 28 May 2019 08:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbfE1GON (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 02:14:13 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:42733 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726828AbfE1GOM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 May 2019 02:14:12 -0400
Received: by mail-oi1-f194.google.com with SMTP id w9so13356113oic.9;
        Mon, 27 May 2019 23:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kIVV/8eVblDW59ypiylK3yzX/TpyuoqX/pgUVcswbpA=;
        b=P6GC8wAFfrBOSFOUT1Muaml1yosVu2ZMgJSciE0ik7A+yT3tE1tQ/OjCPLuU4CtVAY
         X4YgfpNwLjl4lKPl3oYvCyTPnP9WCZfFZJH4Sj9CcpdV09fu6gz2o7j0/qvHQ6Q2tVA1
         gyTeRFxcDk5w8P/2tBNyPddmGn9lw3xLNZn9z4s/lj55mRou3a5tl585wotwRGyXeMuk
         iu/9GQyMqT97BRUI8w6BPidaukpezTfj0qwr2VH6XV2w0erJfKJL4/Sl7AyFBMUCVgXg
         lVPBY9FgHhsvbNkpFdAqnfxytdkfTUH1STqpjuJEVNjMXwri8OsZb+QKvT+CTzjIHyQU
         gXpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kIVV/8eVblDW59ypiylK3yzX/TpyuoqX/pgUVcswbpA=;
        b=J868/SfADg2Xz+wDka1XvI5YhkHE5kiQ30Q3kjA7FpfiUMAf3ZOIkR58mn6C7FBaFH
         NgGPgGGe+3GlBYBmr3WFYbAab9Ta3vl1wIV1G0lUhNI5D2sRrZkq6HmH0RwA9QypylNO
         F7g2k9jrPk577XrF4dNS5q5XHcPqa5YlhmKnffSJXtnmHrOsM6cplKvLk7IPFKdDp97r
         Ev263SXyJmkzIfcNqMH9/jF54Vu/wSShJJlCzBe04npfFWUkDJHc6HKdNf9f1k9b2OA1
         mp/6QMPrHTYEP/v8DDk4j84qsELh1MAalL4IExf1r0H3pDbXj8OWNVJzidiZ4EtyVmaY
         wDPQ==
X-Gm-Message-State: APjAAAWyqMKDe4OX4LxMCy2ir70M+9PWHgF2fZexRbKD5HXYY8PpxxXQ
        K2ZxBpRvl09pp/JItSpy4ClkwLU9RxYrjjU6+p4=
X-Google-Smtp-Source: APXvYqyaT0+xy/y3VTeupzYv+EAsoYmiTQBO9cXHdxbApdbaHqSw+SKfLDSQUzbVOq7vsei2S5awjnAwH02KZjzpA/4=
X-Received: by 2002:aca:e0d6:: with SMTP id x205mr1614334oig.47.1559024052006;
 Mon, 27 May 2019 23:14:12 -0700 (PDT)
MIME-Version: 1.0
References: <1559009752-8536-1-git-send-email-wanpengli@tencent.com> <201905281409.9kOwJUw6%lkp@intel.com>
In-Reply-To: <201905281409.9kOwJUw6%lkp@intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 28 May 2019 14:14:05 +0800
Message-ID: <CANRm+CxFSZMiKh8C7To5s0+D3NUVgTN71QXd+gJeZmT2nBR-OA@mail.gmail.com>
Subject: Re: [PATCH RESEND v2] KVM: X86: Implement PV sched yield hypercall
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@01.org, LKML <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 28 May 2019 at 14:08, kbuild test robot <lkp@intel.com> wrote:
>
> Hi Wanpeng,
>
> Thank you for the patch! Yet something to improve:
>
> [auto build test ERROR on kvm/linux-next]
> [also build test ERROR on v5.2-rc2 next-20190524]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/Wanpeng-Li/KVM-X86-Implement-PV-sched-yield-hypercall/20190528-132021
> base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git linux-next
> config: x86_64-allyesconfig (attached as .config)
> compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64
>
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    arch/x86//kvm/x86.c: In function 'kvm_emulate_hypercall':
> >> arch/x86//kvm/x86.c:7243:7: error: 'KVM_HC_SCHED_YIELD' undeclared (first use in this function); did you mean 'KVM_HC_SEND_IPI'?
>      case KVM_HC_SCHED_YIELD:
>           ^~~~~~~~~~~~~~~~~~
>           KVM_HC_SEND_IPI
>    arch/x86//kvm/x86.c:7243:7: note: each undeclared identifier is reported only once for each function it appears in

It's a false report, it is declared in patch 1/3.

>
> vim +7243 arch/x86//kvm/x86.c
>
>   7196
>   7197  int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>   7198  {
>   7199          unsigned long nr, a0, a1, a2, a3, ret;
>   7200          int op_64_bit;
>   7201
>   7202          if (kvm_hv_hypercall_enabled(vcpu->kvm))
>   7203                  return kvm_hv_hypercall(vcpu);
>   7204
>   7205          nr = kvm_rax_read(vcpu);
>   7206          a0 = kvm_rbx_read(vcpu);
>   7207          a1 = kvm_rcx_read(vcpu);
>   7208          a2 = kvm_rdx_read(vcpu);
>   7209          a3 = kvm_rsi_read(vcpu);
>   7210
>   7211          trace_kvm_hypercall(nr, a0, a1, a2, a3);
>   7212
>   7213          op_64_bit = is_64_bit_mode(vcpu);
>   7214          if (!op_64_bit) {
>   7215                  nr &= 0xFFFFFFFF;
>   7216                  a0 &= 0xFFFFFFFF;
>   7217                  a1 &= 0xFFFFFFFF;
>   7218                  a2 &= 0xFFFFFFFF;
>   7219                  a3 &= 0xFFFFFFFF;
>   7220          }
>   7221
>   7222          if (kvm_x86_ops->get_cpl(vcpu) != 0) {
>   7223                  ret = -KVM_EPERM;
>   7224                  goto out;
>   7225          }
>   7226
>   7227          switch (nr) {
>   7228          case KVM_HC_VAPIC_POLL_IRQ:
>   7229                  ret = 0;
>   7230                  break;
>   7231          case KVM_HC_KICK_CPU:
>   7232                  kvm_pv_kick_cpu_op(vcpu->kvm, a0, a1);
>   7233                  ret = 0;
>   7234                  break;
>   7235  #ifdef CONFIG_X86_64
>   7236          case KVM_HC_CLOCK_PAIRING:
>   7237                  ret = kvm_pv_clock_pairing(vcpu, a0, a1);
>   7238                  break;
>   7239  #endif
>   7240          case KVM_HC_SEND_IPI:
>   7241                  ret = kvm_pv_send_ipi(vcpu->kvm, a0, a1, a2, a3, op_64_bit);
>   7242                  break;
> > 7243          case KVM_HC_SCHED_YIELD:
>   7244                  kvm_sched_yield(vcpu->kvm, a0);
>   7245                  ret = 0;
>   7246                  break;
>   7247          default:
>   7248                  ret = -KVM_ENOSYS;
>   7249                  break;
>   7250          }
>   7251  out:
>   7252          if (!op_64_bit)
>   7253                  ret = (u32)ret;
>   7254          kvm_rax_write(vcpu, ret);
>   7255
>   7256          ++vcpu->stat.hypercalls;
>   7257          return kvm_skip_emulated_instruction(vcpu);
>   7258  }
>   7259  EXPORT_SYMBOL_GPL(kvm_emulate_hypercall);
>   7260
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
