Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45DB82A324D
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 18:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbgKBRxH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 12:53:07 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:18058 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbgKBRxH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 12:53:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1604339587; x=1635875587;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=vt6Hn24mtkMCKwofJ0jwQ4BLGvIOVVWmcLAhyM7iPJQ=;
  b=FZ/rzQwCmFQ4d8HfyoxsH5+hkkAU5cw0Z/cuEaoY4TRhSmxrg+NRDuyc
   gteGYz47rpjkBhNocbXjKze/MOlcie0MGqAgGaAk3Y2iOW0ap191rG9N5
   u8tlKvWNM7tUYLufay221HnC4kGL3tIEOj7vp6qcUEpKm2/uvK9iXLS3q
   s=;
X-IronPort-AV: E=Sophos;i="5.77,445,1596499200"; 
   d="scan'208";a="89788432"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-456ef9c9.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 02 Nov 2020 17:42:31 +0000
Received: from EX13D16EUB003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-456ef9c9.us-west-2.amazon.com (Postfix) with ESMTPS id 99959B390C;
        Mon,  2 Nov 2020 17:42:30 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.241) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 2 Nov 2020 17:42:20 +0000
Subject: Re: [PATCH v1] nitro_enclaves: Fixup type of the poll result assigned
 value
To:     Alexander Graf <graf@amazon.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "David Duncan" <davdunc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        "David Woodhouse" <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Karen Noel <knoel@redhat.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>
References: <20201014090500.75678-1-andraprs@amazon.com>
 <e4a34429-1b25-00d5-9bf1-045ca49acb8d@amazon.de>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <1ca4cd54-5ffd-621d-acb1-925bccb06066@amazon.com>
Date:   Mon, 2 Nov 2020 19:42:09 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <e4a34429-1b25-00d5-9bf1-045ca49acb8d@amazon.de>
Content-Language: en-US
X-Originating-IP: [10.43.162.241]
X-ClientProxiedBy: EX13D22UWB003.ant.amazon.com (10.43.161.76) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 02/11/2020 18:16, Alexander Graf wrote:
>
>
> On 14.10.20 11:05, Andra Paraschiv wrote:
>> Update the assigned value of the poll result to be EPOLLHUP instead of
>> POLLHUP to match the __poll_t type.
>>
>> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>> Reported-by: kernel test robot <lkp@intel.com>
>> ---
>> =A0 drivers/virt/nitro_enclaves/ne_misc_dev.c | 2 +-
>> =A0 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c =

>> b/drivers/virt/nitro_enclaves/ne_misc_dev.c
>> index f06622b48d69..9148566455e8 100644
>> --- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
>> +++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
>> @@ -1508,7 +1508,7 @@ static __poll_t ne_enclave_poll(struct file =

>> *file, poll_table *wait)
>> =A0=A0=A0=A0=A0 if (!ne_enclave->has_event)
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 return mask;
>> =A0 -=A0=A0=A0 mask =3D POLLHUP;
>> +=A0=A0=A0 mask =3D EPOLLHUP;
>
> That whole function looks a bit ... convoluted? How about this? I =

> guess you could trim it down even further, but this looks quite =

> readable to me:
>
> diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c =

> b/drivers/virt/nitro_enclaves/ne_misc_dev.c
> index f06622b48d69..5b7f45e2eb4c 100644
> --- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
> +++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
> @@ -1505,10 +1505,8 @@ static __poll_t ne_enclave_poll(struct file =

> *file, poll_table *wait)
>
> =A0=A0=A0=A0 poll_wait(file, &ne_enclave->eventq, wait);
>
> -=A0=A0=A0 if (!ne_enclave->has_event)
> -=A0=A0=A0=A0=A0=A0=A0 return mask;
> -
> -=A0=A0=A0 mask =3D POLLHUP;
> +=A0=A0=A0 if (ne_enclave->has_event)
> +=A0=A0=A0=A0=A0=A0=A0 mask |=3D POLLHUP;
>
> =A0=A0=A0=A0 return mask;
> =A0}
>

Good point, I updated the logic and sent the v2 of the patch.

https://lore.kernel.org/lkml/20201102173622.32169-1-andraprs@amazon.com/

Thank you.

Andra




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar=
 Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in R=
omania. Registration number J22/2621/2005.

