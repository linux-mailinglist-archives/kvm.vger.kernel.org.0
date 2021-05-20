Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0CED38AC5D
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 13:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240972AbhETLiV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 07:38:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51265 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241082AbhETLgT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 May 2021 07:36:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621510498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vNMGpZqxRmHczjMFUilM+26He8KcqebZKfsvADu1AzE=;
        b=RBn72UI2kxjRa9vwh+2ZnpcAsfRiVxTCvv6xIuNbTGhfgoCG0x6L9qC9TaI8kV2ZDFkzHV
        Tv1HdFvGAKBbZSlkHkF6Q96Tgjy1yIkW+g75r/cMghIl4mz+logc4Zb0H32c71qA1EpRGK
        v4hcS3/aXROtxhIf2OEZ+uSml5Ve6VQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-VxA7lTOQOmiYNbCTGRk8Dw-1; Thu, 20 May 2021 07:34:56 -0400
X-MC-Unique: VxA7lTOQOmiYNbCTGRk8Dw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56E36107ACC7;
        Thu, 20 May 2021 11:34:55 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-166.ams2.redhat.com [10.36.113.166])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F248E10016F2;
        Thu, 20 May 2021 11:34:53 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PULL 0/3] vfio-ccw: some fixes
Date:   Thu, 20 May 2021 13:34:47 +0200
Message-Id: <20210520113450.267893-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 6efb943b8616ec53a5e444193dccf1af9ad627b5:

  Linux 5.13-rc1 (2021-05-09 14:17:44 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/vfio-ccw.git tags/vfio-ccw-20210520

for you to fetch changes up to 2af7a834a435460d546f0cf0a8b8e4d259f1d910:

  vfio-ccw: Serialize FSM IDLE state with I/O completion (2021-05-12 12:59:50 +0200)

----------------------------------------------------------------
Avoid some races in vfio-ccw request handling.

----------------------------------------------------------------

Eric Farman (3):
  vfio-ccw: Check initialized flag in cp_init()
  vfio-ccw: Reset FSM state to IDLE inside FSM
  vfio-ccw: Serialize FSM IDLE state with I/O completion

 drivers/s390/cio/vfio_ccw_cp.c  |  4 ++++
 drivers/s390/cio/vfio_ccw_drv.c | 12 ++++++++++--
 drivers/s390/cio/vfio_ccw_fsm.c |  1 +
 drivers/s390/cio/vfio_ccw_ops.c |  2 --
 4 files changed, 15 insertions(+), 4 deletions(-)

-- 
2.31.1

