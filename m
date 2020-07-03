Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C12C213824
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 11:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725915AbgGCJxC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 05:53:02 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45292 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726129AbgGCJxC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Jul 2020 05:53:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593769981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=FE5Y6pp8ElNmVhvkeBI43hIDt5SlchO8yAxOIStBeaM=;
        b=K+uoeI6MOxpxSI6SKh/pSkHxucSF6reASNSdhqW3IHN5nqBdp6q6bB5j89pb8SzxMY8Bwb
        +oaAYwRZ015T23TuycAFop9pdl2x//qtzN6O7s7bhGK2k4Ml8t4MhAO+NMpWcjHZSdP40/
        M2SzYucnnIfpyns4833XJW1TNtmHwJM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-ZTA5Yu0ZOMGrkWLkcKRf5g-1; Fri, 03 Jul 2020 05:52:59 -0400
X-MC-Unique: ZTA5Yu0ZOMGrkWLkcKRf5g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74778107ACCA;
        Fri,  3 Jul 2020 09:52:58 +0000 (UTC)
Received: from localhost (ovpn-113-54.ams2.redhat.com [10.36.113.54])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 16A947AC71;
        Fri,  3 Jul 2020 09:52:57 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PULL 0/1] vfio-ccw fix
Date:   Fri,  3 Jul 2020 11:52:52 +0200
Message-Id: <20200703095253.620719-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 9e9f85e029a2ee4167aacf3ff04e4288a5e5c74e:

  s390: update defconfigs (2020-07-01 20:02:38 +0200)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/vfio-ccw tags/vfio-ccw-20200703

for you to fetch changes up to d8ca55addb9315ecd9fc4397f4c94d3f1980161c:

  vfio-ccw: Fix a build error due to missing include of linux/slab.h (2020-07-03 11:41:31 +0200)

----------------------------------------------------------------
add a missing include

----------------------------------------------------------------

Sean Christopherson (1):
  vfio-ccw: Fix a build error due to missing include of linux/slab.h

 drivers/s390/cio/vfio_ccw_chp.c | 1 +
 1 file changed, 1 insertion(+)

-- 
2.25.4

