Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14EDDD3074
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2019 20:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbfJJSfi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Oct 2019 14:35:38 -0400
Received: from mail-vk1-f201.google.com ([209.85.221.201]:47718 "EHLO
        mail-vk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfJJSfi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Oct 2019 14:35:38 -0400
Received: by mail-vk1-f201.google.com with SMTP id h186so2464983vkg.14
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2019 11:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=8qITtlfN7DfL4So8PtImqvXvjqN5KVqQfKSdHZjpQwI=;
        b=sLfik+CoQgyisPX1rVG1AxBqN8+xor9OJPAnqpsJopbYdTAgc3xH33PexjCwI31r8q
         hYG+Tp/Z99iVIjWsZ60vbvz8mbgAhOMdl3IvHuNi2vU70kozugqUkDGM+Iy9Yg0/HrIz
         WjDwuWZQFNELHdM+1rjKB4wq0W/mmi2Mg669/BZZ5X7D5+tKLeoez4XY4TnSgGTOkBAW
         qrnPXJkyckuZY51IkBS3fgRKx25HLUKQhtHORI6ZA/aAHUAcpIrC/Z5ciCljWjuf6Vjs
         GvwAD1VfRhD0HhGtoU88PHarF4uJsw5D0pJ43/PaqEY1smBkCf9XP2PsbPr10hPy1YX1
         u1gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=8qITtlfN7DfL4So8PtImqvXvjqN5KVqQfKSdHZjpQwI=;
        b=jTMpVkr97S1Vs9kud6Xgu/KCSoIePnczpoIw3JfzTB2yw8AbSbSpudhU9Pt/fksGks
         zxS8USkX8ySGlqImDLUdcl2wR+U84jisuPelA+iqD8YqWLSIX9o+Yq+V8x5jPYxObnG0
         7SWk1WT0sqTOuPP50QWVvKzlSpTysAdagLz8bkRoxVxaryXo/xlaIfv8qvCRzxZU7MZ7
         JkyYoBH15YkxeLv7Algk/Q/zlQOBKFn4/jpv8XvdPQw6xO0QtUgmh8dASzbLMvxSY9tJ
         41leQ8zP0y1d4DTuBkhQlVVI/xt886NcEgJqIvWnzZ+VZK8qEHzOvvMHzD4b1HowJFfF
         I8ww==
X-Gm-Message-State: APjAAAVwWFNkZhMc3z+ljoeTxod8lsxQJT0dfImAvhpomn7bYIbscT5q
        BgRsIF6aCJtyF9dS8VOvG+v1ur+/8y8cGQY6jY5jIBxH5kIW6Tdm2cSvc6/b1kPxTfHfCm/uiOx
        dpf5v33l0kAaLoqRE8DWWN9Z3aVwLHrS4zDposFCKCoMrbmrcjukcgg==
X-Google-Smtp-Source: APXvYqxxu7e1OVMjCAdG2h8urjxkXs88G8V4HqqHfmeAB6ebIKPJStoJzZ47IITOifPxPaFNLMUbQS5IYA==
X-Received: by 2002:a05:6102:2142:: with SMTP id h2mr6450721vsg.27.1570732537228;
 Thu, 10 Oct 2019 11:35:37 -0700 (PDT)
Date:   Thu, 10 Oct 2019 11:35:03 -0700
Message-Id: <20191010183506.129921-1-morbo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [kvm-unit-tests PATCH 0/3] Patches for clang compilation
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     jmattson@google.com, Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These three patches fixes some compilation issues that clang's
encountering. I ran the tests and there are no regressions with gcc.

Bill Wendling (3):
  x86: emulator: use "SSE2" for the target
  pci: use uint64_t for unsigned long values
  Makefile: use "-Werror" in cc-option

 Makefile       | 19 +++++++++++--------
 lib/pci.c      | 18 +++++++++---------
 lib/pci.h      |  4 ++--
 x86/emulator.c |  2 +-
 4 files changed, 23 insertions(+), 20 deletions(-)

-- 
2.23.0.700.g56cf767bdb-goog

