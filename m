Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2904E396BC1
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 05:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232719AbhFADLq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 23:11:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:61872 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232268AbhFADLq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 May 2021 23:11:46 -0400
IronPort-SDR: srMUuq/4w0gJiKhUaG4NWJWKp9mWyv7LwGCGrC6/dHXPxb9164XJ7pagcSlfET2DdfjMuu8bW5
 CPQegpieqZNg==
X-IronPort-AV: E=McAfee;i="6200,9189,10001"; a="200446690"
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="200446690"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2021 20:10:04 -0700
IronPort-SDR: ULzOL29Vz/IvsNNwQwQA6U77N3rMZEqYfgfyjQyFc8zsTXp9NGuDPeuj9u/nToeVpAZVE4iwh8
 yIPDfw8wzWLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="632725264"
Received: from allen-box.sh.intel.com (HELO [10.239.159.105]) ([10.239.159.105])
  by fmsmga006.fm.intel.com with ESMTP; 31 May 2021 20:10:01 -0700
Cc:     baolu.lu@linux.intel.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Robin Murphy <robin.murphy@arm.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Liu Yi L <yi.l.liu@linux.intel.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528233649.GB3816344@nvidia.com> <20210531193157.5494e6c6@yiliu-dev>
 <20210531180911.GX1002214@nvidia.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <6ca65628-1c0e-4ae3-6357-1493f993349e@linux.intel.com>
Date:   Tue, 1 Jun 2021 11:08:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210531180911.GX1002214@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/1/21 2:09 AM, Jason Gunthorpe wrote:
>>> device bind should fail if the device somehow isn't compatible with
>>> the scheme the user is tring to use.
>> yeah, I guess you mean to fail the device attach when the IOASID is a
>> nesting IOASID but the device is behind an iommu without nesting support.
>> right?
> Right..
>   

Just want to confirm...

Does this mean that we only support hardware nesting and don't want to
have soft nesting (shadowed page table in kernel) in IOASID?

Best regards,
baolu
