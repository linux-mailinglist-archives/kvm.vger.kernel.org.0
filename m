Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1DF74F570
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 18:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233429AbjGKQd2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 12:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233421AbjGKQdF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 12:33:05 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75DE210C4;
        Tue, 11 Jul 2023 09:32:51 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-66c729f5618so5174496b3a.1;
        Tue, 11 Jul 2023 09:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689093170; x=1691685170;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UhCv7ij8x1pOlset39Oaz9+RB/0V1BBSqVlCMCRIhxI=;
        b=GDG6/MLFxdRV/HIVa34aoxVfgdHvb+65IuZcu4RJeSzjj7Lgggdw2TNhg2ZI2jqKDS
         ioe0AcKVhyRN4e4XWrJl+KGatb1kPWP0BonPFcArWJQnFJqSfqMYQQNwX0Z0NB10Vz0F
         T2VII+6TCbCw/uX8WtPYA7TFpGdB6q1xyervSEgpsGYToVcQqtkZZdS2aKCy+/G0p8jE
         9EBgh9EJx1Q73rRgKDcrMHjuMHQn0ljIIH8BY2YQPQ5x0g6D0mRdk3IgK9e8qFRLGf3c
         mzExEvkK1iFL7dGYO5f8D0JVT3sADOaK1x0t4djb3+tACQFrfOn9B7DIbp66RTHPjaan
         Ky5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689093170; x=1691685170;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UhCv7ij8x1pOlset39Oaz9+RB/0V1BBSqVlCMCRIhxI=;
        b=Y+Xk+YcTrlZ4VNKlLTzL5OPb1gdhhO+j1eAooKOyvzBYZ2M1AePITtvOIVRueoQpYl
         jr2CCUC6dftU7n54ukSy4kGxiQsMddB2QyfvSqRVvtefz7JMmjVXme7L6zrjdL9lHyCS
         8D1O6oJvHKn3L5nh9jZNR8jB/Up562xkHMJeVtrYC9YVEYnC55djorPOy7IY0hYYVP8H
         6sLbDuzRN1Zn5Rdgu7ojl0KIbRgmBLZSdMnm4WG3zU5bxkeDdC+4TVYxOmyd2dF579+F
         xkcuSfGE+6jcNVT6te7pZseMzszW7BlKMsdSfZ6Kd9bB23KO8jrhhJ3Q0fOxuky0+2JZ
         86/w==
X-Gm-Message-State: ABy/qLZgJg2c2JDS6LAmUDSeIcQC+AySAnf5O0+/eBtExzqRfCysCYvb
        VxwlZLIQMHiUFgSf3DgjoI7QuVT6961a7Wcz
X-Google-Smtp-Source: APBJJlEYX8MP7cdCsuhoVmMV0duMmMivth79k3DahAyDgJT8EIrgNpWQhckIbIT8w78EAZQzlWT24w==
X-Received: by 2002:a05:6a00:cce:b0:682:537f:2cb8 with SMTP id b14-20020a056a000cce00b00682537f2cb8mr21087293pfv.26.1689093169971;
        Tue, 11 Jul 2023 09:32:49 -0700 (PDT)
Received: from [192.168.255.10] ([114.84.31.161])
        by smtp.gmail.com with ESMTPSA id j23-20020aa79297000000b006636c4f57a6sm1930119pfa.27.2023.07.11.09.32.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jul 2023 09:32:49 -0700 (PDT)
Message-ID: <81c32ae2-ff21-131f-e498-f87b1e7fe3b5@gmail.com>
Date:   Wed, 12 Jul 2023 00:32:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.0
Subject: Re: [PATCH 4/4] KVM: x86/pmu: Move .hw_event_available() check out of
 PMC filter helper
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230607010206.1425277-1-seanjc@google.com>
 <20230607010206.1425277-5-seanjc@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20230607010206.1425277-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/6/7 09:02, Sean Christopherson wrote:
> Move the call to kvm_x86_pmu.hw_event_available(), which has nothing to
> with the userspace PMU filter, out of check_pmu_event_filter() and into
> its sole caller pmc_event_is_allowed().  pmc_event_is_allowed() didn't
> exist when commit 7aadaa988c5e ("KVM: x86/pmu: Drop amd_event_mapping[]
> in the KVM context"), so presumably the motivation for invoking
> .hw_event_available() from check_pmu_event_filter() was to avoid having
> to add multiple call sites.

The event unavailability check based on intel cpuid is, in my opinion,
part of our pmu_event_filter mechanism. Unavailable events can be
defined either by KVM userspace or by architectural cpuid (if any).

The bigger issue here is what happens when the two rules conflict, and
the answer can be found more easily by putting the two parts in one
function (the architectural cpuid rule takes precedence).

> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/pmu.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 1690d41c1830..2a32dc6aa3f7 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -387,9 +387,6 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
>   	struct kvm_x86_pmu_event_filter *filter;
>   	struct kvm *kvm = pmc->vcpu->kvm;
>   
> -	if (!static_call(kvm_x86_pmu_hw_event_available)(pmc))
> -		return false;
> -
>   	filter = srcu_dereference(kvm->arch.pmu_event_filter, &kvm->srcu);
>   	if (!filter)
>   		return true;
> @@ -403,6 +400,7 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
>   static bool pmc_event_is_allowed(struct kvm_pmc *pmc)
>   {
>   	return pmc_is_globally_enabled(pmc) && pmc_speculative_in_use(pmc) &&
> +	       static_call(kvm_x86_pmu_hw_event_available)(pmc) &&
>   	       check_pmu_event_filter(pmc);
>   }
>   
