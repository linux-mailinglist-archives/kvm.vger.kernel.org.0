Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61E2A600FA
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 08:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbfGEGVj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 02:21:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51786 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726892AbfGEGVj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 02:21:39 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3A460C058CBD;
        Fri,  5 Jul 2019 06:21:39 +0000 (UTC)
Received: from localhost (ovpn-116-51.ams2.redhat.com [10.36.116.51])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D301660BF1;
        Fri,  5 Jul 2019 06:21:35 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PULL 0/1] vfio-ccw fix for 5.3
Date:   Fri,  5 Jul 2019 08:21:31 +0200
Message-Id: <20190705062132.20755-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Fri, 05 Jul 2019 06:21:39 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 05f31e3bf6b34fe6e4922868d132f6455f81d5bf:

  s390: ap: kvm: Enable PQAP/AQIC facility for the guest (2019-07-02 16:00:28 +0200)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/vfio-ccw.git tags/vfio-ccw-20190705

for you to fetch changes up to c382cbc6dbf513d73cf896ad43a3789ad42c2e2f:

  vfio-ccw: Fix the conversion of Format-0 CCWs to Format-1 (2019-07-05 07:58:53 +0200)

----------------------------------------------------------------
Fix a bug introduced in the refactoring.

----------------------------------------------------------------

Eric Farman (1):
  vfio-ccw: Fix the conversion of Format-0 CCWs to Format-1

 drivers/s390/cio/vfio_ccw_cp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.20.1

