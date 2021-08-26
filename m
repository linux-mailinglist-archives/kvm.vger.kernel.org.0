Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D963F8483
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 11:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240931AbhHZJ23 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 05:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233744AbhHZJ22 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 05:28:28 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112D9C061757;
        Thu, 26 Aug 2021 02:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=BruyytMuDPhf/GeuMHuCWEbth4Qwu9l95H0vUsisZ2g=; b=emC85jGfw+SQMzjEm3VNbfqVkS
        JF9Hv2IcZtlpTS8WWLj0Q2L1PKSI3BH3sQcgKBe7nrWrl/+QunXT4qF2OQa1RKXbF6oMtqFRgcWE5
        7Ut2VimoBRsXhhsOMvGKJvaoxmOXebfeu1Oveh1+o3nJOe0OU0lEalrnuRVdfXHG3ZPaRgyhG9X2j
        4h3EUGbAEJnP5/aG4UNdrmyOyNV4ivFEvPo5pSOQ/hXqFb1SYIenAE1STDfPOD44WbDmpJvAs4C3h
        RJeAd39c0G7G+QrL2hW7gQuSynsOyCsn+P0f9idstG0Qh7FgpLUEFAVuqvn4sx6/z2NyBizQh84Tt
        Cf3G86eQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJBe2-00D9OK-AB; Thu, 26 Aug 2021 09:26:11 +0000
Date:   Thu, 26 Aug 2021 10:25:58 +0100
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
Subject: Re: [PATCH V4 04/13] vfio/pci: Rename ops functions to fit core
 namings
Message-ID: <YSdeJs4hcPmSHd+A@infradead.org>
References: <20210825135139.79034-1-yishaih@nvidia.com>
 <20210825135139.79034-5-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825135139.79034-5-yishaih@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 25, 2021 at 04:51:30PM +0300, Yishai Hadas wrote:
> From: Max Gurtovoy <mgurtovoy@nvidia.com>
> 
> This is another preparation patch for separating the vfio_pci driver to
> a subsystem driver and a generic pci driver. This patch doesn't change
> any logic.

It would be nice to fix the overly long lines.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
