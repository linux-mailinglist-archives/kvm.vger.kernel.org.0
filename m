Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECDB1E6909
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 20:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391393AbgE1SFf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 May 2020 14:05:35 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:33955 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391340AbgE1SFd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 May 2020 14:05:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590689132; x=1622225132;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=bzsHc1U7VovgwWU+LZ+j3z2fUKeN6w6p9d/tPUXOe70=;
  b=AXf0reKQ6Js488YrcIE3dWqidZgnTFq8NvjzdqUMkoxdjCiE+0EIUHDt
   WopTDDI7dJlZ6lIG0FSCD45J1Jv1TDIW1sZLMVo0rW/uyZM+6qgFXP0Ni
   Oj7WK+m/mkwMjAcoqxYCEzWU5D2pGaV6hW5YxI8czz9ONtVlD26wAVpAA
   8=;
IronPort-SDR: KbSBWUOFxV6AxDrzBlRhHWsBxtS4r8Re1ClWKDaIlBfq5L4GFpW4LEiYyQvfFwoPn/QwRB2uQC
 UCOhg9smOPHg==
X-IronPort-AV: E=Sophos;i="5.73,445,1583193600"; 
   d="scan'208";a="46995014"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-27fb8269.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 28 May 2020 18:05:29 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-27fb8269.us-east-1.amazon.com (Postfix) with ESMTPS id D9B98A0646;
        Thu, 28 May 2020 18:05:27 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 28 May 2020 18:05:27 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.193) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 28 May 2020 18:05:18 +0000
Subject: Re: [PATCH v3 01/18] nitro_enclaves: Add ioctl interface definition
To:     Stefan Hajnoczi <stefanha@gmail.com>
CC:     <linux-kernel@vger.kernel.org>,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        "Alexander Graf" <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Stefan Hajnoczi" <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        "Uwe Dannowski" <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200525221334.62966-1-andraprs@amazon.com>
 <20200525221334.62966-2-andraprs@amazon.com>
 <20200527084959.GA29137@stefanha-x1.localdomain>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <13b0ccfa-ea39-4b8a-f09b-6fa5c371ce9b@amazon.com>
Date:   Thu, 28 May 2020 21:05:12 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200527084959.GA29137@stefanha-x1.localdomain>
Content-Language: en-US
X-Originating-IP: [10.43.161.193]
X-ClientProxiedBy: EX13D03UWC004.ant.amazon.com (10.43.162.49) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 27/05/2020 11:49, Stefan Hajnoczi wrote:
> On Tue, May 26, 2020 at 01:13:17AM +0300, Andra Paraschiv wrote:
>> The Nitro Enclaves driver handles the enclave lifetime management. This
>> includes enclave creation, termination and setting up its resources such
>> as memory and CPU.
>>
>> An enclave runs alongside the VM that spawned it. It is abstracted as a
>> process running in the VM that launched it. The process interacts with
>> the NE driver, that exposes an ioctl interface for creating an enclave
>> and setting up its resources.
>>
>> Include part of the KVM ioctls in the provided ioctl interface, with
>> additional NE ioctl commands that e.g. triggers the enclave run.
>>
>> Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
>> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>> ---
>> Changelog
>>
>> v2 -> v3
>>
>> * Remove the GPL additional wording as SPDX-License-Identifier is alread=
y in
>> place.
>>
>> v1 -> v2
>>
>> * Add ioctl for getting enclave image load metadata.
>> * Update NE_ENCLAVE_START ioctl name to NE_START_ENCLAVE.
>> * Add entry in Documentation/userspace-api/ioctl/ioctl-number.rst for NE=
 ioctls.
>> * Update NE ioctls definition based on the updated ioctl range for major=
 and
>> minor.
>> ---
>>   .../userspace-api/ioctl/ioctl-number.rst      |  5 +-
>>   include/linux/nitro_enclaves.h                | 11 ++++
>>   include/uapi/linux/nitro_enclaves.h           | 65 +++++++++++++++++++
>>   3 files changed, 80 insertions(+), 1 deletion(-)
>>   create mode 100644 include/linux/nitro_enclaves.h
>>   create mode 100644 include/uapi/linux/nitro_enclaves.h
>>
>> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Docume=
ntation/userspace-api/ioctl/ioctl-number.rst
>> index f759edafd938..8a19b5e871d3 100644
>> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
>> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
>> @@ -325,8 +325,11 @@ Code  Seq#    Include File                         =
                  Comments
