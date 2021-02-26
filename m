Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71752325D41
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 06:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhBZFjC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 00:39:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhBZFjA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Feb 2021 00:39:00 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C62C061574;
        Thu, 25 Feb 2021 21:38:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=B81HiCHH2Umn9d439xCfrrLYHKIefOnMbAaD6qr9ZCE=; b=D7hlFC7jcVerLgiOAWjsfkgpqc
        gitm/z4uPHTsIx3IJVtJjv1+yAIY/xA21guaaDUMhBuCQL/7TPJ5sPimXQEX7hsu7d5rFw3ReZXQd
        sTDcQ44OWARIV1JwdZVr2/rFeGCAMdOjeHcAUcsOnPPPqbGKCNf68V02RqxjfTc6Qp19+K2EiezWw
        PtdO/H1RV/7jzPzUPQ9riqOc5zvJBcE6JR4nE5Y8VNabYZrhBB51alur+Q/XnxHrAVvPVV2VgN72N
        IkwYvbwNg2Y7qq/jeWsASIFEyOhv3f8pIuRZkVcjtSGsVvZt+YAUk1dY/A42W19FaiSK/Rcpp0J22
        4+xYnnnA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lFVpE-00BbQP-7q; Fri, 26 Feb 2021 05:38:05 +0000
Date:   Fri, 26 Feb 2021 05:38:04 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com, peterx@redhat.com,
        viro@zeniv.linux.org.uk
Subject: Re: [RFC PATCH 01/10] vfio: Create vfio_fs_type with inode per device
Message-ID: <20210226053804.GA2764758@infradead.org>
References: <161401167013.16443.8389863523766611711.stgit@gimli.home>
 <161401263517.16443.7534035240372538844.stgit@gimli.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161401263517.16443.7534035240372538844.stgit@gimli.home>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 22, 2021 at 09:50:35AM -0700, Alex Williamson wrote:
> By linking all the device fds we provide to userspace to an
> address space through a new pseudo fs, we can use tools like
> unmap_mapping_range() to zap all vmas associated with a device.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Adding Al:

I hate how we're are growing these tiny file systems just to allocate an
anonymous inode all over.  Shouldn't we allow to enhance fs/anon_inodes.c
to add a new API to allocate a new specific inode from anon_inodefs
instead?
