Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EABFE74109B
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 13:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbjF1L7L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 07:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231815AbjF1L7F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 07:59:05 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F09762D7F
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 04:59:03 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id ffacd0b85a97d-3094910b150so6508471f8f.0
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 04:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687953542; x=1690545542;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XAnNOBqj7/aZOLa/iEWVdgiwRfPn+uBhlnTFYDZDHtw=;
        b=XE7Vi2wrCeeILyk3U/eN0QEw2vyalWxVrmJf4lD0tUb7oMCiVJf8wS7IHVCfWF1ljm
         UcYgRcV+vj/TBd9upybrGu2ZGnWQcYk115AdgEaWs35KGlrLBhcqG0BEhTcU7YjZck4e
         hZnPymWrPJt5bpB6buQ8HEi1nwHGrrdsvvsmSmYanpPr8vBk4Iw+l38CFXHwaRUuBcEw
         oO5si+rS6KwqffIjHKgUWwn6ziExQo+Lxfh6bCrhbutF0UwXkHqNHNbT49sTTF/BwM5b
         xVXU+6JUZHdDPEpQFm8vio/70Zk337UqTeAm/3QQDEKOChBQNaN3tDnqXgvim7JECTXh
         ovwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687953542; x=1690545542;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XAnNOBqj7/aZOLa/iEWVdgiwRfPn+uBhlnTFYDZDHtw=;
        b=OL1QnA1xbUYkgpKcN8ppvA51A9Ko0iCinE8rtW15fyyXjrbPFsSx/fkG/MwSbWpS8t
         e1Q4yyintyVPt+1Q4VDz+vY2Bj78aBC4Cq+IlIovhNfoN6GqTDFEBFqJ8Km+NOKJxJA/
         E8KswwnwcsWiHP1e6ZS/oNj8XJ34vS7se/t/hSi/Tr68UImFwHUToUGZlTZZGqZUQHK3
         9E6w2dR/c0aXAcY29wwE7agNI92Sr4v5N3kuqT6MI4DhQIq6ldNH8YvuKN43MTzeNGvK
         enA+PHqZPdayeeNeV8Jm58LT/jxmZ6qp4vMQWfM9E6zPySEntFtz8YjcgWT5IwT2roQV
         dr6A==
X-Gm-Message-State: AC+VfDwZLGA0gt41DlHs8c18KTukOlZJO/4wJSep08J6CQMWO2y0h8RU
        VhR8pGWuxakocOIALnkH1MJoWg==
X-Google-Smtp-Source: ACHHUZ5EJieVTJ0ylfA8kzbRNwsOjUJqO0iacg3Gk1TjS5ordwDft3hLui2kj4QeSRA9jXw9Lp4yWQ==
X-Received: by 2002:a05:6000:1b81:b0:313:f957:fc0c with SMTP id r1-20020a0560001b8100b00313f957fc0cmr5011317wru.47.1687953542430;
        Wed, 28 Jun 2023 04:59:02 -0700 (PDT)
Received: from [192.168.69.115] ([176.187.207.229])
        by smtp.gmail.com with ESMTPSA id t5-20020a05600001c500b00313f7b077fesm6513263wrx.59.2023.06.28.04.59.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jun 2023 04:59:01 -0700 (PDT)
Message-ID: <19821e47-0ea0-ca79-2c1c-3f663c9921f7@linaro.org>
Date:   Wed, 28 Jun 2023 13:58:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [PATCH v3 00/16] accel: Share CPUState accel context
 (HAX/NVMM/WHPX/HVF)
Content-Language: en-US
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Roman Bolshakov <rbolshakov@ddn.com>, qemu-arm@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Alexander Graf <agraf@csgraf.de>,
        xen-devel@lists.xenproject.org,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        Paul Durrant <paul@xen.org>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Cameron Esfahani <dirty@apple.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230624174121.11508-1-philmd@linaro.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230624174121.11508-1-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/6/23 19:41, Philippe Mathieu-Daudé wrote:

> Philippe Mathieu-Daudé (16):
>    MAINTAINERS: Update Roman Bolshakov email address
>    accel: Document generic accelerator headers
>    accel: Remove unused hThread variable on TCG/WHPX
>    accel: Fix a leak on Windows HAX
>    accel: Destroy HAX vCPU threads once done
>    accel: Rename 'hax_vcpu' as 'accel' in CPUState
>    accel: Rename HAX 'struct hax_vcpu_state' -> AccelCPUState
>    accel: Move HAX hThread to accelerator context
>    accel: Remove NVMM unreachable error path
>    accel: Rename NVMM 'struct qemu_vcpu' -> AccelCPUState
>    accel: Inline NVMM get_qemu_vcpu()
>    accel: Remove WHPX unreachable error path
>    accel: Rename WHPX 'struct whpx_vcpu' -> AccelCPUState
>    accel: Inline WHPX get_whpx_vcpu()
>    accel: Rename 'cpu_state' -> 'cs'
>    accel: Rename HVF 'struct hvf_vcpu_state' -> AccelCPUState

Series queued.
