Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 984EE220198
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 03:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbgGOBEl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 21:04:41 -0400
Received: from mga04.intel.com ([192.55.52.120]:29311 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726962AbgGOBEk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 21:04:40 -0400
IronPort-SDR: zVKxatvGwfhciKZvFCykYATBurvA8doSX6RumBn/EPvcZkUkarm86IYsHDERMxHMr4OhGPDl8W
 9+uvHk6BpHgQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9682"; a="146563181"
X-IronPort-AV: E=Sophos;i="5.75,353,1589266800"; 
   d="scan'208";a="146563181"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 18:04:38 -0700
IronPort-SDR: gbYlDs4Ly5SqxpHpBIogAaCvu597r+FyU8UGFhHgLyt2iKxmSwIjEagGJ2FHxrymAQvdzZX+Ad
 hhl4enV8Ea0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,353,1589266800"; 
   d="scan'208";a="459891197"
Received: from allen-box.sh.intel.com (HELO [10.239.159.139]) ([10.239.159.139])
  by orsmga005.jf.intel.com with ESMTP; 14 Jul 2020 18:04:36 -0700
Cc:     baolu.lu@linux.intel.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v3 4/4] vfio/type1: Use iommu_aux_at(de)tach_group() APIs
To:     Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Christoph Hellwig <hch@infradead.org>
References: <20200714055703.5510-1-baolu.lu@linux.intel.com>
 <20200714055703.5510-5-baolu.lu@linux.intel.com>
 <20200714082514.GA30622@infradead.org>
 <20200714092930.4b61b77c@jacob-builder>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <ac4507d5-a5fc-d078-9bfc-f9e9fd1244e7@linux.intel.com>
Date:   Wed, 15 Jul 2020 09:00:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200714092930.4b61b77c@jacob-builder>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Christoph and Jacob,

On 7/15/20 12:29 AM, Jacob Pan wrote:
> On Tue, 14 Jul 2020 09:25:14 +0100
> Christoph Hellwig<hch@infradead.org>  wrote:
> 
>> On Tue, Jul 14, 2020 at 01:57:03PM +0800, Lu Baolu wrote:
>>> Replace iommu_aux_at(de)tach_device() with
>>> iommu_aux_at(de)tach_group(). It also saves the
>>> IOMMU_DEV_FEAT_AUX-capable physcail device in the vfio_group data
>>> structure so that it could be reused in other places.
>> This removes the last user of iommu_aux_attach_device and
>> iommu_aux_detach_device, which can be removed now.
> it is still used in patch 2/4 inside iommu_aux_attach_group(), right?
> 

There is a need to use this interface. For example, an aux-domain is
attached to a subset of a physical device and used in the kernel. In
this usage scenario, there's no need to use vfio/mdev. The device driver
could just allocate an aux-domain and call iommu_aux_attach_device() to
setup the iommu.

Best regards,
baolu
