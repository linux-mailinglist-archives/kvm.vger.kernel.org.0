Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A10B37FAF1
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 17:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234980AbhEMPmq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 May 2021 11:42:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53224 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234940AbhEMPmj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 May 2021 11:42:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620920489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sXZYS/0BUExKj3W5kBmFWrcfidrqXplf+lopV9pbEik=;
        b=ZQxPMSSLi6i3jWRQqgibWzu1Rk5nmCVeiGUvLk2rHBMmSSu4XVveR5qfa7ioi3sS6Zm4na
        o63658A61e+joJoXVc0Z7L0YzKzB7Cy7713KCh1rp+965+TomTuUkA6Q2GT3Oi9v0h1NYh
        +Q9qIbY2KzsdiBC7ZDqFk+cQVVicq+w=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-3-fIuj36Nk6j2_wJ-qOwTQ-1; Thu, 13 May 2021 11:41:27 -0400
X-MC-Unique: 3-fIuj36Nk6j2_wJ-qOwTQ-1
Received: by mail-ed1-f72.google.com with SMTP id i19-20020a05640242d3b0290388cea34ed3so14829641edc.15
        for <kvm@vger.kernel.org>; Thu, 13 May 2021 08:41:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sXZYS/0BUExKj3W5kBmFWrcfidrqXplf+lopV9pbEik=;
        b=GbA2ADyDwSjs6/8u4kwpRBWkczzn7t1jyat0/g3Q2lOcvIFP37siWrlFQsIYWLyR03
         gWsBiSmxgU6xZOM7H0Ut0TuwEqSXgmVyc/5GVDpresmN+Yvs1b0RDqqBenJUA95kMfPo
         fGnITodtNkeUSM36jFK2GNY6biuT+je0n9kqwOOe8j3eK0Erh788G+CmiHVeM4pvNbPo
         gKXCvyUXhboGCMeO83RQasHeMLZjGnkdmY0abEkwqfr2SHYldC7zrGb9A8vv+kjHZhWO
         OFroKjggaYTOrsZdJWKu25XxcJSQ57Xb8SFdpU4DbcBiPCA6Wm9uU3nuAgNz7TaTPJlX
         TkIw==
X-Gm-Message-State: AOAM533NwB5HHkL2VowbfRtf//Nb3Dcmx/Cgqj1jEq0ds59xGHLSJO4U
        zra/AKykB3IFPn3ch7JsFlHstOUezPfNhvIqsQezFccoWu7l9xZAb9TBfhn+kMcvopNaiUlqQlp
        Netkl2q5TPJZx
X-Received: by 2002:aa7:dd41:: with SMTP id o1mr50245477edw.361.1620920486206;
        Thu, 13 May 2021 08:41:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwPjtArqT2SrP+FHXngcrCXNm8mzmb8hWvhCdzDFicV/Wrm8pfSoY4vN4Vx8FaRAq4VLVTKdw==
X-Received: by 2002:aa7:dd41:: with SMTP id o1mr50245467edw.361.1620920486053;
        Thu, 13 May 2021 08:41:26 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id o3sm2624150edr.84.2021.05.13.08.41.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 08:41:25 -0700 (PDT)
Date:   Thu, 13 May 2021 17:41:21 +0200
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
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v9 19/19] af_vsock: serialize writes to shared socket
Message-ID: <20210513154121.a4p2gxwnrxxlj64n@steredhat>
References: <20210508163027.3430238-1-arseny.krasnov@kaspersky.com>
 <20210508163738.3432975-1-arseny.krasnov@kaspersky.com>
 <20210513140150.ugw6foy742fxan4w@steredhat>
 <20210513144653.ogzfvypqpjsz2iga@steredhat>
 <a0cd1806-22d1-8197-50dc-b63a43f33807@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <a0cd1806-22d1-8197-50dc-b63a43f33807@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 13, 2021 at 05:48:19PM +0300, Arseny Krasnov wrote:
>
>On 13.05.2021 17:46, Stefano Garzarella wrote:
>> On Thu, May 13, 2021 at 04:01:50PM +0200, Stefano Garzarella wrote:
>>> On Sat, May 08, 2021 at 07:37:35PM +0300, Arseny Krasnov wrote:
>>>> This add logic, that serializes write access to single socket
>>>> by multiple threads. It is implemented be adding field with TID
>>>> of current writer. When writer tries to send something, it checks
>>>> that field is -1(free), else it sleep in the same way as waiting
>>>> for free space at peers' side.
>>>>
>>>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>>>> ---
>>>> include/net/af_vsock.h   |  1 +
>>>> net/vmw_vsock/af_vsock.c | 10 +++++++++-
>>>> 2 files changed, 10 insertions(+), 1 deletion(-)
>>> I think you forgot to move this patch at the beginning of the series.
>>> It's important because in this way we can backport to stable branches
>>> easily.
>>>
>>> About the implementation, can't we just add a mutex that we hold until
>>> we have sent all the payload?
>> Re-thinking, I guess we can't because we have the timeout to deal
>> with...
>Yes, i forgot about why i've implemented it using 'tid_owner' :)

It is not clear to me if we need to do this also for stream.

I think will be better to follow af_inet/af_unix, but I need to check 
their implementation.

Thanks,
Stefano

