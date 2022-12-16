Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8130264EFAC
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 17:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbiLPQr2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 11:47:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231396AbiLPQrU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 11:47:20 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D85118E1D
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 08:47:17 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id c129so2459910oia.0
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 08:47:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=E7UrxsSLb+0W8g1qAvBnmTOhbPAx/vUfp/wBCrELUiQ=;
        b=AZI2H6SWr3rdh5b9DbAiSrZpxLPsh2OpoYHH5D6w3839Zki1KWeHcENSnxYCmnazA7
         T4DMPycqme1VRcEAYcLJkYcRT5+/pH416bzFs5q9rEPQzCh+br/IpqFzJOBSTJMvzBd+
         ieokTmTYbnwb2gopbpyNEb7wXnmkp+qb4hERc3xY1XrzPk1cpEjrPimFWp1ocwUlc3vX
         6kiVO68d82ac63lPCwgBwwq+/A+FKOCteLSmjpIbhPxIbSFjuvo04wCxel/d/ewiowUI
         G/Fuq59UDlOWHZT+5+69W2lwrmJjjGBvm8RFq0Fneow16RmyZ/kNV0Fqm5jMywRaL31Q
         kD+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E7UrxsSLb+0W8g1qAvBnmTOhbPAx/vUfp/wBCrELUiQ=;
        b=vFmbvM91HaKFbknIBnXR9Z6K1r5Sd9O2I113nMrir9z89iBQ5ZgcA4yRLjs56GpWDR
         zbieRUeEtQOnhmrV0iqySBB2LzqE6f6ypqgLh3nhvQEIlJdvq3suhui9CRLdecppJfAW
         SbfyOSxb0pCZDAoARRDzzoXnAk4fF+g8v+J1VBUGZ/kxvVAyLJkTXgSqQHa1LG/if80V
         4+utAR7MJHDNQu+psozvWF9JFiSEf12tW5j98uy7l1icoEDV3j0rQqXhBpWl50bG54Gz
         jTxSDxFDr/6C9MOFWS5gQfCVzlVVlqyhIn5DI3BZSDRXkBh/uNbd++UoN1BoHeC2CVQV
         n9ww==
X-Gm-Message-State: ANoB5pnb/zhKQ8vW0btj9q09rY05xw/lulhAWF+a5RYTA5QfC0iQK0hG
        JiNDzMVwJptgBp2zHBWlY6w=
X-Google-Smtp-Source: AA0mqf41f2ZzMZMs9c1XRbypYStSBBLDzk55zopupul3TcdAyZBeBNES07kuhEYCzXlmkc5PIZF8aQ==
X-Received: by 2002:a05:6808:1a9c:b0:35b:80e6:86f7 with SMTP id bm28-20020a0568081a9c00b0035b80e686f7mr13609964oib.43.1671209236833;
        Fri, 16 Dec 2022 08:47:16 -0800 (PST)
Received: from [192.168.68.106] (201-43-103-101.dsl.telesp.net.br. [201.43.103.101])
        by smtp.gmail.com with ESMTPSA id bk22-20020a0568081a1600b003544822f725sm933465oib.8.2022.12.16.08.47.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 08:47:16 -0800 (PST)
Message-ID: <c871b044-4241-2f02-ebd6-6b797663a140@gmail.com>
Date:   Fri, 16 Dec 2022 13:47:12 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH-for-8.0 4/4] hw/ppc/spapr_ovec: Avoid target_ulong
 spapr_ovec_parse_vector()
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-ppc@nongnu.org, David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Greg Kurz <groug@kaod.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Markus Armbruster <armbru@redhat.com>
References: <20221213123550.39302-1-philmd@linaro.org>
 <20221213123550.39302-5-philmd@linaro.org>
From:   Daniel Henrique Barboza <danielhb413@gmail.com>
In-Reply-To: <20221213123550.39302-5-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/13/22 09:35, Philippe Mathieu-Daudé wrote:
> spapr_ovec.c is a device, but it uses target_ulong which is
> target specific. The hwaddr type (declared in "exec/hwaddr.h")
> better fits hardware addresses.

As said by Harsh, spapr_ovec is in fact a data structure that stores platform
options that are supported by the guest.

That doesn't mean that I oppose the change made here. Aside from semantics - which
I also don't have a strong opinion about it - I don't believe it matters that
much - spapr is 64 bit only, so hwaddr will always be == target_ulong.

Cedric/David/Greg, let me know if you have any restriction/thoughts about this.
I'm inclined to accept it as is.


Daniel

> 
> Change spapr_ovec_parse_vector() to take a hwaddr argument,
> allowing the removal of "cpu.h" in a device header.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   hw/ppc/spapr_ovec.c         | 3 ++-
>   include/hw/ppc/spapr_ovec.h | 4 ++--
>   2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/hw/ppc/spapr_ovec.c b/hw/ppc/spapr_ovec.c
> index b2567caa5c..a18a751b57 100644
> --- a/hw/ppc/spapr_ovec.c
> +++ b/hw/ppc/spapr_ovec.c
> @@ -19,6 +19,7 @@
>   #include "qemu/error-report.h"
>   #include "trace.h"
>   #include <libfdt.h>
> +#include "cpu.h"
>   
>   #define OV_MAXBYTES 256 /* not including length byte */
>   #define OV_MAXBITS (OV_MAXBYTES * BITS_PER_BYTE)
> @@ -176,7 +177,7 @@ static target_ulong vector_addr(target_ulong table_addr, int vector)
>       return table_addr;
>   }
>   
> -SpaprOptionVector *spapr_ovec_parse_vector(target_ulong table_addr, int vector)
> +SpaprOptionVector *spapr_ovec_parse_vector(hwaddr table_addr, int vector)
>   {
>       SpaprOptionVector *ov;
>       target_ulong addr;
> diff --git a/include/hw/ppc/spapr_ovec.h b/include/hw/ppc/spapr_ovec.h
> index c3e8b98e7e..d756b916e4 100644
> --- a/include/hw/ppc/spapr_ovec.h
> +++ b/include/hw/ppc/spapr_ovec.h
> @@ -37,7 +37,7 @@
>   #ifndef SPAPR_OVEC_H
>   #define SPAPR_OVEC_H
>   
> -#include "cpu.h"
> +#include "exec/hwaddr.h"
>   
>   typedef struct SpaprOptionVector SpaprOptionVector;
>   
> @@ -73,7 +73,7 @@ void spapr_ovec_set(SpaprOptionVector *ov, long bitnr);
>   void spapr_ovec_clear(SpaprOptionVector *ov, long bitnr);
>   bool spapr_ovec_test(SpaprOptionVector *ov, long bitnr);
>   bool spapr_ovec_empty(SpaprOptionVector *ov);
> -SpaprOptionVector *spapr_ovec_parse_vector(target_ulong table_addr, int vector);
> +SpaprOptionVector *spapr_ovec_parse_vector(hwaddr table_addr, int vector);
>   int spapr_dt_ovec(void *fdt, int fdt_offset,
>                     SpaprOptionVector *ov, const char *name);
>   
