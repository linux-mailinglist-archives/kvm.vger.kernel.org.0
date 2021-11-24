Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D381145B40D
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 06:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233331AbhKXFzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 00:55:40 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:44988
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231421AbhKXFzk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Nov 2021 00:55:40 -0500
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 293B23F19E
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 05:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1637733149;
        bh=V/j9435sf+Q6QqIYUyi0ktOVWvCT49bfuL52dC8eJNQ=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=mNA71YDlPdMDewD3l9zhJplvW/lU6JG5K33Ie2aSCJOnbyp387hcJTA8AsAsyPonC
         YcGnFIAVyUsAVEqJ1pRjiRHMNmsniWnOjEF3/dFmlyeU4C62WWnaFbVzYXVDmAFlly
         PoRK5eQZVr0rqqJB3IaV6DOJjMiOuCYava/gVdJutkJtWB31a+5c0PZBHFr1DKJM+Y
         dHYDA+z17+agCWgjwKXKjGce2RMkDsoH1ECDqur1EeWHIkKJ6YbN2Sr7H8Zf+uKaUy
         HibNTSiOESlWIbKQZzPeKPftNUpMbc/o0F0d3EHRZZJzEU+SpbgRLO5G/+6WalPIEV
         FgybKkKwwkvEw==
Received: by mail-pf1-f200.google.com with SMTP id x14-20020a627c0e000000b0049473df362dso917120pfc.12
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 21:52:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V/j9435sf+Q6QqIYUyi0ktOVWvCT49bfuL52dC8eJNQ=;
        b=6GRyFy97eXbMFOwRFE9MqkxTaAFNsWdgj+00OtsZ1L9+MSzv+OoHQXndPp5q42mEyc
         9QJWejWGokkN/fB8VyD65Cn05R/xcTJ0qJ8dZajJlKzuu4m4o4vL+rPOWLIrpHbFL+y7
         1q9o42SZdJkIwcvIZpqYPXPuQNHRQ9D9z6ARfKAImbxngrZ25FCPQEBHH6XcU01kh2MS
         NzbYE/l1QPQy/8Bkw2qcqwaV10wKbcxrfPFoL6ceNxHfXDKYw78RWOOb+mijx9d2MoLC
         QtK2Tdjvbl/j6D71Z5USa3v73xa4j2gz5vzcJFNGOHaiZcxGTzNa+dKD+5E0RA6C+grH
         2mjQ==
X-Gm-Message-State: AOAM532cJlCn0nl/P3GNWwrTmxnJJ/RT75NrunQyBqX8i7YU6ePoGr0a
        AISJvttBTsYUA1cqgRnMgj2AZYOGDY9S3WSpVujjseCOnEEN7jWq8vPUHXVp+kf/k9Ro5WhWk37
        6lO21TkoEulIij+xyf+aarYdafUpmivlyZXWc1WqWuy9USw==
X-Received: by 2002:a17:90a:fe0a:: with SMTP id ck10mr5187432pjb.216.1637733147744;
        Tue, 23 Nov 2021 21:52:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxtcQIbaN5dL44ZbqC9L1a1WlemOP/LRBnvajM2RC/ohJohHICyHnWXVJGR7cdc4bVPeYgPZaVQp8pkmusSUQE=
X-Received: by 2002:a17:90a:fe0a:: with SMTP id ck10mr5187399pjb.216.1637733147439;
 Tue, 23 Nov 2021 21:52:27 -0800 (PST)
MIME-Version: 1.0
References: <d4084296-9d36-64ec-8a79-77d82ac6d31c@canonical.com>
 <20210914104301.48270518.alex.williamson@redhat.com> <9e8d0e9e-1d94-35e8-be1f-cf66916c24b2@canonical.com>
 <20210915103235.097202d2.alex.williamson@redhat.com> <2fadf33d-8487-94c2-4460-2a20fdb2ea12@canonical.com>
 <20211005171326.3f25a43a.alex.williamson@redhat.com> <CAKAwkKtJQ1mE3=iaDA1B_Dkn1+ZbN0jTSWrQon0=SAszRv5xFw@mail.gmail.com>
 <20211012140516.6838248b.alex.williamson@redhat.com> <CAKAwkKsF3Kn1HLAg55cBVmPmo2y0QAf7g6Zc7q6ZsQZBXGW9bg@mail.gmail.com>
 <CAKAwkKsoKELnR=--06sRZL3S6_rQVi5J_Kcv6iRQ6w2tY71WCQ@mail.gmail.com> <20211104160541.4aedc593.alex.williamson@redhat.com>
