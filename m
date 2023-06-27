Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BADEF73F852
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 11:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbjF0JJo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 05:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231793AbjF0JJe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 05:09:34 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A5F1BCB
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 02:09:32 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-51d9124e1baso3612332a12.2
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 02:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1687856970; x=1690448970;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R0dPPN6kCxjJ5erU6C8GI2QpZR2Odnb/ktBK6lqyvdY=;
        b=eZMzvYYkDo8EfR7GYZC2UEnZSGriHw1BzLCiOfGra3b2gqub9gEyeftBpgrsE1Us2o
         6JFZLDMOSh92+JS5MZ8TD+vn5oJrWDH9kD7RhVcSTc6pdjTmRzo/XgWxOHvGQ1NE1lbk
         jj1kvNlyxa+p46PiIy/BuVrkH2bfc9U3Xil7zkB2GQ93+HVIkPsktCI+rx8rlNQ1hDrs
         l946asInJqI5DBhG9fmf0hvBTKRlMttnOpX2bZ7N0+OIzUcF4Voh365nwihT8sINjk9D
         XYiSnoYfIaGsCm8wmUxhO/obTZwOD/O99AOzfjGeeM9upJVj16dWxdKE1bixlQt8yXsG
         kl5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687856970; x=1690448970;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R0dPPN6kCxjJ5erU6C8GI2QpZR2Odnb/ktBK6lqyvdY=;
        b=jSwYdV/gmH/9RdaJWez7WWShtT2osnKoAmNRUMpCMecj/x6QcZnz5Z71CpIRNqJg8p
         /EyXD8Dxqz7YFd14KrE9hxt/lDOTChFGK28XpmDYt4AxztkjnH4UtcQA/cj1tNC5Rg/2
         Br0kmwr5uO+Q9NK5e6Eas1x1v/Hb0hCatcRzs4UY9Y5k4akm9G4PKeXFewNfewk/adZ2
         jWME89N5jF42gDpJS0SxuZegYtnSZA8l0FOgoS/cnwYmEMljs3i6a2vBwTWO6WVXdmNE
         sfMp2XyDVVkoUumSPGvjSfhTmLuwWtcJ1e8oPTMklULWrxy+v4jPM8Bev7R60pgvG4W8
         Oh5w==
X-Gm-Message-State: AC+VfDwRK8Tq3XyYSUCGMBDUO/RCV1pat65f578haDe8Ex0TKJfrNFf0
        mrO0NA783wO1ylj60j6f8VKmqw==
X-Google-Smtp-Source: ACHHUZ4JTx2HNgMrDX8zs9F7AE78EPk6RMDfso94B/r0ax0vwcVieNX1DoGrYahuA+FJpIr1APh3ag==
X-Received: by 2002:aa7:d784:0:b0:51b:d49c:8c36 with SMTP id s4-20020aa7d784000000b0051bd49c8c36mr15262930edq.16.1687856970460;
        Tue, 27 Jun 2023 02:09:30 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id y19-20020aa7d513000000b0051d8a512472sm3133032edq.51.2023.06.27.02.09.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 02:09:29 -0700 (PDT)
Date:   Tue, 27 Jun 2023 11:09:28 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Haibo Xu <haibo1.xu@intel.com>
Cc:     xiaobo55x@gmail.com, maz@kernel.org, oliver.upton@linux.dev,
        seanjc@google.com, Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Shuah Khan <shuah@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kselftest@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v4 08/12] KVM: arm64: selftests: Move reject_set check
 logic to a function
Message-ID: <20230627-4d207186c4ef81be43c9d874@orel>
References: <cover.1687515463.git.haibo1.xu@intel.com>
 <341feff384c9f8a20ed4aac6e2dda0440d6b84f2.1687515463.git.haibo1.xu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <341feff384c9f8a20ed4aac6e2dda0440d6b84f2.1687515463.git.haibo1.xu@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 23, 2023 at 06:40:10PM +0800, Haibo Xu wrote:
> No functional changes. Just move the reject_set check logic to a
> function so we can check for specific errno for specific register.
> This is a preparation for support reject_set in riscv.
> 
> Suggested-by: Andrew Jones <ajones@ventanamicro.com>
> Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> ---
>  tools/testing/selftests/kvm/aarch64/get-reg-list.c | 8 ++++++++
>  tools/testing/selftests/kvm/get-reg-list.c         | 7 ++++++-
>  2 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> index aaf035c969ec..4e2e1fe833eb 100644
> --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> @@ -27,6 +27,14 @@ bool filter_reg(__u64 reg)
>  	return false;
>  }
>  
> +bool reject_set_fail(__u64 reg)
> +{
> +	if (reg == KVM_REG_ARM64_SVE_VLS)
> +		return (errno != EPERM);
> +
> +	return false;
> +}

I think we should pass errno in as a parameter and I prefer positive
predicate functions, so I'd name this check_reject_set() and reverse
the logic. Also, we don't want to check for KVM_REG_ARM64_SVE_VLS,
because that duplicates the rejects set. I see in a later patch
that riscv needs to check reg because different errors are used
for different registers, but that's because KVM_REG_RISCV_TIMER_REG(state)
was erroneously added to the rejects set. KVM_REG_RISCV_TIMER_REG(state)
doesn't belong there. That register can be set, but it only supports
certain input, otherwise, it correctly, results in EINVAL. We'll need
the concept of a "skip set" to avoid tripping over that one.

So, I think arm's function should be

 bool check_reject_set(int errno)
 {
     return errno == EPERM;
 }

and riscv's should be

 bool check_reject_set(int errno)
 {
     return errno == EOPNOTSUPP;
 }

> +
>  #define REG_MASK (KVM_REG_ARCH_MASK | KVM_REG_SIZE_MASK | KVM_REG_ARM_COPROC_MASK)
>  
>  #define CORE_REGS_XX_NR_WORDS	2
> diff --git a/tools/testing/selftests/kvm/get-reg-list.c b/tools/testing/selftests/kvm/get-reg-list.c
> index f6ad7991a812..b956ee410996 100644
> --- a/tools/testing/selftests/kvm/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/get-reg-list.c
> @@ -98,6 +98,11 @@ void __weak print_reg(const char *prefix, __u64 id)
>  	printf("\t0x%llx,\n", id);
>  }
>  
> +bool __weak reject_set_fail(__u64 reg)
> +{
> +	return false;
> +}
> +
>  #ifdef __aarch64__
>  static void prepare_vcpu_init(struct vcpu_reg_list *c, struct kvm_vcpu_init *init)
>  {
> @@ -216,7 +221,7 @@ static void run_test(struct vcpu_reg_list *c)
>  			if (s->rejects_set && find_reg(s->rejects_set, s->rejects_set_n, reg.id)) {
>  				reject_reg = true;
>  				ret = __vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
> -				if (ret != -1 || errno != EPERM) {
> +				if (ret != -1 || reject_set_fail(reg.id)) {
>  					printf("%s: Failed to reject (ret=%d, errno=%d) ", config_name(c), ret, errno);
>  					print_reg(config_name(c), reg.id);
>  					putchar('\n');
> -- 
> 2.34.1
>

Thanks,
drew
