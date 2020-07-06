Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C6B2158D3
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 15:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729198AbgGFNut (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 09:50:49 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:20605 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729169AbgGFNus (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 09:50:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594043448; x=1625579448;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=cqMisbW4G4BBUuKTd9vQVVtJLyPCiNtYX4T4czXDsWw=;
  b=GC367V6MDKdljpTBmDU7qhWL/12Q3tjKNJEJln928uhjJJBS/2BKx5+1
   f0olDDXbzW564/x431r86zt1rwDxXr5lmq7t639HI4fkhxBwbQQwtV6Be
   i8DvAGL7BmTibVVU/MuL0CQIpi0naK9BHVacCh9Jnp8feWDxAYDvJ/BNt
   U=;
IronPort-SDR: N373rT1nSZVN0L7Ho6D+HHXlYdhs++lhKiA8wz+6md6BEeVC2Gkl/mpBQNV4vW062Ix+wr42tQ
 oESuk94vsDVw==
X-IronPort-AV: E=Sophos;i="5.75,320,1589241600"; 
   d="scan'208";a="49434461"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-9ec21598.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 06 Jul 2020 13:50:44 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-9ec21598.us-east-1.amazon.com (Postfix) with ESMTPS id BA0CAA1A94;
        Mon,  6 Jul 2020 13:50:41 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 6 Jul 2020 13:50:41 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.48) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 6 Jul 2020 13:50:32 +0000
Subject: Re: [PATCH v4 14/18] nitro_enclaves: Add Kconfig for the Nitro
 Enclaves driver
To:     Alexander Graf <graf@amazon.de>, <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Bjoern Doebel" <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Frank van der Linden" <fllinden@amazon.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        "Stefano Garzarella" <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200622200329.52996-1-andraprs@amazon.com>
 <20200622200329.52996-15-andraprs@amazon.com>
 <0576a41d-f915-24b3-e6f9-0bc3616fd75b@amazon.de>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <3da5e023-47d0-09c1-89b8-94a80fbeba85@amazon.com>
Date:   Mon, 6 Jul 2020 16:50:23 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0576a41d-f915-24b3-e6f9-0bc3616fd75b@amazon.de>
Content-Language: en-US
X-Originating-IP: [10.43.160.48]
X-ClientProxiedBy: EX13D17UWC001.ant.amazon.com (10.43.162.188) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 06/07/2020 14:28, Alexander Graf wrote:
>
>
> On 22.06.20 22:03, Andra Paraschiv wrote:
>> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>> ---
>> Changelog
>>
>> v3 -> v4
>>
>> * Add PCI and SMP dependencies.
>>
>> v2 -> v3
>>
>> * Remove the GPL additional wording as SPDX-License-Identifier is
>> =A0=A0 already in place.
>>
>> v1 -> v2
>>
>> * Update path to Kconfig to match the drivers/virt/nitro_enclaves
>> =A0=A0 directory.
>> * Update help in Kconfig.
>> ---
>> =A0 drivers/virt/Kconfig=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=
=A0 2 ++
>> =A0 drivers/virt/nitro_enclaves/Kconfig | 16 ++++++++++++++++
>> =A0 2 files changed, 18 insertions(+)
>> =A0 create mode 100644 drivers/virt/nitro_enclaves/Kconfig
>>
>> diff --git a/drivers/virt/Kconfig b/drivers/virt/Kconfig
>> index cbc1f25c79ab..80c5f9c16ec1 100644
>> --- a/drivers/virt/Kconfig
>> +++ b/drivers/virt/Kconfig
>> @@ -32,4 +32,6 @@ config FSL_HV_MANAGER
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 partition shuts down.
>> =A0 =A0 source "drivers/virt/vboxguest/Kconfig"
>> +
>> +source "drivers/virt/nitro_enclaves/Kconfig"
>> =A0 endif
>> diff --git a/drivers/virt/nitro_enclaves/Kconfig =

>> b/drivers/virt/nitro_enclaves/Kconfig
>> new file mode 100644
>> index 000000000000..69e41aa2222d
>> --- /dev/null
>> +++ b/drivers/virt/nitro_enclaves/Kconfig
>> @@ -0,0 +1,16 @@
>> +# SPDX-License-Identifier: GPL-2.0
>> +#
>> +# Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights =

>> Reserved.
>> +
>> +# Amazon Nitro Enclaves (NE) support.
>> +# Nitro is a hypervisor that has been developed by Amazon.
>> +
>> +config NITRO_ENCLAVES
>> +=A0=A0=A0 tristate "Nitro Enclaves Support"
>> +=A0=A0=A0 depends on HOTPLUG_CPU && PCI && SMP
>
> Let's also depend on ARM64 || X86, so that we don't burden all of the =

> other archs that are not available in EC2 today with an additional =

> config option to think about.

Included the arch specs.

Thanks,
Andra



Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar=
 Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in R=
omania. Registration number J22/2621/2005.

