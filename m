Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28FD6411464
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 14:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238038AbhITMaG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 08:30:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42303 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233543AbhITMaF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 08:30:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632140918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bbQ8h/wkBS10Efo8Um8TUhVatac0+20cWgk++bQq2ME=;
        b=UTNH7lvNmESK4ljGlSFUFOGM+eCvRooyeMqapeV67uMW5DR4nNtwWQD0g0cIIiH2CcTA0Q
        tVNk2fBWpt6hKMERpq+70HA7Al+PfvBzGdWgF/1ISVaHLIMrF3svpLTyxspn7CLFRuwFLX
        Rv3p0g92Y/zVcQVWW4GVwmNBiKyuSlY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-HLvFKP9NMYmw5bZJHSuEOQ-1; Mon, 20 Sep 2021 08:28:37 -0400
X-MC-Unique: HLvFKP9NMYmw5bZJHSuEOQ-1
Received: by mail-wr1-f71.google.com with SMTP id r15-20020adfce8f000000b0015df1098ccbso5940948wrn.4
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 05:28:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bbQ8h/wkBS10Efo8Um8TUhVatac0+20cWgk++bQq2ME=;
        b=zuOZ4bZ2+lVDw5p6wmVIKm9BpnqnAGl+tcKwgrKrlKA9Iiwil2u8Om7a/502LgQST2
         L7NXY4rfqACsHu9EC9t9y0lbzBS+Kf5QzSSXhKIUN+PZxPtLtF0Cwpj95seYa54UqBst
         8HEFaEOOHCtzuxTCTSJPbasn403EmqvKi+/FZE9TUbvTreORQM/Ba5mF1SXE4bsX6AkN
         ms5PmHu2xhcDxtA6bOAj5iGm9v0lf/EneePNi4rZnyz3zYjoVotaieDsmxBK86zLtGUS
         h5FhnWpQeqttaSkl7th7EZDRggzHycM88xVEOdyAxId0K2i1RaD0o07L5mtrHt0zwYVu
         pg9Q==
X-Gm-Message-State: AOAM5332kxf1m9N4zn1gcpbxS0OeUidfTR+FI0HoC7IGwBifcsYmG2qp
        5Gd9gaL26IBBjHzp9tYtlldvjzYtgDmaFeHxvTWnUNzQzXKC8pcvvrrfnGX69t+Owb+g77xn6zo
        Z0+OZZTmYRxZk
X-Received: by 2002:a05:6000:14d:: with SMTP id r13mr28662725wrx.420.1632140916058;
        Mon, 20 Sep 2021 05:28:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxzOtn1g3FI6YAdIMt8FsZF+ei+aITEY4UXbrvUzTUEapa6XDjXm/kHFoQf2LfEEBBOLiZ3jw==
X-Received: by 2002:a05:6000:14d:: with SMTP id r13mr28662707wrx.420.1632140915903;
        Mon, 20 Sep 2021 05:28:35 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id a75sm16193423wmd.4.2021.09.20.05.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 05:28:35 -0700 (PDT)
Date:   Mon, 20 Sep 2021 14:28:33 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v8 9/9] selftests: KVM: Test vtimer offset reg in
 get-reg-list
Message-ID: <20210920122833.wlo7xj4ckq4upjch@gator>
References: <20210916181555.973085-1-oupton@google.com>
 <20210916181555.973085-10-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916181555.973085-10-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 16, 2021 at 06:15:55PM +0000, Oliver Upton wrote:
