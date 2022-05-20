Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D445052E65D
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 09:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346549AbiETHiU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 03:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346547AbiETHiT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 03:38:19 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4342C14A243
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 00:38:18 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 211A2820; Fri, 20 May 2022 09:38:14 +0200 (CEST)
Date:   Fri, 20 May 2022 09:38:09 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Robin Murphy <robin.murphy@arm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Will Deacon <will@kernel.org>,
        Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH] vfio: Remove VFIO_TYPE1_NESTING_IOMMU
Message-ID: <YodFYVd4vLetqt3D@8bytes.org>
References: <0-v1-0093c9b0e345+19-vfio_no_nesting_jgg@nvidia.com>
 <20220517142656.140deb10.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220517142656.140deb10.alex.williamson@redhat.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 17, 2022 at 02:26:56PM -0600, Alex Williamson wrote:
> I'd be in favor of applying this, but it seems Robin and Eric are
> looking for a stay of execution and I'd also be looking for an ack from
> Joerg.  Thanks,

This is mainly an ARM-SMMU thing, so I defer my ack to Will and Robin.

Regards,

	Joerg
