Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B58A6549C0
	for <lists+kvm@lfdr.de>; Fri, 23 Dec 2022 01:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbiLWAYy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 19:24:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiLWAYt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 19:24:49 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90A9E087
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 16:24:47 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id s7so3518373plk.5
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 16:24:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xYp01oZozTwqv8trA9cozBg+VWN9/VcWKzanKtwkrvM=;
        b=C3DDYa1ZckxRdOBEbiBuhGz558/+7793H4C2lhNO7b2TvXJZX/Wka+N9KN4VLIlr7y
         xTgvVYS7FP/XWpwOF1EYXeluNGnvSlLHmI1bXqpKnHjRW50kJcyiM/qfPXHliKy+vd7f
         GkiMEzCcf3x9YgK/1xDhA2ZePVrnC+8UHkP1xwDZfWwJyfVAYAg8tn1/aerwJFVZvcHd
         qQBl5gCpA3i7I5y5fLap06tHHtN9tku03u/CBrbkb7glYXV1pKjV8kO+mi8pU5BSna6d
         lIJDjQcrFEmPBpcrVFdSLwoLKocqsL01HjNooy82ZtRDxg0ngjwVkg7/gbHXUIrcvYJ9
         SmcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xYp01oZozTwqv8trA9cozBg+VWN9/VcWKzanKtwkrvM=;
        b=t0Nx6ktjACUs1ie3SxX+3SISRvqBJCu0TlHUCxkTZFX+MNv0e6rHO/j/304PKs1sqy
         TaWIFfpBlFCR1H6RGlYmSVgTSTQcj2vTPd1AkKgg0vm+GP/+wdpaRKeqvOcrTl4EdHEd
         4PVfh6CExuly9KA4Lra1YTBtcQLU98vRMU7KMn06JWpOlevr8gODaz9dm4JOG5Dvmvww
         CYKM/t1GJOKSw50jO14J6bNZ7Ot3jhI4A4ne854rjS3Z7jxLuSMfU8o/FDEIdjNpWwr9
         5wJ5AZ0h6mDDAegURWsip/Ym6PQl7Eymco4hoGJvCdF4es4r7qWfJs+Bym5gLRYk5DMz
         HbhQ==
X-Gm-Message-State: AFqh2kokIYI2ZwJzoGuldEZ3opGsX7jWaM+ZJfVdiPG+MaPP0VB3Zk2f
        1+WpBedEVP6DXb6tJO9hfqTi/w==
X-Google-Smtp-Source: AMrXdXtjmyMN0n1ch5Bp+fTjhtJGeCGV6ouHTDWZL4BvND5FtfYB4JbEM/AE3FM5TYS0IaHg+BXNPw==
X-Received: by 2002:a05:6a20:a012:b0:a7:882e:3a18 with SMTP id p18-20020a056a20a01200b000a7882e3a18mr340954pzj.1.1671755087182;
        Thu, 22 Dec 2022 16:24:47 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id o5-20020a170903210500b001897e2fd65dsm1136325ple.9.2022.12.22.16.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Dec 2022 16:24:46 -0800 (PST)
Date:   Fri, 23 Dec 2022 00:24:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vishal Annapurve <vannapurve@google.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, pbonzini@redhat.com,
        shuah@kernel.org, bgardon@google.com, oupton@google.com,
        peterx@redhat.com, vkuznets@redhat.com, dmatlack@google.com,
        pgonda@google.com, andrew.jones@linux.dev
Subject: Re: [V3 PATCH 1/2] KVM: selftests: x86: Cache the cpu vendor type
Message-ID: <Y6T1S8GSuwf08StX@google.com>
References: <20221222230458.3828342-1-vannapurve@google.com>
 <20221222230458.3828342-2-vannapurve@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221222230458.3828342-2-vannapurve@google.com>
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

