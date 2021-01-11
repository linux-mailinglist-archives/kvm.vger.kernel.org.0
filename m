Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8192F1987
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 16:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731169AbhAKPVy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 10:21:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43157 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730627AbhAKPVx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Jan 2021 10:21:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610378427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Ucd06r2eJPcCIqt9QCTk/uw4j4Vi5AVfWPojlXh2MWo=;
        b=in1dkHa8UBwH1v4cwuMmfdnOJYCHq5c16Xl2flaViqNK3WrpC17bVR9fZLfdlo1fsu1rCq
        bx3WfGy1663PHc/rnpwRyiFwiX5izWeCbL6jk7uWxrxnBPWPxxbiQcRUlxzuURFVucy04c
        AQ0uPcp9tx2YPiqgTvg3ygwAaFkxDp8=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-6wIwBHTENWyPWPeJWLFAFQ-1; Mon, 11 Jan 2021 10:20:25 -0500
X-MC-Unique: 6wIwBHTENWyPWPeJWLFAFQ-1
Received: by mail-ej1-f70.google.com with SMTP id r26so41459ejx.6
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 07:20:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ucd06r2eJPcCIqt9QCTk/uw4j4Vi5AVfWPojlXh2MWo=;
        b=CDBAEf7HUJ4iN4Ra88+VAvh0F111YGppYkLaU0Ls2zZ0+10ETSmyJBi88tpg0EjSWC
         eqd1NcKrg7TZf1RguhharBVlxxAZZv4RQ6wD3DcwNT8eAJepzImz3Jo/qggNv4yloD7u
         JLkBr+LcAH8Ap6DX0Ky6K593IQao8ef5X3HeiO51EqdQZG2p6mNvCgy26zGncE8rhnd6
         IRZqA31bqpURoAizyhegK2oYtFBqpKrbct41sFPq19K2T5BhEUjr2KcOYZb49WY8JkjU
         V0upGYjDPgtuH/eqOyAJJ4Z8gvNJQ1YO8oUnDuDI4G6/vuuR+AX+3/RWDISxShg52ZZf
         2/Bg==
X-Gm-Message-State: AOAM532kUkS4vsqeJaw2oWPnSDacY73wDjtKDDZjQYFJ3R5UqoMDI1Cl
        KPbIi6eDRuxucP4YK2CrDqXgg01i8tZXlAeAzBYLutKoxaDa0pqicl9qboMMgss98K/K+FU/GOR
        qmbVu6VPvVJhI
X-Received: by 2002:a17:907:e9e:: with SMTP id ho30mr11282826ejc.529.1610378424338;
        Mon, 11 Jan 2021 07:20:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJywxJElqigN/5jUO+VSUtxZXH9MfGPzYtOFdIcNPFnX2mDokjoLqsfHorN2m3Haq800FJrUjA==
X-Received: by 2002:a17:907:e9e:: with SMTP id ho30mr11282789ejc.529.1610378424080;
        Mon, 11 Jan 2021 07:20:24 -0800 (PST)
Received: from x1w.redhat.com (129.red-88-21-205.staticip.rima-tde.net. [88.21.205.129])
        by smtp.gmail.com with ESMTPSA id y17sm7157263ejj.84.2021.01.11.07.20.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 07:20:23 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Huacai Chen <chenhuacai@kernel.org>, Greg Kurz <groug@kaod.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-trivial@nongnu.org,
        Amit Shah <amit@kernel.org>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        qemu-arm@nongnu.org, John Snow <jsnow@redhat.com>,
        qemu-s390x@nongnu.org, Paul Durrant <paul@xen.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Max Reitz <mreitz@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Halil Pasic <pasic@linux.ibm.com>, Fam Zheng <fam@euphon.net>,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Stefano Stabellini <sstabellini@kernel.org>,
        xen-devel@lists.xenproject.org, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>, qemu-block@nongnu.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Laurent Vivier <laurent@vivier.eu>,
        Thomas Huth <thuth@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH 0/2] sysemu: Let VMChangeStateHandler take boolean 'running'
 argument
Date:   Mon, 11 Jan 2021 16:20:18 +0100
Message-Id: <20210111152020.1422021-1-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Trivial prototype change to clarify the use of the 'running'=0D
argument of VMChangeStateHandler.=0D
=0D
Green CI:=0D
https://gitlab.com/philmd/qemu/-/pipelines/239497352=0D
=0D
Philippe Mathieu-Daud=C3=A9 (2):=0D
  sysemu/runstate: Let runstate_is_running() return bool=0D
  sysemu: Let VMChangeStateHandler take boolean 'running' argument=0D
=0D
 include/sysemu/runstate.h   | 12 +++++++++---=0D
 target/arm/kvm_arm.h        |  2 +-=0D
 target/ppc/cpu-qom.h        |  2 +-=0D
 accel/xen/xen-all.c         |  2 +-=0D
 audio/audio.c               |  2 +-=0D
 block/block-backend.c       |  2 +-=0D
 gdbstub.c                   |  2 +-=0D
 hw/block/pflash_cfi01.c     |  2 +-=0D
 hw/block/virtio-blk.c       |  2 +-=0D
 hw/display/qxl.c            |  2 +-=0D
 hw/i386/kvm/clock.c         |  2 +-=0D
 hw/i386/kvm/i8254.c         |  2 +-=0D
 hw/i386/kvmvapic.c          |  2 +-=0D
 hw/i386/xen/xen-hvm.c       |  2 +-=0D
 hw/ide/core.c               |  2 +-=0D
 hw/intc/arm_gicv3_its_kvm.c |  2 +-=0D
 hw/intc/arm_gicv3_kvm.c     |  2 +-=0D
 hw/intc/spapr_xive_kvm.c    |  2 +-=0D
 hw/misc/mac_via.c           |  2 +-=0D
 hw/net/e1000e_core.c        |  2 +-=0D
 hw/nvram/spapr_nvram.c      |  2 +-=0D
 hw/ppc/ppc.c                |  2 +-=0D
 hw/ppc/ppc_booke.c          |  2 +-=0D
 hw/s390x/tod-kvm.c          |  2 +-=0D
 hw/scsi/scsi-bus.c          |  2 +-=0D
 hw/usb/hcd-ehci.c           |  2 +-=0D
 hw/usb/host-libusb.c        |  2 +-=0D
 hw/usb/redirect.c           |  2 +-=0D
 hw/vfio/migration.c         |  2 +-=0D
 hw/virtio/virtio-rng.c      |  2 +-=0D
 hw/virtio/virtio.c          |  2 +-=0D
 net/net.c                   |  2 +-=0D
 softmmu/memory.c            |  2 +-=0D
 softmmu/runstate.c          |  4 ++--=0D
 target/arm/kvm.c            |  2 +-=0D
 target/i386/kvm/kvm.c       |  2 +-=0D
 target/i386/sev.c           |  2 +-=0D
 target/i386/whpx/whpx-all.c |  2 +-=0D
 target/mips/kvm.c           |  4 ++--=0D
 ui/gtk.c                    |  2 +-=0D
 ui/spice-core.c             |  2 +-=0D
 41 files changed, 51 insertions(+), 45 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

