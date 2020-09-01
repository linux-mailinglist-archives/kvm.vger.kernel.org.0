Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 534CA259114
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 16:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbgIAOoz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 10:44:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55972 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727961AbgIAOnb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Sep 2020 10:43:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598971409;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GPbP04lPt1v0iZ449hyOji4fcc1kzdBh1pIqDA8zHp0=;
        b=gOu531h+vSTa63ILwVJSxqSS7adtk1Difucur2nq52Dy4+2aaXE4luXI0humDGScXXrGSa
        LcuDFjKCkiMvsoIemEr4UTpT09aUl3nBdVXpXxUi+uxFfTwsc68bN5BNJFhP9TvlDjV2sh
        cs9nSUDBh3CXpnNNRkPzLV9fggs4PX8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-rukXKZP9O6uPiQWR4ShftQ-1; Tue, 01 Sep 2020 10:43:28 -0400
X-MC-Unique: rukXKZP9O6uPiQWR4ShftQ-1
Received: by mail-wr1-f69.google.com with SMTP id c17so668856wrt.12
        for <kvm@vger.kernel.org>; Tue, 01 Sep 2020 07:43:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=GPbP04lPt1v0iZ449hyOji4fcc1kzdBh1pIqDA8zHp0=;
        b=M8594uHSFNGZWgM4riylrpsN6WcHmrk1KgjW/o3Ol5m8+0MI2bCSPpQ7qECBR6U4Ty
         q/LKa0L1A9HCvIGhWcV2G9F74CUqn0b+mmkiG/e6xKZ2Yf/yQCC62yeRAMUfS4PPxWig
         nYti93zkpn1XF2MkEmdkdnVPhylrpat+6E0JkOmcs1LXsIDiu7TeZNlJ2TM4lI91bv08
         IAwY3PmhbVRWdIAdQBK+eSdpd6M1jgGOHx4b7AsYcP+iFrnxrMw5cByMw49arVBkogn/
         NjhV1M22ubwl26X+Hm8ANTBftYnl/kXGLwEEgnttOwag78uXZbdPt1xIcgioA5nL+/zh
         +stA==
X-Gm-Message-State: AOAM532CXI7sVgkzCGQ9mbLYpfjtlbhN9/CHqxV2MgoWo511YgqtcqHx
        3ZBre+H1Tr7rDM+j8TxF5AskeWPPeFyR/FfoTB0Ml/l2LkOQy39+XxIXBvjW6SKpwIA6CmkkJBt
        tSrd/i4/q1EcV
X-Received: by 2002:adf:db52:: with SMTP id f18mr2217330wrj.397.1598971406998;
        Tue, 01 Sep 2020 07:43:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwJzKR8a+SsyTI8zecqTgZ0D4P1NUMXQNbFg4Z1fpLhaO9xme/Gd1HwibnnhuJcxZ1jjgroFg==
X-Received: by 2002:adf:db52:: with SMTP id f18mr2217303wrj.397.1598971406756;
        Tue, 01 Sep 2020 07:43:26 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id p16sm2574255wro.71.2020.09.01.07.43.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 07:43:26 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Tsirkin <mst@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] KVM: x86: KVM_MEM_PCI_HOLE memory
In-Reply-To: <20200825212526.GC8235@xz-x1>
References: <20200807141232.402895-1-vkuznets@redhat.com> <20200825212526.GC8235@xz-x1>
Date:   Tue, 01 Sep 2020 16:43:25 +0200
Message-ID: <87eenlwoaa.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Peter Xu <peterx@redhat.com> writes:

> On Fri, Aug 07, 2020 at 04:12:29PM +0200, Vitaly Kuznetsov wrote:
>> When testing Linux kernel boot with QEMU q35 VM and direct kernel boot
>> I observed 8193 accesses to PCI hole memory. When such exit is handled
>> in KVM without exiting to userspace, it takes roughly 0.000001 sec.
>> Handling the same exit in userspace is six times slower (0.000006 sec) so
>> the overal; difference is 0.04 sec. This may be significant for 'microvm'
>> ideas.
>
> Sorry to comment so late, but just curious... have you looked at what's those
> 8000+ accesses to PCI holes and what they're used for?  What I can think of are
> some port IO reads (e.g. upon vendor ID field) during BIOS to scan the devices
> attached.  Though those should be far less than 8000+, and those should also be
> pio rather than mmio.

And sorry for replying late)

We explicitly want MMIO instead of PIO to speed things up, afaiu PIO
requires two exits per device (and we exit all the way to
QEMU). Julia/Michael know better about the size of the space.

>
> If this is only an overhead for virt (since baremetal mmios should be fast),
> I'm also thinking whether we can make it even better to skip those pci hole
> reads.  Because we know we're virt, so it also gives us possibility that we may
> provide those information in a better way than reading PCI holes in the guest?

This means let's invent a PV interface and if we decide to go down this
road, I'd even argue for abandoning PCI completely. E.g. we can do
something similar to Hyper-V's Vmbus.

-- 
Vitaly

