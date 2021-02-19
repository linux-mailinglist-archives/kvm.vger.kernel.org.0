Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEE231FE12
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 18:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbhBSRkw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 12:40:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31261 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229930AbhBSRku (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Feb 2021 12:40:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613756363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ltjnESlJDd3H5QR2j8eiWOyKx9h8jJk2C0jWkjeNUew=;
        b=eq9f8YTsHSiZHbZaEbSyygRDuLddjYVZUiSZjEmOtmPvGeR5wxzWfqNuoKpHKzYNJ5+oCC
        m/pFJAeWJmnA+7E6qAjCBQ6jIDSz4LxESwzBeomPps4ZIcMsXpys4aYJiinK506u07eovq
        v28D+PeiZGWHcWyHk4DsGUtF37m80oQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-ZGLsO0QIPd26Dl4ag2rtYg-1; Fri, 19 Feb 2021 12:39:20 -0500
X-MC-Unique: ZGLsO0QIPd26Dl4ag2rtYg-1
Received: by mail-wr1-f69.google.com with SMTP id d10so2748099wrq.17
        for <kvm@vger.kernel.org>; Fri, 19 Feb 2021 09:39:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ltjnESlJDd3H5QR2j8eiWOyKx9h8jJk2C0jWkjeNUew=;
        b=fPAJOJrokRzxHESUebyAfMHbIaGUEdt2qwtJGAIBLnS0JcMRiBNBYdHGROsMGue7Nh
         PVHkrWu/TpyGhNRydUT2ImecL76P07nhYRmsizWGMc3e5X7UTE9aNQz/9I0rjTQhC029
         ceiJAT1CEink/U3T0gid6AwB+tnmUliMn41wE7GyylGRAlFsoM0CCCDNNieQ0ZryrdNF
         ETD5Ydtv0S4WUTHRiPcxKmBsxjzvfzSsjEVZDtPkOx4vF1MJELS6/SA3p8aNzRAZKPVQ
         e7el62voaB3WykgX1P0QX24gL0WpIzZbe3xW8CIZ+PjRN50IHDjJFTseYkS+4m2jPYQC
         Mx0Q==
X-Gm-Message-State: AOAM532azuyQmhFPyUjTY6Xr6Wky+SIJGn8MeI1ccv+9M2gMUh2ih7jk
        tcRbpLpJEFVLgkHuEg//XPcB2Tie11t4KZQ5y4IMluREka/cQpmSn48IxiS6cD7zQdKd41dapIK
        PotQ5kfoXDZPs
X-Received: by 2002:a5d:558b:: with SMTP id i11mr10341338wrv.125.1613756359008;
        Fri, 19 Feb 2021 09:39:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyksADAECUrKIFfE8NXfSBq0p9Yv0QU1jPKKdp6ensUX0SFo+MEZzOE/tMgXW9KlqBOatRsLw==
X-Received: by 2002:a5d:558b:: with SMTP id i11mr10341310wrv.125.1613756358861;
        Fri, 19 Feb 2021 09:39:18 -0800 (PST)
Received: from localhost.localdomain (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id f7sm14534967wre.78.2021.02.19.09.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 09:39:18 -0800 (PST)
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
Subject: [PATCH v2 05/11] hw/mips: Restrict KVM to the malta & virt machines
Date:   Fri, 19 Feb 2021 18:38:41 +0100
Message-Id: <20210219173847.2054123-6-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210219173847.2054123-1-philmd@redhat.com>
References: <20210219173847.2054123-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Restrit KVM to the following MIPS machines:
- malta
- loongson3-virt

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/mips/loongson3_virt.c | 5 +++++
 hw/mips/malta.c          | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/hw/mips/loongson3_virt.c b/hw/mips/loongson3_virt.c
index d4a82fa5367..c3679dff043 100644
--- a/hw/mips/loongson3_virt.c
+++ b/hw/mips/loongson3_virt.c
@@ -612,6 +612,10 @@ static void mips_loongson3_virt_init(MachineState *machine)
     loongson3_virt_devices_init(machine, liointc);
 }
 
+static const char *const valid_accels[] = {
+    "tcg", "kvm", NULL
+};
+
 static void loongson3v_machine_class_init(ObjectClass *oc, void *data)
 {
     MachineClass *mc = MACHINE_CLASS(oc);
@@ -622,6 +626,7 @@ static void loongson3v_machine_class_init(ObjectClass *oc, void *data)
     mc->max_cpus = LOONGSON_MAX_VCPUS;
     mc->default_ram_id = "loongson3.highram";
     mc->default_ram_size = 1600 * MiB;
+    mc->valid_accelerators = valid_accels;
     mc->kvm_type = mips_kvm_type;
     mc->minimum_page_bits = 14;
 }
diff --git a/hw/mips/malta.c b/hw/mips/malta.c
index 9afc0b427bf..0212048dc63 100644
--- a/hw/mips/malta.c
+++ b/hw/mips/malta.c
@@ -1443,6 +1443,10 @@ static const TypeInfo mips_malta_device = {
     .instance_init = mips_malta_instance_init,
 };
 
+static const char *const valid_accels[] = {
+    "tcg", "kvm", NULL
+};
+
 static void mips_malta_machine_init(MachineClass *mc)
 {
     mc->desc = "MIPS Malta Core LV";
@@ -1456,6 +1460,7 @@ static void mips_malta_machine_init(MachineClass *mc)
     mc->default_cpu_type = MIPS_CPU_TYPE_NAME("24Kf");
 #endif
     mc->default_ram_id = "mips_malta.ram";
+    mc->valid_accelerators = valid_accels;
 }
 
 DEFINE_MACHINE("malta", mips_malta_machine_init)
-- 
2.26.2

