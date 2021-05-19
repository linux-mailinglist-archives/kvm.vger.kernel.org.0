Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAAF3889C1
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 10:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343879AbhESIxM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 04:53:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:60218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238621AbhESIxK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 04:53:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57A7E61059;
        Wed, 19 May 2021 08:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621414311;
        bh=y1shfZpMexqe3QXr2DMzM1tm/zaqMgMobTVuM8HdP+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e8NjRFW1GxfjGMMuoBoeRbGzuah0VQa7C7CH9Gx6uneyacAc3jHy8tGqnlkpykLkZ
         q62VycTGgcOmz1KT7I3YNgTTxsFZi5ARaMuSDw4pwk64UZsPOR39LQBqhPpRlnyJSh
         JAPlQaLjSdVTj7L6bKrCy4HDCsbmzj7eH0CGEmSaGsfE5giKiX80AmrlN/WQSc7qxp
         tHiN8+6HbmJW/cHOTyZ+U0phRjmb3kL1S4z3yceRABxFG6/hgSejY8zqRu51Fl0wZg
         GlIRJZo099QYd1jEvZCjIJpAtxQ6VOSmChQ8QLHyHJ+lBDQnJoJrtQTVCZsobWyDnU
         FHOyqIvHkqIHg==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1ljHvh-007gYI-JA; Wed, 19 May 2021 10:51:49 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/10] docs: virt: api.rst: fix a pointer to SGX documentation
Date:   Wed, 19 May 2021 10:51:43 +0200
Message-Id: <138c24633c6e4edf862a2b4d77033c603fc10406.1621413933.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621413933.git.mchehab+huawei@kernel.org>
References: <cover.1621413933.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The document which describes the SGX kernel architecture was added at
commit 3fa97bf00126 ("Documentation/x86: Document SGX kernel architecture")

but the reference at virt/kvm/api.rst is pointing to some
non-existing document.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/virt/kvm/api.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 22d077562149..e86fe3481574 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6360,7 +6360,7 @@ system fingerprint.  To prevent userspace from circumventing such restrictions
 by running an enclave in a VM, KVM prevents access to privileged attributes by
 default.
 
-See Documentation/x86/sgx/2.Kernel-internals.rst for more details.
+See Documentation/x86/sgx.rst for more details.
 
 8. Other capabilities.
 ======================
-- 
2.31.1

