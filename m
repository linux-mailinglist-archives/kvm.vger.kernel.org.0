Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F09174903C6
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 09:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235404AbiAQI1a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 03:27:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:57755 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230248AbiAQI1a (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 03:27:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642408049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5AiDyqvFvh3yOegzgJFQoLQBwCo7wbjcGj2xMIv/7xE=;
        b=Uh0Ge4sIDwHsYqm674ok8WIDLWlWcXEoD7bIxN3h0qJn4BjFUd/hEVvW9ufqAvet7D9xIH
        1jwHYfPR5Kbben5KpK2mBOH/Nruy73L5kAUNiegxJaAt3YXbXdRNg8z4OSlsZGl/g4bEhU
        21x+ylUpKzrR7KGbks8Y1Z9ePSvAs9Q=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-673-y0_2O71zOOWgrs7lWgsLGA-1; Mon, 17 Jan 2022 03:27:28 -0500
X-MC-Unique: y0_2O71zOOWgrs7lWgsLGA-1
Received: by mail-wm1-f69.google.com with SMTP id n13-20020a05600c3b8d00b0034979b7e200so4808339wms.4
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 00:27:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5AiDyqvFvh3yOegzgJFQoLQBwCo7wbjcGj2xMIv/7xE=;
        b=oe9vef7diRKkGXDRSRY/jdU76jx1ui1Hrf7S6uDCBEaFoCHqgFBT7yUuzXE0HMRJLz
         sb2GZBBtJZyL4DqJ/G1CGyk52wjP9hujzHUSDfPUhQSQKxasZzDYYS/V3fJJd2F7JXZx
         6MVzIEV0nPoZQIJfTP/0L15DuqYNJWKyF4V5jfkeYfnoG6aw6/FbRKsYzGCdF4TW1w78
         S8LprvFisbPeR1deB4AmbEteB8AzY9zf5CNZKm2sBF1V5yZltRUcwx4W8Advwa0pR9j8
         pTAc8opyBIwz+dKKuymJES24YxpTuCV/MYtmjt4CHfRxaUXYoSeFaB+e3f4CBf/jxjiH
         cwxw==
X-Gm-Message-State: AOAM533gNHq6sUQbvH9O1bQXb8xxPgI2I6JwhEky0KorzMuiYZxS99r7
        iG9Y0U9LI6/ip3yu9ia+Hh3MrFqKoeCjnNyS2LqvxTJBIZ+viGvUkwI6CdOe1C9B3eSZHX+PLNd
        W8kel6iY6xMCd
X-Received: by 2002:a05:600c:1e8e:: with SMTP id be14mr7423365wmb.30.1642408046963;
        Mon, 17 Jan 2022 00:27:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxmSkskdohPD3R4PDk0Urfw0voyV4lTR4GN3RTrgxGfrqifw7hI7f7kMWAl75gDkdsEbn4Ksg==
X-Received: by 2002:a05:600c:1e8e:: with SMTP id be14mr7423345wmb.30.1642408046819;
        Mon, 17 Jan 2022 00:27:26 -0800 (PST)
Received: from [192.168.8.100] (tmo-098-68.customers.d1-online.com. [80.187.98.68])
        by smtp.gmail.com with ESMTPSA id p2sm15764709wmg.44.2022.01.17.00.27.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jan 2022 00:27:26 -0800 (PST)
Message-ID: <41d23c24-7395-c7a0-047b-03c6abb71020@redhat.com>
Date:   Mon, 17 Jan 2022 09:27:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 05/30] s390/airq: pass more TPI info to airq handlers
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
 <20220114203145.242984-6-mjrosato@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220114203145.242984-6-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/01/2022 21.31, Matthew Rosato wrote:
> A subsequent patch will introduce an airq handler that requires additional
> TPI information beyond directed vs floating, so pass the entire tpi_info
> structure via the handler.  Only pci actually uses this information today,
> for the other airq handlers this is effectively a no-op.
> 
> Reviewed-by: Eric Farman <farman@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
> Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   arch/s390/include/asm/airq.h     | 3 ++-
>   arch/s390/kvm/interrupt.c        | 4 +++-
>   arch/s390/pci/pci_irq.c          | 9 +++++++--
>   drivers/s390/cio/airq.c          | 2 +-
>   drivers/s390/cio/qdio_thinint.c  | 6 ++++--
>   drivers/s390/crypto/ap_bus.c     | 9 ++++++---
>   drivers/s390/virtio/virtio_ccw.c | 4 +++-
>   7 files changed, 26 insertions(+), 11 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>

