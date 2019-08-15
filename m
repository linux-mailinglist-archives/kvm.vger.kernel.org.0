Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9788E911
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 12:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730935AbfHOKfL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 06:35:11 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33158 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730150AbfHOKfL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 06:35:11 -0400
Received: by mail-pg1-f195.google.com with SMTP id n190so1155183pgn.0
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2019 03:35:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NZexTARNLLR7b9hxD7/WQtSkaarQGcau2Mr8+ymJR5o=;
        b=mqdRx6TIuRxfGIJuS5WuAiYK/MPqH432Reyo7lwNkBY5gTqmUxR3Ehdt5gvzZ9jphx
         WyOSnT5sDY6zbCWKdK1OixSNuPmOx7g7X3Cbo+eqTwZkV04UfWQP/MR3mHelA2082u3h
         8eBLKORbFEnl6lHdZ0b2iGhue4U5inCi7NkpYoXAwxCzw28uxxV/GdtCFIJQjfafRY9c
         TZpjfmQoBupJm/8Fe2dfkxWTihN2g5vSaEHSdURST9RICD9cEhAjv2+RrgZmv8LrLMF6
         dMniet8HUY1ABGNAyQt/9YASLMXOya7gC3OrAAjAFKrXqzQYQp7vNi42SpegbRRB311a
         8MUA==
X-Gm-Message-State: APjAAAVz+tTjjtKko+sv1yVrnsMSf8Go0N1R2ORWhdobnYGb6I40vNSt
        1K3xDrCjoiTzWDA0EbZBBFL9eRNrW2Dp6g==
X-Google-Smtp-Source: APXvYqzzpJBZd6q/M6MxoS3ELE5DoxGa0aYiTZyk1llfcNdHoTd1t36vhVVTIUM9x57vem8y1fpN3w==
X-Received: by 2002:a65:5b8e:: with SMTP id i14mr2993080pgr.188.1565865310043;
        Thu, 15 Aug 2019 03:35:10 -0700 (PDT)
Received: from xz-x1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o128sm2481066pfb.42.2019.08.15.03.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 03:35:09 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>, peterx@redhat.com
Subject: [PATCH v2 0/3] KVM: X86: Some tracepoint enhancements
Date:   Thu, 15 Aug 2019 18:34:55 +0800
Message-Id: <20190815103458.23207-1-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2:
- fix commit messages, change format of ple window tracepoint [Sean]
- rebase [Wanpeng]

Each small patch explains itself.  I noticed them when I'm tracing
some IRQ paths and I found them helpful at least to me.

Please have a look.  Thanks,

Peter Xu (3):
  KVM: X86: Trace vcpu_id for vmexit
  KVM: X86: Remove tailing newline for tracepoints
  KVM: X86: Tune PLE Window tracepoint

 arch/x86/kvm/svm.c     | 16 ++++++++--------
 arch/x86/kvm/trace.h   | 30 ++++++++++++------------------
 arch/x86/kvm/vmx/vmx.c | 14 ++++++++------
 arch/x86/kvm/x86.c     |  2 +-
 4 files changed, 29 insertions(+), 33 deletions(-)

-- 
2.21.0

