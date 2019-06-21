Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 486974EAAC
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 16:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbfFUOeA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 10:34:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34251 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbfFUOeA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 10:34:00 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DDCD93179156;
        Fri, 21 Jun 2019 14:33:59 +0000 (UTC)
Received: from localhost (dhcp-192-192.str.redhat.com [10.33.192.192])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 883D75C22B;
        Fri, 21 Jun 2019 14:33:59 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PULL 00/14] more vfio-ccw updates for 5.3
Date:   Fri, 21 Jun 2019 16:33:41 +0200
Message-Id: <20190621143355.29175-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Fri, 21 Jun 2019 14:34:00 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 39c00378e337c869b0c9cd35e108fc0c8671d644:

  Update default configuration (2019-06-15 12:27:29 +0200)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/vfio-ccw.git tags/vfio-ccw-20190621

for you to fetch changes up to 5223bee837e8d90d752de744c5702706a7bb13d9:

  vfio-ccw: Remove copy_ccw_from_iova() (2019-06-21 14:13:37 +0200)

----------------------------------------------------------------
Refactoring of the vfio-ccw cp handling, simplifying the
code and avoiding unneeded allocating/copying.

----------------------------------------------------------------

Eric Farman (14):
  s390/cio: Squash cp_free() and cp_unpin_free()
  s390/cio: Refactor the routine that handles TIC CCWs
  s390/cio: Generalize the TIC handler
  s390/cio: Use generalized CCW handler in cp_init()
  vfio-ccw: Rearrange pfn_array and pfn_array_table arrays
  vfio-ccw: Adjust the first IDAW outside of the nested loops
  vfio-ccw: Remove pfn_array_table
  vfio-ccw: Rearrange IDAL allocation in direct CCW
  s390/cio: Combine direct and indirect CCW paths
  vfio-ccw: Move guest_cp storage into common struct
  vfio-ccw: Skip second copy of guest cp to host
  vfio-ccw: Copy CCW data outside length calculation
  vfio-ccw: Factor out the ccw0-to-ccw1 transition
  vfio-ccw: Remove copy_ccw_from_iova()

 drivers/s390/cio/vfio_ccw_cp.c  | 415 +++++++++++---------------------
 drivers/s390/cio/vfio_ccw_cp.h  |   7 +
 drivers/s390/cio/vfio_ccw_drv.c |   7 +
 3 files changed, 151 insertions(+), 278 deletions(-)

-- 
2.20.1

