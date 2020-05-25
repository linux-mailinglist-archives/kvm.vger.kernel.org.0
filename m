Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE66C1E0AD1
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 11:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389619AbgEYJl0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 05:41:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41482 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388182AbgEYJl0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 05:41:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590399685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JwjWmEOBpRQtZ8phDKRgWl2KRxszcpdW2e3E8rqI/3E=;
        b=dhCCnSgI8gwkSMFCV2Lam2IXtd2KFzqzmIktOZCmKUEaa5H6vN/aGt3BfwyDSHjADI16l4
        JtWScRLqaqSS1szzp2x5tKTmYGwXoCHphaQcxHMlySv9d0oEx5pfWx2jtr/n22O+DgCefU
        AmrNDvQ1RVaaVhZqHazNa0upyk5K5cg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-115-QFw6Q0ZtP-CEmUV1fPFVhA-1; Mon, 25 May 2020 05:41:21 -0400
X-MC-Unique: QFw6Q0ZtP-CEmUV1fPFVhA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C29BB1009624;
        Mon, 25 May 2020 09:41:19 +0000 (UTC)
Received: from localhost (ovpn-112-215.ams2.redhat.com [10.36.112.215])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A6C310027A6;
        Mon, 25 May 2020 09:41:19 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PULL 00/10] vfio-ccw patches for 5.8
Date:   Mon, 25 May 2020 11:41:05 +0200
Message-Id: <20200525094115.222299-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 6a8b55ed4056ea5559ebe4f6a4b247f627870d4c:

  Linux 5.7-rc3 (2020-04-26 13:51:02 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/vfio-ccw tags/vfio-ccw-20200525

for you to fetch changes up to 40b4240eed2f2de57775b996a0b38d412e570086:

  vfio-ccw: Add trace for CRW event (2020-05-18 11:46:33 +0200)

----------------------------------------------------------------
vfio-ccw updates:
- accept requests without the prefetch bit set
- enable path handling via two new regions

----------------------------------------------------------------
Cornelia Huck (1):
      vfio-ccw: document possible errors

Eric Farman (3):
      vfio-ccw: Refactor the unregister of the async regions
      vfio-ccw: Refactor IRQ handlers
      vfio-ccw: Add trace for CRW event

Farhan Ali (5):
      vfio-ccw: Introduce new helper functions to free/destroy regions
      vfio-ccw: Register a chp_event callback for vfio-ccw
      vfio-ccw: Introduce a new schib region
      vfio-ccw: Introduce a new CRW region
      vfio-ccw: Wire up the CRW irq and CRW region

Jared Rossi (1):
      vfio-ccw: Enable transparent CCW IPL from DASD

 Documentation/s390/vfio-ccw.rst     |  99 +++++++++++++++++++++-
 drivers/s390/cio/Makefile           |   2 +-
 drivers/s390/cio/vfio_ccw_chp.c     | 148 ++++++++++++++++++++++++++++++++
 drivers/s390/cio/vfio_ccw_cp.c      |  19 +++--
 drivers/s390/cio/vfio_ccw_drv.c     | 165 +++++++++++++++++++++++++++++++++---
 drivers/s390/cio/vfio_ccw_ops.c     |  65 ++++++++++----
 drivers/s390/cio/vfio_ccw_private.h |  16 ++++
 drivers/s390/cio/vfio_ccw_trace.c   |   1 +
 drivers/s390/cio/vfio_ccw_trace.h   |  30 +++++++
 include/uapi/linux/vfio.h           |   3 +
 include/uapi/linux/vfio_ccw.h       |  18 ++++
 11 files changed, 529 insertions(+), 37 deletions(-)
 create mode 100644 drivers/s390/cio/vfio_ccw_chp.c

Cornelia Huck (1):
  vfio-ccw: document possible errors

Eric Farman (3):
  vfio-ccw: Refactor the unregister of the async regions
  vfio-ccw: Refactor IRQ handlers
  vfio-ccw: Add trace for CRW event

Farhan Ali (5):
  vfio-ccw: Introduce new helper functions to free/destroy regions
  vfio-ccw: Register a chp_event callback for vfio-ccw
  vfio-ccw: Introduce a new schib region
  vfio-ccw: Introduce a new CRW region
  vfio-ccw: Wire up the CRW irq and CRW region

Jared Rossi (1):
  vfio-ccw: Enable transparent CCW IPL from DASD

 Documentation/s390/vfio-ccw.rst     |  99 ++++++++++++++++-
 drivers/s390/cio/Makefile           |   2 +-
 drivers/s390/cio/vfio_ccw_chp.c     | 148 +++++++++++++++++++++++++
 drivers/s390/cio/vfio_ccw_cp.c      |  19 ++--
 drivers/s390/cio/vfio_ccw_drv.c     | 165 ++++++++++++++++++++++++++--
 drivers/s390/cio/vfio_ccw_ops.c     |  65 ++++++++---
 drivers/s390/cio/vfio_ccw_private.h |  16 +++
 drivers/s390/cio/vfio_ccw_trace.c   |   1 +
 drivers/s390/cio/vfio_ccw_trace.h   |  30 +++++
 include/uapi/linux/vfio.h           |   3 +
 include/uapi/linux/vfio_ccw.h       |  18 +++
 11 files changed, 529 insertions(+), 37 deletions(-)
 create mode 100644 drivers/s390/cio/vfio_ccw_chp.c

-- 
2.25.4

