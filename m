Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A450C21B0F8
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 10:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgGJIGe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 04:06:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43197 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725967AbgGJIGd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 04:06:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594368389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IcPYTOxi7SejMkMipMbZpOX+1aA5giVu8sNUOPe4LhY=;
        b=LDsIXEE/4QNrr9e+4s3063BN0iCioZSngv1xOSGHlLrQoy7NyI8z1nfzsHgXd9FwdkhdQ6
        xTv2dn003e6lnIHztzqjQZYokRoX7rRvLWlYCkyWet4nV3IeWVrKpbnHTT/WPQFzTzr+LI
        GzgRFtPtwsl2jQzg/PeGV/GYlgySAGs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-m94q73sxMr-CaSC4hhoV-w-1; Fri, 10 Jul 2020 04:06:27 -0400
X-MC-Unique: m94q73sxMr-CaSC4hhoV-w-1
Received: by mail-wm1-f69.google.com with SMTP id q20so5782661wme.3
        for <kvm@vger.kernel.org>; Fri, 10 Jul 2020 01:06:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IcPYTOxi7SejMkMipMbZpOX+1aA5giVu8sNUOPe4LhY=;
        b=f+9VM20fZW8dxQeyJovBj+WK/BBXnoDmRXbRi+XPdprHRL34txAzX+SyzZtEMzroua
         hPXKeI2pemsh28j5BJeOkH5p5nQy0Q3uepUEQckCgvUw9uXAtLJj8StRzm7vzpohSsRA
         kvjRXqBiYg5yp4a6pGycoFCQW/HJxhT5oJACNvUOjv9iItpPmUeHC/28Pt3Mbu/0PWmQ
         JP21whNb4Qd1WjjFQSlS9ZBEIfLpPzeNrfMjR89LRScz/4AbI+TFkfDPDb4X5NmNqCfE
         tBw+rRfADAMWFFFh5QdV2Ke52lo0iTCSGlYKepcFXJxtFt9z1A9PZCA2BjX9vZiu3Cox
         IjoQ==
X-Gm-Message-State: AOAM532LmcIPVgB7KF0ACBohNikunVyrHMKGFveYD3kcg4wTvjw1yApH
        FaCm8sKV9li8KvDOJ3Id38+LGKyhfgmnGSYb15u6OwA7wAFSKWhzlHGqZRv6ErIG+Q5kC2JkXua
        XjnpRTTb0kSmM
X-Received: by 2002:adf:dc90:: with SMTP id r16mr67472036wrj.264.1594368385848;
        Fri, 10 Jul 2020 01:06:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxi/p/PFaV1bzZq8r0RUkQRvjVpndGGxXidZwQcADTqzgFpWAk1V+Y9GJLRzc2PNpusTbi7gw==
X-Received: by 2002:adf:dc90:: with SMTP id r16mr67471987wrj.264.1594368385178;
        Fri, 10 Jul 2020 01:06:25 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id 59sm9553359wrj.37.2020.07.10.01.06.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2020 01:06:24 -0700 (PDT)
Subject: Re: [PATCH v6 4/5] KVM: MIPS: clean up redundant 'kvm_run' parameters
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        tsbogend@alpha.franken.de, chenhuacai@gmail.com
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org
References: <20200623131418.31473-1-tianjia.zhang@linux.alibaba.com>
 <20200623131418.31473-5-tianjia.zhang@linux.alibaba.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a37f236d-feb6-9ef4-8893-dc3a85c482af@redhat.com>
