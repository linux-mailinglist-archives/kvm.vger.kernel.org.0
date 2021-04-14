Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C795735F72B
	for <lists+kvm@lfdr.de>; Wed, 14 Apr 2021 17:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235620AbhDNPDz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 11:03:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44679 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230213AbhDNPDy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Apr 2021 11:03:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618412612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=88s58SzYj2MxQQqxlXe2yFHWu8MlDxFM8fvj/JE9A8A=;
        b=RrMZnQyluQZOL4oWKnaIpg2pV+bXMcNz9gAyel/KmDzqe7a8DKZBiThOf1iscWrrjwK3BV
        VywpK3cy/3J1iu+8TlFI8ojiLsWccCXbMVRWz4fKPMnrRvsy/tO9nBh54/Z4h1Gs+pCkbl
        YHYXmPWao6tx69MligCMaUnHFIqPZ+Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-HyQaNGn_NxyF144W0WNB-A-1; Wed, 14 Apr 2021 11:03:28 -0400
X-MC-Unique: HyQaNGn_NxyF144W0WNB-A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C00D83DD20;
        Wed, 14 Apr 2021 15:03:27 +0000 (UTC)
Received: from omen (ovpn-117-254.rdu2.redhat.com [10.10.117.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 633C26087C;
        Wed, 14 Apr 2021 15:03:26 +0000 (UTC)
Date:   Wed, 14 Apr 2021 09:03:25 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>, lk@c--e.de
Subject: [GIT PULL] VFIO fix for v5.12-rc8/final
Message-ID: <20210414090325.3580db75@omen>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

Sorry for the late request.

The following changes since commit d434405aaab7d0ebc516b68a8fc4100922d7f5ef:

  Linux 5.12-rc7 (2021-04-11 15:16:13 -0700)

are available in the Git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-v5.12-rc8

for you to fetch changes up to 909290786ea335366e21d7f1ed5812b90f2f0a92:

  vfio/pci: Add missing range check in vfio_pci_mmap (2021-04-13 08:29:16 -0600)

----------------------------------------------------------------
VFIO fix for v5.12-rc8/final

 - Verify mmap region within range (Christian A. Ehrhardt)

----------------------------------------------------------------
Christian A. Ehrhardt (1):
      vfio/pci: Add missing range check in vfio_pci_mmap

 drivers/vfio/pci/vfio_pci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

