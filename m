Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30E6637F9F8
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 16:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234703AbhEMOtW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 May 2021 10:49:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25616 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234685AbhEMOsJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 May 2021 10:48:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620917219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rGg3l/7n8SNDT+a7ouZ0AJr+1X0/uEbg6PfCHzDeJoQ=;
        b=DaXC4Vr90H3qXrSmGdfXHfU1wXHAPhqIFhKU44BIpW/sHtUtwuOXbMl6m/HK99ukiC1qLx
        lbnox7GuOAVPv8hyXHm6vStOhE0msAbq4lwMg+7bfj9uPmbCtD877HpTWILjGeUBWmdcQ4
        0hTgFSMkQnwxp0Mt+A+S7Y+KdRtzsU8=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-65-nc6tJfSpPh2eQSiUI6ceJg-1; Thu, 13 May 2021 10:46:57 -0400
X-MC-Unique: nc6tJfSpPh2eQSiUI6ceJg-1
Received: by mail-ej1-f69.google.com with SMTP id sd18-20020a170906ce32b02903cedf584542so2377596ejb.9
        for <kvm@vger.kernel.org>; Thu, 13 May 2021 07:46:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rGg3l/7n8SNDT+a7ouZ0AJr+1X0/uEbg6PfCHzDeJoQ=;
        b=cjlSb2MKnhteQ9DFTcIhnDpOaKGzJP/LydFAnJ4y8f4GHtkRfaacv7/OKFS9dSmVm6
         2tFSyyZtnO65pbvuSLc5AUSecMYRl+l4XIc2CU2TXi/q8xQgdGcXhylRVFOIUg+3RNT2
         GpRkugxt7rY7cMoQQUoTlHjG4jHRZNogMJXTJ9qcP6B5HGP9A4sBIM/0SBI7CZAWk5Nh
         uRVUmuyxGrwCESqpa1o5CecffY5PeWA4f8O3Q0FOJ7s8RH1orP0i4brYfqJmp8LT9JVB
         I+3isp0KElVZXkWYy9eCvfOIYPFp437jxf+3gdDUOq4KiIHN3vLc563SBkNkbbssXBzH
         VxNQ==
X-Gm-Message-State: AOAM532VZjQGzJduFCZjH7UaUH5ZFQieOhv2jWS/EAuhQesvG+/ylWl6
        sjwQ22mQ3pQ4XxU7mDMdq8/cm4K/h+0bUOSd6TQuraItPt37mLjmO2ys13rhsZdS5s90nFMIQHl
        YOw1j7sOftczZ
X-Received: by 2002:a17:907:3e28:: with SMTP id hp40mr21283575ejc.523.1620917216307;
        Thu, 13 May 2021 07:46:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwzSceLI37ohYl3OTJmHxOffRDbF3BNal57WXUnEN0Xk+EFEMUtvnnXnlAzBST0LnZ+IGqHEw==
X-Received: by 2002:a17:907:3e28:: with SMTP id hp40mr21283545ejc.523.1620917216075;
        Thu, 13 May 2021 07:46:56 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id i8sm2536335edu.64.2021.05.13.07.46.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 07:46:55 -0700 (PDT)
Date:   Thu, 13 May 2021 16:46:53 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v9 19/19] af_vsock: serialize writes to shared socket
Message-ID: <20210513144653.ogzfvypqpjsz2iga@steredhat>
References: <20210508163027.3430238-1-arseny.krasnov@kaspersky.com>
 <20210508163738.3432975-1-arseny.krasnov@kaspersky.com>
 <20210513140150.ugw6foy742fxan4w@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210513140150.ugw6foy742fxan4w@steredhat>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 13, 2021 at 04:01:50PM +0200, Stefano Garzarella wrote:
>On Sat, May 08, 2021 at 07:37:35PM +0300, Arseny Krasnov wrote:
>>This add logic, that serializes write access to single socket
>>by multiple threads. It is implemented be adding field with TID
>>of current writer. When writer tries to send something, it checks
>>that field is -1(free), else it sleep in the same way as waiting
>>for free space at peers' side.
>>
>>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>>---
>>include/net/af_vsock.h   |  1 +
>>net/vmw_vsock/af_vsock.c | 10 +++++++++-
>>2 files changed, 10 insertions(+), 1 deletion(-)
>
>I think you forgot to move this patch at the beginning of the series.
>It's important because in this way we can backport to stable branches 
>easily.
>
>About the implementation, can't we just add a mutex that we hold until 
>we have sent all the payload?

Re-thinking, I guess we can't because we have the timeout to deal 
with...

>
>I need to check other implementations like TCP.
>

Thanks,
Stefano

