Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B43A151651
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 08:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbgBDHN7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 02:13:59 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30977 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727237AbgBDHN6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 02:13:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580800437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=/66ISL3Mm1HtWe/pNh0zOYoz/9Pwhfw5Q6nsv8PoPy4=;
        b=Qo9asl2StJvCbrmL8uQhj5iwd0QRDVPnXKDMfbThCBgTV5DdnACywOU8lidCBbLztV1tKi
        pktH8uT2gujRvl2DRnOT7kmB0LZtnT4kNEWjKpMJ0f8h9e4mSuIZRTyYrFUt0t5SMA6mFZ
        Zt0GWRl5UPHAX8F57B8rh8Y5f65BnsU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-EoC4g_8zOua2OZPSM_BYpA-1; Tue, 04 Feb 2020 02:13:56 -0500
X-MC-Unique: EoC4g_8zOua2OZPSM_BYpA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A4D5801E6C
        for <kvm@vger.kernel.org>; Tue,  4 Feb 2020 07:13:55 +0000 (UTC)
Received: from thuth.com (ovpn-116-39.ams2.redhat.com [10.36.116.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 20B325C1D4;
        Tue,  4 Feb 2020 07:13:53 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     david@redhat.com
Subject: [kvm-unit-tests PULL 8/9] gitlab-ci.yml: Remove ioapic from the x86 tests
Date:   Tue,  4 Feb 2020 08:13:34 +0100
Message-Id: <20200204071335.18180-9-thuth@redhat.com>
In-Reply-To: <20200204071335.18180-1-thuth@redhat.com>
References: <20200204071335.18180-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The test recently started to fail (likely do to a recent change to
"x86/ioapic.c). According to Nitesh, it's not required to keep this
test running with TCG, and we already check it with KVM on Travis,
so let's simply disable it here now.

Message-Id: <20191205151610.19299-1-thuth@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .gitlab-ci.yml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index cf3264d..3093239 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -64,7 +64,7 @@ build-x86_64:
  - ./configure --arch=x86_64
  - make -j2
  - ACCEL=tcg ./run_tests.sh
-     ioapic-split ioapic smptest smptest3 vmexit_cpuid vmexit_mov_from_cr8
+     smptest smptest3 vmexit_cpuid vmexit_mov_from_cr8
      vmexit_mov_to_cr8 vmexit_inl_pmtimer  vmexit_ipi vmexit_ipi_halt
      vmexit_ple_round_robin vmexit_tscdeadline vmexit_tscdeadline_immed
      eventinj msr port80 setjmp syscall tsc rmap_chain umip intel_iommu
-- 
2.18.1

