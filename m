Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE9B325D4D
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 06:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhBZFsK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 00:48:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhBZFsJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Feb 2021 00:48:09 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D01DEC061574;
        Thu, 25 Feb 2021 21:47:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YBiFSDizlRMVTmEdyIEkyqkMLhTn9prNOG6rrFQE2J4=; b=umC7SAICAGE71YCZpGPH6Pfahr
        2+CUegdTb+ewFmKnZSo4FkyQcMxEL2oY29PR+92pQtCPOSripw52M6Dw8s+zzB80p1kN30kPqro6l
        Ut57H3NQChAM0dQgEkuychkeLKirhqeob/Bzyyq5VuWtsd6g7vBTWvJFuyheGE0CoYXgH6QzWB7V4
        nVzCePK1EV5QIKX0XQ0qxGeqA51QuDY01QyHewd3dn4UM6KEWEmJLrt4ehIahOZ/4q3nxr0MxRfzl
        jkbNLyM6MmoP5ZIxTLLk2C5TAdXHEHIVPHGL5K1zurU5394182F92CZndhjsCUckS1/3L83vieNCP
        pGIF2+Iw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lFVxy-00BbrF-HE; Fri, 26 Feb 2021 05:47:10 +0000
Date:   Fri, 26 Feb 2021 05:47:06 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterx@redhat.com
Subject: Re: [RFC PATCH 10/10] vfio/type1: Register device notifier
Message-ID: <20210226054706.GB2764758@infradead.org>
References: <161401167013.16443.8389863523766611711.stgit@gimli.home>
 <161401275279.16443.6350471385325897377.stgit@gimli.home>
 <20210222175523.GQ4247@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210222175523.GQ4247@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 22, 2021 at 01:55:23PM -0400, Jason Gunthorpe wrote:
> > +static bool strict_mmio_maps = true;
> > +module_param_named(strict_mmio_maps, strict_mmio_maps, bool, 0644);
> > +MODULE_PARM_DESC(strict_mmio_maps,
> > +		 "Restrict to safe DMA mappings of device memory (true).");
> 
> I think this should be a kconfig, historically we've required kconfig
> to opt-in to unsafe things that could violate kernel security. Someone
> building a secure boot trusted kernel system should not have an
> options for userspace to just turn off protections.

Agreed, but I'd go one step further:  Why should we allow the unsafe
mode at all?
