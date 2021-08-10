Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFFA53E55CB
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 10:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236775AbhHJIrF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 04:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233034AbhHJIrA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 04:47:00 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E263C0613D3;
        Tue, 10 Aug 2021 01:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Rb4AJ3RpTEpnwHFGufrRXvpNIl3SykHPZcUGM6sSAhU=; b=sefWE1vye7O2LBnpxizIRl1uJk
        FJ1kmk0NBO8bSAgycCHQwqzgbZ5DNQ9oEzSNvTr0Ca0HEc2HfXPrew4rcHyEILGQcQSzTrsy7mutg
        cdTdehwzAoxcLkWSKHtMy+UVYwHQG4FvVfxvbx08Y2FQT+woIP6YIJZfQwxatshtkWp5CMbCJUEja
        T2z88qNgdcTkxzFvr8vOtCREbvU3dms9BKkVxhNF+lugwbwQnnMMYZ0TfpQwrWMuGahS6d+c+Ii3j
        BiBuFdvCEQEKXWCUTAqNRKwaHyCs55DPKhZuSI95TjbDkY2H5xTip8N8RXHVt1L1b23lDphGrCPiB
        5OvmhrIA==;
Received: from [2001:4bb8:184:6215:a004:cea2:5ea9:6eca] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mDNNx-00BuPt-7E; Tue, 10 Aug 2021 08:45:33 +0000
Date:   Tue, 10 Aug 2021 10:45:20 +0200
From:   Christoph Hellwig <hch@infradead.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, jgg@nvidia.com,
        peterx@redhat.com
Subject: Re: [PATCH 2/7] vfio: Export unmap_mapping_range() wrapper
Message-ID: <YRI8oP59/+QFL1QD@infradead.org>
References: <162818167535.1511194.6614962507750594786.stgit@omen>
 <162818324222.1511194.15934590640437021149.stgit@omen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162818324222.1511194.15934590640437021149.stgit@omen>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +void vfio_device_unmap_mapping_range(struct vfio_device *device,
> +				     loff_t start, loff_t len)
> +{
> +	unmap_mapping_range(device->inode->i_mapping, start, len, true);
> +}
> +EXPORT_SYMBOL_GPL(vfio_device_unmap_mapping_range);

Instead of mirroring the name of unmap_mapping_range maybe give this
a name to document the use case?

> +extern void vfio_device_unmap_mapping_range(struct vfio_device *device,
> +					    loff_t start, loff_t len);

No need for the extern.
