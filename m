Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48772214495
	for <lists+kvm@lfdr.de>; Sat,  4 Jul 2020 10:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbgGDIYB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Jul 2020 04:24:01 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:32141 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgGDIYB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Jul 2020 04:24:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1593851040; x=1625387040;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=MGKZRxRlGDCpn2GdZLuWjghVOYAjAXEXtuDigg+AjhM=;
  b=JkhJzPZuf9Hnm1bQHodCCczRTPDyU00h3jwXOlsBuJTLO4rMhN41Pin/
   URmksnzscmK6lUy0FOkw+q8qPCbV5JTh3Bq2xRa7HGdncOJYH71/NNa2V
   DOfcjTg59dzUukl/uRArUU2FRHRGYi0FpAMyjvBb+nO1EkWy9YN+VvINd
   E=;
IronPort-SDR: XfhBsKEaKsDwZrAPvxsOomlSENBP+C0tqBkFfqF9sBZyav32ucOe/R3jmVMy0mqmw6pwOhzISc
 Y57D5XSEYYkQ==
X-IronPort-AV: E=Sophos;i="5.75,311,1589241600"; 
   d="scan'208";a="39935489"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-87a10be6.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 04 Jul 2020 08:23:59 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-87a10be6.us-west-2.amazon.com (Postfix) with ESMTPS id BA783A1D35;
        Sat,  4 Jul 2020 08:23:57 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 4 Jul 2020 08:23:57 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.85) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 4 Jul 2020 08:23:48 +0000
Subject: Re: [PATCH v4 03/18] nitro_enclaves: Define enclave info for internal
 bookkeeping
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
 <20200622200329.52996-4-andraprs@amazon.com>
 <cc84e2ee-1a85-c92e-9d29-2f4a33148a61@amazon.de>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <04453234-40ad-4ebc-7273-41880484e1b7@amazon.com>
Date:   Sat, 4 Jul 2020 11:23:43 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <cc84e2ee-1a85-c92e-9d29-2f4a33148a61@amazon.de>
Content-Language: en-US
X-Originating-IP: [10.43.162.85]
X-ClientProxiedBy: EX13D27UWA002.ant.amazon.com (10.43.160.30) To
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
>> The Nitro Enclaves driver keeps an internal info per each enclave.
>>
>> This is needed to be able to manage enclave resources state, enclave
>> notifications and have a reference of the PCI device that handles
>> command requests for enclave lifetime management.
>>
>> Signed-off-by: Alexandru-Catalin Vasile <lexnv@amazon.com>
>> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>
> Reviewed-by: Alexander Graf <graf@amazon.com>

Added. Thank you.

Andra



Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar=
 Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in R=
omania. Registration number J22/2621/2005.

