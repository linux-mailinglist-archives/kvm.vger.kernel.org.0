Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE13A3E55BC
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 10:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234688AbhHJIoo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 04:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231569AbhHJIok (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 04:44:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B807C0613D3;
        Tue, 10 Aug 2021 01:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wjcjJP3fIhiBNIkloAsoPiOZrQYFqb20BfwL09gssaA=; b=cf2QKqehd0F6baIPP76hpDkgac
        5+O4JcVPafqA5d6Oz06BwZUDqQ4C+QgPIuxBj5j/sjIGPTkqj269KmiHd1Q2CuI0OmaJPVvYj4G7L
        3Zagvi092WfGpOvoKmjLQpSF5gvxPl+be1XJV7CcFbxXAgDzXKdqt0rniafPhVDGYsXLp5WGMlUGD
        4+rm/RnRHDxDHP1+Ar3a3s2BsD/FhbEiRzuwvtfxDduynNrDFU0/VaNnoBmMEcQdH9ZCnyQBJrOIM
        ytiGg5ab1yzhpfa4NCeUwyK4UoA/OetDEjxXOrOLWhdw5y0h9mw+XGqlrJO9AEJ7JnnK3pRiVgQxi
        F8ZLKP4Q==;
Received: from [2001:4bb8:184:6215:a004:cea2:5ea9:6eca] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mDNMA-00BuLM-Ex; Tue, 10 Aug 2021 08:43:40 +0000
Date:   Tue, 10 Aug 2021 10:43:29 +0200
From:   Christoph Hellwig <hch@infradead.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, peterx@redhat.com
Subject: Re: [PATCH 1/7] vfio: Create vfio_fs_type with inode per device
Message-ID: <YRI8Mev5yfeAXsrj@infradead.org>
References: <162818167535.1511194.6614962507750594786.stgit@omen>
 <162818322947.1511194.6035266132085405252.stgit@omen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162818322947.1511194.6035266132085405252.stgit@omen>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> + * XXX Adopt the following when available:
> + * https://lore.kernel.org/lkml/20210309155348.974875-1-hch@lst.de/

No need for this link.
