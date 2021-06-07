Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF0E739D927
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 11:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbhFGJ5m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 05:57:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30796 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230127AbhFGJ5l (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Jun 2021 05:57:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623059750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wkHX6pObXanNlJ8UdRQUA8q1lmcsT7SZQ8EkbY0Tba0=;
        b=YCOEEjgaGN2f9pMCYnCsmRdUFmWlMiUeD0M3peB6LVH3UwpvdG0sm2lGRQ6JxpUBo6xddi
        W5lAug4CrLT0m0XfKMAk1zONwxrji56PgsxWjFuXvn0zjMfwlziMPz2l0i6/g6r7fiYT0e
        1Td4jOJ4TEKv4Gm2KTS1HB6rFex4NRg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-uwc-JVpMMo6WCEhKIS_KWA-1; Mon, 07 Jun 2021 05:55:49 -0400
X-MC-Unique: uwc-JVpMMo6WCEhKIS_KWA-1
Received: by mail-wr1-f70.google.com with SMTP id x9-20020a5d49090000b0290118d8746e06so7650594wrq.10
        for <kvm@vger.kernel.org>; Mon, 07 Jun 2021 02:55:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=wkHX6pObXanNlJ8UdRQUA8q1lmcsT7SZQ8EkbY0Tba0=;
        b=gMXqDMTrGO3Y9BPa6vHwvkv8POYivOHV9t3pRv+HEhJRbA12kAa8ppXRgZCpI7ydNt
         +csjzjMeacHciPhG2vVCiirIyCEn7/fzXKWdzH+GJQoMZyerwb3bqcogAVgnWbtkfjlZ
         eimYhTwC5fPyclTcIe5vV6F5hx9Tsj2g30J6Hg28SPU5/61QNa4Iadx3ISpBql4KVyt4
         BonOON7nMBk2cK/LthL4KZFxqTsZGx+STWEJmPRn0jhHJm2BIZ7jVj+InARFI3VFY8BA
         M3e4yTkfdO3tUsklCxon42Cnm9CV2mncQkSw6RvEDGbEDBiBq0WI2Yg9WT0nXv3Dkhxu
         Z3MQ==
X-Gm-Message-State: AOAM533YsSJSbTHMQ3v1ZnFI9vr7NMC+78T1WKvDAgoLBn0bWzUlStUF
        wA4VCMT/URjjLCBKKu6wqHpgAsmQVkaJYeSjjDl2PfzjAQz1y5iN3SW0RVA/iRgTthwdmKyjbZF
        DyeEjvrfzxsws
X-Received: by 2002:a05:6000:50d:: with SMTP id a13mr15852517wrf.130.1623059748303;
        Mon, 07 Jun 2021 02:55:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw6moH5xg7FDfTLpCOtRTgo0mbOP7tmH+soh2teAVItLpQbTOitZXCEX1x8kJ7qbpgUAaIEQQ==
X-Received: by 2002:a05:6000:50d:: with SMTP id a13mr15852503wrf.130.1623059748102;
        Mon, 07 Jun 2021 02:55:48 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6188.dip0.t-ipconnect.de. [91.12.97.136])
        by smtp.gmail.com with ESMTPSA id l31sm2247988wms.31.2021.06.07.02.55.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jun 2021 02:55:47 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 1/3] s390x: Don't run PV testcases under
 tcg
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20210318125015.45502-1-frankja@linux.ibm.com>
 <20210318125015.45502-2-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <10456eb5-b473-7eea-3fb7-1da08e5a9ce8@redhat.com>
Date:   Mon, 7 Jun 2021 11:55:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210318125015.45502-2-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18.03.21 13:50, Janosch Frank wrote:
> The UV call facility is only available on hardware.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   scripts/s390x/func.bash | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/scripts/s390x/func.bash b/scripts/s390x/func.bash
> index b3912081..bf799a56 100644
> --- a/scripts/s390x/func.bash
> +++ b/scripts/s390x/func.bash
> @@ -21,6 +21,9 @@ function arch_cmd_s390x()
>   	"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
>   
>   	# run PV test case
> +	if [ "$ACCEL" = 'tcg' ]; then
> +		return
> +	fi
>   	kernel=${kernel%.elf}.pv.bin
>   	testname=${testname}_PV
>   	if [ ! -f "${kernel}" ]; then
> 

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

