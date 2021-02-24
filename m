Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70AB2324776
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 00:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236250AbhBXXXm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 18:23:42 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:10574 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236237AbhBXXXl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 18:23:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1614209020; x=1645745020;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=ajbqqzyw00MhpTl6JbnnxX80P4gpbBT5SgRo7F/hXQg=;
  b=V76yx5iRokjnNjF9M8sjQfHt9Wte/qzDVXnW/eejH2XDKvo2nA7Lc5nX
   PbXpoCeC/MOLrb4AopB82Tk6bflDaMAjR6ZRK2Yfk/EE7Qm2do05iwjXo
   bLS6MpaUaPy4+dotfu+a96owrjGEPetm5//ImDQw/wEzGEU2VonPFonvL
   g=;
X-IronPort-AV: E=Sophos;i="5.81,203,1610409600"; 
   d="scan'208";a="87715762"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 24 Feb 2021 23:22:56 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com (Postfix) with ESMTPS id B4778A22EC;
        Wed, 24 Feb 2021 23:22:53 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 24 Feb 2021 23:22:51 +0000
Received: from Alexanders-MacBook-Air.local (10.43.160.146) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 24 Feb 2021 23:22:43 +0000
Subject: Re: [PATCH v7 1/2] drivers/misc: sysgenid: add system generation id
 driver
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Adrian Catangiu <acatan@amazon.com>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rdunlap@infradead.org>,
        <arnd@arndb.de>, <ebiederm@xmission.com>, <rppt@kernel.org>,
        <0x7f454c46@gmail.com>, <borntraeger@de.ibm.com>,
        <Jason@zx2c4.com>, <jannh@google.com>, <w@1wt.eu>,
        <colmmacc@amazon.com>, <luto@kernel.org>, <tytso@mit.edu>,
        <ebiggers@kernel.org>, <dwmw@amazon.co.uk>, <bonzini@gnu.org>,
        <sblbir@amazon.com>, <raduweis@amazon.com>, <corbet@lwn.net>,
        <mhocko@kernel.org>, <rafael@kernel.org>, <pavel@ucw.cz>,
        <mpe@ellerman.id.au>, <areber@redhat.com>, <ovzxemul@gmail.com>,
        <avagin@gmail.com>, <ptikhomirov@virtuozzo.com>, <gil@azul.com>,
        <asmehra@redhat.com>, <dgunigun@redhat.com>, <vijaysun@ca.ibm.com>,
        <oridgar@gmail.com>, <ghammer@redhat.com>
References: <1614156452-17311-1-git-send-email-acatan@amazon.com>
 <1614156452-17311-2-git-send-email-acatan@amazon.com>
 <20210224040516-mutt-send-email-mst@kernel.org>
 <d63146a9-a3f8-14ea-2b16-cb5b3fe7aecf@amazon.com>
 <20210224173205-mutt-send-email-mst@kernel.org>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <e7768780-ce08-9998-8200-d3c33d34fade@amazon.com>
Date:   Thu, 25 Feb 2021 00:22:41 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210224173205-mutt-send-email-mst@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.43.160.146]
X-ClientProxiedBy: EX13D36UWB003.ant.amazon.com (10.43.161.118) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 24.02.21 23:41, Michael S. Tsirkin wrote:
> =

> On Wed, Feb 24, 2021 at 02:45:03PM +0100, Alexander Graf wrote:
>>> Above should try harder to explan what are the things that need to be
>>> scrubbed and why. For example, I personally don't really know what is
>>> the OpenSSL session token example and what makes it vulnerable. I guess
>>> snapshots can attack each other?
>>>
>>>
>>>
>>>
>>> Here's a simple example of a workflow that submits transactions
>>> to a database and wants to avoid duplicate transactions.
>>> This does not require overseer magic. It does however require
>>> a correct genid from hypervisor, so no mmap tricks work.
>>>
>>>
>>>
>>>           int genid, oldgenid;
>>>           read(&genid);
>>> start:
>>>           oldgenid =3D genid;
>>>           transid =3D submit transaction
>>>           read(&genid);
>>>           if (genid !=3D oldgenid) {
>>>                           revert transaction (transid);
>>>                           goto start:
>>>           }
>>
>> I'm not sure I fully follow. For starters, if this is a VM local databas=
e, I
>> don't think you'd care about the genid. If it's a remote database, your
>> connection would get dropped already at the point when you clone/resume,
>> because TCP and your connection state machine will get really confused w=
hen
>> you suddenly have a different IP address or two consumers of the same st=
ream
>> :).
>>
>> But for the sake of the argument, let's assume you can have a connection=
less
>> database connection that maintains its own connection uniqueness logic.
> =

