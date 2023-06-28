Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71313741935
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 22:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbjF1UDL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 16:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231897AbjF1UC5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 16:02:57 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 996AD1BEA
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 13:02:55 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-55ac8f85360so57389a12.0
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 13:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687982575; x=1690574575;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aF+eaqoyjG8K7JrTXAx7p+ekpq66+KyCCJ2W8xApmu4=;
        b=yiXMZe1WRiCBewd8cQIpLAFHrBNvdVKQGotoGoxyUI+Nt8m67zl9/LQsJJTjIY4dTr
         UVCUCQagQXdkhQQCP2zgCKYg73b+Q9jTHV+/C9rrSL5Ds1bXsWZ5vP5WK7LtMrPNBl83
         XA6uYZItHwh/nTj5wL4klFmcXVsz0ZOkw8N9xrnS0ey/9J85y8+wmME4Al6uHDg42AWq
         yyqm9wMuiW0FejgZ0IBHG18KhoC4gzy1mWpIY/OOtVt1MKpipmJruIk3/eoSgFd1PQXl
         e9WFa9Ue90gV7m+cWv3dfOPUuyoGXpQ82UA7TjuD0LzX/lZtRvxXQxyboNIZDS4cOL62
         98ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687982575; x=1690574575;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aF+eaqoyjG8K7JrTXAx7p+ekpq66+KyCCJ2W8xApmu4=;
        b=hPRUhBQl2AsTyZBev9/QdR01frYA+B6Re40GLlkR0hKhhOxY0iX33ool06G1qSmdid
         XzhKvWCNZEl6ZI/Tlkp/C2K8HY9kJstMneb0pGlnXcpsn7ZUUuuyG911o4aSMekqBnq3
         BbqS8tENg33SPQrJPRqfeGap2VD7naX+qlQ+dnzAebSIDk0mI9ka0bIGw/1AuMWqBFJf
         lXyLPk4L2pFjyjGXD+QYWRlMTO1g+ly8sg5hMrGlsKhon2o6R6j1TNwsjPz2bTb2lQXx
         +D+XEEvoCa27iJ5RqBLIoouPk+jJdB6MluO06Ohu10WeB9uqYdVkp88fEnlog3z8E/iC
         eMww==
X-Gm-Message-State: AC+VfDz4guzHQ/ReArrlOZ9pZNrpfTZZRLuhvCBKWDW6xIeCVHeYBQ9E
        Dpd7RfoZFGntnqNLMW/TLhzqOZGyMeA=
X-Google-Smtp-Source: ACHHUZ5bO34e6p8FZc9bz44vcDbWILB0WTqbsNIRWGQhflnvBOZc6PKwqE2im4IFVlHM6ZRuwHrSr8ltKMg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:fa45:0:b0:52c:8878:65dd with SMTP id
 g5-20020a63fa45000000b0052c887865ddmr3637339pgk.0.1687982575114; Wed, 28 Jun
 2023 13:02:55 -0700 (PDT)
Date:   Wed, 28 Jun 2023 13:02:53 -0700
In-Reply-To: <20230530134248.23998-3-cloudliang@tencent.com>
Mime-Version: 1.0
References: <20230530134248.23998-1-cloudliang@tencent.com> <20230530134248.23998-3-cloudliang@tencent.com>
Message-ID: <ZJyR7XzVeOu8IN9n@google.com>
Subject: Re: [PATCH v2 2/8] KVM: selftests: Add pmu.h for PMU events and
 common masks
From:   Sean Christopherson <seanjc@google.com>
To:     Jinrong Liang <ljr.kernel@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Like Xu <likexu@tencent.com>,
        David Matlack <dmatlack@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 30, 2023, Jinrong Liang wrote:
> From: Jinrong Liang <cloudliang@tencent.com>
> 
> To introduce a new pmu.h header file under
> tools/testing/selftests/kvm/include/x86_64 directory to better
> organize the PMU performance event constants and common masks.
> It will enhance the maintainability and readability of the KVM
> selftests code.
> 
> In the new pmu.h header, to define the PMU performance events and
> masks that are relevant for x86_64, allowing developers to easily
> reference them and minimize potential errors in code that handles
> these values.

Same feedback as the previous changelog.

> Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
> ---
>  .../selftests/kvm/include/x86_64/pmu.h        | 56 +++++++++++++++++++
>  1 file changed, 56 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/include/x86_64/pmu.h
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/pmu.h b/tools/testing/selftests/kvm/include/x86_64/pmu.h
> new file mode 100644
> index 000000000000..0e0111b11024
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/include/x86_64/pmu.h
> @@ -0,0 +1,56 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * tools/testing/selftests/kvm/include/x86_64/pmu.h
> + *
> + * Copyright (C) 2023, Tencent, Inc.
> + */
> +#ifndef _PMU_H_
> +#define _PMU_H_

SELFTEST_KVM_PMU_H for consistency, and to minimize the risk of a collision.

> +#include "processor.h"
> +
> +#define GP_CTR_NUM_OFS_BIT 8
> +#define EVT_LEN_OFS_BIT 24

Please spell out the words, I genuinely have no idea what these refer to, and
readers shouldn't have to consult the SDM just to understand a name.

> +#define INTEL_PMC_IDX_FIXED 32
> +
> +#define PMU_CAP_FW_WRITES BIT_ULL(13)
> +#define EVENTSEL_OS BIT_ULL(17)
> +#define EVENTSEL_ANY BIT_ULL(21)
> +#define EVENTSEL_EN BIT_ULL(22)
> +#define RDPMC_FIXED_BASE BIT_ULL(30)
> +
> +#define PMU_VERSION_MASK GENMASK_ULL(7, 0)
> +#define EVENTS_MASK GENMASK_ULL(7, 0)
> +#define EVT_LEN_MASK GENMASK_ULL(31, EVT_LEN_OFS_BIT)
> +#define GP_CTR_NUM_MASK GENMASK_ULL(15, GP_CTR_NUM_OFS_BIT)
> +#define FIXED_CTR_NUM_MASK GENMASK_ULL(4, 0)
> +
> +#define X86_INTEL_PMU_VERSION		kvm_cpu_property(X86_PROPERTY_PMU_VERSION)
> +#define X86_INTEL_MAX_GP_CTR_NUM	kvm_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS)
> +#define X86_INTEL_MAX_FIXED_CTR_NUM	kvm_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS)
> +#define X86_INTEL_FIXED_CTRS_BITMASK	kvm_cpu_property(X86_PROPERTY_PMU_FIXED_CTRS_BITMASK)

Please don't add macros like this.  It gives the false impression that all these
values are constant at compile time, which is very much not the case.  I really,
really dislike code that hides important details, like the fact that this is
querying KVM.

Yeah, the line lengths will be longer, but 80 chars is a soft limit, and we can
always get creative, e.g.

	uint8_t max_pmu_version = kvm_cpu_property(X86_PROPERTY_PMU_VERSION);
	struct kvm_vm *vm;
	struct kvm_vcpu *vcpu;
	uint8_t version;

	TEST_REQUIRE(kvm_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS) > 2);

> +/* Definitions for Architectural Performance Events */
> +#define ARCH_EVENT(select, umask) (((select) & 0xff) | ((umask) & 0xff) << 8)
> +
> +/* Intel Pre-defined Architectural Performance Events */
> +static const uint64_t arch_events[] = {
> +	[0] = ARCH_EVENT(0x3c, 0x0),
> +	[1] = ARCH_EVENT(0xc0, 0x0),
> +	[2] = ARCH_EVENT(0x3c, 0x1),
> +	[3] = ARCH_EVENT(0x2e, 0x4f),
> +	[4] = ARCH_EVENT(0x2e, 0x41),
> +	[5] = ARCH_EVENT(0xc4, 0x0),
> +	[6] = ARCH_EVENT(0xc5, 0x0),
> +	[7] = ARCH_EVENT(0xa4, 0x1),

Please do something like I proposed for KVM, i.e. avoid magic numbers inasmuch
as possible.

https://lore.kernel.org/all/20230607010206.1425277-2-seanjc@google.com

> +};
> +
> +/* Association of Fixed Counters with Architectural Performance Events */
> +static int fixed_events[] = {1, 0, 7};
> +
> +static inline uint64_t evt_code_for_fixed_ctr(uint8_t idx)

s/evt/event.  Having consistent naming is more important than saving two characters.

> +{
> +	return arch_events[fixed_events[idx]];
> +}
> +
> +#endif /* _PMU_H_ */
> -- 
> 2.31.1
> 
