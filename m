Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1281E222D
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 14:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389257AbgEZMoa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 08:44:30 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:12251 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388917AbgEZMo3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 08:44:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1590497069; x=1622033069;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=B8VHpumsAuOYQHWgs9g2sAk0k5+X3E6msxqGuNOgHZM=;
  b=Rxf8AmGUgPtEPR8OiZOIt79eVaxXab8rCPs9ufs8e3LreN2ibWVXN3Sk
   gBvRpWLtLm3IaOyyOjw9ICgZQMDQ19R7jh90N6oJf27xK1If0k/7qNOtc
   fivlUcnUIuv1Rlk/ttptkanhawVZ7NB2tRUIa3coZavDU+6y9Zt7azxZU
   U=;
IronPort-SDR: ZJxFfgJt1AZkClFw3ZY2WYtqsW/2tgXRj/umqXjSX38xkaG3I8QJbXMb/HXO+uedk0djCO/fao
 3yySW1m/9wzg==
X-IronPort-AV: E=Sophos;i="5.73,437,1583193600"; 
   d="scan'208";a="37682336"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 26 May 2020 12:44:27 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com (Postfix) with ESMTPS id 5191DA234E;
        Tue, 26 May 2020 12:44:26 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 26 May 2020 12:44:25 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.82) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 26 May 2020 12:44:21 +0000
Subject: Re: [PATCH v3 07/18] nitro_enclaves: Init misc device providing the
 ioctl interface
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Andra Paraschiv <andraprs@amazon.com>,
        <linux-kernel@vger.kernel.org>,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Bjoern Doebel" <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Frank van der Linden" <fllinden@amazon.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        "Matt Wilson" <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Stefan Hajnoczi" <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        "Uwe Dannowski" <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200525221334.62966-1-andraprs@amazon.com>
 <20200525221334.62966-8-andraprs@amazon.com>
 <20200526065133.GD2580530@kroah.com>
 <72647fa4-79d9-7754-9843-a254487703ea@amazon.de>
 <20200526123300.GA2798@kroah.com>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <59007eb9-fad3-9655-a856-f5989fa9fdb3@amazon.de>
Date:   Tue, 26 May 2020 14:44:18 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200526123300.GA2798@kroah.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.82]
X-ClientProxiedBy: EX13D17UWC002.ant.amazon.com (10.43.162.61) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 26.05.20 14:33, Greg KH wrote:
> =

> On Tue, May 26, 2020 at 01:42:41PM +0200, Alexander Graf wrote:
>>
>>
>> On 26.05.20 08:51, Greg KH wrote:
>>>
>>> On Tue, May 26, 2020 at 01:13:23AM +0300, Andra Paraschiv wrote:
>>>> +#define NE "nitro_enclaves: "
>>>
>>> Again, no need for this.
>>>
>>>> +#define NE_DEV_NAME "nitro_enclaves"
>>>
>>> KBUILD_MODNAME?
>>>
>>>> +#define NE_IMAGE_LOAD_OFFSET (8 * 1024UL * 1024UL)
>>>> +
>>>> +static char *ne_cpus;
>>>> +module_param(ne_cpus, charp, 0644);
>>>> +MODULE_PARM_DESC(ne_cpus, "<cpu-list> - CPU pool used for Nitro Encla=
ves");
>>>
>>> Again, please do not do this.
>>
>> I actually asked her to put this one in specifically.
>>
>> The concept of this parameter is very similar to isolcpus=3D and maxcpus=
=3D in
>> that it takes CPUs away from Linux and instead donates them to the
>> underlying hypervisor, so that it can spawn enclaves using them.
>>
>>  From an admin's point of view, this is a setting I would like to keep
>> persisted across reboots. How would this work with sysfs?
> =

> How about just as the "initial" ioctl command to set things up?  Don't
> grab any cpu pools until asked to.  Otherwise, what happens when you
> load this module on a system that can't support it?

That would give any user with access to the enclave device the ability =

to remove CPUs from the system. That's clearly a CAP_ADMIN task in my book.

Hence this whole split: The admin defines the CPU Pool, users can safely =

consume this pool to spawn enclaves from it.

So I really don't think an ioctl would be a great user experience. Same =

for a sysfs file - although that's probably slightly better than the ioctl.

Other options I can think of:

   * sysctl (for modules?)
   * module parameter (as implemented here)
   * proc file (deprecated FWIW)

The key is the tenant split: Admin sets the pool up, user consumes. This =

setup should happen (early) on boot, so that system services can spawn =

enclaves.

> module parameters are a major pain, you know this :)

I think in this case it's the least painful option ;). But I'm really =

happy to hear about an actually good alternative to it. Right now, I =

just can't think of any.


Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



