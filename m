Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 268F9240494
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 12:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbgHJKQw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 06:16:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54904 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbgHJKQv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 06:16:51 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1k54rI-0007Lc-2U; Mon, 10 Aug 2020 10:16:48 +0000
From:   Colin King <colin.king@canonical.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] kvm: selftests: fix spelling mistake: "missmatch" -> "missmatch"
Date:   Mon, 10 Aug 2020 11:16:47 +0100
Message-Id: <20200810101647.62039-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in an error message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 tools/testing/selftests/kvm/lib/sparsebit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/sparsebit.c b/tools/testing/selftests/kvm/lib/sparsebit.c
index 031ba3c932ed..59ffba902e61 100644
--- a/tools/testing/selftests/kvm/lib/sparsebit.c
+++ b/tools/testing/selftests/kvm/lib/sparsebit.c
@@ -1866,7 +1866,7 @@ void sparsebit_validate_internal(struct sparsebit *s)
 		 * of total bits set.
 		 */
 		if (s->num_set != total_bits_set) {
-			fprintf(stderr, "Number of bits set missmatch,\n"
+			fprintf(stderr, "Number of bits set mismatch,\n"
 				"  s->num_set: 0x%lx total_bits_set: 0x%lx",
 				s->num_set, total_bits_set);
 
-- 
2.27.0

