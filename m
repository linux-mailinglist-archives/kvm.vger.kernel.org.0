Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B67678ED04
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 14:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346234AbjHaM0m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Aug 2023 08:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245372AbjHaM0l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Aug 2023 08:26:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7355B19A;
        Thu, 31 Aug 2023 05:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xznFs8Mqdf536+ELzSud2X/8Vl7HPTIZ4nxAqQyBBj4=; b=MzPFKTeyFG+zlbChN7Mle38r12
        JdcpYQZstPRes24wVde0gK8ukLb0N5298ASor90AlfUbHlQCY2EJIUtK/nQAb3m9pVrn9X9Wmr6Am
        GJefmUGtp5KcHe4AQmKAcffC8PCdSN0Fh0wQkwDFbNc58BSe49MIbUe2wCHLyG19GMeb6RgPobaol
        saULWaHosigANbsdbIK7E75CkZiazEKa//9Npke/F2s5XJleYBwJqdxVnFR5RZLJ/eQ5uKRFXKv8n
        6s/KOdxc+6Q8E9liWaXATNdTcwuZpDNdkheK8nxKU1bqQkrsEP1htAdE0lxWtB5cd5ce8CH3mAZCD
        1w404GRw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qbgkp-00FHM9-2W;
        Thu, 31 Aug 2023 12:26:31 +0000
Date:   Thu, 31 Aug 2023 05:26:31 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@infradead.org>, ankita@nvidia.com,
        alex.williamson@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
        targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
        apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Airlie <airlied@redhat.com>,
        dri-devel@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH v7 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Message-ID: <ZPCG9/P0fm88E2Zi@infradead.org>
References: <20230822202303.19661-1-ankita@nvidia.com>
 <ZO9JKKurjv4PsmXh@infradead.org>
 <ZO9imcoN5l28GE9+@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZO9imcoN5l28GE9+@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 30, 2023 at 12:39:05PM -0300, Jason Gunthorpe wrote:
> On Wed, Aug 30, 2023 at 06:50:32AM -0700, Christoph Hellwig wrote:
> > I know I'm chiming in a bit late, but what ultimate user space is going
> > to use this?  We should not add anything to the kernel that can't
> > be used without fully open user space.
> 
> qemu will get the matching VFIO userspace patches, I think they were
> posted someplace already.

Well, that's not what I mean with full userspace.  Whats the actual
consumer running in a qemu VM here?
