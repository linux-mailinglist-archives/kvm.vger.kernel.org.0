Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4837438951
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 13:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728796AbfFGLqO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 07:46:14 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55712 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728606AbfFGLqO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 07:46:14 -0400
Received: by mail-wm1-f66.google.com with SMTP id a15so1740007wmj.5
        for <kvm@vger.kernel.org>; Fri, 07 Jun 2019 04:46:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gnWFjc+G+xpkyU5e2RNt1AZsFiuo9mdL+PpgvRI2di8=;
        b=V65O6Nj3t7mZm4q7b15kx8MLh6wVSXvNW5VzMdyQa7a5YXM5Kmr7yv/FJ2NA+VrQxK
         UpnrH0GkQTJKOBNYzbmj56OIDfn1bNMz7dY/lA2J0BMpiiJO5pT63npPR2VME4NkJRRH
         LwGsD3dt/E1NDw/OsT8XlVslqDPazZnGhtvQOsORCqI11cxflU+ICaQ9ey+tOHTgfidN
         bDYn2OCR1nnLHvmPT4cHdP64YEx5k3cSzri2ENAWFlT/4monVBhv9/XgPLAszwmg49xH
         vT9zPmjXABY+7Nzw8wRIfEeuUFtWA0Vhctr+H/1TN21jU01mvWSYPttM6FgmSA5969Rc
         nI5w==
X-Gm-Message-State: APjAAAWFZRvZd09jAzbIeHTnQBsviUn+FzAYJyrIoQTZ3838pSZ56iqB
        ETPnMWXpRO+icRK1Bdal5vlVXA==
X-Google-Smtp-Source: APXvYqwyQtQtUyff6zE+6e1icSYEInlI+knM/+5RFsQArL9ncrcBcFrHvK/n2Dg12cbZhvLtL5qXeA==
X-Received: by 2002:a7b:c251:: with SMTP id b17mr2140022wmj.143.1559907972587;
        Fri, 07 Jun 2019 04:46:12 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d43d:6da3:9364:a775? ([2001:b07:6468:f312:d43d:6da3:9364:a775])
        by smtp.gmail.com with ESMTPSA id z135sm2111872wmc.45.2019.06.07.04.46.11
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 04:46:12 -0700 (PDT)
Subject: Re: [PATCH] kvm-all: Add/update fprintf's for kvm_*_ioeventfd_del
To:     Yury Kotov <yury-kotov@yandex-team.ru>,
        "open list:Overall" <kvm@vger.kernel.org>
Cc:     "open list:All patches CC here" <qemu-devel@nongnu.org>,
        yc-core@yandex-team.ru
References: <20190607090830.18807-1-yury-kotov@yandex-team.ru>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <99896404-c7d9-d2d0-ab01-ab67dcb0348f@redhat.com>
Date:   Fri, 7 Jun 2019 13:46:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190607090830.18807-1-yury-kotov@yandex-team.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/06/19 11:08, Yury Kotov wrote:
> Signed-off-by: Yury Kotov <yury-kotov@yandex-team.ru>
> ---
>  accel/kvm/kvm-all.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 524c4ddfbd..e4ac3386cb 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -864,8 +864,8 @@ static void kvm_mem_ioeventfd_add(MemoryListener *listener,
>                                 data, true, int128_get64(section->size),
>                                 match_data);
>      if (r < 0) {
> -        fprintf(stderr, "%s: error adding ioeventfd: %s\n",
> -                __func__, strerror(-r));
> +        fprintf(stderr, "%s: error adding ioeventfd: %s (%d)\n",
> +                __func__, strerror(-r), -r);
>          abort();
>      }
>  }
> @@ -882,6 +882,8 @@ static void kvm_mem_ioeventfd_del(MemoryListener *listener,
>                                 data, false, int128_get64(section->size),
>                                 match_data);
>      if (r < 0) {
> +        fprintf(stderr, "%s: error deleting ioeventfd: %s (%d)\n",
> +                __func__, strerror(-r), -r);
>          abort();
>      }
>  }
> @@ -898,8 +900,8 @@ static void kvm_io_ioeventfd_add(MemoryListener *listener,
>                                data, true, int128_get64(section->size),
>                                match_data);
>      if (r < 0) {
> -        fprintf(stderr, "%s: error adding ioeventfd: %s\n",
> -                __func__, strerror(-r));
> +        fprintf(stderr, "%s: error adding ioeventfd: %s (%d)\n",
> +                __func__, strerror(-r), -r);
>          abort();
>      }
>  }
> @@ -917,6 +919,8 @@ static void kvm_io_ioeventfd_del(MemoryListener *listener,
>                                data, false, int128_get64(section->size),
>                                match_data);
>      if (r < 0) {
> +        fprintf(stderr, "%s: error deleting ioeventfd: %s (%d)\n",
> +                __func__, strerror(-r), -r);
>          abort();
>      }
>  }
> 

Queued, thanks.

Paolo