>>   0xAC  00-1F  linux/raw.h
>>   0xAD  00                                                             N=
etfilter device in development:
>>                                                                        <=
mailto:rusty@rustcorp.com.au>
>> -0xAE  all    linux/kvm.h                                             Ke=
rnel-based Virtual Machine
>> +0xAE  00-1F  linux/kvm.h                                             Ke=
rnel-based Virtual Machine
>>                                                                        <=
mailto:kvm@vger.kernel.org>
>> +0xAE  40-FF  linux/kvm.h                                             Ke=
rnel-based Virtual Machine
>> +                                                                     <m=
ailto:kvm@vger.kernel.org>
>> +0xAE  20-3F  linux/nitro_enclaves.h                                  Ni=
tro Enclaves
>>   0xAF  00-1F  linux/fsl_hypervisor.h                                  F=
reescale hypervisor
>>   0xB0  all                                                            R=
ATIO devices in development:
>>                                                                        <=
mailto:vgo@ratio.de>
> Reusing KVM ioctls seems a little hacky. Even the ioctls that are used
> by this driver don't use all the fields or behave in the same way as
> kvm.ko.
>
> For example, the memory regions slot number is not used by Nitro
> Enclaves.
>
> It would be cleaner to define NE-specific ioctls instead.

Indeed, a couple of fields / parameters are not used during the KVM =

ioctl calls for now.

Will adapt the logic to follow a similar model of creating VMs and =

adding resources, with NE ioctls.

>
>> diff --git a/include/linux/nitro_enclaves.h b/include/linux/nitro_enclav=
es.h
>> new file mode 100644
>> index 000000000000..d91ef2bfdf47
>> --- /dev/null
>> +++ b/include/linux/nitro_enclaves.h
>> @@ -0,0 +1,11 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserv=
ed.
>> + */
>> +
>> +#ifndef _LINUX_NITRO_ENCLAVES_H_
>> +#define _LINUX_NITRO_ENCLAVES_H_
>> +
>> +#include <uapi/linux/nitro_enclaves.h>
>> +
>> +#endif /* _LINUX_NITRO_ENCLAVES_H_ */
>> diff --git a/include/uapi/linux/nitro_enclaves.h b/include/uapi/linux/ni=
tro_enclaves.h
>> new file mode 100644
>> index 000000000000..3413352baf32
>> --- /dev/null
>> +++ b/include/uapi/linux/nitro_enclaves.h
>> @@ -0,0 +1,65 @@
>> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>> +/*
>> + * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserv=
ed.
>> + */
>> +
>> +#ifndef _UAPI_LINUX_NITRO_ENCLAVES_H_
>> +#define _UAPI_LINUX_NITRO_ENCLAVES_H_
>> +
>> +#include <linux/kvm.h>
>> +#include <linux/types.h>
>> +
>> +/* Nitro Enclaves (NE) Kernel Driver Interface */
>> +
>> +/**
>> + * The command is used to get information needed for in-memory enclave =
image
>> + * loading e.g. offset in enclave memory to start placing the enclave i=
mage.
>> + *
>> + * The image load metadata is an in / out data structure. It includes i=
nfo
>> + * provided by the caller - flags - and returns the offset in enclave m=
emory
>> + * where to start placing the enclave image.
>> + */
>> +#define NE_GET_IMAGE_LOAD_METADATA _IOWR(0xAE, 0x20, struct image_load_=
metadata)
>> +
>> +/**
>> + * The command is used to trigger enclave start after the enclave resou=
rces,
>> + * such as memory and CPU, have been set.
>> + *
>> + * The enclave start metadata is an in / out data structure. It include=
s info
>> + * provided by the caller - enclave cid and flags - and returns the slo=
t uid
>> + * and the cid (if input cid is 0).
>> + */
>> +#define NE_START_ENCLAVE _IOWR(0xAE, 0x21, struct enclave_start_metadat=
a)
>> +
> image_load_metadata->flags and enclave_start_metadata->flags constants
> are missing.

I added them now in this file. Thank you.

>
>> +/* Metadata necessary for in-memory enclave image loading. */
>> +struct image_load_metadata {
>> +	/**
>> +	 * Flags to determine the enclave image type e.g. Enclave Image Format
>> +	 * (EIF) (in).
>> +	 */
>> +	__u64 flags;
>> +
>> +	/**
>> +	 * Offset in enclave memory where to start placing the enclave image
>> +	 * (out).
>> +	 */
>> +	__u64 memory_offset;
>> +};
> What about feature bits or a API version number field? If you add
> features to the NE driver, how will userspace detect them?
>
> Even if you intend to always compile userspace against the exact kernel
> headers that the program will run on, it can still be useful to have an
> API version for informational purposes and to easily prevent user
> errors (running a new userspace binary on an old kernel where the API is
> different).

Good point. I'll add a get API version ioctl for this purpose.

>
> Finally, reserved struct fields may come in handy in the future. That
> way userspace and the kernel don't need to explicitly handle multiple
> struct sizes.

True, I've seen this pattern of including reserved fields e.g. in a =

couple of KVM data structures.

Thanks for feedback, Stefan.

Andra



Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar=
 Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in R=
omania. Registration number J22/2621/2005.

