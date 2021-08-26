Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08FC63F8448
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 11:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240847AbhHZJQO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 05:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240674AbhHZJQN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 05:16:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23B2C061757;
        Thu, 26 Aug 2021 02:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Ihrfoe+h5Gg9VSrxwCLJOFQdRJ20cFSEfYzj5YNpG8Q=; b=wY38G8ajxEChFLwyC3iRnxB39A
        2EC3dFAUwsP05slk284As6B+u1JXjX/VL9yNrm088GdJvIsvjIpo3vn+octhnoEBML9oASladIgHz
        6kr0LPc8SPuYaNmuOIFdZ/FdMqrn5iqV1KMFzDhTbvC81X21ji6hVWQKe++zavBOiF380QYOMApAG
        Y3dbeW7C/lO6r1ENhS8CMumFjOBwV9113GbZ2dVeQL8mL5XjQDH+qZJU5R4v2Qcrvql1nMVYyoBEy
        CqT0YiRTiqO8aVu4sTwqY7X1kMNzN1tdTB+5Oqd5hZWfczn3mCJLW5PrjFHSPRQEfG7vd5fd1Zbsn
        p2jgF1uA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJBQt-00D8iq-Gm; Thu, 26 Aug 2021 09:13:07 +0000
Date:   Thu, 26 Aug 2021 10:12:23 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     bhelgaas@google.com, corbet@lwn.net, alex.williamson@redhat.com,
        diana.craciun@oss.nxp.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, masahiroy@kernel.org,
        michal.lkml@markovi.net, linux-pci@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kbuild@vger.kernel.org,
        mgurtovoy@nvidia.com, jgg@nvidia.com, maorg@nvidia.com,
        leonro@nvidia.com
Subject: Re: [PATCH V4 13/13] vfio/pci: Introduce vfio_pci_core.ko
Message-ID: <YSda91k6G6yPWjCa@infradead.org>
References: <20210825135139.79034-1-yishaih@nvidia.com>
 <20210825135139.79034-14-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825135139.79034-14-yishaih@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 25, 2021 at 04:51:39PM +0300, Yishai Hadas wrote:
> From: Max Gurtovoy <mgurtovoy@nvidia.com>
> 
> Now that vfio_pci has been split into two source modules, one focusing on
> the "struct pci_driver" (vfio_pci.c) and a toolbox library of code
> (vfio_pci_core.c), complete the split and move them into two different
> kernel modules.
> 
> As before vfio_pci.ko continues to present the same interface under sysfs
> and this change will have no functional impact.
> 
> Splitting into another module and adding exports allows creating new HW
> specific VFIO PCI drivers that can implement device specific
> functionality, such as VFIO migration interfaces or specialized device
> requirements.
> 
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
