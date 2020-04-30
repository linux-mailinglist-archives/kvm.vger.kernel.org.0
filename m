Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F39A81C000F
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 17:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgD3PYn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 11:24:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56318 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726343AbgD3PYn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 11:24:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588260282;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=nhSNFmu2Iz7syjBaUT/MbA657lciB2SBAu/qfBBAEOI=;
        b=OKirr5QhrZuqYuWGjcAseq1xOYNCPmOkzA32n+oEHYTtxuYshne4RjM3uE+nDlevBf7px/
        2Xo4NcNv8An87C7MXOfUeh5FLbi7lFvgGyIId1/yD8cx8RMxgVweYAJ/ngXDtjWSqNOnyd
        N8r4OpeLpJAqaHP+M4g5OTQ5ZSsPktM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-gzfeDhBlOmaj1-KrYOon-w-1; Thu, 30 Apr 2020 11:24:37 -0400
X-MC-Unique: gzfeDhBlOmaj1-KrYOon-w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C442D107ACCA;
        Thu, 30 Apr 2020 15:24:35 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-172.ams2.redhat.com [10.36.113.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 400035D777;
        Thu, 30 Apr 2020 15:24:31 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        linux-s390@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Subject: [kvm-unit-tests PULL 00/17] s390x updates
Date:   Thu, 30 Apr 2020 17:24:13 +0200
Message-Id: <20200430152430.40349-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

The following changes since commit 5c052c904ded7ecd80d8f7efe2803821b45ce4=
83:

  kvm-unit-tests: nSVM: Test that CR0[63:32] are not set on VMRUN of nest=
ed guests (2020-04-21 12:16:07 -0400)

are available in the Git repository at:

  https://github.com/davidhildenbrand/kvm-unit-tests.git tags/s390x-2020-=
04-30

for you to fetch changes up to f7df29115f736b9ffe8e529ba9c2b418d2f5e736:

  s390x: Fix library constant definitions (2020-04-30 16:52:14 +0200)

----------------------------------------------------------------
New maintainer, reviewer, and cc list. New STSI test. Lots of minor fixes
and cleanups

----------------------------------------------------------------
Andrew Jones (1):
      s390x: unittests: Use smp parameter

Christian Borntraeger (2):
      s390x/smp: fix detection of "running"
      s390x/smp: add minimal test for sigp sense running status

Cornelia Huck (2):
      MAINTAINERS: s390x: add myself as reviewer
      MAINTAINERS: s390x: add linux-s390 list

David Hildenbrand (1):
      s390x: STFLE operates on doublewords

Janosch Frank (10):
      s390x: Add stsi 3.2.2 tests
      s390x: smp: Test all CRs on initial reset
      s390x: smp: Dirty fpc before initial reset test
      s390x: smp: Test stop and store status on a running and stopped cpu
      s390x: smp: Test local interrupts after cpu reset
      s390x: smp: Loop if secondary cpu returns into cpu setup again
      s390x: smp: Remove unneeded cpu loops
      s390x: smp: Use full PSW to bringup new cpu
      s390x: smp: Add restart when running test
      s390x: Fix library constant definitions

Thomas Huth (1):
      MAINTAINERS: Add Janosch as a s390x maintainer

 MAINTAINERS              |   4 +-
 lib/s390x/asm/arch_def.h |   8 ++--
 lib/s390x/asm/facility.h |  14 +++----
 lib/s390x/io.c           |   2 +-
 lib/s390x/smp.c          |   6 ++-
 lib/s390x/smp.h          |   2 +-
 s390x/cstart64.S         |   5 ++-
 s390x/smp.c              | 105 +++++++++++++++++++++++++++++++++++++++++=
++----
 s390x/stsi.c             |  73 ++++++++++++++++++++++++++++++++
 s390x/unittests.cfg      |   3 +-
 10 files changed, 196 insertions(+), 26 deletions(-)

