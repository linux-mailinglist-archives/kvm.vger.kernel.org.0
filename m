Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56672B5BB4
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 10:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbgKQJV4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 04:21:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbgKQJVz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 04:21:55 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84ACCC0613CF;
        Tue, 17 Nov 2020 01:21:55 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1605604913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+oNN0MQgkiBnCbtfwugoj2ueCMN1m2mxEsnINrDLEe0=;
        b=DwBmeWJShTfSxI7/bv9yMVNbyXuplY6dNWaJqhWyEBj0NEoUnDzm/Q61zBRx/jvfVqMab3
        YqSSqciJOklmsPQhLhvFcAhDaCgdtLjlgDx1WVoEJhofYrTb+HZOhHdBmFYZ8sOC2J+3rF
        kkEshToFTkEciOfblmWCrEZp5P6IbtwlfRxWHlsTJbeLlyWYtXZ7SdaRZeP8Ae+vxzSOqK
        eStnMibR6Ryujt1YDKfPzB2cupuDgeXiLMpjrk89EkPjUsUGpsAGsIueuBeEINhXacrsmY
        QdeJkh0tBpaCWJVw6wHbr0zQo5UbpJ4Qszu9RndP91TowUjpuEanGAb23BvW1w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1605604913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+oNN0MQgkiBnCbtfwugoj2ueCMN1m2mxEsnINrDLEe0=;
        b=YCVL+0Qrok4yb6+AmGU6uun36CXW4zeVISlAXjUYay+MYF25xqVx1q5xsECe4BULShPhcB
        gQiiXXhWd1DZjrAg==
To:     "Tian\, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
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
Subject: RE: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
In-Reply-To: <MWHPR11MB1645E87DBEFFCC017C4849CC8CE30@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <877dqqmc2h.fsf@nanos.tec.linutronix.de> <20201114103430.GA9810@infradead.org> <20201114211837.GB12197@araj-mobl1.jf.intel.com> <877dqmamjl.fsf@nanos.tec.linutronix.de> <20201115193156.GB14750@araj-mobl1.jf.intel.com> <875z665kz4.fsf@nanos.tec.linutronix.de> <20201116002232.GA2440@araj-mobl1.jf.intel.com> <MWHPR11MB164539B8FDE63D5CBDA300E18CE30@MWHPR11MB1645.namprd11.prod.outlook.com> <20201116154635.GK917484@nvidia.com> <87y2j1xk1a.fsf@nanos.tec.linutronix.de> <20201116180241.GP917484@nvidia.com> <MWHPR11MB1645E87DBEFFCC017C4849CC8CE30@MWHPR11MB1645.namprd11.prod.outlook.com>
Date:   Tue, 17 Nov 2020 10:21:52 +0100
Message-ID: <875z64xrrj.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 16 2020 at 23:51, Kevin Tian wrote:
>> From: Jason Gunthorpe <jgg@nvidia.com>
> btw Jason/Thomas, how do you think about the proposal down in this
> thread (ims=[auto|on|off])? Does it sound a good tradeoff to move forward?

What does it solve? It defaults to auto and then you still need to solve
the problem of figuring out whether it's safe to use it or not.

The command line option is not a solution per se. It's the last resort
when the logic which decides whether IMS can be used or not fails to do
the right thing. Nothing more.

We clearly have outlined what needs to be done and you can come up with
as many magic bullets you want, they won't make the real problems go
away.

Thanks,

        tglx
