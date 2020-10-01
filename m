Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4E5D280849
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 22:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732836AbgJAUQ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 16:16:28 -0400
Received: from mga03.intel.com ([134.134.136.65]:22504 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726606AbgJAUQ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Oct 2020 16:16:28 -0400
IronPort-SDR: GtCHumbbjretZKGy7GcqDd/cJ2HD68/CwEAC44HphGkOxqy1nPsxHmZQkmI6uDNdVoDcU918LK
 hIBCxOL9WIrw==
X-IronPort-AV: E=McAfee;i="6000,8403,9761"; a="162905240"
X-IronPort-AV: E=Sophos;i="5.77,325,1596524400"; 
   d="scan'208";a="162905240"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2020 13:16:26 -0700
IronPort-SDR: e3hlJtscKSDwiMWFlsQr9QOKArY5bF2sy1Dil9b6aYEGenVDaoVQ6aKK7pO9p4pdXCFZ0Nftmk
 6ujwKWs6QFbA==
X-IronPort-AV: E=Sophos;i="5.77,325,1596524400"; 
   d="scan'208";a="351290865"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.212.6.80]) ([10.212.6.80])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2020 13:16:25 -0700
Subject: Re: [PATCH v3 04/18] dmaengine: idxd: add interrupt handle request
 support
To:     Thomas Gleixner <tglx@linutronix.de>, vkoul@kernel.org,
        megha.dey@intel.com, maz@kernel.org, bhelgaas@google.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, jgg@mellanox.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        rafael@kernel.org, netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
References: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com>
 <160021248280.67751.12525558281536923518.stgit@djiang5-desk3.ch.intel.com>
 <87v9fvglhm.fsf@nanos.tec.linutronix.de>
From:   Dave Jiang <dave.jiang@intel.com>
Message-ID: <999e3cde-5f3e-17d8-e76f-8294c08138ab@intel.com>
Date:   Thu, 1 Oct 2020 13:16:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <87v9fvglhm.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/30/2020 11:36 AM, Thomas Gleixner wrote:
> On Tue, Sep 15 2020 at 16:28, Dave Jiang wrote:
>>   
>> +#define INT_HANDLE_IMS_TABLE	0x10000
>> +int idxd_device_request_int_handle(struct idxd_device *idxd, int idx,
>> +				   int *handle, enum idxd_interrupt_type irq_type)
> 
> New lines exist for a reason and this glued together define and function
> definition is unreadable garbage.
> 
> Also is that magic bit a software flag or defined by hardware? If the
> latter then you want to move it to the other hardware defines.

Will move this to hardware register header.

> 
> Thanks,
> 
>          tglx
>   
> 
