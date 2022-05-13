Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECE16525E35
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 11:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378520AbiEMI5s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 04:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243338AbiEMI5r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 04:57:47 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A6267D10;
        Fri, 13 May 2022 01:57:46 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 137so6934765pgb.5;
        Fri, 13 May 2022 01:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=im9OFuvNv+HlaoOnPCMf8xlooNiaI5y8YCFk0vG3dWQ=;
        b=BiJjDkjU/rZgKg+Fw7ejRnhRwSKkVYFgPgtGPL7re+qhT3CCcsvlW7tAMtxBg4XXqK
         DM2UpKH9ckkPjnx7PenzCvBOuO7eq3Dwh73tOAURfvtvhuJU6MsCH756IxLuU9R6ubHk
         nbKBVkxmY4uJDcBrckB6ahaXf0VBLNZLPIWTtmkSIScX/nAO681oIzHtRWVBjykHw+ca
         lcAxG4QLmvWnC7G+RwyHdOmXENw/SOxpiDnapJanqXc51rKUptGqdlXgVG4kQZ3S3SC5
         1p8QXyqzH9BNqX0GFYUuyi6uS5STgy+adukkJYZG2XSLxY/vFBN/o8ChA2T/zD49rcC0
         vAVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=im9OFuvNv+HlaoOnPCMf8xlooNiaI5y8YCFk0vG3dWQ=;
        b=yotW82zkkxv/QjnEjso8+iM3QrLe4KdvcR0hDfVhgHj4VHSQa0qmNHduvTSNqT1v/3
         HgsEo6OUl1t3qfpmDQuJ44lZYnG08KRtQd9NRNr4/96/nlEaCilp8s0NuJWdaiW94x0n
         hDkoE/AdOBZTFb3ocKRuwx+Zb5gJeCgYq4nY0t4/L3AVZx7e2QZPABhKAeAsuj4MKI6s
         m+GGnRfhN7YF6Zv5KDX1FDVLwz7YmcVCJEyGFBWeD5ComqNAUxQ2jLENl+JpWmXoIJJO
         ygoXL1lnuMioAK7MscCbI8Dg8+9Q28FA9IUrfDfb4vpOrzuQYm1I5cGq9wgGkxSiiipz
         lytg==
X-Gm-Message-State: AOAM533Rft12ahx2raSieovljao9rfg/XvBnmq0bdu531pXRffiMW7/+
        D20FW0fBm+IxWXw5eYtL63zd2+BnKdaqqw==
X-Google-Smtp-Source: ABdhPJzPaTK64rA1aVx5Ti4Wwv8WzvA8sn4JHJpxWwWhX/LZnpPtKz8z1OBPdYqYQNW01uPN4Gp1zw==
X-Received: by 2002:a05:6a00:1492:b0:50e:11ae:f62f with SMTP id v18-20020a056a00149200b0050e11aef62fmr3736424pfu.43.1652432265870;
        Fri, 13 May 2022 01:57:45 -0700 (PDT)
Received: from [192.168.255.10] ([203.205.141.25])
        by smtp.gmail.com with ESMTPSA id im9-20020a170902bb0900b0015e8d4eb1c6sm1313739plb.16.2022.05.13.01.57.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 May 2022 01:57:45 -0700 (PDT)
Message-ID: <ab59943e-4a92-41ff-fed7-c0e7f916fa82@gmail.com>
Date:   Fri, 13 May 2022 16:57:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH RESEND v12 09/17] KVM: x86/pmu: Adjust precise_ip to
 emulate Ice Lake guest PDIR counter
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>
References: <20220411101946.20262-1-likexu@tencent.com>
 <20220411101946.20262-10-likexu@tencent.com>
In-Reply-To: <20220411101946.20262-10-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/4/2022 6:19 pm, Like Xu wrote:

> +++ b/arch/x86/kvm/pmu.h
> @@ -4,6 +4,8 @@
>   
>   #include <linux/nospec.h>
>   
> +#include <asm/cpu_device_id.h>
> +
>   #define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu)
>   #define pmu_to_vcpu(pmu)  (container_of((pmu), struct kvm_vcpu, arch.pmu))
>   #define pmc_to_pmu(pmc)   (&(pmc)->vcpu->arch.pmu)
> @@ -15,6 +17,12 @@
>   #define VMWARE_BACKDOOR_PMC_REAL_TIME		0x10001
>   #define VMWARE_BACKDOOR_PMC_APPARENT_TIME	0x10002
>   
> +static const struct x86_cpu_id vmx_icl_pebs_cpu[] = {
> +	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_D, NULL),
> +	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X, NULL),
> +	{}
> +};
The gcc [-Wunused-const-variable] flag would complain about
not moving vmx_icl_pebs_cpu[] from pmu.h to pmu.c:

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index b5d0c36b869b..17c9bfc2527d 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -27,6 +27,12 @@
  struct x86_pmu_capability __read_mostly kvm_pmu_cap;
  EXPORT_SYMBOL_GPL(kvm_pmu_cap);

+static const struct x86_cpu_id vmx_icl_pebs_cpu[] = {
+    X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_D, NULL),
+    X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X, NULL),
+    {}
+};
+
  /* NOTE:
   * - Each perf counter is defined as "struct kvm_pmc";
   * - There are two types of perf counters: general purpose (gp) and fixed.
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index dbf4c83519a4..8064d074f3be 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -17,12 +17,6 @@
  #define VMWARE_BACKDOOR_PMC_REAL_TIME        0x10001
  #define VMWARE_BACKDOOR_PMC_APPARENT_TIME    0x10002

-static const struct x86_cpu_id vmx_icl_pebs_cpu[] = {
-    X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_D, NULL),
-    X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X, NULL),
-    {}
-};
-
  struct kvm_event_hw_type_mapping {
      u8 eventsel;
      u8 unit_mask;



