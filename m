Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA8B7780190
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 01:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356026AbjHQXSz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 19:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356019AbjHQXSX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 19:18:23 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FBAC30C2
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 16:18:22 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-564fec87e4fso558261a12.0
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 16:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692314301; x=1692919101;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cF5cqh5eSeWqKpcJHB/Zh6MI6Yxqy+jI72/iuIwTH3U=;
        b=7C9cK3teVRAECzMuc/HAmfFmfVsWI/cAzkUb3dlz1+qlHi1jB2vT7PNXLjHFVj6s3X
         tLZANZgICEchQiox7a8NIPYA5CMP73qDntXWL8WCvlW0O6paM25v+LVYYf5dIDhIfYoq
         SQS/h/wDuSSbBRqQ2tGidLlbxL8LRLM8ykeWIqluQ2On9upMXgfjEHpQSpKFlaGU9zmk
         8XTRIU1ob715OPtIAyU2to4dU38u6s5QFchJm9pi5Nq50ef0fwKmgGPlrClU4Okw0gSJ
         CNJttj7DDKMKHn3iTOysqbrx8t4Nu0jJef9H1ekcA93I8FTqn3Oyy4p2YhzeQhP1jQ+U
         d8cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692314301; x=1692919101;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cF5cqh5eSeWqKpcJHB/Zh6MI6Yxqy+jI72/iuIwTH3U=;
        b=KC4gMOJ6B5qVqweXyZb/ysjNV8AGoruBlbNcSxJcU/LhxRj+H/jEWzzGcXZFqL3oBj
         +SCpTb7l0Ogyy5MySapyIH7xNx+iGbz2ejSIwL0h+oXTxnSx9N05TD8uYDKj3257bx8D
         qSYjBIBVCvyLKi35Bi9nfFofutLCZA6xzH3ri8IBW1xs2ZFtqMaU1w0o9eW+L8VxUpiO
         6ZgGX7yDEruLXLJwLLju5BApGjulB9qHVtcFovv/UyQrzEh0Z2m+Bjvt8oBY9hbyIHPG
         0JjQ0K2dOJBxVmInKct3wAEOV31p3I+oiJGKiN4p3ZKopEZpw57Qa6yOdsYoAm5MMYQr
         6dKQ==
X-Gm-Message-State: AOJu0Yz8Zrr9t3iqO3VJjuTLdjFfwaqQv/WTjzq39TvTH/X8ThlprMc9
        TVEuFK3+u3P1uCDJZaN22BOhi4W2OWU=
X-Google-Smtp-Source: AGHT+IHRBQOFxmQ97oxi/zBzVqP8369xTvSCxMxOhLT68qoD3Gaz1CT8J6qRN6HZFRbKZ4VMQgGUql8XP6I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:b51c:0:b0:564:aca2:b22c with SMTP id
 y28-20020a63b51c000000b00564aca2b22cmr140591pge.4.1692314301567; Thu, 17 Aug
 2023 16:18:21 -0700 (PDT)
Date:   Thu, 17 Aug 2023 16:18:20 -0700
In-Reply-To: <ZN6mfSWLScLjdyCz@google.com>
Mime-Version: 1.0
References: <20230814115108.45741-1-cloudliang@tencent.com>
 <20230814115108.45741-6-cloudliang@tencent.com> <ZN6mfSWLScLjdyCz@google.com>
Message-ID: <ZN6qvKnltoyzbzDW@google.com>
Subject: Re: [PATCH v3 05/11] KVM: selftests: Test consistency of CPUID with
 num of gp counters
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
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 17, 2023, Sean Christopherson wrote:
> On Mon, Aug 14, 2023, Jinrong Liang wrote:
> > From: Jinrong Liang <cloudliang@tencent.com>
> > 
> > Add test to check if non-existent counters can be accessed in guest after
> > determining the number of Intel generic performance counters by CPUID.
> > When the num of counters is less than 3, KVM does not emulate #GP if
> > a counter isn't present due to compatibility MSR_P6_PERFCTRx handling.
> > Nor will the KVM emulate more counters than it can support.
> > 
> > Co-developed-by: Like Xu <likexu@tencent.com>
> > Signed-off-by: Like Xu <likexu@tencent.com>
> > Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
> > ---
> >  .../kvm/x86_64/pmu_basic_functionality_test.c | 78 +++++++++++++++++++
> >  1 file changed, 78 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c b/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
> > index daa45aa285bb..b86033e51d5c 100644
> > --- a/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
> > +++ b/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
> > @@ -16,6 +16,11 @@
> >  /* Guest payload for any performance counter counting */
> >  #define NUM_BRANCHES			10
> >  
> > +static const uint64_t perf_caps[] = {
> > +	0,
> > +	PMU_CAP_FW_WRITES,
> > +};
> > +
> >  static struct kvm_vm *pmu_vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
> >  						  void *guest_code)
> >  {
> > @@ -164,6 +169,78 @@ static void intel_test_arch_events(void)
> >  	}
> >  }
> >  
> > +static void guest_wr_and_rd_msrs(uint32_t base, uint8_t begin, uint8_t offset)
> > +{
> > +	uint8_t wr_vector, rd_vector;
> > +	uint64_t msr_val;
> > +	unsigned int i;
> > +
> > +	for (i = begin; i < begin + offset; i++) {
> > +		wr_vector = wrmsr_safe(base + i, 0xffff);
> > +		rd_vector = rdmsr_safe(base + i, &msr_val);

Unless I'm missing something, there is zero reason to pass "base" and "being"
separately, just do the math in the host.  A "base" that isn't actually the base
when viewed without the full context is super confusing.

> > +		if (wr_vector == GP_VECTOR || rd_vector == GP_VECTOR)
> > +			GUEST_SYNC(GP_VECTOR);
> 
> Rather than pass around the "expected" vector, and shuffle #GP vs. the msr_val
> up (which can get false negatives if msr_val == 13), just read
> MSR_IA32_PERF_CAPABILITIES from within the guest and GUEST_ASSERT accordingly.

Ah, you did that so that the fixed counter test can reuse the guest code.  Just
use separate trampolines in the guest, e.g.

static void __guest_wrmsr_rdmsr(uint32_t base, uint8_t nr_msrs, bool expect_gp)
{
	uint64_t msr_val;
	uint8_t vector;
	uint32_t i;

	for (i = base; i < base + nr_msrs; i++) {
		vector = wrmsr_safe(i, 0xffff);
		GUEST_ASSERT(expect_gp ? vector == GP_VECTOR : !vector,
			     "...");

		vector = rdmsr_safe(i, &msr_val);
		GUEST_ASSERT(expect_gp ? vector == GP_VECTOR : !vector,
			     "...");
		if (!expect_gp)
			GUEST_ASSERT_EQ(msr_val, 0);
	}

	GUEST_DONE();
}

static void guest_rd_wr_fixed_counter(uint32_t base, uint8_t nr_msrs)
{
	__guest_wrmsr_rdmsr(base, nr_msrs, true);
}

static void guest_rd_wr_gp_counter(uint32_t base, uint8_t nr_msrs)
{
	uint64_t perf_capabilities = rdmsr();

	__guest_wrmsr_rdmsr(base, nr_msrs, !!perf_capabilities);
}

