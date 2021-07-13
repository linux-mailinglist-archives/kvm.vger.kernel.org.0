Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02FA23C7814
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 22:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235060AbhGMUkj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 16:40:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27574 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234172AbhGMUkj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Jul 2021 16:40:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626208668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=StjhJZ4vCHXZICLvMdmlRWHHb1Np0k3u9iVCo+f4OO0=;
        b=V7FdtVF6yQufpQ02NJa+3H11nBYHVzrrpafCy89dkYfka7CrezU7Frs+n5PgdR9R8Of50t
        8Jg3x/y/WHA9c4DmzhmcSDezcFlh07tVp1zS8OK485qOS2xoqPsV4VcHnV4mSEK74nBDoH
        zqcb3NThN5MwMblDahhO08j2qDiKMXA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-515-witzaIkJOcyklM0hiWrgrg-1; Tue, 13 Jul 2021 16:37:45 -0400
X-MC-Unique: witzaIkJOcyklM0hiWrgrg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB9D919200C0;
        Tue, 13 Jul 2021 20:37:43 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.22.8.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1CF4510016F8;
        Tue, 13 Jul 2021 20:37:43 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, pbonzini@redhat.com
Subject: [PATCH 0/2] KVM: selftests: a couple fixes
Date:   Tue, 13 Jul 2021 22:37:40 +0200
Message-Id: <20210713203742.29680-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The first removes a compiler warning. The second does what a 6 patch
patch series wanted to do, but apparently got too distracted with
the preparation refactoring to actually do...

Andrew Jones (2):
  KVM: selftests: change pthread_yield to sched_yield
  KVM: arm64: selftests: get-reg-list: actually enable pmu regs in pmu
    sublist

 tools/testing/selftests/kvm/aarch64/get-reg-list.c | 3 ++-
 tools/testing/selftests/kvm/steal_time.c           | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

-- 
2.31.1

