Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF46059931
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2019 13:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbfF1L0Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 07:26:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726524AbfF1L0Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jun 2019 07:26:25 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6011820656;
        Fri, 28 Jun 2019 11:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561721184;
        bh=q2zQxctvdSqsCTcCJRetb7GrdxiY+wY0Ao8G5ZnB5gQ=;
        h=From:To:Cc:Subject:Date:From;
        b=pXl2edsaibAum6oW7QjaGvJ2jcQcUYi5uF/JLdtQ8nz3E4DJNmh49j5mPxMWxRziD
         q4QBp+ZVk1Rj7iYY+u1r8fposNuFw7PL5HUfluoDt6fl7mcFVQMgGb749zffch33Vw
         vOfS2XkSs1QTf4LhJEQAVLzaEHiSwns9LKGbQp0Y=
From:   Will Deacon <will@kernel.org>
To:     kvm@vger.kernel.org
Cc:     marc.zyngier@arm.com, Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH kvmtool] README: Add maintainers section
Date:   Fri, 28 Jun 2019 12:26:19 +0100
Message-Id: <20190628112619.20426-1-will@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Julien has kindly offered to help maintain kvmtool, but it occurred to
me that we don't actually provide any maintainer contact details in the
repository as it stands.

Add a brief "Maintainers" section to the README, immediately after the
"Contributing" section so that people know who to nag about merging and
reviewing patches.

Cc: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 README | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/README b/README
index 52124b87a5e2..591f84f3f489 100644
--- a/README
+++ b/README
@@ -111,3 +111,9 @@ added automatically by issuing the command
  git config format.subjectprefix "PATCH kvmtool"
 
 in the git repository.
+
+Maintainers
+-----------
+
+kvmtool is maintained by Will Deacon <will@kernel.org> and Julien Thierry
+<julien.thierry@arm.com>.
-- 
2.11.0

