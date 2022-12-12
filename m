Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3521E6499CF
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 08:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbiLLH5M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 02:57:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231213AbiLLH5K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 02:57:10 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573AFBF49;
        Sun, 11 Dec 2022 23:57:10 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id A09EB68AA6; Mon, 12 Dec 2022 08:57:07 +0100 (CET)
Date:   Mon, 12 Dec 2022 08:57:07 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Dong, Eddie" <eddie.dong@intel.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        "Rao, Lei" <lei.rao@intel.com>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@fb.com" <axboe@fb.com>, "kch@nvidia.com" <kch@nvidia.com>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Li, Yadong" <yadong.li@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Wilk, Konrad" <konrad.wilk@oracle.com>,
        "stephen@eideticom.com" <stephen@eideticom.com>,
        "Yuan, Hang" <hang.yuan@intel.com>
Subject: Re: [RFC PATCH 5/5] nvme-vfio: Add a document for the NVMe device
Message-ID: <20221212075707.GD11162@lst.de>
References: <20221206130901.GB24358@lst.de> <Y49JNvdmRPNWw26q@ziepe.ca> <20221206140002.GB27689@lst.de> <Y49PqoAhZOeraLVa@ziepe.ca> <20221206143126.GB30297@lst.de> <Y49WNo7XWZ2aFfds@ziepe.ca> <20221206150131.GA32365@lst.de> <Y49fjFD6foGorhmp@ziepe.ca> <20221206153546.GA2266@lst.de> <BL0PR11MB3042F27C99080E4B51318B338A1B9@BL0PR11MB3042.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL0PR11MB3042F27C99080E4B51318B338A1B9@BL0PR11MB3042.namprd11.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 06, 2022 at 06:00:27PM +0000, Dong, Eddie wrote:
> NVMe spec is general, but the implementation details (such as internal state) may 
> be vendor specific. If the migration happens between 2 identical NVMe devices 
> (from same vendor/device w/ same firmware version), migration of 
> subsystem-wide state can be naturally covered, right?

No.  If you want live migration for nvme supported in Linux, it must
be speced in the NVMe technical working group and interoperate between
different implementations.
