Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64746135C90
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 16:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732328AbgAIPWh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 10:22:37 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26348 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732329AbgAIPWg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 10:22:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578583356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r3ZQ1yjWg+zwPb7yaMBrPwZ0OBjAylTCAOCJYYSVOiU=;
        b=JWQnO/GEwQeki6hg2zkpXnaujQ0dXboDGQo1kMb/4JglOY5F43Zo5qVco1Q3Nar6dX23Ea
        kpV0TAsD4yj7NWVh2CDJOTJ9JnEy8nEu3Ge9uTot5FR77wQ6Ge0Sk6Vb66juzX59T0wb53
        CdH/G8TEavvBzw5qIso3XD+mzYWso64=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-fDmWKW9vOzO3WF0mJrsHcQ-1; Thu, 09 Jan 2020 10:22:32 -0500
X-MC-Unique: fDmWKW9vOzO3WF0mJrsHcQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C49B9FE71;
        Thu,  9 Jan 2020 15:22:31 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-204-180.brq.redhat.com [10.40.204.180])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7805D1CB;
        Thu,  9 Jan 2020 15:22:20 +0000 (UTC)
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
Subject: [PATCH 05/15] device-hotplug: Replace current_machine by qdev_get_machine()
Date:   Thu,  9 Jan 2020 16:21:23 +0100
Message-Id: <20200109152133.23649-6-philmd@redhat.com>
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
replace MACHINE_GET_CLASS(current_machine) by
MACHINE_GET_CLASS(qdev_get_machine()).

Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
---
 device-hotplug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/device-hotplug.c b/device-hotplug.c
index f01d53774b..44d687f254 100644
--- a/device-hotplug.c
+++ b/device-hotplug.c
@@ -45,7 +45,7 @@ static DriveInfo *add_init_drive(const char *optstr)
     if (!opts)
         return NULL;
=20
-    mc =3D MACHINE_GET_CLASS(current_machine);
+    mc =3D MACHINE_GET_CLASS(qdev_get_machine());
     dinfo =3D drive_new(opts, mc->block_default_type, &err);
     if (err) {
         error_report_err(err);
--=20
2.21.1

