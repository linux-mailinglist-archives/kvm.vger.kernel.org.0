Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD5DC3E23F6
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 09:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243592AbhHFH0d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 03:26:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43462 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243213AbhHFH0d (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Aug 2021 03:26:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628234777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZmCWNcZsQzuYzmlOhaB93+dvV+Gy0mN6pPvnW6rjRRc=;
        b=QRIdpqQCnsiCFJbHdc0KEZXxCOSrBsKv+zd01d1+jir8Y8AP84nd94fQdhh+pxYVkHpeO7
        GJjnoxBBjrhkV8cH5eFF1Fd+mxQPfpgHL7tbGzlWznc+qlHGIa+ks7upJzOsov5lceI1A1
        tyq4uLPTtmNHGfUdndMhVtd87ig9SoQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-7soq9xjJNeunDdN-b2lKAw-1; Fri, 06 Aug 2021 03:26:14 -0400
X-MC-Unique: 7soq9xjJNeunDdN-b2lKAw-1
Received: by mail-wm1-f71.google.com with SMTP id c2-20020a7bc8420000b0290238db573ab7so3569710wml.5
        for <kvm@vger.kernel.org>; Fri, 06 Aug 2021 00:26:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ZmCWNcZsQzuYzmlOhaB93+dvV+Gy0mN6pPvnW6rjRRc=;
        b=bjW9cTCes1AMymPdCmJt2l9bwcZexydfSzGVY/jC/ZiC5z6crO/FXp/WkRwn/2ElDo
         MGAYT9ZR0iqxEWaFQcAOOq6HxLAUIopjCTDMX/yzO1WVPDHjO5M71PcQmzzrT4MdMQj5
         E+aTsjrf8xiXXa8MoLtrh0uvUVw8MePhVfTPHDmVYD3lZPZcPjJHzjMBdVMvxpUoFLZz
         fU4/mKeL3Rthe5FZc0k93LZjBIZRpuGKHihKEG82oLhGfVziyp9HewEP4fs2V0J58ztu
         M6R3CLkutBRjkwK4eYBCv4fYt9gxFGryLzPiAqTBsl6xn4s0A3AtiShZKWz7EviFUYTO
         7LpQ==
X-Gm-Message-State: AOAM532JUF9vBDHCwK/SBRilO3WYmigI4+hMZOhid2oJJ6D6Dt1qXiPB
        xJfp/B+BeeQn4Ve+cvjrIK5+iaq5zYczQbhD9zbdIRBusF/GyioY2pTW9hVgFldxdJKxrioust+
        ln5MLkfk2X8v0
X-Received: by 2002:a7b:c441:: with SMTP id l1mr1794913wmi.69.1628234772926;
        Fri, 06 Aug 2021 00:26:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw1R6/lybPHP6E+xmkyFOI9O0T7/CYEHmOzYi+aT4Ky2+3mi2P/oDOj576zRfFwUsq2Vc8hog==
X-Received: by 2002:a7b:c441:: with SMTP id l1mr1794892wmi.69.1628234772720;
        Fri, 06 Aug 2021 00:26:12 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6104.dip0.t-ipconnect.de. [91.12.97.4])
        by smtp.gmail.com with ESMTPSA id l5sm9908011wrc.90.2021.08.06.00.26.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Aug 2021 00:26:12 -0700 (PDT)
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ulrich.Weigand@de.ibm.com
References: <20210804154046.88552-1-imbrenda@linux.ibm.com>
 <20210804154046.88552-2-imbrenda@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v3 01/14] KVM: s390: pv: add macros for UVC CC values
Message-ID: <f3fc81a7-ea71-56f6-16e0-e43fc36d646e@redhat.com>
Date:   Fri, 6 Aug 2021 09:26:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210804154046.88552-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.08.21 17:40, Claudio Imbrenda wrote:
> Add macros to describe the 4 possible CC values returned by the UVC
> instruction.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   arch/s390/include/asm/uv.h | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index 12c5f006c136..b35add51b967 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -18,6 +18,11 @@
>   #include <asm/page.h>
>   #include <asm/gmap.h>
>   
> +#define UVC_CC_OK	0
> +#define UVC_CC_ERROR	1
> +#define UVC_CC_BUSY 	2
> +#define UVC_CC_PARTIAL	3
> +
>   #define UVC_RC_EXECUTED		0x0001
>   #define UVC_RC_INV_CMD		0x0002
>   #define UVC_RC_INV_STATE	0x0003
> 

Do we have any users we could directly fix up? AFAIKs, most users don't 
really care about the cc value, only about cc vs !cc.

The only instances I was able to spot quickly:


diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 12c5f006c136..dd72d325f9e8 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -233,7 +233,7 @@ static inline int uv_call(unsigned long r1, unsigned 
long r2)

         do {
                 cc = __uv_call(r1, r2);
-       } while (cc > 1);
+       } while (cc >= UVC_CC_BUSY);
         return cc;
  }

@@ -245,7 +245,7 @@ static inline int uv_call_sched(unsigned long r1, 
unsigned long r2)
         do {
                 cc = __uv_call(r1, r2);
                 cond_resched();
-       } while (cc > 1);
+       } while (cc >= UVC_CC_BUSY);
         return cc;
  }


Of course, we could replace all checks for cc vs !cc with "cc != 
UVC_CC_OK" vs "cc == UVC_CC_OK".

-- 
Thanks,

David / dhildenb

