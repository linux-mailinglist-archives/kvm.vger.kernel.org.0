Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03264A985E
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2019 04:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729366AbfIECg3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 22:36:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57120 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728267AbfIECg3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 22:36:29 -0400
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 60223182D
        for <kvm@vger.kernel.org>; Thu,  5 Sep 2019 02:36:29 +0000 (UTC)
Received: by mail-pf1-f197.google.com with SMTP id v15so706557pfe.7
        for <kvm@vger.kernel.org>; Wed, 04 Sep 2019 19:36:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+eJV3E7CEyPbMu34xaIgaU3JSPlKajRTnFS7tmbRJtk=;
        b=hQJMAeE1g7qZoooyhsRUrJOAPtdZsxfwWatjbgenf3lpjYZHZLRYyMWPy0/GyEbGB6
         xwoj+63IedbSwRzYzvsoUtw16/hEpsIZmATHUz8SLBsFcW58Y9CiD4IqVMDKd5t1MfiW
         L0EbyAzPt5lHKUgsoI1+2u7ezXfDHDa/OVCgwgtoFaxk7W+YSS13jOzCO2Esa1I7EcDN
         /ZBogF6todYYz/K8gwQw5T6kp4DqAVVH35yZbgHsH0ZBq2pezbR/h+/xM9vipwCz8UOC
         U8+p1zaFTVNkbx97SA1IbPHDXkXJXVug6TI+cvcypDbAVFcSug2PwRGoLCbHn9SH7ehS
         CROg==
X-Gm-Message-State: APjAAAXyjN/KXaVD72PoKdeS6GobTRR8hxPtHWEHwSJTQcbj8VuXk1nB
        FEohVSf3cNtE6tfUqaByTucCqoa8MYB+K+JbOw0nVcYqhd5zwfAS8lsoN7sqfcc32zKy/aU06Jy
        RDt+y5IE1eLKx
X-Received: by 2002:a62:2d3:: with SMTP id 202mr1013667pfc.141.1567650988553;
        Wed, 04 Sep 2019 19:36:28 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzx71eeFT6dL7OSCTUDVdfMD8/EUHCs/7N3jRwZvsiHjEfDQi118LVrKauPmNizcCppky2hCg==
X-Received: by 2002:a62:2d3:: with SMTP id 202mr1013658pfc.141.1567650988377;
        Wed, 04 Sep 2019 19:36:28 -0700 (PDT)
Received: from xz-x1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v10sm326504pjk.23.2019.09.04.19.36.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 19:36:27 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>, peterx@redhat.com
Subject: [PATCH v3 0/4] KVM: X86: Some tracepoint enhancements
Date:   Thu,  5 Sep 2019 10:36:12 +0800
Message-Id: <20190905023616.29082-1-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v3:
- use unsigned int for vcpu id [Sean]
- a new patch to fix ple_window type [Sean]

v2:
- fix commit messages, change format of ple window tracepoint [Sean]
- rebase [Wanpeng]

Each small patch explains itself.  I noticed them when I'm tracing
some IRQ paths and I found them helpful at least to me.

Please have a look.  Thanks,

Peter Xu (4):
  KVM: X86: Trace vcpu_id for vmexit
  KVM: X86: Remove tailing newline for tracepoints
  KVM: X86: Tune PLE Window tracepoint
  KVM: VMX: Change ple_window type to unsigned int

 arch/x86/kvm/svm.c     | 16 ++++++++--------
 arch/x86/kvm/trace.h   | 34 ++++++++++++++--------------------
 arch/x86/kvm/vmx/vmx.c | 18 ++++++++++--------
 arch/x86/kvm/vmx/vmx.h |  2 +-
 arch/x86/kvm/x86.c     |  2 +-
 5 files changed, 34 insertions(+), 38 deletions(-)

-- 
2.21.0

