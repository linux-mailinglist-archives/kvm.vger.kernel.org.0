Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05D5F1E233A
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 15:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbgEZNom (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 09:44:42 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:38413 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbgEZNol (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 09:44:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1590500682; x=1622036682;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=B/v3kU+6ifVN37aCOfBDL/cRb6TeFupXOz2xgVvHHxU=;
  b=Hnqv/uTwHqeTnr30FCMEqx+TDgKZ6M0QztrB6Comc3N4SW2FB0iat6er
   0m/yyCGjQhqUqgsprl50GVIxJp+XuMe/g7mQS1YDPOZijIvV6sK15rP/A
   iU8u1ZRgfteD4IJWSNHdi+NUlKpLsw2f0AA9JrivW1tGtY330/LMM9UV1
   M=;
IronPort-SDR: VK6uPIpDLfCBYuybNRRWM8Oyeic7vwIMBHzxyfYfUbDDvagDejAusAjvaajvd1xwZN1lKOIXwV
 L1963FLUvbrw==
X-IronPort-AV: E=Sophos;i="5.73,437,1583193600"; 
   d="scan'208";a="45995375"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 26 May 2020 13:44:40 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com (Postfix) with ESMTPS id 025F9C07D4;
        Tue, 26 May 2020 13:44:38 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 26 May 2020 13:44:38 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.82) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 26 May 2020 13:44:33 +0000
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
 <59007eb9-fad3-9655-a856-f5989fa9fdb3@amazon.de>
 <20200526131708.GA9296@kroah.com>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <29ebdc29-2930-51af-8a54-279c1e449a48@amazon.de>
Date:   Tue, 26 May 2020 15:44:30 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200526131708.GA9296@kroah.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.82]
X-ClientProxiedBy: EX13D04UWB001.ant.amazon.com (10.43.161.46) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 26.05.20 15:17, Greg KH wrote:
> =

> On Tue, May 26, 2020 at 02:44:18PM +0200, Alexander Graf wrote:
>>
>>
>> On 26.05.20 14:33, Greg KH wrote:
>>>
>>> On Tue, May 26, 2020 at 01:42:41PM +0200, Alexander Graf wrote:
>>>>
>>>>
>>>> On 26.05.20 08:51, Greg KH wrote:
>>>>>
>>>>> On Tue, May 26, 2020 at 01:13:23AM +0300, Andra Paraschiv wrote:
>>>>>> +#define NE "nitro_enclaves: "
>>>>>
>>>>> Again, no need for this.
>>>>>
>>>>>> +#define NE_DEV_NAME "nitro_enclaves"
>>>>>
>>>>> KBUILD_MODNAME?
>>>>>
>>>>>> +#define NE_IMAGE_LOAD_OFFSET (8 * 1024UL * 1024UL)
>>>>>> +
>>>>>> +static char *ne_cpus;
>>>>>> +module_param(ne_cpus, charp, 0644);
>>>>>> +MODULE_PARM_DESC(ne_cpus, "<cpu-list> - CPU pool used for Nitro Enc=
laves");
>>>>>
>>>>> Again, please do not do this.
>>>>
>>>> I actually asked her to put this one in specifically.
>>>>
>>>> The concept of this parameter is very similar to isolcpus=3D and maxcp=
us=3D in
>>>> that it takes CPUs away from Linux and instead donates them to the
>>>> underlying hypervisor, so that it can spawn enclaves using them.
>>>>
>>>>   From an admin's point of view, this is a setting I would like to keep
>>>> persisted across reboots. How would this work with sysfs?
>>>
>>> How about just as the "initial" ioctl command to set things up?  Don't
>>> grab any cpu pools until asked to.  Otherwise, what happens when you
>>> load this module on a system that can't support it?
>>
>> That would give any user with access to the enclave device the ability to
>> remove CPUs from the system. That's clearly a CAP_ADMIN task in my book.
> =

> Ok, what's wrong with that?

Would you want random users to get the ability to hot unplug CPUs from =

your system? At unlimited quantity? I don't :).

> =

>> Hence this whole split: The admin defines the CPU Pool, users can safely
>> consume this pool to spawn enclaves from it.
> =

> But having the admin define that at module load / boot time, is a major
> pain.  What tools do they have that allow them to do that easily?

The normal toolbox: editing /etc/default/grub, adding an =

/etc/modprobe.d/ file.

When but at module load / boot time would you define it? I really don't =

want to have a device node that in theory "the world" can use which then =

allows any user on the system to hot unplug every CPU but 0 from my system.

> =

>> So I really don't think an ioctl would be a great user experience. Same =
for
>> a sysfs file - although that's probably slightly better than the ioctl.
> =

> You already are using ioctls to control this thing, right?  What's wrong
> with "one more"? :)

So what we *could* do is add an ioctl to set the pool size which then =

does a CAP_ADMIN check. That however means you now are in priority hell:

A user that wants to spawn an enclave as part of an nginx service would =

need to create another service to set the pool size and indicate the =

dependency in systemd control files.

Is that really better than a module parameter?

> =

>> Other options I can think of:
>>
>>    * sysctl (for modules?)
> =

> Ick.
> =

>>    * module parameter (as implemented here)
> =

> Ick.
> =

>>    * proc file (deprecated FWIW)
> =

> Ick.
> =

>> The key is the tenant split: Admin sets the pool up, user consumes. This
>> setup should happen (early) on boot, so that system services can spawn
>> enclaves.
> =

> But it takes more than jus this initial "split up" to set the pool up,

I don't quite follow. The initial "split up" is all it takes. From the =

hypervisor's point of view, the physical underlying cores will not be =

used to schedule the parent as soon as an enclave is running on them. =

Which CPUs are available for enclaves however is purely a parent OS =

construct, hence the module parameter.

> right?  Why not make this part of that initial process?  What makes this
> so special you have to do this at module load time only?

What is the "initial process"? It's really 2 stages: One stage to create =

a pool (CAP_ADMIN) which makes sure that some cores become invisible to =

the Linux scheduler and one stage to spawn an enclave (normal user =

permission) on those pool's CPUs.


Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



