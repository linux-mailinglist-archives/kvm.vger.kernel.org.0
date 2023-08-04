Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF2F476F818
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 04:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbjHDCvR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 22:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbjHDCvQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 22:51:16 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635A630E5;
        Thu,  3 Aug 2023 19:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691117475; x=1722653475;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eXeTRrJrSwpkgttBNpKGEGLg5g7y0gW4h0332+UDCeo=;
  b=TKJCDu4QgnvvJ7buqagAr6r/wup2NrABbkCV1nxYLASyK1XX9dUMmOKn
   TXs3aUKfxJkY7KSDLjREM4p/ob+dJxJiRFttns7eAqFLr13J1QqzxdJ9c
   dtXEBQU7b3w9sT9lSRmIhgzNrA5ujT0CBMAsceJhfcadiMJkzGgWX/awY
   NhlrdH42w8DRoAS0YYj+JAOE3dNhUEIidgCfMjNmjK4FbkeTa0yNZg9j0
   5l05Ko8MXZznmfC39MUf8tKwKDPEMpJoeG08FVt2n2kyxn0mNlxwIXINa
   JTtMPOwuJ2eaT1V0SUI9eRVTLB2/7aFIpY/kl+RntuAAG9o3kuci246hb
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="436374499"
X-IronPort-AV: E=Sophos;i="6.01,253,1684825200"; 
   d="scan'208";a="436374499"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 19:51:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="733039611"
X-IronPort-AV: E=Sophos;i="6.01,253,1684825200"; 
   d="scan'208";a="733039611"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.254.210.88]) ([10.254.210.88])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 19:51:11 -0700
Message-ID: <5b37263b-2fea-434b-ed5f-c6f60158ea1a@linux.intel.com>
Date:   Fri, 4 Aug 2023 10:51:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Cc:     baolu.lu@linux.intel.com, "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 01/12] iommu: Move iommu fault data to linux/iommu.h
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-2-baolu.lu@linux.intel.com>
 <BN9PR11MB5276D70741353AEE610D53668C08A@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB5276D70741353AEE610D53668C08A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/8/3 15:53, Tian, Kevin wrote:
>> From: Lu Baolu <baolu.lu@linux.intel.com>
>> Sent: Thursday, July 27, 2023 1:48 PM
>>
>> The iommu fault data is currently defined in uapi/linux/iommu.h, but is
>> only used inside the iommu subsystem. Move it to linux/iommu.h, where it
>> will be more accessible to kernel drivers.
>>
>> With this done, uapi/linux/iommu.h becomes empty and can be removed
>> from
>> the tree.
>>
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> ---
>>   include/linux/iommu.h      | 152 +++++++++++++++++++++++++++++++++-
>>   include/uapi/linux/iommu.h | 161 -------------------------------------
>>   MAINTAINERS                |   1 -
>>   3 files changed, 151 insertions(+), 163 deletions(-)
>>   delete mode 100644 include/uapi/linux/iommu.h
>>
> 
> put this behind patch2/3 then there are less lines to be moved.

My idea was that "include/uapi/linux.h" is not used anywhere and we no
longer want to maintain it. Hence, we should remove it before changing
any lines inside it.

Best regards,
baolu
