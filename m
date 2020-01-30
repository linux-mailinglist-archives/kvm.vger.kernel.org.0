Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B62314E628
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 00:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbgA3XsA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 18:48:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24556 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726026AbgA3XsA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 18:48:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580428079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BqDe7Cj8FT35afwZ7Z18l1nXaF9b4b2GM42iw9a3gLY=;
        b=VMvd4RHEl0lATGufDXRyAddTSmQAsJWP7KJH+x3qvTo1SyPkhLx2TaukYsQwz3bX99jku7
        saNpYEXvSwqhRLpnydGcWr+dlSr+gkihRpDb40ygS1i5y5bjBN5ex58nkQvVHaVUo2Uguf
        tKT0S9uzXgJEwDJlo7CaW5CDS+UnTS4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-XdWplodWPoeM_LGmFIikrw-1; Thu, 30 Jan 2020 18:47:57 -0500
X-MC-Unique: XdWplodWPoeM_LGmFIikrw-1
Received: by mail-wr1-f70.google.com with SMTP id u18so2426092wrn.11
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2020 15:47:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BqDe7Cj8FT35afwZ7Z18l1nXaF9b4b2GM42iw9a3gLY=;
        b=LgPH+mObL+Mnjiick1mq2cdudrRM8QFffKBuIZEUlaeMrXQflNSUZfV4TO00VZXwa1
         ysQV+gYlAtYGHypziEiwGf3zKVXMhDX57A7QoEd6sO8hh9dQf0BpxLbn68R2n5b+WnOd
         /SIH7+fft60TvpVTT2stxGSUhh1ReHKiVtKAF2UTu57i4HaQ/gO4Fk3rhE8/kAzqE2Ld
         g2Cj+p9bIu5Vv8KyleYukANEF6G93Zyc5CrbvQthLBx7DeoQDOeu4UGX55UMCqwirswf
         DiaXgD6yzWpSw4A5eMQgm7muqIwCnjZ+SjK07ruEVKk6d5TfOx95Z4VHq2AOUggkgXEC
         Q4XQ==
X-Gm-Message-State: APjAAAW6dtdtfNJgF2T102fEd072AXf+vXJ2ZVSPw7dr19ugLakTdkTd
        oSLPdmG1KTBmidexbUVj0IAiLYjLSs7xbYV+s7SpL+UmzJfc34YCscw/IV5uMXC6rqV9No827fa
        rqq+HJ0ai1LK1
X-Received: by 2002:a5d:4285:: with SMTP id k5mr8017115wrq.72.1580428075259;
        Thu, 30 Jan 2020 15:47:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqzgxpjyuUEBwc3eUqIM0ptp5DlvPeawGxcWdCo6pV92vhECbiOddUA/blxEwAA3nvGtdKjSWg==
X-Received: by 2002:a5d:4285:: with SMTP id k5mr8017097wrq.72.1580428075086;
        Thu, 30 Jan 2020 15:47:55 -0800 (PST)
Received: from [192.168.1.35] (113.red-83-57-172.dynamicip.rima-tde.net. [83.57.172.113])
        by smtp.gmail.com with ESMTPSA id a198sm8022382wme.12.2020.01.30.15.47.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jan 2020 15:47:54 -0800 (PST)
Subject: Re: [PATCH v2 07/12] tests/acceptance: Remove shebang header
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <rth@twiddle.net>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Cleber Rosa <crosa@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        qemu-block@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        =?UTF-8?Q?Daniel_P_=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Max Reitz <mreitz@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fam Zheng <fam@euphon.net>, Kevin Wolf <kwolf@redhat.com>,
        kvm@vger.kernel.org
References: <20200130163232.10446-1-philmd@redhat.com>
 <20200130163232.10446-8-philmd@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <29489dc7-6ec0-afcd-a26f-1f8eeafe7b7a@redhat.com>
Date:   Fri, 31 Jan 2020 00:47:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200130163232.10446-8-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/30/20 5:32 PM, Philippe Mathieu-Daudé wrote:
> Patch created mechanically by running:
> 
>    $ chmod 644 $(git grep -lF '#!/usr/bin/env python' \
>        | xargs grep -L 'if __name__.*__main__')
>    $ sed -i "/^#\!\/usr\/bin\/\(env\ \)\?python.\?$/d" \
>        $(git grep -lF '#!/usr/bin/env python' \
>        | xargs grep -L 'if __name__.*__main__')
> 
> Reported-by: Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>
> Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
> Reviewed-by: Wainer dos Santos Moschetta <wainersm@redhat.com>
> Acked-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>   tests/acceptance/virtio_seg_max_adjust.py  | 1 -
>   tests/acceptance/x86_cpu_model_versions.py | 1 -
>   2 files changed, 2 deletions(-)
>   mode change 100755 => 100644 tests/acceptance/virtio_seg_max_adjust.py
> 
> diff --git a/tests/acceptance/virtio_seg_max_adjust.py b/tests/acceptance/virtio_seg_max_adjust.py
> old mode 100755
> new mode 100644
> index 5458573138..8d4f24da49
> --- a/tests/acceptance/virtio_seg_max_adjust.py
> +++ b/tests/acceptance/virtio_seg_max_adjust.py
> @@ -1,4 +1,3 @@
> -#!/usr/bin/env python
>   #
>   # Test virtio-scsi and virtio-blk queue settings for all machine types
>   #
> diff --git a/tests/acceptance/x86_cpu_model_versions.py b/tests/acceptance/x86_cpu_model_versions.py
> index 90558d9a71..01ff614ec2 100644
> --- a/tests/acceptance/x86_cpu_model_versions.py
> +++ b/tests/acceptance/x86_cpu_model_versions.py
> @@ -1,4 +1,3 @@
> -#!/usr/bin/env python
>   #
>   # Basic validation of x86 versioned CPU models and CPU model aliases
>   #
> 

Thanks, applied to my python-next tree:
https://gitlab.com/philmd/qemu/commits/python-next

