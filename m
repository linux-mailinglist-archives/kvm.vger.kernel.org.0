Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63815527DB2
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 08:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240348AbiEPGjo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 02:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237096AbiEPGjl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 02:39:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BEBF32EDE
        for <kvm@vger.kernel.org>; Sun, 15 May 2022 23:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0o88uoiLdgu72BX9iz1mCBNHPqmASxxQIpMC4taHFxI=; b=r0rOr9Vbw5T3aAmCp/QHtLutdT
        mkawSr3Ga1C9bZRdNsH97QeZtPueK65nRl2VAKD0/mmeH+7zbGIn9r9F6+IaC9RpiybUqG5DHGi/M
        y6Mu95eMorRknW4nwdwloxdTSSsApFD3MceuG4NNv0fOtqgf9OQYTprsLbJ/VzzXsWlBQNDWkUDSi
        LHk3nE+qKbx/T0mShpeFAGeACj1XLIb6rRHlwbsESJaKYF4QS2QiQOthgvgNzCNBBBr7BhtqGGzt1
        kQ2AC3fHG7rEKHpny+hzvd7Jt1eAsYh5IsayzD4IIKrqV179FjlDIKkkPMlTJT6zenWjKJZ0Xv2gD
        Tf6IAKWQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nqUOH-006DxI-Jc; Mon, 16 May 2022 06:39:37 +0000
Date:   Sun, 15 May 2022 23:39:37 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Will Deacon <will@kernel.org>,
        Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH] vfio: Remove VFIO_TYPE1_NESTING_IOMMU
Message-ID: <YoHxqWss49FUYnJ7@infradead.org>
References: <0-v1-0093c9b0e345+19-vfio_no_nesting_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-0093c9b0e345+19-vfio_no_nesting_jgg@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

we really should not keep dead code like this around.
