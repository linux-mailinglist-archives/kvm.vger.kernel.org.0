Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C5B20C20F
	for <lists+kvm@lfdr.de>; Sat, 27 Jun 2020 16:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbgF0OZ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Jun 2020 10:25:29 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:42516 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726067AbgF0OZ1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 27 Jun 2020 10:25:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593267926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ucveFcaVn+NbjZBITUs6YHOBMRpcQVmuOm1jQkNCAac=;
        b=hw7aB7tZI+ZWKnJ05VLH9nAmPCQFZXWFeZaQqBuphM7/NkpRqEMtDhWDoiDOSd4mGRyQf6
        6exJbyNDLREM9mMfDWtaak4sbBShlnYXPGFTARym2tEBmXi17tCz9m3UGE2KgJqBoLywF6
        Yv7xdOAwzaSrWCqk1/Vj2pXFN2Epjes=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-XqGsosmvMWyJotxsjT9lIA-1; Sat, 27 Jun 2020 10:25:20 -0400
X-MC-Unique: XqGsosmvMWyJotxsjT9lIA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD54B1883607;
        Sat, 27 Jun 2020 14:25:19 +0000 (UTC)
Received: from x1.home (ovpn-112-156.phx2.redhat.com [10.3.112.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 84FEB5C1C3;
        Sat, 27 Jun 2020 14:25:19 +0000 (UTC)
Date:   Sat, 27 Jun 2020 08:25:18 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] VFIO fixes for v5.8-rc3
Message-ID: <20200627082518.38f98251@x1.home>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

The following changes since commit b3a9e3b9622ae10064826dccb4f7a52bd88c7407:

  Linux 5.8-rc1 (2020-06-14 12:45:04 -0700)

are available in the Git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-v5.8-rc3

for you to fetch changes up to ebfa440ce38b7e2e04c3124aa89c8a9f4094cf21:

  vfio/pci: Fix SR-IOV VF handling with MMIO blocking (2020-06-25 11:04:23 -0600)

----------------------------------------------------------------
VFIO fixes for v5.8-rc3

 - Fix double free of eventfd ctx (Alex Williamson)

 - Fix duplicate use of capability ID (Alex Williamson)

 - Fix SR-IOV VF memory enable handling (Alex Williamson)

----------------------------------------------------------------
Alex Williamson (3):
      vfio/pci: Clear error and request eventfd ctx after releasing
      vfio/type1: Fix migration info capability ID
      vfio/pci: Fix SR-IOV VF handling with MMIO blocking

 drivers/vfio/pci/vfio_pci.c        |  8 ++++++--
 drivers/vfio/pci/vfio_pci_config.c | 17 ++++++++++++++++-
 include/uapi/linux/vfio.h          |  2 +-
 3 files changed, 23 insertions(+), 4 deletions(-)

