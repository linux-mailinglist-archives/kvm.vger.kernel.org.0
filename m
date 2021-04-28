Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 987F436DFC7
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 21:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbhD1Tkt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 15:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241833AbhD1Ti5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 15:38:57 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72593C06138B
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 12:38:06 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 27-20020a63155b0000b02901fc44c72f4fso22006776pgv.10
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 12:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=y5TtNvQVcJDv9Z7T1noOFyA3ZEWB7AcnNOctxeDgCSw=;
        b=Ay+VJZ4ahiyvX7cnAJy9QBvCOp0B2pagEvWI8fx2RuBj7dTYB362WFaPfyyrx5f7Kh
         QMhmUSVQBU7KLTD2lIjkSGO+3Fb5HkHETqAb3FNjeCbtU8OquS7XkNpgAWzqMXoV7arY
         DpjTkjTGSi3rb8BI1p4nYnYrBllrUtQwiU+m7QHSRy7c2f/COKdsJ/7GS19xDtEpJLI+
         CWuN8iRf1IvqIPdafAVVTpT398O89OMISnTnJS86FZQZQAfSakOreMxb29iRZRFrkMuZ
         zzLt0FP3ukRcKzJGBQydpkYQWFVuyRdYRbx3vSxcCGeZpK7CkKkNF5uopTiDM5/dbwMO
         ISUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=y5TtNvQVcJDv9Z7T1noOFyA3ZEWB7AcnNOctxeDgCSw=;
        b=rSEzxgXR2ZLBC3aoiPqSCOsViUY/Mpv2wKVlAzLrRVIMZmah/9yZCnSmYsGY4cJR+m
         Wqq3+kBHg8IxQ/bAqaatUit5JOX+c5mBpeANH15jt6jI3WKu6xsA6xKwBbLBwmIM708B
         BI0AAZRhA4Gz9JXJOJkGIcBBQS2mWVrzcI2GK73bR5EkNMaz+iLKUg9cbD+KfBy6FD55
         T1lOMZSV+CGJWhRQjKwsYzICSwkFQt3MBSfp78kvJ5qFmeNUGtKFy3qArs/CWmSGaJRu
         m6IC3K9BE2/wnHPWt+SB1qvf4SQGw0pa2vqgXs3HGcKkh1Z8rQ0RMIiELFcCGRpwukxI
         uhcw==
X-Gm-Message-State: AOAM533V5GRR/aKK//5E2piXvzrmLjeZqU3odRy04fy4Sba6QVsWHVPz
        jFL0APTZizwPFQosBTMxTnYVr4Km0MbLkw==
X-Google-Smtp-Source: ABdhPJw+Qnh815VDtDsA5CtP6S9BYBw6Zjzt/YgEpIlEYD2r+/tUmKiBWwxygl6tYBp6dUgQx+PJdyhNss9n2g==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:a60b:: with SMTP id
 c11mr34343701pjq.125.1619638686001; Wed, 28 Apr 2021 12:38:06 -0700 (PDT)
Date:   Wed, 28 Apr 2021 12:37:52 -0700
In-Reply-To: <20210428193756.2110517-1-ricarkol@google.com>
Message-Id: <20210428193756.2110517-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20210428193756.2110517-1-ricarkol@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v2 2/6] tools headers x86: Update bitsperlong.h in tools
From:   Ricardo Koller <ricarkol@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update uapi/asm-generic/bitsperlong.h with the latest version in the
kernel. Here is how KVM selftests is currently including it:

  tools/testing/selftests/kvm/lib/elf.c:#include <linux/elf.h>
  . ../../../../usr/include/linux/elf.h
  .. ../../../../tools/include/linux/types.h
  ... ../../../../usr/include/asm/types.h
  .... ../../../../usr/include/asm-generic/types.h
  ..... ../../../../usr/include/asm-generic/int-ll64.h
  ...... ../../../../usr/include/asm/bitsperlong.h
  ....... ../../../../tools/include/asm-generic/bitsperlong.h
  ........ ../../../../tools/include/uapi/asm-generic/bitsperlong.h

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/include/uapi/asm-generic/bitsperlong.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/include/uapi/asm-generic/bitsperlong.h b/tools/include/uapi/asm-generic/bitsperlong.h
index 23e6c416b85f..693d9a40eb7b 100644
--- a/tools/include/uapi/asm-generic/bitsperlong.h
+++ b/tools/include/uapi/asm-generic/bitsperlong.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 #ifndef _UAPI__ASM_GENERIC_BITS_PER_LONG
 #define _UAPI__ASM_GENERIC_BITS_PER_LONG
 
-- 
2.31.1.498.g6c1eba8ee3d-goog

