Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93FFD340DFC
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 20:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbhCRTP7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 15:15:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44278 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232728AbhCRTPq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 15:15:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616094945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=UrN6I/K64VfQCttfF8qXoz5SoRAyjeSvtF00DW1eR4I=;
        b=KunJ3BS6ddKULC7PI8y+mTiQ3DFKpdQtYicC9jFs4jTKMOJgxLkTAxlgdljnym/Foqg7UE
        60egEGQBMuA8GboAy6xg+LmZ/WxuqtqQEc/LNK3pDErznSx8ovpQgPLW7fbkiKPer+cz7u
        Yf8igH+arbD5dI/Mzm0B8mXgh7y14ds=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-3LcEhTwLPCSXOj0Z9u-Bog-1; Thu, 18 Mar 2021 15:15:41 -0400
X-MC-Unique: 3LcEhTwLPCSXOj0Z9u-Bog-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2EC1018C89C4;
        Thu, 18 Mar 2021 19:15:40 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A60215D9C6;
        Thu, 18 Mar 2021 19:15:39 +0000 (UTC)
Date:   Thu, 18 Mar 2021 13:15:39 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        steven.sistare@oracle.com, jgg@nvidia.com,
        daniel.m.jordan@oracle.com
Subject: [GIT PULL] VFIO fixes for v5.12-rc4
Message-ID: <20210318131539.1c66212d@omen.home.shazbot.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

The following changes since commit 1e28eed17697bcf343c6743f0028cc3b5dd88bf0:

  Linux 5.12-rc3 (2021-03-14 14:41:02 -0700)

are available in the Git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-v5.12-rc4

for you to fetch changes up to 4ab4fcfce5b540227d80eb32f1db45ab615f7c92:

  vfio/type1: fix vaddr_get_pfns() return in vfio_pin_page_external() (2021-03-16 10:39:29 -0600)

----------------------------------------------------------------
VFIO fixes for v5.12-rc4

 - Fix 32-bit issue with new unmap-all flag (Steve Sistare)

 - Various Kconfig changes for better coverage (Jason Gunthorpe)

 - Fix to batch pinning support (Daniel Jordan)

----------------------------------------------------------------
Daniel Jordan (1):
      vfio/type1: fix vaddr_get_pfns() return in vfio_pin_page_external()

Jason Gunthorpe (4):
      vfio: IOMMU_API should be selected
      vfio-platform: Add COMPILE_TEST to VFIO_PLATFORM
      ARM: amba: Allow some ARM_AMBA users to compile with COMPILE_TEST
      vfio: Depend on MMU

Steve Sistare (1):
      vfio/type1: fix unmap all on ILP32

 drivers/vfio/Kconfig            |  4 ++--
 drivers/vfio/platform/Kconfig   |  4 ++--
 drivers/vfio/vfio_iommu_type1.c | 20 ++++++++++++--------
 include/linux/amba/bus.h        | 11 +++++++++++
 4 files changed, 27 insertions(+), 12 deletions(-)

