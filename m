Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 562BD2B4EAC
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 18:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387759AbgKPR4f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 12:56:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387513AbgKPR4e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 12:56:34 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC33AC0613CF;
        Mon, 16 Nov 2020 09:56:34 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1605549393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/4Dj4H4h07T3HAdVoU3L0DmQaoeq12MkqX6wjjZOegA=;
        b=nBGp3JNgdM2ohDkTTKJk3iDoHDePjcC35N1cE/kHdVkfINkXyyDrvHUtP/WpveXZe5BFgW
        C5NsffljQAIk3bx4ZPB/QKt2B4n1PKGZKDwVLMr80B07vhBNNrdSvcTDRLVhip02c2EykS
        C0yJ+BbYBfpc97IFvpks8xyZ1Pl+VSIwJvHj3MlZ7I0177vAtCom12kyEH/h0JvOHu7a+F
        SpOl07nr6kv/+P47LGoE9cSZehjaOGqrtUYgzL7D9GJIZxO2ZPtalnUvv72o09gWFKqLXZ
        yrFK5EgLGLYWCWQGi27BLzkhXCdD/dU3CUM4lu/7psDSHvE6jPhvBylg5/a1yQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1605549393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/4Dj4H4h07T3HAdVoU3L0DmQaoeq12MkqX6wjjZOegA=;
        b=xxLH7da1/bbkHaKVfEDfUOMlDxTKQrHyxLLt/pKG4NijVWYaDvU4EIFGsiDWcmWfVFWpqV
        OMKDOAshoXel6PDg==
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Tian\, Kevin" <kevin.tian@intel.com>
Cc:     "Raj\, Ashok" <ashok.raj@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Wilk\, Konrad" <konrad.wilk@oracle.com>,
        "Williams\, Dan J" <dan.j.williams@intel.com>,
        "Jiang\, Dave" <dave.jiang@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "vkoul\@kernel.org" <vkoul@kernel.org>,
        "Dey\, Megha" <megha.dey@intel.com>,
        "maz\@kernel.org" <maz@kernel.org>,
        "bhelgaas\@google.com" <bhelgaas@google.com>,
        "alex.williamson\@redhat.com" <alex.williamson@redhat.com>,
        "Pan\, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu\, Yi L" <yi.l.liu@intel.com>,
        "Lu\, Baolu" <baolu.lu@intel.com>,
        "Kumar\, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck\, Tony" <tony.luck@intel.com>,
        "kwankhede\@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger\@redhat.com" <eric.auger@redhat.com>,
        "parav\@mellanox.com" <parav@mellanox.com>,
        "rafael\@kernel.org" <rafael@kernel.org>,
        "netanelg\@mellanox.com" <netanelg@mellanox.com>,
        "shahafs\@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao\@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini\@redhat.com" <pbonzini@redhat.com>,
        "Ortiz\, Samuel" <samuel.ortiz@intel.com>,
        "Hossain\, Mona" <mona.hossain@intel.com>,
        "dmaengine\@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
In-Reply-To: <20201116154635.GK917484@nvidia.com>
References: <MWHPR11MB16455B594B1B48B6E3C97C108CE80@MWHPR11MB1645.namprd11.prod.outlook.com> <20201112193253.GG19638@char.us.oracle.com> <877dqqmc2h.fsf@nanos.tec.linutronix.de> <20201114103430.GA9810@infradead.org> <20201114211837.GB12197@araj-mobl1.jf.intel.com> <877dqmamjl.fsf@nanos.tec.linutronix.de> <20201115193156.GB14750@araj-mobl1.jf.intel.com> <875z665kz4.fsf@nanos.tec.linutronix.de> <20201116002232.GA2440@araj-mobl1.jf.intel.com> <MWHPR11MB164539B8FDE63D5CBDA300E18CE30@MWHPR11MB1645.namprd11.prod.outlook.com> <20201116154635.GK917484@nvidia.com>
Date:   Mon, 16 Nov 2020 18:56:33 +0100
Message-ID: <87y2j1xk1a.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 16 2020 at 11:46, Jason Gunthorpe wrote:

> On Mon, Nov 16, 2020 at 07:31:49AM +0000, Tian, Kevin wrote:
>
>> > The subdevices require PASID & IOMMU in native, but inside the guest there
>> > is no
>> > need for IOMMU unless you want to build SVM on top. subdevices work
>> > without
>> > any vIOMMU or hypercall in the guest. Only because they look like normal
>> > PCI devices we could map interrupts to legacy MSIx.
>> 
>> Guest managed subdevices on PF/VF requires vIOMMU. 
>
> Why? I've never heard we need vIOMMU for our existing SRIOV flows in
> VMs??

Handing PF/VF into the guest does not require it.

But if the PF/VF driver in the guest wants to create and manage the
magic mdev subdevices which require PASID support then you surely need
it.

Thanks,

        tglx
