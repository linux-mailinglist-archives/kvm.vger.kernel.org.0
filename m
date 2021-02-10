Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE45317475
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 00:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233800AbhBJXdP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 18:33:15 -0500
Received: from mga05.intel.com ([192.55.52.43]:2015 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231815AbhBJXdI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 18:33:08 -0500
IronPort-SDR: RMREcKz370w3SpE8lQCB8XOEMzU2dCsB7HLy3VBBT49mcSln6gItKu6KQ0ifWLPeceaG6yiNJ8
 CjJ9jkvzZMeg==
X-IronPort-AV: E=McAfee;i="6000,8403,9891"; a="267009738"
X-IronPort-AV: E=Sophos;i="5.81,169,1610438400"; 
   d="scan'208";a="267009738"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2021 15:32:27 -0800
IronPort-SDR: VyTEMK3rM3wGmhWVpzYqyIKs6nvgYDR3EfvOaWZbl2r2TFtbQkAy/WgBp0XacCu5NH3K1G/yXh
 1j1cSilC3lYw==
X-IronPort-AV: E=Sophos;i="5.81,169,1610438400"; 
   d="scan'208";a="436862136"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.213.187.135]) ([10.213.187.135])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2021 15:32:25 -0800
Subject: Re: [PATCH v5 02/14] dmaengine: idxd: add IMS detection in base
 driver
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org, megha.dey@intel.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, dan.j.williams@intel.com,
        eric.auger@redhat.com, parav@mellanox.com, netanelg@mellanox.com,
        shahafs@mellanox.com, pbonzini@redhat.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <161255810396.339900.7646244556839438765.stgit@djiang5-desk3.ch.intel.com>
 <161255838583.339900.1371114106574605023.stgit@djiang5-desk3.ch.intel.com>
 <20210210233000.GH4247@nvidia.com>
From:   Dave Jiang <dave.jiang@intel.com>
Message-ID: <412e40cc-3982-7301-661f-eb57a4a9144c@intel.com>
Date:   Wed, 10 Feb 2021 16:32:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210210233000.GH4247@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/10/2021 4:30 PM, Jason Gunthorpe wrote:
> On Fri, Feb 05, 2021 at 01:53:05PM -0700, Dave Jiang wrote:
>
>> diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
>> index 21c1e23cdf23..ab5c76e1226b 100644
>> +++ b/drivers/dma/idxd/sysfs.c
>> @@ -1444,6 +1444,14 @@ static ssize_t numa_node_show(struct device *dev,
>>   }
>>   static DEVICE_ATTR_RO(numa_node);
>>   
>> +static ssize_t ims_size_show(struct device *dev, struct device_attribute *attr, char *buf)
>> +{
>> +	struct idxd_device *idxd = container_of(dev, struct idxd_device, conf_dev);
>> +
>> +	return sprintf(buf, "%u\n", idxd->ims_size);
>> +}
> use sysfs_emit for all new sysfs functions please

Will fix. Thanks!


>
> Jason
