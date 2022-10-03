Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB8755F3929
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 00:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiJCWgM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 18:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiJCWgK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 18:36:10 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4F12657B
        for <kvm@vger.kernel.org>; Mon,  3 Oct 2022 15:36:09 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id q7so3841364pfl.9
        for <kvm@vger.kernel.org>; Mon, 03 Oct 2022 15:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date;
        bh=Bg3bkDSB5Rie05Qpuc6aVORV4OAik7UrPscyfhGNsaI=;
        b=I1tecMML8qAvywZ8EcCfrXEVSIAfj5Hl+TGGjtaywYdLot8hD0UiX/b4lpQcvGnC8h
         8BmhYqW3ifkJi6xVat/mbherD6PZL+WhHVtmxulTdfm/VPxvRvIywKLMZ6G6uLaVa8IY
         UKBp4gtt2iqOrcDtzQmqUtUsKlWQIFKooEfX0p6gR167G7ScPQzYvmfi7yZqtWdF4BVS
         OlXX8iejB+jQnVyoZ+0/pFm0Ia2hVNujX6gyF4aCxQDL1KNYE69T5rrMf8SRuky33UB+
         BIkJaD88RJWagt+klR00KC2xJOoQElZk3NO2ZTaXwcZwKmPlh/V3RB9KM357lq+gadcR
         ELeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date;
        bh=Bg3bkDSB5Rie05Qpuc6aVORV4OAik7UrPscyfhGNsaI=;
        b=kLDtDjUVYvKgvQLmkR7YjdJ/3f9HZsMgcnVSZC4LUerttAIyCTf/OTcEpU3++1KHI6
         wzdmSV7TmFVH9371BU7thxakckvq3l7VcD/P0kuepXR7Lu8141rYdLtGvvxBdhRxxcrL
         YxrrHvwRozRLf3XL/NribU6OzWbZYDFetNltZQZzB+grmC7Lzjp2nw2DTXacv68QDbzm
         Sv8PeEbQXhQ1anptNopaebtPcjRwLVIFiQeXPkjAHunwI967AmkxAB85xJvhfFcguP7f
         qdrf1WXnFq+7BiKo3N8AnEza+4yCytc/tpQEET7v7l+twX+zqUAEEFVBaP+/dnRA6vB/
         yiWA==
X-Gm-Message-State: ACrzQf1gkVaAFSLIDAt8GOA//5UXvTXnAevZ8928K9iI4bzH9uW3t9uO
        ztyH55Cr76W6b8pAZ5XW4pg=
X-Google-Smtp-Source: AMsMyM6zAiok65R6bvlwGEhT9m/OQe63yLDEtUTxK6a52WXzIWscx2EYSc5EBZCqYcL3sICm4Aj0ag==
X-Received: by 2002:a63:ff1b:0:b0:43c:e4ee:e5e0 with SMTP id k27-20020a63ff1b000000b0043ce4eee5e0mr19775305pgi.540.1664836569138;
        Mon, 03 Oct 2022 15:36:09 -0700 (PDT)
Received: from [192.168.1.115] ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id d17-20020a170902b71100b0017f61576dbesm2104467pls.304.2022.10.03.15.36.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Oct 2022 15:36:08 -0700 (PDT)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Message-ID: <b529059a-7819-e49d-e4dc-7ae79ee21ec5@amsat.org>
Date:   Tue, 4 Oct 2022 00:36:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH v2] mips/malta: pass RNG seed to to kernel via env var
Content-Language: en-US
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>, qemu-devel@nongnu.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        kvm-devel <kvm@vger.kernel.org>,
        Laurent Vivier <lvivier@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
References: <YziPyCqwl5KIE2cf@zx2c4.com>
 <20221003103627.947985-1-Jason@zx2c4.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
In-Reply-To: <20221003103627.947985-1-Jason@zx2c4.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

Per 
https://www.qemu.org/docs/master/devel/submitting-a-patch.html#when-resending-patches-add-a-version-tag:

Send each new revision as a new top-level thread, rather than burying it 
in-reply-to an earlier revision, as many reviewers are not looking 
inside deep threads for new patches.

