Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B45514B2AE
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 11:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbgA1KfY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 05:35:24 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49062 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725948AbgA1KfX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jan 2020 05:35:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580207722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g1Y7SAIkQ6YKL70iv+PevVOHVnPkk+5bW/+E3fVVoME=;
        b=bbPilG3naIr1ePcnMiUJ3aQKVM3AHb3amhlnB97UkX8XdnBPhT78yu0Mo/oQJY8n85x4Gu
        e6IL6Y0DX0+liZVzX5nsmgZ7wWvcCsbPK3zN2b9rBAa6V7759hBVInJhYge5pK3eH3qwxW
        bFTAacgfLNdbRAZIbKrb8FcAkxxhx8A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-60MnbJ6RNh6DWtQjzWJD4g-1; Tue, 28 Jan 2020 05:35:17 -0500
X-MC-Unique: 60MnbJ6RNh6DWtQjzWJD4g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47B7B1005510;
        Tue, 28 Jan 2020 10:35:16 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-37.ams2.redhat.com [10.36.116.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E70F91001B30;
        Tue, 28 Jan 2020 10:35:10 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 01/14] libcflat: Add other size defines
Date:   Tue, 28 Jan 2020 11:34:46 +0100
Message-Id: <20200128103459.19413-2-eric.auger@redhat.com>
In-Reply-To: <20200128103459.19413-1-eric.auger@redhat.com>
References: <20200128103459.19413-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce additional SZ_256, SZ_8K, SZ_16K macros that will
be used by ITS tests.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 lib/libcflat.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/libcflat.h b/lib/libcflat.h
index ea19f61..7092af2 100644
--- a/lib/libcflat.h
+++ b/lib/libcflat.h
@@ -36,7 +36,10 @@
 #define ALIGN(x, a)		__ALIGN((x), (a))
 #define IS_ALIGNED(x, a)	(((x) & ((typeof(x))(a) - 1)) =3D=3D 0)
=20
+#define SZ_256			(1 << 8)
 #define SZ_4K			(1 << 12)
+#define SZ_8K			(1 << 13)
+#define SZ_16K			(1 << 14)
 #define SZ_64K			(1 << 16)
 #define SZ_2M			(1 << 21)
 #define SZ_1G			(1 << 30)
--=20
2.20.1

