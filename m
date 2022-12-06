Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67F446445AE
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 15:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234387AbiLFObi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 09:31:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiLFObh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 09:31:37 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C571B7A3;
        Tue,  6 Dec 2022 06:31:35 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5F41368C4E; Tue,  6 Dec 2022 15:31:27 +0100 (CET)
Date:   Tue, 6 Dec 2022 15:31:26 +0100
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
Message-ID: <20221206143126.GB30297@lst.de>
References: <20221206055816.292304-1-lei.rao@intel.com> <20221206055816.292304-6-lei.rao@intel.com> <20221206062604.GB6595@lst.de> <Y48+AaG5rSCviIhl@ziepe.ca> <20221206130901.GB24358@lst.de> <Y49JNvdmRPNWw26q@ziepe.ca> <20221206140002.GB27689@lst.de> <Y49PqoAhZOeraLVa@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y49PqoAhZOeraLVa@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 06, 2022 at 10:20:26AM -0400, Jason Gunthorpe wrote:
> In the VFIO restore model there is no "live OS" on resume. The
> load/resume cycle is as destructive as reset to the vfio device.

Of course there may be and OS.  As soon as the VF is live Linux
will by default bind to it.  And that's the big problem here,
the VF should not actually exist or at least not be usable when
such a restore happens - or to say it in NVMe terms, the Secondary
Controller better be in offline state when state is loaded into it.
