Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B93F35E91E
	for <lists+kvm@lfdr.de>; Wed, 14 Apr 2021 00:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347514AbhDMWk0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 18:40:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50337 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347463AbhDMWkZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Apr 2021 18:40:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618353605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Se+bjf3UY2AKAwu4d1rz6KBu7BtAyVo+o4WxT9t65S8=;
        b=cIM7Dv2sMSNk9NqTrwIF0rQn47CDn8QWKQ3F4Kbf4fHlY74INEVSwK/W2V9AbvEgwamVC/
        K1xVVkBrzyFR/0c04xQ47M2XhNOpkD/bJpU8JFUsolQbkBhW+V0YmNS/w2wCuRH+68u1/8
        vPFmrJMyQh8xxetdg6F6RI/l25qibIA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-F1oR74fOP22g-Rh33WhCQg-1; Tue, 13 Apr 2021 18:40:00 -0400
X-MC-Unique: F1oR74fOP22g-Rh33WhCQg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6740107ACC7;
        Tue, 13 Apr 2021 22:39:59 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 77538614FA;
        Tue, 13 Apr 2021 22:39:59 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for 5.12-rc8 or final
Date:   Tue, 13 Apr 2021 18:39:58 -0400
Message-Id: <20210413223958.156145-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 315f02c60d9425b38eb8ad7f21b8a35e40db23f9:

  KVM: x86/mmu: preserve pending TLB flush across calls to kvm_tdp_mmu_zap_sp (2021-04-08 07:48:18 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 04c4f2ee3f68c9a4bf1653d15f1a9a435ae33f7a:

  KVM: VMX: Don't use vcpu->run->internal.ndata as an array index (2021-04-13 18:23:41 -0400)

----------------------------------------------------------------
Fix for a possible out-of-bounds access.

----------------------------------------------------------------
Reiji Watanabe (1):
      KVM: VMX: Don't use vcpu->run->internal.ndata as an array index

 arch/x86/kvm/vmx/vmx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

