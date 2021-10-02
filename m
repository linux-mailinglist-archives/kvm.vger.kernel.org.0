Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D539A41FBE1
	for <lists+kvm@lfdr.de>; Sat,  2 Oct 2021 14:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233209AbhJBMzJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Oct 2021 08:55:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59300 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232823AbhJBMzI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 2 Oct 2021 08:55:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633179201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Ib9ELo2khl9yldyMRwflp0UN303ciEAFS7yOmdsrtJM=;
        b=DAKxbi0BMvpZNO/Fya7VAAg4PwH86pPmvta7pLZmkJIFdUizGxzYwJ2PK7tLJ2Ut3QjVZp
        W75/PYDzn8rQLy98ySQ8oYxCkYEbvq8OqulLAij8MD8Tigjnv/4jLgiQZZHtY4KPjpMVg/
        rTuvGGbunhDzmegeQOebs12dr5Lbs9Y=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-3dizRT_yOrqXiNBruNabVQ-1; Sat, 02 Oct 2021 08:53:21 -0400
X-MC-Unique: 3dizRT_yOrqXiNBruNabVQ-1
Received: by mail-wm1-f72.google.com with SMTP id 10-20020a05600c240a00b0030d403f24e2so3204248wmp.9
        for <kvm@vger.kernel.org>; Sat, 02 Oct 2021 05:53:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ib9ELo2khl9yldyMRwflp0UN303ciEAFS7yOmdsrtJM=;
        b=MY5AYZNNX3uNw/wHiQiHDBY5THjVcKgugA8SP/wEcOAMpyNrtAoRe50NbHtx1pEGNE
         QNfaYKcosnk+pV4ZmfYQhkBE0CKnMhVHpkG1PEyH6v18aZBuFocVU5AwpB2QoeYrFoZh
         NkU1iTOpG3i+BHSUjmYj43YRf5HNdFMBZPrkH1yZBvxYKFek7XekHbSRG7Z6jEwgI7gs
         6YzXAX0QBmOtTOHyOXM582M3SPdNsqhyN/LfTCWzso5a/+4/SqL/aGQwYp6TrWiT/6FK
         CMc2ftFFXpW6eTlC5WJscq7DygcE4ishVlo7D1BvqOX6kQoGrEJkRYVNRUAi/bTz6qxM
         umjg==
X-Gm-Message-State: AOAM531u29TGHmL0wm6J+EiGkVyBRC96bsnDlH4ST0uRnhU7VBBRFUaZ
        a8HVz4JG9XetxSup4QVGHQfnayyxNgpLRQN5Y8Qf2kkIz/tH4GLz/C7MQyGY6kbNNYqxIjT5Ph8
        1HvlCFYEmuKyZ
X-Received: by 2002:adf:8bcf:: with SMTP id w15mr3445863wra.144.1633179199568;
        Sat, 02 Oct 2021 05:53:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxmJJVJtij1cYhaOoS1a2n3oM4h81AupX1+DD9gs6imh/k3aWK6DwR8Pisb94OyZBbpntRePg==
X-Received: by 2002:adf:8bcf:: with SMTP id w15mr3445845wra.144.1633179199336;
        Sat, 02 Oct 2021 05:53:19 -0700 (PDT)
