Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F25228720
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 19:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730134AbgGURRj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 13:17:39 -0400
Received: from mga07.intel.com ([134.134.136.100]:10555 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729286AbgGURRj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 13:17:39 -0400
IronPort-SDR: TTKTiD8Ty3QSBBnkPynzNIf8DupNlcN7W5j+3dnNvSWhyXDmxGEnITs4cCfsOeX85wqxHDFp4M
 LSsXoZj4rC9Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="214839140"
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="214839140"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2020 10:17:36 -0700
IronPort-SDR: PRmyN7gp5wF41uVRnfVHJOfgingQ7F3tDTAjGVtjK7KHwH+C+64WU0/RcXp7UrW8eXBvcXHznz
 OpytWloy/2sA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="326434915"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.213.181.166]) ([10.213.181.166])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Jul 2020 10:17:35 -0700
Subject: Re: [PATCH RFC v2 00/18] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     vkoul@kernel.org, megha.dey@intel.com, maz@kernel.org,
        bhelgaas@google.com, rafael@kernel.org, tglx@linutronix.de,
        hpa@zytor.com, alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, jgg@mellanox.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        dave.hansen@intel.com, netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
 <20200721162858.GA2139881@kroah.com>
From:   Dave Jiang <dave.jiang@intel.com>
Message-ID: <754118ac-0c3f-c870-eb6e-f7bc24014cfc@intel.com>
Date:   Tue, 21 Jul 2020 10:17:34 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200721162858.GA2139881@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/21/2020 9:28 AM, Greg KH wrote:
> On Tue, Jul 21, 2020 at 09:02:15AM -0700, Dave Jiang wrote:
>> v2:
> 
> "RFC" to me means "I don't really think this is mergable, so I'm
> throwing it out there."  Which implies you know it needs more work
> before others should review it as you are not comfortable with it :(
> 
> So, back-of-the-queue you go...
> 
> greg k-h
> 

Hi Greg! Yes this absolutely needs more work! I think it's in pretty good shape, 
but it has reached the point where it needs the talented eyes of reviewers from 
outside of Intel. I was really hoping to get feedback from folks like Jason 
(Thanks Jason!!) and KVM and VFIO experts like Alex, Paolo, Eric, and Kirti.

I can understand that you are quite busy and can not necessarily provide a 
detailed review at this phase. Would you prefer to be cc'd on code at this phase 
in the future? Or, should we reserve putting you on the cc for times when we 
know it's ready for merge?
