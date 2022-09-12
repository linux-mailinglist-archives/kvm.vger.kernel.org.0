Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D843C5B6000
	for <lists+kvm@lfdr.de>; Mon, 12 Sep 2022 20:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbiILSNT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Sep 2022 14:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiILSNQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Sep 2022 14:13:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1635141D16
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 11:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663006393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MIivuanKSjygaobAWTqz6Vlrz5BF6yE307kFzPCTliY=;
        b=INnt/rYiEVb02Ty2IwhGOUlUyHxkHrxqms4IPh+PWFDWlLhbF2/Y3SZbQWQ54f5vIka3Hy
        dzD3jPV0dyLxeK4mk0OkftsSrCn4BZO3DL1IV3NN3WBd4seUPMUViftP6txKVfsjAJ9M8s
        heZu1rBmtfsHsWTamsD4QfxT0AIlAaU=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-669-vucxFC-nOj2nLyWui2Qhrw-1; Mon, 12 Sep 2022 14:13:11 -0400
X-MC-Unique: vucxFC-nOj2nLyWui2Qhrw-1
Received: by mail-lf1-f70.google.com with SMTP id x7-20020a056512130700b00492c545b3cfso3124514lfu.11
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 11:13:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=MIivuanKSjygaobAWTqz6Vlrz5BF6yE307kFzPCTliY=;
        b=VOUGG3Ebww+hNUDHMYe6u7BnC3MaDq9RmDKX95AuBvm4o9o25hszeQvML4ln4cfxHQ
         gslgSCUhnQviH4TnS8LVq9uPrqQ0YyGxXD6Hni3vxbqk2KLtXCqTORwWuzOyf+Yc3GSI
         DFx0DgTKXmx3yR/n5U3zuxp8DaC1K6eDsTEg+qeRpWp+V1st9MYNzfZFW/50n3u1mc+V
         ACtc6k4FzXd0VvNG5ZJpXp7yQ8Mo4IBHJDEhtRtaWeNVUmzxFb7Us1CPv8MPDZLZzf6Z
         /8V8QYJ3KYN+bws4eFguGox1+HxOtc2qArfVXIQ/cJgIRgGfGDdGvTN4cKKC9B02nGwE
         /q4A==
X-Gm-Message-State: ACgBeo1eBBm3Lacvnp5u/WCpq84bTxF34Xk1Y1lGWICOsAzTgVZckjC0
        N4ddAeuifGGNkgJW+ZerXfKnc2VyZjOKNdSEKN1y215OKGmb2u63toSUjRlSA4DJdIMyQlquMzE
        IefzljsDKpjEISBhoTHD3vT1knyHz
X-Received: by 2002:a05:6512:3b1e:b0:49b:49d9:cb9e with SMTP id f30-20020a0565123b1e00b0049b49d9cb9emr877210lfv.201.1663006390225;
        Mon, 12 Sep 2022 11:13:10 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5ppAN5/qdHGxQeudg4Zh5HihxK1wLBPBp6mq9A3a1ed9G1ccE8gIbz65FRZyZtWK+AopezeLNQh/bU8TMuMvk=
X-Received: by 2002:a05:6512:3b1e:b0:49b:49d9:cb9e with SMTP id
 f30-20020a0565123b1e00b0049b49d9cb9emr877188lfv.201.1663006389976; Mon, 12
 Sep 2022 11:13:09 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
 <YxdKiUzlfpHs3h3q@fedora> <Yv5PFz1YrSk8jxzY@bullseye> <20220908143652.tfyjjx2z6in6v66c@sgarzare-redhat>
 <YxuCVfFcRdWHeeh8@bullseye>
In-Reply-To: <YxuCVfFcRdWHeeh8@bullseye>
From:   Stefano Garzarella <sgarzare@redhat.com>
Date:   Mon, 12 Sep 2022 20:12:58 +0200
Message-ID: <CAGxU2F5HG_UouKzJNuvfeCASJ4j84qPY9-7-yFUpEtAJQSoxJg@mail.gmail.com>
Subject: Re: Call to discuss vsock netdev/sk_buff [was Re: [PATCH 0/6]
 virtio/vsock: introduce dgrams, sk_buff, and qdisc]
To:     Bobby Eshleman <bobbyeshleman@gmail.com>
Cc:     Dexuan Cui <decui@microsoft.com>, Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Bobby Eshleman <bobby.eshleman@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 9, 2022 at 8:13 PM Bobby Eshleman <bobbyeshleman@gmail.com> wrote:
>
> Hey Stefano, thanks for sending this out.
>
> On Thu, Sep 08, 2022 at 04:36:52PM +0200, Stefano Garzarella wrote:
> >
> > Looking better at the KVM forum sched, I found 1h slot for Sep 15 at 16:30
> > UTC.
> >
> > Could this work for you?
>
> Unfortunately, I can't make this time slot.

No problem at all!

>
> My schedule also opens up a lot the week of the 26th, especially between
> 16:00 and 19:00 UTC, as well as after 22:00 UTC.

Great, that week works for me too.
What about Sep 27 @ 16:00 UTC?

Thanks,
Stefano

