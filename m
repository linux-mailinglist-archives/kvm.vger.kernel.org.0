Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7A0292C68
	for <lists+kvm@lfdr.de>; Mon, 19 Oct 2020 19:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730897AbgJSRPF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Oct 2020 13:15:05 -0400
Received: from mail.efficios.com ([167.114.26.124]:34144 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730646AbgJSRPF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Oct 2020 13:15:05 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id AADCB2707BD;
        Mon, 19 Oct 2020 13:15:03 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id QTruwX3BYTn2; Mon, 19 Oct 2020 13:15:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 284FE270752;
        Mon, 19 Oct 2020 13:15:03 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 284FE270752
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1603127703;
        bh=a4Kyq9ggmnqJgL1OMZgiL3YI8Vq7lTIeBQc5QZoN7D4=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=Rleo5KpYLxJL9bE+eS/IDKaOFoEmvkq70bRu+JU0FvBo/l/SmYGCBDQs+xaFOFVHh
         BJLQKLA6tCK8ZaIUWSrsP9eNGLLZGdYFBrCmdjHdnSkKFJRiWBCddq7bINqO1JrS6z
         LiDZeRjCGch2dLFOuXwqHnn+Ivxs2sOrIF5lAwNdQIXqAC1yn7Wcp2M95eK+hTAjh2
         2bA+wXNULdWuS9DpiktZT7bNyAwruDfMklfP+qTv7VM9LXYilPo5xXvaq8H58JbRBX
         xy5xAXA9Jfvdh96AGWs2I075RgU0Y4TmN5l6CqHVGnXdNU7ZWMEVZ3OrX5Vg/g/cFz
         WJ9MFFce5aMuQ==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id yP-ztTyztNwI; Mon, 19 Oct 2020 13:15:03 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 0FA782707BC;
        Mon, 19 Oct 2020 13:15:03 -0400 (EDT)
Date:   Mon, 19 Oct 2020 13:15:02 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Jann Horn <jannh@google.com>,
        "Catangiu, Adrian Costin" <acatan@amazon.com>,
        Jason Donenfeld <Jason@zx2c4.com>,
        Theodore Tso <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>,
        Eric Biggers <ebiggers@kernel.org>,
        "open list, DOCUMENTATION" <linux-doc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        "Graf (AWS), Alexander" <graf@amazon.de>,
        "MacCarthaigh, Colm" <colmmacc@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>, bonzini@gnu.org,
        "Singh, Balbir" <sblbir@amazon.com>,
        "Weiss, Radu" <raduweis@amazon.com>, oridgar@gmail.com,
        ghammer@redhat.com, Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        mst@redhat.com, qemu-devel@nongnu.org,
        KVM list <kvm@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        linux-api <linux-api@vger.kernel.org>
Message-ID: <476895871.28084.1603127702969.JavaMail.zimbra@efficios.com>
In-Reply-To: <CALCETrViTg_BWvRa+nfDWq=_B_ithzL-anVJNpsgHaXe9VgCNQ@mail.gmail.com>
References: <788878CE-2578-4991-A5A6-669DCABAC2F2@amazon.com> <CAG48ez0EanBvDyfthe+hAP0OC8iGLNSq2e5wJVz-=ENNGF97_w@mail.gmail.com> <CALCETrViTg_BWvRa+nfDWq=_B_ithzL-anVJNpsgHaXe9VgCNQ@mail.gmail.com>
Subject: Re: [PATCH] drivers/virt: vmgenid: add vm generation id driver
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3968 (ZimbraWebClient - FF81 (Linux)/8.8.15_GA_3968)
Thread-Topic: drivers/virt: vmgenid: add vm generation id driver
Thread-Index: LGqdszkWAp7MsnjacXz6ZDq20p5wzw==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

----- On Oct 17, 2020, at 2:10 PM, Andy Lutomirski luto@kernel.org wrote:

> On Fri, Oct 16, 2020 at 6:40 PM Jann Horn <jannh@google.com> wrote:
>>
>> [adding some more people who are interested in RNG stuff: Andy, Jason,
>> Theodore, Willy Tarreau, Eric Biggers. also linux-api@, because this
>> concerns some pretty fundamental API stuff related to RNG usage]
>>
>> On Fri, Oct 16, 2020 at 4:33 PM Catangiu, Adrian Costin
>> <acatan@amazon.com> wrote:
>> > - Background
>> >
>> > The VM Generation ID is a feature defined by Microsoft (paper:
>> > http://go.microsoft.com/fwlink/?LinkId=260709) and supported by
>> > multiple hypervisor vendors.
>> >
>> > The feature is required in virtualized environments by apps that work
>> > with local copies/caches of world-unique data such as random values,
>> > uuids, monotonically increasing counters, etc.
>> > Such apps can be negatively affected by VM snapshotting when the VM
>> > is either cloned or returned to an earlier point in time.
>> >
>> > The VM Generation ID is a simple concept meant to alleviate the issue
>> > by providing a unique ID that changes each time the VM is restored
>> > from a snapshot. The hw provided UUID value can be used to
>> > differentiate between VMs or different generations of the same VM.
>> >
>> > - Problem
>> >
>> > The VM Generation ID is exposed through an ACPI device by multiple
>> > hypervisor vendors but neither the vendors or upstream Linux have no
>> > default driver for it leaving users to fend for themselves.
>> >
>> > Furthermore, simply finding out about a VM generation change is only
>> > the starting point of a process to renew internal states of possibly
>> > multiple applications across the system. This process could benefit
>> > from a driver that provides an interface through which orchestration
>> > can be easily done.
>> >
>> > - Solution
>> >
>> > This patch is a driver which exposes the Virtual Machine Generation ID
>> > via a char-dev FS interface that provides ID update sync and async
>> > notification, retrieval and confirmation mechanisms:
>> >
>> > When the device is 'open()'ed a copy of the current vm UUID is
>> > associated with the file handle. 'read()' operations block until the
>> > associated UUID is no longer up to date - until HW vm gen id changes -
>> > at which point the new UUID is provided/returned. Nonblocking 'read()'
>> > uses EWOULDBLOCK to signal that there is no _new_ UUID available.
>> >
>> > 'poll()' is implemented to allow polling for UUID updates. Such
>> > updates result in 'EPOLLIN' events.
>> >
>> > Subsequent read()s following a UUID update no longer block, but return
>> > the updated UUID. The application needs to acknowledge the UUID update
>> > by confirming it through a 'write()'.
>> > Only on writing back to the driver the right/latest UUID, will the
>> > driver mark this "watcher" as up to date and remove EPOLLIN status.
>> >
>> > 'mmap()' support allows mapping a single read-only shared page which
>> > will always contain the latest UUID value at offset 0.
>>
>> It would be nicer if that page just contained an incrementing counter,
>> instead of a UUID. It's not like the application cares *what* the UUID
>> changed to, just that it *did* change and all RNGs state now needs to
>> be reseeded from the kernel, right? And an application can't reliably
>> read the entire UUID from the memory mapping anyway, because the VM
>> might be forked in the middle.
>>
>> So I think your kernel driver should detect UUID changes and then turn
>> those into a monotonically incrementing counter. (Probably 64 bits
>> wide?) (That's probably also a little bit faster than comparing an
>> entire UUID.)
>>
>> An option might be to put that counter into the vDSO, instead of a
>> separate VMA; but I don't know how the other folks feel about that.
>> Andy, do you have opinions on this? That way, normal userspace code
>> that uses this infrastructure wouldn't have to mess around with a
>> special device at all. And it'd be usable in seccomp sandboxes and so
>> on without needing special plumbing. And libraries wouldn't have to
>> call open() and mess with file descriptor numbers.
> 
> The vDSO might be annoyingly slow for this.  Something like the rseq
> page might make sense.  It could be a generic indication of "system
> went through some form of suspend".

This might indeed fit nicely as an extension of my KTLS prototype (extensible rseq):

https://lore.kernel.org/lkml/20200925181518.4141-1-mathieu.desnoyers@efficios.com/

There are a few ways we could wire things up. One might be to add the
UUID field into the extended KTLS structure (so it's always updated after it
changes on next return to user-space). For this I assume that the Linux scheduler
within the guest VM always preempts all threads before a VM is suspended (is that
indeed true ?).

This leads to one important question though: how is the UUID check vs commit operation
made atomic with respect to suspend ? Unless we use rseq critical sections in assembly,
where the kernel will abort the rseq critical section on preemption, I don't see how we
can ensure that the UUID value does not change right after it has been checked, before
the "commit" side-effect. And what is the expected "commit" side-effect ? Is it a store
to a variable in user-space memory, or is it issuing a system call which sends a packet over
the network ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
