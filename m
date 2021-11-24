Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48EE045C9AC
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 17:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242112AbhKXQSJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 11:18:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:48076 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230368AbhKXQSI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Nov 2021 11:18:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637770498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mJrAXo0yOwYDhqzWJltPdXBtYsqn5jxXKwheMp22Ick=;
        b=avdladGihBr7aE8k9duo47r8wmBBuVxuJH1YPrWy3mRvA0Ue0vVUShKvauVCGlUMAHb26T
        NYGhu6zoBKFI5q5sDDVuFk66FyjvGsQiH+lXT2VEeS7jnyf/fOZ5y0GbtgfaiC6Gxn59nx
        2ieIc7EOOunNk7BILK/HZiml11z61Ls=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-191-24gy4WrKNQGqEOlRFfln-Q-1; Wed, 24 Nov 2021 11:14:56 -0500
X-MC-Unique: 24gy4WrKNQGqEOlRFfln-Q-1
Received: by mail-wm1-f71.google.com with SMTP id o18-20020a05600c511200b00332fa17a02eso1706993wms.5
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 08:14:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=mJrAXo0yOwYDhqzWJltPdXBtYsqn5jxXKwheMp22Ick=;
        b=cbdlp3Ut6S4CknpWsCZ1gfB3tbaviRPPA46LfXZRf2v/Tx3ZUzhDlm7H0n32jsS+7J
         6dVE4+/APP1qVIlDH5QZtMNU3uersenb1GMPxzGr1N4z0uHk1ge6xpQeFyZzqXgcmYRW
         Q70lJj5/h++sQaYFs7vLtFJX9xCoyY0YwvpuxsuT4w93pqNQFHptvmMMhkvwLdHQyltc
         6v8pDfcrIl6uUcv4MblrFR+pfcu/58zQlhgMZqJ5l680olBKygRse/Quf7LxE8I94aw3
         m6atT20htwmLDEGHwzUg6NH8AXG6FanXUjt+WCimOAZQq/TbMMPvdF5nVb7F4UznkTwy
         GbHw==
X-Gm-Message-State: AOAM531fsRu6zc21uDPt9zhsFdO5+Q1MlVNrZbw2hiPqTLMR/k/zPL2R
        b/IMJky7rmH61O+bwIjyW4rmrzuyeepzq7H+h1N2bnNvKuNBUhiBuMdJgZqKWSIoORpRQoIL23H
        J+G5bosOrsvMh
X-Received: by 2002:a1c:448b:: with SMTP id r133mr17043663wma.85.1637770495400;
        Wed, 24 Nov 2021 08:14:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJymmCc+u6oBfH4XVYWnBhwOgHSX0hlfUcbUYa1AN2TAUKehwrKpAWg2/27EFWQM986LicPmXg==
X-Received: by 2002:a1c:448b:: with SMTP id r133mr17043615wma.85.1637770495102;
        Wed, 24 Nov 2021 08:14:55 -0800 (PST)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id b6sm5303470wmq.45.2021.11.24.08.14.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 08:14:54 -0800 (PST)
Date:   Wed, 24 Nov 2021 17:14:53 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc:     kvm@vger.kernel.org, Will Deacon <will@kernel.org>, maz@kernel.org,
        qemu-arm@nongnu.org, idan.horowitz@gmail.com,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [kvm-unit-tests PATCH v8 08/10] arm/barrier-litmus-tests: add
 simple mp and sal litmus tests
Message-ID: <20211124161453.aqkcykcfq5gphvzw@gator>
References: <20211118184650.661575-1-alex.bennee@linaro.org>
 <20211118184650.661575-9-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211118184650.661575-9-alex.bennee@linaro.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 18, 2021 at 06:46:48PM +0000, Alex Bennée wrote:
