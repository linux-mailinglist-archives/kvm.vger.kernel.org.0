Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD0C3ED85C
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 16:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbhHPOBH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 10:01:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41685 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231598AbhHPN7y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Aug 2021 09:59:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629122345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=jXR5RiDVEchO7MOkXoUsCoNxgYOwO5p/5FxTFExwIx0=;
        b=Vm1EC8LZ4hrU1xMMVFQKFcrSOCoK+jOLi0SQ9M1ocVei56D4ECOAsBmhK2sGb0m74KtDnO
        g67BvKJAjhfSPMvHighAeQYtXQQkrPlALLIT9Zk8l2amI87KpWDhUzaqZjJpXOoEjG75Zp
        li0G0wJy5hT+unPj9pwif7IgkrKWQWA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-589-rSANSKymOYi-0VXFrUXFmw-1; Mon, 16 Aug 2021 09:59:04 -0400
X-MC-Unique: rSANSKymOYi-0VXFrUXFmw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE21F100A608;
        Mon, 16 Aug 2021 13:59:02 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D71460C81;
        Mon, 16 Aug 2021 13:59:02 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 5.14-rc7
Date:   Mon, 16 Aug 2021 09:59:01 -0400
Message-Id: <20210816135901.3838181-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 6e949ddb0a6337817330c897e29ca4177c646f02:

  Merge branch 'kvm-tdpmmu-fixes' into kvm-master (2021-08-13 03:33:13 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to c7dfa4009965a9b2d7b329ee970eb8da0d32f0bc:

  KVM: nSVM: always intercept VMLOAD/VMSAVE when nested (CVE-2021-3656) (2021-08-16 09:48:37 -0400)

----------------------------------------------------------------
Two nested virtualization fixes for AMD processors.

----------------------------------------------------------------
Maxim Levitsky (2):
      KVM: nSVM: avoid picking up unsupported bits from L2 in int_ctl (CVE-2021-3653)
      KVM: nSVM: always intercept VMLOAD/VMSAVE when nested (CVE-2021-3656)

 arch/x86/include/asm/svm.h |  2 ++
 arch/x86/kvm/svm/nested.c  | 13 ++++++++++---
 arch/x86/kvm/svm/svm.c     |  9 +++++----
 3 files changed, 17 insertions(+), 7 deletions(-)

