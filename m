Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEF903D48A
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 19:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406650AbfFKRuA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 13:50:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35442 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406643AbfFKRuA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 13:50:00 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 751039D0F7;
        Tue, 11 Jun 2019 17:49:57 +0000 (UTC)
Received: from x1.home (ovpn-116-190.phx2.redhat.com [10.3.116.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1089B60C81;
        Tue, 11 Jun 2019 17:49:55 +0000 (UTC)
Date:   Tue, 11 Jun 2019 11:49:55 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: [GIT PULL] VFIO fixes for v5.2-rc5
Message-ID: <20190611114955.2d0b6388@x1.home>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Tue, 11 Jun 2019 17:50:00 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

The following changes since commit f2c7c76c5d0a443053e94adb9f0918fa2fb85c3a:

  Linux 5.2-rc3 (2019-06-02 13:55:33 -0700)

are available in the Git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-v5.2-rc5

for you to fetch changes up to 5715c4dd66a315515eedef3fc4cbe1bf4620f009:

  vfio/mdev: Synchronize device create/remove with parent removal (2019-06-06 12:32:37 -0600)

----------------------------------------------------------------
VFIO fixes for v5.2-rc5

 - Fix mdev device create/remove paths to provide initialized device for
   parent driver create callback and correct ordering of device removal
   from bus prior to initiating removal by parent.  Also resolve races
   between parent removal and device create/remove paths. (Parav Pandit)

----------------------------------------------------------------
Parav Pandit (3):
      vfio/mdev: Improve the create/remove sequence
      vfio/mdev: Avoid creating sysfs remove file on stale device removal
      vfio/mdev: Synchronize device create/remove with parent removal

 drivers/vfio/mdev/mdev_core.c    | 136 ++++++++++++++++++---------------------
 drivers/vfio/mdev/mdev_private.h |   4 +-
 drivers/vfio/mdev/mdev_sysfs.c   |   6 +-
 3 files changed, 69 insertions(+), 77 deletions(-)
