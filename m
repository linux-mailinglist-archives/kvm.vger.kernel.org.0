Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 258CB388A9B
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 11:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344782AbhESJ0w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 05:26:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44420 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344811AbhESJ0v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 05:26:51 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14J952n4141949;
        Wed, 19 May 2021 09:25:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=rdrBqh1+38dvjdiPWGBE+DTr8HN3SKDKWRojemYDsg8=;
 b=MMAkzDh+aWcVvkveAnh2cLDytKeKDwEvU6b/1bBa4KPxB84xxo+vv4lvb0qW59P6KPIy
 WsJKrwzGv+0Rw/Qq8Of70284tMT9vDpE3cnfHFOy5ngfsY8fNlBZ0J8E6ernLOM6+KMH
 oTrgVPOO5TOpoHR/9oayLq4x3tK6jOdTCNqqjURpRLr6DUNamZehpxa+yG3rNDC/xkPK
 UvxsnwntvoXMS7liwgn5/i29VkzxJqiNGx2kO5kIJ31+4f79145XxK9hIUwxo3wBpQJ2
 +u0j1DSYWNKzrjTnjr2wOQSND9zOKgCpuZFOdSIZABGbYmlgY8JQ2pxgvsU+98lfHaxn YA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 38j68mgxfe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 09:25:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14J95rWF009467;
        Wed, 19 May 2021 09:25:05 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 38mechm6e3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 09:25:05 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 14J9Lvis123188;
        Wed, 19 May 2021 09:25:04 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 38mechm6c6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 09:25:04 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 14J9Owe8013238;
        Wed, 19 May 2021 09:24:58 GMT
Received: from kadam (/41.212.42.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 May 2021 02:24:57 -0700
Date:   Wed, 19 May 2021 12:24:41 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Anup Patel <anup.patel@wdc.com>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-staging@lists.linux.dev
Subject: Re: [PATCH v18 02/18] RISC-V: Add initial skeletal KVM support
Message-ID: <20210519092441.GQ1955@kadam>
References: <20210519033553.1110536-1-anup.patel@wdc.com>
 <20210519033553.1110536-3-anup.patel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519033553.1110536-3-anup.patel@wdc.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-ORIG-GUID: WFKODEbKdUYqjC4MuMXLdYlfJUXJ4yB5
X-Proofpoint-GUID: WFKODEbKdUYqjC4MuMXLdYlfJUXJ4yB5
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9988 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 suspectscore=0 clxscore=1011
 adultscore=0 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105190068
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 19, 2021 at 09:05:37AM +0530, Anup Patel wrote:
> +int kvm_arch_hardware_enable(void)
> +{
> +	unsigned long hideleg, hedeleg;
> +
> +	hedeleg = 0;
> +	hedeleg |= (1UL << EXC_INST_MISALIGNED);

You may as well use BIT_UL(EXC_INST_MISALIGNED) for all of these.
There is a Coccinelle script to convert these so please just make it
standard like everyone else.

> +	hedeleg |= (1UL << EXC_BREAKPOINT);
> +	hedeleg |= (1UL << EXC_SYSCALL);
> +	hedeleg |= (1UL << EXC_INST_PAGE_FAULT);
> +	hedeleg |= (1UL << EXC_LOAD_PAGE_FAULT);
> +	hedeleg |= (1UL << EXC_STORE_PAGE_FAULT);
> +	csr_write(CSR_HEDELEG, hedeleg);
> +
> +	hideleg = 0;
> +	hideleg |= (1UL << IRQ_VS_SOFT);
> +	hideleg |= (1UL << IRQ_VS_TIMER);
> +	hideleg |= (1UL << IRQ_VS_EXT);
> +	csr_write(CSR_HIDELEG, hideleg);
> +
> +	csr_write(CSR_HCOUNTEREN, -1UL);
> +
> +	csr_write(CSR_HVIP, 0);
> +
> +	return 0;
> +}
> +
> +void kvm_arch_hardware_disable(void)
> +{
> +	csr_write(CSR_HEDELEG, 0);
> +	csr_write(CSR_HIDELEG, 0);
> +}
> +
> +int kvm_arch_init(void *opaque)
> +{
> +	if (!riscv_isa_extension_available(NULL, h)) {
> +		kvm_info("hypervisor extension not available\n");
> +		return -ENODEV;
> +	}
> +
> +	if (sbi_spec_is_0_1()) {
> +		kvm_info("require SBI v0.2 or higher\n");
> +		return -ENODEV;
> +	}
> +
> +	if (sbi_probe_extension(SBI_EXT_RFENCE) <= 0) {

sbi_probe_extension() never returns zero.


> +		kvm_info("require SBI RFENCE extension\n");
> +		return -ENODEV;
> +	}
> +
> +	kvm_info("hypervisor extension available\n");
> +
> +	return 0;
> +}
> +
> +void kvm_arch_exit(void)
> +{
> +}
> +
> +static int riscv_kvm_init(void)
> +{
> +	return kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
> +}
> +module_init(riscv_kvm_init);


[ snip ]

> +int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> +{
> +	int ret;
> +	struct kvm_cpu_trap trap;
> +	struct kvm_run *run = vcpu->run;
> +
> +	vcpu->arch.srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
> +
> +	/* Process MMIO value returned from user-space */
> +	if (run->exit_reason == KVM_EXIT_MMIO) {
> +		ret = kvm_riscv_vcpu_mmio_return(vcpu, vcpu->run);
> +		if (ret) {
> +			srcu_read_unlock(&vcpu->kvm->srcu, vcpu->arch.srcu_idx);
> +			return ret;
> +		}
> +	}
> +
> +	if (run->immediate_exit) {
> +		srcu_read_unlock(&vcpu->kvm->srcu, vcpu->arch.srcu_idx);
> +		return -EINTR;
> +	}
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
> +
> +		/*
> +		 * Ensure we set mode to IN_GUEST_MODE after we disable
> +		 * interrupts and before the final VCPU requests check.
> +		 * See the comment in kvm_vcpu_exiting_guest_mode() and
> +		 * Documentation/virtual/kvm/vcpu-requests.rst
> +		 */
> +		vcpu->mode = IN_GUEST_MODE;
> +
> +		srcu_read_unlock(&vcpu->kvm->srcu, vcpu->arch.srcu_idx);
> +		smp_mb__after_srcu_read_unlock();
> +
> +		if (ret <= 0 ||

ret can never be == 0 at this point.

> +		    kvm_request_pending(vcpu)) {
> +			vcpu->mode = OUTSIDE_GUEST_MODE;
> +			local_irq_enable();
> +			preempt_enable();
> +			vcpu->arch.srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
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
> +		/*
> +		 * Save SCAUSE, STVAL, HTVAL, and HTINST because we might
> +		 * get an interrupt between __kvm_riscv_switch_to() and
> +		 * local_irq_enable() which can potentially change CSRs.
> +		 */
> +		trap.sepc = 0;
> +		trap.scause = csr_read(CSR_SCAUSE);
> +		trap.stval = csr_read(CSR_STVAL);
> +		trap.htval = csr_read(CSR_HTVAL);
> +		trap.htinst = csr_read(CSR_HTINST);
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
> +
> +		vcpu->arch.srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
> +
> +		ret = kvm_riscv_vcpu_exit(vcpu, run, &trap);
> +	}
> +
> +	kvm_sigset_deactivate(vcpu);
> +
> +	vcpu_put(vcpu);
> +
> +	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->arch.srcu_idx);
> +
> +	return ret;
> +}

regards,
dan carpenter
