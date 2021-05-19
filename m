Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4419D3889CD
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 10:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343943AbhESIxN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 04:53:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:60288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343824AbhESIxL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 04:53:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61AAE610CC;
        Wed, 19 May 2021 08:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621414311;
        bh=H2xJFaGOtqmzr2+rgfc0d9kbWgFeN1e+g9wwRpKEzOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pt+WA0+fV9R+WI3t2smfUI4i5eFl++NvT/52lMLfuC8CQSRc14L6dfXtrYz1s72Jc
         FqTusu+ZG9VaAC+0pVznHudjcyS6VIuuHzZRJFXv3O3BHZT7TpYQSJi48PutdiIEct
         XeSkNTauBx0UvChbXsAjiGQGCj1lNBMu4xCsnW/Imr9Cq+HOe2gxBZu4rda+HK5qDq
         EsVG/EVpDi8LWFEfx9RtqQUkETpCiJZBsSsW+++Vpl0o1OgZ5zF464DVWuIGdUkLHO
         if/pFsqmwElkFCrMxVdvyKNNXJJGT7OFTe1236OMcB3ZTw6gSPljsuq/PUgNimAy5G
         kzOeHLhvi0amw==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1ljHvh-007gY2-CM; Wed, 19 May 2021 10:51:49 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/10] docs: vcpu-requests.rst: fix reference for atomic ops
Date:   Wed, 19 May 2021 10:51:39 +0200
Message-Id: <703af756ac26a06c2185c05dfe6d902253f11161.1621413933.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621413933.git.mchehab+huawei@kernel.org>
References: <cover.1621413933.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changeset f0400a77ebdc ("atomic: Delete obsolete documentation")
got rid of atomic_ops.rst, pointing that this was superseded by
Documentation/atomic_*.txt.

Update its reference accordingly.

Fixes: f0400a77ebdc ("atomic: Delete obsolete documentation")
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/virt/kvm/vcpu-requests.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/vcpu-requests.rst b/Documentation/virt/kvm/vcpu-requests.rst
index 5feb3706a7ae..5f8798e7fdf8 100644
--- a/Documentation/virt/kvm/vcpu-requests.rst
+++ b/Documentation/virt/kvm/vcpu-requests.rst
@@ -302,6 +302,6 @@ VCPU returns from the call.
 References
 ==========
 
-.. [atomic-ops] Documentation/core-api/atomic_ops.rst
+.. [atomic-ops] Documentation/atomic_bitops.txt and Documentation/atomic_t.txt
 .. [memory-barriers] Documentation/memory-barriers.txt
 .. [lwn-mb] https://lwn.net/Articles/573436/
-- 
2.31.1

