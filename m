Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9338035666E
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 10:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237082AbhDGIVX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 04:21:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240361AbhDGIVQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 04:21:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA0A8613E5;
        Wed,  7 Apr 2021 08:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617783662;
        bh=01jspTSWm7bLXEJy5cH57gxxdERvRXGSivEgicYhRac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jXzc1b5Agkr/7HQxKILvoj1ZXg4WQ4JoGIL8aHE3xU+wUrgoH2CaqRIi8BsJ3m8/q
         L9TEVVmpKxnFQdouRV6ucHeyJyi4kkv0SH+DH4ECIEmLKIm2dnShkYx4yaMBZ5fXf2
         +ybd+3fl7i3eA3+pZ4RMV1zsKQc7CiGEPAPVN2Q6b+3WNwMD+dfH25DWa8cM3JBwON
         d0WPPrljMfeeD1IZiMHAVmE9Jh5ljNJZm0fomiA3mxlnpqgUcQOe6wFL/J9mIljX1Y
         BO38nXrNBFFs2UV6yByRTjRNQlG5Oz6xmv8FsLUAKPyum8RJvHWbL94HVTiM4jg/ud
         eApwM31XX4zBw==
Received: by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1lU3Qq-005i2i-Rj; Wed, 07 Apr 2021 10:21:00 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 16/19] docs: vcpu-requests.rst: fix reference for atomic ops
Date:   Wed,  7 Apr 2021 10:20:55 +0200
Message-Id: <d6980818e862c08d13747b87054d92ab2b891112.1617783062.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1617783062.git.mchehab+huawei@kernel.org>
References: <cover.1617783062.git.mchehab+huawei@kernel.org>
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
2.30.2

