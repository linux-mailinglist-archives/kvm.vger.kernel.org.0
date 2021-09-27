Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8165E4197DF
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 17:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235156AbhI0P2p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 11:28:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53544 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235117AbhI0P2o (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Sep 2021 11:28:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632756426;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L4NMWxT3cfbxRVFFnxXJnEGfN7af8pHyx3dvW9V5X/8=;
        b=CVO93axk6jGKao0jiibQ2IoKWD1InQ2fNYM3AU3gI0bxj+awrsZ1Bf4fVSDcQK93eWNJgL
        uoI93eWzsz1VTXCYQvYx2Z9NRTyu4NM+uPjUldDU+ayjKzQEpihaHz2cN/Ko44KYtbzVuX
        bxmGzXGYIxQW/6l7T1e9TYcHIP6DGt4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-h9cdnwg7NFedRsfU08Wyfw-1; Mon, 27 Sep 2021 11:27:00 -0400
X-MC-Unique: h9cdnwg7NFedRsfU08Wyfw-1
Received: by mail-wr1-f72.google.com with SMTP id r7-20020a5d6947000000b0015e0f68a63bso14233281wrw.22
        for <kvm@vger.kernel.org>; Mon, 27 Sep 2021 08:27:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L4NMWxT3cfbxRVFFnxXJnEGfN7af8pHyx3dvW9V5X/8=;
        b=XX3axoLwLp7KMSogzqAI7Pa5dJOEIQm0m8U5SS7PWXUBco8kRZGxSfcyVOtfEszS1x
         LFRVIXYK6WPyv1SWKWE9XT5UVOeb9KeLpxVsTDPV82h4G760B7rYMp7WoSq/7Pc+UUKY
         i0i5mKeG/tnY7KbVLuxC0c+rjI4Ehr9xIYISOkBPBFN7L0Z8MY3HqLG4iNlxGbF3WquQ
         EET9DVkvy+T5Hx7O0zyXe44jD9KRztbF8ur2WgU+AHzN8Nz1fpJNfjeLGc5EEe/mvBGU
         ArZVUGM9Un8PI5PKOWd32mDODE5xux8raLA/kePYhfT+S4rj5HadSuUaXi3J9ncf6m7U
         uNAw==
X-Gm-Message-State: AOAM530o8BBZKHke+yH+iUDTx0Kl4GmMyyH8xd5x/JQRlW6vWdTkMr1O
        GyfOUCl+RLCEvMAcTshlUVh/XJnlDWPeOru1RSGWiLbVPa+hrBRMg9RSoU9+NcXP8pbDANPX88t
        IPR+kpxOqLLs4
X-Received: by 2002:a05:600c:220e:: with SMTP id z14mr531314wml.84.1632756419167;
        Mon, 27 Sep 2021 08:26:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJynSE4/E24J38JDzGwXrRxW5fcEgu/rr7EQCWyK0XK829+8JlB1tXqSvVH1kA6JoNxSkjvbdQ==
X-Received: by 2002:a05:600c:220e:: with SMTP id z14mr531292wml.84.1632756419001;
        Mon, 27 Sep 2021 08:26:59 -0700 (PDT)
Received: from thuth.remote.csb (p549bb2bd.dip0.t-ipconnect.de. [84.155.178.189])
        by smtp.gmail.com with ESMTPSA id c9sm15606090wmb.41.2021.09.27.08.26.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 08:26:58 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 3/9] s390x: uv-host: Fence a destroy cpu
 test on z15
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, linux-s390@vger.kernel.org, seiden@linux.ibm.com,
        imbrenda@linux.ibm.com
References: <20210922071811.1913-1-frankja@linux.ibm.com>
 <20210922071811.1913-4-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <8035a911-4a76-50ed-cb07-edce48abdb9c@redhat.com>
Date:   Mon, 27 Sep 2021 17:26:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210922071811.1913-4-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/09/2021 09.18, Janosch Frank wrote:
> Firmware will not give us the expected return code on z15 so let's
> fence it for the z15 machine generation.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   lib/s390x/asm/arch_def.h | 14 ++++++++++++++
>   s390x/uv-host.c          | 11 +++++++----
>   2 files changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index aa80d840..c8d2722a 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -219,6 +219,20 @@ static inline unsigned short stap(void)
>   	return cpu_address;
>   }
>   
> +#define MACHINE_Z15A	0x8561
> +#define MACHINE_Z15B	0x8562
> +
> +static inline uint16_t get_machine_id(void)
> +{
> +	uint64_t cpuid;
> +
> +	asm volatile("stidp %0" : "=Q" (cpuid));
> +	cpuid = cpuid >> 16;
> +	cpuid &= 0xffff;
> +
> +	return cpuid;
> +}
> +
>   static inline int tprot(unsigned long addr)
>   {
>   	int cc;
> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
> index 66a11160..5e351120 100644
> --- a/s390x/uv-host.c
> +++ b/s390x/uv-host.c
> @@ -111,6 +111,7 @@ static void test_config_destroy(void)
>   static void test_cpu_destroy(void)
>   {
>   	int rc;
> +	uint16_t machineid = get_machine_id();
>   	struct uv_cb_nodata uvcb = {
>   		.header.len = sizeof(uvcb),
>   		.header.cmd = UVC_CMD_DESTROY_SEC_CPU,
> @@ -125,10 +126,12 @@ static void test_cpu_destroy(void)
>   	       "hdr invalid length");
>   	uvcb.header.len += 8;
>   
> -	uvcb.handle += 1;
> -	rc = uv_call(0, (uint64_t)&uvcb);
> -	report(rc == 1 && uvcb.header.rc == UVC_RC_INV_CHANDLE, "invalid handle");
> -	uvcb.handle -= 1;
> +	if (machineid != MACHINE_Z15A && machineid != MACHINE_Z15B) {
> +		uvcb.handle += 1;
> +		rc = uv_call(0, (uint64_t)&uvcb);
> +		report(rc == 1 && uvcb.header.rc == UVC_RC_INV_CHANDLE, "invalid handle");
> +		uvcb.handle -= 1;
> +	}

So this is a bug in the firmware? Any chance that it will still get fixed 
for the z15? If so, would it make sense to turn this into a report_xfail() 
instead?

  Thomas

