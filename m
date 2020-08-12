Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D50242418
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 04:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgHLCbw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Aug 2020 22:31:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27488 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726235AbgHLCbv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Aug 2020 22:31:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597199510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=2EC38ghpNZUdwD9Qkzu2IPHuATHcILU8kmquKFz/u7E=;
        b=VDkqO16TdW2W5zKjHEnv2R4QUHcmeHYCCXkttG5ZoouOBTH6QRDdCuLEPBayIrGLRSDQqD
        CPV8yE0f6pykyzxrmMmTnQ+uPclgEF+ktkXy11YXyMAQvddaBs4alcYXVJ77fx6PZxRbIF
        EP+T8eNM0fREkGuJXv3/g10ew3pYO68=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-k48dE6NrNqaehmKFfqVikw-1; Tue, 11 Aug 2020 22:31:48 -0400
X-MC-Unique: k48dE6NrNqaehmKFfqVikw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BEC0857;
        Wed, 12 Aug 2020 02:31:47 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 861537AC68;
        Wed, 12 Aug 2020 02:31:47 +0000 (UTC)
Date:   Tue, 11 Aug 2020 20:31:47 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] VFIO updates for v5.9-rc1
Message-ID: <20200811203147.1ad96351@x1.home>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

The following changes since commit 92ed301919932f777713b9172e525674157e983d:

  Linux 5.8-rc7 (2020-07-26 14:14:06 -0700)

are available in the Git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-v5.9-rc1

for you to fetch changes up to ccd59dce1a21f473518bf273bdf5b182bab955b3:

  vfio/type1: Refactor vfio_iommu_type1_ioctl() (2020-07-27 13:46:13 -0600)

----------------------------------------------------------------
VFIO updates for v5.9-rc1

 - Inclusive naming updates (Alex Williamson)

 - Intel X550 INTx quirk (Alex Williamson)

 - Error path resched between unmaps (Xiang Zheng)

 - SPAPR IOMMU pin_user_pages() conversion (John Hubbard)

 - Trivial mutex simplification (Alex Williamson)

 - QAT device denylist (Giovanni Cabiddu)

 - type1 IOMMU ioctl refactor (Liu Yi L)

----------------------------------------------------------------
Alex Williamson (3):
      vfio: Cleanup allowed driver naming
      vfio/pci: Add Intel X550 to hidden INTx devices
      vfio/pci: Hold igate across releasing eventfd contexts

Giovanni Cabiddu (3):
      PCI: Add Intel QuickAssist device IDs
      vfio/pci: Add device denylist
      vfio/pci: Add QAT devices to denylist

John Hubbard (1):
      vfio/spapr_tce: convert get_user_pages() --> pin_user_pages()

Liu Yi L (1):
      vfio/type1: Refactor vfio_iommu_type1_ioctl()

Xiang Zheng (1):
      vfio/type1: Add conditional rescheduling after iommu map failed

 drivers/vfio/pci/vfio_pci.c         |  54 ++++-
 drivers/vfio/vfio.c                 |  13 +-
 drivers/vfio/vfio_iommu_spapr_tce.c |   4 +-
 drivers/vfio/vfio_iommu_type1.c     | 398 +++++++++++++++++++-----------------
 include/linux/pci_ids.h             |   6 +
 5 files changed, 282 insertions(+), 193 deletions(-)

