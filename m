Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07D144544C2
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 11:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236125AbhKQKPF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 05:15:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233876AbhKQKPD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 05:15:03 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6F9C061570;
        Wed, 17 Nov 2021 02:12:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5ReCsooihDQ9YuxbQvkUBMTQuLIENZLOrhq8Lxdj/NU=; b=rxYDnL/QuEc3MpCMAfNwYDB1Zc
        ng3LSc+YJvfXmQpA0Q2a516GKFGJXLYonGZuLGvKki/8MIutmGrM+4Z7SxnGtl+GNAzUkJOmyOvj8
        CMl6VDNLknciUUICY1UpBV6MS4/f0rVScLNoV70kLp1E0Z/hgrDc0VwZb7oHmZBIsf/3i4L2ArPm3
        85t/igOtSkg9Ejr/dj0E1eqJ3PvzF2q7bfzD7VtKN4NXoa84sRk21S49AlaWpSWze832QvBQU8GYf
        Xur8FdcJ1eKXvgR2lcP2KRtH9hATbIpkxg1Mag/DFTROKEz9d72CETkOh+cmXR2C9rB07g0vIrM2p
        F86l5YCA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mnHvA-004PjB-AH; Wed, 17 Nov 2021 10:12:04 +0000
Date:   Wed, 17 Nov 2021 02:12:04 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Yifeng Li <tomli@tomli.me>
Cc:     Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2] PCI: Add func1 DMA quirk for Marvell 88SE9125 SATA
 controller
Message-ID: <YZTVdOlEbMb0tv59@infradead.org>
References: <YZPA+gSsGWI6+xBP@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZPA+gSsGWI6+xBP@work>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 16, 2021 at 02:32:26PM +0000, Yifeng Li wrote:
> Like other SATA controller chips in the Marvell 88SE91xx series, the
> Marvell 88SE9125 has the same DMA requester ID hardware bug that prevents
> it from working under IOMMU. This patch adds its device ID 0x9125 to the
> Function 1 DMA alias quirk list.

Btw, do we need to prevent vfio assignment for all devices with this
quirk?
