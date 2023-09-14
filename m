Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAEB379FD43
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 09:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234161AbjINHcl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 03:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbjINHck (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 03:32:40 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB11CFA
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 00:32:35 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-9a9f139cd94so87208066b.2
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 00:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694676754; x=1695281554; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sQkQg+WQaNXU/YUTIcWsqOCq+YZdIsih/0uurCVxt4s=;
        b=Gv+Uhh2eFXzZaeeVdL6/DOW/k1T+R1o9dnhliq0tZbL8SwWGHgoayEROCQgcJEcXNi
         9LZ8CPHUveAN7rbYE7QPjA+ii4/kOy5vYKx5rNKfUvCAaQI4bWiTBHY+2nW7UrHsvmSo
         baBSlV8atXSGzbtN4PTpiFZR76R/0M35ir2123VsiqIo6RlCESgYCzm1uE4hNiCICAu1
         uFQyacjcpgQ17FUYO00XRkL4ZB6jU7vvx2dspA7xrSA/g1ZwMynRGm916RnayA8daJO9
         xPFUcg8I3/68lBCWIxg6W0yVsVAtIfqP/Z6Oudk421OYSKopzpQBqa2mQadom2USRIlY
         747Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694676754; x=1695281554;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sQkQg+WQaNXU/YUTIcWsqOCq+YZdIsih/0uurCVxt4s=;
        b=CKh9cOXCkOaNicGDxhQeJHwxlHDXtYYYoQ+yWEianCGQpLYUecEvSdsG2B5Jnn8krR
         v1RoVBCPt4xptBZvDTah9DX3qJTnx2klUThWu9PIdTOdOJkPGHttZuexofUb2KtbesPr
         bQfnU841+TevU28+YE9xGaBqtWhdvzl1tVjIwVsubtI9j420w9ZsdEneu3np+98fHDfX
         P+P56MXe+Y7oPF8R/rUVdlMNDQpho96Ehs+k7yyeq4W742zc5FfQKn/xjmrwLmNxQlmT
         O4B8cEaQIXvYHhpad3n0YzVfjggVoGr4xZwWz8+pOKiISjQA1tT46MzKi3Te+Rv9OPJu
         T5xQ==
X-Gm-Message-State: AOJu0Yx9Ld4CQvxbSeq8ff9dkukpBLTcEUhDG1ApSZl6N9orQBxE8tiK
        o7agVgn9TY1wfVx09fuFl+mqxw==
X-Google-Smtp-Source: AGHT+IGeWwXoWJSbO2YdWy2as/ETl2V4vZASu++SBccQOJdbtPyR5u0tZ2aeQz9fCh0jk10OCJzMCQ==
X-Received: by 2002:a17:906:1db2:b0:9a9:e3be:1310 with SMTP id u18-20020a1709061db200b009a9e3be1310mr3714790ejh.53.1694676754136;
        Thu, 14 Sep 2023 00:32:34 -0700 (PDT)
Received: from [192.168.69.115] (sem44-h01-176-172-56-29.dsl.sta.abo.bbox.fr. [176.172.56.29])
        by smtp.gmail.com with ESMTPSA id w26-20020a17090633da00b00988be3c1d87sm590078eja.116.2023.09.14.00.32.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Sep 2023 00:32:33 -0700 (PDT)
Message-ID: <b6acd6c8-fffe-2826-bc02-0968af0236a1@linaro.org>
Date:   Thu, 14 Sep 2023 09:32:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v4 04/21] hw/cpu: Update the comments of nr_cores and
 nr_dies
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
        Babu Moger <babu.moger@amd.com>, Zhao Liu <zhao1.liu@intel.com>
References: <20230914072159.1177582-1-zhao1.liu@linux.intel.com>
 <20230914072159.1177582-5-zhao1.liu@linux.intel.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230914072159.1177582-5-zhao1.liu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/9/23 09:21, Zhao Liu wrote:
> From: Zhao Liu <zhao1.liu@intel.com>
> 
> In the nr_threads' comment, specify it represents the
> number of threads in the "core" to avoid confusion.
> 
> Also add comment for nr_dies in CPUX86State.
> 
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
> Changes since v3:
>   * The new patch split out of CPUSTATE.nr_cores' fix. (Xiaoyao)
> ---
>   include/hw/core/cpu.h | 2 +-
>   target/i386/cpu.h     | 1 +
>   2 files changed, 2 insertions(+), 1 deletion(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

