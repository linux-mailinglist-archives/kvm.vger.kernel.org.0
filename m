Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3C9F34EE49
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 18:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbhC3QqU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 12:46:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42547 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232529AbhC3Qpi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Mar 2021 12:45:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617122738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=zzc2KTIEFsB3osEymwowtqBBc0fZZdXcHQvsko2yUzo=;
        b=T/JBsC2ImjM4bYtOMs7VZnTt0UmqPSmm6JMCWjj9ZdXKzbN/k/pn8/2fwxG5fk/ovJSdx6
        MvEUw4Br6hqJfm9NlrJLGtjfapcoiSe84KcopZrauixshlDOPVe0R0Nfr4b07ziqPqTTP4
        0FcANRFYEAt5t0NlvrHMliRRgm30YgM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-ljLN9JOIOR-Zyrx8eNaKZg-1; Tue, 30 Mar 2021 12:45:36 -0400
X-MC-Unique: ljLN9JOIOR-Zyrx8eNaKZg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 944E71005D64;
        Tue, 30 Mar 2021 16:45:34 +0000 (UTC)
Received: from omen (ovpn-112-120.phx2.redhat.com [10.3.112.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 36EB75C1D1;
        Tue, 30 Mar 2021 16:45:34 +0000 (UTC)
Date:   Tue, 30 Mar 2021 10:45:33 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>, jgg@nvidia.com,
        daniel.m.jordan@oracle.com
Subject: [GIT PULL] VFIO fixes for v5.12-rc6
Message-ID: <20210330104533.4ab8d840@omen>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

The following changes since commit 0d02ec6b3136c73c09e7859f0d0e4e2c4c07b49b:

  Linux 5.12-rc4 (2021-03-21 14:56:43 -0700)

are available in the Git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-v5.12-rc6

for you to fetch changes up to e0146a108ce4d2c22b9510fd12268e3ee72a0161:

  vfio/nvlink: Add missing SPAPR_TCE_IOMMU depends (2021-03-29 14:48:00 -0600)

----------------------------------------------------------------
VFIO fixes for v5.12-rc6

 - Fix pfnmap batch carryover (Daniel Jordan)

 - Fix nvlink Kconfig dependency (Jason Gunthorpe)

----------------------------------------------------------------
Daniel Jordan (1):
      vfio/type1: Empty batch for pfnmap pages

Jason Gunthorpe (1):
      vfio/nvlink: Add missing SPAPR_TCE_IOMMU depends

 drivers/vfio/pci/Kconfig        | 2 +-
 drivers/vfio/vfio_iommu_type1.c | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

