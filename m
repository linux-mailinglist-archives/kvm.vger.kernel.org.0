Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 472FF11E7F3
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 17:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbfLMQSr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 11:18:47 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47128 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728057AbfLMQSr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 11:18:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576253926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YVWQa/Zo1x2m8LGgxk7TW+9fJim2zfZM8M5wdoCqM3g=;
        b=DzbLDecS98DTMSni0Va706qkqnXVDTEt0fyNdxJdUUTZw0e1XAyipwdI9DdldG6w/dQt92
        3N4YsxIh4RTL8oaLlYfhDUAxrsQEr4RAVVUczuMVwF39UFy97memvn7/4e7QdYPPaz9akM
        srPp26IV5SSylzKBru/+xLKmQ9+xZdE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-eDjHLZxKONO5C1zmGmqY7Q-1; Fri, 13 Dec 2019 11:18:45 -0500
X-MC-Unique: eDjHLZxKONO5C1zmGmqY7Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EBEE2800D41;
        Fri, 13 Dec 2019 16:18:42 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-205-147.brq.redhat.com [10.40.205.147])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 57CD819C4F;
        Fri, 13 Dec 2019 16:18:35 +0000 (UTC)
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
Subject: [PATCH 03/12] hw/i386/pc: Remove obsolete pc_pci_device_init() declaration
Date:   Fri, 13 Dec 2019 17:17:44 +0100
Message-Id: <20191213161753.8051-4-philmd@redhat.com>
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

In commit 1454509726 we removed the pc_pci_device_init()
deprecated function and its calls, but we forgot to remove
its prototype. Do that now.

Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
---
 include/hw/i386/pc.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index 9866dfbd60..bc7d855aaa 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -211,7 +211,6 @@ void pc_cmos_init(PCMachineState *pcms,
                   BusState *ide0, BusState *ide1,
                   ISADevice *s);
 void pc_nic_init(PCMachineClass *pcmc, ISABus *isa_bus, PCIBus *pci_bus)=
;
-void pc_pci_device_init(PCIBus *pci_bus);
=20
 typedef void (*cpu_set_smm_t)(int smm, void *arg);
=20
--=20
2.21.0

