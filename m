Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADE239EEA1
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 08:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbhFHGYH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 02:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbhFHGYG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 02:24:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A779C061574
        for <kvm@vger.kernel.org>; Mon,  7 Jun 2021 23:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=Qm95BxWewwm4OwjsRcchflQZve
        mknYdrRk+Q1UlRn11JT5JNyFQK9KehewpmMalppCkvhIyFoU8ydAhfr1Fd/XtenV5rYMkJ7tzWym/
        QsBTmA22vEaOW7i7pvb6N6BFfxnbiKAnmd8tpmgcWHiuTjpo8CzDTcLbWcZZVlItSGZWcpsqsTN+M
        fCjI45QK5rkOSYqdYu6c4Y8L1Sjqbna3K/jDLyVLFr3BpnMXJxSP+8g/2NxdV0WQUa/V6yTkmPRpl
        nTKpsqoDcj6Q9AvXt+0r6qH6vGCLE6wDxWySVRE53YkuWkOuWqboYfLXssTH0U+nPVi0ccntVmfUG
        L68Alj3Q==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lqV7e-00Gcxf-5q; Tue, 08 Jun 2021 06:22:00 +0000
Date:   Tue, 8 Jun 2021 07:21:58 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH 07/10] vfio/mdev: Allow the mdev_parent_ops to specify
 the device driver to bind
Message-ID: <YL8MhsMQ+9iKVBL9@infradead.org>
References: <0-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
 <7-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
