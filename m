Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5608449B36E
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 13:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387200AbiAYL5c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 06:57:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36133 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1387408AbiAYLyZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Jan 2022 06:54:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643111663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OVruUK15QVwyvN+qAZUe6bEpmNWFxdquQkfG12amLdM=;
        b=A4QxpMTUL4BkJ9pGn8iWmq4God59xpBAt3bnkxXg/3S1apQFFBb3d768WmweasVCq+4DHu
        4E6NWBeHzoMCufneo3irhrGptfO8aNbtKMepWbCZ8jT4lR4U+Sw01e8uO/2CUL2v59ZE3k
        sbzmq+JqaLfqPQJiX7J7sU3qPGxX2gw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-546-k1ZL-VZsMa6VKkcrDoSajg-1; Tue, 25 Jan 2022 06:54:21 -0500
X-MC-Unique: k1ZL-VZsMa6VKkcrDoSajg-1
Received: by mail-wr1-f70.google.com with SMTP id i16-20020adfa510000000b001d7f57750a6so2928170wrb.0
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 03:54:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OVruUK15QVwyvN+qAZUe6bEpmNWFxdquQkfG12amLdM=;
        b=XPh/9Wv/RTie/0eQMUfD3tc3obvvfI7sUPCgirOznfJHzTV7trBaOQcUaLEtv2RGAB
         lu3ezk6flf8jZdC/QLI8Mol/5hVzLW4VgPh62kq+9IIdPTHMsj5WG/7VptgRHhN+Btu2
         EbGvrBDsAXcJchhUW9e5jQS9OKiDhn6bu5CmLmY7cfbixJgxYKlbhlotv2YkA4oFnmqP
         z7Mjih/XPyFkMVG0cMfThdKoBBRIXBP5ldNlgqLrPQUkA1KHC/SqEjmN+VySR0RiP7aW
         iejRVnIsVQ0uS+0aezmukl56O4+XyYdVNCEX+CG8GeLu9aFwYjC3hf3AO4sxT+LObQXi
         fc8g==
X-Gm-Message-State: AOAM532lhP4JPy4uMz52AHkyJ5fD4ZUmj/Ks/MyMVv50BQaVtuRjhD7p
        Lu/nCWB8VjDqid2Neb7Cs2E+j3ZMsX2oTwjX73ZPM1TU/31pqlAIvMN2GN2wgwgwTfed6ZFscuX
        2uJrjw+kV8y7c
X-Received: by 2002:a5d:55c6:: with SMTP id i6mr15096115wrw.641.1643111660388;
        Tue, 25 Jan 2022 03:54:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxE4cK6Od2JFP896yUNMWk7bxnNlD7rPAw3eXZxYAORjKcWqG3h49APmrFEhxBd7YCgpHQkdQ==
X-Received: by 2002:a5d:55c6:: with SMTP id i6mr15096103wrw.641.1643111660162;
        Tue, 25 Jan 2022 03:54:20 -0800 (PST)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id h127sm146471wmh.27.2022.01.25.03.54.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 03:54:19 -0800 (PST)
Message-ID: <aa2f0f15-56d3-5009-1741-5d3664286c46@redhat.com>
Date:   Tue, 25 Jan 2022 12:54:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH kvm-unit-tests v1 1/8] s390x: Add more tests for MSCH
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, david@redhat.com
References: <20220121150931.371720-1-nrb@linux.ibm.com>
 <20220121150931.371720-2-nrb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220121150931.371720-2-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/01/2022 16.09, Nico Boehr wrote:
> We already have some coverage for MSCH, but there are more cases to test
> for:
> 
> - invalid SCHIB structure. We cover that by setting reserved bits 0, 1,
>    6 and 7 in the flags of the PMCW.
>    This test currently fails because of a QEMU bug, a fix
>    is available (see "[PATCH qemu] s390x/css: fix PMCW invalid mask")
> - a pointer to an unaligned SCHIB. We cover misalignment by 1
>    and 2 bytes. Using pointer to valid memory avoids messing up
>    random memory in case of test failures.
> 
> Here's the QEMU PMCW invalid mask fix: https://lists.nongnu.org/archive/html/qemu-s390x/2021-12/msg00100.html
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   s390x/css.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 51 insertions(+)
> 
> diff --git a/s390x/css.c b/s390x/css.c
> index 881206ba1cef..afe1f71bb576 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -27,6 +27,8 @@ static int test_device_sid;
>   static struct senseid *senseid;
>   struct ccw1 *ccw;
>   
> +char alignment_test_page[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));

Alternatively, you could also use alloc_page() in that new function... not 
sure what's nicer, though.

>   static void test_enumerate(void)
>   {
>   	test_device_sid = css_enumerate();
> @@ -331,6 +333,54 @@ static void test_schm_fmt1(void)
>   	free_io_mem(mb1, sizeof(struct measurement_block_format1));
>   }
>   
> +static void test_msch(void)
> +{
> +	const int align_to = 4;
> +	int cc;
> +	int invalid_pmcw_flags[] = {0, 1, 6, 7};
> +	int invalid_flag;
> +	uint16_t old_pmcw_flags;
> +
> +	if (!test_device_sid) {
> +		report_skip("No device");
> +		return;
> +	}
> +
> +	cc = stsch(test_device_sid, &schib);
> +	if (cc) {
> +		report_fail("stsch: sch %08x failed with cc=%d", test_device_sid, cc);
> +		return;
> +	}
> +
> +	report_prefix_push("Unaligned");
> +	for (int i = 1; i < align_to; i *= 2) {
> +		report_prefix_pushf("%d", i);
> +
> +		expect_pgm_int();
> +		msch(test_device_sid, (struct schib *)(alignment_test_page + i));
> +		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +
> +		report_prefix_pop();
> +	}
> +	report_prefix_pop();
> +
> +	report_prefix_push("Invalid SCHIB");
> +	old_pmcw_flags = schib.pmcw.flags;
> +	for (int i = 0; i < ARRAY_SIZE(invalid_pmcw_flags); i++) {
> +		invalid_flag = invalid_pmcw_flags[i];
> +
> +		report_prefix_pushf("PMCW flag bit %d set", invalid_flag);
> +
> +		schib.pmcw.flags = old_pmcw_flags | BIT(15 - invalid_flag);
> +		expect_pgm_int();
> +		msch(test_device_sid, &schib);
> +		check_pgm_int_code(PGM_INT_CODE_OPERAND);
> +
> +		report_prefix_pop();
> +	}

Maybe restore schib.pmcw.flags = old_pmcw_flags at the end, in case someone 
wants to add more tests later?

> +	report_prefix_pop();
> +}
> +
>   static struct {
>   	const char *name;
>   	void (*func)(void);
> @@ -343,6 +393,7 @@ static struct {
>   	{ "measurement block (schm)", test_schm },
>   	{ "measurement block format0", test_schm_fmt0 },
>   	{ "measurement block format1", test_schm_fmt1 },
> +	{ "msch", test_msch },
>   	{ NULL, NULL }
>   };
>   

Reviewed-by: Thomas Huth <thuth@redhat.com>

