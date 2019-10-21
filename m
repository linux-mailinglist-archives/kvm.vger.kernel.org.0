Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4389BDF439
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2019 19:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729726AbfJUR3A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 13:29:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40696 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726847AbfJUR2y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 13:28:54 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A722E83F51
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 17:28:53 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id i10so7671509wrb.20
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 10:28:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lvbEIhN+KLA5G34KXJDqPu7aWF/7PZQEg8je+IqEmF4=;
        b=FpYZNDdfcJaZRWUTaAuB0jehMU/iwIz5ZdJXhzNSMwp7kzRjoF98U14IxqTDt21aL7
         Kj142VuxSI0SUWES7YkwD39ayPYHjZH2ju4eMHeCAHdd49yRP3o+DeJnyltd4ASu322x
         +3d06bKV8uD0Jun6Hcufm+04i5XVkxQT/OFJZ1niXyv80zTkEYFI56BQrLi2y4k9R5sp
         IpjTNIl4TnCS9jM+iMIFiQ6ssmTzzZ7xG2P62Rgbo5BYi7uBhr9nl2SCdVpX09NXeh0C
         HYpO0qG/KphcHlYWtzZTKQ/1yXo9eWNZ4xX1yu2FjoKjrNLLrXFCnG7+QIEJ7hEN72jU
         Q7HQ==
X-Gm-Message-State: APjAAAW77y4FLJLr4WilZqmcPc4nhpIt3qv1bPPyJPTMTVq0PLGVhL2B
        j0dTQVQ47Dj1gWFkWnkm3JWwrD1zn1HC+8oIXFEImSY8QXM8rwOLqG410UnOz07I6uai+K5mbxP
        8fj3uoSEEjoJZ
X-Received: by 2002:a7b:c019:: with SMTP id c25mr1082380wmb.61.1571678930587;
        Mon, 21 Oct 2019 10:28:50 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxwIY/tsn9uA9I4YLp+kutIvQ8m7k5EbCTYWNNxxsB8jxi7jQKxpiLSQwcr3cxvYqwoNSRLVQ==
X-Received: by 2002:a7b:c019:: with SMTP id c25mr1082361wmb.61.1571678930237;
        Mon, 21 Oct 2019 10:28:50 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:847b:6afc:17c:89dd? ([2001:b07:6468:f312:847b:6afc:17c:89dd])
        by smtp.gmail.com with ESMTPSA id a17sm12276159wrx.84.2019.10.21.10.28.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2019 10:28:49 -0700 (PDT)
Subject: Re: [PATCH v9 19/22] RISC-V: KVM: Remove per-CPU vsip_shadow variable
To:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Radim K <rkrcmar@redhat.com>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20191016160649.24622-1-anup.patel@wdc.com>
 <20191016160649.24622-20-anup.patel@wdc.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <7381057d-a3f3-e79a-bb2c-b078fc918b1f@redhat.com>
Date:   Mon, 21 Oct 2019 19:28:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191016160649.24622-20-anup.patel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/10/19 18:12, Anup Patel wrote:
> Currently, we track last value wrote to VSIP CSR using per-CPU
> vsip_shadow variable but this easily goes out-of-sync because
> Guest can update VSIP.SSIP bit directly.
> 
> To simplify things, we remove per-CPU vsip_shadow variable and
> unconditionally write vcpu->arch.guest_csr.vsip to VSIP CSR in
> run-loop.
> 
> Signed-off-by: Anup Patel <anup.patel@wdc.com>

Please squash this and patch 20 into the corresponding patches earlier
in the series.

Paolo

> ---
>  arch/riscv/include/asm/kvm_host.h |  3 ---
>  arch/riscv/kvm/main.c             |  6 ------
>  arch/riscv/kvm/vcpu.c             | 24 +-----------------------
>  3 files changed, 1 insertion(+), 32 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index ec1ca4bc98f2..cd86acaed055 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -202,9 +202,6 @@ static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
>  static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
>  
> -int kvm_riscv_setup_vsip(void);
> -void kvm_riscv_cleanup_vsip(void);
> -
>  #define KVM_ARCH_WANT_MMU_NOTIFIER
>  int kvm_unmap_hva_range(struct kvm *kvm,
>  			unsigned long start, unsigned long end);
> diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
> index 55df85184241..002301a27d29 100644
> --- a/arch/riscv/kvm/main.c
> +++ b/arch/riscv/kvm/main.c
> @@ -61,17 +61,11 @@ void kvm_arch_hardware_disable(void)
>  
>  int kvm_arch_init(void *opaque)
>  {
> -	int ret;
> -
>  	if (!riscv_isa_extension_available(NULL, h)) {
>  		kvm_info("hypervisor extension not available\n");
>  		return -ENODEV;
>  	}
>  
> -	ret = kvm_riscv_setup_vsip();
> -	if (ret)
> -		return ret;
> -
>  	kvm_riscv_stage2_vmid_detect();
>  
>  	kvm_info("hypervisor extension available\n");
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index fd77cd39dd8c..f1a218d3a8cf 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -111,8 +111,6 @@ static void kvm_riscv_vcpu_host_fp_restore(struct kvm_cpu_context *cntx) {}
>  				 riscv_isa_extension_mask(s) | \
>  				 riscv_isa_extension_mask(u))
>  
> -static unsigned long __percpu *vsip_shadow;
> -
>  static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
> @@ -765,7 +763,6 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>  void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  {
>  	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
> -	unsigned long *vsip = raw_cpu_ptr(vsip_shadow);
>  
>  	csr_write(CSR_VSSTATUS, csr->vsstatus);
>  	csr_write(CSR_VSIE, csr->vsie);
> @@ -775,7 +772,6 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  	csr_write(CSR_VSCAUSE, csr->vscause);
>  	csr_write(CSR_VSTVAL, csr->vstval);
>  	csr_write(CSR_VSIP, csr->vsip);
> -	*vsip = csr->vsip;
>  	csr_write(CSR_VSATP, csr->vsatp);
>  
>  	kvm_riscv_stage2_update_hgatp(vcpu);
> @@ -843,26 +839,8 @@ static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
>  static void kvm_riscv_update_vsip(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
> -	unsigned long *vsip = raw_cpu_ptr(vsip_shadow);
> -
> -	if (*vsip != csr->vsip) {
> -		csr_write(CSR_VSIP, csr->vsip);
> -		*vsip = csr->vsip;
> -	}
> -}
> -
> -int kvm_riscv_setup_vsip(void)
> -{
> -	vsip_shadow = alloc_percpu(unsigned long);
> -	if (!vsip_shadow)
> -		return -ENOMEM;
>  
> -	return 0;
> -}
> -
> -void kvm_riscv_cleanup_vsip(void)
> -{
> -	free_percpu(vsip_shadow);
> +	csr_write(CSR_VSIP, csr->vsip);
>  }
>  
>  int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> 

