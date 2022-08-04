Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCE1358A3E6
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 01:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240039AbiHDX02 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 19:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235305AbiHDX00 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 19:26:26 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA0E6068A
        for <kvm@vger.kernel.org>; Thu,  4 Aug 2022 16:26:25 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id p18so1164169plr.8
        for <kvm@vger.kernel.org>; Thu, 04 Aug 2022 16:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=X5uKb7oCa10gcyiDKzDcavbggNqrev4ZJSWyFhL2ZME=;
        b=BT3MIvNVasV8rpqD768caM6CuFWvDKKqhHwnYFxxwEVwJ017DEtxT0u2vN2BCDc0Gt
         e4L/vUPagK0dI19Yme/Ip9x+lBqc6avUtolieL59W9UyNt/N4r/rKvYp7vYXVwRDUF7s
         NbYM9k2HDZ3j/kadLpE7O/gkR5CeJxedH0mtjmxlt6QvEIM/qqRbNdbDWNbz71uXVo+n
         cnFUl40T8EI/KpzsmiNSNUyw7xxIYOnYYS1AFk0JSiVEERfhWrcrDprmtNi9kCM/z4y2
         Y7DdLj30gCQXc62PN9C8N+S7uIdQ14LWrEDQdMelNc1lxPzT3imvtu/fycdMATdBGWUw
         vEcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=X5uKb7oCa10gcyiDKzDcavbggNqrev4ZJSWyFhL2ZME=;
        b=jXvd4ekNzNN3PqWlw0mg6D/J03RQUFtoZNLsM95/sjXKHY8I9oLH6mHnn2HuunKlnA
         FtS5kijXSClBX/yjWmYT3wnvFAZ2nVp+hXfmdlTzWjlMQVaslR3OmnJqy+pl97q8Pd+W
         liYY2/ck5//rDPH5pX8WhIQYKo67hcHSkX9THx5mPR9WYnJFGsekeV8wppc8t02QisVU
         3bQh81AMCs0JemzXkp5NFr4b8kSSKwm+/cXTeSCXetkuKKQ5ELQIxQG1BqSkHvR7raIV
         OgEthsQuhDbcUlSWOrSdYLONRLMr7EUtciyz0qBzti+KkYlkBtlwqRL2qYZybgKlrQsj
         lp4A==
X-Gm-Message-State: ACgBeo1hXCKLQPdstwq/1ac51FmSMy2F4ODHbxX7c36s7BOE0n+y7mpO
        nd30G/bX3luIxk3EQaknRJPMag==
X-Google-Smtp-Source: AA6agR4r8lTtmd7jklaYdAihB6LjgBXY/8c5Gd88XpvZbJW3hbzGUE3F+WQaa2lGMrpcQ1kIbpEW4A==
X-Received: by 2002:a17:90a:a2a:b0:1f3:1479:e869 with SMTP id o39-20020a17090a0a2a00b001f31479e869mr4432295pjo.41.1659655584329;
        Thu, 04 Aug 2022 16:26:24 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x194-20020a6286cb000000b0052abfc4b4a4sm1641077pfd.12.2022.08.04.16.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 16:26:23 -0700 (PDT)
Date:   Thu, 4 Aug 2022 23:26:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: kvm/x86: test if it checks all the bits in
 the LBR_FMT bit-field
Message-ID: <YuxVnDif6UMcFZ5I@google.com>
References: <20220804073819.76460-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220804073819.76460-1-likexu@tencent.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 04, 2022, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> User space only enable guest LBR feature when the exactly supported
> LBR format value is initialized to the MSR_IA32_PERF_CAPABILITIES.
> The input is also invalid if only partially supported bits are set.
> 
> Note for PEBS feature, the PEBS_FORMAT bit field is the primary concern,
> thus if the PEBS_FORMAT input is empty, the other bits check about PEBS
> (like PEBS_TRAP or ARCH_REG) will be ignored.
> 
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
> index 6ec901dab61e..98483947f921 100644
> --- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
> @@ -13,6 +13,7 @@
>  
>  #define _GNU_SOURCE /* for program_invocation_short_name */
>  #include <sys/ioctl.h>
> +#include <linux/bitmap.h>
>  
>  #include "kvm_util.h"
>  #include "vmx.h"
> @@ -56,7 +57,7 @@ int main(int argc, char *argv[])
>  	const struct kvm_cpuid_entry2 *entry_a_0;
>  	struct kvm_vm *vm;
>  	struct kvm_vcpu *vcpu;
> -	int ret;
> +	int ret, bit;
>  	union cpuid10_eax eax;
>  	union perf_capabilities host_cap;
>  
> @@ -97,6 +98,12 @@ int main(int argc, char *argv[])
>  	ret = _vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, 0x30);
>  	TEST_ASSERT(ret == 0, "Bad PERF_CAPABILITIES didn't fail.");
>  
> +	/* testcase 4, reject LBR_FMT if only partially supported bits are set */
> +	for_each_set_bit(bit, (unsigned long *)&host_cap.capabilities, 6) {
> +		ret = _vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, BIT_ULL(bit));
> +		TEST_ASSERT(ret == 0, "Bad PERF_CAPABILITIES didn't fail.");
> +	}

Rather than add another testcase and target only a subset of possible values, what
about replacing (fixing IMO) testcase #3 with fully exhaustive approach?

---
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 4 Aug 2022 12:18:15 -0700
Subject: [PATCH] KVM: selftests: Test all possible "invalid"
 PERF_CAPABILITIES.LBR_FMT vals

Test all possible input values to verify that KVM rejects all values
except the exact host value.  Due to the LBR format affecting the core
functionality of LBRs, KVM can't emulate "other" formats, so even though
there are a variety of legal values, KVM should reject anything but an
exact host match.

Suggested-by: Like Xu <like.xu.linux@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c    | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
index 6ec901dab61e..069589c52f41 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
@@ -59,6 +59,7 @@ int main(int argc, char *argv[])
 	int ret;
 	union cpuid10_eax eax;
 	union perf_capabilities host_cap;
+	uint64_t val;

 	host_cap.capabilities = kvm_get_feature_msr(MSR_IA32_PERF_CAPABILITIES);
 	host_cap.capabilities &= (PMU_CAP_FW_WRITES | PMU_CAP_LBR_FMT);
@@ -91,11 +92,17 @@ int main(int argc, char *argv[])
 	vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, host_cap.lbr_format);
 	ASSERT_EQ(vcpu_get_msr(vcpu, MSR_IA32_PERF_CAPABILITIES), (u64)host_cap.lbr_format);

-	/* testcase 3, check invalid LBR format is rejected */
-	/* Note, on Arch LBR capable platforms, LBR_FMT in perf capability msr is 0x3f,
-	 * to avoid the failure, use a true invalid format 0x30 for the test. */
-	ret = _vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, 0x30);
-	TEST_ASSERT(ret == 0, "Bad PERF_CAPABILITIES didn't fail.");
+	/*
+	 * Testcase 3, check that an "invalid" LBR format is rejected.  Only an
+	 * exact match of the host's format (and 0/disabled) is allowed.
+	 */
+	for (val = 1; val <= PMU_CAP_LBR_FMT; val++) {
+		if (val == (host_cap.capabilities & PMU_CAP_LBR_FMT))
+			continue;
+
+		ret = _vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, val);
+		TEST_ASSERT(!ret, "Bad LBR FMT = 0x%lx didn't fail", val);
+	}

 	printf("Completed perf capability tests.\n");
 	kvm_vm_free(vm);

base-commit: 93472b79715378a2386598d6632c654a2223267b
--

