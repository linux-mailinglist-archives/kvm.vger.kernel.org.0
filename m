Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED3912E1107
	for <lists+kvm@lfdr.de>; Wed, 23 Dec 2020 02:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbgLWBJe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Dec 2020 20:09:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbgLWBJe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Dec 2020 20:09:34 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A404C0613D6
        for <kvm@vger.kernel.org>; Tue, 22 Dec 2020 17:08:53 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id y23so4561432wmi.1
        for <kvm@vger.kernel.org>; Tue, 22 Dec 2020 17:08:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ECso56Xc8gg3DWYGpGZLWGbsXUs03FGYbkNr2pEUBUI=;
        b=cdcIKhtLZT9+NKhpn/mN1e9X11O/WJHWl5yNw930VVxF0aFNKo5tlvOV7L2x4iK4sN
         PBV7RyVNakPSeErtz54aWxCeDgnxY8hQi0jgpsSEMjetaMwMYyTfiQQNsD3lnJ88wbsn
         F8hEsvn5wJd3gjRSspkEWrx807wJREwTkehukfybAh1QoL8sXsg81XxN70jwb8ESPsPp
         ZLqW1H/Qr3FK2HiWuNT4ifEeeOBzuw2qU5eydpCqkbstQI0Jqk8XcP4rzuoCIUpwdjfq
         ZMuoRRX2I5zV2GGSoOE8hCE6+Pkrb1C3Ct1fffW1NaqXEeZwiB1lvJ8+eiRcgXJc3+vi
         F9xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=ECso56Xc8gg3DWYGpGZLWGbsXUs03FGYbkNr2pEUBUI=;
        b=HVMQHszjgfCHpp5gKqTX41vtWl3hEsQAWH2D6si+T5FOH19Fgh+1cuxWjr9lrnqpfO
         SXJ6DPRVT8ufnZ59FXaZ9B3G2aQgs6zNwvBgWkPiU+MvbHY8JIYmj8nSub4NBIvNHift
         HkwyGAb7l3ktnapkXpXHy+twoP9KhbC9a/YUyI4e++uIbQkSM1HTzjTjWKIQV/g0g3wV
         4hMghbc8sc09EhTwCXJKh0ula9VsKtRL8i5DbJF3Ysyz14bB0aYbwMBh3fWfLsDlnu2j
         Eo4yU10TT6MYVH2awao3H3c7mtz+Az5ylh0O0vbXjOcY350YShKRz/Q9zT4klyQQDtkQ
         8NUg==
X-Gm-Message-State: AOAM53096NmQsCS3TIko7vAuepvmGIYT3ikran9DFtuyLYXoFmYRAicM
        sJ5nM2jj9J8Rn4lr6h5d9JO4aEgFBEs=
X-Google-Smtp-Source: ABdhPJyca1sK5K7n20dza05betg8clXJGI8tC1d2IzTBKazUx1h0kHUrHCEBayRAt9bytRth+rx7WQ==
X-Received: by 2002:a05:600c:250:: with SMTP id 16mr8099807wmj.6.1608685732199;
        Tue, 22 Dec 2020 17:08:52 -0800 (PST)
Received: from avogadro.lan ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id h83sm30995047wmf.9.2020.12.22.17.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 17:08:51 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com
Subject: [RFC PATCH kvm-unit-tests 0/4] add generic stress test
Date:   Wed, 23 Dec 2020 02:08:46 +0100
Message-Id: <20201223010850.111882-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This short series adds a generic stress test to KVM unit tests that runs a
series of

The test could grow a lot more features, including:

- wrapping the stress test with a VMX or SVM veneer which would forward
  or inject interrupts periodically

- test perf events

- do some work in the MSI handler, so that they have a chance
  of overlapping

- use PV EOI

- play with TPR and self IPIs, similar to Windows DPCs.

The configuration of the test is set individually for each VCPU on
the command line, for example:

   ./x86/run x86/chaos.flat -smp 2 \
      -append 'invtlb=1,mem=12,hz=100  hz=250,edu=1,edu_hz=53,hlt' -device edu

runs a continuous INVLPG+write test on 1<<12 pages on CPU 0, interrupted
by a 100 Hz timer tick; and keeps CPU 1 mostly idle except for 250 timer
ticks and 53 edu device interrupts per second.

For now, the test runs for an infinite time so it's not included in
unittests.cfg.  Do you think this is worth including in kvm-unit-tests,
and if so are you interested in non-x86 versions of it?  Or should the
code be as pluggable as possible to make it easier to port it?

Thanks,

Paolo

Paolo Bonzini (4):
  libcflat: add a few more runtime functions
  chaos: add generic stress test
  chaos: add timer interrupt to the workload
  chaos: add edu device interrupt to the workload

 lib/alloc.c         |   9 +-
 lib/alloc.h         |   1 +
 lib/libcflat.h      |   4 +-
 lib/string.c        |  59 +++++++++-
 lib/string.h        |   4 +
 lib/x86/processor.h |   2 +-
 x86/Makefile.x86_64 |   1 +
 x86/chaos.c         | 263 ++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 337 insertions(+), 6 deletions(-)
 create mode 100644 x86/chaos.c

-- 
2.29.2

