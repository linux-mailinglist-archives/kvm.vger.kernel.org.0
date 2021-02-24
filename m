Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDBE323F97
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 16:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235774AbhBXOOG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 09:14:06 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:43711 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236769AbhBXNqi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 08:46:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1614174390; x=1645710390;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=qkxlZHYSuW0uj3CmrGOCQGXxaMSVLtWvtFUpmQxIi2g=;
  b=Vc0g2dfki9HRr2MiCBozSW6FZyReB1viHNW7jYHee0tk5+TmJMUHKhsv
   3jR66xMzh4HbTCU8ivI+GrFuKCCxEHG2P1DYItP80L9z2DghHPWTh3mpn
   Ggl7xrBakoikC0LGj+aR9kFCIPzdTBQixF1iniV0VCsw4i9VFsjwIR38A
   M=;
X-IronPort-AV: E=Sophos;i="5.81,203,1610409600"; 
   d="scan'208";a="91706228"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-715bee71.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 24 Feb 2021 13:45:32 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-715bee71.us-east-1.amazon.com (Postfix) with ESMTPS id 2623DA2E61;
        Wed, 24 Feb 2021 13:45:14 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 24 Feb 2021 13:45:13 +0000
Received: from Alexanders-MacBook-Air.local (10.43.161.39) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 24 Feb 2021 13:45:05 +0000
Subject: Re: [PATCH v7 1/2] drivers/misc: sysgenid: add system generation id
 driver
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Adrian Catangiu <acatan@amazon.com>
CC:     <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        <linux-s390@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <rdunlap@infradead.org>, <arnd@arndb.de>, <ebiederm@xmission.com>,
        <rppt@kernel.org>, <0x7f454c46@gmail.com>,
        <borntraeger@de.ibm.com>, <Jason@zx2c4.com>, <jannh@google.com>,
        <w@1wt.eu>, <colmmacc@amazon.com>, <luto@kernel.org>,
        <tytso@mit.edu>, <ebiggers@kernel.org>, <dwmw@amazon.co.uk>,
        <bonzini@gnu.org>, <sblbir@amazon.com>, <raduweis@amazon.com>,
        <corbet@lwn.net>, <mhocko@kernel.org>, <rafael@kernel.org>,
        <pavel@ucw.cz>, <mpe@ellerman.id.au>, <areber@redhat.com>,
        <ovzxemul@gmail.com>, <avagin@gmail.com>,
        <ptikhomirov@virtuozzo.com>, <gil@azul.com>, <asmehra@redhat.com>,
        <dgunigun@redhat.com>, <vijaysun@ca.ibm.com>, <oridgar@gmail.com>,
        <ghammer@redhat.com>
References: <1614156452-17311-1-git-send-email-acatan@amazon.com>
 <1614156452-17311-2-git-send-email-acatan@amazon.com>
 <20210224040516-mutt-send-email-mst@kernel.org>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <d63146a9-a3f8-14ea-2b16-cb5b3fe7aecf@amazon.com>
Date:   Wed, 24 Feb 2021 14:45:03 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210224040516-mutt-send-email-mst@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.43.161.39]
X-ClientProxiedBy: EX13D22UWC003.ant.amazon.com (10.43.162.250) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 24.02.21 10:19, Michael S. Tsirkin wrote:
> =

> On Wed, Feb 24, 2021 at 10:47:31AM +0200, Adrian Catangiu wrote:
>> - Background and problem
>>
>> The System Generation ID feature is required in virtualized or
>> containerized environments by applications that work with local copies
>> or caches of world-unique data such as random values, uuids,
>> monotonically increasing counters, etc.
>> Such applications can be negatively affected by VM or container
>> snapshotting when the VM or container is either cloned or returned to
>> an earlier point in time.
>>
>> Furthermore, simply finding out about a system generation change is
>> only the starting point of a process to renew internal states of
>> possibly multiple applications across the system. This process requires
>> a standard interface that applications can rely on and through which
>> orchestration can be easily done.
>>
>> - Solution
>>
>> The System Generation ID is meant to help in these scenarios by
>> providing a monotonically increasing u32 counter that changes each time
>> the VM or container is restored from a snapshot.
>>
>> The `sysgenid` driver exposes a monotonic incremental System Generation
>> u32 counter via a char-dev filesystem interface accessible
>> through `/dev/sysgenid`. It provides synchronous and asynchronous SysGen
>> counter update notifications, as well as counter retrieval and
>> confirmation mechanisms.
>> The counter starts from zero when the driver is initialized and
>> monotonically increments every time the system generation changes.
>>
>> Userspace applications or libraries can (a)synchronously consume the
>> system generation counter through the provided filesystem interface, to
>> make any necessary internal adjustments following a system generation
>> update.
>>
>> The provided filesystem interface operations can be used to build a
>> system level safe workflow that guest software can follow to protect
>> itself from negative system snapshot effects.
>>
>> The `sysgenid` driver exports the `void sysgenid_bump_generation()`
>> symbol which can be used by backend drivers to drive system generation
>> changes based on hardware events.
>> System generation changes can also be driven by userspace software
>> through a dedicated driver ioctl.
>>
>> **Please note**, SysGenID alone does not guarantee complete snapshot
>> safety to applications using it. A certain workflow needs to be
>> followed at the system level, in order to make the system
>> snapshot-resilient. Please see the "Snapshot Safety Prerequisites"
>> section in the included documentation.
>>
>> Signed-off-by: Adrian Catangiu <acatan@amazon.com>
>> ---
>>   Documentation/misc-devices/sysgenid.rst            | 229 +++++++++++++=
++
>>   Documentation/userspace-api/ioctl/ioctl-number.rst |   1 +
>>   MAINTAINERS                                        |   8 +
>>   drivers/misc/Kconfig                               |  15 +
>>   drivers/misc/Makefile                              |   1 +
>>   drivers/misc/sysgenid.c                            | 322 +++++++++++++=
++++++++
>>   include/uapi/linux/sysgenid.h                      |  18 ++
>>   7 files changed, 594 insertions(+)
>>   create mode 100644 Documentation/misc-devices/sysgenid.rst
>>   create mode 100644 drivers/misc/sysgenid.c
>>   create mode 100644 include/uapi/linux/sysgenid.h
>>

