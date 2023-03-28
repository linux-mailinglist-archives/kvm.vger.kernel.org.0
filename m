Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A296D6CC7AD
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 18:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233038AbjC1QPq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 12:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232916AbjC1QPi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 12:15:38 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF95BE187
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 09:15:36 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id o32so7307631wms.1
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 09:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680020135;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DWKWWkSsnpfRn2+LYEIqq1vAGExKdFNDPfBo77h5+cM=;
        b=XifWTcm1xnu6f9aPouPR7VpIbR1N50dcIM54qN5Mlbel5sTiLdbYCmSrtLw+KEdPPn
         1cF9OK2tzNRfBtBzKhUWKFrzydK8HB4RjTKxG3lRQznlJeHEt9b18xI81tjKIDcLO6Eo
         YZN+JIkHNrswH2apXYp8qCAmDm1e5xx0qqkC15FhCIwF6ikGsN0usjVkw1cSN9SUrgnK
         8eYG+LVZqlmkc8PnWAVpdiGIvfXNjoI6Yim82jOq/aaqYsae+Z9+beMNWCNpH65ymKQM
         Iq0Ggbxz0pC8gHx8Yu7TY2O7CoIbWyEFj/IQVWk10QxRBgFl8Cd+FqnAsOaeBP7S7dNP
         Oebw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680020135;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DWKWWkSsnpfRn2+LYEIqq1vAGExKdFNDPfBo77h5+cM=;
        b=gmAgYyScez3qEyb8z88lYHH3gDWVTciAnpMZI/jiUh/XZBg8CEPZ4IEMVt006QRtnA
         CYekcaf6oWjA3+ytWASNsUSrmMD6VDHoCftCj1pCM3FhxG8WldZoMKcsfTCFqWcNlNVj
         OhicIgtU9wLL9G22/sMYbQx6I0sC3pDZ0g/2W6cpO79kx89gWdiP9BtUq6JBVlOfbULi
         wfW8dFnmicid7iZRYUhcJCZJrq2QMBqF1jVfVS6X38LAlNTgTbFPtlNEHRFN81VPyytQ
         BgPjo5zIlW1oWsmDSHkX2MCSs2+leN5m/ZQXSIi849iLx9hj0isGVMNN+P7N/tTBIK9s
         bmcw==
X-Gm-Message-State: AO0yUKUga3z+CTHyLU8Qv5Vq2iiN+Cxypdh28YBVpmMnKO9kmUU9KdD4
        RqAFWL778xQujEPv48jtM5dIMA==
X-Google-Smtp-Source: AK7set9OcnlChpyZKYyxyXwjedxJze5iXZPnnxbaugRBy5012tIcIyFoZkfRD1TZBGXun9T1yu26jg==
X-Received: by 2002:a05:600c:2199:b0:3ee:3fd7:5f84 with SMTP id e25-20020a05600c219900b003ee3fd75f84mr12627963wme.6.1680020135178;
        Tue, 28 Mar 2023 09:15:35 -0700 (PDT)
Received: from [192.168.69.115] ([176.187.210.212])
        by smtp.gmail.com with ESMTPSA id l10-20020a7bc44a000000b003ed246c1d28sm17270217wmi.44.2023.03.28.09.15.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Mar 2023 09:15:34 -0700 (PDT)
Message-ID: <fff8236b-831c-c844-06d4-7eb417367e23@linaro.org>
Date:   Tue, 28 Mar 2023 18:15:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH-for-8.0 2/3] softmmu: Restrict cpu_check_watchpoint /
 address_matches to TCG accel
Content-Language: en-US
To:     qemu-devel@nongnu.org
Cc:     Eduardo Habkost <eduardo@habkost.net>, kvm@vger.kernel.org,
        qemu-s390x@nongnu.org, Fabiano Rosas <farosas@suse.de>,
        David Hildenbrand <david@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Greg Kurz <groug@kaod.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Yanan Wang <wangyanan55@huawei.com>, qemu-ppc@nongnu.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org
References: <20230328160203.13510-1-philmd@linaro.org>
 <20230328160203.13510-3-philmd@linaro.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230328160203.13510-3-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/3/23 18:02, Philippe Mathieu-Daudé wrote:
