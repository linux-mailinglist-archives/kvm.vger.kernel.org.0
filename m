Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF146AB82
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 17:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387847AbfGPPSQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 11:18:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41436 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728137AbfGPPSQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 11:18:16 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 408F0C025014;
        Tue, 16 Jul 2019 15:18:16 +0000 (UTC)
Received: from x1.home (ovpn-116-35.phx2.redhat.com [10.3.116.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 11375617AA;
        Tue, 16 Jul 2019 15:18:16 +0000 (UTC)
Date:   Tue, 16 Jul 2019 09:18:15 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [GIT PULL] VFIO updates for v5.3-rc1
Message-ID: <20190716091815.74662138@x1.home>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Tue, 16 Jul 2019 15:18:16 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

The following changes since commit 6fbc7275c7a9ba97877050335f290341a1fd8dbf:

  Linux 5.2-rc7 (2019-06-30 11:25:36 +0800)

are available in the Git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-v5.3-rc1

for you to fetch changes up to 1e4d09d2212d9e230b967f57bc8df463527dbd75:

  mdev: Send uevents around parent device registration (2019-07-11 13:26:52 -0600)

----------------------------------------------------------------
VFIO updates for v5.3-rc1

 - Static symbol cleanup in mdev samples (Kefeng Wang)

 - Use vma help in nvlink code (Peng Hao)

 - Remove unused code in mbochs sample (YueHaibing)

 - Send uevents around mdev registration (Alex Williamson)

----------------------------------------------------------------
Alex Williamson (1):
      mdev: Send uevents around parent device registration

Kefeng Wang (1):
      vfio-mdev/samples: make some symbols static

Peng Hao (1):
      vfio: vfio_pci_nvlink2: use a vma helper function

YueHaibing (1):
      sample/mdev/mbochs: remove set but not used variable 'mdev_state'

 drivers/vfio/mdev/mdev_core.c       |  9 +++++++
 drivers/vfio/pci/vfio_pci_nvlink2.c |  3 +--
 samples/vfio-mdev/mbochs.c          |  3 ---
 samples/vfio-mdev/mtty.c            | 47 +++++++++++++++++++------------------
 4 files changed, 34 insertions(+), 28 deletions(-)
