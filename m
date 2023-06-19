Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC043734D09
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 10:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjFSIG1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 04:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbjFSIGF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 04:06:05 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC0110DC
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 01:06:00 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-9889952ed18so152630366b.3
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 01:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687161959; x=1689753959;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j0l5GOaHWYG0L0zKQlFk/9TlrxBHtaYkVp2Z4p8EEnY=;
        b=D2D2iNFhbRpX0HCq0mM24zFaSrXA5S4oTEbSnp3xl9XIFMEIMZrARRa/0WtoS69MMh
         1wCfOucya6V4etrMO3VlUlxlxm5Jdt+6QyFezeprGFibc3yewc6KQ19L7QNSj+eR1Vnl
         garbCXPb4vLQ1TxsL/bk+tkIm2aGcTe8PQw79GdckIT1XMq9gl7r6GuE8KEveZUxN2Jr
         6qwY5Au0hjpaiRe0mc2svwzZjlj0req7r+uyR+pBu9ZYVWZVefARZyJAh2mgqIgZ+VNw
         Hnq7Kfh1DeMfZ7HGRA4cOqFMCTU1lrXjxuSvz0r4SLQtyxYEFQVd+RlexIBcddoS4mVa
         j6Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687161959; x=1689753959;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j0l5GOaHWYG0L0zKQlFk/9TlrxBHtaYkVp2Z4p8EEnY=;
        b=jC9q3SWrZm5QOrejsyo1itUa8tZHa8aRAuKnDGfbnnNgt1/xHa3GtpTuAE3aDu/DTr
         8PRXhH/ccPLPZuYt4ZVHUKmmfeBMBhTSfh+BZAbNLjXRfdVmEkAmdRpejU5vio2MGjw0
         YN82xPjRfXgGMKC49yqjAdf2Bv5EpgUkz/pg4At4hv6+H74v7enq8Ffvhgy29E5GLbtA
         pubBmGinSaU+45UQaeB8rXm9t/gInkcGM7n+vloO1P+iQB1qI0c3K8WAb21QTXwtaLyt
         dsa4xuKReHFQTkWoEH7aF/zPyfVlws0BTHKEqP+zR5AwSHrjBxVuC9R6DKVWuWPOuuEh
         jP3Q==
X-Gm-Message-State: AC+VfDyxjbqEwJR3t40StpkPaNaIpWK08wmEyFmLo/K6GW9CKjBTN+Z8
        B0weGhBXdY37Ieeex0IncfOucg==
X-Google-Smtp-Source: ACHHUZ49YEn+5itFRHuTll43hZznxgato+HMnQvuoh8l0WLgNI4U3K8ec4WhybOgDvxxrSKxEeu9Rw==
X-Received: by 2002:a17:907:1c95:b0:987:15ee:4399 with SMTP id nb21-20020a1709071c9500b0098715ee4399mr6970592ejc.29.1687161958726;
        Mon, 19 Jun 2023 01:05:58 -0700 (PDT)
Received: from [192.168.69.129] (sar95-h02-176-184-10-225.dsl.sta.abo.bbox.fr. [176.184.10.225])
        by smtp.gmail.com with ESMTPSA id a12-20020a170906670c00b00988b2050f47sm964912ejp.20.2023.06.19.01.05.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 01:05:58 -0700 (PDT)
Message-ID: <73329920-8d4c-dd55-2a09-1167b37a1903@linaro.org>
Date:   Mon, 19 Jun 2023 10:05:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 2/4] hw/dma/etraxfs: Include missing 'exec/memory.h'
 header
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Helge Deller <deller@gmx.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jason Wang <jasowang@redhat.com>
References: <20230619074153.44268-1-philmd@linaro.org>
 <20230619074153.44268-3-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230619074153.44268-3-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/19/23 09:41, Philippe Mathieu-Daudé wrote:
> The 'fs_dma_ctrl' structure has a MemoryRegion 'mmio' field
> which is initialized in etraxfs_dmac_init() calling
> memory_region_init_io() and memory_region_add_subregion().
> 
> These functions are declared in "exec/memory.h", along with
> the MemoryRegion structure. Include the missing header.
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   hw/dma/etraxfs_dma.c | 1 +
>   1 file changed, 1 insertion(+)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
