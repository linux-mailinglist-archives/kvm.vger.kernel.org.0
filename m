Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D35743A6A65
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 17:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233799AbhFNPcq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 11:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234031AbhFNPcU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 11:32:20 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73BC6C061787;
        Mon, 14 Jun 2021 08:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=BOAPjwbtdUFJhW0vGZOZuptTrlFMtA9QPhXUlP40eQY=; b=XkpzfRqmBRHXIKnme9t/VjQIKy
        Zat1XtfRe8V7UJlt6lovmkDrp/eMfRPtb/+QgqmUj125U4i8ZvOeY1iGnrFE0srCupfWZ0n+xDQ8f
        c0aKSmY8opAMCTNDU0GFm6gD8PpZz62ETmtzFsX6e3QXGaVa1D0MmK7Jc1DXHtK5ANiaSEzNekGWp
        2xKx51/J7g0W27PgOqsE1IGKK158UN2CyOQuzGDjN7PBTMA0DmqpO62efsKOg9YXc0xG6mLQ80Yiv
        c0u4GkVlSZLub+dEctSHP+a2CRKM4X+iyw5zU/gx7THbI5bfNERC+C+HGdEYoj1jDqmAcCfvMZkLf
        3PtQfg0Q==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lsoUv-005YqL-2Y; Mon, 14 Jun 2021 15:27:47 +0000
Date:   Mon, 14 Jun 2021 16:27:33 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        aviadye@nvidia.com, oren@nvidia.com, shahafs@nvidia.com,
        parav@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, cjia@nvidia.com, yishaih@nvidia.com,
        kevin.tian@intel.com, targupta@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, liulongfang@huawei.com,
        yan.y.zhao@intel.com
Subject: Re: [PATCH 09/11] PCI: add matching checks for driver_override
 binding
Message-ID: <YMd1ZSCZLjaE4TFb@infradead.org>
References: <20210603160809.15845-1-mgurtovoy@nvidia.com>
 <20210603160809.15845-10-mgurtovoy@nvidia.com>
 <20210608152643.2d3400c1.alex.williamson@redhat.com>
 <20210608224517.GQ1002214@nvidia.com>
 <20210608192711.4956cda2.alex.williamson@redhat.com>
 <117a5e68-d16e-c146-6d37-fcbfe49cb4f8@nvidia.com>
 <YMbrxP/5D4vVLE0j@infradead.org>
 <1f7ad5bc-5297-6ddd-9539-a2439f3314fa@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f7ad5bc-5297-6ddd-9539-a2439f3314fa@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 14, 2021 at 11:18:32AM +0300, Max Gurtovoy wrote:
>   *			into a static list of equivalent device types,
>   *			instead of using it as a pointer.
> + * @flags:		PCI flags of the driver. Bitmap of pci_id_flags enum.
>   */
>  struct pci_device_id {
>  	__u32 vendor, device;		/* Vendor and device ID or PCI_ANY_ID*/
>  	__u32 subvendor, subdevice;	/* Subsystem ID's or PCI_ANY_ID */
>  	__u32 class, class_mask;	/* (class,subclass,prog-if) triplet */
>  	kernel_ulong_t driver_data;	/* Data private to the driver */
> +	__u32 flags;
>  };

Isn't struct pci_device_id a userspace ABI due to MODULE_DEVICE_TABLE()?
