Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7475F2AD908
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 15:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730853AbgKJOmM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 09:42:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730059AbgKJOmL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 09:42:11 -0500
Received: from twosheds.infradead.org (twosheds.infradead.org [IPv6:2001:8b0:10b:1:21d:7dff:fe04:dbe2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56C1C0613CF;
        Tue, 10 Nov 2020 06:42:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=twosheds.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Cc:To:From:Subject:Date:References:In-Reply-To:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0dwxESZhE6qS0tRQVz8GERHRJWul6w0ygr/xjcdQRuo=; b=mZ0oOKzHKaYt5WTaP1PaQHA31
        hJGt7ocnCK64bHABuSiLoI8hM12VVmUFEK8fMQgljLzb9F59hV65Yh5RJrPUF6WSwpcZZay6vVckf
        5jFfVUBJY7+dbA4hix2kHzk49frDVnm/1Dyd2BbNruEvlV6+kZE2xvghEzd6G8HwJzYrWuEQzBLYM
        KsoA/q6laDk4xYgXSR5gRc1NFrYS1StLyRtXqSsY/DYwvjlnEK3yPDC1UQ0IYlzOUGoSjOBVFSgrz
        0vNdgd6lUIbXyflZPkrGx5B3HA5Gnyva/dZYHpHDnvr5P3cliTG4acFvyFJSYjyh99+8B/PRkqiGI
        93+pqJqqA==;
Received: from localhost ([127.0.0.1] helo=twosheds.infradead.org)
        by twosheds.infradead.org with esmtp (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kcUpw-00DNR9-Tz; Tue, 10 Nov 2020 14:41:33 +0000
Received: from 2a01:4c8:1444:cb4a:7550:3916:282:2b3a
        (SquirrelMail authenticated user dwmw2)
        by twosheds.infradead.org with HTTP;
        Tue, 10 Nov 2020 14:41:33 -0000
Message-ID: <9d35d5ea113b4d917c1560906445a811.squirrel@twosheds.infradead.org>
In-Reply-To: <20201110141928.GC22336@otc-nc-03>
References: <20201104135415.GX2620339@nvidia.com>
    <MWHPR11MB1645524BDEDF8899914F32AE8CED0@MWHPR11MB1645.namprd11.prod.outlook.com>
    <20201106131415.GT2620339@nvidia.com>
    <20201106164850.GA85879@otc-nc-03>
    <20201106175131.GW2620339@nvidia.com>
    <CAPcyv4iYHA1acfo=+fTk+U_TrLbSWJjA6v4oeTXgVYDTrnCoGw@mail.gmail.com>
    <20201107001207.GA2620339@nvidia.com>
    <20201108181124.GA28173@araj-mobl1.jf.intel.com>
    <20da76a4cd2e984a307d673e26f76ab73bd820f4.camel@infradead.org>
    <20201108232557.GA32074@araj-mobl1.jf.intel.com>
    <20201110141928.GC22336@otc-nc-03>
Date:   Tue, 10 Nov 2020 14:41:33 -0000
Subject: Re: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
From:   "David Woodhouse" <dwmw2@infradead.org>
To:     "Raj, Ashok" <ashok.raj@intel.com>
Cc:     "David Woodhouse" <dwmw2@infradead.org>,
        "Jason Gunthorpe" <jgg@nvidia.com>,
        "Dan Williams" <dan.j.williams@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Bjorn Helgaas" <helgaas@kernel.org>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "jing.lin@intel.com" <jing.lin@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "netanelg@mellanox.com" <netanelg@mellanox.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>,
        "Hossain, Mona" <mona.hossain@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
User-Agent: SquirrelMail/1.4.23 [SVN]-1.fc30.20190710
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by twosheds.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> Hi David
>
> I did't follow the support for 32768 CPUs in guest without IR support.
>
> Can you tell me how that is done?



Using bits 11-5 of the MSI address bits (the other 7 bits of "Extended
Destination ID" that aren't the Remappable Format indicator).

And physical addressing mode, which is no loss for external interrupts
since they're all unicast dest_Fixed these days anyway.


-- 
dwmw2

