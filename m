Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF4611E7FB
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 17:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbfLMQTL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 11:19:11 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47707 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728133AbfLMQTL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 11:19:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576253950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MoaYblDuqaOu06Ol7lC33g4xxfLM5QgSZVl86kdLlTs=;
        b=jOL+8O01ioOVAn+nJqsnlB8CnD136wRL03MH+F/KmE2PsPlYwIMMgFK2FLanYKMIZPXT0M
        41uOE/1jswil5VlJRxP5kDIkgKtpNEorZjoXy3etMA0VGMNVWlGS48vQYx582Y/NDOgdMf
        kOg3Un4hsvyPFTIBgRcrHwU9ZKeiyro=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-7VHFUSGePyuNHDhuMawR8g-1; Fri, 13 Dec 2019 11:19:08 -0500
X-MC-Unique: 7VHFUSGePyuNHDhuMawR8g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E2D1A801E70;
        Fri, 13 Dec 2019 16:19:06 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-205-147.brq.redhat.com [10.40.205.147])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E7D019C4F;
        Fri, 13 Dec 2019 16:18:57 +0000 (UTC)
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
Subject: [PATCH 05/12] hw/i386/ich9: Remove unused include
Date:   Fri, 13 Dec 2019 17:17:46 +0100
Message-Id: <20191213161753.8051-6-philmd@redhat.com>
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

The "pcie_host.h" header is used by devices providing a PCI-e bus,
usually North Bridges. The ICH9 is a South Bridge.
Since we don't need this header, do not include it.

Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
---
 include/hw/i386/ich9.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/hw/i386/ich9.h b/include/hw/i386/ich9.h
index 72e803f6e2..eeb79ac1fe 100644
--- a/include/hw/i386/ich9.h
+++ b/include/hw/i386/ich9.h
@@ -7,7 +7,6 @@
 #include "hw/isa/apm.h"
 #include "hw/i386/ioapic.h"
 #include "hw/pci/pci.h"
-#include "hw/pci/pcie_host.h"
 #include "hw/pci/pci_bridge.h"
 #include "hw/acpi/acpi.h"
 #include "hw/acpi/ich9.h"
--=20
2.21.0

