Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28268218C8
	for <lists+kvm@lfdr.de>; Fri, 17 May 2019 15:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728820AbfEQNDN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 May 2019 09:03:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60298 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728746AbfEQNDN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 May 2019 09:03:13 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 251F830642AA;
        Fri, 17 May 2019 13:03:13 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.40.205.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 16050600C4;
        Fri, 17 May 2019 13:03:10 +0000 (UTC)
From:   Laurent Vivier <lvivier@redhat.com>
To:     =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        Laurent Vivier <lvivier@redhat.com>
Subject: [kvm-unit-tests PULL 2/2] powerpc: Make h_cede_tm test run by default
Date:   Fri, 17 May 2019 15:03:05 +0200
Message-Id: <20190517130305.32123-3-lvivier@redhat.com>
In-Reply-To: <20190517130305.32123-1-lvivier@redhat.com>
References: <20190517130305.32123-1-lvivier@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Fri, 17 May 2019 13:03:13 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Suraj Jitindar Singh <sjitindarsingh@gmail.com>

This test was initially designed to test for a known bug where
performing a sequence of H_CEDE hcalls while suspended would cause a
vcpu to lockup in the host. The fix has been available for some time
now, so to increase coverage of this test remove the no-default flag.

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Reviewed-by: Laurent Vivier <lvivier@redhat.com>
Acked-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Laurent Vivier <lvivier@redhat.com>
---
 powerpc/unittests.cfg | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/powerpc/unittests.cfg b/powerpc/unittests.cfg
index af535b7f8982..1e7494801273 100644
--- a/powerpc/unittests.cfg
+++ b/powerpc/unittests.cfg
@@ -64,7 +64,7 @@ file = emulator.elf
 file = tm.elf
 smp = 2,threads=2
 extra_params = -machine cap-htm=on -append "h_cede_tm"
-groups = nodefault,h_cede_tm
+groups = h_cede_tm
 
 [sprs]
 file = sprs.elf
-- 
2.20.1

