Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41D21BB0A9
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 23:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbgD0ViR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 17:38:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:11912 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726259AbgD0ViQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 17:38:16 -0400
IronPort-SDR: OAepLcrguzYCcYcVhGebqoQbMw8YphuPIaYu/iYk8PSaGGuGi6AlfDf9vc9KIqLhRyr/wJr7/E
 tVHJa4iz2EYw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2020 14:38:15 -0700
IronPort-SDR: J55vk0pF84yPFVCrwNKWw1dK8bo24IMKbKbK1b3HqZGfkKQPO1BJnm1Y5aNiAd8ecyVBJ7x1jp
 JlaHbUzZhN+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,325,1583222400"; 
   d="scan'208";a="246286715"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.213.181.12]) ([10.213.181.12])
  by orsmga007.jf.intel.com with ESMTP; 27 Apr 2020 14:38:13 -0700
Subject: Re: [PATCH RFC 01/15] drivers/base: Introduce platform_msi_ops
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     vkoul@kernel.org, megha.dey@linux.intel.com, maz@kernel.org,
        bhelgaas@google.com, rafael@kernel.org, tglx@linutronix.de,
        hpa@zytor.com, alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, jgg@mellanox.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
 <158751203294.36773.11436842117908325764.stgit@djiang5-desk3.ch.intel.com>
 <20200426070118.GA2083720@kroah.com>
From:   Dave Jiang <dave.jiang@intel.com>
Message-ID: <4223511b-8dc0-33d1-6af1-831d8bf40b3d@intel.com>
Date:   Mon, 27 Apr 2020 14:38:12 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200426070118.GA2083720@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/26/2020 12:01 AM, Greg KH wrote:
> On Tue, Apr 21, 2020 at 04:33:53PM -0700, Dave Jiang wrote:
>> From: Megha Dey <megha.dey@linux.intel.com>
>>
>> This is a preparatory patch to introduce Interrupt Message Store (IMS).
>>
>> Until now, platform-msi.c provided a generic way to handle non-PCI MSI
>> interrupts. Platform-msi uses its parent chip's mask/unmask routines
>> and only provides a way to write the message in the generating device.
>>
>> Newly creeping non-PCI complaint MSI-like interrupts (Intel's IMS for
>> instance) might need to provide a device specific mask and unmask callback
>> as well, apart from the write function.
>>
>> Hence, introduce a new structure platform_msi_ops, which would provide
>> device specific write function as well as other device specific callbacks
>> (mask/unmask).
>>
>> Signed-off-by: Megha Dey <megha.dey@linux.intel.com>
> 
> As this is not following the Intel-specific rules for sending me new
> code, I am just deleting it all from my inbox.

That is my fault. As the aggregator of the patches, I should've signed 
off Megha's patches.

> 
> Please follow the rules you all have been given, they are specific and
> there for a reason.  And in looking at this code, those rules are not
> going away any time soon.
> 
> greg k-h
> 
