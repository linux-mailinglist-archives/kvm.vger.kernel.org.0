Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1057307699
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 14:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbhA1M7l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 07:59:41 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:62208 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231932AbhA1M7R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jan 2021 07:59:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1611838756; x=1643374756;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=B56E1Awf7VEQPdUFQmhu23n9pP7LJrGNglTlfuHed+U=;
  b=ERdJQ3q0L8dvF3APuLnziiKfn9NEKDpQpubh+o8HN7qA+Y+m5tQ3eLN1
   3nfh847FpF1czOV4xRQu6/YTw8MIGNz+qhdLFcOtzXhlf95sZmPujaqcc
   w7HXqVpJNWioN8ECo+IFIdgdl9Nk45NFKEyQx8R5rJm5GdFG4Mc+e3nAc
   4=;
X-IronPort-AV: E=Sophos;i="5.79,382,1602547200"; 
   d="scan'208";a="82178107"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 28 Jan 2021 12:58:25 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com (Postfix) with ESMTPS id 6DE2AC0600;
        Thu, 28 Jan 2021 12:58:22 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 28 Jan 2021 12:58:21 +0000
Received: from Alexanders-MacBook-Air.local (10.43.162.125) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 28 Jan 2021 12:58:14 +0000
Subject: Re: [PATCH v4 0/2] System Generation ID driver and VMGENID backend
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        "Catangiu, Adrian Costin" <acatan@amazon.com>
CC:     "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "0x7f454c46@gmail.com" <0x7f454c46@gmail.com>,
        "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>,
        "Jason@zx2c4.com" <Jason@zx2c4.com>,
        "jannh@google.com" <jannh@google.com>, "w@1wt.eu" <w@1wt.eu>,
        "MacCarthaigh, Colm" <colmmacc@amazon.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "bonzini@gnu.org" <bonzini@gnu.org>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "Weiss, Radu" <raduweis@amazon.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "mhocko@kernel.org" <mhocko@kernel.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "areber@redhat.com" <areber@redhat.com>,
        "ovzxemul@gmail.com" <ovzxemul@gmail.com>,
        "avagin@gmail.com" <avagin@gmail.com>,
        "ptikhomirov@virtuozzo.com" <ptikhomirov@virtuozzo.com>,
        "gil@azul.com" <gil@azul.com>,
        "asmehra@redhat.com" <asmehra@redhat.com>,
        "dgunigun@redhat.com" <dgunigun@redhat.com>,
        "vijaysun@ca.ibm.com" <vijaysun@ca.ibm.com>,
        "oridgar@gmail.com" <oridgar@gmail.com>,
        "ghammer@redhat.com" <ghammer@redhat.com>
References: <1610453760-13812-1-git-send-email-acatan@amazon.com>
 <20210112074658-mutt-send-email-mst@kernel.org>
 <9952EF0C-CD1D-4EDB-BAB8-21F72C0BF90D@amazon.com>
 <20210127074549-mutt-send-email-mst@kernel.org>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <7bcd1cf3-d055-db46-95ea-5c023df2f184@amazon.de>
Date:   Thu, 28 Jan 2021 13:58:12 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210127074549-mutt-send-email-mst@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.43.162.125]
X-ClientProxiedBy: EX13D02UWC002.ant.amazon.com (10.43.162.6) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Michael!

On 27.01.21 13:47, Michael S. Tsirkin wrote:
> =

> On Thu, Jan 21, 2021 at 10:28:16AM +0000, Catangiu, Adrian Costin wrote:
>> On 12/01/2021, 14:49, "Michael S. Tsirkin" <mst@redhat.com> wrote:
>>
>>      On Tue, Jan 12, 2021 at 02:15:58PM +0200, Adrian Catangiu wrote:
>>      > The first patch in the set implements a device driver which expos=
es a
>>      > read-only device /dev/sysgenid to userspace, which contains a
>>      > monotonically increasing u32 generation counter. Libraries and
>>      > applications are expected to open() the device, and then call rea=
d()
>>      > which blocks until the SysGenId changes. Following an update, rea=
d()
>>      > calls no longer block until the application acknowledges the new
>>      > SysGenId by write()ing it back to the device. Non-blocking read()=
 calls
>>      > return EAGAIN when there is no new SysGenId available. Alternativ=
ely,
>>      > libraries can mmap() the device to get a single shared page which
>>      > contains the latest SysGenId at offset 0.
>>
>>      Looking at some specifications, the gen ID might actually be located
>>      at an arbitrary address. How about instead of hard-coding the offse=
t,
>>      we expose it e.g. in sysfs?
>>
>> The functionality is split between SysGenID which exposes an internal u32
>> counter to userspace, and an (optional) VmGenID backend which drives
>> SysGenID generation changes based on hw vmgenid updates.
>>
>> The hw UUID you're referring to (vmgenid) is not mmap-ed to userspace or
>> otherwise exposed to userspace. It is only used internally by the vmgenid
>> driver to find out about VM generation changes and drive the more generic
>> SysGenID.
>>
>> The SysGenID u32 monotonic increasing counter is the one that is mmaped =
to
>> userspace, but it is a software counter. I don't see any value in using =
a dynamic
>> offset in the mmaped page. Offset 0 is fast and easy and most importantl=
y it is
>> static so no need to dynamically calculate or find it at runtime.
> =

> Well you are burning a whole page on it, using an offset the page
> can be shared with other functionality.

Currently, the SysGenID lives is one page owned by Linux that we share =

out to multiple user space clients. So yes, we burn a single page of the =

system here.

If we put more data in that same page, what data would you put there? =

Random other bits from other subsystems? At that point, we'd be =

reinventing vdso all over again, no? Probably with the same problems.

Which gets me to the second alternative: Reuse VDSO. The problem there =

is that the VDSO is an extremely architecture specific mechanism. Any =

new architecture we'd want to support would need multiple layers of =

changes in multiple layers of both kernel and libc. I'd like to avoid =

that if we can :).

So that leaves us with either wasting a page per system or not having an =

mmap() interface in the first place.

The reason we have the mmap() interface is that it's be easier to =

consume for libraries, that are not hooked into the main event loop.

So, uh, what are you suggesting? :)


Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



