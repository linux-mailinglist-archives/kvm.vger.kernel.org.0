Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF9D6FF093
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 13:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237778AbjEKLea (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 07:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235855AbjEKLe3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 07:34:29 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129ED1726;
        Thu, 11 May 2023 04:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683804868; x=1715340868;
  h=message-id:date:mime-version:from:subject:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=BUHo0rVNqKyIe58G35kkseoJDroPHq977gxNkS+A3BM=;
  b=OA0zkWH9mprnQ9dNzfj03MUpY1QttNoIrQ+xpdA9x+2IuBISZgZGJm+Z
   FuxxBlzNaN6cJko30s5a0ZkFLBq1vsJCoSOxYTcUDrcaXkFYOqIrZpu8i
   ptW3dRTaOioSmTK1a3mSgizitxy5LOfAZWYckA9GmX3bYgsLa1ELvFkpD
   hJ2frkY8x3HbUUY7VJT6OiCvpjTdDMGKWPb4TmEW+LXuYaOqQJTgVcyMl
   OMNMBUYh9EFDRPwPjrc2qB/c+lx9/AllT/TH0r8G+3PpCj/jVJq1O4BVg
   lXjp+a7TBgz9XjME+Hqs/6ldWXCMs2t3pVINaEUFPKn6l8qWSgHx3Xjhr
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="352682503"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="352682503"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 04:34:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="693762633"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="693762633"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.254.214.148]) ([10.254.214.148])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 04:34:25 -0700
Message-ID: <49063f2e-4ab5-1e20-093d-e1a0b3c15481@linux.intel.com>
Date:   Thu, 11 May 2023 19:34:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
From:   Baolu Lu <baolu.lu@linux.intel.com>
Subject: Re: vPASID capability for VF
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     baolu.lu@linux.intel.com, Jason Gunthorpe <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
References: <BN9PR11MB52764BE569672A02FE2A8CCA8C769@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230510112449.4d766f6f.alex.williamson@redhat.com>
 <BN9PR11MB52769ABFE779CE1D8838A7A78C749@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
In-Reply-To: <BN9PR11MB52769ABFE779CE1D8838A7A78C749@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/11/23 3:27 PM, Tian, Kevin wrote:
>> From: Alex Williamson<alex.williamson@redhat.com>
>> Sent: Thursday, May 11, 2023 1:25 AM
>>
>> On Tue, 9 May 2023 08:34:53 +0000
>> "Tian, Kevin"<kevin.tian@intel.com>  wrote:
>>
>>> According to PCIe spec (7.8.9 PASID Extended Capability Structure):
>>>
>>>    The PASID configuration of the single non-VF Function representing
>>>    the device is also used by all VFs in the device. A PF is permitted
>>>    to implement the PASID capability, but VFs must not implement it.
>>>
>>> To enable PASID on VF then one open is where to locate the PASID
>>> capability in VF's vconfig space. vfio-pci doesn't know which offset
>>> may contain VF specific config registers. Finding such offset must
>>> come from a device specific knowledge.
>> Backup for a moment, VFs are governed by the PASID capability on the
>> PF.  The PASID capability exposes control registers that imply the
>> ability to manage various feature enable bits.  The VF owner does not
>> have privileges to manipulate those bits.  For example, the PASID Enable
>> bit should restrict the endpoint from sending TLPs with a PASID prefix,
>> but this can only be changed at the PF level for all associated VFs.
>>
>> The protocol specified in 7.8.9.3 defines this enable bit as RW.  How do
>> we virtualize that?  Either it's virtualized to be read-only and we
>> violate the spec or we allow it to be read-write and it has no effect,
>> which violates the spec.
>>
> Currently the PASID cap is enabled by default when a device is probed
> by iommu driver. Leaving it enabled in PF while guest wants it disabled
> in VF is harmless. W/o proper setup in iommu side the VF cannot
> do real work with PASID.

[sorry for partial reply]

I am attempting to move PASID enabling/disabling out of the iommu
driver and give its control to the device driver. One puzzle thing is
that PCI spec requires PASID control bits not changed once the ATS is
is enabled. So I also need to add iommu interfaces to enable/disable
ATS on devices.

By default, the ATS is enabled by the iommu subsystem to utilize the
device TLB, the device driver needs to disable it before change the
PASID control bits and re-enable it afterwards.

I have patches in my local tree, if the pasid virtualization requires
them, I can bring it up for discussion.

Best regards,
baolu