[...]

>> +``ioctl()``:
>> +  The driver also adds support for waiting on open file descriptors
>> +  that haven't acknowledged a generation counter update, as well as a
>> +  mechanism for userspace to *trigger* a generation update:
>> +
>> +  - SYSGENID_SET_WATCHER_TRACKING: takes a bool argument to set tracking
>> +    status for current file descriptor. When watcher tracking is
>> +    enabled, the driver tracks this file descriptor as an independent
>> +    *watcher*. The driver keeps accounting of how many watchers have
>> +    confirmed the latest Sys-Gen-Id counter and how many of them are
>> +    *outdated*; an outdated watcher is a *tracked* open file descriptor
>> +    that has lived through a Sys-Gen-Id change but has not yet confirmed
>> +    the new generation counter.
>> +    Software that wants to be waited on by the system while it adjusts
>> +    to generation changes, should turn tracking on. The sysgenid driver
>> +    then keeps track of it and can block system-level adjustment process
>> +    until the software has finished adjusting and confirmed it through a
>> +    ``write()``.
>> +    Tracking is disabled by default and file descriptors need to
>> +    explicitly opt-in using this IOCTL.
>> +  - SYSGENID_WAIT_WATCHERS: blocks until there are no more *outdated*
>> +    tracked watchers or, if a ``timeout`` argument is provided, until
>> +    the timeout expires.
>> +    If the current caller is *outdated* or a generation change happens
>> +    while waiting (thus making current caller *outdated*), the ioctl
>> +    returns ``-EINTR`` to signal the user to handle event and retry.
>> +  - SYSGENID_TRIGGER_GEN_UPDATE: triggers a generation counter incremen=
t.
>> +    It takes a ``minimum-generation`` argument which represents the
>> +    minimum value the generation counter will be set to. For example if
>> +    current generation is ``5`` and ``SYSGENID_TRIGGER_GEN_UPDATE(8)``
>> +    is called, the generation counter will increment to ``8``.
> =

> And what if it's 9?

Then it becomes 10. The hint only tells you what the smallest version =

the system is matching against is.

The only thing I have a slight concern over here is an overflow. What if =

my generation id is 0x7fffffff? For starters, it'd probably be better to =

treat the counter as ulong so it matches the atomic_t, no?

But then you would still have the same situation, just with a wrap to 0 =

instead of a wrap to negative. I guess the answer is "users of this API =

will not get a guarantee that the counters are monotonically increasing. =

They have to check for !=3D instead of < or >".

> =

>> +    This IOCTL can only be used by processes with CAP_CHECKPOINT_RESTORE
>> +    or CAP_SYS_ADMIN capabilities.
>> +
>> +``mmap()``:
>> +  The driver supports ``PROT_READ, MAP_SHARED`` mmaps of a single page
>> +  in size. The first 4 bytes of the mapped page will contain an
>> +  up-to-date u32 copy of the system generation counter.
>> +  The mapped memory can be used as a low-latency generation counter
>> +  probe mechanism in critical sections.
>> +  The mmap() interface is targeted at libraries or code that needs to
>> +  check for generation changes in-line, where an event loop is not
>> +  available or read()/write() syscalls are too expensive.
>> +  In such cases, logic can be added in-line with the sensitive code to
>> +  check and trigger on-demand/just-in-time readjustments when changes
>> +  are detected on the memory mapped generation counter.
>> +  Users of this interface that plan to lazily adjust should not enable
>> +  watcher tracking, since waiting on them doesn't make sense.
>> +
>> +``close()``:
>> +  Removes the file descriptor as a system generation counter *watcher*.
>> +
>> +Snapshot Safety Prerequisites
>> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
>> +
>> +If VM, container or other system-level snapshots happen asynchronously,
>> +at arbitrary times during an active workload there is no practical way
>> +to ensure that in-flight local copies or caches of world-unique data
>> +such as random values, secrets, UUIDs, etc are properly scrubbed and
>> +regenerated.
>> +The challenge stems from the fact that the categorization of data as
>> +snapshot-sensitive is only known to the software working with it, and
>> +this software has no logical control over the moment in time when an
>> +external system snapshot occurs.
>> +
>> +Let's take an OpenSSL session token for example. Even if the library
>> +code is made 100% snapshot-safe, meaning the library guarantees that
>> +the session token is unique (any snapshot that happened during the
>> +library call did not duplicate or leak the token), the token is still
>> +vulnerable to snapshot events while it transits the various layers of
>> +the library caller, then the various layers of the OS before leaving
>> +the system.
>> +
>> +To catch a secret while it's in-flight, we'd have to validate system
>> +generation at every layer, every step of the way. Even if that would
>> +be deemed the right solution, it would be a long road and a whole
>> +universe to patch before we get there.
>> +
>> +Bottom line is we don't have a way to track all of these in-flight
>> +secrets and dynamically scrub them from existence with snapshot
>> +events happening arbitrarily.
> =

