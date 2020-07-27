Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEE3A22ED9E
	for <lists+kvm@lfdr.de>; Mon, 27 Jul 2020 15:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728169AbgG0Njl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 09:39:41 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:48766 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726620AbgG0Njl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Jul 2020 09:39:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595857180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=fYBBQADx7LsYm+yccVufp29aOZIIf/4uKblRdnXFZb8=;
        b=HvOqeCeObUBBeODUhlnbSNC4+l/fmKgBf5QDqLdtyES1tiZJnolLYHbyNWL1YlsMJWmB+H
        PP8okaXRDxVXcDP5z2uKcfnA8qdtWDPztyYskr5upqb0M34Rl2ogNLXwaAM4m9FAEMBxq6
        oAsqxK7fy9/BJ77NZQvVjspCf4wm0SM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-glqHWLosMyKK-wuLx4oP5g-1; Mon, 27 Jul 2020 09:39:38 -0400
X-MC-Unique: glqHWLosMyKK-wuLx4oP5g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2409679EC4;
        Mon, 27 Jul 2020 13:39:37 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F3FCF5D9F3;
        Mon, 27 Jul 2020 13:39:34 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, aaronlewis@google.com
Subject: [PATCH 0/3] KVM: nVMX: tighten some KVM_SET_NESTED_STATE validity checks
Date:   Mon, 27 Jul 2020 09:39:31 -0400
Message-Id: <20200727133934.25482-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patch 1 is a fix to the tests so that we can cover the new cases properly.
Patches 2-3 check for more cases of invalid nested state data.

Paolo

Paolo Bonzini (3):
  selftests: kvm: do not set guest mode flag
  KVM: nVMX: check for required but missing VMCS12 in
    KVM_SET_NESTED_STATE
  KVM: nVMX: check for invalid hdr.vmx.flags

 arch/x86/kvm/vmx/nested.c                     | 16 +++++--
 arch/x86/kvm/vmx/nested.h                     |  5 +++
 .../kvm/x86_64/vmx_set_nested_state_test.c    | 42 +++++++++++++++----
 3 files changed, 51 insertions(+), 12 deletions(-)

-- 
2.26.2

