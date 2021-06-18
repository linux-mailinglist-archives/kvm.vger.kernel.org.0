Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 828593ACDC1
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 16:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234638AbhFROrK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 10:47:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50807 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234590AbhFROrJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Jun 2021 10:47:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624027499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V/WnAvrrvHUpmCgAw99j9Kec2UebwacAruxQ8zG2B7M=;
        b=HT/1qc79JJhwxg1eyPIDD8eAEH4x9FW/mGHmz1SMLECqj33avFExyGg7kGRifrERlwP9mo
        0n0xoz+5JU+e5LdFdXi3zpNyQzYHuy0lMtycLO00V2StWH/yxbm7jCIyJ3nTwoceJGymNe
        aYfQjiJWtSbOVY6w5gQzgDVRFxanuPs=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-_pYyHr4tONirfbaONm5R-Q-1; Fri, 18 Jun 2021 10:44:57 -0400
X-MC-Unique: _pYyHr4tONirfbaONm5R-Q-1
Received: by mail-ej1-f69.google.com with SMTP id jw19-20020a17090776b3b0290481592f1fc4so2403857ejc.2
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 07:44:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V/WnAvrrvHUpmCgAw99j9Kec2UebwacAruxQ8zG2B7M=;
        b=cATRsxjt898tea4XeS0+xtrak5Tln8+8smSIwgcEzTaUONfSAzCpl8Nc+gHhRaslbY
         NedntFsKRnwKdB7LDdvcJBofflP3JpiMqh43ycT+MXk8xRVjgJcITxvbAMCj0vyHbmQA
         3tw21oqvGlZP76pSACetHC6Pux0Oi9e0Yf7vccSVOYDy+HqQKvtSZSOUvlnfhK9GG+JU
         Skd0t9c/Anwck7lj7VWw85G3hVXMY3YeO+Awm06NsbJGlHHXQUI4P1rB85soNzFKS6BR
         SjYU3y1/506QniZfhWnWAWSer/A8pb/SShy8Rd7w4QuAwC2K66/KSsQb1qfvpCEWysQS
         fh8Q==
X-Gm-Message-State: AOAM532Nqo1bYZt9ikdnLoFQOs0u5anwBtQJRAuXRvuROIEPJxHV+uDw
        H+EsxkJLFyn435aTiBdOSynDsTJ9iqEsu9t5zI6ff4xu589Ppf/L/1xSM4kwOmluYyqg2QqHw00
        LK4UoXB3mQjjL
X-Received: by 2002:a50:fe84:: with SMTP id d4mr3407515edt.204.1624027496830;
        Fri, 18 Jun 2021 07:44:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzK4Z8Hr0HyQjHs6Puo8AmSdgMXl6TuIWEB1lOjBOybncOitI6nTXoOqO4csz4fz/xLxynwbg==
X-Received: by 2002:a50:fe84:: with SMTP id d4mr3407501edt.204.1624027496686;
        Fri, 18 Jun 2021 07:44:56 -0700 (PDT)
Received: from steredhat.lan ([5.170.128.175])
        by smtp.gmail.com with ESMTPSA id c18sm6178818edt.97.2021.06.18.07.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 07:44:56 -0700 (PDT)
Date:   Fri, 18 Jun 2021 16:44:51 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        oxffffaa@gmail.com
Subject: Re: [PATCH v11 11/18] virtio/vsock: dequeue callback for
 SOCK_SEQPACKET
Message-ID: <20210618144451.6gmeqtfawdjpvgkv@steredhat.lan>
References: <20210611110744.3650456-1-arseny.krasnov@kaspersky.com>
 <20210611111241.3652274-1-arseny.krasnov@kaspersky.com>
 <20210618134423.mksgnbmchmow4sgh@steredhat.lan>
 <20210618095006-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210618095006-mutt-send-email-mst@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 18, 2021 at 09:51:44AM -0400, Michael S. Tsirkin wrote:
>On Fri, Jun 18, 2021 at 03:44:23PM +0200, Stefano Garzarella wrote:
>> Hi Arseny,
>> the series looks great, I have just a question below about
>> seqpacket_dequeue.
>>
>> I also sent a couple a simple fixes, it would be great if you can review
>> them:
>> https://lore.kernel.org/netdev/20210618133526.300347-1-sgarzare@redhat.com/
>
>So given this was picked into net next, what's the plan? Just make spec
>follow code? We can wait and see, if there are issues with the spec just
>remember to mask the feature before release.

Yep, the spec patches was already posted, but not merged yet: 
https://lists.oasis-open.org/archives/virtio-comment/202105/msg00017.html

The changes are quite small and they are aligned with the current 
implementation.

Anyway, I perfectly agree with you about waiting and mask it before 
v5.14 release if there are any issue.

Thanks,
Stefano

