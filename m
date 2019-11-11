Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37279F7562
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 14:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbfKKNu2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 08:50:28 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29681 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726887AbfKKNu2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 08:50:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573480226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=8JCxOw3BImA6khL1YeIuICYDLlOUD6+B4yx10OooT2o=;
        b=JgjIn3pj+Dqt936amljyM8xeVK1SBPH+Qw5wR+lDC2YIkyiHLxj5nk/DsynvQMzNrMYokU
        CYvPR+7TUUfIP9HqYthQ8zxM60pO8M+lyYLvJh9GTK9sVxtmQ9RSD3DAMfo8odFkFDM4jq
        k55XLDxAIVM3bAYOYLLponUsrg/mOKQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-4l2IOjYPMn2YL2_UmjIAHQ-1; Mon, 11 Nov 2019 08:50:25 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 218391005509;
        Mon, 11 Nov 2019 13:50:24 +0000 (UTC)
Received: from localhost (ovpn-117-4.ams2.redhat.com [10.36.117.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B79B018B91;
        Mon, 11 Nov 2019 13:50:23 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PULL 0/4] vfio-ccw updates
Date:   Mon, 11 Nov 2019 14:50:15 +0100
Message-Id: <20191111135019.2394-1-cohuck@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: 4l2IOjYPMn2YL2_UmjIAHQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 89d0180a60fcc5368eb2d92faeb1e012f8a591b3=
:

  s390/Kconfig: add z13s and z14 ZR1 to TUNE descriptions (2019-10-10 10:50=
:14 +0200)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/vfio-ccw.git tags=
/vfio-ccw-20191111

for you to fetch changes up to 8529888070f15e7c784b1c93bad358bf1d08045f:

  vfio-ccw: Rework the io_fctl trace (2019-10-17 11:37:24 +0200)

----------------------------------------------------------------
enhance tracing in vfio-ccw

----------------------------------------------------------------

Eric Farman (4):
  vfio-ccw: Refactor how the traces are built
  vfio-ccw: Trace the FSM jumptable
  vfio-ccw: Add a trace for asynchronous requests
  vfio-ccw: Rework the io_fctl trace

 drivers/s390/cio/Makefile           |  4 +-
 drivers/s390/cio/vfio_ccw_cp.h      |  1 +
 drivers/s390/cio/vfio_ccw_fsm.c     | 11 +++--
 drivers/s390/cio/vfio_ccw_private.h |  1 +
 drivers/s390/cio/vfio_ccw_trace.c   | 14 ++++++
 drivers/s390/cio/vfio_ccw_trace.h   | 76 ++++++++++++++++++++++++++---
 6 files changed, 93 insertions(+), 14 deletions(-)
 create mode 100644 drivers/s390/cio/vfio_ccw_trace.c

--=20
2.21.0

