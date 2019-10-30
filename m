Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C144EEA517
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2019 22:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbfJ3VE1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Oct 2019 17:04:27 -0400
Received: from mail-ua1-f74.google.com ([209.85.222.74]:55185 "EHLO
        mail-ua1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726749AbfJ3VE1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Oct 2019 17:04:27 -0400
Received: by mail-ua1-f74.google.com with SMTP id r13so553859uam.21
        for <kvm@vger.kernel.org>; Wed, 30 Oct 2019 14:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=aiFlHLaj6X/N2ZURrJjEU4vYX3C5zBsE6x3F5CGlqEU=;
        b=MQlOk3SpDeMdM4ReP5nagv2SpEpRil0SLDyMLjMdVSvqiqSWuvOhMBXhj3mdJMROZ1
         VN88xMYE3Pvopi3XWY++qUtwz+jpdDmu5AYPGWb2zDHQRIZonAsSf1eS7adHlUNxvUqM
         RZETOg9V6JVIA76TaM5V7qmDrVryU9EXRurqzB1+1uXUBaSmLPTAD9BR9QgH/mcy0DDQ
         mNARyUNueyuuK7/WcOxoRZM7BeP8dKB75ELp8z+TZWtj7+y9RbXgDlj8P35hntJT0/lf
         hKDta/aqib+GJkLmH78PEIAwzNa+Dp3c6ptFZvTpsuz/NEGSENVHdLP/yzne51qyTE4G
         Zkuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=aiFlHLaj6X/N2ZURrJjEU4vYX3C5zBsE6x3F5CGlqEU=;
        b=ek0y4g038jznyYDVIEgdMuXaR4ptGDYgY/jwpSuUzi5MMzSA38YFeMmHEaTv+gES3k
         LEDES8d8DiW5IzeFJXq3iPixIWGyYjPFB6UVlyEIuGogIshT1mO0BgjlSG1lrfPFN6Cr
         plqtDjrCVULA/8H9nUPEfiSdstNolONqokMDgVZwBTySz7z1wxIrqqE15ITLwpq6Sbat
         FZKB6ipZv01hx2Tq68OSp8Ob7O0CFZW0O/2J3pT+MIRSWBBHdK5TfNKGSTJxXN2Hz5j/
         elHz1liTZj/lhhBAe+zTV5ryLNRCbZ+LucxIhDDF08XfQY3sm+2q3YwkQS429kg88Vyp
         KQsw==
X-Gm-Message-State: APjAAAVtAxdGemy1oLfOXrYVb7kAuywpbPhmXQtdSrMCwFWOrrbF9ICu
        5B/Z828Vsnh0JIHzT8TgBUelXps+KIsTQybnEocTR7H8eoCTMBWbSoNhFXLI4RipYlx0qrkk70a
        nSy/ju99EZAJYJs759d+0uwSTp9UsqwBq/SvDZz70lUwSI0MwRasaLg==
X-Google-Smtp-Source: APXvYqzOK5eWNslxZeCF5LENpEN/eRV7Hbm2Z9PdmCAbnjjpnQTeQRu9Kq5Y5U5lfdijW1FHsqu51G0iag==
X-Received: by 2002:a1f:6a02:: with SMTP id f2mr265410vkc.40.1572469465876;
 Wed, 30 Oct 2019 14:04:25 -0700 (PDT)
Date:   Wed, 30 Oct 2019 14:04:13 -0700
In-Reply-To: <20191015000411.59740-1-morbo@google.com>
Message-Id: <20191030210419.213407-1-morbo@google.com>
Mime-Version: 1.0
References: <20191015000411.59740-1-morbo@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [kvm-unit-tests PATCH v3 0/6] Patches for clang compilation
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, thuth@redhat.com
Cc:     jmattson@google.com, sean.j.christopherson@intel.com,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series of patches includes extra from the original patch set:

- Changes to the "use -Werror in cc-option" patch to address Thomas
  Huth's comments.
- Two fixes for code clang warned about: shifting negative numbers, and
  misuse of the "registers for local variables" feature.

Bill Wendling (6):
  x86: emulator: use "SSE2" for the target
  pci: cast the masks to the appropriate size
  Makefile: use "-Werror" in cc-option
  Makefile: add "cxx-option" for C++ builds
  x86: use a non-negative number in shift
  x86: use inline asm to retrieve stack pointer

 Makefile        | 30 +++++++++++++++++++++++-------
 lib/pci.c       |  3 ++-
 x86/emulator.c  |  2 +-
 x86/svm.c       |  2 +-
 x86/vmx_tests.c |  8 ++++++--
 5 files changed, 33 insertions(+), 12 deletions(-)

-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

