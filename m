Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2511A06CA
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 17:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbfH1P5U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 11:57:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65215 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726713AbfH1P5U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 11:57:20 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 90F358AC6F9;
        Wed, 28 Aug 2019 15:57:20 +0000 (UTC)
Received: from localhost (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E6785C1D6;
        Wed, 28 Aug 2019 15:57:20 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PULL 0/1] vfio-ccw patch for next release
Date:   Wed, 28 Aug 2019 17:57:15 +0200
Message-Id: <20190828155716.22809-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.69]); Wed, 28 Aug 2019 15:57:20 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 416f79c23dbe47e0e223efc06d3487e1d90a92ee:

  s390/paes: Prepare paes functions for large key blobs (2019-08-21 12:58:54 +0200)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/vfio-ccw.git tags/vfio-ccw-20190828

for you to fetch changes up to 60e05d1cf0875f0cf73472f7dff71d9933c5b697:

  vfio-ccw: add some logging (2019-08-23 12:53:32 +0200)

----------------------------------------------------------------
Add some logging into the s390dbf.

----------------------------------------------------------------

Cornelia Huck (1):
  vfio-ccw: add some logging

 drivers/s390/cio/vfio_ccw_drv.c     | 50 ++++++++++++++++++++++++++--
 drivers/s390/cio/vfio_ccw_fsm.c     | 51 ++++++++++++++++++++++++++++-
 drivers/s390/cio/vfio_ccw_ops.c     | 10 ++++++
 drivers/s390/cio/vfio_ccw_private.h | 17 ++++++++++
 4 files changed, 124 insertions(+), 4 deletions(-)

-- 
2.20.1

