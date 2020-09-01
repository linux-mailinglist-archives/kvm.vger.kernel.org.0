Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAAFE258AC6
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 10:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbgIAIvj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 04:51:39 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:55074 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727944AbgIAIvM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 04:51:12 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 755B6574E8;
        Tue,  1 Sep 2020 08:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1598950270; x=1600764671; bh=NdA+6+BccPWVUWOh/PnqUnf8ENv2nQ2zLip
        qh3CRl4U=; b=wEcmqweAhG13lNAdk5sLG6cj9SYsYgriR5o/IHN9GVp2QjB+h6I
        oMY303BKRMwPc91PJGJl7Cjajx7/fskKG2akcSiL+N7Sg2vDME6sDH1Q2AB93rgf
        ERxszDJXudviOG+SUGJvJ33K8u/W4wL+JKn3jWUzkGnQxvckHiGrd1Lg=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8wbbdDAS809w; Tue,  1 Sep 2020 11:51:10 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id C16E35141E;
        Tue,  1 Sep 2020 11:51:08 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Tue, 1 Sep
 2020 11:51:08 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <kvm@vger.kernel.org>
CC:     Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [kvm-unit-tests PATCH v2 09/10] travis.yml: Change matrix keyword to jobs
Date:   Tue, 1 Sep 2020 11:50:55 +0300
Message-ID: <20200901085056.33391-10-r.bolshakov@yadro.com>
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

jobs keyword is used throughout Travis documentation and matrix is an
alias for it (according to Travis config validation):

  root: key matrix is an alias for jobs, using jobs

At first glance it's not clear if they're the same and if jobs
documentation applies to matrix. Changing keyword name should make it
obvious.

While at it, fix the Travis config warning:

  root: deprecated key sudo (The key `sudo` has no effect anymore.)

Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 .travis.yml | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/.travis.yml b/.travis.yml
index 7bd0205..f3a8899 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -1,11 +1,10 @@
-sudo: true
 dist: bionic
 language: c
 cache: ccache
 git:
   submodules: false
 
-matrix:
+jobs:
   include:
 
     - addons:
-- 
2.28.0

