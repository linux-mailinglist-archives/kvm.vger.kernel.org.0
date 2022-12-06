Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2151D643D15
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 07:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233661AbiLFGTt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 01:19:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231978AbiLFGTr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 01:19:47 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE8224F28;
        Mon,  5 Dec 2022 22:19:46 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 051516732D; Tue,  6 Dec 2022 07:19:41 +0100 (CET)
Date:   Tue, 6 Dec 2022 07:19:40 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Lei Rao <lei.rao@intel.com>
Cc:     kbusch@kernel.org, axboe@fb.com, kch@nvidia.com, hch@lst.de,
        sagi@grimberg.me, alex.williamson@redhat.com, cohuck@redhat.com,
        jgg@ziepe.ca, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        mjrosato@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, kvm@vger.kernel.org,
        eddie.dong@intel.com, yadong.li@intel.com, yi.l.liu@intel.com,
        Konrad.wilk@oracle.com, stephen@eideticom.com, hang.yuan@intel.com
Subject: Re: [RFC PATCH 1/5] nvme-pci: add function nvme_submit_vf_cmd to
 issue admin commands for VF driver.
Message-ID: <20221206061940.GA6595@lst.de>
References: <20221206055816.292304-1-lei.rao@intel.com> <20221206055816.292304-2-lei.rao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206055816.292304-2-lei.rao@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 06, 2022 at 01:58:12PM +0800, Lei Rao wrote:
> The new function nvme_submit_vf_cmd() helps the host VF driver to issue
> VF admin commands. It's helpful in some cases that the host NVMe driver
> does not control VF's admin queue. For example, in the virtualization
> device pass-through case, the VF controller's admin queue is governed
> by the Guest NVMe driver. Host VF driver relies on PF device's admin
> queue to control VF devices like vendor-specific live migration commands.

WTF are you even smoking when you think this would be acceptable?
