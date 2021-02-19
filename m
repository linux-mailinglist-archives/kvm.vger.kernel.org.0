Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB7E31F88E
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 12:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbhBSLqH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 06:46:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23637 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230222AbhBSLqB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Feb 2021 06:46:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613735074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=aBiPAh6j0La2jswV89eyq5qlhizmmpayYHhAIblEKKQ=;
        b=C3zKWfLM5MrEwuKltoQbAerZTNU10TdB5xlVeMHOPbAwOBbCFMaGXH4AIQWpKacL10xc3n
        AXLe1gQwxvq63XAdmpVJaLA1ZtPnVLVUURz9jkQkYW/jxdFSb08dl7mCSIb9WefJF6K5/Y
        cYZE4ARBil08WZMsq7RsDWL/a7h3kQM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-_O25KnmQMwSLdq4cLQsL9Q-1; Fri, 19 Feb 2021 06:44:32 -0500
X-MC-Unique: _O25KnmQMwSLdq4cLQsL9Q-1
Received: by mail-wr1-f69.google.com with SMTP id f5so2346977wro.7
        for <kvm@vger.kernel.org>; Fri, 19 Feb 2021 03:44:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aBiPAh6j0La2jswV89eyq5qlhizmmpayYHhAIblEKKQ=;
        b=BNGKl+cXE5+FvpH7zQFQJaZbS7QZNTer5Rf+PpbuGvADrS0cKsnxTt9oWXzuGkMYbl
         Ga1ZSg8An0itDA9DTsqtU+F59Cf+Kb4RtyvriW6NCP1R1yQAluxQRWBjd+BTVfsGmaNZ
         cMl8TdULBHJztT363LW9z81kuk0lu5HMJpaFL9Ax5s/ZHx0a6LfXVGJ2Pi9+pxC3TWxi
         N+2Vj/QsxaC9oQKv4tOLJZvsffvCjoaP5togJb4awoQE4B3lyXVeq28TWZcRuzuI0ZVh
         DScxk1vHxExJnvfnLiW62UjpW/kPJF0x2Hl7hSVC6ZV4vKVcMrRf22U9cXMlXeZ/fy8k
         fKZQ==
X-Gm-Message-State: AOAM533sn1Qg1nK+VWYU1sDCD6B83o6PI/Nb7WDHTCc+8r5ttWa4p5wY
        mnuLJWSk2FnC34qq9MTvR7b+mAnWVjJyHzgcleymK5fa579tqjK99yVuQZmhXQzFlNL/DXu1JnW
        NBeshOC05TvyK
X-Received: by 2002:a05:600c:8a2:: with SMTP id l34mr7983459wmp.4.1613735071626;
        Fri, 19 Feb 2021 03:44:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzCQmJUMzqBp58GRknzlFcK+50J5x/1xbRxspDX0PSKwBAjo2a1yxhfME/pP4E86Lbkjw1cYw==
X-Received: by 2002:a05:600c:8a2:: with SMTP id l34mr7983425wmp.4.1613735071474;
        Fri, 19 Feb 2021 03:44:31 -0800 (PST)
Received: from localhost.localdomain (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id l17sm1537098wmq.46.2021.02.19.03.44.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 03:44:31 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Radoslaw Biernacki <rad@semihalf.com>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-s390x@nongnu.org,
        Greg Kurz <groug@kaod.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        qemu-arm@nongnu.org, Cornelia Huck <cohuck@redhat.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        BALATON Zoltan <balaton@eik.bme.hu>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Leif Lindholm <leif@nuviainc.com>,
        Alistair Francis <alistair@alistair23.me>,
        Thomas Huth <thuth@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, qemu-ppc@nongnu.org,
        =?UTF-8?q?Herv=C3=A9=20Poussineau?= <hpoussin@reactos.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH 0/7] hw/kvm: Exit gracefully when KVM is not supported
Date:   Fri, 19 Feb 2021 12:44:21 +0100
Message-Id: <20210219114428.1936109-1-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,=0D
=0D
This series aims to improve user experience by providing=0D
a better error message when the user tries to enable KVM=0D
on machines not supporting it.=0D
=0D
Regards,=0D
=0D
Phil.=0D
=0D
Philippe Mathieu-Daud=C3=A9 (7):=0D
  accel/kvm: Check MachineClass kvm_type() return value=0D
  hw/boards: Introduce 'kvm_supported' field to MachineClass=0D
  hw/arm: Set kvm_supported for KVM-compatible machines=0D
  hw/mips: Set kvm_supported for KVM-compatible machines=0D
  hw/ppc: Set kvm_supported for KVM-compatible machines=0D
  hw/s390x: Set kvm_supported to s390-ccw-virtio machines=0D
  accel/kvm: Exit gracefully when KVM is not supported=0D
=0D
 include/hw/boards.h        |  6 +++++-=0D
 accel/kvm/kvm-all.c        | 12 ++++++++++++=0D
 hw/arm/sbsa-ref.c          |  1 +=0D
 hw/arm/virt.c              |  1 +=0D
 hw/arm/xlnx-versal-virt.c  |  1 +=0D
 hw/mips/loongson3_virt.c   |  1 +=0D
 hw/mips/malta.c            |  1 +=0D
 hw/ppc/e500plat.c          |  1 +=0D
 hw/ppc/mac_newworld.c      |  1 +=0D
 hw/ppc/mac_oldworld.c      |  1 +=0D
 hw/ppc/mpc8544ds.c         |  1 +=0D
 hw/ppc/ppc440_bamboo.c     |  1 +=0D
 hw/ppc/prep.c              |  1 +=0D
 hw/ppc/sam460ex.c          |  1 +=0D
 hw/ppc/spapr.c             |  1 +=0D
 hw/s390x/s390-virtio-ccw.c |  1 +=0D
 16 files changed, 31 insertions(+), 1 deletion(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

