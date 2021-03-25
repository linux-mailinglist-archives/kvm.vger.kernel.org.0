Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E58CB34994B
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 19:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbhCYSPO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 14:15:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49517 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230137AbhCYSOq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 14:14:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616696085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kp7rjFqvtgvZ1JZJ3yQQpORrWHnOdoM9w1+Fw1e9j38=;
        b=ZvFo+DtrHosJDPIBF0KAK+3Eweqf2WPAIgY5NkNGBOpFohOyt2wa9ayzN6WDU8yS++7uIl
        YDacns/BAmzeN+3YOCctu+2XisAz3z9xrNO18Ja1nIP3QuPEOIbtY3cgdPIWXSdXo4fUFb
        ZwKmGJO5IBR5AEKyVeZNrBUAWYiPins=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-572-utzkegUrN7qyeTyYfoBf9w-1; Thu, 25 Mar 2021 14:14:43 -0400
X-MC-Unique: utzkegUrN7qyeTyYfoBf9w-1
Received: by mail-wm1-f72.google.com with SMTP id a65so144384wmh.1
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 11:14:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kp7rjFqvtgvZ1JZJ3yQQpORrWHnOdoM9w1+Fw1e9j38=;
        b=JB1xMj4JG8vxXmaZn5pqQVc9n6dokLuxUh+18UEPgIciN7wU0RmEltrU1oSrm4jRxN
         OIErPi2sEUGTR6YeF4QIfeuklTsfGf6cPRy5EFiPSI4yzjivGya7p/sBfqUqmj4lkl7i
         wySqoPvlyMn8RaHdumpMsOYlc0P7jxwCUjbtTUiOs4U2XmVHGnSYIgHErcD5mYalThZr
         VmkfkQatkc/H/Vxxotu7+FfP3RtaPI72cJerYmqgJve3CZ/D79EZxPxIOh0QVf7De2eE
         Pa76i6Nk66rEiS/Y2yq7V87Rb8fjpK39bLs3/RjcfSz5f1uZbhV5pohwE4V0TtJ06UTP
         F8hA==
X-Gm-Message-State: AOAM530AQLzrzCebMBZdiES7xhdkueZ2evddv1RPegNn+6FvYncBWQxV
        Uhd5ISlfucMGILLvU9p6cJwNRY+aStjU19v8gPEmWmJ7oc2mDt5SNUkMLOc/MUGj/WmVOChk3tr
        m0dSyhaJ3TzCa
X-Received: by 2002:a05:600c:20d3:: with SMTP id y19mr9498989wmm.146.1616696081947;
        Thu, 25 Mar 2021 11:14:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw+Zepq9Kx6C1wgPXIWc5XVPRRTInJ/jGya9YD1si2qS6bgSzqEzSGcC72NbXhEw/cVHoKUDg==
X-Received: by 2002:a05:600c:20d3:: with SMTP id y19mr9498980wmm.146.1616696081744;
        Thu, 25 Mar 2021 11:14:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f16sm8330024wrt.21.2021.03.25.11.14.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 11:14:41 -0700 (PDT)
Subject: Re: [PATCH] tools/kvm_stat: Add restart delay
To:     Stefan Raspl <raspl@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com
References: <20210325122949.1433271-1-raspl@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3016e5de-081e-2eea-9513-08c90193d840@redhat.com>
Date:   Thu, 25 Mar 2021 19:14:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210325122949.1433271-1-raspl@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/03/21 13:29, Stefan Raspl wrote:
> If this service is enabled and the system rebooted, Systemd's initial
> attempt to start this unit file may fail in case the kvm module is not
> loaded. Since we did not specify a delay for the retries, Systemd
> restarts with a minimum delay a number of times before giving up and
> disabling the service. Which means a subsequent kvm module load will
> have kvm running without monitoring.
> Adding a delay to fix this.
> 
> Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
> ---
>   tools/kvm/kvm_stat/kvm_stat.service | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/tools/kvm/kvm_stat/kvm_stat.service b/tools/kvm/kvm_stat/kvm_stat.service
> index 71aabaffe779..8f13b843d5b4 100644
> --- a/tools/kvm/kvm_stat/kvm_stat.service
> +++ b/tools/kvm/kvm_stat/kvm_stat.service
> @@ -9,6 +9,7 @@ Type=simple
>   ExecStart=/usr/bin/kvm_stat -dtcz -s 10 -L /var/log/kvm_stat.csv
>   ExecReload=/bin/kill -HUP $MAINPID
>   Restart=always
> +RestartSec=60s
>   SyslogIdentifier=kvm_stat
>   SyslogLevel=debug
>   
> 

Queued, thanks.

Paolo

