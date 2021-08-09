Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71FB03E42C8
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 11:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234468AbhHIJem (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 05:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234375AbhHIJel (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 05:34:41 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D249C0613CF;
        Mon,  9 Aug 2021 02:34:20 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id j3so15726179plx.4;
        Mon, 09 Aug 2021 02:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uCGpUr2j9D66mSgiwXstiBVBXY4god79WtpOChDFv8g=;
        b=MyyZfcT+a7lJSGQmSG+ij13zxJebAJBwFWfy01VL9LEY79KcZNDZm/Wq9KaDhahy+K
         bdQc/1FkC9S6fuKFBN/YnnL1zqJuXpW+sNMFzEIxoBzvZptfj5L6fv1KFQK3OF7Pcj6q
         eFp1Bj08ZbUPbidkpnU8mMN1Lk53zdkgU7ogs33bwemXZCoqyOJ7YPxRSiI1k49EV0aQ
         ONMaEr8jUSfGsJyU59SzFn+ilJUcshewMPyPu9hVLD8nphqwFaQWc9uBDNMetg7YrN18
         zqnaXCjDTfRjObbzhvokfq044MmcCoPo87AIBsdTSzLE7pE2At7jh50++aFOVvJZHX+u
         ChuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uCGpUr2j9D66mSgiwXstiBVBXY4god79WtpOChDFv8g=;
        b=BRBYX65T7M3wnlCyQVnZneLR64TX3uq4cjALwXu+B66DXAPcpCz1B2APBq8hbpzt/d
         CbUBZVCkrRSRyhn+9MBavZujQwSJENv0F4wzVEvYqrhy9AliTKwhD0Zesk/1kCyIhI2C
         ym4C+fcBEsOsxpu0B0gdTUC67qoaUK65rPMP9jvPkRQ5nYp9vV4hY6UbTd+oZuydTikT
         3oXx0462yNqnpEwMKjnE71VGucbudmknGOK7waVVcA+PfB55R8pRc8N4YUJJAmxOSUg/
         nVQkk9MAmCHYnagl3q/8gAjhjSI7FRXaP+xAfntlBBzs9S1u7NF8Z2KREcL1iWDu8jM3
         DR0w==
X-Gm-Message-State: AOAM531AtIr58r4uco0CMnq5O4FhxlVlNwoBPa/6pkfKspVxRfEz8b1S
        5IQHNBor1rnsT+aeAo2Fyw8=
X-Google-Smtp-Source: ABdhPJwBg42DZycaIhZuLLnIypdZvj48GYhu+t8A6d8TpgO3cQ+OhYWXxvpY6o8p7c5TpsRMytPg8Q==
X-Received: by 2002:a63:dd51:: with SMTP id g17mr716156pgj.47.1628501659697;
        Mon, 09 Aug 2021 02:34:19 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id h188sm10839982pfg.45.2021.08.09.02.34.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Aug 2021 02:34:19 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] KVM: x86: Clean up redundant macro definitions
Date:   Mon,  9 Aug 2021 17:34:05 +0800
Message-Id: <20210809093410.59304-1-likexu@tencent.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In KVM/x86 code, there are macros with the same name that are
defined and used separately in the evolving code, and if the scope
of the code review is only on iterations of the patch set, it can be
difficult to spot these fragmented macros being defined repeatedly.

IMO, it's necessary to clean this up to improve the consistency and
readability of the code, and it also helps to avoid software defects
caused by inconsistencies in the scope of influence of macros.

Like Xu (5):
  KVM: x86: Clean up redundant mod_64(x, y) macro definition
  KVM: x86: Clean up redundant CC macro definition
  KVM: x86: Clean up redundant ROL16(val, n) macro definition
  KVM: x86: Clean up redundant __ex(x) macro definition
  KVM: x86: Clean up redundant pr_fmt(fmt) macro definition for svm

 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/kvm/i8254.c            | 6 ------
 arch/x86/kvm/lapic.c            | 6 ------
 arch/x86/kvm/svm/avic.c         | 2 --
 arch/x86/kvm/svm/nested.c       | 4 ----
 arch/x86/kvm/svm/sev.c          | 2 --
 arch/x86/kvm/svm/svm.c          | 4 ----
 arch/x86/kvm/svm/svm.h          | 3 +++
 arch/x86/kvm/vmx/evmcs.c        | 1 -
 arch/x86/kvm/vmx/evmcs.h        | 4 ----
 arch/x86/kvm/vmx/nested.c       | 2 --
 arch/x86/kvm/vmx/vmcs.h         | 2 ++
 arch/x86/kvm/vmx/vmcs12.c       | 1 -
 arch/x86/kvm/vmx/vmcs12.h       | 4 ----
 arch/x86/kvm/vmx/vmx_ops.h      | 2 --
 arch/x86/kvm/x86.h              | 8 ++++++++
 16 files changed, 15 insertions(+), 38 deletions(-)

-- 
2.32.0

