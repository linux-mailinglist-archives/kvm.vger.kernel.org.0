Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 629D4204D63
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 11:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731887AbgFWJGb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 05:06:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41875 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731853AbgFWJGb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 05:06:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592903190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=2m2t021fPmocAk1w7rK7jsWgzV0rCiGfOdB2/ye3op0=;
        b=Z3WPbkWa0GYOkXZrKU+fTLtQfh/G+LQZweUSyTp/qomHywbrBC5UrxLh2cqApqwAMBV/3h
        NyYKDvU2mcQeuj1RzKHmqeSw6vaYrclqUcSyTs07KeiAgsUXso55j+Cyhe1hIZOes5kByT
        y/Gfy5npXwqTLlG0m+Dz//8YqcwOVuE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-T0zFWbBlPtu4sQnB7G7MKA-1; Tue, 23 Jun 2020 05:06:26 -0400
X-MC-Unique: T0zFWbBlPtu4sQnB7G7MKA-1
Received: by mail-wr1-f71.google.com with SMTP id y13so1388798wrp.13
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 02:06:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2m2t021fPmocAk1w7rK7jsWgzV0rCiGfOdB2/ye3op0=;
        b=Kxzq9TFWi9lUTNr8UdZE58C02WmGuerKUur6+ncKHZIa6nYNBDL7pOYOT0iFH2qm4Z
         ZGwZC4HWKuQgsSBM1OHHHulXNgFNNKSdR1DuL8+WUUd7wb/Z9RXdZhxARb3JfYYBzVMj
         qTE/XzxRCL3F9JKj/RNFyZcbBzzzGbD6KAwutDltAzhnjx3OOEYxUULFfxozK8jWEdn1
         0Qp+w9MxZBVNPzrg9ZEqS8qPZcG2QKKkCWud+vASlYIZAY4yFHUtHlREATHQky7RPqCA
         6iHpqTEXt6OJJ/oP0gx6HBpQ5FpWSQXo0RP37mRnjNqGgS0aInMxvp5v2eUgIzrhOFjN
         BpMw==
X-Gm-Message-State: AOAM532ykM8i+dRaJ623t7FOFphSyBOLT2Ubkhfchou7zT+N1HGPZ2eB
        W/Wkn6iVtCXYd/ux6kBYCPZk8cgxvDccMxgDN/X9/D44+YN2A0Yc5ikJXPwj7WbPPXW2MjS/rFs
        cpNNpb8D1WX4y
X-Received: by 2002:a05:6000:100c:: with SMTP id a12mr11437348wrx.81.1592903185144;
        Tue, 23 Jun 2020 02:06:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyZP10WQPOHMp4i3NHPCCa9B8KmGvXoITH2SZ5LSo0WtmaCkCiIGpy/qn/H3k+WRHf/tocWQg==
X-Received: by 2002:a05:6000:100c:: with SMTP id a12mr11437320wrx.81.1592903184970;
        Tue, 23 Jun 2020 02:06:24 -0700 (PDT)
Received: from localhost.localdomain (1.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.1])
        by smtp.gmail.com with ESMTPSA id b19sm2951554wmj.0.2020.06.23.02.06.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 02:06:24 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     qemu-arm@nongnu.org, Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        Andrew Jones <drjones@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH v3 0/2] target/arm: Fix using pmu=on on KVM
Date:   Tue, 23 Jun 2020 11:06:20 +0200
Message-Id: <20200623090622.30365-1-philmd@redhat.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since v2:
- include Drew test fix (addressed Peter review comments)
- addressed Drew review comments
- collected R-b/A-b

Andrew Jones (1):
  tests/qtest/arm-cpu-features: Add feature setting tests

Philippe Mathieu-Daudé (1):
  target/arm: Check supported KVM features globally (not per vCPU)

 target/arm/kvm_arm.h           | 21 ++++++++-----------
 target/arm/cpu.c               |  2 +-
 target/arm/cpu64.c             | 10 ++++-----
 target/arm/kvm.c               |  4 ++--
 target/arm/kvm64.c             | 14 +++++--------
 tests/qtest/arm-cpu-features.c | 38 ++++++++++++++++++++++++++++++----
 6 files changed, 56 insertions(+), 33 deletions(-)

-- 
2.21.3

