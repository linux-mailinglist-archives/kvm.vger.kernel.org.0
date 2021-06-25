Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88B303B4609
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 16:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbhFYOtz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 10:49:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57832 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229653AbhFYOtz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Jun 2021 10:49:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624632454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=HetBqryaCtuqSOesjWS+ekhM/U9bvM+uJkprgmLod24=;
        b=M9crMfgjbo+SNNMakY57W5y7E3Jks0jyYNHCGnyYr8iK78LIEvOicfTnSDXFgXVXIor+h0
        uaXiI6wRt9fLRp/rpdY8fPerw6VxDz0PmZFlx8Ib93Ux5e9LF5IsBGbUzlGi+iNVbj/SeY
        QV9tKhWKH2X6yY+tSzk/Hp1yCQEa5NY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-MKuWO-NCMtCw5hL63jBO9A-1; Fri, 25 Jun 2021 10:47:32 -0400
X-MC-Unique: MKuWO-NCMtCw5hL63jBO9A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32DDB804140;
        Fri, 25 Jun 2021 14:47:31 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D407E5D6A8;
        Fri, 25 Jun 2021 14:47:30 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] Final batch of KVM changes for Linux 5.13
Date:   Fri, 25 Jun 2021 10:47:30 -0400
Message-Id: <20210625144730.32703-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 13311e74253fe64329390df80bed3f07314ddd61:

  Linux 5.13-rc7 (2021-06-20 15:03:15 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus-urgent

for you to fetch changes up to f8be156be163a052a067306417cd0ff679068c97:

  KVM: do not allow mapping valid but non-reference-counted pages (2021-06-24 11:55:11 -0400)

----------------------------------------------------------------
A selftests fix for ARM, and the fix for page reference count underflow.
This is a very small fix that was provided by Nick Piggin and tested
by myself.

----------------------------------------------------------------
Nicholas Piggin (1):
      KVM: do not allow mapping valid but non-reference-counted pages

Zenghui Yu (1):
      KVM: selftests: Fix mapping length truncation in m{,un}map()

 tools/testing/selftests/kvm/set_memory_region_test.c |  4 ++--
 virt/kvm/kvm_main.c                                  | 19 +++++++++++++++++--
 2 files changed, 19 insertions(+), 4 deletions(-)

