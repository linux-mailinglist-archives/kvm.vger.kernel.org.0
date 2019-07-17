Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3835F6B979
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2019 11:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbfGQJn5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jul 2019 05:43:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52806 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbfGQJn4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jul 2019 05:43:56 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B23E781F1B;
        Wed, 17 Jul 2019 09:43:56 +0000 (UTC)
Received: from localhost (dhcp-192-232.str.redhat.com [10.33.192.232])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F67560BFC;
        Wed, 17 Jul 2019 09:43:56 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PULL v2 0/6] vfio-ccw fixes for 5.3
Date:   Wed, 17 Jul 2019 11:43:44 +0200
Message-Id: <20190717094350.13620-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Wed, 17 Jul 2019 09:43:56 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 9a159190414d461fdac7ae5bb749c2d532b35419:

  s390/unwind: avoid int overflow in outside_of_stack (2019-07-11 20:40:02 +0200)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/vfio-ccw.git tags/vfio-ccw-20190717-2

for you to fetch changes up to 4c4cbbaa693a5cc435664f2f220c8b0be873abd1:

  Documentation: fix vfio-ccw doc (2019-07-17 11:35:35 +0200)

----------------------------------------------------------------
Fixes in vfio-ccw for older and newer issues.

----------------------------------------------------------------

Cornelia Huck (1):
  Documentation: fix vfio-ccw doc

Farhan Ali (5):
  vfio-ccw: Fix misleading comment when setting orb.cmd.c64
  vfio-ccw: Fix memory leak and don't call cp_free in cp_init
  vfio-ccw: Set pa_nr to 0 if memory allocation fails for pa_iova_pfn
  vfio-ccw: Don't call cp_free if we are processing a channel program
  vfio-ccw: Update documentation for csch/hsch

 Documentation/s390/vfio-ccw.rst | 31 ++++++++++++++++++++++++++++---
 drivers/s390/cio/vfio_ccw_cp.c  | 28 +++++++++++++++++-----------
 drivers/s390/cio/vfio_ccw_drv.c |  2 +-
 3 files changed, 46 insertions(+), 15 deletions(-)

-- 
2.20.1

