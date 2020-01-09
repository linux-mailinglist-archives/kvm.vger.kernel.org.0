Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEE1B135C94
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 16:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732341AbgAIPXE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 10:23:04 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49498 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732321AbgAIPXE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 10:23:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578583383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hzr8Edx5jAryfh/huxiAkUz4zCXuFwzT7om8QEdCtyk=;
        b=C+6R538tDUSlBZEE7nrT6P9s3jlyEutfO1g38dDT/PTqgTKT+y6wWQG51jRT2ucriHHgww
        3KZBVI3WjSYswOTiulbnn5gvKBihqRVDmgls9ZNti2MJHV0MYTcsjoIv94HiwKaFgUs+JM
        Wd8jqtzLX3OjySffPMp8T1VjP5jckcw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-_7PA0sDLPwqBnL2Z-1DRkA-1; Thu, 09 Jan 2020 10:22:59 -0500
X-MC-Unique: _7PA0sDLPwqBnL2Z-1DRkA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 18ED985EE6A;
        Thu,  9 Jan 2020 15:22:58 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-204-180.brq.redhat.com [10.40.204.180])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1FD0280608;
        Thu,  9 Jan 2020 15:22:52 +0000 (UTC)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
        Eduardo Habkost <ehabkost@redhat.com>,
        Juan Quintela <quintela@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        qemu-ppc@nongnu.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH 09/15] device_tree: Replace current_machine by qdev_get_machine()
Date:   Thu,  9 Jan 2020 16:21:27 +0100
Message-Id: <20200109152133.23649-10-philmd@redhat.com>
In-Reply-To: <20200109152133.23649-1-philmd@redhat.com>
References: <20200109152133.23649-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As we want to remove the global current_machine,
replace 'current_machine' by MACHINE(qdev_get_machine()).

Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
---
 device_tree.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/device_tree.c b/device_tree.c
index f8b46b3c73..665ea2f586 100644
--- a/device_tree.c
+++ b/device_tree.c
@@ -466,7 +466,9 @@ uint32_t qemu_fdt_alloc_phandle(void *fdt)
      * which phandle id to start allocating phandles.
      */
     if (!phandle) {
-        phandle =3D machine_phandle_start(current_machine);
+        MachineState *ms =3D MACHINE(qdev_get_machine());
+
+        phandle =3D machine_phandle_start(ms);
     }
=20
     if (!phandle) {
--=20
2.21.1

