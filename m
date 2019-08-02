Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA017EFC3
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 11:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404554AbfHBJBv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 05:01:51 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34873 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728559AbfHBJBv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 05:01:51 -0400
Received: by mail-wm1-f66.google.com with SMTP id l2so65557896wmg.0
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2019 02:01:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QOtgP+1RY1QtN6WT4QHkjPhGkfEsydxRR6ux+horNPY=;
        b=hZIbjXgi9DwvLKswPAZzich0b6a7L7newnN/8Da9jCayW6IvrFC2ln6C0c+RWES37s
         oMpjKuSWAKYepx0eRrnBu13r391VjPIX9oBF27jxc/UuAGQnJ9P2wp/uJCASX3QwLKJI
         wB0lnlbnhJnL+jS/NVmNIqM47vTstefHZmiEnjMKR7X9wxayidvAjgybFQXfx5m/Ytwh
         MiPqPWR8NfNNy11mQzj6+LCBSk0QDzWd4EGo78LlcjleYfBq6F1u+N1/woIjNY+35Tmg
         BIddHgFPyxSS1UytVZJFdpSFitq8rPcAJPxxCnI08NqmglldkxvjIT/40Q4tLxhfhkS0
         s9qQ==
X-Gm-Message-State: APjAAAUr20wrcmUQlMQI3xAfBi5mJIoKuTLfWtCBDbsws83kAa11TWnN
        fMoB5jnJMS90pttZ01mri6xb7Q==
X-Google-Smtp-Source: APXvYqzq25yQIa1bgv7HJCnkd7BZAp1jtHjdGSOymg909tJvajWzsC0WjBHYpUPZ4KXiwMZr7mdhzA==
X-Received: by 2002:a05:600c:2388:: with SMTP id m8mr3344920wma.23.1564736507947;
        Fri, 02 Aug 2019 02:01:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4013:e920:9388:c3ff? ([2001:b07:6468:f312:4013:e920:9388:c3ff])
        by smtp.gmail.com with ESMTPSA id s10sm90218243wmf.8.2019.08.02.02.01.46
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 02:01:47 -0700 (PDT)
Subject: Re: [RFC PATCH v2 04/19] RISC-V: Add initial skeletal KVM support
To:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Radim K <rkrcmar@redhat.com>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190802074620.115029-1-anup.patel@wdc.com>
 <20190802074620.115029-5-anup.patel@wdc.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <9f30d2b6-fa2c-22ff-e597-b9fbd1c700ff@redhat.com>
Date:   Fri, 2 Aug 2019 11:01:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190802074620.115029-5-anup.patel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/08/19 09:47, Anup Patel wrote:
> +static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
> +{
> +	if (kvm_request_pending(vcpu)) {
> +		/* TODO: */
> +
> +		/*
> +		 * Clear IRQ_PENDING requests that were made to guarantee
> +		 * that a VCPU sees new virtual interrupts.
> +		 */
> +		kvm_check_request(KVM_REQ_IRQ_PENDING, vcpu);
> +	}
> +}

This kvm_check_request can go away (as it does in patch 6).

> +int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> +{
> +	int ret;
> +	unsigned long scause, stval;

You need to wrap this with srcu_read_lock/srcu_read_unlock, otherwise
stage2_page_fault can access freed memslot arrays.  (ARM doesn't have
this issue because it does not have to decode instructions on MMIO faults).

That is,

	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);

