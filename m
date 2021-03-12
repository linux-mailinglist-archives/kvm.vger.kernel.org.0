Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C92EE33902F
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 15:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhCLOlL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 09:41:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41658 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230072AbhCLOky (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Mar 2021 09:40:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615560053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UHFz+ZfMKEJbP5t9K2bCk5hCYslzNNC+cpLu7ln61Mg=;
        b=Q0A/s5Osax2RIMU3L94kc6QYqDq1qn8DDBFo0xDyElDn8FmB7jFg14+igb5IOoSMQPMu+s
        IjRsoyF/aNpRVylbMwoWxoMvWjnG4bxgJhIp/yzk4KhjTuKx29kbTSEsY+S/lJAzda8wXg
        9/TiGMmYlujIg2ZquVgyIPd0uss71oM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217--jbfGZkSOmWiNbYUX4bpog-1; Fri, 12 Mar 2021 09:40:50 -0500
X-MC-Unique: -jbfGZkSOmWiNbYUX4bpog-1
Received: by mail-wr1-f71.google.com with SMTP id e13so11237405wrg.4
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 06:40:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UHFz+ZfMKEJbP5t9K2bCk5hCYslzNNC+cpLu7ln61Mg=;
        b=cUpuocGJZuFy63rkHuNg1h0+J/JB0j6bl7Rcw9GGpEMcvsjWf3NiSHp0c+gE2EzYT7
         /5x/5DLdCuJMpcSxoqfOp7edMOgOqCMapCYr5kke4FKsenbjmGB72qZAqU2SpfHUa+Qw
         A6gKlABPY8bNTXTTwVjH6LBQn4MTOYD2dQrIPYW0tu9Tv6qy0mGca4rOGxV8yheB81ZF
         UsdlLwks+bnQjne9AgB5I2zb3BoTztGvgcTdec54MdqbTqsUmFQSKxcke+VmrhCw6Q4Z
         yEPMwh5FwhZM4kecAa1gcmtLMf2eSRe4Vbie6Rl9w9es60eN5eChki/DNT0IO1neLgOy
         YJKA==
X-Gm-Message-State: AOAM530JOL5s7jU+EOCvDUkXM1uvdXR3QAbEfKGBUtvCCvl8vg/piuTp
        q5Pr0DnYwhtEPoE/OpYJvBS+wn4em2v/tX+ueEbLNWjzB2f4M0vrscu82BR0H6TeyVJCQjHwSht
        o4D3rTUFo4GJ8
X-Received: by 2002:adf:f841:: with SMTP id d1mr14157283wrq.36.1615560049592;
        Fri, 12 Mar 2021 06:40:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzgzENVDWH77SrdxqPP5xavvsUwfa0+M+2ZdEnSJauzOQ012YEkvpkDBfuH0dxQ2NcCuQ1oKw==
X-Received: by 2002:adf:f841:: with SMTP id d1mr14157254wrq.36.1615560049394;
        Fri, 12 Mar 2021 06:40:49 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id q17sm3268632wrv.25.2021.03.12.06.40.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 06:40:49 -0800 (PST)
Date:   Fri, 12 Mar 2021 15:40:46 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v6 02/22] af_vsock: separate wait data loop
Message-ID: <20210312144046.dnthewowhmkvfotd@steredhat>
References: <20210307175722.3464068-1-arseny.krasnov@kaspersky.com>
 <20210307175905.3464610-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210307175905.3464610-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 07, 2021 at 08:59:01PM +0300, Arseny Krasnov wrote:
>This moves wait loop for data to dedicated function, because later it
>will be used by SEQPACKET data receive loop. While moving the code
>around, let's update an old comment.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> net/vmw_vsock/af_vsock.c | 156 +++++++++++++++++++++------------------
> 1 file changed, 84 insertions(+), 72 deletions(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