> Above should try harder to explan what are the things that need to be
> scrubbed and why. For example, I personally don't really know what is
> the OpenSSL session token example and what makes it vulnerable. I guess
> snapshots can attack each other?
> =

> =

> =

> =

> Here's a simple example of a workflow that submits transactions
> to a database and wants to avoid duplicate transactions.
> This does not require overseer magic. It does however require
> a correct genid from hypervisor, so no mmap tricks work.
> =

> =

> =

>          int genid, oldgenid;
>          read(&genid);
> start:
>          oldgenid =3D genid;
>          transid =3D submit transaction
>          read(&genid);
>          if (genid !=3D oldgenid) {
>                          revert transaction (transid);
>                          goto start:
>          }

I'm not sure I fully follow. For starters, if this is a VM local =

database, I don't think you'd care about the genid. If it's a remote =

database, your connection would get dropped already at the point when =

you clone/resume, because TCP and your connection state machine will get =

really confused when you suddenly have a different IP address or two =

consumers of the same stream :).

But for the sake of the argument, let's assume you can have a =

connectionless database connection that maintains its own connection =

uniqueness logic. That database connector would need to understand how =

to abort the connection (and thus the transaction!) when the generation =

changes. And that's logic you would do with the read/write/notify =

mechanism. So your main loop would check for reads on the genid fd and =

after sending a connection termination, notify the overlord that it's =

safe to use the VM now.

The OpenSSL case (with mmap) is for libraries that are stateless and can =

not guarantee that they receive a genid notification event timely.

Since you asked, this is mainly important for the PRNG. Imagine an https =

server. You create a snapshot. You resume from that snapshot. OpenSSL is =

fully initialized with a user space PRNG randomness pool that it =

considers safe to consume. However, that means your first connection =

after resume will be 100% predictable randomness wise.

The mmap mechanism allows the PRNG to reseed after a genid change. =

Because we don't have an event mechanism for this code path, that can =

happen minutes after the resume. But that's ok, we "just" have to ensure =

that nobody is consuming secret data at the point of the snapshot.

> =

> =

> =

> =

> =

> =

>> +Simplifyng assumption - safety prerequisite
>> +-------------------------------------------
>> +
>> +**Control the snapshot flow**, disallow snapshots coming at arbitrary
>> +moments in the workload lifetime.
>> +
>> +Use a system-level overseer entity that quiesces the system before
>> +snapshot, and post-snapshot-resume oversees that software components
>> +have readjusted to new environment, to the new generation. Only after,
>> +will the overseer un-quiesce the system and allow active workloads.
>> +
>> +Software components can choose whether they want to be tracked and
>> +waited on by the overseer by using the ``SYSGENID_SET_WATCHER_TRACKING``
>> +IOCTL.
>> +
>> +The sysgenid framework standardizes the API for system software to
>> +find out about needing to readjust and at the same time provides a
>> +mechanism for the overseer entity to wait for everyone to be done, the
>> +system to have readjusted, so it can un-quiesce.
>> +
>> +Example snapshot-safe workflow
>> +------------------------------
>> +
>> +1) Before taking a snapshot, quiesce the VM/container/system. Exactly
>> +   how this is achieved is very workload-specific, but the general
>> +   description is to get all software to an expected state where their
>> +   event loops dry up and they are effectively quiesced.
> =

> If you have ability to do this by communicating with
> all processes e.g. through a unix domain socket,
> why do you need the rest of the stuff in the kernel?
> Quescing is a harder problem than waking up.

That depends. Think of a typical VM workload. Let's take the web server =

example again. You can preboot the full VM and snapshot it as is. As =

long as you don't allow any incoming connections, you can guarantee that =

the system is "quiesced" well enough for the snapshot.

This is really what this bullet point is about. The point is that you're =

not consuming randomness you can't reseed asynchronously (see the above =

OpenSSL PRNG example).


Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