> Both cpu_check_watchpoint() and cpu_watchpoint_address_matches()
> are specific to TCG system emulation. Declare them in "tcg-cpu-ops.h"
> to be sure accessing them from non-TCG code is a compilation error.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   include/hw/core/cpu.h         | 37 ------------------------------
>   include/hw/core/tcg-cpu-ops.h | 43 +++++++++++++++++++++++++++++++++++
>   2 files changed, 43 insertions(+), 37 deletions(-)
> 
> diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
> index 821e937020..ce312745d5 100644
> --- a/include/hw/core/cpu.h
> +++ b/include/hw/core/cpu.h
> @@ -970,17 +970,6 @@ static inline void cpu_watchpoint_remove_by_ref(CPUState *cpu,
>   static inline void cpu_watchpoint_remove_all(CPUState *cpu, int mask)
>   {
>   }
> -
> -static inline void cpu_check_watchpoint(CPUState *cpu, vaddr addr, vaddr len,
> -                                        MemTxAttrs atr, int fl, uintptr_t ra)
> -{
> -}
> -
> -static inline int cpu_watchpoint_address_matches(CPUState *cpu,
> -                                                 vaddr addr, vaddr len)
> -{
> -    return 0;
> -}
>   #else
>   int cpu_watchpoint_insert(CPUState *cpu, vaddr addr, vaddr len,
>                             int flags, CPUWatchpoint **watchpoint);
> @@ -988,32 +977,6 @@ int cpu_watchpoint_remove(CPUState *cpu, vaddr addr,
>                             vaddr len, int flags);
>   void cpu_watchpoint_remove_by_ref(CPUState *cpu, CPUWatchpoint *watchpoint);
>   void cpu_watchpoint_remove_all(CPUState *cpu, int mask);
> -
> -/**
> - * cpu_check_watchpoint:
> - * @cpu: cpu context
> - * @addr: guest virtual address
> - * @len: access length
> - * @attrs: memory access attributes
> - * @flags: watchpoint access type
> - * @ra: unwind return address
> - *
> - * Check for a watchpoint hit in [addr, addr+len) of the type
> - * specified by @flags.  Exit via exception with a hit.
> - */
> -void cpu_check_watchpoint(CPUState *cpu, vaddr addr, vaddr len,
> -                          MemTxAttrs attrs, int flags, uintptr_t ra);
> -
> -/**
> - * cpu_watchpoint_address_matches:
> - * @cpu: cpu context
> - * @addr: guest virtual address
> - * @len: access length
> - *
> - * Return the watchpoint flags that apply to [addr, addr+len).
> - * If no watchpoint is registered for the range, the result is 0.
> - */
> -int cpu_watchpoint_address_matches(CPUState *cpu, vaddr addr, vaddr len);
>   #endif
>   
>   /**
> diff --git a/include/hw/core/tcg-cpu-ops.h b/include/hw/core/tcg-cpu-ops.h
> index 20e3c0ffbb..0ae08df47e 100644
> --- a/include/hw/core/tcg-cpu-ops.h
> +++ b/include/hw/core/tcg-cpu-ops.h
> @@ -175,4 +175,47 @@ struct TCGCPUOps {
>   
>   };
>   
> +#if defined(CONFIG_USER_ONLY)
> +
> +static inline void cpu_check_watchpoint(CPUState *cpu, vaddr addr, vaddr len,
> +                                        MemTxAttrs atr, int fl, uintptr_t ra)
> +{
> +}
> +
> +static inline int cpu_watchpoint_address_matches(CPUState *cpu,
> +                                                 vaddr addr, vaddr len)
> +{
> +    return 0;
> +}
> +
> +#else
> +
> +/**
> + * cpu_check_watchpoint:
> + * @cpu: cpu context
> + * @addr: guest virtual address
> + * @len: access length
> + * @attrs: memory access attributes
> + * @flags: watchpoint access type
> + * @ra: unwind return address
> + *
> + * Check for a watchpoint hit in [addr, addr+len) of the type
> + * specified by @flags.  Exit via exception with a hit.
> + */
> +void cpu_check_watchpoint(CPUState *cpu, vaddr addr, vaddr len,
> +                          MemTxAttrs attrs, int flags, uintptr_t ra);
> +
> +/**
> + * cpu_watchpoint_address_matches:
> + * @cpu: cpu context
> + * @addr: guest virtual address
> + * @len: access length
> + *
> + * Return the watchpoint flags that apply to [addr, addr+len).
> + * If no watchpoint is registered for the range, the result is 0.
> + */
> +int cpu_watchpoint_address_matches(CPUState *cpu, vaddr addr, vaddr len);
> +
> +#endif
> +
>   #endif /* TCG_CPU_OPS_H */

This hunk is missing:

-- >8 --
diff --git a/target/arm/tcg/mte_helper.c b/target/arm/tcg/mte_helper.c
index fee3c7eb96..22802b659d 100644
--- a/target/arm/tcg/mte_helper.c
+++ b/target/arm/tcg/mte_helper.c
@@ -29,2 +29,3 @@
  #include "qemu/guest-random.h"
+#include "hw/core/tcg-cpu-ops.h"

diff --git a/target/arm/tcg/sve_helper.c b/target/arm/tcg/sve_helper.c
index 9a8951afa4..ace2d88f8d 100644
--- a/target/arm/tcg/sve_helper.c
+++ b/target/arm/tcg/sve_helper.c
@@ -29,3 +29,3 @@
  #include "sve_ldst_internal.h"
-
+#include "hw/core/tcg-cpu-ops.h"

diff --git a/target/s390x/tcg/mem_helper.c b/target/s390x/tcg/mem_helper.c
index b93dbd3dad..1e7f72a2f2 100644
--- a/target/s390x/tcg/mem_helper.c
+++ b/target/s390x/tcg/mem_helper.c
@@ -30,2 +30,3 @@
  #include "qemu/atomic128.h"
+#include "hw/core/tcg-cpu-ops.h"
  #include "trace.h"
---
