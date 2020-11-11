Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67EC62AF098
	for <lists+kvm@lfdr.de>; Wed, 11 Nov 2020 13:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726544AbgKKM1r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 07:27:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60233 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726605AbgKKM1O (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Nov 2020 07:27:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605097634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Oblfe4GtT7xohx7ugXEwQOWXEtfXL0rXjo04N8fIbPw=;
        b=YJeqPkt3NW60e1X+VHLW0O/sEOGbzoggplOt1K9yb2+P5tpkASikC8HWddZUeZirH5CTkd
        BAAocgzirIxNB+G84ixAIQqW5wh4cX+Rq0x/A+cnWyrQWsRQWdBuqJ2NHn1Hsq+vaf7bcw
        xYdCGMfel5hsXhx5GNP3MXRbyyohxOE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-542-S6hXYnbPPM6lMCp3eghgKg-1; Wed, 11 Nov 2020 07:27:11 -0500
X-MC-Unique: S6hXYnbPPM6lMCp3eghgKg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 170A8805F10;
        Wed, 11 Nov 2020 12:27:10 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.216])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 37C9910013BD;
        Wed, 11 Nov 2020 12:27:08 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        bgardon@google.com, peterx@redhat.com
Subject: [PATCH v2 09/11] KVM: selftests: Also build dirty_log_perf_test on AArch64
Date:   Wed, 11 Nov 2020 13:26:34 +0100
Message-Id: <20201111122636.73346-10-drjones@redhat.com>
In-Reply-To: <20201111122636.73346-1-drjones@redhat.com>
References: <20201111122636.73346-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 120b02bf3f1e..74e99a2b1b49 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -70,6 +70,7 @@ TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list-sve
 TEST_GEN_PROGS_aarch64 += demand_paging_test
 TEST_GEN_PROGS_aarch64 += dirty_log_test
+TEST_GEN_PROGS_aarch64 += dirty_log_perf_test
 TEST_GEN_PROGS_aarch64 += kvm_create_max_vcpus
 TEST_GEN_PROGS_aarch64 += set_memory_region_test
 TEST_GEN_PROGS_aarch64 += steal_time
-- 
2.26.2

