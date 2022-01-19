Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD1D493FAA
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 19:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356652AbiASSLr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 13:11:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21133 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234280AbiASSLr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Jan 2022 13:11:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642615906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=GNXJ0yqpaBu/M90jjOlDPwUordWMR9OUp0gxFTOdR3E=;
        b=YUD+UFxP669f03vZUbnxPw5ltv30aiM284VPmWQvh5tNIazyR1c2bw9l2egnPAaCEZLs38
        +OWMxxzMlX3b3J6dMUaRz9u+Kxb7RkV+xLGcXf3WUI2Dc8ML7UJ0O+TCvizi4i7KfA20RM
        P92tCqrWzVKUCWQrPkKuhH2lMkMWvWA=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-270-DAnbjeoBM9qJSBPds6-cHA-1; Wed, 19 Jan 2022 13:11:45 -0500
X-MC-Unique: DAnbjeoBM9qJSBPds6-cHA-1
Received: by mail-ot1-f72.google.com with SMTP id t6-20020a05683019e600b0059b1b43c8cdso1942964ott.22
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 10:11:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=GNXJ0yqpaBu/M90jjOlDPwUordWMR9OUp0gxFTOdR3E=;
        b=ly1PvNynf7+c7jX51uHnTOF/tz1+pO+uyaTJFIeW98wZyzoE7YK2P6ZJxRuhzFmQcC
         NBPThUmtuJD+KJiQ8b9/N3mEqDpeA8GI0ArZYm84tndKzNKcGetUVytoZrgKfWBzc6H3
         Wb6Rz7nXqOrsM4455ucgOiTHkY6m7KPu4Li6u3D6Vxa86gz5NNeMfbIodZpBBo0mhr60
         pDf2IZQKoJ/Rl3xKonv5uWe5FZpPrZBbBrHYFfzLmP2+N+b9XrnnzGQt2uknXtyV+NHw
         AD8nIykKYAhfx0hM3gLqjfnutJijCRwj0SJo2DXucsXywF2lWQyBRaqneQECNSI968S4
         TUeA==
X-Gm-Message-State: AOAM532cybCIY84gAlEa0cbIDky6AYrWWq9Yp0sCiqzkG/agdLdJZ0Mt
        RDCdKk4+W34icWFjiQYQOLdfJ3hM/cOUZisZq2eDVVeLmp63HaQt97THWKGdyTIW/4ej/x4KycC
        MLPCvfK+nICF8
X-Received: by 2002:a05:6808:1aa7:: with SMTP id bm39mr4204136oib.24.1642615904329;
        Wed, 19 Jan 2022 10:11:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzlHar5MRRf6LI6ea4gKSaVnYZ8opJyKvRwJVoD+Mx/krYS1DYbDnuJxrNj15jwiF6kNtm4fQ==
X-Received: by 2002:a05:6808:1aa7:: with SMTP id bm39mr4204120oib.24.1642615904111;
        Wed, 19 Jan 2022 10:11:44 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id c26sm238327oov.22.2022.01.19.10.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 10:11:43 -0800 (PST)
Date:   Wed, 19 Jan 2022 11:11:42 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [GIT PULL] VFIO updates for v5.17-rc1
Message-ID: <20220119111142.6ecbab24.alex.williamson@redhat.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

The following changes since commit a7904a538933c525096ca2ccde1e60d0ee62c08e:

  Linux 5.16-rc6 (2021-12-19 14:14:33 -0800)

are available in the Git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-v5.17-rc1

for you to fetch changes up to 2bed2ced40c97b8540ff38df0149e8ecb2bf4c65:

  vfio/iommu_type1: replace kfree with kvfree (2021-12-21 12:30:34 -0700)

----------------------------------------------------------------
VFIO updates for v5.17-rc1

 - Fix sparse endian warnings in IGD code (Alex Williamson)

 - Balance kvzalloc with kvfree (Jiacheng Shi)

----------------------------------------------------------------
Alex Williamson (1):
      vfio/pci: Resolve sparse endian warnings in IGD support

Jiacheng Shi (1):
      vfio/iommu_type1: replace kfree with kvfree

 drivers/vfio/pci/vfio_pci_igd.c | 15 +++++++++------
 drivers/vfio/vfio_iommu_type1.c |  2 +-
 2 files changed, 10 insertions(+), 7 deletions(-)

