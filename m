Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D28D207533
	for <lists+kvm@lfdr.de>; Wed, 24 Jun 2020 16:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404063AbgFXODw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jun 2020 10:03:52 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:9758 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403922AbgFXODv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jun 2020 10:03:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1593007431; x=1624543431;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=lSjmdvPtvlSp5tbNUOnf3T8VMVMZvTCAfVnI9cmGGJw=;
  b=PjPN7dP5CqE61TSulrOUPZwt0WuNCGpHNbOYmM5VkTmit1WNjLMUJvJT
   SeLlprXGuxDWX5RZlmMsj3VZChrXgCbdfmUE2VuJOqrJ8JZBWvuIboxhP
   asRnf2TVbQUzp7grwXTYDcJXn52v1JnsHGfQ71IOcSsJYcLjGu2qDw8mq
   U=;
IronPort-SDR: IGYKflQzaECzMSe0GJOS74JOQqVJ73I9rQzk2te8N80PLfQt5ec0ns2qcHgM2MeFAr4tTi1pxc
 zMyCkE58mXJg==
X-IronPort-AV: E=Sophos;i="5.75,275,1589241600"; 
   d="scan'208";a="53534094"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-27fb8269.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 24 Jun 2020 14:03:14 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-27fb8269.us-east-1.amazon.com (Postfix) with ESMTPS id BA307A1ADB;
        Wed, 24 Jun 2020 14:03:12 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 24 Jun 2020 14:03:11 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.248) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 24 Jun 2020 14:03:03 +0000
Subject: Re: [PATCH v4 01/18] nitro_enclaves: Add ioctl interface definition
To:     Stefan Hajnoczi <stefanha@redhat.com>
CC:     <linux-kernel@vger.kernel.org>,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        "Alexander Graf" <graf@amazon.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200622200329.52996-1-andraprs@amazon.com>
 <20200622200329.52996-2-andraprs@amazon.com>
 <20200623085617.GE32718@stefanha-x1.localdomain>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <60d7d8be-7c8c-964a-a339-8ef7f5bd2fef@amazon.com>
Date:   Wed, 24 Jun 2020 17:02:54 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200623085617.GE32718@stefanha-x1.localdomain>
Content-Language: en-US
X-Originating-IP: [10.43.162.248]
X-ClientProxiedBy: EX13D36UWA001.ant.amazon.com (10.43.160.71) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 23/06/2020 11:56, Stefan Hajnoczi wrote:
> On Mon, Jun 22, 2020 at 11:03:12PM +0300, Andra Paraschiv wrote:
>> diff --git a/include/uapi/linux/nitro_enclaves.h b/include/uapi/linux/ni=
tro_enclaves.h
>> new file mode 100644
>> index 000000000000..3270eb939a97
>> --- /dev/null
>> +++ b/include/uapi/linux/nitro_enclaves.h
>> @@ -0,0 +1,137 @@
>> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>> +/*
>> + * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserv=
ed.
>> + */
>> +
>> +#ifndef _UAPI_LINUX_NITRO_ENCLAVES_H_
>> +#define _UAPI_LINUX_NITRO_ENCLAVES_H_
>> +
>> +#include <linux/types.h>
>> +
>> +/* Nitro Enclaves (NE) Kernel Driver Interface */
>> +
>> +#define NE_API_VERSION (1)
>> +
>> +/**
>> + * The command is used to get the version of the NE API. This way the u=
ser space
>> + * processes can be aware of the feature sets provided by the NE kernel=
 driver.
>> + *
>> + * The NE API version is returned as result of this ioctl call.
>> + */
>> +#define NE_GET_API_VERSION _IO(0xAE, 0x20)
>> +
>> +/**
>> + * The command is used to create a slot that is associated with an encl=
ave VM.
>> + *
>> + * The generated unique slot id is a read parameter of this command. An=
 enclave
>> + * file descriptor is returned as result of this ioctl call. The enclav=
e fd can
>> + * be further used with ioctl calls to set vCPUs and memory regions, th=
en start
>> + * the enclave.
>> + */
>> +#define NE_CREATE_VM _IOR(0xAE, 0x21, __u64)
> Information that would be useful for the ioctls:
>
> 1. Which fd the ioctl must be invoked on (/dev/nitro-enclaves, enclave fd=
, vCPU fd)
>
> 2. Errnos and their meanings
>
> 3. Which state(s) the ioctls may be invoked in (e.g. enclave created/star=
ted/etc)

I'll include this info in v5. Indeed, that's useful for the user space =

tooling that interacts with the kernel driver, in addition to the code =

review itself and future refs, to understand how it works.

>
>> +/* User memory region flags */
>> +
>> +/* Memory region for enclave general usage. */
>> +#define NE_DEFAULT_MEMORY_REGION (0x00)
>> +
>> +/* Memory region to be set for an enclave (write). */
>> +struct ne_user_memory_region {
>> +	/**
>> +	 * Flags to determine the usage for the memory region (write).
>> +	 */
>> +	__u64 flags;
> Where is the write flag defined?
>
> I guess it's supposed to be:
>
>    #define NE_USER_MEMORY_REGION_FLAG_WRITE (0x01)

For now, the flags field is included in the NE ioctl interface for =

extensions, it is not part of the NE PCI device interface yet.

The enclave image is copied into enclave memory before the enclave =

memory is carved out of the primary / parent VM. After carving it out =

(when the command request to add memory is sent to the PCI device and it =

is successfully completed), there will be faults if the enclave memory =

is written from the primary / parent VM.

Ah, and just as a note, that "read" / "write" in parentheses means that =

a certain data structure / field is read / written by user space. I =

updated to use "in" / "out" instead of "read" / "write" in v5.

Thank you.

Andra




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar=
 Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in R=
omania. Registration number J22/2621/2005.

