Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC82489064
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 07:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235027AbiAJGwx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 01:52:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235016AbiAJGww (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 01:52:52 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D69FC06173F
        for <kvm@vger.kernel.org>; Sun,  9 Jan 2022 22:52:52 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id o20so4037992ill.0
        for <kvm@vger.kernel.org>; Sun, 09 Jan 2022 22:52:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NsHy/5+QqdRkw9PRCfJEH7Dt5lwaLVOXuuF/YTlBNDo=;
        b=i7xiKxfaUBWmIoZobYONW7nX9gl4AMWo6xkTTxlqHPo2S/1OY7xqIQouMJaI/xvI8i
         nYXOeFw5G3mggy++oBVY7JyKQ5nzFMiS6M3N2tQgfiM5+rn3C9UkbZZKFty0tMmvFuXG
         DhqDJx+CK9MEHv53jkN485g5iHjq4pnSLnJPs51tKQu+/m0Iyo3iPx+hJoWKPtrKOFcX
         wp0Pz7Z8gZZIdf4Ap9TEaW7O8YlKU8HoNJlF4vAWpZXmWBgV6EtJcdNk33lHWcAipgpu
         liTIKAtds+c4x3/5deERulaAw4D+hsc5V877Nc78Dtl0gD7EabVfcvfUE0x2XvQXl6/o
         G5Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NsHy/5+QqdRkw9PRCfJEH7Dt5lwaLVOXuuF/YTlBNDo=;
        b=USB6OOAb4eW7S8cwGi+B1wvKt5I5xdPHNQZc7hyCScd8XlQh+SF7iJ41wHXxr1WFSQ
         AdUQquZixK9H26GgXL6i5sclkocAO0vKT0e136xHzwzYzjpTjbRJU/LQ99R3ioyw1BGD
         RTTZPjQm/3hRN0/mS1N3NHLoJFdrcjYQrrDvkwMF7mxzihqv5kZOAgxRHVizmoBSqcCH
         3/PxB+9jpYJ2mXSYPZi4oZ8ASwMAB+JhA5J/k7niK7w1Ws8F6g1fGXcnmJ8i6nztD/lo
         J4l3zK+2QWsx2jJNsrQ4lCUuWqs3SNw8evUiMagvJrUbinwGxC2UKS0y+GLNoOcqoZqL
         GPTQ==
X-Gm-Message-State: AOAM533WSlMCvLJrUhuyrIwVia5/h0jJTS9j+imT83h+o/ugOpIyPNHu
        88gBeL4purLj/caUZOXRF9NvIjpDNpHp0K9QRRI=
X-Google-Smtp-Source: ABdhPJygbB7GMhaRJpQW+IQxT6619gQbWeRuqgIM0D4IA7qith9Sd+meHXb0l4kT2zCQC/Dt+IO/QxRpx+PE1z+nmOw=
X-Received: by 2002:a05:6e02:1806:: with SMTP id a6mr32172727ilv.221.1641797571979;
 Sun, 09 Jan 2022 22:52:51 -0800 (PST)
MIME-Version: 1.0
References: <20220110013831.1594-1-jiangyifei@huawei.com> <20220110013831.1594-11-jiangyifei@huawei.com>
In-Reply-To: <20220110013831.1594-11-jiangyifei@huawei.com>
From:   Alistair Francis <alistair23@gmail.com>
Date:   Mon, 10 Jan 2022 16:52:25 +1000
Message-ID: <CAKmqyKNb4eDQVm4tMz1VJk006Y=X7tpuG8dAQ1Uuj02mHMMbKg@mail.gmail.com>
Subject: Re: [PATCH v4 10/12] target/riscv: Add kvm_riscv_get/put_regs_timer
To:     Yifei Jiang <jiangyifei@huawei.com>
Cc:     "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>,
        "open list:RISC-V" <qemu-riscv@nongnu.org>,
        kvm-riscv@lists.infradead.org,
        "open list:Overall" <kvm@vger.kernel.org>, libvir-list@redhat.com,
        Anup Patel <anup@brainfault.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Bin Meng <bin.meng@windriver.com>, fanliang@huawei.com,
        "Wubin (H)" <wu.wubin@huawei.com>, wanghaibin.wang@huawei.com,
        wanbo13@huawei.com, Mingwang Li <limingwang@huawei.com>,
        Anup Patel <anup.patel@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 10, 2022 at 11:54 AM Yifei Jiang via <qemu-devel@nongnu.org> wrote:
>
> Add kvm_riscv_get/put_regs_timer to synchronize virtual time context
> from KVM.
>
> To set register of RISCV_TIMER_REG(state) will occur a error from KVM
> on kvm_timer_state == 0. It's better to adapt in KVM, but it doesn't matter
> that adaping in QEMU.
>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Mingwang Li <limingwang@huawei.com>
> Reviewed-by: Anup Patel <anup.patel@wdc.com>

Acked-by: Alistair Francis <alistair.francis@wdc.com>

Alistair

> ---
>  target/riscv/cpu.h |  7 +++++
>  target/riscv/kvm.c | 72 ++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 79 insertions(+)
>
> diff --git a/target/riscv/cpu.h b/target/riscv/cpu.h
> index 5f54fae7cc..9eceded96c 100644
> --- a/target/riscv/cpu.h
> +++ b/target/riscv/cpu.h
> @@ -261,6 +261,13 @@ struct CPURISCVState {
>
>      hwaddr kernel_addr;
>      hwaddr fdt_addr;
> +
> +    /* kvm timer */
> +    bool kvm_timer_dirty;
> +    uint64_t kvm_timer_time;
> +    uint64_t kvm_timer_compare;
> +    uint64_t kvm_timer_state;
> +    uint64_t kvm_timer_frequency;
>  };
>
>  OBJECT_DECLARE_TYPE(RISCVCPU, RISCVCPUClass,
> diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
> index ded2a8c29d..b1f1d55f29 100644
> --- a/target/riscv/kvm.c
> +++ b/target/riscv/kvm.c
> @@ -40,6 +40,7 @@
>  #include "kvm_riscv.h"
>  #include "sbi_ecall_interface.h"
>  #include "chardev/char-fe.h"
> +#include "migration/migration.h"
>
>  static uint64_t kvm_riscv_reg_id(CPURISCVState *env, uint64_t type, uint64_t idx)
>  {
> @@ -64,6 +65,9 @@ static uint64_t kvm_riscv_reg_id(CPURISCVState *env, uint64_t type, uint64_t idx
>  #define RISCV_CSR_REG(env, name)  kvm_riscv_reg_id(env, KVM_REG_RISCV_CSR, \
>                   KVM_REG_RISCV_CSR_REG(name))
>
> +#define RISCV_TIMER_REG(env, name)  kvm_riscv_reg_id(env, KVM_REG_RISCV_TIMER, \
> +                 KVM_REG_RISCV_TIMER_REG(name))
> +
>  #define RISCV_FP_F_REG(env, idx)  kvm_riscv_reg_id(env, KVM_REG_RISCV_FP_F, idx)
>
>  #define RISCV_FP_D_REG(env, idx)  kvm_riscv_reg_id(env, KVM_REG_RISCV_FP_D, idx)
> @@ -84,6 +88,22 @@ static uint64_t kvm_riscv_reg_id(CPURISCVState *env, uint64_t type, uint64_t idx
>          } \
>      } while(0)
>
> +#define KVM_RISCV_GET_TIMER(cs, env, name, reg) \
> +    do { \
> +        int ret = kvm_get_one_reg(cs, RISCV_TIMER_REG(env, name), &reg); \
> +        if (ret) { \
> +            abort(); \
> +        } \
> +    } while(0)
> +
> +#define KVM_RISCV_SET_TIMER(cs, env, name, reg) \
> +    do { \
> +        int ret = kvm_set_one_reg(cs, RISCV_TIMER_REG(env, time), &reg); \
> +        if (ret) { \
> +            abort(); \
> +        } \
> +    } while (0)
> +
>  static int kvm_riscv_get_regs_core(CPUState *cs)
>  {
>      int ret = 0;
> @@ -235,6 +255,58 @@ static int kvm_riscv_put_regs_fp(CPUState *cs)
>      return ret;
>  }
>
> +static void kvm_riscv_get_regs_timer(CPUState *cs)
> +{
> +    CPURISCVState *env = &RISCV_CPU(cs)->env;
> +
> +    if (env->kvm_timer_dirty) {
> +        return;
> +    }
> +
> +    KVM_RISCV_GET_TIMER(cs, env, time, env->kvm_timer_time);
> +    KVM_RISCV_GET_TIMER(cs, env, compare, env->kvm_timer_compare);
> +    KVM_RISCV_GET_TIMER(cs, env, state, env->kvm_timer_state);
> +    KVM_RISCV_GET_TIMER(cs, env, frequency, env->kvm_timer_frequency);
> +
> +    env->kvm_timer_dirty = true;
> +}
> +
> +static void kvm_riscv_put_regs_timer(CPUState *cs)
> +{
> +    uint64_t reg;
> +    CPURISCVState *env = &RISCV_CPU(cs)->env;
> +
> +    if (!env->kvm_timer_dirty) {
> +        return;
> +    }
> +
> +    KVM_RISCV_SET_TIMER(cs, env, time, env->kvm_timer_time);
> +    KVM_RISCV_SET_TIMER(cs, env, compare, env->kvm_timer_compare);
> +
> +    /*
> +     * To set register of RISCV_TIMER_REG(state) will occur a error from KVM
> +     * on env->kvm_timer_state == 0, It's better to adapt in KVM, but it
> +     * doesn't matter that adaping in QEMU now.
> +     * TODO If KVM changes, adapt here.
> +     */
> +    if (env->kvm_timer_state) {
> +        KVM_RISCV_SET_TIMER(cs, env, state, env->kvm_timer_state);
> +    }
> +
> +    /*
> +     * For now, migration will not work between Hosts with different timer
> +     * frequency. Therefore, we should check whether they are the same here
> +     * during the migration.
> +     */
> +    if (migration_is_running(migrate_get_current()->state)) {
> +        KVM_RISCV_GET_TIMER(cs, env, frequency, reg);
> +        if (reg != env->kvm_timer_frequency) {
> +            error_report("Dst Hosts timer frequency != Src Hosts");
> +        }
> +    }
> +
> +    env->kvm_timer_dirty = false;
> +}
>
>  const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
>      KVM_CAP_LAST_INFO
> --
> 2.19.1
>
>
