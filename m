Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792B33EFDE7
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 09:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239178AbhHRHlD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 03:41:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45980 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239045AbhHRHlB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Aug 2021 03:41:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629272427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LayocC0CiLEAoj+bUdeIdNWvBdq+Y8wlxH81H8i9dIo=;
        b=Ema5pmsGM//uSAnJsdghLtdh/eD9+BABEopDEKdEb04GlrsG++MsMuFTxZbTHEpPGcxOd8
        A2cpoWBiAMi1kbBIZICqT40+lxRxTxyWwnLw7eQJHEWAtE8x72ZQlGWZcZegxFHy4Qi26a
        5LitTObkNZkBGcOkrRAg+BAInUoXpLA=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-aCnFq_e7MOqM4qnAn1FLrg-1; Wed, 18 Aug 2021 03:40:25 -0400
X-MC-Unique: aCnFq_e7MOqM4qnAn1FLrg-1
Received: by mail-ed1-f70.google.com with SMTP id o17-20020aa7d3d1000000b003beaf992d17so589920edr.13
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 00:40:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LayocC0CiLEAoj+bUdeIdNWvBdq+Y8wlxH81H8i9dIo=;
        b=AEJFFUmZJ2ExmSvBGgH76Q+xNKy1v00kFm/ImVaVHDmkj63M+2/iqUz31blCkgYA81
         gHLI/TvfvODTWH72NF6Wzohpd1EeXVTfpmFHg40VqojKkcMI7cXMNG4F2Qi+8KqjjMQ9
         BzMw7Gw5Uj6/4JK0pi521wGh+2VzC+mL//cdNe8xzWFluVE05ZjzMxjCJmfXE0zKCPsD
         JxSoWP7mjrIFnTNO5WBPfdPQAbFbxsu30KSdXLKTNQHsgMs4k6zj+ICSH8NXbk78B5qH
         Y088mRTM6JOKfkot0vQ82l2nMUif09cKNkhqpA+WXqahpeT6Ek7IaenNVc7B9erBf4YQ
         Q/Cg==
X-Gm-Message-State: AOAM532r3Xd3EI6BfVeAdYvU8fk304okZV0Bk5mwV9PpX3MNTlNiBkdo
        LHFrc/8KqwSq+JPO5aR4XMdp3ytnWMr/hJa9XYbB4lHkhFZ//16TI+yFAInOOh7F9ZD6+f3B0G9
        8iq9wqBQTWWvd
X-Received: by 2002:a17:906:2817:: with SMTP id r23mr8252881ejc.285.1629272424332;
        Wed, 18 Aug 2021 00:40:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy1d4Deq3fHMtKFHMm82ypcInyEW7LdEPY4KhLe4VS8YLB1ouLtJ1yldbS6F6bmlbRw5YqZUg==
X-Received: by 2002:a17:906:2817:: with SMTP id r23mr8252874ejc.285.1629272424142;
        Wed, 18 Aug 2021 00:40:24 -0700 (PDT)
Received: from thuth.remote.csb (pd9e83070.dip0.t-ipconnect.de. [217.232.48.112])
        by smtp.gmail.com with ESMTPSA id r16sm1629802ejz.41.2021.08.18.00.40.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 00:40:23 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 1/1] s390x: css: check the CSS is working
 with any ISC
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1628769189-10699-1-git-send-email-pmorel@linux.ibm.com>
 <1628769189-10699-2-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <b9191517-a20b-f5e4-0e78-a819512ee328@redhat.com>
Date:   Wed, 18 Aug 2021 09:40:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1628769189-10699-2-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/08/2021 13.53, Pierre Morel wrote:
> In the previous version we did only check that one ISC dedicated by
> Linux for I/O is working fine.
> 
> However, there is no reason to prefer one ISC to another ISC, we are
> free to take anyone.
> 
> Let's check all possible ISC to verify that QEMU/KVM is really ISC
> independent.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   s390x/css.c | 25 +++++++++++++++++--------
>   1 file changed, 17 insertions(+), 8 deletions(-)
> 
> diff --git a/s390x/css.c b/s390x/css.c
> index c340c539..aa005309 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -22,6 +22,7 @@
>   
>   #define DEFAULT_CU_TYPE		0x3832 /* virtio-ccw */
>   static unsigned long cu_type = DEFAULT_CU_TYPE;
> +static int io_isc;
>   
>   static int test_device_sid;
>   static struct senseid *senseid;
> @@ -46,7 +47,7 @@ static void test_enable(void)
>   		return;
>   	}
>   
> -	cc = css_enable(test_device_sid, IO_SCH_ISC);
> +	cc = css_enable(test_device_sid, io_isc);
>   
>   	report(cc == 0, "Enable subchannel %08x", test_device_sid);
>   }
> @@ -67,7 +68,7 @@ static void test_sense(void)
>   		return;
>   	}
>   
> -	ret = css_enable(test_device_sid, IO_SCH_ISC);
> +	ret = css_enable(test_device_sid, io_isc);
>   	if (ret) {
>   		report(0, "Could not enable the subchannel: %08x",
>   		       test_device_sid);
> @@ -142,7 +143,6 @@ static void sense_id(void)
>   
>   static void css_init(void)
>   {
> -	assert(register_io_int_func(css_irq_io) == 0);
>   	lowcore_ptr->io_int_param = 0;
>   
>   	report(get_chsc_scsc(), "Store Channel Characteristics");
> @@ -351,11 +351,20 @@ int main(int argc, char *argv[])
>   	int i;
>   
>   	report_prefix_push("Channel Subsystem");
> -	enable_io_isc(0x80 >> IO_SCH_ISC);
> -	for (i = 0; tests[i].name; i++) {
> -		report_prefix_push(tests[i].name);
> -		tests[i].func();
> -		report_prefix_pop();
> +
> +	for (io_isc = 0; io_isc < 8; io_isc++) {
> +		report_info("ISC: %d\n", io_isc);

Would it make sense to add the "ISC" string as a prefix with 
report_prefix_push() instead, so that the tests get individual test names?

  Thomas


> +		enable_io_isc(0x80 >> io_isc);
> +		assert(register_io_int_func(css_irq_io) == 0);
> +
> +		for (i = 0; tests[i].name; i++) {
> +			report_prefix_push(tests[i].name);
> +			tests[i].func();
> +			report_prefix_pop();
> +		}
> +
> +		unregister_io_int_func(css_irq_io);
>   	}
>   	report_prefix_pop();
>   
> 

