Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE04644770
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 16:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234960AbiLFPGd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 10:06:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234577AbiLFPGO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 10:06:14 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3202F002;
        Tue,  6 Dec 2022 07:01:50 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3A0CA68CFE; Tue,  6 Dec 2022 16:01:33 +0100 (CET)
Date:   Tue, 6 Dec 2022 16:01:31 +0100
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
Message-ID: <20221206150131.GA32365@lst.de>
References: <20221206055816.292304-1-lei.rao@intel.com> <20221206055816.292304-6-lei.rao@intel.com> <20221206062604.GB6595@lst.de> <Y48+AaG5rSCviIhl@ziepe.ca> <20221206130901.GB24358@lst.de> <Y49JNvdmRPNWw26q@ziepe.ca> <20221206140002.GB27689@lst.de> <Y49PqoAhZOeraLVa@ziepe.ca> <20221206143126.GB30297@lst.de> <Y49WNo7XWZ2aFfds@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y49WNo7XWZ2aFfds@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 06, 2022 at 10:48:22AM -0400, Jason Gunthorpe wrote:
> Sadly in Linux we don't have a SRIOV VF lifecycle model that is any
> use.

Beward:  The secondary function might as well be a physical function
as well.  In fact one of the major customers for "smart" multifunction
nvme devices prefers multi-PF devices over SR-IOV VFs. (and all the
symmetric dual ported devices are multi-PF as well).

So this isn't really about a VF live cycle, but how to manage life
migration, especially on the receive / restore side.  And restoring
the entire controller state is extremely invasive and can't be done
on a controller that is in any classic form live.  In fact a lot
of the state is subsystem-wide, so without some kind of virtualization
of the subsystem it is impossible to actually restore the state.

To cycle back to the hardware that is posted here, I'm really confused
how it actually has any chance to work and no one has even tried
to explain how it is supposed to work.
