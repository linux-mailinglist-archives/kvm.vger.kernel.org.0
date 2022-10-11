Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 591A35FACD4
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 08:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiJKGbY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 02:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiJKGbX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 02:31:23 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2316C4DF2D
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 23:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jV0lel4hcyRuBF4vz1VDWKObIFyCbpPDEDjiOKfaidA=; b=0k97Na1L4BlDblguquZuAmwWJ5
        u/+oM3kp875M733+xD++gQEy5HHgVpcbNvFRUgkbWI23frPBbBJhpUcRmf4pPeAs9PRFoNP0ZF/sp
        N6H+4FFtS1iEt+DUTfSVmnD/JQ2+ZA5e6zvu4Q/soqklOCgaiGWUe1hlEgTaYn1tePcsimrEjkIkx
        D8Kur0fokKtfYAB4nJo1EXfepsScd0b3h4UbF1PaP7zUxg2cLwIoK7VJaYmSRYvcvdcF6DYkFV1oO
        jg/LqyRlqlhOMQGbxli9Fr6igygowJBP7iEikcp5URD8BfoW6Fkwy0EMyLaVF1g0US0ktNOijPWzE
        bnTDGETQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oi8nL-003SCu-Ua; Tue, 11 Oct 2022 06:31:15 +0000
Date:   Mon, 10 Oct 2022 23:31:15 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/4] vfio: Move vfio_spapr_iommu_eeh_ioctl into
 vfio_iommu_spapr_tce.c
Message-ID: <Y0UNs0UU56YKCSSd@infradead.org>
References: <0-v2-18daead6a41e+98-vfio_modules_jgg@nvidia.com>
 <2-v2-18daead6a41e+98-vfio_modules_jgg@nvidia.com>
 <Y0PFJwIlaeJY0nSe@infradead.org>
 <Y0Rne7dwZVdqF3cX@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0Rne7dwZVdqF3cX@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 10, 2022 at 03:42:03PM -0300, Jason Gunthorpe wrote:
> You mean to fold the case branches into the existing switch statements
> in tce_iommu_ioctl()? Like below with indenting fixed?

Yes.