> This adds a framework for adding simple barrier litmus tests against
> ARM. The litmus tests aren't as comprehensive as the academic exercises
> which will attempt to do all sorts of things to keep racing CPUs synced
> up. These tests do honour the "sync" parameter to do a poor-mans
> equivalent.
> 
> The two litmus tests are:
>   - message passing
>   - store-after-load
> 
> They both have case that should fail (although won't on single-threaded
> TCG setups). If barriers aren't working properly the store-after-load
> test will fail even on an x86 backend as x86 allows re-ording of non
> aliased stores.
> 
> I've imported a few more of the barrier primatives from the Linux source
> tree so we consistently use macros.
> 
> The arm64 barrier primitives trip up on -Wstrict-aliasing so this is
> disabled in the Makefile.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> CC: Will Deacon <will@kernel.org>
> 
> ---
> v8
>   - move to mttcgtests.cfg
>   - fix checkpatch issues
>   - fix report usage
> v7
>   - merge in store-after-load
>   - clean-up sync-up code
>   - use new counter api
>   - fix xfail for sal test
> v6
>   - add a unittest.cfg
>   - -fno-strict-aliasing
> ---
>  arm/Makefile.common       |   1 +
>  lib/arm/asm/barrier.h     |  61 ++++++
>  lib/arm64/asm/barrier.h   |  50 +++++
>  arm/barrier-litmus-test.c | 450 ++++++++++++++++++++++++++++++++++++++
>  arm/mttcgtests.cfg        |  33 +++
>  5 files changed, 595 insertions(+)
>  create mode 100644 arm/barrier-litmus-test.c
> 
> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index f905971..861e5c7 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -13,6 +13,7 @@ tests-common += $(TEST_DIR)/sieve.flat
>  tests-common += $(TEST_DIR)/pl031.flat
>  tests-common += $(TEST_DIR)/tlbflush-code.flat
>  tests-common += $(TEST_DIR)/locking-test.flat
> +tests-common += $(TEST_DIR)/barrier-litmus-test.flat
>  
>  tests-all = $(tests-common) $(tests)
>  all: directories $(tests-all)
> diff --git a/lib/arm/asm/barrier.h b/lib/arm/asm/barrier.h
> index 7f86831..2870080 100644
> --- a/lib/arm/asm/barrier.h
> +++ b/lib/arm/asm/barrier.h
> @@ -8,6 +8,8 @@
>   * This work is licensed under the terms of the GNU GPL, version 2.
>   */
>  
> +#include <stdint.h>
> +
>  #define sev()		asm volatile("sev" : : : "memory")
>  #define wfe()		asm volatile("wfe" : : : "memory")
>  #define wfi()		asm volatile("wfi" : : : "memory")
> @@ -25,4 +27,63 @@
>  #define smp_rmb()	smp_mb()
>  #define smp_wmb()	dmb(ishst)
>  
> +extern void abort(void);
> +
> +static inline void __write_once_size(volatile void *p, void *res, int size)
> +{
> +	switch (size) {
> +	case 1: *(volatile uint8_t *)p = *(uint8_t *)res; break;
> +	case 2: *(volatile uint16_t *)p = *(uint16_t *)res; break;
> +	case 4: *(volatile uint32_t *)p = *(uint32_t *)res; break;
> +	case 8: *(volatile uint64_t *)p = *(uint64_t *)res; break;
> +	default:
> +		/* unhandled case */
> +		abort();
> +	}
> +}
> +
> +#define WRITE_ONCE(x, val) \
> +({							\
> +	union { typeof(x) __val; char __c[1]; } __u =	\
> +		{ .__val = (typeof(x)) (val) }; \
> +	__write_once_size(&(x), __u.__c, sizeof(x));	\
> +	__u.__val;					\
> +})
> +
> +#define smp_store_release(p, v)						\
> +do {									\
> +	smp_mb();							\
> +	WRITE_ONCE(*p, v);						\
> +} while (0)
> +
> +
> +static inline
> +void __read_once_size(const volatile void *p, void *res, int size)
> +{
> +	switch (size) {
> +	case 1: *(uint8_t *)res = *(volatile uint8_t *)p; break;
> +	case 2: *(uint16_t *)res = *(volatile uint16_t *)p; break;
> +	case 4: *(uint32_t *)res = *(volatile uint32_t *)p; break;
> +	case 8: *(uint64_t *)res = *(volatile uint64_t *)p; break;
> +	default:
> +		/* unhandled case */
> +		abort();
> +	}
> +}
> +
> +#define READ_ONCE(x)							\
> +({									\
> +	union { typeof(x) __val; char __c[1]; } __u;			\
> +	__read_once_size(&(x), __u.__c, sizeof(x));			\
> +	__u.__val;							\
> +})


WRITE_ONCE and READ_ONCE are already defined in lib/linux/compiler.h

Thanks,
drew

