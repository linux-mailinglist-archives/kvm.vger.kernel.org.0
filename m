Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAD7D602421
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 08:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbiJRGGY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 02:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiJRGGX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 02:06:23 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F6EA4BA9
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 23:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=32ItSogg9s4UtDxdi657DaOFnWsZSE9s/UcBtF0R6NI=; b=dysule8JJIKm/cU9Te44GcoSB/
        sRQrjz5uOFVQuRhVyZusv3fYFAL41NEh6P1Zk1x0k/ALI6zl+fFXR26ZI0aRGxNdh5mROR7K+yQ3v
        Mx1Xaji70uZmDyj+rpRFKLw7Vl/rnZrDe0niWjlROu7f1I2ZTVdYBczP9L5/pv3YJOPkry2pHdB4s
        1U2BuLCKZZgVugjpdIouvvN8niAAp4NgJaLmHHi9fuLnXn6qCqVxDnkHnsXF+af6gpviGCygN2+h8
        4np8xwWKAUFSMuAsiFaS/jIoR3OSNqSnQwWCi7x8LolgBLCty6ro48Q6q343xIBCmkJmfQ+Tyw4/v
        WEdhK+OA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1okfk3-003DAJ-EO; Tue, 18 Oct 2022 06:06:19 +0000
Date:   Mon, 17 Oct 2022 23:06:19 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v3 3/5] vfio: Move vfio_spapr_iommu_eeh_ioctl into
 vfio_iommu_spapr_tce.c
Message-ID: <Y05CW7nYgVN53I1+@infradead.org>
References: <0-v3-8db96837cdf9+784-vfio_modules_jgg@nvidia.com>
 <3-v3-8db96837cdf9+784-vfio_modules_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3-v3-8db96837cdf9+784-vfio_modules_jgg@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +	switch (op.op) {
> +	case VFIO_EEH_PE_DISABLE:
> +		ret = eeh_pe_set_option(pe, EEH_OPT_DISABLE);
> +		break;
> +	case VFIO_EEH_PE_ENABLE:
> +		ret = eeh_pe_set_option(pe, EEH_OPT_ENABLE);
> +		break;

This could be simplified a bit more by moving the return from the
end of the function into the switch statements.

> - * Copyright Gavin Shan, IBM Corporation 2014.

This notice needs to move over to vfio_iommu_spapr_tce.c.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
