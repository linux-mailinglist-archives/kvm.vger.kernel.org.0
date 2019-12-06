Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 790A311571B
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 19:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbfLFSWc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 13:22:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25747 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726298AbfLFSWc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 13:22:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575656551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=pkO2zZFmgQehl/A8nk21THxwcIqs5vjrYyeZ+q3C/Nk=;
        b=Cr93jeQWMdg5kBFM60+z+DPcRbgSN0FTk6PDmNRt5GOonNKi4fxcmpkXPK6b8BBCTGjqzU
        Ru/o9Vt8yZFNt33a/pD4EvWP1+LFApQo+OxP1iE5o5a+rsKqaX7MVy0ZYYLaFYz4Jg58xT
        87DqN2CqjzsT9QCT1GOGS5HIESVP1+4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-S58x6o8wPNCLHbUrxi5mBA-1; Fri, 06 Dec 2019 13:22:30 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D070800D4C;
        Fri,  6 Dec 2019 18:22:29 +0000 (UTC)
Received: from x1.home (ovpn-116-56.phx2.redhat.com [10.3.116.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD5D6608A5;
        Fri,  6 Dec 2019 18:22:28 +0000 (UTC)
Date:   Fri, 6 Dec 2019 11:22:27 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [GIT PULL] VFIO updates for v5.5-rc1
Message-ID: <20191206112227.53e15607@x1.home>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: S58x6o8wPNCLHbUrxi5mBA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

The following changes since commit 4f5cafb5cb8471e54afdc9054d973535614f7675:

  Linux 5.4-rc3 (2019-10-13 16:37:36 -0700)

are available in the Git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-v5.5-rc1

for you to fetch changes up to 9917b54aded12dff9beb9e709981617b788e44b0:

  Merge branch 'v5.5/vfio/jiang-yi-irq-bypass-unregister-v1' into v5.5/vfio/next (2019-12-04 10:15:56 -0700)

----------------------------------------------------------------
VFIO updates for v5.5-rc1

 - Remove hugepage checks for reserved pfns (Ben Luo)

 - Fix irq-bypass unregister ordering (Jiang Yi)

----------------------------------------------------------------
Alex Williamson (1):
      Merge branch 'v5.5/vfio/jiang-yi-irq-bypass-unregister-v1' into v5.5/vfio/next

Ben Luo (1):
      vfio/type1: remove hugepage checks in is_invalid_reserved_pfn()

Jiang Yi (1):
      vfio/pci: call irq_bypass_unregister_producer() before freeing irq

 drivers/vfio/pci/vfio_pci_intrs.c |  2 +-
 drivers/vfio/vfio_iommu_type1.c   | 26 ++++----------------------
 2 files changed, 5 insertions(+), 23 deletions(-)

