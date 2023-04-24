Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2486EC3C3
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 04:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbjDXCux (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Apr 2023 22:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjDXCuw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Apr 2023 22:50:52 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45284211D
        for <kvm@vger.kernel.org>; Sun, 23 Apr 2023 19:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682304651; x=1713840651;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GOMTZaSoUp256Vix08jhKCvQRsm1uFL2LGJQqar2An0=;
  b=JD9UzfxC4dXiSobFfO3muMIsLROnjC+bRXd+Kcd6ozk0SrVu0w4FntyI
   hPlTSXMVM52Bz1ldKPExrinNI1+Ob3GCnU2RXvITghVSqhJkmylfDrN9+
   qtCPQkgRvFrCU+4rI+HbzlJjbjdsHyJT99seayK5aDBVsptTEgm8rlPJb
   QkgBSKk4bxGNWkstmMboSiwWxAPKUhSCaE7Ryq3c9ytYtDPEECmr8pPLL
   jkSiT+Yt4eDGzXqLyaITrILiKx/r4SplsGQJhfXo96rOClCGw7elsZ2Yh
   xDzJRIdsKgmc9jfFSp2aFblmIt7qfR1dExn2xz7W3CAr6lXbTIFRPzqVf
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="348255078"
X-IronPort-AV: E=Sophos;i="5.99,221,1677571200"; 
   d="scan'208";a="348255078"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2023 19:50:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="723426123"
X-IronPort-AV: E=Sophos;i="5.99,221,1677571200"; 
   d="scan'208";a="723426123"
Received: from allen-box.sh.intel.com (HELO [10.239.159.127]) ([10.239.159.127])
  by orsmga008.jf.intel.com with ESMTP; 23 Apr 2023 19:50:48 -0700
Message-ID: <b845fc36-5167-1aa7-25cf-35bb5d578087@linux.intel.com>
Date:   Mon, 24 Apr 2023 10:50:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Cc:     baolu.lu@linux.intel.com, Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
Subject: Re: RMRR device on non-Intel platform
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
References: <BN9PR11MB5276E84229B5BD952D78E9598C639@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230420081539.6bf301ad.alex.williamson@redhat.com>
 <6cce1c5d-ab50-41c4-6e62-661bc369d860@arm.com>
 <20230420084906.2e4cce42.alex.williamson@redhat.com>
 <fd324213-8d77-cb67-1c52-01cd0997a92c@arm.com>
 <20230420154933.1a79de4e.alex.williamson@redhat.com>
 <ZEJ73s/2M4Rd5r/X@nvidia.com>
 <BN9PR11MB5276723C89B46201F471F7E78C669@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB5276723C89B46201F471F7E78C669@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/23/23 4:24 PM, Tian, Kevin wrote:
>> From: Jason Gunthorpe <jgg@nvidia.com>
>> Sent: Friday, April 21, 2023 8:05 PM
>>
>> So, after my domain error handling series, the core fix is pretty
>> simple and universal. We should also remove all the redundant code in
>> drivers - drivers should report the regions each devices needs
>> properly and leave enforcement to the core code.. Lu/Kevin do you want
>> to take this?
>>
> 
> this direction looks good to me.

Looks good to me too. I will take this work after Jason's series lands.

Best regards,
baolu
