Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53F4B1F80C
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 17:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbfEOP6O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 11:58:14 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:47634 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726335AbfEOP6N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 11:58:13 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0A615374;
        Wed, 15 May 2019 08:58:13 -0700 (PDT)
Received: from [10.1.196.129] (ostrya.cambridge.arm.com [10.1.196.129])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 16E9D3F703;
        Wed, 15 May 2019 08:58:09 -0700 (PDT)
Subject: Re: [PATCH v7 04/23] iommu: Introduce attach/detach_pasid_table API
To:     Auger Eric <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
        alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
        yi.l.liu@intel.com, will.deacon@arm.com, robin.murphy@arm.com
Cc:     peter.maydell@linaro.org, kevin.tian@intel.com,
        vincent.stehle@arm.com, ashok.raj@intel.com, marc.zyngier@arm.com,
        christoffer.dall@arm.com
References: <20190408121911.24103-1-eric.auger@redhat.com>
 <20190408121911.24103-5-eric.auger@redhat.com>
 <21bfdab4-846c-1dc7-6dff-62a46cc9c829@arm.com>
 <b4c47851-0269-5aa2-682a-77677f756205@redhat.com>
From:   Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Message-ID: <9fedefb7-e13c-7ea7-b2ae-50a8f1a7e09b@arm.com>
Date:   Wed, 15 May 2019 16:57:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <b4c47851-0269-5aa2-682a-77677f756205@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/05/2019 14:06, Auger Eric wrote:
> Hi Jean-Philippe,
> 
> On 5/15/19 2:09 PM, Jean-Philippe Brucker wrote:
>> On 08/04/2019 13:18, Eric Auger wrote:
>>> diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
>>> index edcc0dda7993..532a64075f23 100644
>>> --- a/include/uapi/linux/iommu.h
>>> +++ b/include/uapi/linux/iommu.h
>>> @@ -112,4 +112,51 @@ struct iommu_fault {
>>>  		struct iommu_fault_page_request prm;
>>>  	};
>>>  };
>>> +
>>> +/**
>>> + * SMMUv3 Stream Table Entry stage 1 related information
>>> + * The PASID table is referred to as the context descriptor (CD) table.
>>> + *
>>> + * @s1fmt: STE s1fmt (format of the CD table: single CD, linear table
>>> +   or 2-level table)
>>
>> Running "scripts/kernel-doc -v -none" on this header produces some
>> warnings. Not sure if we want to get rid of all of them, but we should
>> at least fix the coding style for this comment (line must start with
>> " * "). I'm fixing it up on my sva/api branch
> Thanks!
> 
> Let me know if you want me to do the job for additional fixes.

I fixed the others warnings as well, in case we ever want to include
this into the kernel doc

Thanks,
Jean

