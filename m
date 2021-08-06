Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF483E23E0
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 09:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243085AbhHFHUy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 03:20:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47641 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242107AbhHFHUp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Aug 2021 03:20:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628234429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HTm9fbXgLtcZGdGW/3I21kvZ1VGYI5U7k0mhmEpEDg0=;
        b=FSTa0CY5QWVMGSAhJkJC7vjnuHrBQCQfqwkY3HEfrr+B3P9NL1ZZzdAfJtB+3FwPXwV1nx
        2WS96G0N6qoKpi1YBaXeve/LdBjuzFszM7dgnpn9eUQH9IyYQFj5DsxiApY/6bHmjiEmYU
        bWdDXK9GSg1mp+a/TUA8U1aSU2vMsns=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-f4YxHzOyP_iCUj8R8ICtlQ-1; Fri, 06 Aug 2021 03:20:28 -0400
X-MC-Unique: f4YxHzOyP_iCUj8R8ICtlQ-1
Received: by mail-ej1-f70.google.com with SMTP id ju25-20020a17090798b9b029058c24b55273so2883499ejc.8
        for <kvm@vger.kernel.org>; Fri, 06 Aug 2021 00:20:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HTm9fbXgLtcZGdGW/3I21kvZ1VGYI5U7k0mhmEpEDg0=;
        b=KsuvAfAqi9Qy0HFItqHLcX71VzuDWfr1eITR5qwIdKrDCtjPrx6FB/MCTxMhh8doDz
         uTMHoD9VgX/vnV4O80SazENmKTYIzEZaW0aZfIEP4BPuwL0D4ZwJrqvQxvXbzsY2yFG/
         C4yKQAxmms1EwZkYON7I9IqbMkXQBk5Iaut6ctvzqMcT/ycZMCnZyvBaQsopzaXnfFfu
         dMoD6NA8kzqM9dILPcDZT0mahhYOVUy1GVA/2gDF0Gj5P5o1rQAAIgrajMAb/HLYkv3U
         9JT9hxNsXqXkl33w4Vm+ot9vBXtriw78TKy/E8DThpVZUl8AdPSCd6sxwgXbJZJlsUhG
         TtNA==
X-Gm-Message-State: AOAM531iAzPE+hGvouwWZnvygV1BsLLrjkQ1gk3f3CQjLV6OwjY3xYLB
        vnCBO7OXo5kkU4T9Pl+TGIhtvGGX2NJy/58LoUWqMdiJvsOIDgIBoVPX5GIPLKNP3oY4NPh/f0g
        Rh0+BVRnRTolO
X-Received: by 2002:a05:6402:361:: with SMTP id s1mr11209641edw.172.1628234427596;
        Fri, 06 Aug 2021 00:20:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyuVKndM6vRqX10g0DMF+zN0NMme5c3sOtXbrtFonOTm7kn0n+W/NJwkU2ojVAcnd/691RvGg==
X-Received: by 2002:a05:6402:361:: with SMTP id s1mr11209627edw.172.1628234427450;
        Fri, 06 Aug 2021 00:20:27 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id p16sm3396595eds.73.2021.08.06.00.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 00:20:27 -0700 (PDT)
Date:   Fri, 6 Aug 2021 09:20:24 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v1 2/7] vsock: rename implementation from 'record' to
 'message'
Message-ID: <20210806072024.ejp2d5sgfatga6oz@steredhat>
References: <20210726163137.2589102-1-arseny.krasnov@kaspersky.com>
 <20210726163328.2589649-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210726163328.2589649-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 26, 2021 at 07:33:25PM +0300, Arseny Krasnov wrote:
>As 'record' is not same as 'message', rename current variables,
>comments and defines from 'record' concept to 'message'.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> drivers/vhost/vsock.c                   | 18 +++++++++---------
> net/vmw_vsock/virtio_transport_common.c | 14 +++++++-------
> 2 files changed, 16 insertions(+), 16 deletions(-)


This patch is fine, I think you can move here the renaming of the flag 
too.

Stefano

