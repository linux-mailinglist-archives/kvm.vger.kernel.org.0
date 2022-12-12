Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E919E6499E2
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 09:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbiLLIJy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 03:09:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiLLIJx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 03:09:53 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5704BCA9;
        Mon, 12 Dec 2022 00:09:52 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 24CC067373; Mon, 12 Dec 2022 09:09:48 +0100 (CET)
Date:   Mon, 12 Dec 2022 09:09:47 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     "Rao, Lei" <lei.rao@intel.com>, Christoph Hellwig <hch@lst.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, kbusch@kernel.org,
        axboe@fb.com, kch@nvidia.com, sagi@grimberg.me,
        alex.williamson@redhat.com, cohuck@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        mjrosato@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, kvm@vger.kernel.org,
        eddie.dong@intel.com, yadong.li@intel.com, yi.l.liu@intel.com,
        Konrad.wilk@oracle.com, stephen@eideticom.com, hang.yuan@intel.com,
        Oren Duer <oren@nvidia.com>
Subject: Re: [RFC PATCH 5/5] nvme-vfio: Add a document for the NVMe device
Message-ID: <20221212080947.GA11892@lst.de>
References: <20221206130901.GB24358@lst.de> <Y49JNvdmRPNWw26q@ziepe.ca> <20221206140002.GB27689@lst.de> <Y49PqoAhZOeraLVa@ziepe.ca> <20221206143126.GB30297@lst.de> <Y49WNo7XWZ2aFfds@ziepe.ca> <20221206150131.GA32365@lst.de> <9bc8e614-a687-e419-f9fd-e3177cfb41dd@nvidia.com> <cf88c2ec-bdd6-1df3-6c77-64a17dc3eb86@intel.com> <d4aeda5c-d7bb-4427-5157-fb7530dfd1fb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4aeda5c-d7bb-4427-5157-fb7530dfd1fb@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Dec 11, 2022 at 04:51:02PM +0200, Max Gurtovoy wrote:
> I don't think that medium migration should be part of the SPEC. We can 
> specify it's out of scope.

This is the main item in the TPAR in the technical working group,
with SQ/CQ state beeing the other one.  So instead of arguing here
I'd suggest you all get involved in the working group ASAP.

> All the idea of live migration is to have a short downtime and I don't 
> think we can guarantee short downtime if we need to copy few terabytes 
> throw the networking.

You can.  Look at the existing qemu code for live migration for
image based storage, the same concepts also work for hardware offloads.

> If the media copy is taking few seconds, there is no need to do live 
> migration of few milisecs downtime. Just do regular migration of a VM.

The point is of course to not do the data migration during the downtime,
but to track newly written LBAs after the start of the copy proces.
Again look at qemu for how this has been done for years in software.
