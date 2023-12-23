Return-Path: <kvm+bounces-5196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CD94F81D6C6
	for <lists+kvm@lfdr.de>; Sat, 23 Dec 2023 23:16:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88D4A282799
	for <lists+kvm@lfdr.de>; Sat, 23 Dec 2023 22:16:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 198E41D53A;
	Sat, 23 Dec 2023 22:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="NKWzPgU2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926F118B1E
	for <kvm@vger.kernel.org>; Sat, 23 Dec 2023 22:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-35fe8a4b311so5571985ab.1
        for <kvm@vger.kernel.org>; Sat, 23 Dec 2023 14:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1703369781; x=1703974581; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1ac2xR3b7E+AlQD1/HjNzYkoX3E0xeS+J4+7zILaP4s=;
        b=NKWzPgU2rmM9eqcFr95GJlijfQrg0YtoBcQA/14eDBRDa3QemEOgpGIEMo2UtvP0V3
         b+aPkqoVxMY0NcdZnz6t2c1AY0Kn8QV6UzGPlyV9jVRqsz1C1+UlE9AploQquVXYGHY2
         +Nmt1DNooJbq3mkGCV9lw85/DyYIGWW4Bp6lKzV1N7AKUnJhl7jQ5w63qVNLGpkJ1QAM
         unrcQXZ3zRJiAUHlYqxxgcCs+iTVhmj0pBJGZyoGnvVXX6xlfP+0dhrhhKkKeaYa26u/
         mQjB5jBliMtK/bDDDhApvF4GIZMTxhDVDA4crMv/Dxw6+RxvcNlL7UhWDopBEUE07gp4
         xZPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703369781; x=1703974581;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1ac2xR3b7E+AlQD1/HjNzYkoX3E0xeS+J4+7zILaP4s=;
        b=to+F6CSnIaBeHMYH0jPvxzz4iqpV2e/V1gdwYrRtEYZxSNjCIq3ZsSr2kUzH0cue0U
         KA2yt1LoaXvL9SHmAKsao0+nlslhuv+8qJ/NtnkTZN5a9cu1iz75bNZu4hAD3AG+KBy+
         4veJ/iDcHHmL0d2M8SKjH+/vfvG5JgYJBoP0zPSh4FM8nF0n8jfFu7hoWBWQh3gR0L3Y
         EpkAznWtjphbO3a3Ad1YnPLCTLMTDfeNdyOjf7xhgCe2JItBgznNg0e4H7tVHXxu3xRF
         rNS98uXcevGKZ7+Cd4nKopMOF/vLGDEu93WDhDvhXxF8eRPH/7y8QMBcc+nS+lcGawmz
         XmXA==
X-Gm-Message-State: AOJu0YzKndQap25JW//LIkPFG1abGfqIHYs2o9J8ZESAk0wL3b8e9zuz
	6GKo9TGXVGo26+d4PQzo2wE3YBltiGuvGntjNujknZdOicZ+qTHUYeVKIZ1wkzz8cWbkaSDJAbT
	vbCdThCZBbkr8oht0cn/mJvYz70MolXTovETfurSf45A8CDTyltWH+Qi+hWBNshCo372K/+Dh6X
	cuxUjD
X-Google-Smtp-Source: AGHT+IEo1k26R6WgAaL7ZvhvoX+xx5B7KtTwd6q4UOQqfMNbQgIioQE/5HcAA8Hllpx86c5STlrOUQ==
X-Received: by 2002:a05:6e02:16ce:b0:35f:a1c8:a6e1 with SMTP id 14-20020a056e0216ce00b0035fa1c8a6e1mr5132328ilx.58.1703369781272;
        Sat, 23 Dec 2023 14:16:21 -0800 (PST)
Received: from dev-mattc2.dev.purestorage.com ([208.88.159.129])
        by smtp.googlemail.com with ESMTPSA id hf17-20020a17090aff9100b0028c2b52d132sm1817925pjb.13.2023.12.23.14.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Dec 2023 14:16:20 -0800 (PST)
From: Matthew W Carlis <mattc@purestorage.com>
To: kvm@vger.kernel.org,
	alex.williamson@redhat.com,
	jgg@nvidia.com
Cc: Matthew W Carlis <mattc@purestorage.com>
Subject: [PATCH 1/1] vfio/pci: Log/indicate devices being bound & unbound.
Date: Sat, 23 Dec 2023 15:16:12 -0700
Message-Id: <20231223221612.35998-2-mattc@purestorage.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231223221612.35998-1-mattc@purestorage.com>
References: <20231223221612.35998-1-mattc@purestorage.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

We often would like to know when a device is unbound or bound
to vfio. Since I have a belief that such events should be
infrequent & in low volume; after this change the driver
will log when it decides to bind and unbind a device.

vfio-pci doesn't log when it binds to a device or is unbound
from a device. There may be logging from vfio when a device
is opened or closed by some user process which is good, but
even when the device is never opened vfio may have taken some
action as a result of binding. One such example might be
putting it into D3 low power state.

Additionally, the lifecycle of some applications that use
vfio-pci may be infrequent or defered for a significant time.
We have found that some third party tools or perhaps ignorant
super-users may choose to bind or unbind devices with a fairly
inexplicit policy leaving applictions that might have wanted
to use a device confused about its absence from vfio.

Signed-Off-by: Matthew W Carlis <mattc@purestorage.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 1929103ee59a..3e463a7d25f9 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -2265,6 +2265,8 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 	ret = vfio_register_group_dev(&vdev->vdev);
 	if (ret)
 		goto out_power;
+
+	pci_info(pdev, "binding to vfio control\n");
 	return 0;
 
 out_power:
@@ -2291,6 +2293,8 @@ void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
 		pm_runtime_get_noresume(&vdev->pdev->dev);
 
 	pm_runtime_forbid(&vdev->pdev->dev);
+
+	pci_info(vdev->pdev, "unbinding from vfio control\n");
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_unregister_device);
 
-- 
2.17.1


