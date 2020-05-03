Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0F341C3025
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 00:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbgECWl5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 May 2020 18:41:57 -0400
Received: from mga05.intel.com ([192.55.52.43]:24309 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729174AbgECWl5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 May 2020 18:41:57 -0400
IronPort-SDR: G+OQ22H03Bp8sdN9yvJvMERvqmEKCW5Xia/BWUd4cVKJNwRpSsltdidq9/6+fKZu+X4VzWxBNs
 Ju2v2/wbzZXA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2020 15:41:57 -0700
IronPort-SDR: PIZ87LicNVawY0Hze2wXvPIyEYsAv4y084iXwFfeCni7x5fOKk4VIZ1PgzbMLFhjV3ymvUoLFD
 ammYMAaaUhtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,349,1583222400"; 
   d="scan'208";a="406301409"
Received: from meghadey-mobl1.amr.corp.intel.com (HELO [10.212.197.87]) ([10.212.197.87])
  by orsmga004.jf.intel.com with ESMTP; 03 May 2020 15:41:55 -0700
Subject: Re: [PATCH RFC 07/15] Documentation: Interrupt Message store
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Dave Jiang <dave.jiang@intel.com>, vkoul@kernel.org,
        maz@kernel.org, bhelgaas@google.com, rafael@kernel.org,
        gregkh@linuxfoundation.org, tglx@linutronix.de, hpa@zytor.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, baolu.lu@intel.com,
        kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
 <158751207000.36773.18208950543781892.stgit@djiang5-desk3.ch.intel.com>
 <20200423200436.GA29181@ziepe.ca>
 <afd2ae49-ed65-5cde-c867-a923ac9bf8ac@linux.intel.com>
 <20200503222855.GT26002@ziepe.ca>
From:   "Dey, Megha" <megha.dey@linux.intel.com>
Message-ID: <e8788adb-6993-2885-d91b-1541fbff02f4@linux.intel.com>
Date:   Sun, 3 May 2020 15:41:55 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200503222855.GT26002@ziepe.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/3/2020 3:28 PM, Jason Gunthorpe wrote:
> On Fri, May 01, 2020 at 03:32:22PM -0700, Dey, Megha wrote:
>> Hi Jason,
>>
>> On 4/23/2020 1:04 PM, Jason Gunthorpe wrote:
>>> On Tue, Apr 21, 2020 at 04:34:30PM -0700, Dave Jiang wrote:
>>>
>>>> diff --git a/Documentation/ims-howto.rst b/Documentation/ims-howto.rst
>>>> new file mode 100644
>>>> index 000000000000..a18de152b393
>>>> +++ b/Documentation/ims-howto.rst
>>>> @@ -0,0 +1,210 @@
>>>> +.. SPDX-License-Identifier: GPL-2.0
>>>> +.. include:: <isonum.txt>
>>>> +
>>>> +==========================
>>>> +The IMS Driver Guide HOWTO
>>>> +==========================
>>>> +
>>>> +:Authors: Megha Dey
>>>> +
>>>> +:Copyright: 2020 Intel Corporation
>>>> +
>>>> +About this guide
>>>> +================
>>>> +
>>>> +This guide describes the basics of Interrupt Message Store (IMS), the
>>>> +need to introduce a new interrupt mechanism, implementation details of
>>>> +IMS in the kernel, driver changes required to support IMS and the general
>>>> +misconceptions and FAQs associated with IMS.
>>>
>>> I'm not sure why we need to call this IMS in kernel documentat? I know
>>> Intel is using this term, but this document is really only talking
>>> about extending the existing platform_msi stuff, which looks pretty
>>> good actually.
>>
>> hmmm, so maybe we call it something else or just say dynamic platform-msi?
>>
>>>
>>> A lot of this is good for the cover letter..
>>
>> Well, I got a lot of comments internally and externally about how the cover
>> page needs to have just the basics and all the ugly details can go in the
>> Documentation. So well, I am confused here.
> 
> Documentation should be documentation for users and developers.
> 
> Justification and rational for why functionality should be merged
> belong in the commit message and cover letter, IMHO.
> 
> Here too much time is spent belabouring IMS's rational and not enough
> is spent explaining how a driver should consume it or how a platform
> should provide it.
> 
> And since most of this tightly related to platform-msi it might make
> sense to start by documenting platform msi then adding a diff on that
> to explain what change is being made to accommodate IMS.
> 
> Most likely few people are very familiar with platform-msi in the
> first place..

Ok makes sense, will rework this in the next version..
> 
> Jason
> 
