Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2FEA3312D4
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 17:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbhCHQEm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 11:04:42 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:51906 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbhCHQEb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 11:04:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1615219471; x=1646755471;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=+AelMi3v18s6+/y1BQYDbI2IpSHlRy2T4ik8Uc3Ym70=;
  b=bG+4hnas4YNJk3w/HmOqvVeY0XcC9WLfWavRcwA2XepyTLkOrvzF0iai
   qatRTWUCuFwcmPL13liOMq6b3hZDBLKEn609oeBiZ4QUDZtAFZf1du0fh
   3GZCBys2dLCTpJOKocAejwqKPfdsmp3hC7WO0ylPiEvILECqQyA1Y+oxh
   U=;
X-IronPort-AV: E=Sophos;i="5.81,232,1610409600"; 
   d="scan'208";a="92508455"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 08 Mar 2021 16:04:19 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (Postfix) with ESMTPS id 9E5F4A1F36;
        Mon,  8 Mar 2021 16:04:08 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 8 Mar 2021 16:04:08 +0000
Received: from Alexanders-MacBook-Air.local (10.43.162.131) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 8 Mar 2021 16:04:00 +0000
Subject: Re: [PATCH v8] drivers/misc: sysgenid: add system generation id
 driver
To:     Greg KH <gregkh@linuxfoundation.org>,
        Adrian Catangiu <acatan@amazon.com>
CC:     <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        <linux-s390@vger.kernel.org>, <rdunlap@infradead.org>,
        <arnd@arndb.de>, <ebiederm@xmission.com>, <rppt@kernel.org>,
        <0x7f454c46@gmail.com>, <borntraeger@de.ibm.com>,
        <Jason@zx2c4.com>, <jannh@google.com>, <w@1wt.eu>,
        <colmmacc@amazon.com>, <luto@kernel.org>, <tytso@mit.edu>,
        <ebiggers@kernel.org>, <dwmw@amazon.co.uk>, <bonzini@gnu.org>,
        <sblbir@amazon.com>, <raduweis@amazon.com>, <corbet@lwn.net>,
        <mst@redhat.com>, <mhocko@kernel.org>, <rafael@kernel.org>,
        <pavel@ucw.cz>, <mpe@ellerman.id.au>, <areber@redhat.com>,
        <ovzxemul@gmail.com>, <avagin@gmail.com>,
        <ptikhomirov@virtuozzo.com>, <gil@azul.com>, <asmehra@redhat.com>,
        <dgunigun@redhat.com>, <vijaysun@ca.ibm.com>, <oridgar@gmail.com>,
        <ghammer@redhat.com>
References: <1615213083-29869-1-git-send-email-acatan@amazon.com>
 <YEY2b1QU5RxozL0r@kroah.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <a61c976f-b362-bb60-50a5-04073360e702@amazon.com>
Date:   Mon, 8 Mar 2021 17:03:58 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <YEY2b1QU5RxozL0r@kroah.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.131]
X-ClientProxiedBy: EX13D19UWA003.ant.amazon.com (10.43.160.170) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 08.03.21 15:36, Greg KH wrote:
> =

> On Mon, Mar 08, 2021 at 04:18:03PM +0200, Adrian Catangiu wrote:
>> +static struct miscdevice sysgenid_misc =3D {
>> +     .minor =3D MISC_DYNAMIC_MINOR,
>> +     .name =3D "sysgenid",
>> +     .fops =3D &fops,
>> +};
> =

> Much cleaner, but:
> =

>> +static int __init sysgenid_init(void)
>> +{
>> +     int ret;
>> +
>> +     sysgenid_data.map_buf =3D get_zeroed_page(GFP_KERNEL);
>> +     if (!sysgenid_data.map_buf)
>> +             return -ENOMEM;
>> +
>> +     atomic_set(&sysgenid_data.generation_counter, 0);
>> +     atomic_set(&sysgenid_data.outdated_watchers, 0);
>> +     init_waitqueue_head(&sysgenid_data.read_waitq);
>> +     init_waitqueue_head(&sysgenid_data.outdated_waitq);
>> +     spin_lock_init(&sysgenid_data.lock);
>> +
>> +     ret =3D misc_register(&sysgenid_misc);
>> +     if (ret < 0) {
>> +             pr_err("misc_register() failed for sysgenid\n");
>> +             goto err;
>> +     }
>> +
>> +     return 0;
>> +
>> +err:
>> +     free_pages(sysgenid_data.map_buf, 0);
>> +     sysgenid_data.map_buf =3D 0;
>> +
>> +     return ret;
>> +}
>> +
>> +static void __exit sysgenid_exit(void)
>> +{
>> +     misc_deregister(&sysgenid_misc);
>> +     free_pages(sysgenid_data.map_buf, 0);
>> +     sysgenid_data.map_buf =3D 0;
>> +}
>> +
>> +module_init(sysgenid_init);
>> +module_exit(sysgenid_exit);
> =

> So you do this for any bit of hardware that happens to be out there?
> Will that really work?  You do not have any hwid to trigger off of to
> know that this is a valid device you can handle?

The interface is already useful in a pure container context where the =

generation change request is triggered by software.

And yes, there are hardware triggers, but Michael was quite unhappy =

about potential races between VMGenID change and SysGenID change and =

thus wanted to ideally separate the interfaces. So we went ahead and =

isolated the SysGenID one, as it's already useful as is.

Hardware drivers to inject change events into SysGenID can then follow =

later, for all different hardware platforms. But SysGenID as in this =

patch is a completely hardware agnostic concept.


Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



