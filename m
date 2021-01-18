Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B82F2FA4BC
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 16:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405859AbhARP2b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 10:28:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405843AbhARP2T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jan 2021 10:28:19 -0500
Received: from mail-vk1-xa2d.google.com (mail-vk1-xa2d.google.com [IPv6:2607:f8b0:4864:20::a2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B50AC061575
        for <kvm@vger.kernel.org>; Mon, 18 Jan 2021 07:27:36 -0800 (PST)
Received: by mail-vk1-xa2d.google.com with SMTP id a6so4047633vkb.8
        for <kvm@vger.kernel.org>; Mon, 18 Jan 2021 07:27:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F6KA9w3XTyDzR9a/eJiRfa89v7fUgs4kNlqtUAh2eRs=;
        b=LIhPXBoQ0lqZVjwUYNyS926s6D2uM+E4QTstoVoyx4n/7hogHhwpwSIBj+IPlC8YRN
         h3oF2QH8WoW7n66iWRccB6P28cnjAoaZFh9Ihuo4M2y2hnwgm269UEf0c7HlVrmhnE+9
         KJYq1eh3iCo2cSAphPIo6nJjawFJTfFVbF/c7O13aAsmJxFnegxLSNNkU62oqpaWFTiB
         V89AL0U1zhHAjVLfhYgFjt5j4ESe5y8dRSW3qJC3WKQ7QQ4pcRzH5pRi6LJUi78Ft/Ka
         uIHf3k+LMjIxLol3HyKVPi8GWfs3cxxk1fX9BduFukj4m0ZBJOyjaKxOf48FB7EvZ4B5
         EK+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F6KA9w3XTyDzR9a/eJiRfa89v7fUgs4kNlqtUAh2eRs=;
        b=cLTTMt6Uh5NeVL4Uo8vsLO9Aqf2s12cLAYb2KLDHVgFNsM4Wq2EXFvupqSXt7a2Ykv
         EB7FgUENK77UrYCzWlMePndBzhAhldt9wiWmXBPs8gjerj6cj6FqTpb4HdC9K76jSDdj
         y0E2IYUmAx7i0FIr/W1e2JVZW5qWQalxscXLSC996wUCGKmmMtYnOr6zrozEFG20RLGM
         IMx3kscpjsMVVQ74KwCBr8ksgRjYyEJjdDRF0p9Hv5oizfMWEapu6TT8WjVVmAZb0kWs
         MlJ2dTNgfo5boI9t2MJ9FZC/tqa9/bwEGa7oYi29MGxvA1ut92UpL1kxVxUMpHR0ijLE
         DvOw==
X-Gm-Message-State: AOAM530NZTeSjoIvinDtX2mzoSw5XW0x5JexCVS3qQMLCCGTiEOdfmZN
        SNgUHevjzId3Y6/JDQEeX9+2UXNWrJ0=
X-Google-Smtp-Source: ABdhPJzMyAYpEpUCAFJx403oXmba/o199I51YwR/pGn2pKMioNUCAdNr1JBH9I0PlB+o6qqaPgBFQg==
X-Received: by 2002:a1f:2d01:: with SMTP id t1mr243153vkt.8.1610983654910;
        Mon, 18 Jan 2021 07:27:34 -0800 (PST)
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com. [209.85.222.42])
        by smtp.gmail.com with ESMTPSA id w65sm2482932vke.55.2021.01.18.07.27.34
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 07:27:34 -0800 (PST)
Received: by mail-ua1-f42.google.com with SMTP id 43so3107906uag.12
        for <kvm@vger.kernel.org>; Mon, 18 Jan 2021 07:27:34 -0800 (PST)
X-Received: by 2002:ab0:7386:: with SMTP id l6mr17924882uap.141.1610983234282;
 Mon, 18 Jan 2021 07:20:34 -0800 (PST)
MIME-Version: 1.0
References: <20210112194143.1494-1-yuri.benditovich@daynix.com>
 <CAOEp5OejaX4ZETThrj4-n8_yZoeTZs56CBPHbQqNsR2oni8dWw@mail.gmail.com>
 <CAOEp5Oc5qif_krU8oC6qhq6X0xRW-9GpWrBzWgPw0WevyhT8Mg@mail.gmail.com>
 <CA+FuTSfhBZfEf8+LKNUJQpSxt8c5h1wMpARupekqFKuei6YBsA@mail.gmail.com>
 <78bbc518-4b73-4629-68fb-2713250f8967@redhat.com> <CA+FuTSfJJhEYr6gXmjpjjXzg6Xm5wWa-dL1SEV-Zt7RcPXGztg@mail.gmail.com>
 <8ea218a8-a068-1ed9-929d-67ad30111c3c@redhat.com> <CAOEp5OfyHz2rXHmOeojNNE2wvrHMn_z1egr5aGQborEq829TLw@mail.gmail.com>
 <65fe1a40-abc0-77ed-56df-3f0a70615016@redhat.com> <CAOEp5Oe4TcOukJa+OGj-ynfMMrZC=_YQDpzSC9_9p+UXSH7hmg@mail.gmail.com>
In-Reply-To: <CAOEp5Oe4TcOukJa+OGj-ynfMMrZC=_YQDpzSC9_9p+UXSH7hmg@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 18 Jan 2021 10:19:57 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfsFC0DTFhHDwT7dbtWXTmGOWjc=ozt8CgH_qDDn9gejg@mail.gmail.com>
Message-ID: <CA+FuTSfsFC0DTFhHDwT7dbtWXTmGOWjc=ozt8CgH_qDDn9gejg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/7] Support for virtio-net hash reporting
To:     Yuri Benditovich <yuri.benditovich@daynix.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>, decui@microsoft.com,
        cai@lca.pw, Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        bpf <bpf@vger.kernel.org>, Yan Vugenfirer <yan@daynix.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > >>>>> What it does not give is a type indication, such as
