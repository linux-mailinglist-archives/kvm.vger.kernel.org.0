Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F382278CA
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 08:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgGUGUc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 02:20:32 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:59785 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbgGUGUc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 02:20:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1595312432; x=1626848432;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=xTxsgU7dP+dCO7BF1/koKl7ClH5PjAb03Z2Nm54qNPk=;
  b=K9ojjUlgR+yfVPAN6uzwIxEmGELmsH2AisMkzAjo7kMGsqhpifQZb9To
   WzcVLnehnsFpZHrqAxWUvj5j9icxjo+ozOGXzXgjCGEjgJlgoaMAlolD2
   4+zmAsNoAR2raPpUG/uSsDrRQ4q1w4z7P7kCd7D+xI9yPfeVRQBiDISIG
   M=;
IronPort-SDR: qM4kReuBMpJU/qxBHDDloek6Ba7oKCi+kJw7S8tzaLhq/funls180ueZKCSkZUqV5/0/DBFmgw
 Fz1OXn38iYvg==
X-IronPort-AV: E=Sophos;i="5.75,377,1589241600"; 
   d="scan'208";a="60238751"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 21 Jul 2020 06:20:29 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id 0949F284BB9;
        Tue, 21 Jul 2020 06:20:26 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Jul 2020 06:20:26 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.180) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Jul 2020 06:20:17 +0000
Subject: Re: [PATCH v5 04/18] nitro_enclaves: Init PCI device driver
To:     Alexander Graf <graf@amazon.com>, <linux-kernel@vger.kernel.org>
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
        <ne-devel-upstream@amazon.com>
References: <20200715194540.45532-1-andraprs@amazon.com>
 <20200715194540.45532-5-andraprs@amazon.com>
 <d2f717c1-895b-b947-7ec3-067e4f1dbf69@amazon.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <93c45468-d63c-2bc9-58d4-b7a6fa1dfad7@amazon.com>
Date:   Tue, 21 Jul 2020 09:20:07 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d2f717c1-895b-b947-7ec3-067e4f1dbf69@amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.180]
X-ClientProxiedBy: EX13D30UWC003.ant.amazon.com (10.43.162.122) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 20/07/2020 17:24, Alexander Graf wrote:
>
>
> On 15.07.20 21:45, Andra Paraschiv wrote:
>> The Nitro Enclaves PCI device is used by the kernel driver as a means of
>> communication with the hypervisor on the host where the primary VM and
>> the enclaves run. It handles requests with regard to enclave lifetime.
>>
>> Setup the PCI device driver and add support for MSI-X interrupts.
>>
>> Signed-off-by: Alexandru-Catalin Vasile <lexnv@amazon.com>
>> Signed-off-by: Alexandru Ciobotaru <alcioa@amazon.com>
>> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>
> Reviewed-by: Alexander Graf <graf@amazon.com>

Included the Rb, thanks for review.

Andra



Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar=
 Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in R=
omania. Registration number J22/2621/2005.

