Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE78B1EFCA6
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 17:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbgFEPjj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 11:39:39 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:37295 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726568AbgFEPji (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jun 2020 11:39:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1591371578; x=1622907578;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=bpxi5R4bZVMT/3MFEoBfMtJ94Rym4esyRQkAw8vEPzE=;
  b=rhWN8qCv7RMgVHc/VHcpY7aFwUQzLaqZttX6qEi0w38/cSUbFC4tO7Vc
   dEUF9h3oZGR39lQZc0IkI6tKL8ury0zvAQ4oaAK8DNbKhR2QE6TP0hTqc
   xZby2CrjxuRu4D6YWEyp58DkeYJmSCkhwCl9pt/qZuRlKjp8RYvN/oPYd
   Y=;
IronPort-SDR: 5oiTao/Y/+2/exBBlvBCg+94gByxVMIU/9O22P8t8Z8AeIwNGDtJumrAR2ISQ4Z93kHTD+Jt0A
 ePERMDp7myjg==
X-IronPort-AV: E=Sophos;i="5.73,476,1583193600"; 
   d="scan'208";a="34687396"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 05 Jun 2020 15:39:36 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com (Postfix) with ESMTPS id EC151A1C39;
        Fri,  5 Jun 2020 15:39:34 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 5 Jun 2020 15:39:34 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.90) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 5 Jun 2020 15:39:24 +0000
Subject: Re: [PATCH v3 01/18] nitro_enclaves: Add ioctl interface definition
To:     Stefan Hajnoczi <stefanha@gmail.com>
CC:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <linux-kernel@vger.kernel.org>,
        Anthony Liguori <aliguori@amazon.com>,
        "Colm MacCarthaigh" <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        "David Woodhouse" <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        "Matt Wilson" <msw@amazon.com>,
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
 <a95de3ee4b722d418fd6cf662233cb024928804e.camel@kernel.crashing.org>
 <d639afa5-cca6-3707-4c80-40ee1bf5bcb5@amazon.com>
 <20200605081503.GA59410@stefanha-x1.localdomain>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <8dbf6822-d835-8c1f-64ff-3e07a77aa8f9@amazon.com>
Date:   Fri, 5 Jun 2020 18:39:15 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200605081503.GA59410@stefanha-x1.localdomain>
Content-Language: en-US
X-Originating-IP: [10.43.160.90]
X-ClientProxiedBy: EX13D05UWB003.ant.amazon.com (10.43.161.26) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 05/06/2020 11:15, Stefan Hajnoczi wrote:
> On Mon, Jun 01, 2020 at 10:20:18AM +0300, Paraschiv, Andra-Irina wrote:
>>
>> On 01/06/2020 06:02, Benjamin Herrenschmidt wrote:
>>> On Wed, 2020-05-27 at 09:49 +0100, Stefan Hajnoczi wrote:
>>>> What about feature bits or a API version number field? If you add
>>>> features to the NE driver, how will userspace detect them?
>>>>
>>>> Even if you intend to always compile userspace against the exact kernel
>>>> headers that the program will run on, it can still be useful to have an
>>>> API version for informational purposes and to easily prevent user
>>>> errors (running a new userspace binary on an old kernel where the API =
is
>>>> different).
>>>>
>>>> Finally, reserved struct fields may come in handy in the future. That
>>>> way userspace and the kernel don't need to explicitly handle multiple
>>>> struct sizes.
>>> Beware, Greg might disagree :)
>>>
>>> That said, yes, at least a way to query the API version would be
>>> useful.
>> I see there are several thoughts with regard to extensions possibilities=
. :)
>>
>> I added an ioctl for getting the API version, we have now a way to query
>> that info. Also, I updated the sample in this patch series to check for =
the
>> API version.
> Great. The ideas are orthogonal and not all of them need to be used
> together. As long as their is a way of extending the API cleanly in the
> future then extensions can be made without breaking userspace.

Agree, as we achieve the ultimate goal of having a stable interface, =

open for extensions without breaking changes.

Thanks,
Andra



Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar=
 Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in R=
omania. Registration number J22/2621/2005.

