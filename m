Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45DB4467EBB
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 21:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383073AbhLCUVc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 15:21:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:53472 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234814AbhLCUVb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Dec 2021 15:21:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638562686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=qDFnWUE6JGYMviWRrPTghPiCW8vABttFA9L8VJUfZ6o=;
        b=N0xHrU6Zc6jjESzcKcaYEZWU0WDgiSmCI8d9QH/muzQW69I4P7Q/R9IAt0ZxlM4OQjqtfe
        L5eXlzvOzuY71vI83X4EX6y8f6jz42SHOFGRcQssc8sj+OlrwaRfbrWPPxP3E20PKhnvNx
        0j0qIKBbmGrwPYQj6D7DG0UExXp3Axw=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-143-PSXL2yy8N0W48-XzvIGTwg-1; Fri, 03 Dec 2021 15:18:05 -0500
X-MC-Unique: PSXL2yy8N0W48-XzvIGTwg-1
Received: by mail-oi1-f200.google.com with SMTP id y20-20020acaaf14000000b002a817a23a1eso2787602oie.23
        for <kvm@vger.kernel.org>; Fri, 03 Dec 2021 12:18:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=qDFnWUE6JGYMviWRrPTghPiCW8vABttFA9L8VJUfZ6o=;
        b=4vKOai7R0xUk37UgdLWSUW5z2MaUwtCwP0oEyDpLsdZO2zn3kI2kjg7EmwyDBpviPH
         cCuuyEvfWeRG08yjk1yg7vnWZlZZTLv+v0EJRsnudb/LGYoVlh5SE7HBQrLSJOeAu4Tw
         aQSs8vakUWeRwmfRid3PkNZjWZJ05VyfZZHsYWzg3KVuTK7JfIK9IwHfeX9qsbiIhrAG
         fqYGUAzZD6ipxEUQZwFrxv/WIlk93cfnsN4hVfD7yNiZAXXiHl9tIt37XVfQpzT1lDMT
         rc6K67xX8DQXZO5eaJqTet9jF2D8zUuoc107tdXym4rdR1ZKrkWU0F00SzL3O1eB++XR
         Kw1Q==
X-Gm-Message-State: AOAM532MENKg7P0lF5qQ4tL/KuF0/zjj5ZdGMOpbAfJ5T5W5BHqnIwPi
        8Z5oBvvNuT90bhBDSFGA6uuYBqzwVCCekHnARBsUSC00Uf8cUFpL0ICvUNzocwJfhwqz9gFM9NX
        BhZdS0j6BoCgQ
X-Received: by 2002:a9d:f45:: with SMTP id 63mr17759562ott.350.1638562684817;
        Fri, 03 Dec 2021 12:18:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyRXVzV1Dg3EtPBTdHlWj1hDenP/dLOgDBfCJx7/8cXL0CVfU9F+s57MDiqXf4fgPuj46YhKA==
X-Received: by 2002:a9d:f45:: with SMTP id 63mr17759546ott.350.1638562684581;
        Fri, 03 Dec 2021 12:18:04 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id s2sm759026otr.69.2021.12.03.12.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 12:18:04 -0800 (PST)
Date:   Fri, 3 Dec 2021 13:18:03 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [GIT PULL] VFIO updates for v5.16-rc4
Message-ID: <20211203131803.7fb40f46.alex.williamson@redhat.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

The following changes since commit d58071a8a76d779eedab38033ae4c821c30295a5:

  Linux 5.16-rc3 (2021-11-28 14:09:19 -0800)

are available in the Git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-v5.16-rc4

for you to fetch changes up to 8704e89349080bd640d1755c46d8cdc359a89748:

  vfio/pci: Fix OpRegion read (2021-11-30 11:41:49 -0700)

----------------------------------------------------------------
VFIO fixes for v5.16-rc4

 - Fix OpRegion pointer arithmetic (Zhenyu Wang)

 - Fix comment format triggering kernel-doc warnings (Randy Dunlap)

----------------------------------------------------------------
Randy Dunlap (1):
      vfio: remove all kernel-doc notation

Zhenyu Wang (1):
      vfio/pci: Fix OpRegion read

 drivers/vfio/pci/vfio_pci_igd.c |  5 +++--
 drivers/vfio/vfio.c             | 28 ++++++++++++++--------------
 2 files changed, 17 insertions(+), 16 deletions(-)

