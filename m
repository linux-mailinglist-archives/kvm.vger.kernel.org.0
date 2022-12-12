Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 756BA6499E6
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 09:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbiLLILN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 03:11:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiLLILK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 03:11:10 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC902BCA8;
        Mon, 12 Dec 2022 00:11:09 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2A70467373; Mon, 12 Dec 2022 09:11:07 +0100 (CET)
Date:   Mon, 12 Dec 2022 09:11:06 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Li, Yadong" <yadong.li@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        "Rao, Lei" <lei.rao@intel.com>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@fb.com" <axboe@fb.com>, "kch@nvidia.com" <kch@nvidia.com>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Dong, Eddie" <eddie.dong@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Wilk, Konrad" <konrad.wilk@oracle.com>,
        "stephen@eideticom.com" <stephen@eideticom.com>,
        "Yuan, Hang" <hang.yuan@intel.com>
Subject: Re: [RFC PATCH 5/5] nvme-vfio: Add a document for the NVMe device
Message-ID: <20221212081106.GB11892@lst.de>
References: <20221206055816.292304-1-lei.rao@intel.com> <20221206055816.292304-6-lei.rao@intel.com> <20221206062604.GB6595@lst.de> <Y48+AaG5rSCviIhl@ziepe.ca> <20221206130901.GB24358@lst.de> <BN9PR11MB5276EBF06791EF7B39648FA48C1C9@BN9PR11MB5276.namprd11.prod.outlook.com> <BL1PR11MB602591A00CE052373BB47EBCFE1C9@BL1PR11MB6025.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR11MB602591A00CE052373BB47EBCFE1C9@BL1PR11MB6025.namprd11.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 09, 2022 at 04:53:47PM +0000, Li, Yadong wrote:
> The key leadership in NVMe WG, Peter and Nick (from Intel), are on top of this TPAR,
> and help influence the scope of the TPAR to better support IPU/DPUs.

You guys should talk more to each other.  I think Peter especially has
been vocal to reduce the scope and not include this.