Date:   Fri, 10 Jul 2020 10:06:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200623131418.31473-5-tianjia.zhang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/20 15:14, Tianjia Zhang wrote:
> In the current kvm version, 'kvm_run' has been included in the 'kvm_vcpu'
> structure. For historical reasons, many kvm-related function parameters
> retain the 'kvm_run' and 'kvm_vcpu' parameters at the same time. This
> patch does a unified cleanup of these remaining redundant parameters.
> 
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> Reviewed-by: Huacai Chen <chenhc@lemote.com>
> ---
>  arch/mips/include/asm/kvm_host.h |  28 +-------
>  arch/mips/kvm/emulate.c          |  59 ++++++----------
>  arch/mips/kvm/mips.c             |  11 ++-
>  arch/mips/kvm/trap_emul.c        | 114 ++++++++++++++-----------------
>  arch/mips/kvm/vz.c               |  26 +++----
>  5 files changed, 87 insertions(+), 151 deletions(-)
> 
> diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
> index 363e7a89d173..157fc876feca 100644
> --- a/arch/mips/include/asm/kvm_host.h
> +++ b/arch/mips/include/asm/kvm_host.h
> @@ -854,8 +854,8 @@ struct kvm_mips_callbacks {
>  			   const struct kvm_one_reg *reg, s64 v);
>  	int (*vcpu_load)(struct kvm_vcpu *vcpu, int cpu);
>  	int (*vcpu_put)(struct kvm_vcpu *vcpu, int cpu);
> -	int (*vcpu_run)(struct kvm_run *run, struct kvm_vcpu *vcpu);
> -	void (*vcpu_reenter)(struct kvm_run *run, struct kvm_vcpu *vcpu);
> +	int (*vcpu_run)(struct kvm_vcpu *vcpu);
> +	void (*vcpu_reenter)(struct kvm_vcpu *vcpu);
>  };
>  extern struct kvm_mips_callbacks *kvm_mips_callbacks;
>  int kvm_mips_emulation_init(struct kvm_mips_callbacks **install_callbacks);
> @@ -910,7 +910,6 @@ extern int kvm_mips_handle_mapped_seg_tlb_fault(struct kvm_vcpu *vcpu,
>  
>  extern enum emulation_result kvm_mips_handle_tlbmiss(u32 cause,
>  						     u32 *opc,
> -						     struct kvm_run *run,
>  						     struct kvm_vcpu *vcpu,
>  						     bool write_fault);
>  
> @@ -1021,83 +1020,67 @@ static inline bool kvm_is_ifetch_fault(struct kvm_vcpu_arch *vcpu)
>  
>  extern enum emulation_result kvm_mips_emulate_inst(u32 cause,
>  						   u32 *opc,
> -						   struct kvm_run *run,
>  						   struct kvm_vcpu *vcpu);
>  
>  long kvm_mips_guest_exception_base(struct kvm_vcpu *vcpu);
>  
>  extern enum emulation_result kvm_mips_emulate_syscall(u32 cause,
>  						      u32 *opc,
> -						      struct kvm_run *run,
>  						      struct kvm_vcpu *vcpu);
>  
>  extern enum emulation_result kvm_mips_emulate_tlbmiss_ld(u32 cause,
>  							 u32 *opc,
> -							 struct kvm_run *run,
>  							 struct kvm_vcpu *vcpu);
>  
>  extern enum emulation_result kvm_mips_emulate_tlbinv_ld(u32 cause,
>  							u32 *opc,
> -							struct kvm_run *run,
>  							struct kvm_vcpu *vcpu);
>  
>  extern enum emulation_result kvm_mips_emulate_tlbmiss_st(u32 cause,
>  							 u32 *opc,
> -							 struct kvm_run *run,
>  							 struct kvm_vcpu *vcpu);
>  
>  extern enum emulation_result kvm_mips_emulate_tlbinv_st(u32 cause,
>  							u32 *opc,
> -							struct kvm_run *run,
>  							struct kvm_vcpu *vcpu);
>  
>  extern enum emulation_result kvm_mips_emulate_tlbmod(u32 cause,
>  						     u32 *opc,
> -						     struct kvm_run *run,
>  						     struct kvm_vcpu *vcpu);
>  
>  extern enum emulation_result kvm_mips_emulate_fpu_exc(u32 cause,
>  						      u32 *opc,
> -						      struct kvm_run *run,
>  						      struct kvm_vcpu *vcpu);
>  
>  extern enum emulation_result kvm_mips_handle_ri(u32 cause,
>  						u32 *opc,
> -						struct kvm_run *run,
>  						struct kvm_vcpu *vcpu);
>  
>  extern enum emulation_result kvm_mips_emulate_ri_exc(u32 cause,
>  						     u32 *opc,
> -						     struct kvm_run *run,
>  						     struct kvm_vcpu *vcpu);
>  
>  extern enum emulation_result kvm_mips_emulate_bp_exc(u32 cause,
>  						     u32 *opc,
> -						     struct kvm_run *run,
>  						     struct kvm_vcpu *vcpu);
>  
>  extern enum emulation_result kvm_mips_emulate_trap_exc(u32 cause,
>  						       u32 *opc,
> -						       struct kvm_run *run,
>  						       struct kvm_vcpu *vcpu);
>  
>  extern enum emulation_result kvm_mips_emulate_msafpe_exc(u32 cause,
>  							 u32 *opc,
> -							 struct kvm_run *run,
>  							 struct kvm_vcpu *vcpu);
>  
>  extern enum emulation_result kvm_mips_emulate_fpe_exc(u32 cause,
>  						      u32 *opc,
> -						      struct kvm_run *run,
>  						      struct kvm_vcpu *vcpu);
>  
>  extern enum emulation_result kvm_mips_emulate_msadis_exc(u32 cause,
>  							 u32 *opc,
> -							 struct kvm_run *run,
>  							 struct kvm_vcpu *vcpu);
>  
> -extern enum emulation_result kvm_mips_complete_mmio_load(struct kvm_vcpu *vcpu,
> -							 struct kvm_run *run);
> +extern enum emulation_result kvm_mips_complete_mmio_load(struct kvm_vcpu *vcpu);
>  
>  u32 kvm_mips_read_count(struct kvm_vcpu *vcpu);
>  void kvm_mips_write_count(struct kvm_vcpu *vcpu, u32 count);
> @@ -1126,26 +1109,21 @@ static inline void kvm_vz_lose_htimer(struct kvm_vcpu *vcpu) {}
>  
>  enum emulation_result kvm_mips_check_privilege(u32 cause,
>  					       u32 *opc,
> -					       struct kvm_run *run,
>  					       struct kvm_vcpu *vcpu);
>  
>  enum emulation_result kvm_mips_emulate_cache(union mips_instruction inst,
>  					     u32 *opc,
>  					     u32 cause,
> -					     struct kvm_run *run,
>  					     struct kvm_vcpu *vcpu);
>  enum emulation_result kvm_mips_emulate_CP0(union mips_instruction inst,
>  					   u32 *opc,
>  					   u32 cause,
> -					   struct kvm_run *run,
>  					   struct kvm_vcpu *vcpu);
>  enum emulation_result kvm_mips_emulate_store(union mips_instruction inst,
>  					     u32 cause,
> -					     struct kvm_run *run,
>  					     struct kvm_vcpu *vcpu);
>  enum emulation_result kvm_mips_emulate_load(union mips_instruction inst,
>  					    u32 cause,
> -					    struct kvm_run *run,
>  					    struct kvm_vcpu *vcpu);
>  
>  /* COP0 */
> diff --git a/arch/mips/kvm/emulate.c b/arch/mips/kvm/emulate.c
> index 5ae82d925197..23d3a4f3a43b 100644
> --- a/arch/mips/kvm/emulate.c
> +++ b/arch/mips/kvm/emulate.c
> @@ -1262,7 +1262,6 @@ unsigned int kvm_mips_config5_wrmask(struct kvm_vcpu *vcpu)
>  
>  enum emulation_result kvm_mips_emulate_CP0(union mips_instruction inst,
>  					   u32 *opc, u32 cause,
> -					   struct kvm_run *run,
>  					   struct kvm_vcpu *vcpu)
>  {
>  	struct mips_coproc *cop0 = vcpu->arch.cop0;
> @@ -1597,12 +1596,12 @@ enum emulation_result kvm_mips_emulate_CP0(union mips_instruction inst,
>  
>  enum emulation_result kvm_mips_emulate_store(union mips_instruction inst,
>  					     u32 cause,
> -					     struct kvm_run *run,
>  					     struct kvm_vcpu *vcpu)
>  {
>  	int r;
>  	enum emulation_result er;
>  	u32 rt;
> +	struct kvm_run *run = vcpu->run;
>  	void *data = run->mmio.data;
>  	unsigned int imme;
>  	unsigned long curr_pc;
> @@ -1894,9 +1893,9 @@ enum emulation_result kvm_mips_emulate_store(union mips_instruction inst,
>  }
>  
>  enum emulation_result kvm_mips_emulate_load(union mips_instruction inst,
> -					    u32 cause, struct kvm_run *run,
> -					    struct kvm_vcpu *vcpu)
> +					    u32 cause, struct kvm_vcpu *vcpu)
>  {
> +	struct kvm_run *run = vcpu->run;
>  	int r;
>  	enum emulation_result er;
>  	unsigned long curr_pc;
> @@ -2136,7 +2135,6 @@ enum emulation_result kvm_mips_emulate_load(union mips_instruction inst,
>  static enum emulation_result kvm_mips_guest_cache_op(int (*fn)(unsigned long),
>  						     unsigned long curr_pc,
>  						     unsigned long addr,
> -						     struct kvm_run *run,
>  						     struct kvm_vcpu *vcpu,
>  						     u32 cause)
>  {
> @@ -2164,13 +2162,13 @@ static enum emulation_result kvm_mips_guest_cache_op(int (*fn)(unsigned long),
>  			/* no matching guest TLB */
>  			vcpu->arch.host_cp0_badvaddr = addr;
>  			vcpu->arch.pc = curr_pc;
> -			kvm_mips_emulate_tlbmiss_ld(cause, NULL, run, vcpu);
> +			kvm_mips_emulate_tlbmiss_ld(cause, NULL, vcpu);
>  			return EMULATE_EXCEPT;
>  		case KVM_MIPS_TLBINV:
>  			/* invalid matching guest TLB */
>  			vcpu->arch.host_cp0_badvaddr = addr;
>  			vcpu->arch.pc = curr_pc;
> -			kvm_mips_emulate_tlbinv_ld(cause, NULL, run, vcpu);
> +			kvm_mips_emulate_tlbinv_ld(cause, NULL, vcpu);
>  			return EMULATE_EXCEPT;
>  		default:
>  			break;
> @@ -2180,7 +2178,6 @@ static enum emulation_result kvm_mips_guest_cache_op(int (*fn)(unsigned long),
>  
>  enum emulation_result kvm_mips_emulate_cache(union mips_instruction inst,
>  					     u32 *opc, u32 cause,
> -					     struct kvm_run *run,
>  					     struct kvm_vcpu *vcpu)
>  {
>  	enum emulation_result er = EMULATE_DONE;
> @@ -2270,7 +2267,7 @@ enum emulation_result kvm_mips_emulate_cache(union mips_instruction inst,
>  		 * guest's behalf.
>  		 */
>  		er = kvm_mips_guest_cache_op(protected_writeback_dcache_line,
> -					     curr_pc, va, run, vcpu, cause);
> +					     curr_pc, va, vcpu, cause);
>  		if (er != EMULATE_DONE)
>  			goto done;
>  #ifdef CONFIG_KVM_MIPS_DYN_TRANS
> @@ -2283,11 +2280,11 @@ enum emulation_result kvm_mips_emulate_cache(union mips_instruction inst,
>  	} else if (op_inst == Hit_Invalidate_I) {
>  		/* Perform the icache synchronisation on the guest's behalf */
>  		er = kvm_mips_guest_cache_op(protected_writeback_dcache_line,
> -					     curr_pc, va, run, vcpu, cause);
> +					     curr_pc, va, vcpu, cause);
>  		if (er != EMULATE_DONE)
>  			goto done;
>  		er = kvm_mips_guest_cache_op(protected_flush_icache_line,
> -					     curr_pc, va, run, vcpu, cause);
> +					     curr_pc, va, vcpu, cause);
>  		if (er != EMULATE_DONE)
>  			goto done;
>  
> @@ -2313,7 +2310,6 @@ enum emulation_result kvm_mips_emulate_cache(union mips_instruction inst,
>  }
>  
>  enum emulation_result kvm_mips_emulate_inst(u32 cause, u32 *opc,
> -					    struct kvm_run *run,
>  					    struct kvm_vcpu *vcpu)
>  {
>  	union mips_instruction inst;
> @@ -2329,14 +2325,14 @@ enum emulation_result kvm_mips_emulate_inst(u32 cause, u32 *opc,
>  
>  	switch (inst.r_format.opcode) {
>  	case cop0_op:
> -		er = kvm_mips_emulate_CP0(inst, opc, cause, run, vcpu);
> +		er = kvm_mips_emulate_CP0(inst, opc, cause, vcpu);
>  		break;
>  
>  #ifndef CONFIG_CPU_MIPSR6
>  	case cache_op:
>  		++vcpu->stat.cache_exits;
>  		trace_kvm_exit(vcpu, KVM_TRACE_EXIT_CACHE);
> -		er = kvm_mips_emulate_cache(inst, opc, cause, run, vcpu);
> +		er = kvm_mips_emulate_cache(inst, opc, cause, vcpu);
>  		break;
>  #else
>  	case spec3_op:
> @@ -2344,7 +2340,7 @@ enum emulation_result kvm_mips_emulate_inst(u32 cause, u32 *opc,
>  		case cache6_op:
>  			++vcpu->stat.cache_exits;
>  			trace_kvm_exit(vcpu, KVM_TRACE_EXIT_CACHE);
> -			er = kvm_mips_emulate_cache(inst, opc, cause, run,
> +			er = kvm_mips_emulate_cache(inst, opc, cause,
>  						    vcpu);
>  			break;
>  		default:
> @@ -2384,7 +2380,6 @@ long kvm_mips_guest_exception_base(struct kvm_vcpu *vcpu)
>  
>  enum emulation_result kvm_mips_emulate_syscall(u32 cause,
>  					       u32 *opc,
> -					       struct kvm_run *run,
>  					       struct kvm_vcpu *vcpu)
>  {
>  	struct mips_coproc *cop0 = vcpu->arch.cop0;
> @@ -2419,7 +2414,6 @@ enum emulation_result kvm_mips_emulate_syscall(u32 cause,
>  
>  enum emulation_result kvm_mips_emulate_tlbmiss_ld(u32 cause,
>  						  u32 *opc,
> -						  struct kvm_run *run,
>  						  struct kvm_vcpu *vcpu)
>  {
>  	struct mips_coproc *cop0 = vcpu->arch.cop0;
> @@ -2463,7 +2457,6 @@ enum emulation_result kvm_mips_emulate_tlbmiss_ld(u32 cause,
>  
>  enum emulation_result kvm_mips_emulate_tlbinv_ld(u32 cause,
>  						 u32 *opc,
> -						 struct kvm_run *run,
>  						 struct kvm_vcpu *vcpu)
>  {
>  	struct mips_coproc *cop0 = vcpu->arch.cop0;
> @@ -2505,7 +2498,6 @@ enum emulation_result kvm_mips_emulate_tlbinv_ld(u32 cause,
>  
>  enum emulation_result kvm_mips_emulate_tlbmiss_st(u32 cause,
>  						  u32 *opc,
> -						  struct kvm_run *run,
>  						  struct kvm_vcpu *vcpu)
>  {
>  	struct mips_coproc *cop0 = vcpu->arch.cop0;
> @@ -2547,7 +2539,6 @@ enum emulation_result kvm_mips_emulate_tlbmiss_st(u32 cause,
>  
>  enum emulation_result kvm_mips_emulate_tlbinv_st(u32 cause,
>  						 u32 *opc,
> -						 struct kvm_run *run,
>  						 struct kvm_vcpu *vcpu)
>  {
>  	struct mips_coproc *cop0 = vcpu->arch.cop0;
> @@ -2588,7 +2579,6 @@ enum emulation_result kvm_mips_emulate_tlbinv_st(u32 cause,
>  
>  enum emulation_result kvm_mips_emulate_tlbmod(u32 cause,
>  					      u32 *opc,
> -					      struct kvm_run *run,
>  					      struct kvm_vcpu *vcpu)
>  {
>  	struct mips_coproc *cop0 = vcpu->arch.cop0;
> @@ -2628,7 +2618,6 @@ enum emulation_result kvm_mips_emulate_tlbmod(u32 cause,
>  
>  enum emulation_result kvm_mips_emulate_fpu_exc(u32 cause,
>  					       u32 *opc,
> -					       struct kvm_run *run,
>  					       struct kvm_vcpu *vcpu)
>  {
>  	struct mips_coproc *cop0 = vcpu->arch.cop0;
> @@ -2657,7 +2646,6 @@ enum emulation_result kvm_mips_emulate_fpu_exc(u32 cause,
>  
>  enum emulation_result kvm_mips_emulate_ri_exc(u32 cause,
>  					      u32 *opc,
> -					      struct kvm_run *run,
>  					      struct kvm_vcpu *vcpu)
>  {
>  	struct mips_coproc *cop0 = vcpu->arch.cop0;
> @@ -2692,7 +2680,6 @@ enum emulation_result kvm_mips_emulate_ri_exc(u32 cause,
>  
>  enum emulation_result kvm_mips_emulate_bp_exc(u32 cause,
>  					      u32 *opc,
> -					      struct kvm_run *run,
>  					      struct kvm_vcpu *vcpu)
>  {
>  	struct mips_coproc *cop0 = vcpu->arch.cop0;
> @@ -2727,7 +2714,6 @@ enum emulation_result kvm_mips_emulate_bp_exc(u32 cause,
>  
>  enum emulation_result kvm_mips_emulate_trap_exc(u32 cause,
>  						u32 *opc,
> -						struct kvm_run *run,
>  						struct kvm_vcpu *vcpu)
>  {
>  	struct mips_coproc *cop0 = vcpu->arch.cop0;
> @@ -2762,7 +2748,6 @@ enum emulation_result kvm_mips_emulate_trap_exc(u32 cause,
>  
>  enum emulation_result kvm_mips_emulate_msafpe_exc(u32 cause,
>  						  u32 *opc,
> -						  struct kvm_run *run,
>  						  struct kvm_vcpu *vcpu)
>  {
>  	struct mips_coproc *cop0 = vcpu->arch.cop0;
> @@ -2797,7 +2782,6 @@ enum emulation_result kvm_mips_emulate_msafpe_exc(u32 cause,
>  
>  enum emulation_result kvm_mips_emulate_fpe_exc(u32 cause,
>  					       u32 *opc,
> -					       struct kvm_run *run,
>  					       struct kvm_vcpu *vcpu)
>  {
>  	struct mips_coproc *cop0 = vcpu->arch.cop0;
> @@ -2832,7 +2816,6 @@ enum emulation_result kvm_mips_emulate_fpe_exc(u32 cause,
>  
>  enum emulation_result kvm_mips_emulate_msadis_exc(u32 cause,
>  						  u32 *opc,
> -						  struct kvm_run *run,
>  						  struct kvm_vcpu *vcpu)
>  {
>  	struct mips_coproc *cop0 = vcpu->arch.cop0;
> @@ -2866,7 +2849,6 @@ enum emulation_result kvm_mips_emulate_msadis_exc(u32 cause,
>  }
>  
>  enum emulation_result kvm_mips_handle_ri(u32 cause, u32 *opc,
> -					 struct kvm_run *run,
>  					 struct kvm_vcpu *vcpu)
>  {
>  	struct mips_coproc *cop0 = vcpu->arch.cop0;
> @@ -2955,12 +2937,12 @@ enum emulation_result kvm_mips_handle_ri(u32 cause, u32 *opc,
>  	 * branch target), and pass the RI exception to the guest OS.
>  	 */
>  	vcpu->arch.pc = curr_pc;
> -	return kvm_mips_emulate_ri_exc(cause, opc, run, vcpu);
> +	return kvm_mips_emulate_ri_exc(cause, opc, vcpu);
>  }
>  
> -enum emulation_result kvm_mips_complete_mmio_load(struct kvm_vcpu *vcpu,
> -						  struct kvm_run *run)
> +enum emulation_result kvm_mips_complete_mmio_load(struct kvm_vcpu *vcpu)
>  {
> +	struct kvm_run *run = vcpu->run;
>  	unsigned long *gpr = &vcpu->arch.gprs[vcpu->arch.io_gpr];
>  	enum emulation_result er = EMULATE_DONE;
>  
> @@ -3103,7 +3085,6 @@ enum emulation_result kvm_mips_complete_mmio_load(struct kvm_vcpu *vcpu,
>  
>  static enum emulation_result kvm_mips_emulate_exc(u32 cause,
>  						  u32 *opc,
> -						  struct kvm_run *run,
>  						  struct kvm_vcpu *vcpu)
>  {
>  	u32 exccode = (cause >> CAUSEB_EXCCODE) & 0x1f;
> @@ -3141,7 +3122,6 @@ static enum emulation_result kvm_mips_emulate_exc(u32 cause,
>  
>  enum emulation_result kvm_mips_check_privilege(u32 cause,
>  					       u32 *opc,
> -					       struct kvm_run *run,
>  					       struct kvm_vcpu *vcpu)
>  {
>  	enum emulation_result er = EMULATE_DONE;
> @@ -3223,7 +3203,7 @@ enum emulation_result kvm_mips_check_privilege(u32 cause,
>  	}
>  
>  	if (er == EMULATE_PRIV_FAIL)
> -		kvm_mips_emulate_exc(cause, opc, run, vcpu);
> +		kvm_mips_emulate_exc(cause, opc, vcpu);
>  
>  	return er;
>  }
> @@ -3237,7 +3217,6 @@ enum emulation_result kvm_mips_check_privilege(u32 cause,
>   */
>  enum emulation_result kvm_mips_handle_tlbmiss(u32 cause,
>  					      u32 *opc,
> -					      struct kvm_run *run,
>  					      struct kvm_vcpu *vcpu,
>  					      bool write_fault)
>  {
> @@ -3261,9 +3240,9 @@ enum emulation_result kvm_mips_handle_tlbmiss(u32 cause,
>  		       KVM_ENTRYHI_ASID));
>  	if (index < 0) {
>  		if (exccode == EXCCODE_TLBL) {
> -			er = kvm_mips_emulate_tlbmiss_ld(cause, opc, run, vcpu);
> +			er = kvm_mips_emulate_tlbmiss_ld(cause, opc, vcpu);
>  		} else if (exccode == EXCCODE_TLBS) {
> -			er = kvm_mips_emulate_tlbmiss_st(cause, opc, run, vcpu);
> +			er = kvm_mips_emulate_tlbmiss_st(cause, opc, vcpu);
>  		} else {
>  			kvm_err("%s: invalid exc code: %d\n", __func__,
>  				exccode);
> @@ -3278,10 +3257,10 @@ enum emulation_result kvm_mips_handle_tlbmiss(u32 cause,
>  		 */
>  		if (!TLB_IS_VALID(*tlb, va)) {
>  			if (exccode == EXCCODE_TLBL) {
> -				er = kvm_mips_emulate_tlbinv_ld(cause, opc, run,
> +				er = kvm_mips_emulate_tlbinv_ld(cause, opc,
>  								vcpu);
>  			} else if (exccode == EXCCODE_TLBS) {
> -				er = kvm_mips_emulate_tlbinv_st(cause, opc, run,
> +				er = kvm_mips_emulate_tlbinv_st(cause, opc,
>  								vcpu);
>  			} else {
>  				kvm_err("%s: invalid exc code: %d\n", __func__,
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index 521bd5891e84..f5ba393472e3 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -448,7 +448,6 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>  
>  int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_run *run = vcpu->run;
>  	int r = -EINTR;
>  
>  	vcpu_load(vcpu);
> @@ -457,11 +456,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  
>  	if (vcpu->mmio_needed) {
>  		if (!vcpu->mmio_is_write)
> -			kvm_mips_complete_mmio_load(vcpu, run);
> +			kvm_mips_complete_mmio_load(vcpu);
>  		vcpu->mmio_needed = 0;
>  	}
>  
> -	if (run->immediate_exit)
> +	if (vcpu->run->immediate_exit)
>  		goto out;
>  
>  	lose_fpu(1);
> @@ -478,7 +477,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  	 */
>  	smp_store_mb(vcpu->mode, IN_GUEST_MODE);
>  
> -	r = kvm_mips_callbacks->vcpu_run(run, vcpu);
> +	r = kvm_mips_callbacks->vcpu_run(vcpu);
>  
>  	trace_kvm_out(vcpu);
>  	guest_exit_irqoff();
> @@ -1234,7 +1233,7 @@ int kvm_mips_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu)
>  		 * end up causing an exception to be delivered to the Guest
>  		 * Kernel
>  		 */
> -		er = kvm_mips_check_privilege(cause, opc, run, vcpu);
> +		er = kvm_mips_check_privilege(cause, opc, vcpu);
>  		if (er == EMULATE_PRIV_FAIL) {
>  			goto skip_emul;
>  		} else if (er == EMULATE_FAIL) {
> @@ -1383,7 +1382,7 @@ int kvm_mips_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu)
>  		 */
>  		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
>  
> -		kvm_mips_callbacks->vcpu_reenter(run, vcpu);
> +		kvm_mips_callbacks->vcpu_reenter(vcpu);
>  
>  		/*
>  		 * If FPU / MSA are enabled (i.e. the guest's FPU / MSA context
> diff --git a/arch/mips/kvm/trap_emul.c b/arch/mips/kvm/trap_emul.c
> index 34ad0b46e610..f8cba51e1054 100644
> --- a/arch/mips/kvm/trap_emul.c
> +++ b/arch/mips/kvm/trap_emul.c
> @@ -67,7 +67,6 @@ static int kvm_trap_emul_no_handler(struct kvm_vcpu *vcpu)
>  static int kvm_trap_emul_handle_cop_unusable(struct kvm_vcpu *vcpu)
>  {
>  	struct mips_coproc *cop0 = vcpu->arch.cop0;
> -	struct kvm_run *run = vcpu->run;
>  	u32 __user *opc = (u32 __user *) vcpu->arch.pc;
>  	u32 cause = vcpu->arch.host_cp0_cause;
>  	enum emulation_result er = EMULATE_DONE;
> @@ -81,14 +80,14 @@ static int kvm_trap_emul_handle_cop_unusable(struct kvm_vcpu *vcpu)
>  			 * Unusable/no FPU in guest:
>  			 * deliver guest COP1 Unusable Exception
>  			 */
> -			er = kvm_mips_emulate_fpu_exc(cause, opc, run, vcpu);
> +			er = kvm_mips_emulate_fpu_exc(cause, opc, vcpu);
>  		} else {
>  			/* Restore FPU state */
>  			kvm_own_fpu(vcpu);
>  			er = EMULATE_DONE;
>  		}
>  	} else {
> -		er = kvm_mips_emulate_inst(cause, opc, run, vcpu);
> +		er = kvm_mips_emulate_inst(cause, opc, vcpu);
>  	}
>  
>  	switch (er) {
> @@ -97,12 +96,12 @@ static int kvm_trap_emul_handle_cop_unusable(struct kvm_vcpu *vcpu)
>  		break;
>  
>  	case EMULATE_FAIL:
> -		run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>  		ret = RESUME_HOST;
>  		break;
>  
>  	case EMULATE_WAIT:
> -		run->exit_reason = KVM_EXIT_INTR;
> +		vcpu->run->exit_reason = KVM_EXIT_INTR;
>  		ret = RESUME_HOST;
>  		break;
>  
> @@ -116,8 +115,7 @@ static int kvm_trap_emul_handle_cop_unusable(struct kvm_vcpu *vcpu)
>  	return ret;
>  }
>  
> -static int kvm_mips_bad_load(u32 cause, u32 *opc, struct kvm_run *run,
> -			     struct kvm_vcpu *vcpu)
> +static int kvm_mips_bad_load(u32 cause, u32 *opc, struct kvm_vcpu *vcpu)
>  {
>  	enum emulation_result er;
>  	union mips_instruction inst;
> @@ -125,7 +123,7 @@ static int kvm_mips_bad_load(u32 cause, u32 *opc, struct kvm_run *run,
>  
>  	/* A code fetch fault doesn't count as an MMIO */
>  	if (kvm_is_ifetch_fault(&vcpu->arch)) {
> -		run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>  		return RESUME_HOST;
>  	}
>  
> @@ -134,23 +132,22 @@ static int kvm_mips_bad_load(u32 cause, u32 *opc, struct kvm_run *run,
>  		opc += 1;
>  	err = kvm_get_badinstr(opc, vcpu, &inst.word);
>  	if (err) {
> -		run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>  		return RESUME_HOST;
>  	}
>  
>  	/* Emulate the load */
> -	er = kvm_mips_emulate_load(inst, cause, run, vcpu);
> +	er = kvm_mips_emulate_load(inst, cause, vcpu);
>  	if (er == EMULATE_FAIL) {
>  		kvm_err("Emulate load from MMIO space failed\n");
> -		run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>  	} else {
> -		run->exit_reason = KVM_EXIT_MMIO;
> +		vcpu->run->exit_reason = KVM_EXIT_MMIO;
>  	}
>  	return RESUME_HOST;
>  }
>  
> -static int kvm_mips_bad_store(u32 cause, u32 *opc, struct kvm_run *run,
> -			      struct kvm_vcpu *vcpu)
> +static int kvm_mips_bad_store(u32 cause, u32 *opc, struct kvm_vcpu *vcpu)
>  {
>  	enum emulation_result er;
>  	union mips_instruction inst;
> @@ -161,34 +158,33 @@ static int kvm_mips_bad_store(u32 cause, u32 *opc, struct kvm_run *run,
>  		opc += 1;
>  	err = kvm_get_badinstr(opc, vcpu, &inst.word);
>  	if (err) {
> -		run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>  		return RESUME_HOST;
>  	}
>  
>  	/* Emulate the store */
> -	er = kvm_mips_emulate_store(inst, cause, run, vcpu);
> +	er = kvm_mips_emulate_store(inst, cause, vcpu);
>  	if (er == EMULATE_FAIL) {
>  		kvm_err("Emulate store to MMIO space failed\n");
> -		run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>  	} else {
> -		run->exit_reason = KVM_EXIT_MMIO;
> +		vcpu->run->exit_reason = KVM_EXIT_MMIO;
>  	}
>  	return RESUME_HOST;
>  }
>  
> -static int kvm_mips_bad_access(u32 cause, u32 *opc, struct kvm_run *run,
> +static int kvm_mips_bad_access(u32 cause, u32 *opc,
>  			       struct kvm_vcpu *vcpu, bool store)
>  {
>  	if (store)
> -		return kvm_mips_bad_store(cause, opc, run, vcpu);
> +		return kvm_mips_bad_store(cause, opc, vcpu);
>  	else
> -		return kvm_mips_bad_load(cause, opc, run, vcpu);
> +		return kvm_mips_bad_load(cause, opc, vcpu);
>  }
>  
>  static int kvm_trap_emul_handle_tlb_mod(struct kvm_vcpu *vcpu)
>  {
>  	struct mips_coproc *cop0 = vcpu->arch.cop0;
> -	struct kvm_run *run = vcpu->run;
>  	u32 __user *opc = (u32 __user *) vcpu->arch.pc;
>  	unsigned long badvaddr = vcpu->arch.host_cp0_badvaddr;
>  	u32 cause = vcpu->arch.host_cp0_cause;
> @@ -212,12 +208,12 @@ static int kvm_trap_emul_handle_tlb_mod(struct kvm_vcpu *vcpu)
>  		 * They would indicate stale host TLB entries.
>  		 */
>  		if (unlikely(index < 0)) {
> -			run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +			vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>  			return RESUME_HOST;
>  		}
>  		tlb = vcpu->arch.guest_tlb + index;
>  		if (unlikely(!TLB_IS_VALID(*tlb, badvaddr))) {
> -			run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +			vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>  			return RESUME_HOST;
>  		}
>  
> @@ -226,23 +222,23 @@ static int kvm_trap_emul_handle_tlb_mod(struct kvm_vcpu *vcpu)
>  		 * exception. Relay that on to the guest so it can handle it.
>  		 */
>  		if (!TLB_IS_DIRTY(*tlb, badvaddr)) {
> -			kvm_mips_emulate_tlbmod(cause, opc, run, vcpu);
> +			kvm_mips_emulate_tlbmod(cause, opc, vcpu);
>  			return RESUME_GUEST;
>  		}
>  
>  		if (kvm_mips_handle_mapped_seg_tlb_fault(vcpu, tlb, badvaddr,
>  							 true))
>  			/* Not writable, needs handling as MMIO */
> -			return kvm_mips_bad_store(cause, opc, run, vcpu);
> +			return kvm_mips_bad_store(cause, opc, vcpu);
>  		return RESUME_GUEST;
>  	} else if (KVM_GUEST_KSEGX(badvaddr) == KVM_GUEST_KSEG0) {
>  		if (kvm_mips_handle_kseg0_tlb_fault(badvaddr, vcpu, true) < 0)
>  			/* Not writable, needs handling as MMIO */
> -			return kvm_mips_bad_store(cause, opc, run, vcpu);
> +			return kvm_mips_bad_store(cause, opc, vcpu);
>  		return RESUME_GUEST;
>  	} else {
>  		/* host kernel addresses are all handled as MMIO */
> -		return kvm_mips_bad_store(cause, opc, run, vcpu);
> +		return kvm_mips_bad_store(cause, opc, vcpu);
>  	}
>  }
>  
> @@ -276,7 +272,7 @@ static int kvm_trap_emul_handle_tlb_miss(struct kvm_vcpu *vcpu, bool store)
>  		 *     into the shadow host TLB
>  		 */
>  
> -		er = kvm_mips_handle_tlbmiss(cause, opc, run, vcpu, store);
> +		er = kvm_mips_handle_tlbmiss(cause, opc, vcpu, store);
>  		if (er == EMULATE_DONE)
>  			ret = RESUME_GUEST;
>  		else {
> @@ -289,14 +285,14 @@ static int kvm_trap_emul_handle_tlb_miss(struct kvm_vcpu *vcpu, bool store)
>  		 * not expect to ever get them
>  		 */
>  		if (kvm_mips_handle_kseg0_tlb_fault(badvaddr, vcpu, store) < 0)
> -			ret = kvm_mips_bad_access(cause, opc, run, vcpu, store);
> +			ret = kvm_mips_bad_access(cause, opc, vcpu, store);
>  	} else if (KVM_GUEST_KERNEL_MODE(vcpu)
>  		   && (KSEGX(badvaddr) == CKSEG0 || KSEGX(badvaddr) == CKSEG1)) {
>  		/*
>  		 * With EVA we may get a TLB exception instead of an address
>  		 * error when the guest performs MMIO to KSeg1 addresses.
>  		 */
> -		ret = kvm_mips_bad_access(cause, opc, run, vcpu, store);
> +		ret = kvm_mips_bad_access(cause, opc, vcpu, store);
>  	} else {
>  		kvm_err("Illegal TLB %s fault address , cause %#x, PC: %p, BadVaddr: %#lx\n",
>  			store ? "ST" : "LD", cause, opc, badvaddr);
> @@ -320,7 +316,6 @@ static int kvm_trap_emul_handle_tlb_ld_miss(struct kvm_vcpu *vcpu)
>  
>  static int kvm_trap_emul_handle_addr_err_st(struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_run *run = vcpu->run;
>  	u32 __user *opc = (u32 __user *) vcpu->arch.pc;
>  	unsigned long badvaddr = vcpu->arch.host_cp0_badvaddr;
>  	u32 cause = vcpu->arch.host_cp0_cause;
> @@ -328,11 +323,11 @@ static int kvm_trap_emul_handle_addr_err_st(struct kvm_vcpu *vcpu)
>  
>  	if (KVM_GUEST_KERNEL_MODE(vcpu)
>  	    && (KSEGX(badvaddr) == CKSEG0 || KSEGX(badvaddr) == CKSEG1)) {
> -		ret = kvm_mips_bad_store(cause, opc, run, vcpu);
> +		ret = kvm_mips_bad_store(cause, opc, vcpu);
>  	} else {
>  		kvm_err("Address Error (STORE): cause %#x, PC: %p, BadVaddr: %#lx\n",
>  			cause, opc, badvaddr);
> -		run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>  		ret = RESUME_HOST;
>  	}
>  	return ret;
> @@ -340,18 +335,17 @@ static int kvm_trap_emul_handle_addr_err_st(struct kvm_vcpu *vcpu)
>  
>  static int kvm_trap_emul_handle_addr_err_ld(struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_run *run = vcpu->run;
>  	u32 __user *opc = (u32 __user *) vcpu->arch.pc;
>  	unsigned long badvaddr = vcpu->arch.host_cp0_badvaddr;
>  	u32 cause = vcpu->arch.host_cp0_cause;
>  	int ret = RESUME_GUEST;
>  
>  	if (KSEGX(badvaddr) == CKSEG0 || KSEGX(badvaddr) == CKSEG1) {
> -		ret = kvm_mips_bad_load(cause, opc, run, vcpu);
> +		ret = kvm_mips_bad_load(cause, opc, vcpu);
>  	} else {
>  		kvm_err("Address Error (LOAD): cause %#x, PC: %p, BadVaddr: %#lx\n",
>  			cause, opc, badvaddr);
> -		run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>  		ret = RESUME_HOST;
>  	}
>  	return ret;
> @@ -359,17 +353,16 @@ static int kvm_trap_emul_handle_addr_err_ld(struct kvm_vcpu *vcpu)
>  
>  static int kvm_trap_emul_handle_syscall(struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_run *run = vcpu->run;
>  	u32 __user *opc = (u32 __user *) vcpu->arch.pc;
>  	u32 cause = vcpu->arch.host_cp0_cause;
>  	enum emulation_result er = EMULATE_DONE;
>  	int ret = RESUME_GUEST;
>  
> -	er = kvm_mips_emulate_syscall(cause, opc, run, vcpu);
> +	er = kvm_mips_emulate_syscall(cause, opc, vcpu);
>  	if (er == EMULATE_DONE)
>  		ret = RESUME_GUEST;
>  	else {
> -		run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>  		ret = RESUME_HOST;
>  	}
>  	return ret;
> @@ -377,17 +370,16 @@ static int kvm_trap_emul_handle_syscall(struct kvm_vcpu *vcpu)
>  
>  static int kvm_trap_emul_handle_res_inst(struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_run *run = vcpu->run;
>  	u32 __user *opc = (u32 __user *) vcpu->arch.pc;
>  	u32 cause = vcpu->arch.host_cp0_cause;
>  	enum emulation_result er = EMULATE_DONE;
>  	int ret = RESUME_GUEST;
>  
> -	er = kvm_mips_handle_ri(cause, opc, run, vcpu);
> +	er = kvm_mips_handle_ri(cause, opc, vcpu);
>  	if (er == EMULATE_DONE)
>  		ret = RESUME_GUEST;
>  	else {
> -		run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>  		ret = RESUME_HOST;
>  	}
>  	return ret;
> @@ -395,17 +387,16 @@ static int kvm_trap_emul_handle_res_inst(struct kvm_vcpu *vcpu)
>  
>  static int kvm_trap_emul_handle_break(struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_run *run = vcpu->run;
>  	u32 __user *opc = (u32 __user *) vcpu->arch.pc;
>  	u32 cause = vcpu->arch.host_cp0_cause;
>  	enum emulation_result er = EMULATE_DONE;
>  	int ret = RESUME_GUEST;
>  
> -	er = kvm_mips_emulate_bp_exc(cause, opc, run, vcpu);
> +	er = kvm_mips_emulate_bp_exc(cause, opc, vcpu);
>  	if (er == EMULATE_DONE)
>  		ret = RESUME_GUEST;
>  	else {
> -		run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>  		ret = RESUME_HOST;
>  	}
>  	return ret;
> @@ -413,17 +404,16 @@ static int kvm_trap_emul_handle_break(struct kvm_vcpu *vcpu)
>  
>  static int kvm_trap_emul_handle_trap(struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_run *run = vcpu->run;
>  	u32 __user *opc = (u32 __user *)vcpu->arch.pc;
>  	u32 cause = vcpu->arch.host_cp0_cause;
>  	enum emulation_result er = EMULATE_DONE;
>  	int ret = RESUME_GUEST;
>  
> -	er = kvm_mips_emulate_trap_exc(cause, opc, run, vcpu);
> +	er = kvm_mips_emulate_trap_exc(cause, opc, vcpu);
>  	if (er == EMULATE_DONE) {
>  		ret = RESUME_GUEST;
>  	} else {
> -		run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>  		ret = RESUME_HOST;
>  	}
>  	return ret;
> @@ -431,17 +421,16 @@ static int kvm_trap_emul_handle_trap(struct kvm_vcpu *vcpu)
>  
>  static int kvm_trap_emul_handle_msa_fpe(struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_run *run = vcpu->run;
>  	u32 __user *opc = (u32 __user *)vcpu->arch.pc;
>  	u32 cause = vcpu->arch.host_cp0_cause;
>  	enum emulation_result er = EMULATE_DONE;
>  	int ret = RESUME_GUEST;
>  
> -	er = kvm_mips_emulate_msafpe_exc(cause, opc, run, vcpu);
> +	er = kvm_mips_emulate_msafpe_exc(cause, opc, vcpu);
>  	if (er == EMULATE_DONE) {
>  		ret = RESUME_GUEST;
>  	} else {
> -		run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>  		ret = RESUME_HOST;
>  	}
>  	return ret;
> @@ -449,17 +438,16 @@ static int kvm_trap_emul_handle_msa_fpe(struct kvm_vcpu *vcpu)
>  
>  static int kvm_trap_emul_handle_fpe(struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_run *run = vcpu->run;
>  	u32 __user *opc = (u32 __user *)vcpu->arch.pc;
>  	u32 cause = vcpu->arch.host_cp0_cause;
>  	enum emulation_result er = EMULATE_DONE;
>  	int ret = RESUME_GUEST;
>  
> -	er = kvm_mips_emulate_fpe_exc(cause, opc, run, vcpu);
> +	er = kvm_mips_emulate_fpe_exc(cause, opc, vcpu);
>  	if (er == EMULATE_DONE) {
>  		ret = RESUME_GUEST;
>  	} else {
> -		run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>  		ret = RESUME_HOST;
>  	}
>  	return ret;
> @@ -474,7 +462,6 @@ static int kvm_trap_emul_handle_fpe(struct kvm_vcpu *vcpu)
>  static int kvm_trap_emul_handle_msa_disabled(struct kvm_vcpu *vcpu)
>  {
>  	struct mips_coproc *cop0 = vcpu->arch.cop0;
> -	struct kvm_run *run = vcpu->run;
>  	u32 __user *opc = (u32 __user *) vcpu->arch.pc;
>  	u32 cause = vcpu->arch.host_cp0_cause;
>  	enum emulation_result er = EMULATE_DONE;
> @@ -486,10 +473,10 @@ static int kvm_trap_emul_handle_msa_disabled(struct kvm_vcpu *vcpu)
>  		 * No MSA in guest, or FPU enabled and not in FR=1 mode,
>  		 * guest reserved instruction exception
>  		 */
> -		er = kvm_mips_emulate_ri_exc(cause, opc, run, vcpu);
> +		er = kvm_mips_emulate_ri_exc(cause, opc, vcpu);
>  	} else if (!(kvm_read_c0_guest_config5(cop0) & MIPS_CONF5_MSAEN)) {
>  		/* MSA disabled by guest, guest MSA disabled exception */
> -		er = kvm_mips_emulate_msadis_exc(cause, opc, run, vcpu);
> +		er = kvm_mips_emulate_msadis_exc(cause, opc, vcpu);
>  	} else {
>  		/* Restore MSA/FPU state */
>  		kvm_own_msa(vcpu);
> @@ -502,7 +489,7 @@ static int kvm_trap_emul_handle_msa_disabled(struct kvm_vcpu *vcpu)
>  		break;
>  
>  	case EMULATE_FAIL:
> -		run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>  		ret = RESUME_HOST;
>  		break;
>  
> @@ -1184,8 +1171,7 @@ void kvm_trap_emul_gva_lockless_end(struct kvm_vcpu *vcpu)
>  	local_irq_enable();
>  }
>  
> -static void kvm_trap_emul_vcpu_reenter(struct kvm_run *run,
> -				       struct kvm_vcpu *vcpu)
> +static void kvm_trap_emul_vcpu_reenter(struct kvm_vcpu *vcpu)
>  {
>  	struct mm_struct *kern_mm = &vcpu->arch.guest_kernel_mm;
>  	struct mm_struct *user_mm = &vcpu->arch.guest_user_mm;
> @@ -1228,7 +1214,7 @@ static void kvm_trap_emul_vcpu_reenter(struct kvm_run *run,
>  	check_mmu_context(mm);
>  }
>  
> -static int kvm_trap_emul_vcpu_run(struct kvm_run *run, struct kvm_vcpu *vcpu)
> +static int kvm_trap_emul_vcpu_run(struct kvm_vcpu *vcpu)
>  {
>  	int cpu = smp_processor_id();
>  	int r;
> @@ -1237,7 +1223,7 @@ static int kvm_trap_emul_vcpu_run(struct kvm_run *run, struct kvm_vcpu *vcpu)
>  	kvm_mips_deliver_interrupts(vcpu,
>  				    kvm_read_c0_guest_cause(vcpu->arch.cop0));
>  
> -	kvm_trap_emul_vcpu_reenter(run, vcpu);
> +	kvm_trap_emul_vcpu_reenter(vcpu);
>  
>  	/*
>  	 * We use user accessors to access guest memory, but we don't want to
> @@ -1255,7 +1241,7 @@ static int kvm_trap_emul_vcpu_run(struct kvm_run *run, struct kvm_vcpu *vcpu)
>  	 */
>  	kvm_mips_suspend_mm(cpu);
>  
> -	r = vcpu->arch.vcpu_run(run, vcpu);
> +	r = vcpu->arch.vcpu_run(vcpu->run, vcpu);
>  
>  	/* We may have migrated while handling guest exits */
>  	cpu = smp_processor_id();
> diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
> index d9c462c14163..9e58c479ee20 100644
> --- a/arch/mips/kvm/vz.c
> +++ b/arch/mips/kvm/vz.c
> @@ -874,7 +874,6 @@ static void kvm_write_maari(struct kvm_vcpu *vcpu, unsigned long val)
>  
>  static enum emulation_result kvm_vz_gpsi_cop0(union mips_instruction inst,
>  					      u32 *opc, u32 cause,
> -					      struct kvm_run *run,
>  					      struct kvm_vcpu *vcpu)
>  {
>  	struct mips_coproc *cop0 = vcpu->arch.cop0;
> @@ -1074,7 +1073,6 @@ static enum emulation_result kvm_vz_gpsi_cop0(union mips_instruction inst,
>  
>  static enum emulation_result kvm_vz_gpsi_cache(union mips_instruction inst,
>  					       u32 *opc, u32 cause,
> -					       struct kvm_run *run,
>  					       struct kvm_vcpu *vcpu)
>  {
>  	enum emulation_result er = EMULATE_DONE;
> @@ -1217,7 +1215,6 @@ static enum emulation_result kvm_trap_vz_handle_gpsi(u32 cause, u32 *opc,
>  {
>  	enum emulation_result er = EMULATE_DONE;
>  	struct kvm_vcpu_arch *arch = &vcpu->arch;
> -	struct kvm_run *run = vcpu->run;
>  	union mips_instruction inst;
>  	int rd, rt, sel;
>  	int err;
> @@ -1233,12 +1230,12 @@ static enum emulation_result kvm_trap_vz_handle_gpsi(u32 cause, u32 *opc,
>  
>  	switch (inst.r_format.opcode) {
>  	case cop0_op:
> -		er = kvm_vz_gpsi_cop0(inst, opc, cause, run, vcpu);
> +		er = kvm_vz_gpsi_cop0(inst, opc, cause, vcpu);
>  		break;
>  #ifndef CONFIG_CPU_MIPSR6
>  	case cache_op:
>  		trace_kvm_exit(vcpu, KVM_TRACE_EXIT_CACHE);
> -		er = kvm_vz_gpsi_cache(inst, opc, cause, run, vcpu);
> +		er = kvm_vz_gpsi_cache(inst, opc, cause, vcpu);
>  		break;
>  #endif
>  #ifdef CONFIG_CPU_LOONGSON64
> @@ -1251,7 +1248,7 @@ static enum emulation_result kvm_trap_vz_handle_gpsi(u32 cause, u32 *opc,
>  #ifdef CONFIG_CPU_MIPSR6
>  		case cache6_op:
>  			trace_kvm_exit(vcpu, KVM_TRACE_EXIT_CACHE);
> -			er = kvm_vz_gpsi_cache(inst, opc, cause, run, vcpu);
> +			er = kvm_vz_gpsi_cache(inst, opc, cause, vcpu);
>  			break;
>  #endif
>  		case rdhwr_op:
> @@ -1553,7 +1550,6 @@ static int kvm_trap_vz_handle_guest_exit(struct kvm_vcpu *vcpu)
>   */
>  static int kvm_trap_vz_handle_cop_unusable(struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_run *run = vcpu->run;
>  	u32 cause = vcpu->arch.host_cp0_cause;
>  	enum emulation_result er = EMULATE_FAIL;
>  	int ret = RESUME_GUEST;
> @@ -1581,7 +1577,7 @@ static int kvm_trap_vz_handle_cop_unusable(struct kvm_vcpu *vcpu)
>  		break;
>  
>  	case EMULATE_FAIL:
> -		run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>  		ret = RESUME_HOST;
>  		break;
>  
> @@ -1600,8 +1596,6 @@ static int kvm_trap_vz_handle_cop_unusable(struct kvm_vcpu *vcpu)
>   */
>  static int kvm_trap_vz_handle_msa_disabled(struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_run *run = vcpu->run;
> -
>  	/*
>  	 * If MSA not present or not exposed to guest or FR=0, the MSA operation
>  	 * should have been treated as a reserved instruction!
> @@ -1612,7 +1606,7 @@ static int kvm_trap_vz_handle_msa_disabled(struct kvm_vcpu *vcpu)
>  	    (read_gc0_status() & (ST0_CU1 | ST0_FR)) == ST0_CU1 ||
>  	    !(read_gc0_config5() & MIPS_CONF5_MSAEN) ||
>  	    vcpu->arch.aux_inuse & KVM_MIPS_AUX_MSA) {
> -		run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>  		return RESUME_HOST;
>  	}
>  
> @@ -1648,7 +1642,7 @@ static int kvm_trap_vz_handle_tlb_ld_miss(struct kvm_vcpu *vcpu)
>  		}
>  
>  		/* Treat as MMIO */
> -		er = kvm_mips_emulate_load(inst, cause, run, vcpu);
> +		er = kvm_mips_emulate_load(inst, cause, vcpu);
>  		if (er == EMULATE_FAIL) {
>  			kvm_err("Guest Emulate Load from MMIO space failed: PC: %p, BadVaddr: %#lx\n",
>  				opc, badvaddr);
> @@ -1695,7 +1689,7 @@ static int kvm_trap_vz_handle_tlb_st_miss(struct kvm_vcpu *vcpu)
>  		}
>  
>  		/* Treat as MMIO */
> -		er = kvm_mips_emulate_store(inst, cause, run, vcpu);
> +		er = kvm_mips_emulate_store(inst, cause, vcpu);
>  		if (er == EMULATE_FAIL) {
>  			kvm_err("Guest Emulate Store to MMIO space failed: PC: %p, BadVaddr: %#lx\n",
>  				opc, badvaddr);
> @@ -3242,7 +3236,7 @@ static void kvm_vz_flush_shadow_memslot(struct kvm *kvm,
>  	kvm_vz_flush_shadow_all(kvm);
>  }
>  
> -static void kvm_vz_vcpu_reenter(struct kvm_run *run, struct kvm_vcpu *vcpu)
> +static void kvm_vz_vcpu_reenter(struct kvm_vcpu *vcpu)
>  {
>  	int cpu = smp_processor_id();
>  	int preserve_guest_tlb;
> @@ -3258,7 +3252,7 @@ static void kvm_vz_vcpu_reenter(struct kvm_run *run, struct kvm_vcpu *vcpu)
>  		kvm_vz_vcpu_load_wired(vcpu);
>  }
>  
> -static int kvm_vz_vcpu_run(struct kvm_run *run, struct kvm_vcpu *vcpu)
> +static int kvm_vz_vcpu_run(struct kvm_vcpu *vcpu)
>  {
>  	int cpu = smp_processor_id();
>  	int r;
> @@ -3271,7 +3265,7 @@ static int kvm_vz_vcpu_run(struct kvm_run *run, struct kvm_vcpu *vcpu)
>  	kvm_vz_vcpu_load_tlb(vcpu, cpu);
>  	kvm_vz_vcpu_load_wired(vcpu);
>  
> -	r = vcpu->arch.vcpu_run(run, vcpu);
> +	r = vcpu->arch.vcpu_run(vcpu->run, vcpu);
>  
>  	kvm_vz_vcpu_save_wired(vcpu);
>  
> 

Huacai, can you test these two patches (especially the next one---seems
correct but I'd prefer it to have a Tested-by)?

Thanks,

Paolo

