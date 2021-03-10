Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8F5D3336E0
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 09:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhCJIEl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 03:04:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhCJIER (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 03:04:17 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C2FC06174A;
        Wed, 10 Mar 2021 00:04:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=m7vmehVG7oO9qabFkyYe2PuNA+zX19AuD9m9j6F9h3o=; b=MxAhLHBJCSxXNb2rhkwDa7lqqP
        hc95I57qL/cR4qO72l9jqzsqRRWJr97fynBenR/WulxAhciyd3jLRJk/5i/E8mr9rhs612A/dhfZx
        NfusLgBdvJFEIKrlpwAk+k65Fv3VDIUkcD0RvsHxAWU03BHyfkRTRoBqyMkyllsPAynXaWf2dAF9z
        QVJGScRrG7Tfl8sNELWHSh0VfV5p745eFlbPuJCg9YDA27wlgii9WM4vph7L/WfXThZXF2wWLPDvN
        nEvQiJ4oCv0Znd2XZBsuUBbziNuIIURmMCW5OlOXI25cMgOhHtO8z5wdGs+0VGy7jWgdEhpBCqrST
        Qyw7P9CA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lJtp0-002oaw-Tq; Wed, 10 Mar 2021 08:04:01 +0000
Date:   Wed, 10 Mar 2021 08:03:58 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com, peterx@redhat.com
Subject: Re: [PATCH v1 11/14] vfio/type1: Register device notifier
Message-ID: <20210310080358.GD662265@infradead.org>
References: <161523878883.3480.12103845207889888280.stgit@gimli.home>
 <161524015876.3480.18404153016941080011.stgit@gimli.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161524015876.3480.18404153016941080011.stgit@gimli.home>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +
> +		if (!dma->pfnmap) {
> +			struct vfio_device *device;
> +			unsigned long base_pfn;
> +			struct pfnmap_obj *pfnmap;

Please factor this whole block into a separate helper to keep it
readable.

