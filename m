Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C04012AB3E2
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 10:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728335AbgKIJpv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 04:45:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbgKIJpv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 04:45:51 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B0FC0613CF
        for <kvm@vger.kernel.org>; Mon,  9 Nov 2020 01:45:51 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id c17so7927427wrc.11
        for <kvm@vger.kernel.org>; Mon, 09 Nov 2020 01:45:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/q4o4BiIHWmBVIAtODv3UPM1kTXJig1tzzvjpmqNPpQ=;
        b=oXshjwy58XW4nOnK2QAPSmctnhXSDSl84kEoQ/WCKipy06AHZ7PgRMlNZ9hsm0s1di
         VgEos8EY3M3ciaUyFZvpsPreZAZiHxeSxc6x6l3hGQ02CKFw4tDnfvt/QDIJtvC16Q1x
         2btmMTcMltfDe60QRCx0l86+61soNuNi2eFeuw+eJmAq/7Zz8fWDeXf2vn70KfTg/QJ8
         diVMFr0Q2mB1S7ZZXhOMZ2o3+ik1AyJqb8Eju4WuOxxkxWPOTrq2yXrIVMWhrCDyfX7e
         qpcoYWKnji1/wQncrGWsAcMDj9FqnaeV+ZPLH4RE2gFRTFlAsgrP16o9JdTg6o4Hez8H
         MYbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=/q4o4BiIHWmBVIAtODv3UPM1kTXJig1tzzvjpmqNPpQ=;
        b=aFJiUNkeAgI+ca/LN7H6btnqH9q4PcZCbwiy2eZjMT4LVZ4VyU0untv2sF9Fig/Eq/
         w5Oh6H/B+vXSmGecjMxxbsHYu8oy7OObFlSIquZbIssk8EVh6l2vk//Db/vShIBQS3n/
         964Oz3w1UuyIBSxuClt+xR6LnP6UC7ee+zgtor7PDzKipxzqbuvaDxQ+dPPsW2qrTQcS
         F8w+q3Uu1oUKE7cu85MJx5urdsEmFXWfHPNNRjKoyyPSelMHl8koa3K7YJUKxpcoMnfR
         yyWoassQmORWUXb+SB7oOeSuZvDz2Nm+2MShsMtHKUwQzZk3YqMhathQBIOsZ5Q3a6HW
         o9lw==
X-Gm-Message-State: AOAM53337uXaLOdLRPYZ48gDYZ3ttskdykPJ28tCzEsHf+S5yYWEh8p9
        X3UJObiLW+kEEaimt3enpcVWVjT+TB4=
X-Google-Smtp-Source: ABdhPJypYLA8yDC42PAwQMJL5W7KWz1kEYPcRWXSp9aw20JGITNOoQXvJA/WTqE4S6Ta7XEGPjE77w==
X-Received: by 2002:a5d:4e0e:: with SMTP id p14mr16615971wrt.160.1604915149678;
        Mon, 09 Nov 2020 01:45:49 -0800 (PST)
Received: from localhost.localdomain (234.red-83-42-66.dynamicip.rima-tde.net. [83.42.66.234])
        by smtp.gmail.com with ESMTPSA id u81sm13094834wmb.27.2020.11.09.01.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 01:45:49 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH 0/3] accel: Remove system-mode stubs from user-mode builds
Date:   Mon,  9 Nov 2020 10:45:44 +0100
Message-Id: <20201109094547.2456385-1-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is pointless to build/link these stubs into user-mode binaries.=0D
=0D
Philippe Mathieu-Daud=C3=A9 (3):=0D
  accel: Only include TCG stubs in user-mode only builds=0D
  accel/stubs: Restrict system-mode emulation stubs=0D
  accel/stubs: Simplify kvm-stub.c=0D
=0D
 accel/stubs/kvm-stub.c  |  5 -----=0D
 accel/meson.build       | 10 ++++++----=0D
 accel/stubs/meson.build | 12 ++++++++----=0D
 3 files changed, 14 insertions(+), 13 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D
