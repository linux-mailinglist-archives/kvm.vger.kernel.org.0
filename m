Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74B1A753AF5
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 14:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235519AbjGNM3K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 08:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233758AbjGNM3H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 08:29:07 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C721D30EF;
        Fri, 14 Jul 2023 05:28:36 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id ffacd0b85a97d-307d58b3efbso1968073f8f.0;
        Fri, 14 Jul 2023 05:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689337715; x=1691929715;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w2t3L/hSRRZjqaV5sSCpUwSvgrFE/dKADUY0Rk/fxFI=;
        b=T7bnu0TsapNzMAN7yDxEUE5IUGjDIHYFMnBU5NpGaXEZ5RNrEeG2V1wISbJavxoffn
         l9j/RRVVX2HprRIBqgpVhvLUpayJHUd+IScXgOx/JydlmJVP5mR2+lCMdAyd59o0iSKQ
         8jKHAPPBF7jDVu1X1m9mNSXUiE1kl2DVXgAdXhfyTkb3cRQ0wtHeD7KV4++VVr3UFL5I
         DiWEdpCSYo1m5HD/Xev0C1ntqv8mUtNf9uEl5DSo0X9DXTJBg+lz2C0QudejakvzIQUV
         kqTU6lK3hry14wu1/OfAXb+/Y532cWeMTbpHnFRunT1z0jZL9BWTWATIbuUtnMxeNP5M
         PPaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689337715; x=1691929715;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w2t3L/hSRRZjqaV5sSCpUwSvgrFE/dKADUY0Rk/fxFI=;
        b=PaLuoqAWNBudOdX6mXnQECeGXWhF+gOK45XQHjv0J9sQlkzgUGiqwih+Q05cE4SKE9
         cwUvL2JH6y0uqinuRbo6XXihiCCfnGEkGDRCeSx8M8JNc41WERXumA2lTE2tbVV/hs0v
         c7SGkAj3SiJ9Px3xKoCF9Gxa2HKIyr+GJpx/52FrKaq5fL3Sz2abFzDO4XhI0RnkAERC
         agneWz7Wi0Tzy/KGot/8JcL33AdoX4Tu5HI/hjTWtsbCYWDr+1AnsBMI8iJGm9C0O3jd
         rfoCIjV6br5j3dCI8/E6Cq1zA9icoy9yeVCh9LdmskRR/E6q1ADyM4wmdx7SNNwA1n6o
         5khQ==
X-Gm-Message-State: ABy/qLaXKp7jGUc1GOoh/kErmz4TjeFAGGYPqMpyD3GrGD77ShOwdl27
        m5RPmL8x1K4H/mQnphM7q6c=
X-Google-Smtp-Source: APBJJlGJF19faVHp44i27HlkJBOfkAmszjhYGp/4H8ehYSJfSoqM9cXLH/Czl0j45GTO2c9r6aP8uA==
X-Received: by 2002:a5d:5248:0:b0:313:f7a1:3d92 with SMTP id k8-20020a5d5248000000b00313f7a13d92mr3988765wrc.66.1689337714575;
        Fri, 14 Jul 2023 05:28:34 -0700 (PDT)
Received: from ?IPV6:2a10:bac0:b000:74c4:b5f4:b227:cd6f:fb3f? ([2a10:bac0:b000:74c4:b5f4:b227:cd6f:fb3f])
        by smtp.gmail.com with ESMTPSA id q14-20020adfea0e000000b003063a92bbf5sm10700459wrm.70.2023.07.14.05.28.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jul 2023 05:28:34 -0700 (PDT)
Message-ID: <f176eabc-5fbe-e993-e207-dcf13ea55f0b@gmail.com>
Date:   Fri, 14 Jul 2023 15:28:32 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 04/10] x86/tdx: Make macros of TDCALLs consistent with the
 spec
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, peterz@infradead.org,
        kirill.shutemov@linux.intel.com, linux-kernel@vger.kernel.org
Cc:     dave.hansen@intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, seanjc@google.com,
        pbonzini@redhat.com, kvm@vger.kernel.org, isaku.yamahata@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com
References: <cover.1689151537.git.kai.huang@intel.com>
 <ba4b4ff1fe77ca76cca370b2fd4aa57a2d23c86d.1689151537.git.kai.huang@intel.com>
From:   Nikolay Borisov <n.borisov.lkml@gmail.com>
In-Reply-To: <ba4b4ff1fe77ca76cca370b2fd4aa57a2d23c86d.1689151537.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12.07.23 г. 11:55 ч., Kai Huang wrote:
> The TDX spec names all TDCALLs with prefix "TDG".  Currently, the kernel
> doesn't follow such convention for the macros of those TDCALLs but uses
> prefix "TDX_" for all of them.  Although it's arguable whether the TDX
> spec names those TDCALLs properly, it's better for the kernel to follow
> the spec when naming those macros.
> 
> Change all macros of TDCALLs to make them consistent with the spec.  As
> a bonus, they get distinguished easily from the host-side SEAMCALLs,
> which all have prefix "TDH".
> 
> No functional change intended.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>   arch/x86/coco/tdx/tdx.c | 22 +++++++++++-----------
>   1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
> index 5b8056f6c83f..de021df92009 100644
> --- a/arch/x86/coco/tdx/tdx.c
> +++ b/arch/x86/coco/tdx/tdx.c
> @@ -15,11 +15,11 @@
>   #include <asm/pgtable.h>
>   
>   /* TDX module Call Leaf IDs */
> -#define TDX_GET_INFO			1
> -#define TDX_GET_VEINFO			3
> -#define TDX_GET_REPORT			4
> -#define TDX_ACCEPT_PAGE			6
> -#define TDX_WR				8
> +#define TDG_VP_INFO			1
> +#define TDG_VP_VEINFO_GET		3
> +#define TDG_MR_REPORT			4
> +#define TDG_MEM_PAGE_ACCEPT		6
> +#define TDG_VM_WR			8
>   
What branch is this patch set based off? Because the existing TDX_GET_* 
defines are in arch/x86/include/asm/shared/tdx.h due to ff40b5769a50f ?


<snip>
