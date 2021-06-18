Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B1F3AC7BA
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 11:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbhFRJhs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 05:37:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43164 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232052AbhFRJhr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Jun 2021 05:37:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624008937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rLL8PB172SRL8lGgz205HV0dC/eqDJtIYHSvhcZcv70=;
        b=GS8vU6C7vrY7gPoaPe/PGhAfPRT2cfSjD/JSlPOUUSKrGKn9BcGQ3A0vLD2xcgRNeBqw1d
        LwrjrAkvsdE7hn5+SKeNnaIUAoFbJVGklOU4MHP6qpYEafQPRFyMxwKO1Oy1gS1SeDXJ50
        FlJKmj3vypP+L4WhimuMz1QUARy9sZs=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-k6c0H4cBPfOKlumFFBTSPQ-1; Fri, 18 Jun 2021 05:35:36 -0400
X-MC-Unique: k6c0H4cBPfOKlumFFBTSPQ-1
Received: by mail-ed1-f70.google.com with SMTP id z5-20020a05640235c5b0290393974bcf7eso3243472edc.2
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 02:35:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=rLL8PB172SRL8lGgz205HV0dC/eqDJtIYHSvhcZcv70=;
        b=CtKVImWLC+5j9fCMRXzC0bvgNRGtYRX0es/fRUFRkyYkCoe8l0KwzaJYOTWVD2DC10
         koDNnUiP/GvoDHTG5HHmxVgUkh3iwWg58PeTyOC63/tXdkY48usfbeB2o+fLPUTzmlFh
         mvrrBVq8olw/3iRvpNYHAd04ZqPD5IEHsQ9zqazvYdbW2ncVog8Mv8dV3P3CkbXIuDl8
         Q/Ki1NqZH1aoqEKWZJqzF5J149UQwz27N2nKPIRKrzNzjcxpfg2B+1FFgjxQOBzphUtR
         x8C5aR/MksxUhebV4qCmnf3RSLQJ631K7WZ7PSIfRGprj+tAowYr5Koj7qFQkxZgnCEQ
         0Meg==
X-Gm-Message-State: AOAM531+TIW/XUd/wBn4xFrOnHHcI+oyZJNwLl6yq1SSWY6Av9kU/P9x
        MhmfI5hhuHulAugJjV3YJRdeVN3FMm/o8QIYVtvA56V0wVKKPFEaJzGF1x7D6G5CPHWyeGUEYiS
        tF6/aWbna2NSw
X-Received: by 2002:a50:9d8d:: with SMTP id w13mr3745087ede.94.1624008934362;
        Fri, 18 Jun 2021 02:35:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzrTXbUUFRfwaNYCZ2CYmaoH3ldgRuFW7Ykg1x5qXMOhN3Q/A6Vhme8lxLfTWTSAbzIR/PDfg==
X-Received: by 2002:a50:9d8d:: with SMTP id w13mr3745054ede.94.1624008934194;
        Fri, 18 Jun 2021 02:35:34 -0700 (PDT)
Received: from steredhat.lan ([5.170.128.252])
        by smtp.gmail.com with ESMTPSA id ch17sm5993778edb.42.2021.06.18.02.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 02:35:33 -0700 (PDT)
Date:   Fri, 18 Jun 2021 11:35:29 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jiang Wang <jiang.wang@bytedance.com>
Cc:     virtualization@lists.linux-foundation.org, stefanha@redhat.com,
        mst@redhat.com, arseny.krasnov@kaspersky.com,
        jhansen@vmware.comments, cong.wang@bytedance.com,
        duanxiongchun@bytedance.com, xieyongji@bytedance.com,
        chaiwen.cc@bytedance.com, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Lu Wei <luwei32@huawei.com>,
        Alexander Popov <alex.popov@linux.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC v1 0/6] virtio/vsock: introduce SOCK_DGRAM support
Message-ID: <20210618093529.bxsv4qnryccivdsd@steredhat.lan>
References: <20210609232501.171257-1-jiang.wang@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210609232501.171257-1-jiang.wang@bytedance.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 09, 2021 at 11:24:52PM +0000, Jiang Wang wrote:
>This patchset implements support of SOCK_DGRAM for virtio
>transport.
>
>Datagram sockets are connectionless and unreliable. To avoid unfair contention
>with stream and other sockets, add two more virtqueues and
>a new feature bit to indicate if those two new queues exist or not.
>
>Dgram does not use the existing credit update mechanism for
>stream sockets. When sending from the guest/driver, sending packets
>synchronously, so the sender will get an error when the virtqueue is full.
>When sending from the host/device, send packets asynchronously
>because the descriptor memory belongs to the corresponding QEMU
>process.
>
>The virtio spec patch is here:
>https://www.spinics.net/lists/linux-virtualization/msg50027.html
>
>For those who prefer git repo, here is the link for the linux kernel：
>https://github.com/Jiang1155/linux/tree/vsock-dgram-v1
>
>qemu patch link:
>https://github.com/Jiang1155/qemu/tree/vsock-dgram-v1
>
>
>To do:
>1. use skb when receiving packets
>2. support multiple transport
>3. support mergeable rx buffer

Jiang, I'll do a fast review, but I think is better to rebase on 
net-next since SEQPACKET support is now merged.

Please also run ./scripts/checkpatch.pl, there are a lot of issues.

I'll leave some simple comments in the patches, but I prefer to do a 
deep review after the rebase and the dynamic handling of DGRAM.

Thanks,
Stefano

