Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99A5417093B
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 21:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbgBZUNE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 15:13:04 -0500
Received: from mail-pl1-f201.google.com ([209.85.214.201]:33612 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727240AbgBZUNE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 15:13:04 -0500
Received: by mail-pl1-f201.google.com with SMTP id bd7so357508plb.0
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 12:13:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=eE7m91og2qy8dUqhBgCzX0N5xowRQsCQ0yF3s3lmQnM=;
        b=TM42qedM8DksnVEF0SiVXay32fTG103XsIThRVSSFezzKCW4SqZRIbLmpF38YQ2FQK
         ED0jqzm6gcFoJ8QYjOkmlw6dh2hwf3QbK8UM3++hYsBigXf8I0clqreV6yTl4TMz2idx
         NkDu5RM1qj01+zRUyd8UmKIum9VY+w0m5BImQxmEnS+VvQE7u+7f9yRd7MwF9XlpKSR2
         +7MLS3Iok08Ux1f2v4jEmSG1Vey5Tw6AB+isPo3KzPlO3G2NFJkFKr9U0R1AUgaU5X9p
         pXF2c+jR/HmhfahIicFZK/1k5jVcQ9Pvht0MxPFVfMg8Kom7ITzpvGgsZON/ijH4bhBJ
         QwCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=eE7m91og2qy8dUqhBgCzX0N5xowRQsCQ0yF3s3lmQnM=;
        b=Ilxffo4LsBmuSW6/viyCfJWgvapdNAQtSKvjPR1bfobcKlBqLpJaxHvKRoFQfflpz2
         WWkM0wECGCy4DjWYAurRTBdPZRc90PvOXa/WQQP5yAvUzJBnm+obnF+yMFo9fMiAvRuN
         VKlg4PF+QXf7VlNgWzpY8O8jaukDMYvQ3LmOhBljAEjvImqHCp0BeryLVWqmm7amrSKB
         btJiRQxHduyM+X2N4wpuXfC3mrf7BthoOz5hMls//8p+ZIOSQme50ujwCjFuKXqUwESp
         6g33BtwMDjlqU0HoMY5fP/I6wvfhpIVMDsm7x2zeC6FTqu5a++QKRwqkEn9scD6P2gEe
         rZdw==
X-Gm-Message-State: APjAAAW9vQZf0EoJELmYrXopT3BPm3FJRTO7DTxpLaxGW3J2MNSVK1+T
        sn8CJ6xx1D3gknsafBPtOwZivWg9uled5pDYvMUk4wGc7ZOZO2tu9sVPnCdQADnT1MMJUEuXjAw
        0SW2swgJjbnns7tLnDEVM4fhCFsBGsl/9rUCcl+ZrtiLZpVwIWxtvrw==
X-Google-Smtp-Source: APXvYqxfqT4rvxxcBLpgjXUmxhik05IecVBB4jbhiYl13UObopY2h4rIxVfYzU+bWy8WRwX/w3VvXKLt7g==
X-Received: by 2002:a63:1051:: with SMTP id 17mr482885pgq.291.1582747982494;
 Wed, 26 Feb 2020 12:13:02 -0800 (PST)
Date:   Wed, 26 Feb 2020 12:12:36 -0800
In-Reply-To: <20200226094433.210968-1-morbo@google.com>
Message-Id: <20200226201243.86988-1-morbo@google.com>
Mime-Version: 1.0
References: <20200226094433.210968-1-morbo@google.com>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [kvm-unit-tests PATCH v3 0/7] Fixes for clang builds
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, oupton@google.com, drjones@redhat.com,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes to "pci: cast masks to uint32_t for unsigned long values" to
cast the masks instead of changing the values in the header.

This is a re-send of the v2 patches, which included patches that
shouldn't have been included.

Bill Wendling (7):
  x86: emulator: use "SSE2" for the target
  pci: cast masks to uint32_t for unsigned long values
  x86: realmode: syscall: add explicit size suffix to ambiguous
    instructions
  svm: change operand to output-only for matching constraint
  svm: convert neg shift to unsigned shift
  x86: VMX: use inline asm to get stack pointer
  x86: VMX: the "noclone" attribute is gcc-specific

 lib/pci.c       |  3 ++-
 x86/emulator.c  |  2 +-
 x86/realmode.c  |  6 +++---
 x86/svm.c       |  6 +++---
 x86/syscall.c   |  2 +-
 x86/vmx_tests.c | 11 ++++++++---
 6 files changed, 18 insertions(+), 12 deletions(-)

-- 
2.25.1.481.gfbce0eb801-goog

