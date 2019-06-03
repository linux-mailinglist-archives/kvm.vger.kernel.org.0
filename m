Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A799832DF0
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2019 12:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbfFCKuo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 06:50:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59436 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727029AbfFCKuo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 06:50:44 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 387EA308621E;
        Mon,  3 Jun 2019 10:50:44 +0000 (UTC)
Received: from localhost (ovpn-204-96.brq.redhat.com [10.40.204.96])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C040F66060;
        Mon,  3 Jun 2019 10:50:43 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PULL 0/7] vfio-ccw: fixes
Date:   Mon,  3 Jun 2019 12:50:31 +0200
Message-Id: <20190603105038.11788-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Mon, 03 Jun 2019 10:50:44 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 674459be116955e025d6a5e6142e2d500103de8e:

  MAINTAINERS: add Vasily Gorbik and Christian Borntraeger for s390 (2019-05-31 10:14:15 +0200)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/vfio-ccw.git tags/vfio-ccw-20190603

for you to fetch changes up to 9b6e57e5a51696171de990b3c41bd53d4b8ab8ac:

  s390/cio: Remove vfio-ccw checks of command codes (2019-06-03 12:02:55 +0200)

----------------------------------------------------------------
various vfio-ccw fixes (ccw translation, state machine)

----------------------------------------------------------------

Eric Farman (7):
  s390/cio: Update SCSW if it points to the end of the chain
  s390/cio: Set vfio-ccw FSM state before ioeventfd
  s390/cio: Split pfn_array_alloc_pin into pieces
  s390/cio: Initialize the host addresses in pfn_array
  s390/cio: Don't pin vfio pages for empty transfers
  s390/cio: Allow zero-length CCWs in vfio-ccw
  s390/cio: Remove vfio-ccw checks of command codes

 drivers/s390/cio/vfio_ccw_cp.c  | 159 +++++++++++++++++++++++---------
 drivers/s390/cio/vfio_ccw_drv.c |   6 +-
 2 files changed, 119 insertions(+), 46 deletions(-)

-- 
2.20.1

