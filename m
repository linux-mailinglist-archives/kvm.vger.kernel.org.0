Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64A4922933A
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 10:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728574AbgGVIOc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 04:14:32 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:51592 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgGVIOc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 04:14:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1595405671; x=1626941671;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=dhWOvaKuZvqbMlqikAYroykVPMvhvR9PaTC07Akfv54=;
  b=BdPqys0pOLtkf9gRx2W7V48qkET/ymBRCSOjEePll5TKODsF6fHDOpnB
   kqBmxR6sagPY0pwEESAys8DOk1WxmvMIHRd5+rGUQGXfO6QdLrLUIOSk4
   C/kq1km6lKnUPh08X49QzEXDfhUjZJ5td6POL5S3SRixFc4A8d0YuD2fC
   Q=;
IronPort-SDR: 9ouwtjGL+sWaqj74RXly9rA6zL4Jcj2Qd3IekWM4R99XokeEmNopQMc2rgdMzfFPg0gXPt7FZg
 Gu4npJ1hyffw==
X-IronPort-AV: E=Sophos;i="5.75,381,1589241600"; 
   d="scan'208";a="61833173"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-c6afef2e.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 22 Jul 2020 08:14:29 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-c6afef2e.us-west-2.amazon.com (Postfix) with ESMTPS id 6988AA1F0B;
        Wed, 22 Jul 2020 08:14:28 +0000 (UTC)
Received: from EX13D16EUA003.ant.amazon.com (10.43.165.51) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Jul 2020 08:14:27 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.248) by
 EX13D16EUA003.ant.amazon.com (10.43.165.51) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Jul 2020 08:14:18 +0000
Subject: Re: [PATCH v5 05/18] nitro_enclaves: Handle PCI device command
 requests
To:     Alexander Graf <graf@amazon.de>, <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "David Duncan" <davdunc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        "David Woodhouse" <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Karen Noel <knoel@redhat.com>,
        "Martin Pohlack" <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>, kbuild test robot <lkp@intel.com>
References: <20200715194540.45532-1-andraprs@amazon.com>
 <20200715194540.45532-6-andraprs@amazon.com>
 <87d25260-24e7-319a-f94f-d1eb77c3da00@amazon.de>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <0a840d0c-fdb6-2346-8fcb-edc10aaf1229@amazon.com>
Date:   Wed, 22 Jul 2020 11:14:09 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <87d25260-24e7-319a-f94f-d1eb77c3da00@amazon.de>
Content-Language: en-US
X-Originating-IP: [10.43.162.248]
X-ClientProxiedBy: EX13P01UWA004.ant.amazon.com (10.43.160.127) To
 EX13D16EUA003.ant.amazon.com (10.43.165.51)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 21/07/2020 13:17, Alexander Graf wrote:
>
>
> On 15.07.20 21:45, Andra Paraschiv wrote:
>> The Nitro Enclaves PCI device exposes a MMIO space that this driver
>> uses to submit command requests and to receive command replies e.g. for
>> enclave creation / termination or setting enclave resources.
>>
>> Add logic for handling PCI device command requests based on the given
>> command type.
>>
>> Register an MSI-X interrupt vector for command reply notifications to
>> handle this type of communication events.
>>
>> Signed-off-by: Alexandru-Catalin Vasile <lexnv@amazon.com>
>> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>>
>> Fix issue reported in:
>> https://lore.kernel.org/lkml/202004231644.xTmN4Z1z%25lkp@intel.com/
>>
>> Reported-by: kbuild test robot <lkp@intel.com>
>
> This means that the overall patch is a fix that was reported by the =

> test rebot. I doubt that's what you mean. Just remove the line.

I wanted to mention that the patch includes also the fix for the report. =

I moved these details to the changelog.

>
>> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>
> Reviewed-by: Alexander Graf <graf@amazon.com>

Thanks for review.

Andra



Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar=
 Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in R=
omania. Registration number J22/2621/2005.

