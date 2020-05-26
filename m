Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD50D1E2118
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 13:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731825AbgEZLmw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 07:42:52 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:60545 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728148AbgEZLmv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 07:42:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1590493371; x=1622029371;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=KEjAiSa+WOkQ6WGzU97fQPGqxmN27eW/zY/rZIJWqOU=;
  b=szIeJgjxtNJwpDV+PlThFb5gHtySFVhCxfAV09cGx0twXRpX73n2ZLOq
   csKcAcp/gJWEd08XeJkd1odx6C2myHrg/0nsRmRvOQ+BSS7KcNIAGUsmL
   +1Iktqk6M2GTk5mP6zQq3qwbdbDfLr8BaBPlfLctrVCn13EPr2LLbj5sZ
   U=;
IronPort-SDR: sGY4wPEFRJdJ3Rx9HVKOkZi7xkWA5BtVegJtZem8fnWVPwzelFMoqaGo4eMS15Vqdsj/0JuW83
 w5PV68vIFxyQ==
X-IronPort-AV: E=Sophos;i="5.73,437,1583193600"; 
   d="scan'208";a="37665411"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-53356bf6.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 26 May 2020 11:42:49 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-53356bf6.us-west-2.amazon.com (Postfix) with ESMTPS id 92942A1C66;
        Tue, 26 May 2020 11:42:48 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 26 May 2020 11:42:47 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.162.140) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 26 May 2020 11:42:43 +0000
Subject: Re: [PATCH v3 07/18] nitro_enclaves: Init misc device providing the
 ioctl interface
To:     Greg KH <gregkh@linuxfoundation.org>,
        Andra Paraschiv <andraprs@amazon.com>
CC:     <linux-kernel@vger.kernel.org>,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        "Martin Pohlack" <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200525221334.62966-1-andraprs@amazon.com>
 <20200525221334.62966-8-andraprs@amazon.com>
 <20200526065133.GD2580530@kroah.com>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <72647fa4-79d9-7754-9843-a254487703ea@amazon.de>
Date:   Tue, 26 May 2020 13:42:41 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200526065133.GD2580530@kroah.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.140]
X-ClientProxiedBy: EX13d09UWC004.ant.amazon.com (10.43.162.114) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 26.05.20 08:51, Greg KH wrote:
> =

> On Tue, May 26, 2020 at 01:13:23AM +0300, Andra Paraschiv wrote:
>> +#define NE "nitro_enclaves: "
> =

> Again, no need for this.
> =

>> +#define NE_DEV_NAME "nitro_enclaves"
> =

> KBUILD_MODNAME?
> =

>> +#define NE_IMAGE_LOAD_OFFSET (8 * 1024UL * 1024UL)
>> +
>> +static char *ne_cpus;
>> +module_param(ne_cpus, charp, 0644);
>> +MODULE_PARM_DESC(ne_cpus, "<cpu-list> - CPU pool used for Nitro Enclave=
s");
> =

> Again, please do not do this.

I actually asked her to put this one in specifically.

The concept of this parameter is very similar to isolcpus=3D and maxcpus=3D =

in that it takes CPUs away from Linux and instead donates them to the =

underlying hypervisor, so that it can spawn enclaves using them.

 From an admin's point of view, this is a setting I would like to keep =

persisted across reboots. How would this work with sysfs?

> Can you get the other amazon.com developers on the cc: list to review
> this before you send it out again?  I feel like I am doing basic review
> of things that should be easily caught by them before you ask the
> community to review your code.

Again, my fault :). We did a good number of internal review rounds, but =

I guess I didn't catch the bits you pointed out.

So yes, let's give everyone in CC the change to review v3 properly first =

before v4 goes out.

> And get them to sign off on it too, showing they agree with the design
> decisions here :)

I would expect a Reviewed-by tag as a result from the above would =

satisfy this? :)


Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



