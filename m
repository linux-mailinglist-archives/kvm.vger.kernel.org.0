Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B86E53A6B75
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 18:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234648AbhFNQSO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 12:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234511AbhFNQSN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 12:18:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A44BC061574;
        Mon, 14 Jun 2021 09:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=w4/fXV/7ZWtmXpJiEafoV3RSdiWGaxBYyWUwujF80FQ=; b=gHi8pGffZ5uB2Ud2rXdAcU57gY
        fS2GXglFMhDX1jOSbAYecFYd7MXfjpSh4YvD6bYNilTb13zsxStuO1Q0ivRUhJVm6w3P3WsMZGXUL
        QAbkq9MN758wKOc7dpcshqXYf7QlsKpXijOydPevQZldZrAdElXL3wyYlXW4FSmJpcKY2WWifCdZE
        nPKJlZGHeW2DpW6zZtLI7s8XOoTl2GESbmZFXSDJPfGqqzTzFX3ozVFg2OyF7GS37AjpYpPD67pZM
        MLaut06zjgMgPt6kFbHddDQ2tbYsePJ15UpQza0PHwxSfiHT0H1azT/bPNQuQdxn+kpGxlQAczIwr
        p82MTxaw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lspFC-005bdD-8X; Mon, 14 Jun 2021 16:15:34 +0000
Date:   Mon, 14 Jun 2021 17:15:22 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, aviadye@nvidia.com, oren@nvidia.com,
        shahafs@nvidia.com, parav@nvidia.com, artemp@nvidia.com,
        kwankhede@nvidia.com, ACurrid@nvidia.com, cjia@nvidia.com,
        yishaih@nvidia.com, kevin.tian@intel.com, targupta@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, liulongfang@huawei.com,
        yan.y.zhao@intel.com
Subject: Re: [PATCH 09/11] PCI: add matching checks for driver_override
 binding
Message-ID: <YMeAmoWns9SUkr+q@infradead.org>
References: <20210603160809.15845-1-mgurtovoy@nvidia.com>
 <20210603160809.15845-10-mgurtovoy@nvidia.com>
 <20210608152643.2d3400c1.alex.williamson@redhat.com>
 <20210608224517.GQ1002214@nvidia.com>
 <20210608192711.4956cda2.alex.williamson@redhat.com>
 <117a5e68-d16e-c146-6d37-fcbfe49cb4f8@nvidia.com>
 <YMbrxP/5D4vVLE0j@infradead.org>
 <1f7ad5bc-5297-6ddd-9539-a2439f3314fa@nvidia.com>
 <YMd1ZSCZLjaE4TFb@infradead.org>
 <20210614160125.GK1002214@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210614160125.GK1002214@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 14, 2021 at 01:01:25PM -0300, Jason Gunthorpe wrote:
> > Isn't struct pci_device_id a userspace ABI due to MODULE_DEVICE_TABLE()?
> 
> Not that I can find, it isn't under include/uapi and the way to find
> this information is by looking for symbols starting with "__mod_"
> 
> Debian Code Search says the only place with '"__mod_"' is in
> file2alias.c at least
> 
> Do you know of something? If yes this file should be moved

Seems lke file2alias.c is indeed the only consumer.  So it is a
userspace ABI, but ony to a file included in the kernel tree.
