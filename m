Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6968231FE14
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 18:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhBSRlB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 12:41:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31616 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229952AbhBSRlA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Feb 2021 12:41:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613756373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ueqj+n2dHsbjBHuZ0Hoy+mZlGObPSK9klpKLOoZpu4Y=;
        b=gS9gFcTc29lGbzA9TGtZVJjmLZ2DsvalXDYrgj52AGPDcHgBajrLLeyCgYvrAsDq22wD2Z
        yYh/well8zumKHdE1ojLFP4vEAx9a6jtTV1YCt5DJt21rFSpTrOej321UaS07i1Cb8y40n
        brIBOS52mffkAzOKwl2pakdRhdy0AI4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-YbUZab9rObKaoFc3N5SmdQ-1; Fri, 19 Feb 2021 12:39:32 -0500
X-MC-Unique: YbUZab9rObKaoFc3N5SmdQ-1
Received: by mail-wr1-f71.google.com with SMTP id d10so2748286wrq.17
        for <kvm@vger.kernel.org>; Fri, 19 Feb 2021 09:39:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ueqj+n2dHsbjBHuZ0Hoy+mZlGObPSK9klpKLOoZpu4Y=;
        b=bSnhTd3Zm4QHOGgJN3uKtrBKALk1MR/8XgGx+WWzU82xGieVTcdGmROAg+NElR5STp
         q+AWA1w6K72Cjlj9OuXwrgkYxrLBogsmOdq97iHukASyeh7D/EMs4d2+HU1tDSGQCIQJ
         SZEmLGsBxDBc+JpRwT7QkzZmPbBHJ5T1OcjXj5TvLRKu07hrO69NK05P0RJSBEAON5sb
         Z9fIWPwvv8PufuXTY9CeLSbebKT0vXnbH6uE0g6B0ZpTiqsQypfunUnhV05CmfVEHI2c
         UbCvDecpSxwX0sHReAjLQZnSW+Hud2x2RQcUGxSFPBeOT0sX2dWS3fmbpKIIQ2sYvu1X
         b4Aw==
X-Gm-Message-State: AOAM532YBljqtnK/Wn21K/ZglVXdUxNNChBlZw713isAROboyTAGIAS4
        JYxpeTJVnk34DwU4euuGVaUvbMbBsiBa60Df0HtbmaBQ3uooWA01Me1uRwNC3VOlMv0PRgq9Z2f
        VDxo7n3G9ROJ7
X-Received: by 2002:a1c:c90c:: with SMTP id f12mr9311998wmb.98.1613756370707;
        Fri, 19 Feb 2021 09:39:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyQVxSvgdKIkMYLk6jZPql9ZCAN0WXriT+5Nc8pY51dY+mHxFK5IkbcVQRBV0rvadWM1WYfTA==
X-Received: by 2002:a1c:c90c:: with SMTP id f12mr9311979wmb.98.1613756370490;
        Fri, 19 Feb 2021 09:39:30 -0800 (PST)
Received: from localhost.localdomain (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id r12sm3052972wrt.69.2021.02.19.09.39.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 09:39:30 -0800 (PST)
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
Subject: [PATCH v2 07/11] hw/s390x: Explicit the s390-ccw-virtio machines support TCG and KVM
Date:   Fri, 19 Feb 2021 18:38:43 +0100
Message-Id: <20210219173847.2054123-8-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210219173847.2054123-1-philmd@redhat.com>
References: <20210219173847.2054123-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All s390-ccw-virtio machines support TCG and KVM.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/s390x/s390-virtio-ccw.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
index 2972b607f36..1f168485066 100644
--- a/hw/s390x/s390-virtio-ccw.c
+++ b/hw/s390x/s390-virtio-ccw.c
@@ -586,6 +586,10 @@ static ram_addr_t s390_fixup_ram_size(ram_addr_t sz)
     return newsz;
 }
 
+static const char *const valid_accels[] = {
+    "tcg", "kvm", NULL
+};
+
 static void ccw_machine_class_init(ObjectClass *oc, void *data)
 {
     MachineClass *mc = MACHINE_CLASS(oc);
@@ -612,6 +616,7 @@ static void ccw_machine_class_init(ObjectClass *oc, void *data)
     mc->possible_cpu_arch_ids = s390_possible_cpu_arch_ids;
     /* it is overridden with 'host' cpu *in kvm_arch_init* */
     mc->default_cpu_type = S390_CPU_TYPE_NAME("qemu");
+    mc->valid_accelerators = valid_accels;
     hc->plug = s390_machine_device_plug;
     hc->unplug_request = s390_machine_device_unplug_request;
     nc->nmi_monitor_handler = s390_nmi;
-- 
2.26.2