> Right. E.g. not uncommon with REST APIs. They survive disconnect easily
> and use cookies or such.
> =

>> That
>> database connector would need to understand how to abort the connection =
(and
>> thus the transaction!) when the generation changes.
> =

> the point is that instead of all that you discover transaction as
> a duplicate and revert it.
> =

> =

>> And that's logic you
>> would do with the read/write/notify mechanism. So your main loop would c=
heck
>> for reads on the genid fd and after sending a connection termination, no=
tify
>> the overlord that it's safe to use the VM now.
>>
>> The OpenSSL case (with mmap) is for libraries that are stateless and can=
 not
>> guarantee that they receive a genid notification event timely.
>>
>> Since you asked, this is mainly important for the PRNG. Imagine an https
>> server. You create a snapshot. You resume from that snapshot. OpenSSL is
>> fully initialized with a user space PRNG randomness pool that it conside=
rs
>> safe to consume. However, that means your first connection after resume =
will
>> be 100% predictable randomness wise.
> =

> I wonder whether something similar is possible here. I.e. use the secret
> to encrypt stuff but check the gen ID before actually sending data.
> If it changed re-encrypt. Hmm?

I don't see why you would though. Once you control the application =

level, just use the event based API. That's the much easier to use one. =

The mmap one is really just there to cover cases where you don't own the =

main event loop, but can't spend the syscall overhead on every =

invocation to check if the genid changed.

> =

>>
>> The mmap mechanism allows the PRNG to reseed after a genid change. Becau=
se
>> we don't have an event mechanism for this code path, that can happen min=
utes
>> after the resume. But that's ok, we "just" have to ensure that nobody is
>> consuming secret data at the point of the snapshot.
> =

> =

> Something I am still not clear on is whether it's really important to
> skip the system call here. If not I think it's prudent to just stick
> to read for now, I think there's a slightly lower chance that
> it will get misused. mmap which gives you a laggy gen id value
> really seems like it would be hard to use correctly.

The read is not any less racy than the mmap. The real "safety" of the =

read interface comes from the acknowledge path. And that path requires =

you to be part of the event loop.

> =

> =

>>>
>>>
>>>
>>>
>>>
>>>
>>>> +Simplifyng assumption - safety prerequisite
>>>> +-------------------------------------------
>>>> +
>>>> +**Control the snapshot flow**, disallow snapshots coming at arbitrary
>>>> +moments in the workload lifetime.
>>>> +
>>>> +Use a system-level overseer entity that quiesces the system before
>>>> +snapshot, and post-snapshot-resume oversees that software components
>>>> +have readjusted to new environment, to the new generation. Only after,
>>>> +will the overseer un-quiesce the system and allow active workloads.
>>>> +
>>>> +Software components can choose whether they want to be tracked and
>>>> +waited on by the overseer by using the ``SYSGENID_SET_WATCHER_TRACKIN=
G``
>>>> +IOCTL.
>>>> +
>>>> +The sysgenid framework standardizes the API for system software to
>>>> +find out about needing to readjust and at the same time provides a
>>>> +mechanism for the overseer entity to wait for everyone to be done, the
>>>> +system to have readjusted, so it can un-quiesce.
>>>> +
>>>> +Example snapshot-safe workflow
>>>> +------------------------------
>>>> +
>>>> +1) Before taking a snapshot, quiesce the VM/container/system. Exactly
>>>> +   how this is achieved is very workload-specific, but the general
>>>> +   description is to get all software to an expected state where their
>>>> +   event loops dry up and they are effectively quiesced.
>>>
>>> If you have ability to do this by communicating with
>>> all processes e.g. through a unix domain socket,
>>> why do you need the rest of the stuff in the kernel?
>>> Quescing is a harder problem than waking up.
>>
>> That depends. Think of a typical VM workload. Let's take the web server
>> example again. You can preboot the full VM and snapshot it as is. As lon=
g as
>> you don't allow any incoming connections, you can guarantee that the sys=
tem
>> is "quiesced" well enough for the snapshot.
> =

> Well you can use a firewall or such to block incoming packets,
> but I am not at all sure that means e.g. all socket buffers
> are empty.

If it's a fresh VM that only started the web server and did nothing =

else, there shouldn't be anything in its socket buffers :).

I agree that it won't allow us to cover 100% of all cases automatically =

and seamlessly. I can't think of any solution that does - if you can =

think of something I'm all ears. But this API at least gives us a path =

to slowly move the ecosystem to a point where applications and libraries =

can enable themselves to become vm/container clone aware. Today we don't =

even give them the opportunity to self adjust.


Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



