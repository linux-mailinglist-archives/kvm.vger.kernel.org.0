Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D07263DF8
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 09:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730400AbgIJHFE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 03:05:04 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:43406 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730225AbgIJHBx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Sep 2020 03:01:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599721297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Y1vGmD/fvsXEOWa6wkRKs3aLydzIceOGg7Tbh5f+UXQ=;
        b=GWjYsRTrA+NnxLIECRMVdbYv0rX9n/OjSIMEmuL36MAooVd+C2d5d/Mmtc20YCUQh2dHe7
        uznluxpwZIPTOi4BwtjK7RhVkJ3zwmoGwPkbZO7xGDBqfqJ0ZTZzX53Q4BH1W0hQ2kH9Uy
        //26XvyVJxHD7EUN7bpJLF09yCgSWwo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-2JdGbL8qNYy-AdHQrg1j7Q-1; Thu, 10 Sep 2020 03:01:35 -0400
X-MC-Unique: 2JdGbL8qNYy-AdHQrg1j7Q-1
Received: by mail-wm1-f72.google.com with SMTP id k12so551651wmj.1
        for <kvm@vger.kernel.org>; Thu, 10 Sep 2020 00:01:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y1vGmD/fvsXEOWa6wkRKs3aLydzIceOGg7Tbh5f+UXQ=;
        b=CtKLpr6IFbIVKVR8Vm1to7NuqVhqB9/S89/K0MdorF+FzlnkMoKINPjTeoCgEJ2t/7
         mFBfPZ1oIZUsYY1iMnzTuT8VtzaPsloabTubz7dImSPorluLO+IS2qojQ9SR2Rwji9rj
         j4h6FsGrpz0Fj39ClR5+s1hFXns0SC7WhFGAmwKks0dJ5PGQgq6ZTYEJxWUkxNRQXkIx
         PFz1lyPBXvhJ0DJ1wipAaf0I9wM0oH0M1OHmgg9OpgWF6FyCuBiC5MOsRzz5wMde35qg
         zkIrMnL1JqcRQQ1Ic1IRQZqykyb2tW50CkNbZJVxjmlkqN6SbU5vG0/Y/G9AnpuLDNco
         PQeg==
X-Gm-Message-State: AOAM530uspX5ELhrsm90YeIS4Z2ON99PVSb9UalEKtY8RtqtG3+/NRhZ
        gAxhCZx25nRmOJsRXpzYInaa1PqTBqo1EYMQOZrAqTMHkzlvc8QL7rArBnjfYb5i3Cm+rJd90k3
        LmP0PdwwKnixW
X-Received: by 2002:adf:f2d0:: with SMTP id d16mr7037146wrp.332.1599721294399;
        Thu, 10 Sep 2020 00:01:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxOgVJywoHM/rmr+qzXsusn/6m5n3bTGfi1VzgpHQxefWx1TwErPpn8kQ+0ho5qhfDSLK+sVw==
X-Received: by 2002:adf:f2d0:: with SMTP id d16mr7037127wrp.332.1599721294215;
        Thu, 10 Sep 2020 00:01:34 -0700 (PDT)
Received: from x1w.redhat.com (65.red-83-57-170.dynamicip.rima-tde.net. [83.57.170.65])
        by smtp.gmail.com with ESMTPSA id c14sm7314726wrv.12.2020.09.10.00.01.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 00:01:33 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, qemu-arm@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        Jason Wang <jasowang@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        qemu-trivial@nongnu.org, Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Joel Stanley <joel@jms.id.au>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH 0/6] misc: Some inclusive terminology changes
Date:   Thu, 10 Sep 2020 09:01:25 +0200
Message-Id: <20200910070131.435543-1-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We don't have (yet?) inclusive terminology guidelines,
but the PCI hole memory is not "black", the DMA sources
don't stream to "slaves", and there isn't really a TSX
"black" list, we only check for broken fields.

As this terms can be considered offensive, and changing
them is a no-brain operation, simply do it.

Philippe Mathieu-Daudé (6):
  hw/ssi/aspeed_smc: Rename max_slaves as max_devices
  hw/core/stream: Rename StreamSlave as StreamSink
  hw/dma/xilinx_axidma: Rename StreamSlave as StreamSink
  hw/net/xilinx_axienet: Rename StreamSlave as StreamSink
  hw/pci-host/q35: Rename PCI 'black hole as '(memory) hole'
  target/i386/kvm: Rename host_tsx_blacklisted() as host_tsx_broken()

 include/hw/pci-host/q35.h     |  4 +--
 include/hw/ssi/aspeed_smc.h   |  2 +-
 include/hw/ssi/xilinx_spips.h |  2 +-
 include/hw/stream.h           | 46 +++++++++++++--------------
 hw/core/stream.c              | 20 ++++++------
 hw/dma/xilinx_axidma.c        | 58 +++++++++++++++++------------------
 hw/net/xilinx_axienet.c       | 44 +++++++++++++-------------
 hw/pci-host/q35.c             | 38 +++++++++++------------
 hw/ssi/aspeed_smc.c           | 40 ++++++++++++------------
 hw/ssi/xilinx_spips.c         |  2 +-
 target/i386/kvm.c             |  4 +--
 tests/qtest/q35-test.c        |  2 +-
 12 files changed, 131 insertions(+), 131 deletions(-)

-- 
2.26.2

