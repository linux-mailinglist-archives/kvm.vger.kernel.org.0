Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8E616F8AD
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 08:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbgBZHou (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 02:44:50 -0500
Received: from mail-pj1-f73.google.com ([209.85.216.73]:34264 "EHLO
        mail-pj1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgBZHou (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 02:44:50 -0500
Received: by mail-pj1-f73.google.com with SMTP id v8so3003392pju.1
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 23:44:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Dvhrew6bJQSEcOdx0LzKYO1ItCUbvb7ulg82U8Cs/x4=;
        b=r1rbRrBoqOcHZEEks629lSsI0EwzmHU6fFI5X2n1T+ASmdVyGZAAioTDr6TYSItEmx
         zNIUkC3t18J8Cs7zAGnLlGGcLsJgsPdPZABWsNS96z0il8889+6clORwMhEhoZGsK2eE
         iL9Tv08RvRFmUfKLYSMykRjBsXEvFVUrWa0IcWwk+z0g4uhTQyLcCAe/7Z+Q0B2Ay+xZ
         xNxYqYMsakI/2SEX/dNepiMi2CZNsVt14BcGX2lsYO1NoMp4FXwhPeFRGD590PEPFDyM
         qDM02Ua/DRY6L+SAxIQBX+1re1J02sA5EjUsAGcQAikneReLiWj9f/s01JqpmCGu8CzN
         4hiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Dvhrew6bJQSEcOdx0LzKYO1ItCUbvb7ulg82U8Cs/x4=;
        b=gYqKBT8fCX/xguZNrHZIKIqoAja0UdiF99a7xVl0rNg6hCgxCzwQ9mr5TR+VxbghQY
         +ZYiacLZq5T1zZ1i4DlqvZ2EDmMlDFB/AWjeM+GRt3BeJgOi2KFoLgfj1juW1yP84/7O
         PsPvR3cJFmk4ChOi1+UzC7jxs77AQw930HDRqn0XDAcCIJ8pR8UsUbj6CA23IWh4DKKz
         Ug6KqZ1vGoxnPEH/cCQTTgDeRMyDkbEeLlLoPg5E85Esw9PgmHy7Oj+j7Td3/mCxDwJq
         kaMwkOG+Jf9VvBYjeW1XrY1E16muaD9njzZ3kNWGbWug/edE9OO6vTXAzooFlPVNYdPR
         RukA==
X-Gm-Message-State: APjAAAXaW2/3jTmOWSsy0GD/MGEkwFs0xYAIEUztRNaISqTZ1H+IaXvI
        HjjgwGrSHrPeWZ8QJ234sQftldO3LzbsKVLUxEbofZh/EBdqNNgqtTfUv0zJMmEoP6ZVULEAqyp
        KbrkDFDTCN6xQVtt63e0JvGJRXFQ2brcL+O+nl3Ar2pUzKbGoBoid1A==
X-Google-Smtp-Source: APXvYqyRwxXJMYEbSR91aXCwv5WqK+2o+xKZCoVWnh5Bm7FRiEEhQaoJDsdzgSeQhbyR4qS4Qd5PcbkoWw==
X-Received: by 2002:a63:e65:: with SMTP id 37mr2523168pgo.171.1582703089253;
 Tue, 25 Feb 2020 23:44:49 -0800 (PST)
Date:   Tue, 25 Feb 2020 23:44:20 -0800
Message-Id: <20200226074427.169684-1-morbo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [kvm-unit-tests PATCH 0/7] Fixes for clang builds
From:   morbo@google.com
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Bill Wendling <morbo@google.com>

This is a series of patches which allow clang to build the
kvm-unit-tests.

Bill Wendling (7):
  x86: emulator: use "SSE2" for the target
  pci: use uint32_t for unsigned long values
  x86: realmode: syscall: add explicit size suffix to ambiguous
    instructions
  svm: change operand to output-only for matching constraint
  svm: convert neg shift to unsigned shift
  x86: VMX: use inline asm to get stack pointer
  x86: VMX: the "noclone" attribute is gcc-specific

 lib/linux/pci_regs.h |  4 ++--
 x86/emulator.c       |  2 +-
 x86/realmode.c       |  6 +++---
 x86/svm.c            |  6 +++---
 x86/syscall.c        |  2 +-
 x86/vmx_tests.c      | 11 ++++++++---
 6 files changed, 18 insertions(+), 13 deletions(-)

-- 
2.25.0.265.gbab2e86ba0-goog