In-Reply-To: <20211104160541.4aedc593.alex.williamson@redhat.com>
From:   Matthew Ruffell <matthew.ruffell@canonical.com>
Date:   Wed, 24 Nov 2021 18:52:16 +1300
Message-ID: <CAKAwkKs=p3bHQL5VXuh_Xhu3A+mg0mSEuFJ_fy4Zh6E6YG4aag@mail.gmail.com>
Subject: Re: [PROBLEM] Frequently get "irq 31: nobody cared" when passing
 through 2x GPUs that share same pci switch via vfio
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     linux-pci@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, nathan.langford@xcelesunifiedtechnologies.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

I have forward ported your patch to 5.16-rc2 to account for the vfio module
refactor that happened recently. Attached below.

Have you had an opportunity to research if it is possible to conditionalise
clearing DisINTx by looking at the interrupt status and seeing if there is a
pending interrupt but no handler set?

We are testing a 5.16-rc2 kernel with the patch applied on Nathan's server
currently, and we are also trying out the pci=clearmsi command line parameter
that was discussed on linux-pci a few years ago in [1][2][3][4] along with
setting snd-hda-intel.enable_msi=1 to see if it helps the crashkernel not get
stuck copying IR tables.

[1] https://marc.info/?l=linux-pci&m=153988799707413
[2] https://lore.kernel.org/linux-pci/20181018183721.27467-1-gpiccoli@canonical.com/
[3] https://lore.kernel.org/linux-pci/20181018183721.27467-2-gpiccoli@canonical.com/
[4] https://lore.kernel.org/linux-pci/20181018183721.27467-3-gpiccoli@canonical.com/

I will let you know how we get on.

Thanks,
Matthew

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index f948e6cd2993..cbca207ddc45 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -276,6 +276,7 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
             vdev->pci_2_3 = pci_intx_mask_supported(pdev);
     }

+    vfio_intx_stub_init(vdev);
     pci_read_config_word(pdev, PCI_COMMAND, &cmd);
     if (vdev->pci_2_3 && (cmd & PCI_COMMAND_INTX_DISABLE)) {
         cmd &= ~PCI_COMMAND_INTX_DISABLE;
@@ -365,6 +366,14 @@ void vfio_pci_core_disable(struct
vfio_pci_core_device *vdev)
         kfree(dummy_res);
     }

+    /*
+     * Set known command register state, disabling MSI/X (via busmaster)
+     * and INTx directly.  At this point we can teardown the INTx stub
+     * handler initialized from the SET_IRQS teardown above.
+     */
+    pci_write_config_word(pdev, PCI_COMMAND, PCI_COMMAND_INTX_DISABLE);
+    vfio_intx_stub_exit(vdev);
+
     vdev->needs_reset = true;

     /*
@@ -382,12 +391,6 @@ void vfio_pci_core_disable(struct
vfio_pci_core_device *vdev)
         pci_save_state(pdev);
     }

-    /*
-     * Disable INTx and MSI, presumably to avoid spurious interrupts
-     * during reset.  Stolen from pci_reset_function()
-     */
-    pci_write_config_word(pdev, PCI_COMMAND, PCI_COMMAND_INTX_DISABLE);
-
     /*
      * Try to get the locks ourselves to prevent a deadlock. The
      * success of this is dependent on being able to lock the device,
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c
b/drivers/vfio/pci/vfio_pci_intrs.c
index 6069a11fb51a..98cf528aa175 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -139,6 +139,44 @@ static irqreturn_t vfio_intx_handler(int irq, void *dev_id)
     return ret;
 }

+static irqreturn_t vfio_intx_stub(int irq, void *dev_id)
+{
+    struct vfio_pci_core_device *vdev = dev_id;
+
+    if (pci_check_and_mask_intx(vdev->pdev))
+        return IRQ_HANDLED;
+
+    return IRQ_NONE;
+}
+
+void vfio_intx_stub_init(struct vfio_pci_core_device *vdev)
+{
+    char *name;
+
+    if (vdev->nointx || !vdev->pci_2_3 || !vdev->pdev->irq)
+        return;
+
+    name = kasprintf(GFP_KERNEL, "vfio-intx-stub(%s)",
+             pci_name(vdev->pdev));
+    if (!name)
+        return;
+
+    if (request_irq(vdev->pdev->irq, vfio_intx_stub,
+            IRQF_SHARED, name, vdev))
+        kfree(name);
+
+    vdev->intx_stub = true;
+}
+
+void vfio_intx_stub_exit(struct vfio_pci_core_device *vdev)
+{
+    if (!vdev->intx_stub)
+        return;
+
+    kfree(free_irq(vdev->pdev->irq, vdev));
+    vdev->intx_stub = false;
+}
+
 static int vfio_intx_enable(struct vfio_pci_core_device *vdev)
 {
     if (!is_irq_none(vdev))
@@ -153,6 +191,8 @@ static int vfio_intx_enable(struct
vfio_pci_core_device *vdev)

     vdev->num_ctx = 1;

+    vfio_intx_stub_exit(vdev);
+
     /*
      * If the virtual interrupt is masked, restore it.  Devices
      * supporting DisINTx can be masked at the hardware level
@@ -231,6 +271,7 @@ static void vfio_intx_disable(struct
vfio_pci_core_device *vdev)
     vdev->irq_type = VFIO_PCI_NUM_IRQS;
     vdev->num_ctx = 0;
     kfree(vdev->ctx);
+    vfio_intx_stub_init(vdev);
 }

 /*
@@ -258,6 +299,8 @@ static int vfio_msi_enable(struct
vfio_pci_core_device *vdev, int nvec, bool msi
     if (!vdev->ctx)
         return -ENOMEM;

+    vfio_intx_stub_exit(vdev);
+
     /* return the number of supported vectors if we can't get all: */
     cmd = vfio_pci_memory_lock_and_enable(vdev);
     ret = pci_alloc_irq_vectors(pdev, 1, nvec, flag);
