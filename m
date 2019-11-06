Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA000F1646
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 13:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730622AbfKFMrc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 07:47:32 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:21977 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730392AbfKFMrc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Nov 2019 07:47:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573044451;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2/QDEapR+pQoQB46goTREYq60QE/KAIKC9jcYxuCF9M=;
        b=VkkIKRl/xKvgfnhWb6KzsWhM6YVadIEaKUxe2hBz4AGNnet2/a2t/bY35folWe0AttZdyE
        ME4om8cVb0hmLRWVfMcFrnIDzqtgY/NEPYuLnLkVCVD7N4t3TycLkkokHCBzwlvPdgskAf
        QOKhpLvDwreFZk3KDLlK29sWn2vyFRc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-6epujcizPnyPP0ZuD06fpw-1; Wed, 06 Nov 2019 07:47:30 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 463DC477
        for <kvm@vger.kernel.org>; Wed,  6 Nov 2019 12:47:29 +0000 (UTC)
Received: from virtlab512.virt.lab.eng.bos.redhat.com (virtlab512.virt.lab.eng.bos.redhat.com [10.19.152.206])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8E5F36056B;
        Wed,  6 Nov 2019 12:47:24 +0000 (UTC)
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, thuth@redhat.com,
        mtosatti@redhat.com
Subject: [kvm-unit-tests Patch v1 1/2] x86: ioapic: Add the smp configuration to ioapic unittest
Date:   Wed,  6 Nov 2019 07:47:08 -0500
Message-Id: <1573044429-7390-2-git-send-email-nitesh@redhat.com>
In-Reply-To: <1573044429-7390-1-git-send-email-nitesh@redhat.com>
References: <1573044429-7390-1-git-send-email-nitesh@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: 6epujcizPnyPP0ZuD06fpw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adds -smp configuration for ioapic unittest. This is essentially
required to test IOAPIC Logical destination mode, where we send
an interrupt to more than one vcpus at the same time.

Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
---
 x86/unittests.cfg | 1 +
 1 file changed, 1 insertion(+)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 5ecb9bb..6ed0b86 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -45,6 +45,7 @@ timeout =3D 30
=20
 [ioapic]
 file =3D ioapic.flat
+smp =3D 4
 extra_params =3D -cpu qemu64
 arch =3D x86_64
=20
--=20
1.8.3.1

