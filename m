Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3A5148C63
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2020 17:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388156AbgAXQlI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jan 2020 11:41:08 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:30729 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbgAXQlI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jan 2020 11:41:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1579884068; x=1611420068;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=LXgdOlwtujAE1p5EJnOr5sMTZO6PUyuqb8t7aQa+aDM=;
  b=L1XikwEThwL90lIpnG/Uee3n2cnjMsXvWkKxlCOFnS9zC4g0N9w5Dliv
   2WR9J/4G2JgB+AirBdALDEDaKsmFQdkcBg05p68n4uBBoj2d2K06ZR4rP
   yQ1mJ3V5hako6NREh1pl47KNiGXt/8JWrKttedPg6VAYZhUmgKXdU7a3q
   U=;
IronPort-SDR: kEggzGRjQUbhQNgPmmQt5XZjqmvhOZQFx2qGTmem87b+uhUWRsd7lY08kKes4pYB2fJ2QwHwLX
 yoqe9nN7w4QQ==
X-IronPort-AV: E=Sophos;i="5.70,358,1574121600"; 
   d="scan'208";a="20841900"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-53356bf6.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 24 Jan 2020 16:40:57 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-53356bf6.us-west-2.amazon.com (Postfix) with ESMTPS id 61392A1F07;
        Fri, 24 Jan 2020 16:40:56 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 24 Jan 2020 16:40:55 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.162.133) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 24 Jan 2020 16:40:53 +0000
Subject: Re: [PATCH v16.1 0/9] mm / virtio: Provide support for free page
 reporting
To:     Hillf Danton <hdanton@sina.com>
CC:     Alexander Duyck <alexander.duyck@gmail.com>, <kvm@vger.kernel.org>,
        <mst@redhat.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <akpm@linux-foundation.org>,
        <mgorman@techsingularity.net>, Minchan Kim <minchan@kernel.org>,
        <vbabka@suse.cz>
References: <20200122173040.6142.39116.stgit@localhost.localdomain>
 <20200124132352.12824-1-hdanton@sina.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <286cae85-5dc0-50a7-4fb1-96e75cef408d@amazon.com>
Date:   Fri, 24 Jan 2020 17:40:51 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200124132352.12824-1-hdanton@sina.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.133]
X-ClientProxiedBy: EX13D19UWC002.ant.amazon.com (10.43.162.179) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 24.01.20 14:23, Hillf Danton wrote:
> =

> On Thu, 23 Jan 2020 11:20:07 +0100 Alexander Graf wrote:
>>
>> The big problem I see is that what I really want from a user's point of
>> view is a tuneable that says "Automatically free clean page cache pages
>> that were not accessed in the last X minutes".
> =

> A diff is made on top of 1a4e58cce84e ("mm: introduce MADV_PAGEOUT") with=
out
> test in any form, assuming it goes in line with the tunable above but wit=
hout
> "X minutes" taken into account.
> =

> [BTW, please take a look at
> Content-Type: text/plain; charset=3D"utf-8"; format=3D"flowed"
> Content-Transfer-Encoding: base64
Thanks, looks like Exchange doesn't pass 8bit data on, I've changed the =

default to ascii now, please just notify me in private if you see it =

broken again.

> =

> and ensure pure text message.]
> =

> =

> --- a/include/uapi/asm-generic/mman-common.h
> +++ b/include/uapi/asm-generic/mman-common.h
> @@ -69,6 +69,7 @@
>   =

>   #define MADV_COLD	20		/* deactivate these pages */
>   #define MADV_PAGEOUT	21		/* reclaim these pages */
> +#define MADV_CCPC	22		/* reclaim cold & clean page cache pages */

This patch adds a new madvise flag. I have a hard time seeing how that =

would help with the "full system expiry" of pages?

The basic point that I tried to make above was that I would ideally like =

to have a coldness cutoff date at which you can be pretty confident that =

page cache data is no longer needed.

To work properly, this needs to be transparent to any normal process on =

the system :).


Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



