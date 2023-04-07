Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88C3C6DB6B8
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 01:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbjDGXBI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 19:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDGXBG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 19:01:06 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FDF8AF33
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 16:01:04 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id p8so171025plk.9
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 16:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680908464;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Pwlm1lMKQRjwxkmrW2F8t3gfYFcIvBu5GbvK5p1f3qI=;
        b=WYmgbbs2HSI1ZfANhB99p0It58GikHCFHg8GiCJM3VQAfDfBj7TpC/bvTiV2pJ79UV
         KAS5g4RAW3gC6aKuL00Z27MQAUOxZbmVQcMfZCDSB1r0VuBIuxLsMFHZKi1LaGTK3hGD
         QdhxTCrlzTDRZmVjPx1eYN/x1bPBMtI6NsRmoM2cgteOFw+t/qEnW3IymFjABKUtyO2w
         8JLLbEMqf+MaY87jjDzMDFdSjZ/ZhpXDV5gbgrECBEdb7dvChp+koaU4p/FdyjA+cGPu
         Q4it2C7c8GRxrjcQrXOBMNxBTHsarpA5kw1bkpmHXyGaIy0+DjId1bO+doBUisVu8LKa
         wxmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680908464;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pwlm1lMKQRjwxkmrW2F8t3gfYFcIvBu5GbvK5p1f3qI=;
        b=f+HsOC0kUiNttlztNF36OiAu/jRyGl6YIEDSEOKaW/XR4tfNtzpBzX01KMOxibdsR0
         51XktfrKoUroPjvBs7unXeEWqeShqB1fOldRNX+8+gGQv8ESI5ZFDSNfEO6kE090cMRb
         UJ0mOJ3ycgphLCYL0uev8JjLfUeQ4M6Odwx1J5ko/s0CFoPnZn9w+CiLRjHg/yLo7q+7
         dKsQP0xK8PPduMjYSu1VWqchVnx6WowFNmKvIXr4sPBE53a8SrUmilGat3zWrcfRc061
         V6GOIp+QDzfbIg26rfWsNNZSEjXIhCrN3/xg6HjuvfTyyVrZOcnocmR8KuiS0bXmWcY4
         AMWQ==
X-Gm-Message-State: AAQBX9fQ3+hEEedvvwkole3FHFTcQUjfgSez8CqtdUqC/pGHBtoV63cu
        pLDZHMRT4lQXM1vKteB3EtYIPg==
X-Google-Smtp-Source: AKy350aJv8JM6VFQdChjoum7LkzJsp3BEooDRP1tQQsqzUK9IOYyaf2AaDi9zqTn0y042mdujiyLbw==
X-Received: by 2002:a05:6a20:cd5d:b0:d9:f539:727f with SMTP id hn29-20020a056a20cd5d00b000d9f539727fmr4424102pzb.28.1680908463869;
        Fri, 07 Apr 2023 16:01:03 -0700 (PDT)
Received: from ?IPV6:2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8? ([2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8])
        by smtp.gmail.com with ESMTPSA id s21-20020aa78295000000b0062dc14ee2a7sm3505522pfm.211.2023.04.07.16.01.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 16:01:03 -0700 (PDT)
Message-ID: <8174dba8-3d19-58e6-9bcc-cb8b58d76c1b@linaro.org>
Date:   Fri, 7 Apr 2023 16:01:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 01/14] accel: Document generic accelerator headers
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>
References: <20230405101811.76663-1-philmd@linaro.org>
 <20230405101811.76663-2-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230405101811.76663-2-philmd@linaro.org>
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

On 4/5/23 03:17, Philippe Mathieu-Daudé wrote:
> These headers are meant to be include by any file to check
> the availability of accelerators, thus are not accelerator
> specific.
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   include/sysemu/hax.h  | 2 ++
>   include/sysemu/kvm.h  | 2 ++
>   include/sysemu/nvmm.h | 2 ++
>   include/sysemu/tcg.h  | 2 ++
>   include/sysemu/whpx.h | 2 ++
>   include/sysemu/xen.h  | 2 ++
>   6 files changed, 12 insertions(+)

Acked-by: Richard Henderson <richard.henderson@linaro.org>

r~
