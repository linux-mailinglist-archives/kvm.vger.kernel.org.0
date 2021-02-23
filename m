Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 592CD322CDC
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 15:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233155AbhBWOwI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 09:52:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50637 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232698AbhBWOv4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Feb 2021 09:51:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614091830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M2OsuZx3r6NZflw0QWxaOyg4KYFKBmW4S9BSyB7K63o=;
        b=TsThiW2yX0wp9P166tJDvFqmNJMyu+T351We00fGmUgKY/bZZ+S3Q4eXBp7pAL6TwpiFC8
        yxTq4avZ4OCDefdEWPc9vX8EAMw3KSS8XjNwMn0wu5gMY00GdwL65CoSvUxNHukA8ad2wO
        Znf70BlilDtT9az6tX4pwVb41QmUJR0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-o54DRjYSOuqy17b50yVrFw-1; Tue, 23 Feb 2021 09:50:21 -0500
X-MC-Unique: o54DRjYSOuqy17b50yVrFw-1
Received: by mail-wr1-f69.google.com with SMTP id x14so6796787wrr.13
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 06:50:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=M2OsuZx3r6NZflw0QWxaOyg4KYFKBmW4S9BSyB7K63o=;
        b=i8aFOtby/on9rsckACQYXutrxRgVqVX51szzDeFklwN7O2ILNR8YbRnzZp7Mh0YI8u
         x2uhaI9TqmoYOb8Np2c3ETuDXDuwJQmcQY1G9bFV7NMIvxB8JwJIETtnX7XA0bkwmP26
         iDOwG8Y7lB0rMziwSXtoybILebNy0SmSJMwAWHjIZbt2E1ywy2C7NR8JwKR57CcmgGFx
         K1Xlg3nhAG1ii4faTlCu2GWB73L/no0/986X4a6mUi85+TooQ0VQb3bEYsNHy7UHjxq5
         6qAJ92VQEO3zJROXlFRhYK4OcU1bunGuzkWtV6uCDYPsuHdDh0zDv4fZRJ6+LBbb0eQ5
         fOCg==
X-Gm-Message-State: AOAM5300Z6VESw1BMk4LMzIflygsSv14gIf8kH/Q3FwYjWz6kFbZSCev
        fvwJbgQVY/31RAt5ef97V2G/yabXAN5ywqyJAWNbyWcoZYI1At916CU+rjqSPdWAE730kEnMl5l
        6FYkpUFgZJK/3
X-Received: by 2002:a1c:98c2:: with SMTP id a185mr9344412wme.72.1614091819958;
        Tue, 23 Feb 2021 06:50:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz9tKk0w/iRNRhb7cnm0SfH7twj8rmJO83bREpU9MxKNF6QINjG5A2hMiz9ZZMxEqXDfAr0og==
X-Received: by 2002:a1c:98c2:: with SMTP id a185mr9344394wme.72.1614091819741;
        Tue, 23 Feb 2021 06:50:19 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id o15sm2891607wmh.39.2021.02.23.06.50.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 06:50:19 -0800 (PST)
Date:   Tue, 23 Feb 2021 15:50:16 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v5 00/19] virtio/vsock: introduce SOCK_SEQPACKET
 support
Message-ID: <20210223145016.ddavx6fihq4akdim@steredhat>
References: <20210218053347.1066159-1-arseny.krasnov@kaspersky.com>
 <20210222142311.gekdd7gsm33wglos@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210222142311.gekdd7gsm33wglos@steredhat>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 22, 2021 at 03:23:11PM +0100, Stefano Garzarella wrote:
>Hi Arseny,
>
>On Thu, Feb 18, 2021 at 08:33:44AM +0300, Arseny Krasnov wrote:
>>	This patchset impelements support of SOCK_SEQPACKET for virtio
>>transport.
>>	As SOCK_SEQPACKET guarantees to save record boundaries, so to
>>do it, two new packet operations were added: first for start of record
>>and second to mark end of record(SEQ_BEGIN and SEQ_END later). Also,
>>both operations carries metadata - to maintain boundaries and payload
>>integrity. Metadata is introduced by adding special header with two
>>fields - message count and message length:
>>
>>	struct virtio_vsock_seq_hdr {
>>		__le32  msg_cnt;
>>		__le32  msg_len;
>>	} __attribute__((packed));
>>
>>	This header is transmitted as payload of SEQ_BEGIN and SEQ_END
>>packets(buffer of second virtio descriptor in chain) in the same way as
>>data transmitted in RW packets. Payload was chosen as buffer for this
>>header to avoid touching first virtio buffer which carries header of
>>packet, because someone could check that size of this buffer is equal
>>to size of packet header. To send record, packet with start marker is
>>sent first(it's header contains length of record and counter), then
>>counter is incremented and all data is sent as usual 'RW' packets and
>>finally SEQ_END is sent(it also carries counter of message, which is
>>counter of SEQ_BEGIN + 1), also after sedning SEQ_END counter is
>>incremented again. On receiver's side, length of record is known from
>>packet with start record marker. To check that no packets were dropped
>>by transport, counters of two sequential SEQ_BEGIN and SEQ_END are
>>checked(counter of SEQ_END must be bigger that counter of SEQ_BEGIN by
>>1) and length of data between two markers is compared to length in
>>SEQ_BEGIN header.
>>	Now as  packets of one socket are not reordered neither on
>>vsock nor on vhost transport layers, such markers allows to restore
>>original record on receiver's side. If user's buffer is smaller that
>>record length, when all out of size data is dropped.
>>	Maximum length of datagram is not limited as in stream socket,
>>because same credit logic is used. Difference with stream socket is
>>that user is not woken up until whole record is received or error
>>occurred. Implementation also supports 'MSG_EOR' and 'MSG_TRUNC' flags.
>>	Tests also implemented.
>
>I reviewed the first part (af_vsock.c changes), tomorrow I'll review 
>the rest. That part looks great to me, only found a few minor issues.

I revieiwed the rest of it as well, left a few minor comments, but I 
think we're well on track.

I'll take a better look at the specification patch tomorrow.

Thanks,
Stefano

>
>In the meantime, however, I'm getting a doubt, especially with regard 
>to other transports besides virtio.
>
>Should we hide the begin/end marker sending in the transport?
>
>I mean, should the transport just provide a seqpacket_enqueue() 
>callbacl?
>Inside it then the transport will send the markers. This is because 
>some transports might not need to send markers.
>
>But thinking about it more, they could actually implement stubs for 
>that calls, if they don't need to send markers.
>
>So I think for now it's fine since it allows us to reuse a lot of 
>code, unless someone has some objection.
>
>Thanks,
>Stefano
>

