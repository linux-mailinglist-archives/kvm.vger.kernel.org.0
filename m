Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1E13E017A
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 14:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238214AbhHDM6A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 08:58:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35828 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237105AbhHDM57 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Aug 2021 08:57:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628081866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0/bO+MgPDOUvO02RQ1/ITQ19fPYuZ/wXOCdSbbV0LTs=;
        b=Sjgg8Ao0Trwp81RWAEPO0dUa7lOoKtZ5BPnl5k5yKQcH8T+vSPrBkFoHqrXRBlkpK1rc/W
        LgdrACJHyhl/AzIWpOknBraAU0v3e4HYCR6tqi51v5JlorUmzctOpmAv7X+iY8WjSpOO4k
        ntoLJOAP/OhitVXgn7Vgcenpi4P5KR4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-83-xEoQ71oOOlWg6jYvU5i8sQ-1; Wed, 04 Aug 2021 08:57:45 -0400
X-MC-Unique: xEoQ71oOOlWg6jYvU5i8sQ-1
Received: by mail-ed1-f71.google.com with SMTP id a23-20020a50ff170000b02903b85a16b672so1429368edu.1
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 05:57:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0/bO+MgPDOUvO02RQ1/ITQ19fPYuZ/wXOCdSbbV0LTs=;
        b=Pa1CwwcDpS+csRuTqvF60NDpvhUJLm0hNht/ufXBZl+jvge/rjY+0UrSLFWHRd2yVw
         didYf5g+S52UO9SI3NPlooklJ1QqJdxN79SihzSvK0E9nQo+WtR0jT28Iwm7PEP4MEEh
         bHDp/3+qSEhlJ0Xu23Fcc0CZoS/DEhxG7wJVko/FD011LHlap70WFCLpde1rrU43tujc
         1lUaoCWnEjtm0SGswyjfCLDBTQuZD2RzIaF52XVq6vuygZ42E78GUIiNyIeCECoQjBAj
         OX/M5HTBeox57TTBa1i+lFJqFvSy2Az/behT8CiH7qz6jSasJA3V3h3tFj3+n/J4FmeL
         F7sQ==
X-Gm-Message-State: AOAM533LEBm3nfKVfaRmITT27q1OneASW1iwSCoif0hLkMAAqMLX4k6d
        RHMiaTekSzSFjBo3lvcyuCSwL6hU52UUc5lbCyzQFLLKzOAwYao+FOPHBYtnO01Joxkv0rbqF5+
        QrqTgGI4CWeCo
X-Received: by 2002:a17:906:c085:: with SMTP id f5mr26109114ejz.250.1628081864046;
        Wed, 04 Aug 2021 05:57:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwiZNmhNR8yr3j+9pHq54LbMN6zvfVQtndDuehBDERZ/x4tZYc2Uu210Q95TZ8Abyb0Xl5IzQ==
X-Received: by 2002:a17:906:c085:: with SMTP id f5mr26109096ejz.250.1628081863868;
        Wed, 04 Aug 2021 05:57:43 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id n11sm666345ejg.111.2021.08.04.05.57.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 05:57:43 -0700 (PDT)
Date:   Wed, 4 Aug 2021 14:57:37 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v1 0/7] virtio/vsock: introduce MSG_EOR flag for
 SEQPACKET
Message-ID: <20210804125737.kbgc6mg2v5lw25wu@steredhat>
References: <20210726163137.2589102-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210726163137.2589102-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Arseny,

On Mon, Jul 26, 2021 at 07:31:33PM +0300, Arseny Krasnov wrote:
>	This patchset implements support of MSG_EOR bit for SEQPACKET
>AF_VSOCK sockets over virtio transport.
>	Idea is to distinguish concepts of 'messages' and 'records'.
>Message is result of sending calls: 'write()', 'send()', 'sendmsg()'
>etc. It has fixed maximum length, and it bounds are visible using
>return from receive calls: 'read()', 'recv()', 'recvmsg()' etc.
>Current implementation based on message definition above.

Okay, so the implementation we merged is wrong right?
Should we disable the feature bit in stable kernels that contain it? Or 
maybe we can backport the fixes...

>	Record has unlimited length, it consists of multiple message,
>and bounds of record are visible via MSG_EOR flag returned from
>'recvmsg()' call. Sender passes MSG_EOR to sending system call and
>receiver will see MSG_EOR when corresponding message will be processed.
>	To support MSG_EOR new bit was added along with existing
>'VIRTIO_VSOCK_SEQ_EOR': 'VIRTIO_VSOCK_SEQ_EOM'(end-of-message) - now it
>works in the same way as 'VIRTIO_VSOCK_SEQ_EOR'. But 'VIRTIO_VSOCK_SEQ_EOR'
>is used to mark 'MSG_EOR' bit passed from userspace.

I understand that it makes sense to remap VIRTIO_VSOCK_SEQ_EOR to 
MSG_EOR to make the user understand the boundaries, but why do we need 
EOM as well?

Why do we care about the boundaries of a message within a record?
I mean, if the sender makes 3 calls:
     send(A1,0)
     send(A2,0)
     send(A3, MSG_EOR);

IIUC it should be fine if the receiver for example receives all in one 
single recv() calll with MSG_EOR set, so why do we need EOM?

Thanks,
Stefano

