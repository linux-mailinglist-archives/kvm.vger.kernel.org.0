Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71DBA2A0FBE
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 21:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbgJ3Uw4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 16:52:56 -0400
Received: from mga17.intel.com ([192.55.52.151]:1570 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbgJ3Uw4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 16:52:56 -0400
IronPort-SDR: kbKyRXay1OcYhZQMRis7eJrq/8AahlHc9QLM5OnMXkVYDeisRoJ9mzGNOJXDyx3sB9fWv6R3J4
 FxnmXtPAuz3A==
X-IronPort-AV: E=McAfee;i="6000,8403,9790"; a="148521141"
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="148521141"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 13:52:56 -0700
IronPort-SDR: 01Yln5I7jfUXoNULl5jivpI90WzlySVw8hi+at3tAqAFt/5g3W6RmX4Rs0HeZC75/LTbAPIUH0
 gPy9UBCWmA0g==
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="362555218"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.209.46.60]) ([10.209.46.60])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 13:52:54 -0700
Subject: Re: [PATCH v4 02/17] iommu/vt-d: Add DEV-MSI support
To:     Thomas Gleixner <tglx@linutronix.de>, vkoul@kernel.org,
        megha.dey@intel.com, maz@kernel.org, bhelgaas@google.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, jgg@mellanox.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        rafael@kernel.org, netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org
References: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
 <160408386122.912050.7027904087316715077.stgit@djiang5-desk3.ch.intel.com>
 <87eelfmp6f.fsf@nanos.tec.linutronix.de>
From:   Dave Jiang <dave.jiang@intel.com>
Message-ID: <4e438a37-022a-97ab-88e9-ef11b9a84ffe@intel.com>
Date:   Fri, 30 Oct 2020 13:52:52 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <87eelfmp6f.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/30/2020 1:31 PM, Thomas Gleixner wrote:
> On Fri, Oct 30 2020 at 11:51, Dave Jiang wrote:
>> From: Megha Dey <megha.dey@intel.com>
> 
> This conflicts with
> 
>       git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/apic

I'll get that fixed up. Thanks!

> 
> Thanks,
> 
>          tglx
> 
