Return-Path: <kvm+bounces-18154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C1328CF90B
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 08:28:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9DEC71C20BEE
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 06:28:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA8F514A90;
	Mon, 27 May 2024 06:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=t-8ch.de header.i=@t-8ch.de header.b="i9NB8nFG"
X-Original-To: kvm@vger.kernel.org
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD96017BA7
	for <kvm@vger.kernel.org>; Mon, 27 May 2024 06:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.126.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716791288; cv=none; b=uIX1+WuPMfOBTkGoCm2LNmI1Zyg+9NfYFPaIbyDPkL39i5X6SiwbWC0rC37nI1Mg4x9g7S1rLibyE7TSSPzr+4g8uu+qLTJasnnSiq1N5yPrFH9+OMLu8RpKcPsXJJly6RHuJLgxxyz2gRQ7Ud/ImlvfN+n4PSoaqa1yAJqJGRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716791288; c=relaxed/simple;
	bh=LCuCBVisjMtTqjVLtKRdy56NTXB6OpLxRb1j5TqsU20=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=teQGxZJrv1vFocQ857sRlvGwUwLYIP3JHIqRlQZ36ljTmC6Gixuc52ypa581rz+JoW9Rn+f1tQ4T4gnVHrVoaQH/DOGqO+cXHy+PZDrt1xz8N2FAunOsahnOqOIJnabt7MKFlFlJ1MlJgfN1Q1HG5/bJWbatfdavZjs7ozkxIYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=t-8ch.de; spf=pass smtp.mailfrom=t-8ch.de; dkim=pass (1024-bit key) header.d=t-8ch.de header.i=@t-8ch.de header.b=i9NB8nFG; arc=none smtp.client-ip=159.69.126.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=t-8ch.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=t-8ch.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=t-8ch.de; s=mail;
	t=1716791283; bh=LCuCBVisjMtTqjVLtKRdy56NTXB6OpLxRb1j5TqsU20=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=i9NB8nFGvu1t/qj8cfAPCP8jwNU8ud1dgFfZn9VKFRDlfzeH52KXVLad9bQyLMRPy
	 4CS9ju7MtJotEXfHVMoPznDXzES3ooVJG64EqpR3Clv+efnp1iEdNoFoG9U6JzCe0X
	 Sv1G0JWvBkhxjmgtz+1+wyyXxKQR+CtwNq1dwrys=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas@t-8ch.de>
Date: Mon, 27 May 2024 08:27:47 +0200
Subject: [PATCH v8 1/8] scripts/update-linux-headers: Copy setup_data.h to
 correct directory
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20240527-pvpanic-shutdown-v8-1-5a28ec02558b@t-8ch.de>
References: <20240527-pvpanic-shutdown-v8-0-5a28ec02558b@t-8ch.de>
In-Reply-To: <20240527-pvpanic-shutdown-v8-0-5a28ec02558b@t-8ch.de>
To: "Michael S. Tsirkin" <mst@redhat.com>, 
 Cornelia Huck <cohuck@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>
Cc: qemu-devel@nongnu.org, 
 Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, kvm@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas@t-8ch.de>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1716791282; l=1024;
 i=thomas@t-8ch.de; s=20221212; h=from:subject:message-id;
 bh=LCuCBVisjMtTqjVLtKRdy56NTXB6OpLxRb1j5TqsU20=;
 b=OdQl15KmpX81cnFP+IPHUwVyZuZHQE1/NtJO8jL8BTFnRZoDIM3i2DylGf/OEEFsnFYesCpcJ
 QyGS3cml51DDatO+XB9V5yHzBrbhnhDsxvmzjb3OWX55152ByYIDeui
X-Developer-Key: i=thomas@t-8ch.de; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=

Add the missing "include/" path component, so the files ends up in the
correct place like the other headers.

Fixes: 66210a1a30f2 ("scripts/update-linux-headers: Add setup_data.h to import list")
Signed-off-by: Thomas Weißschuh <thomas@t-8ch.de>
---
 scripts/update-linux-headers.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/update-linux-headers.sh b/scripts/update-linux-headers.sh
index 8963c391895f..a148793bd569 100755
--- a/scripts/update-linux-headers.sh
+++ b/scripts/update-linux-headers.sh
@@ -158,7 +158,7 @@ for arch in $ARCHLIST; do
         cp_portable "$hdrdir/bootparam.h" \
                     "$output/include/standard-headers/asm-$arch"
         cp_portable "$hdrdir/include/asm/setup_data.h" \
-                    "$output/standard-headers/asm-x86"
+                    "$output/include/standard-headers/asm-x86"
     fi
     if [ $arch = riscv ]; then
         cp "$hdrdir/include/asm/ptrace.h" "$output/linux-headers/asm-riscv/"

-- 
2.45.1


