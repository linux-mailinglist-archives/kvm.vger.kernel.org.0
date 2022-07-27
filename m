Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7CC458355C
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 00:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235229AbiG0WmR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 18:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbiG0WmQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 18:42:16 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45EB35C9C6
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 15:42:15 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id o12so378005pfp.5
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 15:42:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NYAvAw9cVOoPnQbWeVJn8GPEaPKmeSC20kSm+BsfcGc=;
        b=nAM5FKKiZyv18t23cbcc4URV/I6nC6QJ7PQksL4sN5wARqcMZ8yIgI0922LrZ1IMP8
         QAARCHSnjO/CJzU42f0C4FqBaFKGhVUc4uMtzWtaX8tvzYyiucy5TCUKsXxqCJ+ftWgm
         9V5kfMvXh670C9rVeodUxpSd1QLiiHvgz4eodX769O9aBtda39o8He4YF20lmFauLTnW
         Z/cGo4E7fjVZKVlildsJoj1WlzAfEKsfj1SLNQWX5MBIOar9yfqrmFElVCkq9jLh3AxL
         89p2GRyTJT6VjSa8QuPCLEFF9Is3sIO1SRC3SrC97M2mUqqRVO5cOk/TM3/EGaR3zUyM
         8lbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NYAvAw9cVOoPnQbWeVJn8GPEaPKmeSC20kSm+BsfcGc=;
        b=tP2S7rrCAIwNNILssY/UMfjaeDuyDtTYkCih+8uzBw0WDFLzrPH4nl2N5NFjBL5+xj
         1cqiwfbYFR0g5VKx712JK6fTPFueG84SbGPm83SrfTEtdlP8HzP+BZ9ZjtM3uehMI/h9
         B4DuAEGw1KUwpAnx21BPBWf1Lic5CMR7KXNsf+6A+tLyGGGaELP3TIj/zgMYjzQ6jiK9
         pzrCuzeGpZCbOAUOm+UYwbmUZHVY7e8v/wGv+ZHIiSaq6sq/YOb6Sg4o5+GnS2kQw6xb
         va9aOiQeXuqcaLMAbDiMNDopFn/hJw1uvRVw404DazUl4kzOz/1zhmRPZLYjs0o+uA1l
         vGCQ==
X-Gm-Message-State: AJIora8AYDIuIFKRmWCpPCmfWjayqGi8dT/kMtfKB8WuOfeLL8tV8pCM
        IhlEJf9VL1j3MrSF3TAL6G8f6w==
X-Google-Smtp-Source: AGRyM1vTFkf4+0TEEy64B/IkyBMp9gDI09JYWDcoFl7iFoQjdbrkCfM8e4ZDDVK2Uv5MNT+o4rXewg==
X-Received: by 2002:a63:e80e:0:b0:419:d02c:fc8b with SMTP id s14-20020a63e80e000000b00419d02cfc8bmr20255708pgh.385.1658961734594;
        Wed, 27 Jul 2022 15:42:14 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i14-20020a17090332ce00b0016a33177d3csm14503714plr.160.2022.07.27.15.42.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 15:42:13 -0700 (PDT)
Date:   Wed, 27 Jul 2022 22:42:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] x86: Add tests for Guest Processor Event
 Based Sampling (PEBS)
Message-ID: <YuG/QtIM/fvhLI/u@google.com>
References: <20220721103549.49543-1-likexu@tencent.com>
 <20220721103549.49543-9-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220721103549.49543-9-likexu@tencent.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 21, 2022, Like Xu wrote:
> +union perf_capabilities {
> +	struct {
> +		u64	lbr_format:6;
> +		u64	pebs_trap:1;
> +		u64	pebs_arch_reg:1;
> +		u64	pebs_format:4;
> +		u64	smm_freeze:1;
> +		/*
> +		 * PMU supports separate counter range for writing
> +		 * values > 32bit.
> +		 */
> +		u64	full_width_write:1;
> +		u64 pebs_baseline:1;
> +		u64	perf_metrics:1;
> +		u64	pebs_output_pt_available:1;
> +		u64	anythread_deprecated:1;
> +	};
> +	u64	capabilities;
> +};
> +
> +union cpuid10_eax {
> +        struct {
> +                unsigned int version_id:8;
> +                unsigned int num_counters:8;
> +                unsigned int bit_width:8;
> +                unsigned int mask_length:8;
> +        } split;
> +        unsigned int full;
> +} pmu_eax;
> +
> +union cpuid10_edx {
> +        struct {
> +                unsigned int num_counters_fixed:5;
> +                unsigned int bit_width_fixed:8;
> +                unsigned int reserved:19;
> +        } split;
> +        unsigned int full;
> +} pmu_edx;

The generic unions are hopefully unnecessary now that helpers are provided by
lib/x86/processor.h, e.g. for pmu_version().

I would prefer to have similar helpers instead of "union perf_capabilities",
but it's not a sticking point if helpers a signifiantly more painful to use.

> +	if (!is_intel() || (pmu_eax.split.version_id < 2) ||
> +	    !(perf.capabilities & PERF_CAP_PEBS_FORMAT) ||
> +	    (rdmsr(MSR_IA32_MISC_ENABLE) & MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL)) {

Split these up, it's really, really annoying to have to guess which one of the
four checks failed.

> +		report_skip("This platform doesn't support guest PEBS.");
> +		return 0;

This needs be be "return report_summary()", otherwise the test says pass when it
didn't do anyting:

 TESTNAME=pmu_pebs TIMEOUT=90s ACCEL=kvm ./x86/run x86/pmu_pebs.flat -smp 1 -cpu host,migratable=no
 PASS pmu_pebs 

wait a second...

  SKIP: This platform doesn't support guest PEBS.

E.g. (though if KUT can provide more information on why PERF_CAP_PEBS_FORMAT
may not be advertised, e.g. requires ICX+?, that would be nice to have)

        if (!is_intel()) {
                report_skip("PEBS is only supported on Intel CPUs");
                return report_summary();
        }
        if (pmu_version() < 2) {
                report_skip("Architectural PMU not available");
                return report_summary();
        }
        if (!(perf.capabilities & PERF_CAP_PEBS_FORMAT)) {
                report_skip("PEBS not enumerated in PERF_CAPABILITIES");
                return report_summary();
        }
        if (rdmsr(MSR_IA32_MISC_ENABLE) & MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL) {
                report_skip("PEBS unavailable according to MISC_ENABLE");
                return report_summary();
        }
