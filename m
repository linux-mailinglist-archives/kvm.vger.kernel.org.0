Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F45C49B48E
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 14:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1575209AbiAYNCm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 08:02:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:39034 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1574850AbiAYNAM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Jan 2022 08:00:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643115610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QhLcThaEu0PlskFzQFT7M5fP0clt93A0xhvHp5D289k=;
        b=X4IZW3kD9Ij1j5Jv8DBYOgFyA1IF1zKl6Ei3/smoQkCZF4zXctwtnJ6fIQi8T4RDN7UmdG
        NIvGQvRjofnvU4nfLSoU5BowLqn8gTIFFLEe5CLGjm/p7rkRo+ObCHO0ClVWQ958Ah067t
        nScQZ21rgA0b7Ld5IwUBCExHKTGbnCA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-647-tiAqr1A8N3KeLe_9gOt25Q-1; Tue, 25 Jan 2022 08:00:09 -0500
X-MC-Unique: tiAqr1A8N3KeLe_9gOt25Q-1
Received: by mail-wr1-f71.google.com with SMTP id x4-20020adfbb44000000b001d83e815683so3009237wrg.8
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 05:00:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QhLcThaEu0PlskFzQFT7M5fP0clt93A0xhvHp5D289k=;
        b=EcC6AYzg3fnKvTrQS9BdvXlIB2xmgOdaCgFE/ExnHK94VPlcmRrYzA4mSu6KIHhqPU
         Md9NwMze49jR3iJMoPxZEO0R/KpUQjGYe9h/rwRe1qyW3Su0ohWuy6075bWpLvPxw7+t
         kW7+fl/QA+sgIXajrvwgrzEsAqwFWyHT0ar3SnDvIwpnI6Du5URvSrIYm/9op1QXB/PT
         oLTx8HXNsdszqAvXB4HU/hZmFc2ECvlRUJi9Xlkc7XSCty2LDOETtHldZSXIT0O4LTum
         PkKcaJYM1OxoZXgR4O+ukDSYIonw5tg3EP5SgpA+lBKxs4ukd9hjH1Q5xcf+fUpiRuLx
         mfJQ==
X-Gm-Message-State: AOAM531h5fQXS4U8vdQHERzm+/HPghriRCdgZA1vPU7ikyVvJMnLHuGS
        zKwsWe8XdnVqWveSMa20NFakaoSQd0shzCKeTNf6tU0rIqNNSqGfTaWiKpGl4RP70DwoKA56lbO
        mXBZrB+/cFZVC
X-Received: by 2002:adf:d1ed:: with SMTP id g13mr3352960wrd.495.1643115608016;
        Tue, 25 Jan 2022 05:00:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx5h9igq4e4apmtvdHXBXtAlwPbOJYJVq3Fp0yhdWOnYTW62PA01UrRJZkdZJcOoleBxG6oIg==
X-Received: by 2002:adf:d1ed:: with SMTP id g13mr3352938wrd.495.1643115607776;
        Tue, 25 Jan 2022 05:00:07 -0800 (PST)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id b2sm9779406wrd.64.2022.01.25.05.00.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 05:00:07 -0800 (PST)
Message-ID: <07910e67-a506-424c-f851-d1f279e3b8df@redhat.com>
Date:   Tue, 25 Jan 2022 14:00:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH kvm-unit-tests v1 2/8] s390x: Add test for PFMF
 low-address protection
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, david@redhat.com
References: <20220121150931.371720-1-nrb@linux.ibm.com>
 <20220121150931.371720-3-nrb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220121150931.371720-3-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/01/2022 16.09, Nico Boehr wrote:
> PFMF should respect the low-address protection when clearing pages, hence
> add some tests for it.
> 
> When low-address protection fails, clearing frame 0 is a destructive
> operation. It messes up interrupts and thus printing test results won't
> work properly. Hence, we first attempt to clear frame 1 which is not as
> destructive.
> 
> Doing it this way around increases the chances for the user to see a
> proper failure message instead of QEMU randomly quitting in the middle
> of the test run.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   s390x/pfmf.c | 29 +++++++++++++++++++++++++++++
>   1 file changed, 29 insertions(+)
> 
> diff --git a/s390x/pfmf.c b/s390x/pfmf.c
> index 2f3cb110dc4c..aa1305292ee8 100644
> --- a/s390x/pfmf.c
> +++ b/s390x/pfmf.c
> @@ -113,6 +113,34 @@ static void test_1m_clear(void)
>   	report_prefix_pop();
>   }
>   
> +static void test_low_addr_prot(void)
> +{
> +	union pfmf_r1 r1 = {
> +		.reg.cf = 1,
> +		.reg.fsc = PFMF_FSC_4K
> +	};
> +
> +	report_prefix_push("low-address protection");
> +
> +	report_prefix_push("0x1000");
> +	expect_pgm_int();
> +	low_prot_enable();
> +	pfmf(r1.val, (void *)0x1000);
> +	low_prot_disable();
> +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
> +	report_prefix_pop();
> +
> +	report_prefix_push("0x0");
> +	expect_pgm_int();
> +	low_prot_enable();
> +	pfmf(r1.val, 0);
> +	low_prot_disable();
> +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
> +	report_prefix_pop();
> +
> +	report_prefix_pop();
> +}
> +
>   int main(void)
>   {
>   	bool has_edat = test_facility(8);
> @@ -124,6 +152,7 @@ int main(void)
>   	}
>   
>   	test_priv();
> +	test_low_addr_prot();
>   	/* Force the buffer pages in */
>   	memset(pagebuf, 0, PAGE_SIZE * 256);
>   

Reviewed-by: Thomas Huth <thuth@redhat.com>