Received: from x1w.. (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id i2sm8378777wrq.78.2021.10.02.05.53.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 05:53:18 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Sergio Lopez <slp@redhat.com>, kvm@vger.kernel.org,
        James Bottomley <jejb@linux.ibm.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "Daniel P . Berrange" <berrange@redhat.com>
Subject: [PATCH v3 00/22] target/i386/sev: Housekeeping SEV + measured Linux SEV guest
Date:   Sat,  2 Oct 2021 14:52:55 +0200
Message-Id: <20211002125317.3418648-1-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,=0D
=0D
While testing James & Dov patch:=0D
https://www.mail-archive.com/qemu-devel@nongnu.org/msg810571.html=0D
I wasted some time trying to figure out how OVMF was supposed to=0D
behave until realizing the binary I was using was built without SEV=0D
support... Then wrote this series to help other developers to not=0D
hit the same problem.=0D
=0D
Since v2:=0D
- Rebased on top of SGX=0D
- Addressed review comments from Markus / David=0D
- Included/rebased 'Measured Linux SEV guest' from Dov [1]=0D
- Added orphean MAINTAINERS section=0D
=0D
[1] https://lore.kernel.org/qemu-devel/20210825073538.959525-1-dovmurik@lin=
ux.ibm.com/=0D
=0D
Supersedes: <20210616204328.2611406-1-philmd@redhat.com>=0D
=0D
Dov Murik (2):=0D
  sev/i386: Introduce sev_add_kernel_loader_hashes for measured linux=0D
    boot=0D
  x86/sev: generate SEV kernel loader hashes in x86_load_linux=0D
=0D
Dr. David Alan Gilbert (1):=0D
  target/i386/sev: sev_get_attestation_report use g_autofree=0D
=0D
Philippe Mathieu-Daud=C3=A9 (19):=0D
  qapi/misc-target: Wrap long 'SEV Attestation Report' long lines=0D
  qapi/misc-target: Group SEV QAPI definitions=0D
  target/i386/kvm: Introduce i386_softmmu_kvm Meson source set=0D
  target/i386/kvm: Restrict SEV stubs to x86 architecture=0D
  target/i386/monitor: Return QMP error when SEV is disabled in build=0D
  target/i386/cpu: Add missing 'qapi/error.h' header=0D
  target/i386/sev_i386.h: Remove unused headers=0D
  target/i386/sev: Remove sev_get_me_mask()=0D
  target/i386/sev: Mark unreachable code with g_assert_not_reached()=0D
  target/i386/sev: Restrict SEV to system emulation=0D
  target/i386/sev: Declare system-specific functions in 'sev_i386.h'=0D
  target/i386/sev: Remove stubs by using code elision=0D
  target/i386/sev: Move qmp_query_sev_attestation_report() to sev.c=0D
  target/i386/sev: Move qmp_sev_inject_launch_secret() to sev.c=0D
  target/i386/sev: Move qmp_query_sev_capabilities() to sev.c=0D
  target/i386/sev: Move qmp_query_sev_launch_measure() to sev.c=0D
  target/i386/sev: Move qmp_query_sev() & hmp_info_sev() to sev.c=0D
  monitor: Restrict 'info sev' to x86 targets=0D
  MAINTAINERS: Cover AMD SEV files=0D
=0D
 qapi/misc-target.json                 |  77 ++++----=0D
 include/monitor/hmp-target.h          |   1 +=0D
 include/monitor/hmp.h                 |   1 -=0D
 include/sysemu/sev.h                  |  20 +-=0D
 target/i386/sev_i386.h                |  32 +--=0D
 hw/i386/pc_sysfw.c                    |   2 +-=0D
 hw/i386/x86.c                         |  25 ++-=0D
 target/i386/cpu.c                     |  17 +-=0D
 {accel =3D> target/i386}/kvm/sev-stub.c |   0=0D
 target/i386/monitor.c                 |  92 +--------=0D
 target/i386/sev-stub.c                |  83 --------=0D
 target/i386/sev-sysemu-stub.c         |  70 +++++++=0D
 target/i386/sev.c                     | 268 +++++++++++++++++++++++---=0D
 MAINTAINERS                           |   7 +=0D
 accel/kvm/meson.build                 |   1 -=0D
 target/i386/kvm/meson.build           |   8 +-=0D
 target/i386/meson.build               |   4 +-=0D
 17 files changed, 438 insertions(+), 270 deletions(-)=0D
 rename {accel =3D> target/i386}/kvm/sev-stub.c (100%)=0D
 delete mode 100644 target/i386/sev-stub.c=0D
 create mode 100644 target/i386/sev-sysemu-stub.c=0D
=0D
-- =0D
2.31.1=0D
=0D

