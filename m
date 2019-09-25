Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2FBBDC67
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 12:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390296AbfIYKvG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 06:51:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48350 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728168AbfIYKvG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 06:51:06 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A9F2A10DCC93;
        Wed, 25 Sep 2019 10:51:05 +0000 (UTC)
Received: from [10.36.117.14] (ovpn-117-14.ams2.redhat.com [10.36.117.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 148A361F24;
        Wed, 25 Sep 2019 10:50:52 +0000 (UTC)
Subject: Re: when to use virtio (was Re: [PATCH v4 0/8] Introduce the microvm
 machine type)
To:     Paolo Bonzini <pbonzini@redhat.com>, Sergio Lopez <slp@redhat.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, imammedo@redhat.com,
        marcel.apfelbaum@gmail.com, rth@twiddle.net, ehabkost@redhat.com,
        philmd@redhat.com, lersek@redhat.com, kraxel@redhat.com,
        mtosatti@redhat.com, kvm@vger.kernel.org,
        Pankaj Gupta <pagupta@redhat.com>
References: <20190924124433.96810-1-slp@redhat.com>
 <c689e275-1a05-7d08-756b-0be914ed24ca@redhat.com> <87h850ssnb.fsf@redhat.com>
 <b361be48-d490-ac6a-4b54-d977c20539c0@redhat.com>
 <231f9f20-ae88-c46b-44da-20b610420e0c@redhat.com>
 <77a157c4-5f43-5c70-981c-20e5a31a4dd1@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 SE+xAvmumFBY
Organization: Red Hat GmbH
Message-ID: <a7001a14-3a50-b45e-a3fb-bee4c3b363db@redhat.com>
Date:   Wed, 25 Sep 2019 12:50:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <77a157c4-5f43-5c70-981c-20e5a31a4dd1@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.64]); Wed, 25 Sep 2019 10:51:05 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25.09.19 12:19, Paolo Bonzini wrote:
> This is a tangent, but I was a bit too harsh in my previous message (at
> least it made you laugh rather than angry!) so I think I owe you an
> explanation.

It's hard to make me really angry, you have to try better :) However,
after years of working on VMs, VM memory management and Linux MM, I
learned that things are horribly complicated - it's not obvious so I
can't expect all people to know what I learned.

> 
> On 25/09/19 10:44, David Hildenbrand wrote:
>> I consider virtio the silver bullet whenever we want a mature
>> paravirtualized interface across architectures. And you can tell that
>> I'm not the only one by the huge amount of virtio device people are
>> crafting right now.
> 
> Given there are hardware implementation of virtio, I would refine that:
> virtio is a silver bullet whenever we want a mature ring buffer
> interface across architectures.  Being friendly to virtualization is by
> now only a detail of virtio.  It is also not exclusive to virtio, for
> example NVMe 1.3 has incorporated some ideas from Xen and virtio and is
> also virtualization-friendly.
> 
> In turn, the ring buffer interface is great if you want to have mostly
> asynchronous operation---if not, the ring buffer is just adding
> complexity.  Sure, we have the luxury of abstractions and powerful
> computers that hide most of the complexity, but some of it still lurks
> in the form of race conditions.
> 
> So the question for virtio-mem is what makes asynchronous operation
> important for memory hotplug?  If I understand the virtio-mem driver,
> all interaction with the virtio device happens through a work item,
> meaning that it is strictly synchronous.  At this point, you do not need
> a ring buffer, you only need:

So, the main building pieces virtio-mem uses as of now in the virtio
infrastructure are the config space and one virtqueue.

a) A way for the host to send requests to the guest. E.g., request a
certain amount of memory to be plugged/unplugged by the guest. Done via
config space updates (e.g., similar to virtio-balloon
inflation/deflation requests).
b) A way for the guest to communicate with the host. E.g., send
plug/unplug requests to plug/unplug separate memory blocks. Done via a
virtqueue. Similar to inflation/deflation of pages in virtio-balloon.

Requests by the host via the config space are processed asynchronously
by the guest (again, similar to - say - virtio-balloon). Guest requests
are currently processed synchronously by the host.

Guest: Can I plug this block?
Host: Sorry, No can do.

Can't tell if there might be extensions (if virtio-mem ever comes to
life ;) ) that might make use of asynchronous communication. Especially,
there might be asynchronous/multiple guest->host requests at some point
(e.g., "I'm nearly out of memory, please send help").

So yes, currently we could live without the ring buffer. But the config
space and the virtqueue are real life-savers for me right now :)

> 
> - a command register where you write the address of a command buffer.
> The device will do DMA from the command block, do whatever it has to do,
> DMA back the results, and trigger an interrupt.
> 
> - an interrupt mechanism.  It could be MSI, or it could be an interrupt
> pending/interrupt acknowledge register if all the hardware offers is
> level-triggered interrupts.
> 
> I do agree that virtio-mem's command buffer/DMA architecture is better
> than the more traditional "bunch of hardware registers" architecture
> that QEMU uses for its ACPI-based CPU and memory hotplug controllers.
> But that's because command buffer/DMA is what actually defines a good
> paravirtualized interface; virtio is a superset of that that may not be
> always a good solution.
> 

I completely agree to what you say here, virtio comes with complexity,
but also with features (e.g., config space, support for multiple queues,
abstraction of transports).

Say, I would only want to expose a DIMM to the guest just like via ACPI,
virtio would clearly not be the right choice.

-- 

Thanks,

David / dhildenb
