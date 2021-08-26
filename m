Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3053F848C
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 11:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241049AbhHZJag (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 05:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241045AbhHZJag (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 05:30:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44BACC061757;
        Thu, 26 Aug 2021 02:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=sqhNsc+NBkqAIus/40Ed8yGQXcD0caE7Srup409Y0KI=; b=qfaX3+IBNGQ+0XF10wCrxX7jLb
        y+hJyybkEy/wKdLWp/QS7osnLOVgwo6MRe67aOjz1TLyS1vrx/GeCJ7QA0OJsYIL81isDygGlL/LK
        hcDz/1pdJBqlftkcjfS9pRuXeahJZfEC22B49bQnNk8XbcPDcPO8C1L/dZUOd2Y1aa4RXB/PTE9UX
        U+Khz0yVQghoeMUtlwI0j/E+SvExxeUuE9FCKq9PqA7srp/OansRzM3TYiEitFxacmdpSGvNtuvdR
        57BdP7h7uV/vbL3CLU7CvCkl01dS4SPpsSaILmW98+Ehi1xKYq9onQwXKEGi6V30XzTSW3KlgrRUV
        ghFwodNA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJBfY-00D9UM-Ls; Thu, 26 Aug 2021 09:27:48 +0000
Date:   Thu, 26 Aug 2021 10:27:32 +0100
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
Subject: Re: [PATCH V4 05/13] vfio/pci: Include vfio header in vfio_pci_core.h
Message-ID: <YSdehPmYJ4Q/YMC5@infradead.org>
References: <20210825135139.79034-1-yishaih@nvidia.com>
 <20210825135139.79034-6-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825135139.79034-6-yishaih@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 25, 2021 at 04:51:31PM +0300, Yishai Hadas wrote:
> From: Max Gurtovoy <mgurtovoy@nvidia.com>
> 
> The vfio_device structure is embedded into the vfio_pci_core_device
> structure, so there is no reason for not including the header file in the
> vfio_pci_core header as well.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
