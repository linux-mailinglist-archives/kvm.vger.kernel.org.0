Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6B23AE6FD
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 12:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbhFUK0S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 06:26:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34979 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230152AbhFUK0R (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Jun 2021 06:26:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624271043;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CFP+bBW5W6kTZB9H0onGu9RL+/PFl1GSn7nOHvioNQY=;
        b=Fapan8otEEFC1wF84YtcO7QS0heTRhj6VkUBONyUGnTdMVGu76it6JY4UG/IjNGvR7EV+Y
        vXuEF/8VGPFQb7wxcsVoo3Gy/qEVZ8TuQHpaidG/OCeoyjlUBEyU+dtCrgZH50iI1ZyiG2
        wm02vihjljg3FrGxXfO9vVICTPtAr6Q=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-qL4AAXqINFO9wj1_FwJeWw-1; Mon, 21 Jun 2021 06:24:02 -0400
X-MC-Unique: qL4AAXqINFO9wj1_FwJeWw-1
Received: by mail-wm1-f72.google.com with SMTP id w186-20020a1cdfc30000b02901ced88b501dso5665640wmg.2
        for <kvm@vger.kernel.org>; Mon, 21 Jun 2021 03:24:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CFP+bBW5W6kTZB9H0onGu9RL+/PFl1GSn7nOHvioNQY=;
        b=JEpUdoG7oHSOJo7z2xEkppexL1P1Qsssl86KAN0/Ws1wR5K503vdn9PJYAJRkjkBev
         +YwlnuJYmFsEqzmGHww3REI9uZjCQ+DM4TGJBHfL5QPV8u1wGnCUyimrdB+hnsVzfgnv
         esaVfONx0JOO0Qbqmy2Eyn5fkHU6LP4qxB+D9tAFs3Ed+ayPHDiEAJGVFziQmnD9Sb7/
         Ocmp2BfdJDmX+ECro/pWn6LeBZyp7Trr+5ZuUB0vsrmgsdf+uW5UA/aUw4cNe35GKgi8
         ZOhinsA7oRxvmoiFQ9E0bv/qea4NcZ+hpHXDWIt/LEtf+Li5DrhUc3ao3TOJCCzc2S0B
         FlMA==
X-Gm-Message-State: AOAM5338gA7kPmH0s/W5KqYFIROlGlw/HIFExX1EFZLS6hLbbTL1aSSi
        Ex8kFvO4P5XNvZJkHWjiAqBeoZWwKEDNrA1yYYM/g92bakU6oH7hlYx8ILLaNcVdhxoZqIEz5X2
        NFrWNJvH6uHZf
X-Received: by 2002:a5d:6c64:: with SMTP id r4mr1804074wrz.316.1624271041229;
        Mon, 21 Jun 2021 03:24:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy4D2bw8vSx5i/LERK0SCMj//6IgDg2pWN6tzwURnO51Qecma8v3T73ZrXAltoSGe9wFG8Bgg==
X-Received: by 2002:a5d:6c64:: with SMTP id r4mr1804056wrz.316.1624271041048;
        Mon, 21 Jun 2021 03:24:01 -0700 (PDT)
Received: from thuth.remote.csb (pd9575fcd.dip0.t-ipconnect.de. [217.87.95.205])
        by smtp.gmail.com with ESMTPSA id n8sm4222413wmc.45.2021.06.21.03.23.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 03:24:00 -0700 (PDT)
Subject: Re: [kvm-unit-tests RFC 2/2] s390x: mvpg: Add SIE mvpg test
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <20210520094730.55759-1-frankja@linux.ibm.com>
 <20210520094730.55759-3-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <35c30a30-e245-e1e2-facc-4685455da575@redhat.com>
Date:   Mon, 21 Jun 2021 12:23:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210520094730.55759-3-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/05/2021 11.47, Janosch Frank wrote:
> Let's also check the PEI values to make sure our VSIE implementation
> is correct.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   s390x/Makefile                  |   3 +-
>   s390x/mvpg-sie.c                | 139 ++++++++++++++++++++++++++++++++
>   s390x/snippets/c/mvpg-snippet.c |  33 ++++++++
>   s390x/unittests.cfg             |   3 +
>   4 files changed, 177 insertions(+), 1 deletion(-)
>   create mode 100644 s390x/mvpg-sie.c
>   create mode 100644 s390x/snippets/c/mvpg-snippet.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index fe267011..6692cf73 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -22,6 +22,7 @@ tests += $(TEST_DIR)/uv-guest.elf
>   tests += $(TEST_DIR)/sie.elf
>   tests += $(TEST_DIR)/mvpg.elf
>   tests += $(TEST_DIR)/uv-host.elf
> +tests += $(TEST_DIR)/mvpg-sie.elf
>   
>   tests_binary = $(patsubst %.elf,%.bin,$(tests))
>   ifneq ($(HOST_KEY_DOCUMENT),)
> @@ -79,7 +80,7 @@ FLATLIBS = $(libcflat)
>   SNIPPET_DIR = $(TEST_DIR)/snippets
>   report_abort
>   # C snippets that need to be linked
> -snippets-c =
> +snippets-c = $(SNIPPET_DIR)/c/mvpg-snippet.gbin
>   
>   # ASM snippets that are directly compiled and converted to a *.gbin
>   snippets-a =
> diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
> new file mode 100644
> index 00000000..a617704b
> --- /dev/nullreport_abort
> +++ b/s390x/mvpg-sie.c
> @@ -0,0 +1,139 @@
> +#include <libcflat.h>
> +#include <asm/asm-offsets.h>
> +#include <asm-generic/barrier.h>
> +#include <asm/interrupt.h>
> +#include <asm/pgtable.h>
> +#include <mmu.h>
> +#include <asm/page.h>
> +#include <asm/facility.h>
> +#include <asm/mem.h>
> +#include <asm/sigp.h>
> +#include <smp.h>
> +#include <alloc_page.h>
> +#include <bitops.h>
> +#include <vm.h>
> +#include <sclp.h>
> +#include <sie.h>
> +
> +static u8 *guest;
> +static u8 *guest_instr;
> +static struct vm vm;
> +
> +static uint8_t *src;
> +static uint8_t *dst;
> +
> +extern const char _binary_s390x_snippets_c_mvpg_snippet_gbin_start[];
> +extern const char _binary_s390x_snippets_c_mvpg_snippet_gbin_end[];
> +int binary_size;
> +
> +static void handle_validity(struct vm *vm)
> +{
> +	report(0, "VALIDITY: %x", vm->sblk->ipb >> 16);
> +}

Maybe rather use report_abort() in that case? Or does it make sense to 
continue running the other tests afterwards?

  Thomas

