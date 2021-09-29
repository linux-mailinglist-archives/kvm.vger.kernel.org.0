Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6CAB41C195
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 11:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245042AbhI2J1O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 05:27:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:60796 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229487AbhI2J1I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 05:27:08 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10121"; a="224940094"
X-IronPort-AV: E=Sophos;i="5.85,331,1624345200"; 
   d="scan'208";a="224940094"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2021 02:25:27 -0700
X-IronPort-AV: E=Sophos;i="5.85,331,1624345200"; 
   d="scan'208";a="563136465"
Received: from blu2-mobl3.ccr.corp.intel.com (HELO [10.254.210.53]) ([10.254.210.53])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2021 02:25:21 -0700
Cc:     baolu.lu@linux.intel.com, alex.williamson@redhat.com,
        jgg@nvidia.com, hch@lst.de, jasowang@redhat.com, joro@8bytes.org,
        jean-philippe@linaro.org, kevin.tian@intel.com, parav@mellanox.com,
        lkml@metux.net, pbonzini@redhat.com, lushenming@huawei.com,
        eric.auger@redhat.com, corbet@lwn.net, ashok.raj@intel.com,
        yi.l.liu@linux.intel.com, jun.j.tian@intel.com, hao.wu@intel.com,
        dave.jiang@intel.com, jacob.jun.pan@linux.intel.com,
        kwankhede@nvidia.com, robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, nicolinc@nvidia.com
Subject: Re: [RFC 04/20] iommu: Add iommu_device_get_info interface
To:     David Gibson <david@gibson.dropbear.id.au>,
        Liu Yi L <yi.l.liu@intel.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-5-yi.l.liu@intel.com> <YVPU89utk3JFPzS7@yekko>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <21cd618b-3ea6-dc89-cc79-e0927dece927@linux.intel.com>
Date:   Wed, 29 Sep 2021 17:25:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YVPU89utk3JFPzS7@yekko>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi David,

On 2021/9/29 10:52, David Gibson wrote:
> On Sun, Sep 19, 2021 at 02:38:32PM +0800, Liu Yi L wrote:
>> From: Lu Baolu<baolu.lu@linux.intel.com>
>>
>> This provides an interface for upper layers to get the per-device iommu
>> attributes.
>>
>>      int iommu_device_get_info(struct device *dev,
>>                                enum iommu_devattr attr, void *data);
> That fact that this interface doesn't let you know how to size the
> data buffer, other than by just knowing the right size for each attr
> concerns me.
> 

We plan to address this by following the comments here.

https://lore.kernel.org/linux-iommu/20210921161930.GP327412@nvidia.com/

Best regards,
baolu