> Assert that KVM exposes KVM_REG_ARM_TIMER_OFFSET in the KVM_GET_REG_LIST
> ioctl when userspace buys in to the new behavior.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  .../selftests/kvm/aarch64/get-reg-list.c      | 42 +++++++++++++++++++
>  1 file changed, 42 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> index cc898181faab..4f337d8b793a 100644
> --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> @@ -40,6 +40,7 @@ static __u64 *blessed_reg, blessed_n;
>  struct reg_sublist {
>  	const char *name;
>  	long capability;
> +	long enable_capability;

cap.cap is a __u32

>  	int feature;
>  	bool finalize;
>  	__u64 *regs;
> @@ -397,6 +398,19 @@ static void check_supported(struct vcpu_config *c)
>  	}
>  }
>  
> +static void enable_caps(struct kvm_vm *vm, struct vcpu_config *c)
> +{
> +	struct kvm_enable_cap cap = {0};
> +	struct reg_sublist *s;
> +
> +	for_each_sublist(c, s) {
> +		if (s->enable_capability) {
> +			cap.cap = s->enable_capability;
> +			vm_enable_cap(vm, &cap);
> +		}
> +	}
> +}
> +
>  static bool print_list;
>  static bool print_filtered;
>  static bool fixup_core_regs;
> @@ -412,6 +426,8 @@ static void run_test(struct vcpu_config *c)
>  	check_supported(c);
>  
>  	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
> +	enable_caps(vm, c);
> +
>  	prepare_vcpu_init(c, &init);
>  	aarch64_vcpu_add_default(vm, 0, &init, NULL);
>  	finalize_vcpu(vm, 0, c);
> @@ -1014,6 +1030,10 @@ static __u64 sve_rejects_set[] = {
>  	KVM_REG_ARM64_SVE_VLS,
>  };
>  
> +static __u64 vtimer_offset_regs[] = {
> +	KVM_REG_ARM_TIMER_OFFSET,
> +};
> +
>  #define BASE_SUBLIST \
>  	{ "base", .regs = base_regs, .regs_n = ARRAY_SIZE(base_regs), }
>  #define VREGS_SUBLIST \
> @@ -1025,6 +1045,10 @@ static __u64 sve_rejects_set[] = {
>  	{ "sve", .capability = KVM_CAP_ARM_SVE, .feature = KVM_ARM_VCPU_SVE, .finalize = true, \
>  	  .regs = sve_regs, .regs_n = ARRAY_SIZE(sve_regs), \
>  	  .rejects_set = sve_rejects_set, .rejects_set_n = ARRAY_SIZE(sve_rejects_set), }
> +#define VTIMER_OFFSET_SUBLIST \
> +	{ "vtimer_offset", .capability = KVM_CAP_ARM_VTIMER_OFFSET, \
> +	  .enable_capability = KVM_CAP_ARM_VTIMER_OFFSET, .regs = vtimer_offset_regs, \
> +	  .regs_n = ARRAY_SIZE(vtimer_offset_regs), }
>  
>  static struct vcpu_config vregs_config = {
>  	.sublists = {
> @@ -1041,6 +1065,14 @@ static struct vcpu_config vregs_pmu_config = {
>  	{0},
>  	},
>  };
> +static struct vcpu_config vregs_vtimer_config = {
> +	.sublists = {
> +	BASE_SUBLIST,
> +	VREGS_SUBLIST,
> +	VTIMER_OFFSET_SUBLIST,
> +	{0},
> +	},
> +};
>  static struct vcpu_config sve_config = {
>  	.sublists = {
>  	BASE_SUBLIST,
> @@ -1056,11 +1088,21 @@ static struct vcpu_config sve_pmu_config = {
>  	{0},
>  	},
>  };
> +static struct vcpu_config sve_vtimer_config = {
> +	.sublists = {
> +	BASE_SUBLIST,
> +	SVE_SUBLIST,
> +	VTIMER_OFFSET_SUBLIST,
> +	{0},
> +	},
> +};
>  
>  static struct vcpu_config *vcpu_configs[] = {
>  	&vregs_config,
>  	&vregs_pmu_config,
> +	&vregs_vtimer_config,
>  	&sve_config,
>  	&sve_pmu_config,
> +	&sve_vtimer_config,
>  };
>  static int vcpu_configs_n = ARRAY_SIZE(vcpu_configs);
> -- 
> 2.33.0.464.g1972c5931b-goog
>

Other than the enable_capability type nit

Reviewed-by: Andrew Jones <drjones@redhat.com>
 

