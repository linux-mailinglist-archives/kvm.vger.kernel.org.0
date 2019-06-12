Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7BF84221F
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 12:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbfFLKQt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 06:16:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33364 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbfFLKQt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 06:16:49 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3D72830832C8;
        Wed, 12 Jun 2019 10:16:49 +0000 (UTC)
Received: from localhost (ovpn-116-169.ams2.redhat.com [10.36.116.169])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B793653786;
        Wed, 12 Jun 2019 10:16:48 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PULL 0/1] vfio-ccw: bugfix
Date:   Wed, 12 Jun 2019 12:16:44 +0200
Message-Id: <20190612101645.9439-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Wed, 12 Jun 2019 10:16:49 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 753469a23b42d0c4a2b28de35826af74a4d554ab:

  Merge tag 'vfio-ccw-20190603' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/vfio-ccw into features (2019-06-04 15:04:53 +0200)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/vfio-ccw.git tags/vfio-ccw-20190612

for you to fetch changes up to 5398331c8c218cc9298fe95380b8b87a3a62defa:

  vfio-ccw: Destroy kmem cache region on module exit (2019-06-04 17:32:01 +0200)

----------------------------------------------------------------
Fix a memory leak on exit.

----------------------------------------------------------------

Farhan Ali (1):
  vfio-ccw: Destroy kmem cache region on module exit

 drivers/s390/cio/vfio_ccw_drv.c | 1 +
 1 file changed, 1 insertion(+)

-- 
2.20.1

