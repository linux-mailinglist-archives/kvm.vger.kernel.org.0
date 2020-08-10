Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89A9E2409FC
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 17:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgHJPhh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 11:37:37 -0400
Received: from foss.arm.com ([217.140.110.172]:57618 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728036AbgHJPhf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 11:37:35 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B2FF21063;
        Mon, 10 Aug 2020 08:37:34 -0700 (PDT)
Received: from monolith.localdoman (arm6-cctv-system.cambridge.arm.com [10.37.12.8])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0A3623F575;
        Mon, 10 Aug 2020 08:37:33 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com
Subject: [PATCH kvmtool] update_headers.sh: Remove arm architecture
Date:   Mon, 10 Aug 2020 16:38:28 +0100
Message-Id: <20200810153828.216821-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM host support for the arm architecture was removed in commit
541ad0150ca4 ("arm: Remove 32bit KVM host support"). When trying to sync
KVM headers we get this error message:

$ util/update_headers.sh /path/to/linux
cp: cannot stat '/path/to/linux/arch/arm/include/uapi/asm/kvm.h': No such file or directory

Do not attempting to copy KVM headers for that architecture.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 util/update_headers.sh | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/util/update_headers.sh b/util/update_headers.sh
index bf87ef601019..049dfe4ef9d0 100755
--- a/util/update_headers.sh
+++ b/util/update_headers.sh
@@ -36,10 +36,9 @@ copy_optional_arch () {
 	fi
 }
 
-for arch in arm arm64 mips powerpc x86
+for arch in arm64 mips powerpc x86
 do
 	case "$arch" in
-		arm) KVMTOOL_PATH=arm/aarch32 ;;
 		arm64)	KVMTOOL_PATH=arm/aarch64
 			copy_optional_arch asm/sve_context.h ;;
 		*) KVMTOOL_PATH=$arch ;;
-- 
2.28.0

