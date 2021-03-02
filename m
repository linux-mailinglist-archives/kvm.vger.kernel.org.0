Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE00432A6F2
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1838890AbhCBPzI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 10:55:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376913AbhCBIRv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 03:17:51 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B80BDC061794
        for <kvm@vger.kernel.org>; Tue,  2 Mar 2021 00:17:10 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id k16so10782883plk.20
        for <kvm@vger.kernel.org>; Tue, 02 Mar 2021 00:17:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=J5nM/aBIL0ud17qxWddLzc4+65+ykqSEziPOIHoR18E=;
        b=CLaHSQRRQuhzlrNUHt+Ee6dvdh/pvhmKVL23Vm4bjLSGpL9t3yxCRmBAVgHL6lsIyn
         05iAFmfLfOZZR9GHkYRXKHrHC0SJlD8qUu+AAvO9gfMPcV4vhR646pp/hEvI68QeA2Mb
         DBYpEVQWeUFHdRFXaub06Vwhv8jjJysBUfgnKx9+1KwWwrDjmMYv+jozyxcKVieG9COH
         DE7ZHKblBdBpTi6HTjHtr7iiM5+8AIUrueg5HzDkJVCaHvkxaOHcB1vGO3bNgFMavgSK
         JIqmGJgz7qn0J+SwCsXUdzaYEdBIOPxEJJe80J4+INK+OSDVp9jhM5+vKb5bRxmRrTWt
         lYag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=J5nM/aBIL0ud17qxWddLzc4+65+ykqSEziPOIHoR18E=;
        b=lfg1qDwYmV8AcpDJGqvQlPSTF6Ihz1PCDO6yCLAPr8kZuBAip2indueuV7NaYK8Yj6
         LjjCW5UIy23NxUpMCte7AwtGBP325Nf3UgIO1Pl+SqobCK3sicfxGEu20pY4wyBdom/h
         8I7KdlJlvxMzXRJ89D1lqhiUxxjLgn1ocKy60P2AskKpHnZimgELWK29NBBtkHl8oZ9q
         Wik/bviRn9N89Iywiv/TEztnSCuHG/dZm9xbdcPzzXvxO3nJMkzt/KHpLWzLMw4AWPVI
         FeCtxMyM3EDDnXLMSM4pPhQxuzEwn3TF9zy8ltFYpDquF0+ikcl9ejMQXYPFQpfJpM9P
         kf9Q==
X-Gm-Message-State: AOAM531X6pJVWqBhOqoXAZIVhsFn5dkWPh6T+Fl6ObUOlpfc9M+LzSvJ
        /aiDqvsnMms0lSw6d/pLXtc86tYZxjDo
X-Google-Smtp-Source: ABdhPJxpzOEermj6hCTqHdZMYKkcNIjK+rfabJvpEhcLm7hTMoPzPtCdKtmgNr1eNEsnSiBD1DsDg2OTL89T
Sender: "vipinsh via sendgmr" <vipinsh@vipinsh.kir.corp.google.com>
X-Received: from vipinsh.kir.corp.google.com ([2620:0:1008:10:e829:dc2a:968a:1370])
 (user=vipinsh job=sendgmr) by 2002:a62:6585:0:b029:1b9:d8d9:1af2 with SMTP id
 z127-20020a6265850000b02901b9d8d91af2mr2296150pfb.17.1614673030058; Tue, 02
 Mar 2021 00:17:10 -0800 (PST)
Date:   Tue,  2 Mar 2021 00:17:03 -0800
Message-Id: <20210302081705.1990283-1-vipinsh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [RFC v2 0/2] cgroup: New misc cgroup controller
From:   Vipin Sharma <vipinsh@google.com>
To:     tj@kernel.org, mkoutny@suse.com, rdunlap@infradead.org,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com,
        eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org,
        frankja@linux.ibm.com, borntraeger@de.ibm.com
Cc:     corbet@lwn.net, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        gingell@google.com, rientjes@google.com, dionnaglaze@google.com,
        kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello

This patch series is creating a new misc cgroup controller for limiting
and tracking of resources which are not abstract like other cgroup
controllers.

This controller was initially proposed as encryption_id but after
the feedbacks, it is now changed to misc cgroup.
https://lore.kernel.org/lkml/20210108012846.4134815-2-vipinsh@google.com/

Changes in RFC v2:
1. Documentation fixes.
2. Added kernel log messages.
3. Changed charge API to treat misc_cg as input parameter.
4. Added helper APIs to get and release references on the cgroup.

[1] https://lore.kernel.org/lkml/20210218195549.1696769-1-vipinsh@google.com
Vipin Sharma (2):
  cgroup: sev: Add misc cgroup controller
  cgroup: sev: Miscellaneous cgroup documentation.

 Documentation/admin-guide/cgroup-v1/index.rst |   1 +
 Documentation/admin-guide/cgroup-v1/misc.rst  |   4 +
 Documentation/admin-guide/cgroup-v2.rst       |  69 ++-
 arch/x86/kvm/svm/sev.c                        |  65 ++-
 arch/x86/kvm/svm/svm.h                        |   1 +
 include/linux/cgroup_subsys.h                 |   4 +
 include/linux/misc_cgroup.h                   | 122 +++++
 init/Kconfig                                  |  14 +
 kernel/cgroup/Makefile                        |   1 +
 kernel/cgroup/misc.c                          | 423 ++++++++++++++++++
 10 files changed, 692 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/admin-guide/cgroup-v1/misc.rst
 create mode 100644 include/linux/misc_cgroup.h
 create mode 100644 kernel/cgroup/misc.c

-- 
2.30.1.766.gb4fecdf3b7-goog