> +	/* Process MMIO value returned from user-space */
> +	if (run->exit_reason == KVM_EXIT_MMIO) {
> +		ret = kvm_riscv_vcpu_mmio_return(vcpu, vcpu->run);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	if (run->immediate_exit)
> +		return -EINTR;
> +
> +	vcpu_load(vcpu);
> +
> +	kvm_sigset_activate(vcpu);
> +
> +	ret = 1;
> +	run->exit_reason = KVM_EXIT_UNKNOWN;
> +	while (ret > 0) {
> +		/* Check conditions before entering the guest */
> +		cond_resched();
> +
> +		kvm_riscv_check_vcpu_requests(vcpu);
> +
> +		preempt_disable();
> +
> +		local_irq_disable();
> +
> +		/*
> +		 * Exit if we have a signal pending so that we can deliver
> +		 * the signal to user space.
> +		 */
> +		if (signal_pending(current)) {
> +			ret = -EINTR;
> +			run->exit_reason = KVM_EXIT_INTR;
> +		}

Add an srcu_read_unlock here (and then the smp_store_mb can become
smp_mb__after_srcu_read_unlock + WRITE_ONCE).


> +		/*
> +		 * Ensure we set mode to IN_GUEST_MODE after we disable
> +		 * interrupts and before the final VCPU requests check.
> +		 * See the comment in kvm_vcpu_exiting_guest_mode() and
> +		 * Documentation/virtual/kvm/vcpu-requests.rst
> +		 */
> +		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
> +
> +		if (ret <= 0 ||
> +		    kvm_request_pending(vcpu)) {
> +			vcpu->mode = OUTSIDE_GUEST_MODE;
> +			local_irq_enable();
> +			preempt_enable();
> +			continue;
> +		}
> +
> +		guest_enter_irqoff();
> +
> +		__kvm_riscv_switch_to(&vcpu->arch);
> +
> +		vcpu->mode = OUTSIDE_GUEST_MODE;
> +		vcpu->stat.exits++;
> +
> +		/* Save SCAUSE and STVAL because we might get an interrupt
> +		 * between __kvm_riscv_switch_to() and local_irq_enable()
> +		 * which can potentially overwrite SCAUSE and STVAL.
> +		 */
> +		scause = csr_read(CSR_SCAUSE);
> +		stval = csr_read(CSR_STVAL);
> +
> +		/*
> +		 * We may have taken a host interrupt in VS/VU-mode (i.e.
> +		 * while executing the guest). This interrupt is still
> +		 * pending, as we haven't serviced it yet!
> +		 *
> +		 * We're now back in HS-mode with interrupts disabled
> +		 * so enabling the interrupts now will have the effect
> +		 * of taking the interrupt again, in HS-mode this time.
> +		 */
> +		local_irq_enable();
> +
> +		/*
> +		 * We do local_irq_enable() before calling guest_exit() so
> +		 * that if a timer interrupt hits while running the guest
> +		 * we account that tick as being spent in the guest. We
> +		 * enable preemption after calling guest_exit() so that if
> +		 * we get preempted we make sure ticks after that is not
> +		 * counted as guest time.
> +		 */
> +		guest_exit();
> +
> +		preempt_enable();

And another srcu_read_lock here.  Using vcpu->srcu_idx instead of a
local variable also allows system_opcode_insn to wrap kvm_vcpu_block
with a srcu_read_unlock/srcu_read_lock pair.

> +		ret = kvm_riscv_vcpu_exit(vcpu, run, scause, stval);
> +	}
> +
> +	kvm_sigset_deactivate(vcpu);

And finally srcu_read_unlock here.

Paolo

> +	vcpu_put(vcpu);
> +	return ret;
> +}
> diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
> new file mode 100644
> index 000000000000..e4d7c8f0807a
> --- /dev/null
> +++ b/arch/riscv/kvm/vcpu_exit.c
> @@ -0,0 +1,35 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2019 Western Digital Corporation or its affiliates.
> + *
> + * Authors:
> + *     Anup Patel <anup.patel@wdc.com>
> + */
> +
> +#include <linux/errno.h>
> +#include <linux/err.h>
> +#include <linux/kvm_host.h>
> +
> +/**
> + * kvm_riscv_vcpu_mmio_return -- Handle MMIO loads after user space emulation
> + *			     or in-kernel IO emulation
> + *
> + * @vcpu: The VCPU pointer
> + * @run:  The VCPU run struct containing the mmio data
> + */
> +int kvm_riscv_vcpu_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
> +{
> +	/* TODO: */
> +	return 0;
> +}
> +
> +/*
> + * Return > 0 to return to guest, < 0 on error, 0 (and set exit_reason) on
> + * proper exit to userspace.
> + */
> +int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
> +			unsigned long scause, unsigned long stval)
> +{
> +	/* TODO: */
> +	return 0;
> +}
> diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
> new file mode 100644
> index 000000000000..ac0211820521
> --- /dev/null
> +++ b/arch/riscv/kvm/vm.c
> @@ -0,0 +1,79 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2019 Western Digital Corporation or its affiliates.
> + *
> + * Authors:
> + *     Anup Patel <anup.patel@wdc.com>
> + */
> +
> +#include <linux/errno.h>
> +#include <linux/err.h>
> +#include <linux/module.h>
> +#include <linux/uaccess.h>
> +#include <linux/kvm_host.h>
> +
> +int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
> +{
> +	/* TODO: To be added later. */
> +	return -ENOTSUPP;
> +}
> +
> +int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> +{
> +	int r;
> +
> +	r = kvm_riscv_stage2_alloc_pgd(kvm);
> +	if (r)
> +		return r;
> +
> +	return 0;
> +}
> +
> +void kvm_arch_destroy_vm(struct kvm *kvm)
> +{
> +	int i;
> +
> +	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
> +		if (kvm->vcpus[i]) {
> +			kvm_arch_vcpu_destroy(kvm->vcpus[i]);
> +			kvm->vcpus[i] = NULL;
> +		}
> +	}
> +}
> +
> +int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> +{
> +	int r;
> +
> +	switch (ext) {
> +	case KVM_CAP_DEVICE_CTRL:
> +	case KVM_CAP_USER_MEMORY:
> +	case KVM_CAP_DESTROY_MEMORY_REGION_WORKS:
> +	case KVM_CAP_ONE_REG:
> +	case KVM_CAP_READONLY_MEM:
> +	case KVM_CAP_MP_STATE:
> +	case KVM_CAP_IMMEDIATE_EXIT:
> +		r = 1;
> +		break;
> +	case KVM_CAP_NR_VCPUS:
> +		r = num_online_cpus();
> +		break;
> +	case KVM_CAP_MAX_VCPUS:
> +		r = KVM_MAX_VCPUS;
> +		break;
> +	case KVM_CAP_NR_MEMSLOTS:
> +		r = KVM_USER_MEM_SLOTS;
> +		break;
> +	default:
> +		r = 0;
> +		break;
> +	}
> +
> +	return r;
> +}
> +
> +long kvm_arch_vm_ioctl(struct file *filp,
> +		       unsigned int ioctl, unsigned long arg)
> +{
> +	return -EINVAL;
> +}
> 

