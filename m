Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F7428E71D
	for <lists+kvm@lfdr.de>; Wed, 14 Oct 2020 21:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390497AbgJNTO5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Oct 2020 15:14:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51509 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390300AbgJNTOz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Oct 2020 15:14:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602702894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TvvMY0SHyLOgnDBHHzi/tUS8kMAlHmURdx5kCxA8Q0k=;
        b=i59/01ve0GMLkeLM1Mx24oVxZNlMI3ZbWKt1qeUWyQWwOfTwo0H6rny7lR/gWloXfnty83
        ube4iW6qLL2N9vLYY3N2Zo8kB/bLiML6sPShuroiCmJm3Yfh6ZTTur11vPV7HCfMGWt+yf
        Vag5mpMDQbgkS02E4y4KjLHxGq731r0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-80-lysSSOZ_N9y3rzyMUDJYXw-1; Wed, 14 Oct 2020 15:14:52 -0400
X-MC-Unique: lysSSOZ_N9y3rzyMUDJYXw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A50501018F77
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 19:14:51 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.195.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6856F5577C;
        Wed, 14 Oct 2020 19:14:50 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, thuth@redhat.com
Subject: [PATCH kvm-unit-tests 3/3] arm/arm64: Change dcache_line_size to ulong
Date:   Wed, 14 Oct 2020 21:14:44 +0200
Message-Id: <20201014191444.136782-4-drjones@redhat.com>
In-Reply-To: <20201014191444.136782-1-drjones@redhat.com>
References: <20201014191444.136782-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

dcache_line_size is treated like a long in assembly, so make it one.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/arm/asm/processor.h   | 2 +-
 lib/arm/setup.c           | 2 +-
 lib/arm64/asm/processor.h | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/arm/asm/processor.h b/lib/arm/asm/processor.h
index e26ef89000a8..273366d1fe1c 100644
--- a/lib/arm/asm/processor.h
+++ b/lib/arm/asm/processor.h
@@ -89,6 +89,6 @@ static inline u32 get_ctr(void)
 	return read_sysreg(CTR);
 }
 
-extern u32 dcache_line_size;
+extern unsigned long dcache_line_size;
 
 #endif /* _ASMARM_PROCESSOR_H_ */
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 78562e47c01c..ea714d064afa 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -42,7 +42,7 @@ static struct mem_region __initial_mem_regions[NR_INITIAL_MEM_REGIONS + 1];
 struct mem_region *mem_regions = __initial_mem_regions;
 phys_addr_t __phys_offset, __phys_end;
 
-u32 dcache_line_size;
+unsigned long dcache_line_size;
 
 int mpidr_to_cpu(uint64_t mpidr)
 {
diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index 02665b84cc7e..6ee7c1260b6b 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -115,7 +115,7 @@ static inline u64 get_ctr(void)
 	return read_sysreg(ctr_el0);
 }
 
-extern u32 dcache_line_size;
+extern unsigned long dcache_line_size;
 
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASMARM64_PROCESSOR_H_ */
-- 
2.26.2

