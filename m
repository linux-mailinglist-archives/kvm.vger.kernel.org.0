Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C59AE63CF15
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 07:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233940AbiK3GFJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 01:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233907AbiK3GFH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 01:05:07 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 674DF74CC1
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 22:05:05 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4C0D76732D; Wed, 30 Nov 2022 07:05:01 +0100 (CET)
Date:   Wed, 30 Nov 2022 07:05:01 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Subject: Re: [PATCH v4 4/5] vfio: Remove CONFIG_VFIO_SPAPR_EEH
Message-ID: <20221130060501.GA11298@lst.de>
References: <0-v4-7993c351e9dc+33a818-vfio_modules_jgg@nvidia.com> <4-v4-7993c351e9dc+33a818-vfio_modules_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4-v4-7993c351e9dc+33a818-vfio_modules_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 29, 2022 at 08:10:21PM -0400, Jason Gunthorpe wrote:
> We don't need a kconfig symbol for this, just directly test CONFIG_EEH in
> the few places that needs it.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
