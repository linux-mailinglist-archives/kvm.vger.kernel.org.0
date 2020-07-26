Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E02AC22DF61
	for <lists+kvm@lfdr.de>; Sun, 26 Jul 2020 14:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgGZM5a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Jul 2020 08:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726711AbgGZM5a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Jul 2020 08:57:30 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49F4C0619D4
        for <kvm@vger.kernel.org>; Sun, 26 Jul 2020 05:57:29 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id k20so4491381wmi.5
        for <kvm@vger.kernel.org>; Sun, 26 Jul 2020 05:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cj1AA+QajmRenSwYh/8g5RjvZ+1Kfi4azWkbk5rVJMY=;
        b=l4ouuUm+RZKjkDPNsYC7yAU3y2YJaYqK7fRoN7KnpfYrRUJXIdaNeqJraLDSLj+Hsq
         DoCjcYHNOPx4wQ8IoFKBY8oXq+gP6wlJ5S/+4ZJRUZe7F+op3/uY4m7z1/B2VnkOgD5m
         t2uIGFEk+6v+lJhjcexw3MSjbYwv9XzgPyuSk2nG7+0gRoCIhPcpMUQxBQ0CXJeMW7Bq
         Pj3YcVraJh5zWRzVM0CLCI1eEwZtk2hlU89S/EKMlfBzmwOSdLrkBcQe9JB7QgVZ03Q+
         zeks5A6Odx9k1ILsGYWcElYbzhHbp57Sf/ChsiYlNzHYRcSM26Z/AA8OZ33WJhBEDIgd
         p68A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cj1AA+QajmRenSwYh/8g5RjvZ+1Kfi4azWkbk5rVJMY=;
        b=RqJjg0vDSGd+pH9i/GIA51KQIQ43oQOmqGTKL587HqLZVzyApUEVqEPOFvTeU9E4cT
         zMAaQyNqJ26NeURuKbNQStEcYlM3oq7qtU/2xyxkDokmg3fzESf0r+GQ8jUHlqnhw6SY
         0X8JOqkLotevJkhYjoGlYtW0xULzeCyuBmZyeywnXFIRPXufF2BoI8YsnP5hGDd1NU1c
         CzZ0jggLx0cXEXS5uU90QUs3GnEoBNzo9ph6IU/Iow9H/VPc4yTqj4ezKnBnkNb9eksS
         /apAmMOFBfLMJG6B9a3nv6KkWoUkOzHDUBquCBhrxv5HWBwbkfcSqkXIY3jnel/j30n8
         y/3g==
X-Gm-Message-State: AOAM532P7ig1sqa9gFyJVnepEgLMoQqnOEZSQQYoPkkVhEvhc0Iv3R4G
        xE0cmqlICMOmVDu/vAMUAKXy39NVH3crvy1/WdvG/g==
X-Google-Smtp-Source: ABdhPJwiFhCYXoqV5R1BrUk4cFAFcu/0v8ywSpRptTToyE31Qt/lRbVUr0NbxhMSfFzTA3SQmpsU/BUW05YZkVeyxhw=
X-Received: by 2002:a1c:5f41:: with SMTP id t62mr17178624wmb.134.1595768248343;
 Sun, 26 Jul 2020 05:57:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200724085441.1514-1-jiangyifei@huawei.com> <20200724085441.1514-3-jiangyifei@huawei.com>
In-Reply-To: <20200724085441.1514-3-jiangyifei@huawei.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Sun, 26 Jul 2020 18:27:16 +0530
Message-ID: <CAAhSdy3q3tNUqSxnFy2tdmXOLJZjt4rMAZirZh88-0BXT7-X1g@mail.gmail.com>
Subject: Re: [RFC 2/2] RISC-V: KVM: read\write kernel mmio device support
To:     Yifei Jiang <jiangyifei@huawei.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup.patel@wdc.com>,
        Atish Patra <atish.patra@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "Zhangxiaofeng (F)" <victor.zhangxiaofeng@huawei.com>,
        wu.wubin@huawei.com,
        Zhanghailiang <zhang.zhanghailiang@huawei.com>,
        "dengkai (A)" <dengkai1@huawei.com>, limingwang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 24, 2020 at 2:25 PM Yifei Jiang <jiangyifei@huawei.com> wrote:
