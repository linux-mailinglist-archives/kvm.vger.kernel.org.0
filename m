Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C51D1452B90
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 08:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbhKPH3J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 02:29:09 -0500
Received: from mga03.intel.com ([134.134.136.65]:1951 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230322AbhKPH24 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 02:28:56 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10169"; a="233580634"
X-IronPort-AV: E=Sophos;i="5.87,238,1631602800"; 
   d="scan'208";a="233580634"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 23:25:57 -0800
X-IronPort-AV: E=Sophos;i="5.87,238,1631602800"; 
   d="scan'208";a="454348715"
Received: from blu2-mobl3.ccr.corp.intel.com (HELO [10.254.215.107]) ([10.254.215.107])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 23:25:52 -0800
Message-ID: <0c1dd36f-5ef7-f41c-48e8-573ae556b65a@linux.intel.com>
Date:   Tue, 16 Nov 2021 15:25:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Cc:     baolu.lu@linux.intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>, kvm@vger.kernel.org,
        rafael@kernel.org, linux-pci@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH 05/11] iommu: Add security context management for assigned
 devices
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
References: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
 <20211115020552.2378167-6-baolu.lu@linux.intel.com>
 <YZJfMg8O/y4aLf8Q@infradead.org>
From:   Lu Baolu <baolu.lu@linux.intel.com>
In-Reply-To: <YZJfMg8O/y4aLf8Q@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/11/15 21:22, Christoph Hellwig wrote:
> On Mon, Nov 15, 2021 at 10:05:46AM +0800, Lu Baolu wrote:
>> +			/*
>> +			 * The UNMANAGED domain should be detached before all USER
>> +			 * owners have been released.
>> +			 */
> 
> Please avoid comments spilling over 80 characters.

Sure! Thanks!

Best regards,
baolu
