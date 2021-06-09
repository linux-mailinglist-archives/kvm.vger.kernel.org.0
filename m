Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B38A83A0F38
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 11:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237635AbhFIJDr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 05:03:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231919AbhFIJDr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 05:03:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26F6B6023B;
        Wed,  9 Jun 2021 09:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623229313;
        bh=Z+zI0RDuvSuYN6v7HJscpw3B4/5MAYapaANvzw9NBwc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WmiR2RPPVpg5P331nrK6XjeWdv7pCU0af80mG7uj4/EG2o1tb9LLtohiNLtk8mpOb
         tkFIKDCEKcOcSiIcbIMGVJ/fN1JUvOts/U/6Yw1l97gZt0kPZUy4edDI5lNpXcnIHC
         W5BeTbAVwtq/9WO1fN6mDJoad1oG+A8DlCM4IJCZshJ82bV4+vGfwQkfXHIYfjD0jV
         bEtrvNChyxo6+7hO+YhBAUjFIuWHPM3pjUlKGjLtPl/N1r55hfu6xP0Jm22i9rYpGC
         TnY9mjqjTBAMX7vHcjrSXqStZ8qiBPVsWNoI4f98t6nYhC5euToDZuG5VDhnF8mgAN
         QyqLZFfoTPMdQ==
Date:   Wed, 9 Jun 2021 12:01:49 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <joro@8bytes.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: Plan for /dev/ioasid RFC v2
Message-ID: <YMCDfWLw6r80Wdu3@unreal>
References: <MWHPR11MB188699D0B9C10EB51686C4138C389@MWHPR11MB1886.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB188699D0B9C10EB51686C4138C389@MWHPR11MB1886.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 07, 2021 at 02:58:18AM +0000, Tian, Kevin wrote:
> Hi, all,

<...>

> (Remaining opens in v1)

<...>

> -   Device-centric (Jason) vs. group-centric (David) uAPI. David is not fully
>     convinced yet. Based on discussion v2 will continue to have ioasid uAPI
>     being device-centric (but it's fine for vfio to be group-centric). A new
>     section will be added to elaborate this part;

<...>

> (Adopted suggestions)

<...>

> -   (Jason) Addition of device label allows per-device capability/format 
>     check before IOASIDs are created. This leads to another major uAPI 
>     change in v2 - specify format info when creating an IOASID (mapping 
>     protocol, nesting, coherent, etc.). User is expected to check per-device 
>     format and then set proper format for IOASID upon to-be-attached 
>     device;

Sorry for my naive question, I still didn't read all v1 thread and maybe
the answer is already written, but will ask anyway.

Doesn't this adopted suggestion to allow device-specific configuration
actually means that uAPI should be device-centric?

User already needs to be aware of device, configure it explicitly, maybe
gracefully clean it later, it looks like not so much left to be group-centric.

Thanks
