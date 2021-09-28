Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7671A41B402
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 18:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241859AbhI1Qjk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 12:39:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27726 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230251AbhI1Qjk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Sep 2021 12:39:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632847080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=5SCTKeQfv554jeasIa56rvTLlkFOsyYw4BiVgx++QQ8=;
        b=SwN9MiLH5YlMgaENFDW9k25ip5H5OUhaAzQlrg91BRw7t2vxGCFldJKnEQ63n7B+fhDuDk
        +YasnJq8KVb+EpKjcFPNolCibvJ2fklUtkAgjR8gJpdho+qgtr+GeAmLKAzPfD+hIYiLWG
        ULjztleuQxOSBK5HOnpzmDofnS0KpO4=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-SPXStZlLOfafTd93xE8nLA-1; Tue, 28 Sep 2021 12:37:58 -0400
X-MC-Unique: SPXStZlLOfafTd93xE8nLA-1
Received: by mail-oo1-f70.google.com with SMTP id z23-20020a4ad597000000b0029174f63d3eso24773959oos.18
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 09:37:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=5SCTKeQfv554jeasIa56rvTLlkFOsyYw4BiVgx++QQ8=;
        b=nnA5VmnlpR3bgTh0V8OQycOAswCWKVgHrYimyHHKJlaUXf+XgLb178mwXTdEUzJKtA
         tS4MUp7oRrjHfxAG6w0urP0yk8xdrLVXs/gu72ujCjO3436VPyEp4bEqmq1+5huXu1Ax
         PMBobsBTS4l0o8sexIDFgImNU41kdW30okmkzEJhcyv3lFj+NSCpykSmNuecCIHuPRv5
         wsOezloDUZIR9wyip3snpTdLkJ48YlDl4CVTo+3z7q3lGhmyFF93ngTpVInFLcJl4Dc6
         lnZMt+dOuTFL6Fa9ZS4oTX3FmKVWTh9RTXykZh1ij9XAoFcanPLNIxvabokEbKmRHF08
         wY1Q==
X-Gm-Message-State: AOAM532DYCclpiuUMWHny/NZ03H0Eqh6wfEJaQAmvF/qy+BlXzXASI2l
        SD26RtDUTR/GNDV2afXyxMRj0Pe5MfWBm4saaEfWmjjIncdjoBtFtI2NCB9PDekUj1acRZOe+I2
        K4V74dcMMzsrL
X-Received: by 2002:a9d:6209:: with SMTP id g9mr5882937otj.259.1632847078024;
        Tue, 28 Sep 2021 09:37:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJytNzTK8C3cAee84xf3tGJRqByMjZehD4qb6jfFVSJs3Cl8aeFt9tGR5xD0HbdPEOZUB6s8PA==
X-Received: by 2002:a9d:6209:: with SMTP id g9mr5882920otj.259.1632847077818;
        Tue, 28 Sep 2021 09:37:57 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id 14sm4554856oiy.53.2021.09.28.09.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 09:37:57 -0700 (PDT)
Date:   Tue, 28 Sep 2021 10:37:56 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>, colin.king@canonical.com
Subject: [GIT PULL] VFIO fixes for v5.15-rc4
Message-ID: <20210928103756.4070e4c6.alex.williamson@redhat.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

The following changes since commit e4e737bb5c170df6135a127739a9e6148ee3da82:

  Linux 5.15-rc2 (2021-09-19 17:28:22 -0700)

are available in the Git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-v5.15-rc4

for you to fetch changes up to 42de956ca7e5f6c47048dde640f797e783b23198:

  vfio/ap_ops: Add missed vfio_uninit_group_dev() (2021-09-24 10:04:44 -0600)

----------------------------------------------------------------
VFIO fixes for v5.15-rc4

 - Fix vfio-ap leak on uninit (Jason Gunthorpe)

 - Add missing prototype arg name (Colin Ian King)

----------------------------------------------------------------
Colin Ian King (1):
      vfio/pci: add missing identifier name in argument of function prototype

Jason Gunthorpe (1):
      vfio/ap_ops: Add missed vfio_uninit_group_dev()

 drivers/s390/crypto/vfio_ap_ops.c | 4 +++-
 drivers/vfio/pci/vfio_pci_core.c  | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

