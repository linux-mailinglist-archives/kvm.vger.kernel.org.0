Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC41531FE15
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 18:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbhBSRlJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 12:41:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34423 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229967AbhBSRlH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Feb 2021 12:41:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613756381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0XNpw7EsZwRfqH5jj+d5q0K26B/2H8ocJXujjf2y0q0=;
        b=RDQEjTRLZTWO2mxBVuE+CjuwWYnePnPDhe8EbBtHCO5ciJX6yb2P6dMZLwdDp105DHn+43
        Wv5sAUTAyloJyAW4gJabhwg3ByiTlGol+azzEp4iDiIbEuA8TSWDwMwzJ4m3WXVtyG3h8Q
        DTITpNp4g3ky6p7qnB3q5/xLThu8hm0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-q0Qp5HYGM2yqTLcX5CyFkw-1; Fri, 19 Feb 2021 12:39:38 -0500
X-MC-Unique: q0Qp5HYGM2yqTLcX5CyFkw-1
Received: by mail-wm1-f69.google.com with SMTP id b62so2784990wmc.5
        for <kvm@vger.kernel.org>; Fri, 19 Feb 2021 09:39:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0XNpw7EsZwRfqH5jj+d5q0K26B/2H8ocJXujjf2y0q0=;
        b=smsPJdMQ5zlJWabxei/8lu87yf/RFVGs8/TjDJV60gWBJGU0YZ/YTtObDkEgTtkexx
         sv9GxKxjelafs0R7ZnEtyfCB/Wnf4iikHpCSvCQlrOZkzM1cr8aw8Ggj7aP2QwXkdyFQ
         ALJmv55PPnRp03zCJnbIz4aQ+AUOuR3308bFlU8JW+Sud7bhmB5KFtkv3tOmTn6MMmGV
         dVF4fEI8Av7kkwYaBVBKvBIKFjvFmEJDYcK3+gmTRfIcTInJ/34Fk9Jnmy61sZ/BKGGw
         CO9E84YOzJxVlS+JGCAYFdW+Mvez0zTaDTdLdJ2ztUMlYi+7p+wTO5ryXnQLU3n+9N3P
         ADQA==
X-Gm-Message-State: AOAM530eRHrKXhEEmcCHeeAwuvoGudW7E5nUZA5xcs+Vc9hZSD72EIei
        WDqEVDANwhZBuoVC+NhyvpZl1MI04/XTLn15JRaM6b33hmr7MlY1impYuDwEP9Ka8ZDDw2DeYqw
        D8/8WBXKA7HqD
X-Received: by 2002:adf:fb91:: with SMTP id a17mr10124640wrr.93.1613756376927;
        Fri, 19 Feb 2021 09:39:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwUWYk16cfFnjfBZLMWl2Vy5aAjSJDcFd3Zrj54+kp+HHEcqph2ioitLZ00EdqyQhCQF2e9eA==
X-Received: by 2002:adf:fb91:: with SMTP id a17mr10124607wrr.93.1613756376757;
        Fri, 19 Feb 2021 09:39:36 -0800 (PST)
Received: from localhost.localdomain (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id c133sm2365046wme.46.2021.02.19.09.39.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 09:39:36 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Peter Maydell <peter.maydell@linaro.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        qemu-ppc@nongnu.org, qemu-s390x@nongnu.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        xen-devel@lists.xenproject.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        qemu-arm@nongnu.org, Stefano Stabellini <sstabellini@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        BALATON Zoltan <balaton@eik.bme.hu>,
        Leif Lindholm <leif@nuviainc.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Radoslaw Biernacki <rad@semihalf.com>,
        Alistair Francis <alistair@alistair23.me>,
        Paul Durrant <paul@xen.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?q?Herv=C3=A9=20Poussineau?= <hpoussin@reactos.org>,
        Greg Kurz <groug@kaod.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [RFC PATCH v2 08/11] hw/i386: Explicit x86 machines support all current accelerators
Date:   Fri, 19 Feb 2021 18:38:44 +0100
Message-Id: <20210219173847.2054123-9-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210219173847.2054123-1-philmd@redhat.com>
References: <20210219173847.2054123-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

x86 machines currently support all accelerators.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
RFC: not sure about this, x86 is not my cup of tea

 hw/i386/x86.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index 6329f90ef90..2dc10e7d386 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -1209,6 +1209,10 @@ static void x86_machine_initfn(Object *obj)
     x86ms->pci_irq_mask = ACPI_BUILD_PCI_IRQS;
 }
 
+static const char *const valid_accels[] = {
+    "tcg", "kvm", "xen", "hax", "hvf", "whpx", NULL
+};
+
 static void x86_machine_class_init(ObjectClass *oc, void *data)
 {
     MachineClass *mc = MACHINE_CLASS(oc);
@@ -1218,6 +1222,7 @@ static void x86_machine_class_init(ObjectClass *oc, void *data)
     mc->cpu_index_to_instance_props = x86_cpu_index_to_props;
     mc->get_default_cpu_node_id = x86_get_default_cpu_node_id;
     mc->possible_cpu_arch_ids = x86_possible_cpu_arch_ids;
+    mc->valid_accelerators = valid_accels;
     x86mc->compat_apic_id_mode = false;
     x86mc->save_tsc_khz = true;
     nc->nmi_monitor_handler = x86_nmi;
-- 
2.26.2