> > >>>>> VIRTIO_NET_HASH_TYPE_TCPv6. I don't understand how this would be used.
> > >>>>> In datapaths where the NIC has already computed the four-tuple hash
> > >>>>> and stored it in skb->hash --the common case for servers--, That type
> > >>>>> field is the only reason to have to compute again.
> > >>>> The problem is there's no guarantee that the packet comes from the NIC,
> > >>>> it could be a simple VM2VM or host2VM packet.
> > >>>>
> > >>>> And even if the packet is coming from the NIC that calculates the hash
> > >>>> there's no guarantee that it's the has that guest want (guest may use
> > >>>> different RSS keys).
> > >>> Ah yes, of course.
> > >>>
> > >>> I would still revisit the need to store a detailed hash_type along with
> > >>> the hash, as as far I can tell that conveys no actionable information
> > >>> to the guest.
> > >>
> > >> Yes, need to figure out its usage. According to [1], it only mention
> > >> that storing has type is a charge of driver. Maybe Yuri can answer this.
> > >>
> > > For the case of Windows VM we can't know how exactly the network stack
> > > uses provided hash data (including hash type). But: different releases
> > > of Windows
> > > enable different hash types (for example UDP hash is enabled only on
> > > Server 2016 and up).
> > >
> > > Indeed the Windows requires a little more from the network adapter/driver
> > > than Linux does.
> > >
> > > The addition of RSS support to virtio specification takes in account
> > > the widest set of
> > > requirements (i.e. Windows one), our initial impression is that this
> > > should be enough also for Linux.
> > >
> > > The NDIS specification in part of RSS is _mandatory_ and there are
> > > certification tests
> > > that check that the driver provides the hash data as expected. All the
> > > high-performance
> > > network adapters have such RSS functionality in the hardware.

Thanks for the context.

If Windows requires the driver to pass the hash-type along with the
hash data, then indeed this will be needed.

If it only requires the device to support a subset of of the possible
types, chosen at init, that would be different and it would be cheaper
for the driver to pass this config to the device one time.

> > > With pre-RSS QEMU (i.e. where the virtio-net device does not indicate
> > > the RSS support)
> > > the virtio-net driver for Windows does all the job related to RSS:
> > > - hash calculation
> > > - hash/hash_type delivery
> > > - reporting each packet on the correct CPU according to RSS settings
> > >
> > > With RSS support in QEMU all the packets always come on a proper CPU and
> > > the driver never needs to reschedule them. The driver still need to
> > > calculate the
> > > hash and report it to Windows. In this case we do the same job twice: the device
> > > (QEMU or eBPF) does calculate the hash and get proper queue/CPU to deliver
> > > the packet. But the hash is not delivered by the device, so the driver needs to
> > > recalculate it and report to the Windows.
> > >
> > > If we add HASH_REPORT support (current set of patches) and the device
> > > indicates this
> > > feature we can avoid hash recalculation in the driver assuming we
> > > receive the correct hash
> > > value and hash type. Otherwise the driver can't know which exactly
> > > hash the device has calculated.
> > >
> > > Please let me know if I did not answer the question.
> >
> >
> > I think I get you. The hash type is also a kind of classification (e.g
> > TCP or UDP). Any possibility that it can be deduced from the driver? (Or
> > it could be too expensive to do that).
> >
> The driver does it today (when the device does not offer any features)
> and of course can continue doing it.
> IMO if the device can't report the data according to the spec it
> should not indicate support for the respective feature (or fallback to
> vhost=off).
> Again, IMO if Linux does not need the exact hash_type we can use (for
> Linux) the way that Willem de Brujin suggested in his patchset:
> - just add VIRTIO_NET_HASH_REPORT_L4 to the spec
> - Linux can use MQ + hash delivery (and use VIRTIO_NET_HASH_REPORT_L4)
> - Linux can use (if makes sense) RSS with VIRTIO_NET_HASH_REPORT_L4 and eBPF
> - Windows gets what it needs + eBPF
> So, everyone has what they need at the respective cost.
>
> Regarding use of skb->cb for hash type:
> Currently, if I'm not mistaken, there are 2 bytes at the end of skb->cb:
> skb->cb is 48 bytes array
> There is skb_gso_cb (14 bytes) at offset SKB_GSO_CB_OFFSET(32)
> Is it possible to use one of these 2 bytes for hash_type?
> If yes, shall we extend the skb_gso_cb and place the 1-bytes hash_type
> in it or just emit compilation error if the skb_gso_cb grows beyond 15
> bytes?

Good catch on segmentation taking place between .ndo_select_queue and
.ndo_start_xmit.

That also means that whatever field in the skb is used, has to be
copied to all segments in skb_segment. Which happens for cb. But this
feature is completely unrelated to the skb_gso_cb type. Perhaps
another field with a real type is more clear. For instance, an
extension to the union with napi_id and sender_cpu, as neither is used
in this egress path with .ndo_select_queue?
