Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1852A214493
	for <lists+kvm@lfdr.de>; Sat,  4 Jul 2020 10:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgGDIU6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Jul 2020 04:20:58 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:34411 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgGDIU6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Jul 2020 04:20:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1593850858; x=1625386858;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=yPbQhH8LKLrnSmZCzzmnZLhpKl1jLQWdHSuA0Fv6Gqg=;
  b=L899p2dgAZ1RRwX9Sl33Xy4Y7Td87C28cqG3ZxypLz+a/bVcrp8oKI/p
   RahoO+pQNJXWHn9RpnQfTZfz1iUKaV7ym33CzN9Opi5vuGksmnN+LgNqs
   1adQMLt6IAWf0lXhTHuejphdeSsLiqZIcnEPbHru3Cp3gNi8qs+mQ5jK6
   k=;
IronPort-SDR: jk1LsG2pLnHq0eKIBFWdYFZivVoc00dmwfUQlvAXKbhsQD+UG0ipz6hPBj+SX1I7DT+YdNkq3o
 Rqy3SUiMsxxw==
X-IronPort-AV: E=Sophos;i="5.75,311,1589241600"; 
   d="scan'208";a="41386704"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-859fe132.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 04 Jul 2020 08:20:57 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-859fe132.us-west-2.amazon.com (Postfix) with ESMTPS id AF781225BF7;
        Sat,  4 Jul 2020 08:20:55 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 4 Jul 2020 08:20:55 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.73) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 4 Jul 2020 08:20:47 +0000
Subject: Re: [PATCH v4 02/18] nitro_enclaves: Define the PCI device interface
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
 <20200622200329.52996-3-andraprs@amazon.com>
 <e8d66879-e528-8808-f46a-e4169548214d@amazon.de>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <97df5e8c-8d6d-6841-a643-871f681f7db6@amazon.com>
Date:   Sat, 4 Jul 2020 11:20:41 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <e8d66879-e528-8808-f46a-e4169548214d@amazon.de>
Content-Language: en-US
X-Originating-IP: [10.43.162.73]
X-ClientProxiedBy: EX13D22UWC003.ant.amazon.com (10.43.162.250) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 02/07/2020 18:24, Alexander Graf wrote:
>
>
> On 22.06.20 22:03, Andra Paraschiv wrote:
>> The Nitro Enclaves (NE) driver communicates with a new PCI device, that
>> is exposed to a virtual machine (VM) and handles commands meant for
>> handling enclaves lifetime e.g. creation, termination, setting memory
>> regions. The communication with the PCI device is handled using a MMIO
>> space and MSI-X interrupts.
>>
>> This device communicates with the hypervisor on the host, where the VM
>> that spawned the enclave itself run, e.g. to launch a VM that is used
>> for the enclave.
>>
>> Define the MMIO space of the PCI device, the commands that are
>> provided by this device. Add an internal data structure used as private
>> data for the PCI device driver and the functions for the PCI device init
>> / uninit and command requests handling.
>>
>> Signed-off-by: Alexandru-Catalin Vasile <lexnv@amazon.com>
>> Signed-off-by: Alexandru Ciobotaru <alcioa@amazon.com>
>> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>
> Reviewed-by: Alexander Graf <graf@amazon.com>

Added. Thank you.

Andra



Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar=
 Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in R=
omania. Registration number J22/2621/2005.

