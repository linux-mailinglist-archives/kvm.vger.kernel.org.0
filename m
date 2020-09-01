Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 478AC258AC5
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 10:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbgIAIvc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 04:51:32 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:55068 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727997AbgIAIvR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 04:51:17 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 240BB5141E;
        Tue,  1 Sep 2020 08:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1598950270; x=1600764671; bh=HR6hkEJLE+0SqABXBGpMRYsT1wpbx2+YucN
        gAQUSKuY=; b=iPtMphLZRz75d7yXKAFShfT1WSAOfa5JMCwrZ8sZcxQzoB4arNC
        RZCy0Zkncqdo9JePUBkaSdeFKOAKE7dJX4uEt7sLpfpmeTlfguMd3r6YNghVO2xD
        aWAr5bWm+XNd2Bl9OQxx+DjGDX4a4bNii7hwZKHFjT+KfaJ3nl+383rM=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id sEjx-AmobgVR; Tue,  1 Sep 2020 11:51:10 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 5740F574FB;
        Tue,  1 Sep 2020 11:51:09 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Tue, 1 Sep
 2020 11:51:09 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <kvm@vger.kernel.org>
CC:     Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [kvm-unit-tests PATCH v2 10/10] travis.yml: Add x86 build with clang 10
Date:   Tue, 1 Sep 2020 11:50:56 +0300
Message-ID: <20200901085056.33391-11-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901085056.33391-1-r.bolshakov@yadro.com>
References: <20200901085056.33391-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

.gitlab-ci.yml already has a job to build the tests with clang but it's
not clear how to set it up on a personal github repo.

NB, realmode test is disabled because it fails immediately after start
if compiled with clang-10.

Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 .travis.yml | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/.travis.yml b/.travis.yml
index f3a8899..ae4ed08 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -17,6 +17,16 @@ jobs:
                kvmclock_test msr pcid rdpru realmode rmap_chain s3 setjmp umip"
       - ACCEL="kvm"
 
+    - addons:
+        apt_packages: clang-10 qemu-system-x86
+      env:
+      - CONFIG="--cc=clang-10"
+      - BUILD_DIR="."
+      - TESTS="access asyncpf debug emulator ept hypercall hyperv_stimer
+               hyperv_synic idt_test intel_iommu ioapic ioapic-split
+               kvmclock_test msr pcid rdpru rmap_chain s3 setjmp umip"
+      - ACCEL="kvm"
+
     - addons:
         apt_packages: gcc qemu-system-x86
       env:
-- 
2.28.0

