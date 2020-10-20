Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75B392940FD
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 19:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395092AbgJTRBE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 13:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389544AbgJTRBE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 13:01:04 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB08C0613CE
        for <kvm@vger.kernel.org>; Tue, 20 Oct 2020 10:01:03 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id a17so1207774pju.1
        for <kvm@vger.kernel.org>; Tue, 20 Oct 2020 10:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SLjiq3pW5LVJISD8gSWpF8UZ/0csQIwTmjFHfpB8KGQ=;
        b=dDcwSXCOzydk78Lztu+93aKWlVV++2x4fn6ADurjE0nmYUMY3OTsi8b/HGLbIvHHmR
         wGE+3kYadp+qsRdmbCX2qV8gLCpVlHGHoXbOrt9JzPOXo/rqoTZbwIjlKsgNASxlBTHb
         tl/YfgqmLAVupq0bf6Vk4CNoyFAsaDl5e57P6gB5WdTagLSb1RT6rbsMhXQcz0jWjtLZ
         jQn94KeXoj+UuTv2hgguVyoARgOULZ2pvnzwuYNBLdlqxRCJxv9uPShEUKKbFVtaW+zw
         4S4g87U3K8T0Ps3LLJrhtIf84mk5BLXDsbNwEbcGs/RDJqyFGrEdi366TLCyxptCVrat
         ab8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SLjiq3pW5LVJISD8gSWpF8UZ/0csQIwTmjFHfpB8KGQ=;
        b=Z27593FB7fgBcrKZtwHbrPx6IWUb6zDtwUeE048sHDljcdTmETI3YC14ZSi8ttA2io
         Ghp/w5f8/K7i0tzHOtkY+RMHQ3MelCRvtIM37k70kvyH/J6opQr2f+FQST6P1FH/jjp4
         c35UkG/CxUWkgMdPLRePMJyPrRLE/uxfA2gEi93P18ZL68WqYeJr0HjJR2P6bbw0PnMk
         CjgLSY4OZ37+2fHYyAkHgPwFvsavWRXv0nAtlWv0n0cdYZXRUG429d+pbTRAr++AgkFP
         ntvwLJ9cJuGZ0x+yv8AIzUiq1SRD8GjphZHvRz6sjhqlwckpPwPn/8olsh9fBuESjyBV
         CPRQ==
X-Gm-Message-State: AOAM531aQ3TN3zom9KB7aketgzzDzFJvZXnkqEmQz7Py8bPmU6baPvkC
        RvFNesf5AhH7rM6S00EWyfq+OPOYMFw=
X-Google-Smtp-Source: ABdhPJzXgH2W//CCXKxe46Ozb57JxmILIjseYynzoQ2X2SC2duR/Vzet5uVuIs+T4bHdhfZIYOLR9Q==
X-Received: by 2002:a17:90a:f0d7:: with SMTP id fa23mr3634676pjb.108.1603213263248;
        Tue, 20 Oct 2020 10:01:03 -0700 (PDT)
Received: from localhost.localdomain ([103.248.31.132])
        by smtp.googlemail.com with ESMTPSA id x29sm2766161pfp.152.2020.10.20.10.01.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2020 10:01:02 -0700 (PDT)
From:   Amey Narkhede <ameynarkhede03@gmail.com>
To:     qemu-devel@nongnu.org, ameynarkhede03@gmail.com
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 0/2] KVM: Introduce ioeventfd read support
Date:   Tue, 20 Oct 2020 22:30:54 +0530
Message-Id: <20201020170056.433528-1-ameynarkhede03@gmail.com>
X-Mailer: git-send-email 2.28.0
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The first patch updates linux headers to=0D
add ioeventfd read support while the=0D
second patch can be used to test the=0D
ioeventfd read feature with kvm-unit-test=0D
which reads from specified guest addres.=0D
Make sure the address provided in=0D
kvm_set_ioeventfd_read matches with address=0D
in x86/ioeventfd_read test in kvm-unit-tests.=0D
=0D
Amey Narkhede (2):=0D
  linux-headers: Add support for reads in ioeventfd=0D
  kvm: Add ioeventfd read test code=0D
=0D
 accel/kvm/kvm-all.c       | 55 +++++++++++++++++++++++++++++++++++++++=0D
 linux-headers/linux/kvm.h |  5 +++-=0D
 2 files changed, 59 insertions(+), 1 deletion(-)=0D
=0D
-- =0D
2.28.0=0D
=0D