On 3/10/22 12:36, Jason A. Donenfeld wrote:
> As of the kernel commit linked below, Linux ingests an RNG seed
> passed from the hypervisor. So, pass this for the Malta platform, and
> reinitialize it on reboot too, so that it's always fresh.
 >
> Cc: Philippe Mathieu-Daudé <f4bug@amsat.org>
> Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
> Cc: Aurelien Jarno <aurelien@aurel32.net>
> Link: https://git.kernel.org/mips/c/056a68cea01

You seem to justify this commit by the kernel commit, which justifies
itself mentioning hypervisor use... So the egg comes first before the
chicken.

> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
> Changes v1->v2:
> - Update commit message.
> - No code changes.
> 
>   hw/mips/malta.c | 25 +++++++++++++++++++++++++
>   1 file changed, 25 insertions(+)
> 
> diff --git a/hw/mips/malta.c b/hw/mips/malta.c
> index 0e932988e0..9d793b3c17 100644
> --- a/hw/mips/malta.c
> +++ b/hw/mips/malta.c
> @@ -26,6 +26,7 @@
>   #include "qemu/units.h"
>   #include "qemu/bitops.h"
>   #include "qemu/datadir.h"
> +#include "qemu/guest-random.h"
>   #include "hw/clock.h"
>   #include "hw/southbridge/piix.h"
>   #include "hw/isa/superio.h"
> @@ -1017,6 +1018,17 @@ static void G_GNUC_PRINTF(3, 4) prom_set(uint32_t *prom_buf, int index,
>       va_end(ap);
>   }
>   
> +static void reinitialize_rng_seed(void *opaque)
> +{
> +    char *rng_seed_hex = opaque;
> +    uint8_t rng_seed[32];
> +
> +    qemu_guest_getrandom_nofail(rng_seed, sizeof(rng_seed));
> +    for (size_t i = 0; i < sizeof(rng_seed); ++i) {
> +        sprintf(rng_seed_hex + i * 2, "%02x", rng_seed[i]);
> +    }
> +}
> +
>   /* Kernel */
>   static uint64_t load_kernel(void)
>   {
> @@ -1028,6 +1040,8 @@ static uint64_t load_kernel(void)
>       long prom_size;
>       int prom_index = 0;
>       uint64_t (*xlate_to_kseg0) (void *opaque, uint64_t addr);
> +    uint8_t rng_seed[32];
> +    char rng_seed_hex[sizeof(rng_seed) * 2 + 1];
>   
>   #if TARGET_BIG_ENDIAN
>       big_endian = 1;
> @@ -1115,9 +1129,20 @@ static uint64_t load_kernel(void)
>   
>       prom_set(prom_buf, prom_index++, "modetty0");
>       prom_set(prom_buf, prom_index++, "38400n8r");
> +
> +    qemu_guest_getrandom_nofail(rng_seed, sizeof(rng_seed));
> +    for (size_t i = 0; i < sizeof(rng_seed); ++i) {
> +        sprintf(rng_seed_hex + i * 2, "%02x", rng_seed[i]);
> +    }
> +    prom_set(prom_buf, prom_index++, "rngseed");
> +    prom_set(prom_buf, prom_index++, "%s", rng_seed_hex);

You use the firmware interface to pass rng data to an hypervisor...

Look to me you are forcing one API to ease another one. From the
FW PoV it is a lie, because the FW will only change this value if
an operator is involved. Here PROM stands for "programmable read-only
memory", rarely modified. Having the 'rngseed' updated on each
reset is surprising.

Do you have an example of firmware doing that? (So I can understand
whether this is the best way to mimic this behavior here).

Aren't they better APIs to have hypervisors pass data to a kernel?

Regards,

Phil.

>       prom_set(prom_buf, prom_index++, NULL);
>   
>       rom_add_blob_fixed("prom", prom_buf, prom_size, ENVP_PADDR);
> +    qemu_register_reset(reinitialize_rng_seed,
> +                        memmem(rom_ptr(ENVP_PADDR, prom_size), prom_size,
> +                               rng_seed_hex, sizeof(rng_seed_hex)));
>   
>       g_free(prom_buf);
>       return kernel_entry;

