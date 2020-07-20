Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 026A42261F6
	for <lists+kvm@lfdr.de>; Mon, 20 Jul 2020 16:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbgGTOZS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 10:25:18 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:59351 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbgGTOZS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jul 2020 10:25:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1595255117; x=1626791117;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=QmMndjatOipcoY5lV3eLeLJw/bM3AglpoCaoMrI/qIo=;
  b=qr8DQJ/9/CnaJ4mfVmLmo/lQIdWWnwxrVjq4W/fBtEYZB5KjQ1tYNmEf
   0UeAfUJXCmO2nGQ+CP0XZzqEBXD1GX1Xdpbn7B92pH+xGVkJHv+0Pi/fH
   Ff5eP23E9byowMLZBm4f54AIGlaLd3lKTd0tSjx1GeveV1pxvt9ZmEIhL
   I=;
IronPort-SDR: FpBNGu0CReeTTsSNa/bk+buWKmztWLILwLqR1Uc9yi3UkdgsBPYXF21eHbi+9z2fQS42O4hmGd
 fZfL7sqkvbnw==
X-IronPort-AV: E=Sophos;i="5.75,375,1589241600"; 
   d="scan'208";a="42973046"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-97fdccfd.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 20 Jul 2020 14:25:15 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-97fdccfd.us-east-1.amazon.com (Postfix) with ESMTPS id 614BEA21C2;
        Mon, 20 Jul 2020 14:25:13 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 20 Jul 2020 14:25:12 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.162.248) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 20 Jul 2020 14:25:07 +0000
Subject: Re: [PATCH v5 04/18] nitro_enclaves: Init PCI device driver
To:     Andra Paraschiv <andraprs@amazon.com>,
        <linux-kernel@vger.kernel.org>
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
From:   Alexander Graf <graf@amazon.com>
Message-ID: <d2f717c1-895b-b947-7ec3-067e4f1dbf69@amazon.com>
Date:   Mon, 20 Jul 2020 16:24:53 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200715194540.45532-5-andraprs@amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.248]
X-ClientProxiedBy: EX13D46UWC003.ant.amazon.com (10.43.162.119) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 15.07.20 21:45, Andra Paraschiv wrote:
> The Nitro Enclaves PCI device is used by the kernel driver as a means of
> communication with the hypervisor on the host where the primary VM and
> the enclaves run. It handles requests with regard to enclave lifetime.
> =

> Setup the PCI device driver and add support for MSI-X interrupts.
> =

> Signed-off-by: Alexandru-Catalin Vasile <lexnv@amazon.com>
> Signed-off-by: Alexandru Ciobotaru <alcioa@amazon.com>
> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>

Reviewed-by: Alexander Graf <graf@amazon.com>


Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



