Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED1601F18EE
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 14:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbgFHMmc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 08:42:32 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:22660 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727052AbgFHMmb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Jun 2020 08:42:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591620150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=BHiSv3/XIs4p+ocNnWY97Q87sD+jZaEpUwxAP3vu2p8=;
        b=IORKHG+yEHNJ7Jlyp9R5FEGjRzChjqlnav5Cr0j2wqCiYhO5tSShZY8XaQ5TGp/czCI9k+
        6lu150s5oCVvVhi7+igUT1WI6M2PGMX7Vw7RX3qmKosTA5K2fpXC8SwxFz+UTmqtmTmboc
        iFj6NQ3YojsfFjs2T8uSmHV1iv6JIp8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-pIkcH4Q9NFW_DvQcTMdNIA-1; Mon, 08 Jun 2020 08:42:23 -0400
X-MC-Unique: pIkcH4Q9NFW_DvQcTMdNIA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5D75EC1A0
        for <kvm@vger.kernel.org>; Mon,  8 Jun 2020 12:42:22 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A2E8C5C1D6
        for <kvm@vger.kernel.org>; Mon,  8 Jun 2020 12:42:22 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests] remove unused file
Date:   Mon,  8 Jun 2020 08:42:22 -0400
Message-Id: <20200608124222.371807-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

---
 lib/x86/fake-apic.h | 14 --------------
 1 file changed, 14 deletions(-)
 delete mode 100644 lib/x86/fake-apic.h

diff --git a/lib/x86/fake-apic.h b/lib/x86/fake-apic.h
deleted file mode 100644
index eed63ba..0000000
--- a/lib/x86/fake-apic.h
+++ /dev/null
@@ -1,14 +0,0 @@
-#ifndef SILLY_APIC_H
-#define SILLY_APIC_H
-
-#define APIC_BASE 0x1000
-#define APIC_SIZE 0x100
-
-#define APIC_REG_NCPU        0x00
-#define APIC_REG_ID          0x04
-#define APIC_REG_SIPI_ADDR   0x08
-#define APIC_REG_SEND_SIPI   0x0c
-#define APIC_REG_IPI_VECTOR  0x10
-#define APIC_REG_SEND_IPI    0x14
-
-#endif
-- 
2.26.2

