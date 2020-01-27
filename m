Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94A5E14AB08
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 21:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgA0UMr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jan 2020 15:12:47 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41601 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725975AbgA0UMr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jan 2020 15:12:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580155966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4ImoCkA2rMAj5OwG4X8CC6lkF8ZqmZqxCa+9EPE6Pdk=;
        b=bsmu97AGWNgo7WXgDMP8NKYXi78JwdQBUKa6eKUeQ3lyuQ/WGOe4arkfEwN28/cYzwVoyE
        j8CjA/m305Ckp8VKYXa8r0AO2Ui6hPfo+qxD0uUqI2VhpRw7GzsdilKxuYiEG8F3JxwWHB
        rAcmj+JjmRdZpj7hcTPAOv2665r8RqU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-85-Mciqd0yTPUC6CeSuJwxu6Q-1; Mon, 27 Jan 2020 15:12:43 -0500
X-MC-Unique: Mciqd0yTPUC6CeSuJwxu6Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D7107800D48
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2020 20:12:42 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-27.gru2.redhat.com [10.97.116.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EED5F8DC35;
        Mon, 27 Jan 2020 20:12:41 +0000 (UTC)
From:   Wainer dos Santos Moschetta <wainersm@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [kvm-unit-tests] x86: Group APIC tests
Date:   Mon, 27 Jan 2020 17:12:40 -0300
Message-Id: <20200127201240.6429-1-wainersm@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This creates the 'apic' group in x86/unittests.cfg to allow
the execution of all APIC tests (including IO-APIC) together.

Signed-off-by: Wainer dos Santos Moschetta <wainersm@redhat.com>
---
 x86/unittests.cfg | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index aae1523..54c9fbf 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -30,11 +30,13 @@ file =3D apic.flat
 smp =3D 2
 extra_params =3D -cpu qemu64,+x2apic,+tsc-deadline -machine kernel_irqch=
ip=3Dsplit
 arch =3D x86_64
+groups =3D apic
=20
 [ioapic-split]
 file =3D ioapic.flat
 extra_params =3D -cpu qemu64 -machine kernel_irqchip=3Dsplit
 arch =3D x86_64
+groups =3D apic
=20
 [apic]
 file =3D apic.flat
@@ -42,12 +44,14 @@ smp =3D 2
 extra_params =3D -cpu qemu64,+x2apic,+tsc-deadline
 arch =3D x86_64
 timeout =3D 30
+groups =3D apic
=20
 [ioapic]
 file =3D ioapic.flat
 smp =3D 4
 extra_params =3D -cpu qemu64
 arch =3D x86_64
+groups =3D apic
=20
 [cmpxchg8b]
 file =3D cmpxchg8b.flat
--=20
2.23.0

