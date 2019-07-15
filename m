Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 579F269AF0
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 20:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729791AbfGOSjP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 14:39:15 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41131 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729277AbfGOSjP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 14:39:15 -0400
Received: by mail-wr1-f68.google.com with SMTP id c2so15000453wrm.8
        for <kvm@vger.kernel.org>; Mon, 15 Jul 2019 11:39:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TktIcPzdYgxt1tcMK8awiyl2KH5a2rCru6fqp+AQ4Pg=;
        b=pTDY2aBBUS9m/NkiJZew1LRrcTwDmRTGGNYePR8e8ibiHycCqV20j3Skpm8R6KeAtQ
         G5MzMVdgaUpmVO1j/zekribql/mDJY16mpKTW5Vzl/xWYQDdGySg62BFb/WzrNKQ7xd1
         1TicyI5FJL5Mtr+hQu3ZefWYEodZ8eiCLTSXfht21elJS7+ZLmGGee5fZYclrU9HlppY
         l5ORFOR0waPugE7QeKYalq2qHS/wupNrMRhI1qghZ5dJStS1g+KP2Kc29QnRoufCP7+I
         DcNg79Y85Pnl3HPMnAG9b7Rxd+QGJA8QRZ8e14WhYro5HKH0GdHdUhvjLOtIn/3gp6Pv
         Cm/w==
X-Gm-Message-State: APjAAAX4tKtZ61UwWvrhURN1bOId2HIqrbfvjZEIRorlUIGEgJko/l+i
        XXVY4HKDBhL/DkWZ/ACl6dRn6bz1Uds=