On Thu, Dec 22, 2022, Vishal Annapurve wrote:
> Query cpuid once per guest selftest and store the cpu vendor type so that
> subsequent queries can reuse the cached cpu vendor type.
> 
> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> ---
>  .../selftests/kvm/lib/x86_64/processor.c      | 33 ++++++++++++++++---
>  1 file changed, 28 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 097cef430774..1e93bb3cb058 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -20,6 +20,9 @@
>  
>  vm_vaddr_t exception_handlers;
>  
> +static bool is_cpu_vendor_intel;
> +static bool is_cpu_vendor_amd;
> +
>  static void regs_dump(FILE *stream, struct kvm_regs *regs, uint8_t indent)
>  {
>  	fprintf(stream, "%*srax: 0x%.16llx rbx: 0x%.16llx "
> @@ -1017,18 +1020,36 @@ void kvm_x86_state_cleanup(struct kvm_x86_state *state)
>  	free(state);
>  }
>  
> -static bool cpu_vendor_string_is(const char *vendor)
> +static void check_cpu_vendor(void)

I don't love the name, "check" makes me think the purpose of the helper is to
assert something.  Maybe cache_cpu_vendor()?  Though this might be a moot point
(more at the end).

>  {
> -	const uint32_t *chunk = (const uint32_t *)vendor;
> +	const char *intel_id = "GenuineIntel";
> +	const uint32_t *intel_id_chunks = (const uint32_t *)intel_id;
> +	const char *amd_id = "AuthenticAMD";
> +	const uint32_t *amd_id_chunks = (const uint32_t *)amd_id;
> +	static bool cpu_vendor_checked;
>  	uint32_t eax, ebx, ecx, edx;
>  
> +	if (cpu_vendor_checked)
> +		return;
> +
>  	cpuid(0, &eax, &ebx, &ecx, &edx);
> -	return (ebx == chunk[0] && edx == chunk[1] && ecx == chunk[2]);
> +
> +	if (ebx == intel_id_chunks[0] && edx == intel_id_chunks[1] &&
> +		ecx == intel_id_chunks[2])

Align indentation, should be:

	if (ebx == intel_id_chunks[0] && edx == intel_id_chunks[1] &&
	    ecx == intel_id_chunks[2])

> +		is_cpu_vendor_intel = true;
> +	else {
> +		if (ebx == amd_id_chunks[0] && edx == amd_id_chunks[1] &&
> +			ecx == amd_id_chunks[2])

Same here.

> +			is_cpu_vendor_amd = true;
> +	}

Though that's likely a moot point since manually checking the chunks (multiple
times!) is rather heinous.  Just store the CPUID output into an array and then
use strncmp() to check the vendor.  Performance isn't a priority for this code.

  static void cache_cpu_vendor(void)
  {
	uint32_t ign, vendor[3];
	static bool cached;

	if (cached)
		return;

	cpuid(0, &ign, &vendor[0], &vendor[2], &vendor[1]);

	is_cpu_vendor_intel = !strncmp((char *)vendor, "GenuineIntel", 12);
	is_cpu_vendor_amd = !strncmp((char *)vendor, "AuthenticAMD", 12);

	cached = true;
  }

That said, I like the v2 approach a lot more, we just need to better name the
host variables to make it very clear that the info being cached is the _host_
vendor, and then provide separate helpers that bypass caching (though I don't
think there would be any users?), again with better names.

The confidential VM use case, and really kvm_hypercall() in general, cares about
the host vendor, i.e. which hypercall instruction won't fault.  Actually, even
fix_hypercall_test is in the same boat.

I don't like auto-caching the guest info because unlike the host (assuming no
shenanigans in a nested setup), the guest vendor string can be changed.  I don't
think it's likely that we'll have a test that wants to muck with the vendor string
on the fly, but it's not impossible, e.g. fix_hypercall_test dances pretty close
to that.

The independent guest vs. host caching in this version is also very subtle, though
that can be solved with comments.

E.g. first make is_intel_cpu() and is_amd_cpu() wrappers to non-caching helpers
that use "this_cpu_..." naming to match other selftests code.  Then rename
is_intel_cpu() and is_amd_cpu() to is_{intel,amd}_host(), with a blurb in the
changelog calling out that fix_hypercall_test wants the host vendor and also passes
through the host CPUID vendor.  And then do the precomputation stuff like in v2.

E.g. for step #1

---
 .../selftests/kvm/include/x86_64/processor.h  | 22 +++++++++++++++++++
 .../selftests/kvm/lib/x86_64/processor.c      | 13 ++---------
 2 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index b1a31de7108a..34523a876336 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -554,6 +554,28 @@ static inline uint32_t this_cpu_model(void)
 	return x86_model(this_cpu_fms());
 }
 
+static inline bool this_cpu_vendor_string_is(const char *vendor)
+{
+	const uint32_t *chunk = (const uint32_t *)vendor;
+	uint32_t eax, ebx, ecx, edx;
+
+	cpuid(0, &eax, &ebx, &ecx, &edx);
+	return (ebx == chunk[0] && edx == chunk[1] && ecx == chunk[2]);
+}
+
+static inline bool this_cpu_is_intel(void)
+{
+	return this_cpu_vendor_string_is("GenuineIntel");
+}
+
+/*
+ * Exclude early K5 samples with a vendor string of "AMDisbetter!"
+ */
+static inline bool this_cpu_is_amd(void)
+{
+	return this_cpu_vendor_string_is("AuthenticAMD");
+}
+
 static inline uint32_t __this_cpu_has(uint32_t function, uint32_t index,
 				      uint8_t reg, uint8_t lo, uint8_t hi)
 {
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index c4d368d56cfe..fae1a8a81652 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1006,18 +1006,9 @@ void kvm_x86_state_cleanup(struct kvm_x86_state *state)
 	free(state);
 }
 
-static bool cpu_vendor_string_is(const char *vendor)
-{
-	const uint32_t *chunk = (const uint32_t *)vendor;
-	uint32_t eax, ebx, ecx, edx;
-
-	cpuid(0, &eax, &ebx, &ecx, &edx);
-	return (ebx == chunk[0] && edx == chunk[1] && ecx == chunk[2]);
-}
-
 bool is_intel_cpu(void)
 {
-	return cpu_vendor_string_is("GenuineIntel");
+	return this_cpu_is_intel();
 }
 
 /*
@@ -1025,7 +1016,7 @@ bool is_intel_cpu(void)
  */
 bool is_amd_cpu(void)
 {
-	return cpu_vendor_string_is("AuthenticAMD");
+	return this_cpu_is_amd();
 }
 
 void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits)

base-commit: d70e740240a298d0ff54d26f48f2fb034e3cb172
-- 

