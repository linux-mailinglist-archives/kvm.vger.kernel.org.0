Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D565339A913
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 19:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhFCRYc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 13:24:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21124 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232267AbhFCRY0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Jun 2021 13:24:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622740960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=aHpBelIcGziVZRjX50HNqyKbhuaMC/JWW1ZKekLkz48=;
        b=cFQgGKqeMq5N8yDh95Z9R0xHcpDQrIZMf5z/A8JagCX8RPGLqWwxgnZ8HBsmzstPS7EhLo
        PIdlQMDsDb/8cvjy05XAGk3j45K/0jyVjUtaMppW3wWB0ijGOjHfOjhhVVfvNEcqVMbn7x
        bN3iXvsCOrbn47PBj5PXIJ8qf4D3osQ=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-vBu7p3cyP6641y-Mw31L4g-1; Thu, 03 Jun 2021 13:22:39 -0400
X-MC-Unique: vBu7p3cyP6641y-Mw31L4g-1
Received: by mail-oo1-f70.google.com with SMTP id c25-20020a4ad7990000b029020e67cc1879so3924824oou.18
        for <kvm@vger.kernel.org>; Thu, 03 Jun 2021 10:22:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=aHpBelIcGziVZRjX50HNqyKbhuaMC/JWW1ZKekLkz48=;
        b=dMFC9Yl50EvHJi0MluDQy65gpFLC1/IU+O9AlUW8C6srojLF6n7A7vp4NV/1Vu99Lt
         HG8eIrKNIitJfUKmpw117WmMAoCKz9twJF7B16qo8nBPxBp0a+ia09TlDRwIYUFNrb4B
         8kQ+2dJ8EN6XyC3PQyIiksQC+ci3Yq8zypPluHg8PIX9u4wTFYiHK4jidJY4I8nMj+cf
         OCNI3QU6DIZgtYAxSylyJ+SR+9/Qx9CkuWMA+Dz4awKl+Wu8EYZdmeLjxPNH6d1YbrrH
         WV0Ie5RbW3WmQKDYX7iw9XqCnCunSgWG2+6+lIKzJtXCMqRc/O3d1GQaslIgJB1WhSGI
         sO2A==
X-Gm-Message-State: AOAM530jrd2pZCwiV2KsGGdpcFz00c16Rv4gMuCCMFqCE7yfyGEQdMm+
        lFODJqglM2vKVN+i/HlGz8aa9cfWPrgmiTfzt6X6sUEuD+czNArllgOMkFBG6Wl8htvzUL1a4u+
        66ukjT/D4KXR0
X-Received: by 2002:a4a:55c1:: with SMTP id e184mr286055oob.74.1622740958679;
        Thu, 03 Jun 2021 10:22:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzWIJ6FthiCRVzxgagPFmBEKINqHxxlflAKjGADOX+m7iPOMGXQLstOybZQVabNpnfI65ro3w==
X-Received: by 2002:a4a:55c1:: with SMTP id e184mr286039oob.74.1622740958468;
        Thu, 03 Jun 2021 10:22:38 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id p1sm847639otk.58.2021.06.03.10.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 10:22:38 -0700 (PDT)
Date:   Thu, 3 Jun 2021 11:22:37 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [GIT PULL] VFIO fixes for v5.13-rc5
Message-ID: <20210603112237.42b620c1.alex.williamson@redhat.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

The following changes since commit d07f6ca923ea0927a1024dfccafc5b53b61cfecc:

  Linux 5.13-rc2 (2021-05-16 15:27:44 -0700)

are available in the Git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-v5.13-rc5

for you to fetch changes up to dc51ff91cf2d1e9a2d941da483602f71d4a51472:

  vfio/platform: fix module_put call in error flow (2021-05-24 13:40:13 -0600)

----------------------------------------------------------------
VFIO fixes for v5.13-rc5

 - Fix error path return value (Zhen Lei)

 - Add vfio-pci CONFIG_MMU dependency (Randy Dunlap)

 - Replace open coding with struct_size() (Gustavo A. R. Silva)

 - Fix sample driver error path (Wei Yongjun)

 - Fix vfio-platform error path module_put() (Max Gurtovoy)

----------------------------------------------------------------
Gustavo A. R. Silva (1):
      vfio/iommu_type1: Use struct_size() for kzalloc()

Max Gurtovoy (1):
      vfio/platform: fix module_put call in error flow

Randy Dunlap (1):
      vfio/pci: zap_vma_ptes() needs MMU

Wei Yongjun (1):
      samples: vfio-mdev: fix error handing in mdpy_fb_probe()

Zhen Lei (1):
      vfio/pci: Fix error return code in vfio_ecap_init()

 drivers/vfio/pci/Kconfig                     |  1 +
 drivers/vfio/pci/vfio_pci_config.c           |  2 +-
 drivers/vfio/platform/vfio_platform_common.c |  2 +-
 drivers/vfio/vfio_iommu_type1.c              |  2 +-
 samples/vfio-mdev/mdpy-fb.c                  | 13 +++++++++----
 5 files changed, 13 insertions(+), 7 deletions(-)

