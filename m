Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A059702BFB
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 13:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241373AbjEOLz6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 07:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238242AbjEOLz1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 07:55:27 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DB421BC5;
        Mon, 15 May 2023 04:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=pWvIuFmnhm9tAkw2SiaTeb6OI+NVYwgnGWSr09ytrtQ=; b=XQzam2wx7hHP7RKcZRsHHTh+jH
        fOcWTjjLz9sOejyH0FqoW80WIs0jMVUG77AOOWswDPnFfUVa3UjFbrAr1Aw5zGeKx35WPKGV5u8Gl
        kIePfBPRxizMWacykL+5vtb5kgaK4nrKj2r72XFapTzCoa35QvEX9yXe/bvTMNW6DGVTJ0DhGpfbY
        GqnAYl994cV1eBFrSQHZTZrWKZdvNWaqtPE+EDq/oRP8hAe9fcdG7tF8ORsU1eBc7yOfS/RYXW8Ju
        M3yarnHLcJCEiXEtMhmrq3L6cuCo34W8D4SFZYSPcAdU2xrGXSZtow+XKlSu6G2j+zh6bCqQBAsht
        SCghbpJA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pyWgd-0021nL-1J;
        Mon, 15 May 2023 11:48:19 +0000
Date:   Mon, 15 May 2023 04:48:19 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        iommu@lists.linux.dev, Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v5 2/6] mm/gup: remove unused vmas parameter from
 pin_user_pages_remote()
Message-ID: <ZGIcA67XjL0M6ObY@infradead.org>
References: <cover.1684097001.git.lstoakes@gmail.com>
 <61f0d12058825a14feee6a3292e5a257662e719c.1684097002.git.lstoakes@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61f0d12058825a14feee6a3292e5a257662e719c.1684097002.git.lstoakes@gmail.com>
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

On Sun, May 14, 2023 at 10:26:47PM +0100, Lorenzo Stoakes wrote:
> No invocation of pin_user_pages_remote() uses the vmas parameter, so remove
> it. This forms part of a larger patch set eliminating the use of the vmas
> parameters altogether.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
