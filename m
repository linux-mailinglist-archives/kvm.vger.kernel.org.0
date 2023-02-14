Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1F8695AA0
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 08:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbjBNH1l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 02:27:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjBNH1k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 02:27:40 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F231026B;
        Mon, 13 Feb 2023 23:27:38 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id d8so14938865plr.10;
        Mon, 13 Feb 2023 23:27:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4nBHKNBpnzKAp9d9UZKBf/Atg89/L5pb1TEd+G9vVe0=;
        b=UrLDbivd7Yi81ZI59CnsnGNlbjkMXW0gKlwgMgh8PpAG7LSChGgQSA/y7dSIvYgtYJ
         LbLySNlbWGm0JZo1b3Kwhw+t5ynlOITSlZUbOaY6PswY0W6tOqzumOxrUyp16ZunjMTn
         0rBma3JK313bjDcc2Nh04+O5ru3VdmaVAauYBB/FlIp7fYaDPxDsG5yXpHvdiisVyP/r
         vq7CTNDt9Qw9KdnHOWe2h6eLbZkUlQV0p0FqrJgJRE1wGVAl43yQ+arTlheLtGPRdrn2
         0gjRrBuXPvsHbA4/fYOK4/bWeE7e4ajWeK6ayeb/R3k+6MjapgEFD8ZE2TznEbjjFOWf
         u7eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4nBHKNBpnzKAp9d9UZKBf/Atg89/L5pb1TEd+G9vVe0=;
        b=vb5leBzds/eu7PJHwJ+OJ4c3YFQ0YSCJb0JVkEQ+f/teUxRDFIP63nF6idyNBP1eKU
         41EtxQI4yZbPMNCp/G8QJ+p7AQfVZUot/QX9j3XzIBg5FleJeDk/6n/LOY5IY5gKJ1jW
         Xwdfz8dPHqw2eaO00SpWGqoLr+HBvxCeY7kvY5uRan6Tq4+qeBL7JNik653FN40/QfS9
         UqVAXQpb9Gq7JjLrv74GoVgJPrJ7zGTbcbjUgnSEJfJeK3EhR7THcY7gDyIWtp5olLjp
         BuF6Ml8LTg9QDTK/1sG0TRwyM39GofImmBX+i5VTYmq/10AF4/9KIEmx+Kj430pob7tK
         eQTA==
X-Gm-Message-State: AO0yUKWuYwv3dOUvOmbtg+jO2m/tegV4PBD+AgW+cysAp1eTcvpG7Ny5
        EHqgnpP0/YB6gaKnqClaiiykKPG7Y4/zpzu95ms=
X-Google-Smtp-Source: AK7set9IlAlxkD8ebmQoOG4S/cPwP0hwQwj9XRBQSn57Lb2xpTuCrBGxLFDlGVIiM/Qf8kAWn0KoaQ==
X-Received: by 2002:a17:902:e84a:b0:199:2a89:f912 with SMTP id t10-20020a170902e84a00b001992a89f912mr2034421plg.20.1676359657901;
        Mon, 13 Feb 2023 23:27:37 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id p6-20020a170903248600b0019949fd956bsm9431072plw.178.2023.02.13.23.27.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Feb 2023 23:27:37 -0800 (PST)
Message-ID: <85b3d348-2e4a-43aa-0131-27e9fc375cf9@gmail.com>
Date:   Tue, 14 Feb 2023 15:27:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH v2 08/21] KVM: selftests: Split PMU caps sub-tests to
 avoid writing MSR after KVM_RUN
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230210003148.2646712-1-seanjc@google.com>
 <20230210003148.2646712-9-seanjc@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20230210003148.2646712-9-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nit, could this patch be applied before the relevant KVM modifications [1] so that
a CI bot doesn't generate an error report before this selftests patch is applied ?

[1] KVM: x86: Disallow writes to immutable feature MSRs after KVM_RUN

