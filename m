Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18671BD9FD
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 10:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442814AbfIYIhn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 04:37:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40432 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438957AbfIYIhm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 04:37:42 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 94FED308AA12;
        Wed, 25 Sep 2019 08:37:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8BB1160872;
        Wed, 25 Sep 2019 08:37:42 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 774AD1808876;
        Wed, 25 Sep 2019 08:37:42 +0000 (UTC)
Date:   Wed, 25 Sep 2019 04:37:42 -0400 (EDT)
From:   Pankaj Gupta <pagupta@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Sergio Lopez <slp@redhat.com>, ehabkost@redhat.com,
        kvm@vger.kernel.org, mst@redhat.com, lersek@redhat.com,
        mtosatti@redhat.com, qemu-devel@nongnu.org, kraxel@redhat.com,
        pbonzini@redhat.com, imammedo@redhat.com, philmd@redhat.com,
        rth@twiddle.net
Message-ID: <1911476948.2948619.1569400662114.JavaMail.zimbra@redhat.com>
In-Reply-To: <3162a686-90c8-9ace-0258-37464390ca45@redhat.com>
References: <20190924124433.96810-1-slp@redhat.com> <c689e275-1a05-7d08-756b-0be914ed24ca@redhat.com> <87h850ssnb.fsf@redhat.com> <3162a686-90c8-9ace-0258-37464390ca45@redhat.com>
Subject: Re: [PATCH v4 0/8] Introduce the microvm machine type
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.116.223, 10.4.195.3]
Thread-Topic: Introduce the microvm machine type
Thread-Index: REiSp/FSnA9gx3Er3v5VaYMdGNUqFQ==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Wed, 25 Sep 2019 08:37:42 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> >>> Microvm is a machine type inspired by both NEMU and Firecracker, and
> >>> constructed after the machine model implemented by the latter.
> >>>
> >>> It's main purpose is providing users a minimalist machine type free
> >>> from the burden of legacy compatibility, serving as a stepping stone
> >>> for future projects aiming at improving boot times, reducing the
> >>> attack surface and slimming down QEMU's footprint.
> >>>
> >>> The microvm machine type supports the following devices:
> >>>
> >>>  - ISA bus
> >>>  - i8259 PIC
> >>>  - LAPIC (implicit if using KVM)
> >>>  - IOAPIC (defaults to kernel_irqchip_split = true)
> >>>  - i8254 PIT
> >>>  - MC146818 RTC (optional)
> >>>  - kvmclock (if using KVM)
> >>>  - fw_cfg
> >>>  - One ISA serial port (optional)
> >>>  - Up to eight virtio-mmio devices (configured by the user)
> >>
> >> So I assume also no ACPI (CPU/memory hotplug), correct?
> > 
> > Correct.
> > 
> >> @Pankaj, I think it would make sense to make virtio-pmem play with
> >> virtio-mmio/microvm.
> > 
> > That would be great. I'm also looking forward for virtio-mem (and an
> > hypothetical virtio-cpu) to eventually gain hotplug capabilities in
> > microvm.
> 
> @Pankaj, do you have time to look into the virtio-pmem thingy? I guess
> the virtio-mmio rapper shouldn't be too hard (very similar to the
> virtio-pci wrapper - luckily I insisted to make it work independently
> from PCI BARs and ACPI slots ;) ). The microvm bits would be properly
> setting up device memory and wiring up the hotplug handlers, similar as
> done in the other PC machine types (maybe that comes for free?).

Yes, I can look at.

> 
> virtio-pmem will allow (in read-only mode) to place the rootfs on a fake
> NVDIMM, as done e.g., in kata containers. We might have to include the
> virtio-pmem kernel module in the initramfs, shouldn't  be too hard. Not
> sure what else we'll need to make virtio-pmem get used as a rootfs.

Sure, will work on it.

Thanks,
Pankaj

> 
> > 
> > Thanks,
> > Sergio.
> > 
> 
> 
> --
> 
> Thanks,
> 
> David / dhildenb
> 
> 
