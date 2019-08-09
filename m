Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED73A8768E
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 11:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405785AbfHIJuA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 05:50:00 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34445 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730233AbfHIJuA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Aug 2019 05:50:00 -0400
Received: by mail-pf1-f194.google.com with SMTP id b13so45774180pfo.1;
        Fri, 09 Aug 2019 02:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=M4LYnoEJb207t6aRi5HbsF+k6e61KxB5f8QClUX5QIY=;
        b=B7sZuZnKX9erQAhbjqw7MPqVXJ1QGVCBauMPHnwn+8d3Y70ibLxR/VuXgfpYq9U9Mq
         wD8WP7IsMY8UxnPc9tSz1arJGz58NG2i1+8Ovm6bDASpvLwtIx7EqiRHbqd5z81IOSOo
         hZkiEuKO68UxMRliSf6XwL91l0//eBIA9WlFNXDV3m0098aAO1Na+2cDI+kRVDTvdc+/
         a6QEINj1di2Qdd4kWjRbSsR0nNyqhAy7a/+lqeLbSLqlSgrLOrcOFgsrh0fv9XjQuQQY
         IBlcnU5AVTnC4ZyWAHVEXqjgfB5cDOIhQYh4DroPRCVAwMXxAG2WgjaJqh70Mh15ZxCj
         YyvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=M4LYnoEJb207t6aRi5HbsF+k6e61KxB5f8QClUX5QIY=;
        b=qVIzXcun/XLV0do0vaLR5EyMlFqLL8nH1fmQd3ysvotRC/sygyuWLwoNU/wM5sksZQ
         oMq1M0LHFpIb++VoOxuOah4jmvg2Pf31wgqGIVLczFW1PEEHt34hn3IIUOXsT6yfNi1R
         h6YPW5iSSHSsLaNTvd40P9XQAhmiMEFGXdKS8Nx5IaRqLqNqPNJgnJ16+hc+erDea+Oo
         lGgYqq2eoQhJKPFa6bqAdfLM+3hj8gsFQc7vU5K9A2kaUM951eu0xmsz65iuQGHvpjgb
         uBwGagLaxRTVLIUCBX0hm6y4kx+ZyOKzPzAWIzRLsMJP8EaTJPEGXk6RNkvEKzC+Vhc6
         EBOw==
X-Gm-Message-State: APjAAAUr6kPNZE4BEiAhRDkDKjmNCUiNEttRvfof6Oqqfi3/IKSNQrs3
        MpPrfstxgoP96SQQOFzPbX0=
X-Google-Smtp-Source: APXvYqwEf426bx7Lg/Kot7Q5FVKeANn4QigqsluEKd28l6me5MSvuWJJG/VFDpcQRQSVOu+dGsRYmg==
X-Received: by 2002:a17:90a:2305:: with SMTP id f5mr8964682pje.128.1565344199350;
        Fri, 09 Aug 2019 02:49:59 -0700 (PDT)
Received: from localhost.corp.microsoft.com ([167.220.255.114])
        by smtp.googlemail.com with ESMTPSA id b16sm159653631pfo.54.2019.08.09.02.49.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 09 Aug 2019 02:49:58 -0700 (PDT)
From:   lantianyu1986@gmail.com
X-Google-Original-From: Tianyu.Lan@microsoft.com
To:     pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        sashal@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org,
        michael.h.kelley@microsoft.com
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, vkuznets@redhat.com
Subject: [PATCH 0/3] KVM/Hyper-V: Add Hyper-V direct tlb flush support
Date:   Fri,  9 Aug 2019 17:49:36 +0800
Message-Id: <20190809094939.76093-1-Tianyu.Lan@microsoft.com>
X-Mailer: git-send-email 2.14.5
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>


This patchset is to add Hyper-V direct tlb support in KVM. Hyper-V
in L0 can delegate L1 hypervisor to handle tlb flush request from
L2 guest when direct tlb flush is enabled in L1.

Patch 2 introduces new cap KVM_CAP_HYPERV_DIRECT_TLBFLUSH to enable
feature from user space. User space should enable this feature only
when Hyper-V hypervisor capability is exposed to guest and KVM profile
is hided. There is a parameter conflict between KVM and Hyper-V hypercall.
We hope L2 guest doesn't use KVM hypercall when the feature is
enabled. Detail please see comment of new API "KVM_CAP_HYPERV_DIRECT_TLBFLUSH"

Tianyu Lan (2):
  x86/Hyper-V: Fix definition of struct hv_vp_assist_page
  KVM/Hyper-V: Add new KVM cap KVM_CAP_HYPERV_DIRECT_TLBFLUSH

Vitaly Kuznetsov (1):
  KVM/Hyper-V/VMX: Add direct tlb flush support

 Documentation/virtual/kvm/api.txt  | 10 ++++++++++
 arch/x86/include/asm/hyperv-tlfs.h | 24 +++++++++++++++++++-----
 arch/x86/include/asm/kvm_host.h    |  2 ++
 arch/x86/kvm/vmx/evmcs.h           |  2 ++
 arch/x86/kvm/vmx/vmx.c             | 38 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c                 |  8 ++++++++
 include/linux/kvm_host.h           |  1 +
 include/uapi/linux/kvm.h           |  1 +
 8 files changed, 81 insertions(+), 5 deletions(-)

-- 
2.14.2

