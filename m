Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7443411E7F6
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 17:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbfLMQTC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 11:19:02 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:36016 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728133AbfLMQTC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Dec 2019 11:19:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576253941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GGwuqBufIRpm7r+bogG1ik6zWSyuu3LLE1OLY6amY0k=;
        b=P7MyBPgKAUZjxvHJQE396s4OjOb6JuXXiy/zJ2zlASw+Z2BKN/ulVA7Xp5utDnzAcBLuAz
        4B7GdkYi//xEf9DqTl7SmAwKt38abOYosyzmirVeV3x1rN0TnyPtw+QjSJUuvWovk6m6hY
        HwEauLQsWrJW2lFmjP9Rn21ZELGB4v0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-tC9omY2INnyb3aoLSRkHSQ-1; Fri, 13 Dec 2019 11:18:59 -0500
X-MC-Unique: tC9omY2INnyb3aoLSRkHSQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF5A48024CF;
        Fri, 13 Dec 2019 16:18:57 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-205-147.brq.redhat.com [10.40.205.147])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 62BEC19C4F;
        Fri, 13 Dec 2019 16:18:43 +0000 (UTC)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     John Snow <jsnow@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Paul Durrant <paul@xen.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, Stefano Stabellini <sstabellini@kernel.org>,
        Igor Mammedov <imammedo@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        qemu-block@nongnu.org, Richard Henderson <rth@twiddle.net>,
        xen-devel@lists.xenproject.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sergio Lopez <slp@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH 04/12] hw/i386/pc: Remove obsolete cpu_set_smm_t typedef
Date:   Fri, 13 Dec 2019 17:17:45 +0100
Message-Id: <20191213161753.8051-5-philmd@redhat.com>
In-Reply-To: <20191213161753.8051-1-philmd@redhat.com>
References: <20191213161753.8051-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In commit f809c6051 we replaced the use of cpu_set_smm_t callbacks
by using a Notifier to modify the MemoryRegion. This prototype is
now not used anymore, we can safely remove it.

Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
---
 include/hw/i386/pc.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index bc7d855aaa..743141e107 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -212,8 +212,6 @@ void pc_cmos_init(PCMachineState *pcms,
                   ISADevice *s);
 void pc_nic_init(PCMachineClass *pcmc, ISABus *isa_bus, PCIBus *pci_bus)=
;
=20
-typedef void (*cpu_set_smm_t)(int smm, void *arg);
-
 void pc_i8259_create(ISABus *isa_bus, qemu_irq *i8259_irqs);
 void ioapic_init_gsi(GSIState *gsi_state, const char *parent_name);
=20
--=20
2.21.0

