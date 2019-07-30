Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2B97A4C7
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 11:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731845AbfG3JkY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 05:40:24 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44703 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbfG3JkR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 05:40:17 -0400
Received: by mail-wr1-f68.google.com with SMTP id p17so64979763wrf.11
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 02:40:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fQg1192WhNDyv6FjBGie6urrqGv9zjrLIH2bCUp56uc=;
        b=uIult0x7n6xSSbx6LcJnEAeG68/B/uMaoUW5NmPy2CEEMjajfwezBvJcGzDLw6DrBX
         6b1QCiLEMUSR1SMMBnj5QyO8IJer5x5xWencgpyc7j/bmkCf+bZfatcETImHNLK9ibNb
         +ZkbFwrnrLe74+Sjj9ofdBaKRqRgdCEq3us0ePL5dVDqRTvVbHWAI5gnCw7JFA2NEU9G
         PJgHK7Njbvd99ivkipPC0PQmxsVnBxAJ2jv2Z3KJhalQWaAkvn0uZOI1VBeADamVeQUk
         BKMg6zx8TTazbnXwpiSJ8ES2+HfUGASRI8z1YReXM6q7RYPwEDxmjwuLmzn2wSjhyij3
         AHRg==
X-Gm-Message-State: APjAAAWow6MW3aaXxNROPTxywlE5QjCpciJDGhRz5xZUmX1EedJ75jFh
        ltP061SkMeh5SGNCVav9txQL4w==
X-Google-Smtp-Source: APXvYqwQrJXSgJVI83eo1dkA3KRV/8pRzTuIDgoLCeF0kh3lvGAFxSVFdhlDZkRo9pud0n2msXMp9A==
X-Received: by 2002:a5d:50d1:: with SMTP id f17mr72705216wrt.124.1564479615723;
        Tue, 30 Jul 2019 02:40:15 -0700 (PDT)
Received: from steredhat (host122-201-dynamic.13-79-r.retail.telecomitalia.it. [79.13.201.122])
        by smtp.gmail.com with ESMTPSA id r12sm77203676wrt.95.2019.07.30.02.40.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 02:40:15 -0700 (PDT)
Date:   Tue, 30 Jul 2019 11:40:13 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v4 0/5] vsock/virtio: optimizations to increase the
 throughput
Message-ID: <20190730094013.ruqjllqrjmkdnh5y@steredhat>
References: <20190717113030.163499-1-sgarzare@redhat.com>
 <20190729095743-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729095743-mutt-send-email-mst@kernel.org>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 29, 2019 at 09:59:23AM -0400, Michael S. Tsirkin wrote:
> On Wed, Jul 17, 2019 at 01:30:25PM +0200, Stefano Garzarella wrote:
> > This series tries to increase the throughput of virtio-vsock with slight
> > changes.
> > While I was testing the v2 of this series I discovered an huge use of memory,
> > so I added patch 1 to mitigate this issue. I put it in this series in order
> > to better track the performance trends.
> 
> Series:
> 
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> 
> Can this go into net-next?
> 

I think so.
Michael, Stefan thanks to ack the series!

Should I resend it with net-next tag?

Thanks,
Stefano
