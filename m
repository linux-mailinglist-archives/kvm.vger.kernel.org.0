Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C480644533
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 15:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234670AbiLFOAR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 09:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234507AbiLFOAO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 09:00:14 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C993B1;
        Tue,  6 Dec 2022 06:00:13 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8B58B68B05; Tue,  6 Dec 2022 15:00:03 +0100 (CET)
Date:   Tue, 6 Dec 2022 15:00:02 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Christoph Hellwig <hch@lst.de>, Lei Rao <lei.rao@intel.com>,
        kbusch@kernel.org, axboe@fb.com, kch@nvidia.com, sagi@grimberg.me,
        alex.williamson@redhat.com, cohuck@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        mjrosato@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, kvm@vger.kernel.org,
        eddie.dong@intel.com, yadong.li@intel.com, yi.l.liu@intel.com,
        Konrad.wilk@oracle.com, stephen@eideticom.com, hang.yuan@intel.com
Subject: Re: [RFC PATCH 5/5] nvme-vfio: Add a document for the NVMe device
Message-ID: <20221206140002.GB27689@lst.de>
References: <20221206055816.292304-1-lei.rao@intel.com> <20221206055816.292304-6-lei.rao@intel.com> <20221206062604.GB6595@lst.de> <Y48+AaG5rSCviIhl@ziepe.ca> <20221206130901.GB24358@lst.de> <Y49JNvdmRPNWw26q@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y49JNvdmRPNWw26q@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 06, 2022 at 09:52:54AM -0400, Jason Gunthorpe wrote:
> On Tue, Dec 06, 2022 at 02:09:01PM +0100, Christoph Hellwig wrote:
> > On Tue, Dec 06, 2022 at 09:05:05AM -0400, Jason Gunthorpe wrote:
> > > In this case Intel has a real PCI SRIOV VF to expose to the guest,
> > > with a full VF RID.
> > 
> > RID?
> 
> "Requester ID" - PCI SIG term that in Linux basically means you get to
> assign an iommu_domain to the vfio device.

Yeah I now the Requester ID, I've just never seen that shortcut for it.

> >From what I understood this series basically allows two Intel devices
> to pass a big opaque blob of data. Intel didn't document what is in
> that blob, so I assume it captures everything you mention above.

Which would be just as bad, because it then changes the IDs under
the live OS on a restore.  This is not something that can be done
behind the back of the hypervisors / control plane OS.