X-Google-Smtp-Source: APXvYqxVf+CvC/eB90uTHqcEBcxUxerWDPZaWVFbFZFHBwWcKJ4PeoAWCvyebjgTqiUSujc0hm9Ljw==
X-Received: by 2002:adf:f544:: with SMTP id j4mr30672241wrp.150.1563215951356;
        Mon, 15 Jul 2019 11:39:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:bca4:e0e3:13b4:ec4? ([2001:b07:6468:f312:bca4:e0e3:13b4:ec4])
        by smtp.gmail.com with ESMTPSA id a6sm13125843wmj.15.2019.07.15.11.39.10
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jul 2019 11:39:10 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: ioapic and apic debug macros cleanup
To:     Yi Wang <wang.yi59@zte.com.cn>
Cc:     rkrcmar@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        up2wing@gmail.com, wang.liang82@zte.com.cn
References: <1562346528-840-1-git-send-email-wang.yi59@zte.com.cn>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <cf360184-fdf6-bd64-ae17-71aabd2b1472@redhat.com>
Date:   Mon, 15 Jul 2019 20:39:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1562346528-840-1-git-send-email-wang.yi59@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/07/19 19:08, Yi Wang wrote:
> The ioapic_debug and apic_debug have been not used
> for years, and kvm tracepoints are enough for debugging,
> so remove them as Paolo suggested.
> 
> However, there may be something wrong when pv evi get/put
> user, so it's better to retain some log there.
> 
> Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
> ---
>  arch/x86/kvm/ioapic.c | 15 --------
>  arch/x86/kvm/lapic.c  | 98 +++++----------------------------------------------
>  2 files changed, 9 insertions(+), 104 deletions(-)
> 
> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
> index 1add1bc..d859ae8 100644
> --- a/arch/x86/kvm/ioapic.c
> +++ b/arch/x86/kvm/ioapic.c
> @@ -45,11 +45,6 @@
>  #include "lapic.h"
>  #include "irq.h"
>  
> -#if 0
> -#define ioapic_debug(fmt,arg...) printk(KERN_WARNING fmt,##arg)
> -#else
> -#define ioapic_debug(fmt, arg...)
> -#endif
>  static int ioapic_service(struct kvm_ioapic *vioapic, int irq,
>  		bool line_status);
>  
> @@ -294,7 +289,6 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
>  	default:
>  		index = (ioapic->ioregsel - 0x10) >> 1;
>  
> -		ioapic_debug("change redir index %x val %x\n", index, val);
>  		if (index >= IOAPIC_NUM_PINS)
>  			return;
>  		e = &ioapic->redirtbl[index];
> @@ -343,12 +337,6 @@ static int ioapic_service(struct kvm_ioapic *ioapic, int irq, bool line_status)
>  	    entry->fields.remote_irr))
>  		return -1;
>  
> -	ioapic_debug("dest=%x dest_mode=%x delivery_mode=%x "
> -		     "vector=%x trig_mode=%x\n",
> -		     entry->fields.dest_id, entry->fields.dest_mode,
> -		     entry->fields.delivery_mode, entry->fields.vector,
> -		     entry->fields.trig_mode);
> -
>  	irqe.dest_id = entry->fields.dest_id;
>  	irqe.vector = entry->fields.vector;
>  	irqe.dest_mode = entry->fields.dest_mode;
> @@ -515,7 +503,6 @@ static int ioapic_mmio_read(struct kvm_vcpu *vcpu, struct kvm_io_device *this,
>  	if (!ioapic_in_range(ioapic, addr))
>  		return -EOPNOTSUPP;
>  
> -	ioapic_debug("addr %lx\n", (unsigned long)addr);
>  	ASSERT(!(addr & 0xf));	/* check alignment */
>  
>  	addr &= 0xff;
> @@ -558,8 +545,6 @@ static int ioapic_mmio_write(struct kvm_vcpu *vcpu, struct kvm_io_device *this,
>  	if (!ioapic_in_range(ioapic, addr))
>  		return -EOPNOTSUPP;
>  
> -	ioapic_debug("ioapic_mmio_write addr=%p len=%d val=%p\n",
> -		     (void*)addr, len, val);
>  	ASSERT(!(addr & 0xf));	/* check alignment */
>  
>  	switch (len) {
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 4dabc31..0f3b57e 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -52,9 +52,6 @@
>  #define PRIu64 "u"
>  #define PRIo64 "o"
>  
> -/* #define apic_debug(fmt,arg...) printk(KERN_WARNING fmt,##arg) */
> -#define apic_debug(fmt, arg...) do {} while (0)
> -
>  /* 14 is the version for Xeon and Pentium 8.4.8*/
>  #define APIC_VERSION			(0x14UL | ((KVM_APIC_LVT_NUM - 1) << 16))
>  #define LAPIC_MMIO_LENGTH		(1 << 12)
> @@ -631,7 +628,7 @@ static bool pv_eoi_get_pending(struct kvm_vcpu *vcpu)
>  {
>  	u8 val;
>  	if (pv_eoi_get_user(vcpu, &val) < 0)
> -		apic_debug("Can't read EOI MSR value: 0x%llx\n",
> +		printk(KERN_WARNING "Can't read EOI MSR value: 0x%llx\n",
>  			   (unsigned long long)vcpu->arch.pv_eoi.msr_val);
>  	return val & 0x1;
>  }
> @@ -639,7 +636,7 @@ static bool pv_eoi_get_pending(struct kvm_vcpu *vcpu)
>  static void pv_eoi_set_pending(struct kvm_vcpu *vcpu)
>  {
>  	if (pv_eoi_put_user(vcpu, KVM_PV_EOI_ENABLED) < 0) {
> -		apic_debug("Can't set EOI MSR value: 0x%llx\n",
> +		printk(KERN_WARNING "Can't set EOI MSR value: 0x%llx\n",
>  			   (unsigned long long)vcpu->arch.pv_eoi.msr_val);
>  		return;
>  	}
> @@ -649,7 +646,7 @@ static void pv_eoi_set_pending(struct kvm_vcpu *vcpu)
>  static void pv_eoi_clr_pending(struct kvm_vcpu *vcpu)
>  {
>  	if (pv_eoi_put_user(vcpu, KVM_PV_EOI_DISABLED) < 0) {
> -		apic_debug("Can't clear EOI MSR value: 0x%llx\n",
> +		printk(KERN_WARNING "Can't clear EOI MSR value: 0x%llx\n",
>  			   (unsigned long long)vcpu->arch.pv_eoi.msr_val);
>  		return;
>  	}
> @@ -683,9 +680,6 @@ static bool __apic_update_ppr(struct kvm_lapic *apic, u32 *new_ppr)
>  	else
>  		ppr = isrv & 0xf0;
>  
> -	apic_debug("vlapic %p, ppr 0x%x, isr 0x%x, isrv 0x%x",
> -		   apic, ppr, isr, isrv);
> -
>  	*new_ppr = ppr;
>  	if (old_ppr != ppr)
>  		kvm_lapic_set_reg(apic, APIC_PROCPRI, ppr);
> @@ -762,8 +756,6 @@ static bool kvm_apic_match_logical_addr(struct kvm_lapic *apic, u32 mda)
>  		return ((logical_id >> 4) == (mda >> 4))
>  		       && (logical_id & mda & 0xf) != 0;
>  	default:
> -		apic_debug("Bad DFR vcpu %d: %08x\n",
> -			   apic->vcpu->vcpu_id, kvm_lapic_get_reg(apic, APIC_DFR));
>  		return false;
>  	}
>  }
> @@ -802,10 +794,6 @@ bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
>  	struct kvm_lapic *target = vcpu->arch.apic;
>  	u32 mda = kvm_apic_mda(vcpu, dest, source, target);
>  
> -	apic_debug("target %p, source %p, dest 0x%x, "
> -		   "dest_mode 0x%x, short_hand 0x%x\n",
> -		   target, source, dest, dest_mode, short_hand);
> -
>  	ASSERT(target);
>  	switch (short_hand) {
>  	case APIC_DEST_NOSHORT:
> @@ -820,8 +808,6 @@ bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
>  	case APIC_DEST_ALLBUT:
>  		return target != source;
>  	default:
> -		apic_debug("kvm: apic: Bad dest shorthand value %x\n",
> -			   short_hand);
>  		return false;
>  	}
>  }
> @@ -1097,15 +1083,10 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
>  			smp_wmb();
>  			kvm_make_request(KVM_REQ_EVENT, vcpu);
>  			kvm_vcpu_kick(vcpu);
> -		} else {
> -			apic_debug("Ignoring de-assert INIT to vcpu %d\n",
> -				   vcpu->vcpu_id);
>  		}
>  		break;
>  
>  	case APIC_DM_STARTUP:
> -		apic_debug("SIPI to vcpu %d vector 0x%02x\n",
> -			   vcpu->vcpu_id, vector);
>  		result = 1;
>  		apic->sipi_vector = vector;
>  		/* make sure sipi_vector is visible for the receiver */
> @@ -1223,14 +1204,6 @@ static void apic_send_ipi(struct kvm_lapic *apic)
>  
>  	trace_kvm_apic_ipi(icr_low, irq.dest_id);
>  
> -	apic_debug("icr_high 0x%x, icr_low 0x%x, "
> -		   "short_hand 0x%x, dest 0x%x, trig_mode 0x%x, level 0x%x, "
> -		   "dest_mode 0x%x, delivery_mode 0x%x, vector 0x%x, "
> -		   "msi_redir_hint 0x%x\n",
> -		   icr_high, icr_low, irq.shorthand, irq.dest_id,
> -		   irq.trig_mode, irq.level, irq.dest_mode, irq.delivery_mode,
> -		   irq.vector, irq.msi_redir_hint);
> -
>  	kvm_irq_delivery_to_apic(apic->vcpu->kvm, apic, &irq, NULL);
>  }
>  
> @@ -1284,7 +1257,6 @@ static u32 __apic_read(struct kvm_lapic *apic, unsigned int offset)
>  
>  	switch (offset) {
>  	case APIC_ARBPRI:
> -		apic_debug("Access APIC ARBPRI register which is for P6\n");
>  		break;
>  
>  	case APIC_TMCCT:	/* Timer CCR */
> @@ -1321,17 +1293,11 @@ int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
>  	/* this bitmask has a bit cleared for each reserved register */
>  	static const u64 rmask = 0x43ff01ffffffe70cULL;
>  
> -	if ((alignment + len) > 4) {
> -		apic_debug("KVM_APIC_READ: alignment error %x %d\n",
> -			   offset, len);
> +	if ((alignment + len) > 4)
>  		return 1;
> -	}
>  
> -	if (offset > 0x3f0 || !(rmask & (1ULL << (offset >> 4)))) {
> -		apic_debug("KVM_APIC_READ: read reserved register %x\n",
> -			   offset);
> +	if (offset > 0x3f0 || !(rmask & (1ULL << (offset >> 4))))
>  		return 1;
> -	}
>  
>  	result = __apic_read(apic, offset & ~0xf);
>  
> @@ -1389,9 +1355,6 @@ static void update_divide_count(struct kvm_lapic *apic)
>  	tmp1 = tdcr & 0xf;
>  	tmp2 = ((tmp1 & 0x3) | ((tmp1 & 0x8) >> 1)) + 1;
>  	apic->divide_count = 0x1 << (tmp2 & 0x7);
> -
> -	apic_debug("timer divide count is 0x%x\n",
> -				   apic->divide_count);
>  }
>  
>  static void limit_periodic_timer_frequency(struct kvm_lapic *apic)
> @@ -1616,16 +1579,6 @@ static bool set_target_expiration(struct kvm_lapic *apic)
>  
>  	limit_periodic_timer_frequency(apic);
>  
> -	apic_debug("%s: bus cycle is %" PRId64 "ns, now 0x%016"
> -		   PRIx64 ", "
> -		   "timer initial count 0x%x, period %lldns, "
> -		   "expire @ 0x%016" PRIx64 ".\n", __func__,
> -		   APIC_BUS_CYCLE_NS, ktime_to_ns(now),
> -		   kvm_lapic_get_reg(apic, APIC_TMICT),
> -		   apic->lapic_timer.period,
> -		   ktime_to_ns(ktime_add_ns(now,
> -				apic->lapic_timer.period)));
> -
>  	apic->lapic_timer.tscdeadline = kvm_read_l1_tsc(apic->vcpu, tscl) +
>  		nsec_to_cycles(apic->vcpu, apic->lapic_timer.period);
>  	apic->lapic_timer.target_expiration = ktime_add_ns(now, apic->lapic_timer.period);
> @@ -1828,8 +1781,6 @@ static void apic_manage_nmi_watchdog(struct kvm_lapic *apic, u32 lvt0_val)
>  	if (apic->lvt0_in_nmi_mode != lvt0_in_nmi_mode) {
>  		apic->lvt0_in_nmi_mode = lvt0_in_nmi_mode;
>  		if (lvt0_in_nmi_mode) {
> -			apic_debug("Receive NMI setting on APIC_LVT0 "
> -				   "for cpu %d\n", apic->vcpu->vcpu_id);
>  			atomic_inc(&apic->vcpu->kvm->arch.vapics_in_nmi_mode);
>  		} else
>  			atomic_dec(&apic->vcpu->kvm->arch.vapics_in_nmi_mode);
> @@ -1943,8 +1894,6 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
>  	case APIC_TDCR: {
>  		uint32_t old_divisor = apic->divide_count;
>  
> -		if (val & 4)
> -			apic_debug("KVM_WRITE:TDCR %x\n", val);
>  		kvm_lapic_set_reg(apic, APIC_TDCR, val);
>  		update_divide_count(apic);
>  		if (apic->divide_count != old_divisor &&
> @@ -1956,10 +1905,8 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
>  		break;
>  	}
>  	case APIC_ESR:
> -		if (apic_x2apic_mode(apic) && val != 0) {
> -			apic_debug("KVM_WRITE:ESR not zero %x\n", val);
> +		if (apic_x2apic_mode(apic) && val != 0)
>  			ret = 1;
> -		}
>  		break;
>  
>  	case APIC_SELF_IPI:
> @@ -1972,8 +1919,7 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
>  		ret = 1;
>  		break;
>  	}
> -	if (ret)
> -		apic_debug("Local APIC Write to read-only register %x\n", reg);
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(kvm_lapic_reg_write);
> @@ -2001,19 +1947,11 @@ static int apic_mmio_write(struct kvm_vcpu *vcpu, struct kvm_io_device *this,
>  	 * 32/64/128 bits registers must be accessed thru 32 bits.
>  	 * Refer SDM 8.4.1
>  	 */
> -	if (len != 4 || (offset & 0xf)) {
> -		/* Don't shout loud, $infamous_os would cause only noise. */
> -		apic_debug("apic write: bad size=%d %lx\n", len, (long)address);
> +	if (len != 4 || (offset & 0xf))
>  		return 0;
> -	}
>  
>  	val = *(u32*)data;
>  
> -	/* too common printing */
> -	if (offset != APIC_EOI)
> -		apic_debug("%s: offset 0x%x with length 0x%x, and value is "
> -			   "0x%x\n", __func__, offset, len, val);
> -
>  	kvm_lapic_reg_write(apic, offset & 0xff0, val);
>  
>  	return 0;
> @@ -2146,11 +2084,6 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
>  	if ((value & MSR_IA32_APICBASE_ENABLE) &&
>  	     apic->base_address != APIC_DEFAULT_PHYS_BASE)
>  		pr_warn_once("APIC base relocation is unsupported by KVM");
> -
> -	/* with FSB delivery interrupt, we can restart APIC functionality */
> -	apic_debug("apic base msr is 0x%016" PRIx64 ", and base address is "
> -		   "0x%lx.\n", apic->vcpu->arch.apic_base, apic->base_address);
> -
>  }
>  
>  void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
> @@ -2161,8 +2094,6 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
>  	if (!apic)
>  		return;
>  
> -	apic_debug("%s\n", __func__);
> -
>  	/* Stop the timer in case it's a reset to an active apic */
>  	hrtimer_cancel(&apic->lapic_timer.timer);
>  
> @@ -2215,11 +2146,6 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
>  
>  	vcpu->arch.apic_arb_prio = 0;
>  	vcpu->arch.apic_attention = 0;
> -
> -	apic_debug("%s: vcpu=%p, id=0x%x, base_msr="
> -		   "0x%016" PRIx64 ", base_address=0x%0lx.\n", __func__,
> -		   vcpu, kvm_lapic_get_reg(apic, APIC_ID),
> -		   vcpu->arch.apic_base, apic->base_address);
>  }
>  
>  /*
> @@ -2291,7 +2217,6 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
>  	struct kvm_lapic *apic;
>  
>  	ASSERT(vcpu != NULL);
> -	apic_debug("apic_init %d\n", vcpu->vcpu_id);
>  
>  	apic = kzalloc(sizeof(*apic), GFP_KERNEL_ACCOUNT);
>  	if (!apic)
> @@ -2645,11 +2570,8 @@ int kvm_x2apic_msr_read(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
>  	if (!lapic_in_kernel(vcpu) || !apic_x2apic_mode(apic))
>  		return 1;
>  
> -	if (reg == APIC_DFR || reg == APIC_ICR2) {
> -		apic_debug("KVM_APIC_READ: read x2apic reserved register %x\n",
> -			   reg);
> +	if (reg == APIC_DFR || reg == APIC_ICR2)
>  		return 1;
> -	}
>  
>  	if (kvm_lapic_reg_read(apic, reg, 4, &low))
>  		return 1;
> @@ -2747,8 +2669,6 @@ void kvm_apic_accept_events(struct kvm_vcpu *vcpu)
>  		/* evaluate pending_events before reading the vector */
>  		smp_rmb();
>  		sipi_vector = apic->sipi_vector;
> -		apic_debug("vcpu %d received sipi with vector # %x\n",
> -			 vcpu->vcpu_id, sipi_vector);
>  		kvm_vcpu_deliver_sipi_vector(vcpu, sipi_vector);
>  		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
>  	}
> 

Queued, thanks.

Paolo
