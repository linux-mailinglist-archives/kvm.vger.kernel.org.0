Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 811D11F17C7
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 13:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729706AbgFHLYB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 07:24:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20779 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729565AbgFHLYA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 07:24:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591615439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zpkcgamnoQZWwxd6fU5WrGz2mHKzjvnnrxEBUwMVz5w=;
        b=aGd3ubY7Ag39eRW0mFbwYGa7rxYcODMHssippt/bp5fJ7DCsScwItsuTP8rmiqGlKohQpU
        O960DIRs9cVPYof5P+3w0o8ZNN/YxIkAAERAPbKcaUFgA8E+4tm+A5MXNKMynxDRT1YhaI
        tieRQw2FFEThM5+5RDbIh9i7+7pVrrM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-474-3wVxRvGdORmKEV7ifNC61Q-1; Mon, 08 Jun 2020 07:23:58 -0400
X-MC-Unique: 3wVxRvGdORmKEV7ifNC61Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CFE56107ACF2;
        Mon,  8 Jun 2020 11:23:56 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.132])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF5335D9E4;
        Mon,  8 Jun 2020 11:23:47 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Bandeira Condotta <mcondotta@redhat.com>,
        Makarand Sonare <makarandsonare@google.com>,
        Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: selftests: Add x86_64/debug_regs to .gitignore
Date:   Mon,  8 Jun 2020 13:23:45 +0200
Message-Id: <20200608112346.593513-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add x86_64/debug_regs to .gitignore.

Reported-by: Marcelo Bandeira Condotta <mcondotta@redhat.com>
Fixes: 449aa906e67e ("KVM: selftests: Add KVM_SET_GUEST_DEBUG test")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index f159718f90c0..452787152748 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -3,6 +3,7 @@
 /s390x/resets
 /s390x/sync_regs_test
 /x86_64/cr4_cpuid_sync_test
+/x86_64/debug_regs
 /x86_64/evmcs_test
 /x86_64/hyperv_cpuid
 /x86_64/mmio_warning_test
-- 
2.25.4

