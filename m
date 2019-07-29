Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB6247846C
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2019 07:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfG2Fcy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jul 2019 01:32:54 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35196 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbfG2Fcy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jul 2019 01:32:54 -0400
Received: by mail-pl1-f194.google.com with SMTP id w24so27036495plp.2
        for <kvm@vger.kernel.org>; Sun, 28 Jul 2019 22:32:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=flBFoWj0dK5v1hltqk4vN/oY+8Ju11YahL+AoE9d1ZE=;
        b=RuXlHHMtb0vEmgIMqb7K8m3rS3qHEgjJERbeiqKdVMfr0rndQJWdGt8ZR2qxSYs3J2
         XoDUPQ3in901w6OXibmxt5EK2wOOBnkmclXwB8IJyblJvHRvJVyzRrVkgncmRuFVtG0/
         eI1gfPFC36f0botXyX0o7LhHw98FVOgO5DfKR4GmejYlfQe/jK1PnxbZaYzaQC9yTw7m
         75PJfT3k/G2u4+ZuXFxOHbzfZYJu8KA7erNRlzRHZDQUxpi1uXBrWMyL4PnYz3dP+9Fv
         fkXqhv6d00iax8FgSEwigsnZfbm+zGjkNIS/2AzgUXHtHhAMcuG1f/DHzfFncuTP1O7k
         5xyA==
X-Gm-Message-State: APjAAAUV0CI9uClVAs6Y2opWC+4ZYorarH/jbLeq/unNmGpJfKwHsOGA
        RfMDiE/tCiRt6/Nbm7M/qsv2la9rtyM=
X-Google-Smtp-Source: APXvYqxjX3ivPDXUJ7bHOtjj3LdA6XZt1RkF0qZ8OaG4JOZ5oqrugR6668nQVmL0c2L7y6FafUoToA==
X-Received: by 2002:a17:902:ff10:: with SMTP id f16mr13596215plj.141.1564378372802;
        Sun, 28 Jul 2019 22:32:52 -0700 (PDT)
Received: from xz-x1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o129sm30498550pfg.1.2019.07.28.22.32.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 28 Jul 2019 22:32:52 -0700 (PDT)
From:   Peter Xu <zhexu@redhat.com>
X-Google-Original-From: Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, peterx@redhat.com
Subject: [PATCH 0/3] KVM: X86: Some tracepoint enhancements
Date:   Mon, 29 Jul 2019 13:32:40 +0800
Message-Id: <20190729053243.9224-1-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Each small patch explains itself.  I noticed them when I'm tracing
some IRQ paths and I found them helpful at least to me.

Please have a look.  Thanks,

Peter Xu (3):
  KVM: X86: Trace vcpu_id for vmexit
  KVM: X86: Remove tailing newline for tracepoints
  KVM: X86: Tune PLE Window tracepoint

 arch/x86/kvm/svm.c     |  8 ++++----
 arch/x86/kvm/trace.h   | 33 ++++++++++++++++-----------------
 arch/x86/kvm/vmx/vmx.c |  4 ++--
 3 files changed, 22 insertions(+), 23 deletions(-)

-- 
2.21.0

