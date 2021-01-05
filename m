Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1BCA2EAA91
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 13:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728438AbhAEMXT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 07:23:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20434 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728381AbhAEMXS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Jan 2021 07:23:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609849312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=U39k5ipMHANWOJWrOXSYV59iZX09Ei6dL9ebZb8Ogeg=;
        b=h0lLt4/Tksg6sI88+7rwPMzNQCYPJcQNpokcL+CsnYogR/Knm6EeB1j/rMH0Xv7n/UlUQX
        LlkU39FznW/EwWqgsRi0jFX8bk+O+VXF0sqjFU3xTMPuUBN4p4SuN8NmJrzE+D7PpMZsIo
        x0Aay4OYfwQIX3GQJGqZpcZNh9OuCUg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522-iKMYHQx1P2SVWYte9haiLA-1; Tue, 05 Jan 2021 07:21:51 -0500
X-MC-Unique: iKMYHQx1P2SVWYte9haiLA-1
Received: by mail-wm1-f69.google.com with SMTP id f187so1179176wme.3
        for <kvm@vger.kernel.org>; Tue, 05 Jan 2021 04:21:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=U39k5ipMHANWOJWrOXSYV59iZX09Ei6dL9ebZb8Ogeg=;
        b=PK4A1etEJ5mp6VSTjiet4uH9j8vzc4upDrqPkTxLopjVTcB0y5U55eU28m6tVDucxB
         u4zrrgjZB6uY1TU9FdktnsHWSD8WaSY9WPUox8dm+OHGVci71qjjyPEOIIusEWkmHJYp
         U8kiQ54gfPlWK+QvXNY9byNFo1+QYZEv4vjlo1h1vvH2o/ZefcOb15Yw+ilvXNGnSo2A
         tbEUxlWRjKI8CldySKl0dyqXE8PXjwBriZtLRHybEQe/TUwwfsvyQDsB8LHZdqgIIoj7
         Xy5mJO6HLhJY7mGubUIU9Ub4ldF5/bWRGCXD63aYckwVPtHf4zgzYNOcJS6UTXXf+DpJ
         tj2A==
X-Gm-Message-State: AOAM5307LMcSNhlqdABQydwtB103p2mD3H0/GbTNhou3XDWlo8aKdJw8
        fVL4B50ih3nmn/idqxDxQ19ZyEKrGSOJAG8ijNV7LhAIWZWnsYWy/hWzaS2xmd33qJitE9KXJV/
        r6rnMpwBIAVTx
X-Received: by 2002:adf:bb0e:: with SMTP id r14mr85949740wrg.159.1609849309287;
        Tue, 05 Jan 2021 04:21:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxRxC04NYGeb6WaL98Uxtwkp2M43zTcBL2qoRpI0IP4stOIB1HKct8R0XtAhgJEy1jrpROFhg==
X-Received: by 2002:adf:bb0e:: with SMTP id r14mr85949711wrg.159.1609849308953;
        Tue, 05 Jan 2021 04:21:48 -0800 (PST)
Received: from redhat.com (bzq-79-178-32-166.red.bezeqint.net. [79.178.32.166])
        by smtp.gmail.com with ESMTPSA id y7sm3716921wmb.37.2021.01.05.04.21.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 04:21:48 -0800 (PST)
Date:   Tue, 5 Jan 2021 07:21:45 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jasowang@redhat.com, mst@redhat.com, sgarzare@redhat.com
Subject: [GIT PULL] vhost: bugfix
Message-ID: <20210105072145-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 418eddef050d5f6393c303a94e3173847ab85466:

  vdpa: Use simpler version of ida allocation (2020-12-18 16:14:31 -0500)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to e13a6915a03ffc3ce332d28c141a335e25187fa3:

  vhost/vsock: add IOTLB API support (2020-12-27 05:49:01 -0500)

----------------------------------------------------------------
vhost: bugfix

This fixes configs with vhost vsock behind a viommu.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Stefano Garzarella (1):
      vhost/vsock: add IOTLB API support

 drivers/vhost/vsock.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 65 insertions(+), 3 deletions(-)

