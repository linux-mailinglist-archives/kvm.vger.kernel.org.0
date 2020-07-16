Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07FD4221FB3
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 11:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbgGPJbG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jul 2020 05:31:06 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:44456 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgGPJbG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jul 2020 05:31:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594891866; x=1626427866;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=CTM7Lg+kTZhV/28ULjCgZGcDn3aqFihZ0oeYbYMaRzM=;
  b=WkOXxk5cl9Bbj9+ueRvKoLohtkgrg8EabXmGXKPwETPpqg2QuZfObjfR
   k6hH44BbhPD7Ga6drvVME5T5IOngdqPS62SqbBvA1hvO2kvv/hb0KpHcb
   Q2vT5hwHU5/Wt4Ql6QHBLNlQ8DPVbooq47T49oqakhonH9N01m3OqrOvP
   I=;
IronPort-SDR: 02zWTIZn0DoG/hiyNBhP3Vk32tZ6iPLCTwTVIpce3Jig3wsuOZySn3dzIgWJlGLAROiUk1N8qb
 8Me9iK9u8ulA==
X-IronPort-AV: E=Sophos;i="5.75,358,1589241600"; 
   d="scan'208";a="43659948"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 16 Jul 2020 09:31:05 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS id 9949EC065A;
        Thu, 16 Jul 2020 09:31:03 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 16 Jul 2020 09:31:03 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.146) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 16 Jul 2020 09:30:53 +0000
Subject: Re: [PATCH v5 01/18] nitro_enclaves: Add ioctl interface definition
To:     Stefan Hajnoczi <stefanha@redhat.com>
CC:     <linux-kernel@vger.kernel.org>,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        David Duncan <davdunc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        Karen Noel <knoel@redhat.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>, Alexander Graf <graf@amazon.com>
References: <20200715194540.45532-1-andraprs@amazon.com>
 <20200715194540.45532-2-andraprs@amazon.com>
 <20200716083010.GA85868@stefanha-x1.localdomain>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <5c1deb3f-35fe-f89f-3eb7-bae07f7a1e6c@amazon.com>
Date:   Thu, 16 Jul 2020 12:30:31 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200716083010.GA85868@stefanha-x1.localdomain>
Content-Language: en-US
X-Originating-IP: [10.43.161.146]
X-ClientProxiedBy: EX13D16UWC003.ant.amazon.com (10.43.162.15) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 16/07/2020 11:30, Stefan Hajnoczi wrote:
> On Wed, Jul 15, 2020 at 10:45:23PM +0300, Andra Paraschiv wrote:
>> + * A NE CPU pool has be set before calling this function. The pool can =
be set
> s/has be/has to be/

Fixed.

>
> Thanks, this looks good!
>
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

Thanks for review, glad to hear it's in a better shape.

Andra



Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar=
 Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in R=
omania. Registration number J22/2621/2005.

