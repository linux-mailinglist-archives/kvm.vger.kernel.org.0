Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE982A333F
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 19:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgKBSn7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 13:43:59 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:14767 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgKBSn5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 13:43:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1604342637; x=1635878637;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=m9xa0Q50hB51kyL00HPQc1iIAciQpiHFcfPK31KVln8=;
  b=j31NjeJHPsVjZ1xtVHgliwmaw2efQko798QSGRamXpLvlsROkDMCKUVs
   GBFKTxV/WKBCTVb/G/3/ghXYq5nLBLqemGoa35QgkapEEAPjsDeyGgfDD
   okeJ+IRu2KvZWOrUYgh6vRrYmLeMTYnBewE4M7qENSH8rlsx9bPCKvn0I
   M=;
X-IronPort-AV: E=Sophos;i="5.77,445,1596499200"; 
   d="scan'208";a="82850716"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 02 Nov 2020 18:34:02 +0000
Received: from EX13D16EUB003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com (Postfix) with ESMTPS id D1F23C0696;
        Mon,  2 Nov 2020 18:29:40 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.229) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 2 Nov 2020 18:29:31 +0000
Subject: Re: [PATCH v2] nitro_enclaves: Fixup type and simplify logic of the
 poll mask setup
To:     Alexander Graf <graf@amazon.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "David Duncan" <davdunc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        "David Woodhouse" <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Karen Noel <knoel@redhat.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        "Matt Wilson" <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Stefano Garzarella" <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>,
        "Vitaly Kuznetsov" <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>
References: <20201102173622.32169-1-andraprs@amazon.com>
 <405f71a6-9699-759d-2398-a17120d3fb96@amazon.de>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <e78692ac-9133-055c-05aa-0cfd213fd5d8@amazon.com>
Date:   Mon, 2 Nov 2020 20:29:20 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <405f71a6-9699-759d-2398-a17120d3fb96@amazon.de>
Content-Language: en-US
X-Originating-IP: [10.43.160.229]
X-ClientProxiedBy: EX13P01UWA003.ant.amazon.com (10.43.160.197) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 02/11/2020 19:50, Alexander Graf wrote:
>
>
> On 02.11.20 18:36, Andra Paraschiv wrote:
>> Update the assigned value of the poll result to be EPOLLHUP instead of
>> POLLHUP to match the __poll_t type.
>>
>> While at it, simplify the logic of setting the mask result of the poll
>> function.
>>
>> Changelog
>>
>> v1 -> v2
>>
>> * Simplify the mask setting logic from the poll function.
>>
>> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>> Reported-by: kernel test robot <lkp@intel.com>
>
> Reviewed-by: Alexander Graf <graf@amazon.com>
>
>

Greg, let me know if there is anything remaining to be done for this =

patch. Otherwise, can you please add the patch to the char-misc tree.

Thanks,
Andra

>
>> ---
>> =A0 drivers/virt/nitro_enclaves/ne_misc_dev.c | 6 ++----
>> =A0 1 file changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c =

>> b/drivers/virt/nitro_enclaves/ne_misc_dev.c
>> index f06622b48d695..f1964ea4b8269 100644
>> --- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
>> +++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
>> @@ -1505,10 +1505,8 @@ static __poll_t ne_enclave_poll(struct file =

>> *file, poll_table *wait)
>> =A0 =A0=A0=A0=A0=A0 poll_wait(file, &ne_enclave->eventq, wait);
>> =A0 -=A0=A0=A0 if (!ne_enclave->has_event)
>> -=A0=A0=A0=A0=A0=A0=A0 return mask;
>> -
>> -=A0=A0=A0 mask =3D POLLHUP;
>> +=A0=A0=A0 if (ne_enclave->has_event)
>> +=A0=A0=A0=A0=A0=A0=A0 mask |=3D EPOLLHUP;
>> =A0 =A0=A0=A0=A0=A0 return mask;
>> =A0 }
>>




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar=
 Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in R=
omania. Registration number J22/2621/2005.