@@ -266,6 +309,7 @@ static int vfio_msi_enable(struct
vfio_pci_core_device *vdev, int nvec, bool msi
             pci_free_irq_vectors(pdev);
         vfio_pci_memory_unlock_and_restore(vdev, cmd);
         kfree(vdev->ctx);
+        vfio_intx_stub_init(vdev);
         return ret;
     }
     vfio_pci_memory_unlock_and_restore(vdev, cmd);
@@ -388,6 +432,7 @@ static int vfio_msi_set_block(struct
vfio_pci_core_device *vdev, unsigned start,
 static void vfio_msi_disable(struct vfio_pci_core_device *vdev, bool msix)
 {
     struct pci_dev *pdev = vdev->pdev;
+    pci_dev_flags_t dev_flags = pdev->dev_flags;
     int i;
     u16 cmd;

@@ -399,19 +444,22 @@ static void vfio_msi_disable(struct
vfio_pci_core_device *vdev, bool msix)
     vfio_msi_set_block(vdev, 0, vdev->num_ctx, NULL, msix);

     cmd = vfio_pci_memory_lock_and_enable(vdev);
-    pci_free_irq_vectors(pdev);
-    vfio_pci_memory_unlock_and_restore(vdev, cmd);

     /*
-     * Both disable paths above use pci_intx_for_msi() to clear DisINTx
-     * via their shutdown paths.  Restore for NoINTx devices.
+     * XXX pci_intx_for_msi() will clear DisINTx, which can trigger an
+     * INTx storm even before we return from pci_free_irq_vectors(), even
+     * as we'll restore the previous command register immediately after.
+     * Hack around it by masking in a dev_flag to prevent such behavior.
      */
-    if (vdev->nointx)
-        pci_intx(pdev, 0);
+    pdev->dev_flags |= PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG;
+    pci_free_irq_vectors(pdev);
+    pdev->dev_flags = dev_flags;

+    vfio_pci_memory_unlock_and_restore(vdev, cmd);
     vdev->irq_type = VFIO_PCI_NUM_IRQS;
     vdev->num_ctx = 0;
     kfree(vdev->ctx);
+    vfio_intx_stub_init(vdev);
 }

 /*
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index ef9a44b6cf5d..58e1029eb083 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -124,6 +124,7 @@ struct vfio_pci_core_device {
     bool            needs_reset;
     bool            nointx;
     bool            needs_pm_restore;
+    bool            intx_stub;
     struct pci_saved_state    *pci_saved_state;
     struct pci_saved_state    *pm_save;
     int            ioeventfds_nr;
@@ -145,6 +146,9 @@ struct vfio_pci_core_device {
 #define is_irq_none(vdev) (!(is_intx(vdev) || is_msi(vdev) || is_msix(vdev)))
 #define irq_is(vdev, type) (vdev->irq_type == type)

+extern void vfio_intx_stub_init(struct vfio_pci_core_device *vdev);
+extern void vfio_intx_stub_exit(struct vfio_pci_core_device *vdev);
+
 extern void vfio_pci_intx_mask(struct vfio_pci_core_device *vdev);
 extern void vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev);
