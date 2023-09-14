Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7FC79FD5B
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 09:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234255AbjINHlk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 03:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232903AbjINHlj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 03:41:39 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0EE91BF5
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 00:41:34 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-502984f5018so1035106e87.3
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 00:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694677293; x=1695282093; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hoacnYyPfsZkUVG3DUSeirmGTlliWMovYowd8cRwrQw=;
        b=mSpBZ7rUAXbJ+UkoVj6Jk3lM5NLGQLD0Md8zrD67OeJ5zR3xPwjUmDr2bE3eeWG7xz
         vNFFjzHKkFM5RZnPCNfckTLtXmFxHtSSzgNA19NO4hqZ3/G4Y7+Va/wbdL0CSAxam/8E
         +N0Xzhp5alzUPyZe4VCsz90URT7NquHEr6AjHsvm9mBq7kQYFDLomrtRMqPi4cbGl3jr
         z6ft7flluczzXysRCK1IHSjLl3uHmghABvpGdnD/Hsj5UF0fn99NWhNpPOsvioCztZyZ
         NkAjAl1CqAkZkVCrMxy39BCD75RQ/iT1P7TKPna3kUnjwXM9AvMmdYVmsz1GTqSP01Ul
         vM0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694677293; x=1695282093;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hoacnYyPfsZkUVG3DUSeirmGTlliWMovYowd8cRwrQw=;
        b=eqcTd2MvtdM1diFystFwNWpYamwYH45oXY0I0QSRHb+r5C90lUpK9g96g7fixmgkqT
         uus/+71tChM99VWR4KNcszWnr4aKol6X59pbB7lPtns0XBp1grdBcrMwiI7OYpbuguSi
         0ToAMQ6r7bvUjPDBPRl1UqSSfyuszuhq8gc5/RlIFTvAcF2Xj2AhAQKkep8+6UtXNV9w
         GOLCZ/liKMYuYVRNgM5zVU8jOjR31WOpllkKduFsBpFNNHQmCCWC6gwbn/Fv+6jmF2HG
         cUjzVPKd/sMVrTatDcSxQcNeQrXnu6yb/cgcux1OI5H/BCTrVlQrJx/1Ggt8orgJHrCH
         uMig==
X-Gm-Message-State: AOJu0YzuyIr7w7mmF4uoDzumaKiI11zabkDau/yhiIpO4qKf6RF6OFTw
        oVUVrdDVd8yh1gAoVSKQq+rsXA==
X-Google-Smtp-Source: AGHT+IEtFuZ3O84gAkborwTw/bhyspsZdiM0BBSNCbdmoHbzaSxqkx1BUBYjlQ21TF8TtUaUS+2FdQ==
X-Received: by 2002:a05:6512:202a:b0:500:b2be:61e1 with SMTP id s10-20020a056512202a00b00500b2be61e1mr3427622lfs.58.1694677293202;
        Thu, 14 Sep 2023 00:41:33 -0700 (PDT)
Received: from [192.168.69.115] (sem44-h01-176-172-56-29.dsl.sta.abo.bbox.fr. [176.172.56.29])
        by smtp.gmail.com with ESMTPSA id t18-20020a056402021200b0052fdfd8870bsm548764edv.89.2023.09.14.00.41.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Sep 2023 00:41:32 -0700 (PDT)
Message-ID: <75ea5477-ca1b-7016-273c-abd6c36f4be4@linaro.org>
Date:   Thu, 14 Sep 2023 09:41:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v4 21/21] i386: Add new property to control L2 cache topo
 in CPUID.04H
Content-Language: en-US
To:     Zhao Liu <zhao1.liu@linux.intel.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Zhenyu Wang <zhenyu.z.wang@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Babu Moger <babu.moger@amd.com>,
        Zhao Liu <zhao1.liu@intel.com>,
        Yongwei Ma <yongwei.ma@intel.com>
References: <20230914072159.1177582-1-zhao1.liu@linux.intel.com>
 <20230914072159.1177582-22-zhao1.liu@linux.intel.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230914072159.1177582-22-zhao1.liu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/9/23 09:21, Zhao Liu wrote:
> From: Zhao Liu <zhao1.liu@intel.com>
> 
> The property x-l2-cache-topo will be used to change the L2 cache
> topology in CPUID.04H.
> 
> Now it allows user to set the L2 cache is shared in core level or
> cluster level.
> 
> If user passes "-cpu x-l2-cache-topo=[core|cluster]" then older L2 cache
> topology will be overrode by the new topology setting.
> 
> Here we expose to user "cluster" instead of "module", to be consistent
> with "cluster-id" naming.
> 
> Since CPUID.04H is used by intel CPUs, this property is available on
> intel CPUs as for now.
> 
> When necessary, it can be extended to CPUID.8000001DH for AMD CPUs.
> 
> (Tested the cache topology in CPUID[0x04] leaf with "x-l2-cache-topo=[
> core|cluster]", and tested the live migration between the QEMUs w/ &
> w/o this patch series.)
> 
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> ---
> Changes since v3:
>   * Add description about test for live migration compatibility. (Babu)
> 
> Changes since v1:
>   * Rename MODULE branch to CPU_TOPO_LEVEL_MODULE to match the previous
>     renaming changes.
> ---
>   target/i386/cpu.c | 34 +++++++++++++++++++++++++++++++++-
>   target/i386/cpu.h |  2 ++
>   2 files changed, 35 insertions(+), 1 deletion(-)


> @@ -8079,6 +8110,7 @@ static Property x86_cpu_properties[] = {
>                        false),
>       DEFINE_PROP_BOOL("x-intel-pt-auto-level", X86CPU, intel_pt_auto_level,
>                        true),
> +    DEFINE_PROP_STRING("x-l2-cache-topo", X86CPU, l2_cache_topo_level),

We use the 'x-' prefix for unstable features, is it the case here?

>       DEFINE_PROP_END_OF_LIST()
>   };

