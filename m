Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6AA810D987
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2019 19:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbfK2SRl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Nov 2019 13:17:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47078 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727118AbfK2SRl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Nov 2019 13:17:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575051459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=0JsvcP5JjavRLN7Eg1l3dqgu/7OBAuKTZlpK2fEtMVA=;
        b=C7aewtxB3YYzazt04QJyJZwuDmDjTa5UXQZ4R83Mu9IwbFwZE/BLZtKg3ovwDfaCF7gF32
        z2ubrO2A+hQqpDvVvZg1vGIox6Dpzh/9lcN7GxvMWtFtwGtPF8izYMTVLBc8OwVSclg9qP
        1DDZdaKj0OY13qakclOMnEPZ5mC8DTw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-Vn0Ttw11NB63YmMzg0Xfcw-1; Fri, 29 Nov 2019 13:17:36 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B413118AAFA3;
        Fri, 29 Nov 2019 18:17:35 +0000 (UTC)
Received: from virtlab501.virt.lab.eng.bos.redhat.com (virtlab501.virt.lab.eng.bos.redhat.com [10.19.152.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B3D15C1BB;
        Fri, 29 Nov 2019 18:17:31 +0000 (UTC)
From:   Wainer dos Santos Moschetta <wainersm@redhat.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH] Documentation: kvm: Fix mention to number of ioctls classes
Date:   Fri, 29 Nov 2019 13:17:30 -0500
Message-Id: <20191129181730.15037-1-wainersm@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: Vn0Ttw11NB63YmMzg0Xfcw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In api.txt it is said that KVM ioctls belong to three classes
but in reality it is four. Fixed this, but do not count categories
anymore to avoid such as outdated information in the future.

Signed-off-by: Wainer dos Santos Moschetta <wainersm@redhat.com>
---
 Documentation/virt/kvm/api.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.tx=
t
index 4833904d32a5..4e3d22429b19 100644
--- a/Documentation/virt/kvm/api.txt
+++ b/Documentation/virt/kvm/api.txt
@@ -5,7 +5,7 @@ The Definitive KVM (Kernel-based Virtual Machine) API Docum=
entation
 ----------------------
=20
 The kvm API is a set of ioctls that are issued to control various aspects
-of a virtual machine.  The ioctls belong to three classes:
+of a virtual machine.  The ioctls belong to the following classes:
=20
  - System ioctls: These query and set global attributes which affect the
    whole kvm subsystem.  In addition a system ioctl is used to create
--=20
2.21.0

