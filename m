Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C471502C09
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 16:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354595AbiDOOkL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 10:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349869AbiDOOkK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 10:40:10 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 790C54667A
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 07:37:42 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id D599968AFE; Fri, 15 Apr 2022 16:37:39 +0200 (CEST)
Date:   Fri, 15 Apr 2022 16:37:39 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Auger <eric.auger@redhat.com>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH 05/10] vfio: Move vfio_external_user_iommu_id() to
 vfio_file_ops
Message-ID: <20220415143739.GC1958@lst.de>
References: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com> <5-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com> <20220415073125.GC24824@lst.de> <20220415122510.GJ2120790@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220415122510.GJ2120790@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 15, 2022 at 09:25:10AM -0300, Jason Gunthorpe wrote:
> The PPC specific iommu_table_group is PPC's "drvdata" for the common
> struct iommu_group - it is obtained trivially by group->iommu_data
> 
> I think using iommu_group as the handle for it in common code is the
> right thing to do.
> 
> What I don't entirely understand is what is 'tablefd' doing in all
> this, or why the lookup of the kvmppc_spapr_tce_table is so
> weird. PPC's unique iommu uapi is still a mystery to me.

Yeah.  So I guess we should go with something like this patch for now.
Eventually as part of the actual iommufd work we'll need to unwind
the PPC stuff anyway.
