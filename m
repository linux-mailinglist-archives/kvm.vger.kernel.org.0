Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3F22696C3E
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 19:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbjBNSDp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 13:03:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbjBNSDo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 13:03:44 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 262C52B2A1
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 10:03:43 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id q127-20020a25d985000000b009362f0368aeso4126198ybg.3
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 10:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Bk+f22HFGRshmH5QUuAzOacVnCT3IjpFp9tZOTami+M=;
        b=KhoXltQMOeY6BXTwpnEI/BBCXoJIYvnSDqakl4l/z3CbwiGzalhKuAc/02otpKL4JC
         K0kuue3aUE/0BhhMc3C7jCS1JlAr7kfon3VZ0dtaXswbfoyhpnxpLSr7YXAty1Fd0pud
         Q2mirdmaYcsKAYvVMWldQFG7pKdPJdPwrv596HOZ8tzaAq/V8hpDjH6aYCQul8js8UZl
         WRJDJcGROSamVxkFbUZ86UUU0RfaKAv4fRKyGWRb39UlHemGFn0xoETSXxU++pkpIcVK
         FknRO5NGjlzdIEwFNqnshxsZvNDWm05e2u8YcUS7TLXieSjrx4S3ychpOHYPaytPkd52
         0wKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bk+f22HFGRshmH5QUuAzOacVnCT3IjpFp9tZOTami+M=;
        b=Yy8NJb7tGY4gOWijPqddyYU19S/wN0QiYOIA2ThQoD6yDVIUKte1dYa9sAwNUsor+M
         lLD52JGflDDX4FNUUxFscSiBtcea+iMynkSrR5a2rCf8YoDilJg7f5Lax5ksSG+jRkw1
         hWlRDDDapgXBMJO/Lkc6d2RP8kc9Q5rUELZTT2o/y337UkYiUaQiJwT+tAt2gbwSPdTK
         IM9axP65/shD48tYqiGUwriXd2DfIO6940AQgUu0q7pvxGXxSVdoASfE6J1NTwJISAet
         A8XzwocHeSFM16OGB/ZBvzp/zSWNGUZHp0IstRpTOsa9TgBKq5OE6mXHc8RgdnR7tbDu
         eBqQ==
X-Gm-Message-State: AO0yUKUoErn1tp/it1HKt95D6zOnnzY7uaVSHBMoCZqbqPEAwvTYzZ2z
        noQcyY/D0UhtjKuFypC8g6ZbMAT6xDI=
X-Google-Smtp-Source: AK7set8yymJUlXsVxH9MgrKTIr6rjkN/DxWkSEg/qj8Xf3PjvLJi7wEBzJReR2v1e/8/DqS8BZM2w+0LGQI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:34d:0:b0:7c8:ba83:62de with SMTP id
 q13-20020a5b034d000000b007c8ba8362demr397281ybp.114.1676397822387; Tue, 14
 Feb 2023 10:03:42 -0800 (PST)
Date:   Tue, 14 Feb 2023 10:03:40 -0800
In-Reply-To: <20230214084920.59787-3-likexu@tencent.com>
Mime-Version: 1.0
References: <20230214084920.59787-1-likexu@tencent.com> <20230214084920.59787-3-likexu@tencent.com>
Message-ID: <Y+vM/KBFNGd+SX9l@google.com>
Subject: Re: [PATCH 2/2] KVM: selftests: Report enable_pmu module value when
 test is skipped
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 14, 2023, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> Running x86_64/pmu_event_filter_test with enable_pmu globally disabled
> will report the following skipping prompt:
> 	1..0 # SKIP - Requirement not met: use_intel_pmu() || use_amd_pmu()
> this can be confusing, so add a check on enable_pmu.
> 
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> index bad7ef8c5b92..070bc8a60a7f 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> @@ -771,6 +771,7 @@ int main(int argc, char *argv[])
>  	TEST_REQUIRE(kvm_has_cap(KVM_CAP_PMU_EVENT_FILTER));
>  	TEST_REQUIRE(kvm_has_cap(KVM_CAP_PMU_EVENT_MASKED_EVENTS));
>  
> +	TEST_REQUIRE(get_kvm_param_bool("enable_pmu"));

I think it makes sense to put this at the very top, just in case more requirements
that depend on enable_pmu get added in the future.  I can do that when applying.

I'll plan on grabbing this for 6.4.

Thanks!
