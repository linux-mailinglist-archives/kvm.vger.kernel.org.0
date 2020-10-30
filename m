Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 436F92A1129
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 23:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725923AbgJ3Wt0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 18:49:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:23281 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbgJ3WtZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 18:49:25 -0400
IronPort-SDR: xvHP9KyiMOSkzfpmXgBAkb/NqqcuufOSktON1+XHZ6UVlCnTuD7yuPsjibNhVoNYI8PpYcTM7e
 godcSAvnggKQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9790"; a="155656579"
X-IronPort-AV: E=Sophos;i="5.77,435,1596524400"; 
   d="scan'208";a="155656579"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 15:49:25 -0700
IronPort-SDR: 7ZM9QMRY/Wez4GSkU5zNjdNDr6V8m80A/dwpXjyFVUfna1xlTogOVVfZKHsnOrmqUwbO/R4Wfi
 +z85XKvlkEcg==
X-IronPort-AV: E=Sophos;i="5.77,435,1596524400"; 
   d="scan'208";a="362581258"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.209.46.60]) ([10.209.46.60])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 15:49:23 -0700
Subject: Re: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>, vkoul@kernel.org,
        megha.dey@intel.com, maz@kernel.org, bhelgaas@google.com,
        tglx@linutronix.de, alex.williamson@redhat.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        rafael@kernel.org, netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org
References: <20201030195159.GA589138@bjorn-Precision-5520>
 <71da5f66-e929-bab1-a1c6-a9ac9627a141@intel.com>
 <20201030224534.GN2620339@nvidia.com>
From:   Dave Jiang <dave.jiang@intel.com>
Message-ID: <ec52cedf-3a99-5ca1-ffbb-d8f8c4f62395@intel.com>
Date:   Fri, 30 Oct 2020 15:49:22 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201030224534.GN2620339@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/30/2020 3:45 PM, Jason Gunthorpe wrote:
> On Fri, Oct 30, 2020 at 02:20:03PM -0700, Dave Jiang wrote:
>> So the intel-iommu driver checks for the SIOV cap. And the idxd driver
>> checks for SIOV and IMS cap. There will be other upcoming drivers that will
>> check for such cap too. It is Intel vendor specific right now, but SIOV is
>> public and other vendors may implement to the spec. Is there a good place to
>> put the common capability check for that?
> 
> I'm still really unhappy with these SIOV caps. It was explained this
> is just a hack to make up for pci_ims_array_create_msi_irq_domain()
> succeeding in VM cases when it doesn't actually work.
> 
> Someday this is likely to get fixed, so tying platform behavior to PCI
> caps is completely wrong.
> 
> This needs to be solved in the platform code,
> pci_ims_array_create_msi_irq_domain() should not succeed in these
> cases.

That sounds reasonable. Are you asking that the IMS cap check should gate the 
success/failure of pci_ims_array_create_msi_irq_domain() rather than the driver?

> 
> Jason
> 
