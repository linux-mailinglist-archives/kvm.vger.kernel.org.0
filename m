Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB39C20A43B
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 19:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406876AbgFYRnS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 13:43:18 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:22147 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406853AbgFYRnS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 13:43:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1593106997; x=1624642997;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=KODjYew9y5CUziLeFgjT5ulnlYrrJbK8+FK4VwP38dI=;
  b=exn+sTQKVPFUVa4g6ulHQ7ObCrEB4+LjuL+dp09zPUqgQ/Om3Eq4QE5p
   ODXDzMek/7r4gpWZ0qPYUjN9hyHl1+A6B9UXF1PbIz2ZC/R3MwQA4YnqO
   hT2Bg9i03eTrhal2SQJczokNXIyGltOUovWFzbngsGxDsomFleHoXHGUk
   A=;
IronPort-SDR: +jsvhuffAApEIscULjVxCw5is0GCt1rNasOc19Af70mwDZkCwVYqbddDi8/4TmcvOF7S/0Emme
 3zZs1HPZfSHg==
X-IronPort-AV: E=Sophos;i="5.75,280,1589241600"; 
   d="scan'208";a="53960560"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-a70de69e.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 25 Jun 2020 17:43:14 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-a70de69e.us-east-1.amazon.com (Postfix) with ESMTPS id 1D5AFA4099;
        Thu, 25 Jun 2020 17:43:12 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 25 Jun 2020 17:43:12 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.65) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 25 Jun 2020 17:43:02 +0000
Subject: Re: [PATCH v4 01/18] nitro_enclaves: Add ioctl interface definition
To:     Stefan Hajnoczi <stefanha@redhat.com>
CC:     <linux-kernel@vger.kernel.org>,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        "Alexander Graf" <graf@amazon.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200622200329.52996-1-andraprs@amazon.com>
 <20200622200329.52996-2-andraprs@amazon.com>
 <20200623085617.GE32718@stefanha-x1.localdomain>
 <60d7d8be-7c8c-964a-a339-8ef7f5bd2fef@amazon.com>
 <20200625132905.GE221479@stefanha-x1.localdomain>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <5df6efdf-a304-ddaa-6335-ae158f7c6ccb@amazon.com>
Date:   Thu, 25 Jun 2020 20:42:57 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200625132905.GE221479@stefanha-x1.localdomain>
Content-Language: en-US
X-Originating-IP: [10.43.160.65]
X-ClientProxiedBy: EX13D43UWC001.ant.amazon.com (10.43.162.69) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 25/06/2020 16:29, Stefan Hajnoczi wrote:
> On Wed, Jun 24, 2020 at 05:02:54PM +0300, Paraschiv, Andra-Irina wrote:
>> On 23/06/2020 11:56, Stefan Hajnoczi wrote:
>>> On Mon, Jun 22, 2020 at 11:03:12PM +0300, Andra Paraschiv wrote:
>>>> +/* User memory region flags */
>>>> +
>>>> +/* Memory region for enclave general usage. */
>>>> +#define NE_DEFAULT_MEMORY_REGION (0x00)
>>>> +
>>>> +/* Memory region to be set for an enclave (write). */
>>>> +struct ne_user_memory_region {
>>>> +	/**
>>>> +	 * Flags to determine the usage for the memory region (write).
>>>> +	 */
>>>> +	__u64 flags;
>>> Where is the write flag defined?
>>>
>>> I guess it's supposed to be:
>>>
>>>     #define NE_USER_MEMORY_REGION_FLAG_WRITE (0x01)
>> For now, the flags field is included in the NE ioctl interface for
>> extensions, it is not part of the NE PCI device interface yet.
> ...
>> Ah, and just as a note, that "read" / "write" in parentheses means that a
>> certain data structure / field is read / written by user space. I update=
d to
>> use "in" / "out" instead of "read" / "write" in v5.
> Oops, I got confused. I thought "(write)" was an example of a flag that
> can be set on the memory region. Now I realize "write" means this field
> is an input to the ioctl. :)
>
> Thanks for updating the docs.

I was thinking this may be the case. :) Should be less confusing now, =

with the "in / out" updates.

Thanks also for feedback.

Andra



Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar=
 Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in R=
omania. Registration number J22/2621/2005.

