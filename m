Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10912396CC3
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 07:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbhFAF0E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 01:26:04 -0400
Received: from mga03.intel.com ([134.134.136.65]:46455 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229521AbhFAF0C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 01:26:02 -0400
IronPort-SDR: YbTWwSOBbZVsDosE0wgD8Tz2wwMRLVGJvLcHijLsoJWpmPIlcRr4adhSgbZufiV2pMokqHfKC3
 YLmIKflH0gHg==
X-IronPort-AV: E=McAfee;i="6200,9189,10001"; a="203508638"
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="203508638"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2021 22:24:21 -0700
IronPort-SDR: 9/26xGdp6Lz9x66jJdkf3SzA1PYii11BJIvKVB0+a/56W0qSgeYjSmdylmkMihaKUpOfvXuquH
 x+Vy+yi2JzkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="632749269"
Received: from allen-box.sh.intel.com (HELO [10.239.159.105]) ([10.239.159.105])
  by fmsmga006.fm.intel.com with ESMTP; 31 May 2021 22:24:16 -0700
Cc:     baolu.lu@linux.intel.com, yi.l.liu@intel.com,
        "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)\"\"" 
        <alex.williamson@redhat.com>, Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
To:     Jason Wang <jasowang@redhat.com>,
        Liu Yi L <yi.l.liu@linux.intel.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <f510f916-e91c-236d-e938-513a5992d3b5@redhat.com>
 <20210531164118.265789ee@yiliu-dev>
 <78ee2638-1a03-fcc8-50a5-81040f677e69@redhat.com>
 <20210601113152.6d09e47b@yiliu-dev>
 <164ee532-17b0-e180-81d3-12d49b82ac9f@redhat.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <64898584-a482-e6ac-fd71-23549368c508@linux.intel.com>
Date:   Tue, 1 Jun 2021 13:23:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <164ee532-17b0-e180-81d3-12d49b82ac9f@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason W,

On 6/1/21 1:08 PM, Jason Wang wrote:
>>> 2) If yes, what's the reason for not simply use the fd opened from
>>> /dev/ioas. (This is the question that is not answered) and what happens
>>> if we call GET_INFO for the ioasid_fd?
>>> 3) If not, how GET_INFO work?
>> oh, missed this question in prior reply. Personally, no special reason
>> yet. But using ID may give us opportunity to customize the management
>> of the handle. For one, better lookup efficiency by using xarray to
>> store the allocated IDs. For two, could categorize the allocated IDs
>> (parent or nested). GET_INFO just works with an input FD and an ID.
> 
> 
> I'm not sure I get this, for nesting cases you can still make the child 
> an fd.
> 
> And a question still, under what case we need to create multiple ioasids 
> on a single ioasid fd?

One possible situation where multiple IOASIDs per FD could be used is
that devices with different underlying IOMMU capabilities are sharing a
single FD. In this case, only devices with consistent underlying IOMMU
capabilities could be put in an IOASID and multiple IOASIDs per FD could
be applied.

Though, I still not sure about "multiple IOASID per-FD" vs "multiple
IOASID FDs" for such case.

Best regards,
baolu
