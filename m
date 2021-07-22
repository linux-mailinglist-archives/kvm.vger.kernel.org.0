Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC3F3D20DC
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 11:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbhGVIrf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 04:47:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22840 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231372AbhGVIre (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Jul 2021 04:47:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626946089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=caunD6WBo1XAHcQhMhOqrgWHallFQMHiPgjwSWOB4fg=;
        b=Azu9wEiLblw6D5pjAqTAVY+q5zuLPIykPHXhmLxE/g7xmJvSajBgXQyXVxw540UgJpQf8u
        qYD3V73xf8kpYLnrUxpMJnFwR5FAkwsRoMCfj8xxXrBXdb6iE20gATCfnP9eZCRBaJXWDc
        6I3aUl7/MALRL522QpAHBfHqX8rkAXw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-76-SwDIcakPPnug5MTtG0_cAQ-1; Thu, 22 Jul 2021 05:28:08 -0400
X-MC-Unique: SwDIcakPPnug5MTtG0_cAQ-1
Received: by mail-wr1-f71.google.com with SMTP id 32-20020adf82a30000b029013b21c75294so2217913wrc.14
        for <kvm@vger.kernel.org>; Thu, 22 Jul 2021 02:28:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=caunD6WBo1XAHcQhMhOqrgWHallFQMHiPgjwSWOB4fg=;
        b=UDtFsgsEBbWgzVONus17LF3pIpzjVD8e5RcqpcvJwas6j/0uwQ6bhg4L4KJtFd97bw
         FB1Q4oqRLOvZKDKLY59jHtP4+09TqWyxUqVj5kBl8x7pzIUz+L2Ed7TzS8E3UkB7yBPa
         EfJQrpfhyagDqFg1zd9YXtPxgdi//PQsNKiWThGojEn1Kcv8PhPiJLsbdidvP9N8qmSR
         4XvmLGJ7bleVu2Am4yz3kHSjaDXXc2J9vRTcBSqx88K1kEViNv9apHgPaN3g41Yzv4pT
         HB9MeIfIJRmUDc7UL1x8k6uRBFyi0pjZjSKJuaxfGMyQYI5GCUxxy6kuc3U377RZighp
         oP5w==
X-Gm-Message-State: AOAM530KhRqDNn0CVsYL4g1rPh5ApT6Ec2CcSIJ1tj1Z9Y498Yh5+A8/
        /XsNn/XJTfqUVJGOzG0++EE1jkN9fe8B8biyDQ/Tjl1kHRLFbDkHXzjbet4v9J0rSjWKtLEBDTT
        1FZZCykgMix49
X-Received: by 2002:adf:eb4c:: with SMTP id u12mr48930637wrn.111.1626946087098;
        Thu, 22 Jul 2021 02:28:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy7qEZuQMFJaccMc+yDMrFgFAX3BPD4rQhg/6jaiTrWYa3o98JI+tj1Q4/VvrDgcYk2nAWs4A==
X-Received: by 2002:adf:eb4c:: with SMTP id u12mr48930623wrn.111.1626946086932;
        Thu, 22 Jul 2021 02:28:06 -0700 (PDT)
Received: from thuth.remote.csb (pd9e83f5d.dip0.t-ipconnect.de. [217.232.63.93])
        by smtp.gmail.com with ESMTPSA id 140sm24964988wmb.43.2021.07.22.02.28.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 02:28:06 -0700 (PDT)
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20210706115724.372901-1-scgl@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] s390x: Add specification exception
 interception test