>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Mingwang Li <limingwang@huawei.com>
> ---
>  arch/riscv/kvm/vcpu_exit.c | 38 ++++++++++++++++++++++++++++++++------
>  1 file changed, 32 insertions(+), 6 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
> index e97ba96cb0ae..448f11179fa8 100644
> --- a/arch/riscv/kvm/vcpu_exit.c
> +++ b/arch/riscv/kvm/vcpu_exit.c
> @@ -191,6 +191,8 @@ static int virtual_inst_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  static int emulate_load(struct kvm_vcpu *vcpu, struct kvm_run *run,
>                         unsigned long fault_addr, unsigned long htinst)
>  {
> +       int ret;
> +       u8 data_buf[8];
>         unsigned long insn;
>         int shift = 0, len = 0;
>         struct kvm_cpu_trap utrap = { 0 };
> @@ -272,19 +274,32 @@ static int emulate_load(struct kvm_vcpu *vcpu, struct kvm_run *run,
>         vcpu->arch.mmio_decode.len = len;
>         vcpu->arch.mmio_decode.return_handled = 0;
>
> -       /* Exit to userspace for MMIO emulation */
> -       vcpu->stat.mmio_exit_user++;
> -       run->exit_reason = KVM_EXIT_MMIO;
> +       ret = kvm_io_bus_read(vcpu, KVM_MMIO_BUS, fault_addr, len,
> +                                                 data_buf);
> +

Move "ret = kvm_io_bus_read()" just before "if (!ret)".

>         run->mmio.is_write = false;
>         run->mmio.phys_addr = fault_addr;
>         run->mmio.len = len;
>
> +       if (!ret) {
> +               /* We handled the access successfully in the kernel. */
> +               memcpy(run->mmio.data, data_buf, len);
> +               vcpu->stat.mmio_exit_kernel++;
> +               kvm_riscv_vcpu_mmio_return(vcpu, run);
> +               return 1;
> +       }
> +
> +       /* Exit to userspace for MMIO emulation */
> +       vcpu->stat.mmio_exit_user++;
> +       run->exit_reason = KVM_EXIT_MMIO;
> +
>         return 0;
>  }
>
>  static int emulate_store(struct kvm_vcpu *vcpu, struct kvm_run *run,
>                          unsigned long fault_addr, unsigned long htinst)
>  {
> +       int ret;
>         u8 data8;
>         u16 data16;
>         u32 data32;
> @@ -378,13 +393,24 @@ static int emulate_store(struct kvm_vcpu *vcpu, struct kvm_run *run,
>                 return -ENOTSUPP;
>         };
>
> -       /* Exit to userspace for MMIO emulation */
> -       vcpu->stat.mmio_exit_user++;
> -       run->exit_reason = KVM_EXIT_MMIO;
> +       ret = kvm_io_bus_write(vcpu, KVM_MMIO_BUS, fault_addr, len,
> +                                                  run->mmio.data);
> +

Same as above.

Move "ret = kvm_io_bus_write()" just before "if (!ret) {"

>         run->mmio.is_write = true;
>         run->mmio.phys_addr = fault_addr;
>         run->mmio.len = len;
>
> +       if (!ret) {
> +               /* We handled the access successfully in the kernel. */
> +               vcpu->stat.mmio_exit_kernel++;
> +               kvm_riscv_vcpu_mmio_return(vcpu, run);
> +               return 1;
> +       }
> +
> +       /* Exit to userspace for MMIO emulation */
> +       vcpu->stat.mmio_exit_user++;
> +       run->exit_reason = KVM_EXIT_MMIO;
> +
>         return 0;
>  }
>
> --
> 2.19.1
>
>

Regards,
Anup
