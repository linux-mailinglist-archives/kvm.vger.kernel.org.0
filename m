Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE543582EE
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 14:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbhDHMMv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 08:12:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57758 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229741AbhDHMMu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Apr 2021 08:12:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617883959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Xu44vmvXtcO0C+M0wE7HV+vWKAd+2q5v3EmKc9PruFU=;
        b=R4puSq5z39PnLAYbYcr45IIrGzxdRImjesL4AlzwDx6gBuBZBWuZzwqg5whKZOJNy3PxRM
        wBSXo1GalaY7WYyXV79pqd6Y+DJrT5MoODBuSEWEJY6D2cGCKw4zwnPZ2xoQJrlYjmTYLo
        h/oTAmgsW8dtyw7v0OKBlfBexggu9JI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-cOT3QhC2NvOluW83TzJeYg-1; Thu, 08 Apr 2021 08:12:37 -0400
X-MC-Unique: cOT3QhC2NvOluW83TzJeYg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 998B8107ACC7;
        Thu,  8 Apr 2021 12:12:36 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 469E910013C1;
        Thu,  8 Apr 2021 12:12:36 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for 5.12-rc7
Date:   Thu,  8 Apr 2021 08:12:34 -0400
Message-Id: <20210408121234.3895999-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 55626ca9c6909d077eca71bccbe15fef6e5ad917:

  selftests: kvm: Check that TSC page value is small after KVM_SET_CLOCK(0) (2021-04-01 05:14:19 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 315f02c60d9425b38eb8ad7f21b8a35e40db23f9:

  KVM: x86/mmu: preserve pending TLB flush across calls to kvm_tdp_mmu_zap_sp (2021-04-08 07:48:18 -0400)

----------------------------------------------------------------
A lone x86 patch, for a bug found while developing a backport to
stable versions.

----------------------------------------------------------------
Paolo Bonzini (1):
      KVM: x86/mmu: preserve pending TLB flush across calls to kvm_tdp_mmu_zap_sp

 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

