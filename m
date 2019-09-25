Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A97DFBD96D
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 09:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442662AbfIYH63 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 03:58:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59113 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437273AbfIYH63 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 03:58:29 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CE6778830A;
        Wed, 25 Sep 2019 07:58:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C514F60872;
        Wed, 25 Sep 2019 07:58:28 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id B0BA21808876;
        Wed, 25 Sep 2019 07:58:28 +0000 (UTC)
Date:   Wed, 25 Sep 2019 03:58:28 -0400 (EDT)
From:   Pankaj Gupta <pagupta@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Sergio Lopez <slp@redhat.com>, qemu-devel@nongnu.org,
        mst@redhat.com, imammedo@redhat.com,
        marcel apfelbaum <marcel.apfelbaum@gmail.com>,
        pbonzini@redhat.com, rth@twiddle.net, ehabkost@redhat.com,
        philmd@redhat.com, lersek@redhat.com, kraxel@redhat.com,
        mtosatti@redhat.com, kvm@vger.kernel.org
Message-ID: <432023601.2927575.1569398308205.JavaMail.zimbra@redhat.com>
In-Reply-To: <c689e275-1a05-7d08-756b-0be914ed24ca@redhat.com>
References: <20190924124433.96810-1-slp@redhat.com> <c689e275-1a05-7d08-756b-0be914ed24ca@redhat.com>
Subject: Re: [PATCH v4 0/8] Introduce the microvm machine type
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.116.223, 10.4.195.3]
Thread-Topic: Introduce the microvm machine type
Thread-Index: VOfRsAtu2e4i6aDKaq9jV9YIctSiGA==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Wed, 25 Sep 2019 07:58:28 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> On 24.09.19 14:44, Sergio Lopez wrote:
> > Microvm is a machine type inspired by both NEMU and Firecracker, and
> > constructed after the machine model implemented by the latter.
> > 
> > It's main purpose is providing users a minimalist machine type free
> > from the burden of legacy compatibility, serving as a stepping stone
> > for future projects aiming at improving boot times, reducing the
> > attack surface and slimming down QEMU's footprint.
> > 
> > The microvm machine type supports the following devices:
> > 
> >  - ISA bus
> >  - i8259 PIC
> >  - LAPIC (implicit if using KVM)
> >  - IOAPIC (defaults to kernel_irqchip_split = true)
> >  - i8254 PIT
> >  - MC146818 RTC (optional)
> >  - kvmclock (if using KVM)
> >  - fw_cfg
> >  - One ISA serial port (optional)
> >  - Up to eight virtio-mmio devices (configured by the user)
> 
> So I assume also no ACPI (CPU/memory hotplug), correct?
> 
> @Pankaj, I think it would make sense to make virtio-pmem play with
> virtio-mmio/microvm.

I agree. Its using virtio-blk device over a raw image.
Similarly or alternatively(as an experiment) we can use virtio-pmem
which will even reduce the guest memory footprint. 

Best regards,
Pankaj

> 
> --
> 
> Thanks,
> 
> David / dhildenb
> 