Message-ID: <709f6326-efcb-d359-bfac-59a162473c91@redhat.com>
Date:   Thu, 22 Jul 2021 11:28:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210706115724.372901-1-scgl@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/07/2021 13.57, Janis Schoetterl-Glausch wrote:
> Check that specification exceptions cause intercepts when
> specification exception interpretation is off.
> Check that specification exceptions caused by program new PSWs
> cause interceptions.
> We cannot assert that non program new PSW specification exceptions
> are interpreted because whether interpretation occurs or not is
> configuration dependent.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
> The patch is based on the following patch sets by Janosch:
> [kvm-unit-tests PATCH 0/5] s390x: sie and uv cleanups
> [kvm-unit-tests PATCH v2 0/3] s390x: Add snippet support
> 
>   s390x/Makefile             |  2 +
>   lib/s390x/sie.h            |  1 +
>   s390x/snippets/c/spec_ex.c | 13 ++++++
>   s390x/spec_ex-sie.c        | 91 ++++++++++++++++++++++++++++++++++++++
>   s390x/unittests.cfg        |  3 ++
>   5 files changed, 110 insertions(+)
>   create mode 100644 s390x/snippets/c/spec_ex.c
>   create mode 100644 s390x/spec_ex-sie.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 07af26d..b1b6536 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -24,6 +24,7 @@ tests += $(TEST_DIR)/mvpg.elf
>   tests += $(TEST_DIR)/uv-host.elf
>   tests += $(TEST_DIR)/edat.elf
>   tests += $(TEST_DIR)/mvpg-sie.elf
> +tests += $(TEST_DIR)/spec_ex-sie.elf
>   
>   tests_binary = $(patsubst %.elf,%.bin,$(tests))
>   ifneq ($(HOST_KEY_DOCUMENT),)
> @@ -84,6 +85,7 @@ snippet_asmlib = $(SNIPPET_DIR)/c/cstart.o
>   # perquisites (=guests) for the snippet hosts.
>   # $(TEST_DIR)/<snippet-host>.elf: snippets = $(SNIPPET_DIR)/<c/asm>/<snippet>.gbin
>   $(TEST_DIR)/mvpg-sie.elf: snippets = $(SNIPPET_DIR)/c/mvpg-snippet.gbin
> +$(TEST_DIR)/spec_ex-sie.elf: snippets = $(SNIPPET_DIR)/c/spec_ex.gbin
>   
>   $(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o $(FLATLIBS)
>   	$(OBJCOPY) -O binary $(patsubst %.gbin,%.o,$@) $@
> diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
> index 6ba858a..a3b8623 100644
> --- a/lib/s390x/sie.h
> +++ b/lib/s390x/sie.h
> @@ -98,6 +98,7 @@ struct kvm_s390_sie_block {
>   	uint8_t		fpf;			/* 0x0060 */
>   #define ECB_GS		0x40
>   #define ECB_TE		0x10
> +#define ECB_SPECI	0x08
>   #define ECB_SRSI	0x04
>   #define ECB_HOSTPROTINT	0x02
>   	uint8_t		ecb;			/* 0x0061 */
> diff --git a/s390x/snippets/c/spec_ex.c b/s390x/snippets/c/spec_ex.c
> new file mode 100644
> index 0000000..f2daab5
> --- /dev/null
> +++ b/s390x/snippets/c/spec_ex.c

Please add a short header comment with the basic idea here + license 
information (e.g. SPDX identifier). Also in the other new file that you 
introduce in this patch.

> @@ -0,0 +1,13 @@
> +#include <stdint.h>
> +#include <asm/arch_def.h>
> +
> +__attribute__((section(".text"))) int main(void)
> +{
> +	uint64_t bad_psw = 0;
> +	struct psw *pgm_new = (struct psw *)464;

Is it possible to use the lib/s390x/asm/arch_def.h in snippets? If so, I'd 
vote for using &lowcore->pgm_new_psw instead of the magic number 464.

> +	pgm_new->mask = 1UL << (63 - 12); //invalid program new PSW

Please add a space after the //
(also in the other spots in this patch)

> +	pgm_new->addr = 0xdeadbeef;

Are we testing the mask or the addr here? If we're testing the mask, I'd 
rather use an even addr here to make sure that we do not trap because of the 
uneven address. Or do we just don't care?

> +	asm volatile ("lpsw %0" :: "Q"(bad_psw));
> +	return 0;
> +}

  Thomas

