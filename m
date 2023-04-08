Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF08E6DB8C7
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 06:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjDHEW3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 8 Apr 2023 00:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjDHEW1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 8 Apr 2023 00:22:27 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8191D339
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 21:22:25 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id q2so5349587pll.7
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 21:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680927745;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3XA7xu7b05KgVtUtSLaFSgkNI9Huml9S1qbjZOV/CIM=;
        b=A7AGaQS8AbhPZNUGaFRYZb7iEGObdhqjJ974H7//mCKlXrIg4OfqiRIcLdRBxjVvsQ
         V/PC2nHH1tjANBFhCUrhQphDxJsayHejY59urWvCAzvJULXR7k2rEBd4LLApbpSfcffa
         M3c8+w30vxLQcPAz2mYTDSlVm5EuIAOQV2SEJU5gewelFxp3kgxbnIcS+41B4xxkDx4R
         g6khRJK4GaDk3S7SHTMoQGcWpUBhe5Y+EWVjJPyhfHZe5J7lTuORb5onupkUjGObjLqU
         Ydr4smfjNYVBosDNqTGxlP67sc/c/W3g72Uh9CQKwIFlkUDjDKwKP/m2crmREuyCZFk/
         nkyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680927745;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3XA7xu7b05KgVtUtSLaFSgkNI9Huml9S1qbjZOV/CIM=;
        b=kpQMymaWuImCqkn+jm1gzohNv2MxQ9kJ85ReTDR5E8iCJMTXhqJptWu4+TUEQeH3AE
         62eLrNLJv0yyIVBK09S0RVcln2VZCr9+UVvWKse/jCUqObbZ2IsQOOeV0faRrH40hr/k
         3eQEtI8JGHRMT6heZCdNMsMRzfz3g6Xo6jb1ShLQVXcld4flJc53M4TBEh2z+0Hze4p+
         v1ymtq7/qJhJ9jNP5Y0Z3MgcjAC/EbuBbVsBbvGjmA1Edtba8lvkwtU9WGDzAxp0zhWz
         vhJVKLo2mUGvVEx/pGepoNyTtn8b7NFxKIyFRFiywo6SaSKpiti3TCNWIIQ+eRak5b+e
         KPkg==
X-Gm-Message-State: AAQBX9db0eqrlzbuH3hfo/iXTD0FJ0rcz3g6/Z+2JhZqYbiXIcAoteU1
        61ncj7GzFag/wnzKfflg4x029Q==
X-Google-Smtp-Source: AKy350ZvPzfE+y1QUhk2IBKWNvy8QImEs21aIMlCoaYiiwpGFf/8mac80Q8PkAy37yOwVjV6IBpT/Q==
X-Received: by 2002:a05:6a20:c12f:b0:d8:f082:437e with SMTP id bh47-20020a056a20c12f00b000d8f082437emr3896972pzb.12.1680927745360;
        Fri, 07 Apr 2023 21:22:25 -0700 (PDT)
Received: from ?IPV6:2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8? ([2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8])
        by smtp.gmail.com with ESMTPSA id z6-20020aa785c6000000b00571cdbd0771sm3781871pfn.102.2023.04.07.21.22.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 21:22:24 -0700 (PDT)
Message-ID: <f56d8333-2cb1-b612-ba7a-9acdceb62cc8@linaro.org>
Date:   Fri, 7 Apr 2023 21:22:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 03/10] hw/intc/arm_gic: Un-inline GIC*/ITS class_name()
 helpers
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     qemu-s390x@nongnu.org, qemu-riscv@nongnu.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
        Peter Maydell <peter.maydell@linaro.org>,
        Shannon Zhao <shannon.zhaosl@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <ani@anisinha.ca>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230405160454.97436-1-philmd@linaro.org>
 <20230405160454.97436-4-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230405160454.97436-4-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/5/23 09:04, Philippe Mathieu-Daudé wrote:
> "kvm_arm.h" contains external and internal prototype declarations.
> Files under the hw/ directory should only access the KVM external
> API.
> 
> In order to avoid machine / device models to include "kvm_arm.h"
> simply to get the QOM GIC/ITS class name, un-inline each class
> name getter to the proper device model file.
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   include/hw/intc/arm_gic.h              |  2 ++
>   include/hw/intc/arm_gicv3_common.h     | 10 ++++++
>   include/hw/intc/arm_gicv3_its_common.h |  9 ++++++
>   target/arm/kvm_arm.h                   | 45 --------------------------
>   hw/arm/virt-acpi-build.c               |  2 +-
>   hw/arm/virt.c                          |  1 +
>   hw/intc/arm_gic_common.c               |  7 ++++
>   hw/intc/arm_gicv3_common.c             | 14 ++++++++
>   hw/intc/arm_gicv3_its_common.c         | 12 +++++++
>   9 files changed, 56 insertions(+), 46 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
