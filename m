Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4C625A826
	for <lists+kvm@lfdr.de>; Wed,  2 Sep 2020 10:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgIBI72 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Sep 2020 04:59:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45647 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726167AbgIBI71 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Sep 2020 04:59:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599037165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ix8N6RQtX+ddzBGK9BdRX1rdzssF3CmlZhDLO9SMtGM=;
        b=b9l+xXpd+F65EVf0Z/i3vo6vjpuVw5Ao9e5hHdX6vakZGazxq9C86hzZqeF9WRCrI2Vlp2
        woRpit85edeueVJCjAtGrTAwcFlIQhYSm2A4M7iIBrdpNMgtk7ECUoraMLz3tDxqalmS9k
        upxjpjkptnbtFovfXqqFm9H5w23vyeg=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-rb_rFs2aMIqiyGhL-xkGtQ-1; Wed, 02 Sep 2020 04:59:23 -0400
X-MC-Unique: rb_rFs2aMIqiyGhL-xkGtQ-1
Received: by mail-ed1-f70.google.com with SMTP id n4so1876351edo.20
        for <kvm@vger.kernel.org>; Wed, 02 Sep 2020 01:59:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Ix8N6RQtX+ddzBGK9BdRX1rdzssF3CmlZhDLO9SMtGM=;
        b=i+0Dz/h/FkN9BoKcRoPQzCXQjDCPc4kMi+2VsbbkhdpV5jxyojFntpqe0whmQAG1Gj
         jyKEnLDftPMyBZh2GMyLv/2pMQFnlWU6ue1boBl/b35mZxdYdYirJTcgDFrgQyvNZccy
         m/sxp9/xGgaZ3g4f5XJQCV0gc0FbFNCJT7QEMkGpS0vXFDU6KVnVp7+6quGgSeA7/+z1
         y9WWqYPtmksddbhF4IvOKpxjrGJd7aU8A5JwqEY8VCCR2jMEWh2fZJE8YAnnZwjlsONF
         j/nxMl6cq7WrY35mWjHDZ/XvK0Mt4aIiiNuOh+GVW66ERyspawXVlua/mRJIMYH17yn0
         M3Ew==
X-Gm-Message-State: AOAM532UkQZsiLN/+bhx8Mp1ysrNv7Oc9PJuLEPtisihKtZinnLXtMy/
        POuJeZsF88TSobXzZIEMDa/36klxe0+HfF26dXW+bo5weM16zxA1gWeDdAec255KBgqMqKT5Lk4
        w/KlEUMLiB1cC
X-Received: by 2002:a17:906:95d1:: with SMTP id n17mr5566894ejy.324.1599037162128;
        Wed, 02 Sep 2020 01:59:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzZ9uG5VoGFj8piU2aeDijZCJLsDj+NsJcm8DJsdt2rZ7X63rZbNnDbaKrAnU8VY81o7E9eaQ==
X-Received: by 2002:a17:906:95d1:: with SMTP id n17mr5566871ejy.324.1599037161896;
        Wed, 02 Sep 2020 01:59:21 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id f13sm3735188ejb.81.2020.09.02.01.59.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 01:59:21 -0700 (PDT)
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
In-Reply-To: <20200901200021.GB3053@xz-x1>
References: <20200807141232.402895-1-vkuznets@redhat.com> <20200825212526.GC8235@xz-x1> <87eenlwoaa.fsf@vitty.brq.redhat.com> <20200901200021.GB3053@xz-x1>
Date:   Wed, 02 Sep 2020 10:59:20 +0200
Message-ID: <877dtcpn9z.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Peter Xu <peterx@redhat.com> writes:

> On Tue, Sep 01, 2020 at 04:43:25PM +0200, Vitaly Kuznetsov wrote:
>> Peter Xu <peterx@redhat.com> writes:
>> 
>> > On Fri, Aug 07, 2020 at 04:12:29PM +0200, Vitaly Kuznetsov wrote:
>> >> When testing Linux kernel boot with QEMU q35 VM and direct kernel boot
>> >> I observed 8193 accesses to PCI hole memory. When such exit is handled
>> >> in KVM without exiting to userspace, it takes roughly 0.000001 sec.
>> >> Handling the same exit in userspace is six times slower (0.000006 sec) so
>> >> the overal; difference is 0.04 sec. This may be significant for 'microvm'
>> >> ideas.
>> >
>> > Sorry to comment so late, but just curious... have you looked at what's those
>> > 8000+ accesses to PCI holes and what they're used for?  What I can think of are
>> > some port IO reads (e.g. upon vendor ID field) during BIOS to scan the devices
>> > attached.  Though those should be far less than 8000+, and those should also be
>> > pio rather than mmio.
>> 
>> And sorry for replying late)
>> 
>> We explicitly want MMIO instead of PIO to speed things up, afaiu PIO
>> requires two exits per device (and we exit all the way to
>> QEMU). Julia/Michael know better about the size of the space.
>> 
>> >
>> > If this is only an overhead for virt (since baremetal mmios should be fast),
>> > I'm also thinking whether we can make it even better to skip those pci hole
>> > reads.  Because we know we're virt, so it also gives us possibility that we may
>> > provide those information in a better way than reading PCI holes in the guest?
>> 
>> This means let's invent a PV interface and if we decide to go down this
>> road, I'd even argue for abandoning PCI completely. E.g. we can do
>> something similar to Hyper-V's Vmbus.
>
> My whole point was more about trying to understand the problem behind.
> Providing a fast path for reading pci holes seems to be reasonable as is,
> however it's just that I'm confused on why there're so many reads on the pci
> holes after all.  Another important question is I'm wondering how this series
> will finally help the use case of microvm.  I'm not sure I get the whole point
> of it, but... if microvm is the major use case of this, it would be good to
> provide some quick numbers on those if possible.
>
> For example, IIUC microvm uses qboot (as a better alternative than seabios) for
> fast boot, and qboot has:
>
> https://github.com/bonzini/qboot/blob/master/pci.c#L20
>
> I'm kind of curious whether qboot will still be used when this series is used
> with microvm VMs?  Since those are still at least PIO based.

I'm afraid there is no 'grand plan' for everything at this moment :-(
For traditional VMs 0.04 sec per boot is negligible and definitely not
worth adding a feature, memory requirements are also very
different. When it comes to microvm-style usage things change.

'8193' PCI hole accesses I mention in the PATCH0 blurb are just from
Linux as I was doing direct kernel boot, we can't get better than that
(if PCI is in the game of course). Firmware (qboot, seabios,...) can
only add more. I *think* the plan is to eventually switch them all to
MMCFG, at least for KVM guests, by default but we need something to put
to the advertisement. 

We can, in theory, short circuit PIO in KVM instead but:
- We will need a complete different API
- We will never be able to reach the speed of the exit-less 'single 0xff
page' solution (see my RFC).

-- 
Vitaly