On 10/2/2023 8:31 am, Sean Christopherson wrote:
> Split the PERF_CAPABILITIES subtests into two parts so that the LBR format
> testcases don't execute after KVM_RUN.  Now that KVM disallows changing
> PERF_CAPABILITIES after KVM_RUN (same as guest CPUID), attempting to set
> the MSR after KVM_RUN will yield false positives and/or false negatives
> depending on what the test is trying to do.
> 
> Land the LBR format test in a more generic "immutable features" test in
> anticipation of expanding its scope to other immutable features.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   .../selftests/kvm/x86_64/vmx_pmu_caps_test.c  | 51 +++++++++++--------
>   1 file changed, 31 insertions(+), 20 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
> index c280ba1e6572..ac08c0fdd84d 100644
> --- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
> @@ -41,24 +41,10 @@ static void guest_code(void)
>   	wrmsr(MSR_IA32_PERF_CAPABILITIES, PMU_CAP_LBR_FMT);
>   }
>   
> -int main(int argc, char *argv[])
> +static void test_fungible_perf_capabilities(union perf_capabilities host_cap)
>   {
> -	struct kvm_vm *vm;
>   	struct kvm_vcpu *vcpu;
> -	int ret;
> -	union perf_capabilities host_cap;
> -	uint64_t val;
> -
> -	host_cap.capabilities = kvm_get_feature_msr(MSR_IA32_PERF_CAPABILITIES);
> -	host_cap.capabilities &= (PMU_CAP_FW_WRITES | PMU_CAP_LBR_FMT);
> -
> -	/* Create VM */
> -	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
> -
> -	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_PDCM));
> -
> -	TEST_REQUIRE(kvm_cpu_has_p(X86_PROPERTY_PMU_VERSION));
> -	TEST_REQUIRE(kvm_cpu_property(X86_PROPERTY_PMU_VERSION) > 0);
> +	struct kvm_vm *vm = vm_create_with_one_vcpu(&vcpu, guest_code);
>   
>   	/* testcase 1, set capabilities when we have PDCM bit */
>   	vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, PMU_CAP_FW_WRITES);
> @@ -70,7 +56,16 @@ int main(int argc, char *argv[])
>   	vcpu_run(vcpu);
>   	ASSERT_EQ(vcpu_get_msr(vcpu, MSR_IA32_PERF_CAPABILITIES), PMU_CAP_FW_WRITES);
>   
> -	/* testcase 2, check valid LBR formats are accepted */
> +	kvm_vm_free(vm);
> +}
> +
> +static void test_immutable_perf_capabilities(union perf_capabilities host_cap)
> +{
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm = vm_create_with_one_vcpu(&vcpu, NULL);
> +	uint64_t val;
> +	int ret;
> +
>   	vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, 0);
>   	ASSERT_EQ(vcpu_get_msr(vcpu, MSR_IA32_PERF_CAPABILITIES), 0);
>   
> @@ -78,8 +73,8 @@ int main(int argc, char *argv[])
>   	ASSERT_EQ(vcpu_get_msr(vcpu, MSR_IA32_PERF_CAPABILITIES), (u64)host_cap.lbr_format);
>   
>   	/*
> -	 * Testcase 3, check that an "invalid" LBR format is rejected.  Only an
> -	 * exact match of the host's format (and 0/disabled) is allowed.
> +	 * KVM only supports the host's native LBR format, as well as '0' (to
> +	 * disable LBR support).  Verify KVM rejects all other LBR formats.
>   	 */
>   	for (val = 1; val <= PMU_CAP_LBR_FMT; val++) {
>   		if (val == (host_cap.capabilities & PMU_CAP_LBR_FMT))
> @@ -88,7 +83,23 @@ int main(int argc, char *argv[])
>   		ret = _vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, val);
>   		TEST_ASSERT(!ret, "Bad LBR FMT = 0x%lx didn't fail", val);
>   	}
> +	kvm_vm_free(vm);
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	union perf_capabilities host_cap;
> +
> +	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_PDCM));
> +
> +	TEST_REQUIRE(kvm_cpu_has_p(X86_PROPERTY_PMU_VERSION));
> +	TEST_REQUIRE(kvm_cpu_property(X86_PROPERTY_PMU_VERSION) > 0);
> +
> +	host_cap.capabilities = kvm_get_feature_msr(MSR_IA32_PERF_CAPABILITIES);
> +	host_cap.capabilities &= (PMU_CAP_FW_WRITES | PMU_CAP_LBR_FMT);
> +
> +	test_fungible_perf_capabilities(host_cap);
> +	test_immutable_perf_capabilities(host_cap);
>   
>   	printf("Completed perf capability tests.\n");
> -	kvm_vm_free(vm);
>   }
