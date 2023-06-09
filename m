Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2E50729D28
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 16:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240870AbjFIOnC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 10:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230431AbjFIOnA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 10:43:00 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC54E43;
        Fri,  9 Jun 2023 07:42:59 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-3f7378a75c0so13981575e9.3;
        Fri, 09 Jun 2023 07:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686321778; x=1688913778;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zO8ENOnSimS6n7gy9/kTHBLX2Up3InmL5+w7nO9x+a4=;
        b=mFpiqwqWl2vdGhX6AJu3w1NHIIZoQi6trxq0Lqp+ylDiBSnZiasMfSJxrk8StXj146
         bsFIpsnfeKf/pNWC/J7X6wDvXx3YJx06hGc/aoUNjRZBE/hojOLO4TolDHwlNlaktdLB
         HgJSDRPKW625qqxAZHmsfjs0fqEDTf5DUQ51s+DY78dzKkpZzUuTrKbgfipgdJnAplvh
         7yUqJSSwDnZ12P5iQD6U38lPC22hA1OGjLKncZsA/O9leoWMO2Znn9bIuG116hNxi/i/
         i/D4QRmYjQ8FgsH9xDbo33qHBT4pcYmPKSkqW7tbbY8IkqOCwYxOFtLXo3VsmZ6XSx9b
         mR2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686321778; x=1688913778;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zO8ENOnSimS6n7gy9/kTHBLX2Up3InmL5+w7nO9x+a4=;
        b=jupv8FwBpt5W/GU03ZIaNx+FF0tAzZEazn0pm4azyhOrINXUMZzLz0IHv70XFMoZN+
         6AdQCIOv6JgVfhgFKfTMvpwFax03UqmN5a8FDi70FryeCPmOiEoY4v6pCWtboxWnO+TN
         k/OkURQa88BJA/XR9ALSlo8uJQNYjugUnmxzs7yfSl7Snhy2bCx+B8wcHKj1qSl9XjI0
         yE8ycxdWpsHw12b477U/ESXNk8Bo1jZO3W6kKJdw0zXB8thMcDc3SWpgYD0VnWU4Ba16
         RFLYhoND7Y1J8DokiQ4SYSkHbUTLJiYIknpn55TqhOZxmwmcsR5A46mr0LlhGNInihSO
         xrjA==
X-Gm-Message-State: AC+VfDxo0wSvoo17fyoG8vwR/I5mhw6uw1xX/URO+eCr/Ct0ysi5YuI2
        obpi1pS8+n1yqvs+eX6F6hk=
X-Google-Smtp-Source: ACHHUZ7zRycn6Zhb+VOFkhu/NrKADDjabWSSsCk+2juGpn7Kl7FYm9QcZHMOp4VDrTurTF5Mu+KZFw==
X-Received: by 2002:adf:fd43:0:b0:309:3df3:8e0f with SMTP id h3-20020adffd43000000b003093df38e0fmr1093526wrs.51.1686321778019;
        Fri, 09 Jun 2023 07:42:58 -0700 (PDT)
Received: from ?IPV6:2a10:bac0:b000:7727:c9f1:3163:7113:1dbf? ([2a10:bac0:b000:7727:c9f1:3163:7113:1dbf])
        by smtp.gmail.com with ESMTPSA id x5-20020adff0c5000000b003078a3f3a24sm4637525wro.114.2023.06.09.07.42.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jun 2023 07:42:57 -0700 (PDT)
Message-ID: <51f4c068-7dbc-6f7d-fa49-b98807b74bee@gmail.com>
Date:   Fri, 9 Jun 2023 17:42:55 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v11 06/20] x86/virt/tdx: Handle SEAMCALL running out of
 entropy error
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1685887183.git.kai.huang@intel.com>
 <9b3582c9f3a81ae68b32d9997fcd20baecb63b9b.1685887183.git.kai.huang@intel.com>
From:   Nikolay Borisov <n.borisov.lkml@gmail.com>
In-Reply-To: <9b3582c9f3a81ae68b32d9997fcd20baecb63b9b.1685887183.git.kai.huang@intel.com>
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



On 4.06.23 г. 17:27 ч., Kai Huang wrote:
> Certain SEAMCALL leaf functions may return error due to running out of
> entropy, in which case the SEAMCALL should be retried as suggested by
> the TDX spec.
> 
> Handle this case in SEAMCALL common function.  Mimic the existing
> rdrand_long() to retry RDRAND_RETRY_LOOPS times.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
> 
> v10 -> v11:
>   - New patch
> 
> ---
>   arch/x86/virt/vmx/tdx/tdx.c | 15 ++++++++++++++-
>   arch/x86/virt/vmx/tdx/tdx.h | 17 +++++++++++++++++
>   2 files changed, 31 insertions(+), 1 deletion(-)
> 

<snip>

> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index 48ad1a1ba737..55dbb1b8c971 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -4,6 +4,23 @@
>   
>   #include <linux/types.h>
>   
> +/*
> + * This file contains both macros and data structures defined by the TDX
> + * architecture and Linux defined software data structures and functions.
> + * The two should not be mixed together for better readability.  The
> + * architectural definitions come first.
> + */
> +
> +/*
> + * TDX SEAMCALL error codes
> + */
> +#define TDX_RND_NO_ENTROPY	0x8000020300000000ULL

Where is this return value documented, in TDX module 1.0 spec there are 
only: 8000020[123]00000000 specified and there's 80000800 
(TDX_KEY_GENERATION_FAILED) and its description mentions the possible 
failure due to lack of entropy?

<snip>
