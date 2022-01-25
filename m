Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0078449BF54
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 00:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234625AbiAYXFm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 18:05:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiAYXF0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 18:05:26 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE35C06161C
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 15:05:25 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id e17-20020a63f551000000b0034d214ccec5so11125922pgk.10
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 15:05:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=kM6hguRm3T/4S5ZJ91/l/G26DkbKwzbLlx0fq4B1iUo=;
        b=MJH5vrQnp5CyfBV7MgEr4BHTLLeatjQJGJlWS2GtXvBXxHn3Ps4Mm7dQDBCWEju0Jd
         bjt2wLgFkUsKCTO3CQNP4HUrYkbABc7ZWik58VF0JMMLrrQm02GchUoTKVZLE7vypnSk
         oS0VEqzGhZlPMHl3IKn93TNjTYPZU8BnOec8onHUcfXp2X3Lp+Pter/ib8cIaOf0G8Tx
         St0DVvOAbIv/T7TLbMwIzHxPzJgB11kZwJEL15Jamwi6Jnu6msmkfuIoRg1ygBAQCj2u
         5uh1I5YmjN2rrxhM6G1ymKf/Itd+YRkH9GaM66WXLp5qV+gX4wkZk63sVZK4z5chifz9
         oIsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=kM6hguRm3T/4S5ZJ91/l/G26DkbKwzbLlx0fq4B1iUo=;
        b=Zxk9mYuryJlrGWhsm8MdXOnm6WNIvMCG5zIrR7KhYJCbSJ6WGkauF6B0kZ5cX+IQu9
         Rc5rrVwU27DUlGJf3+L6IEfqWqnnyv2y3VC2OKOUueqgM/oQHtfz9twpwTFNAhqemb3J
         cZBW8woXxrndi7IMPOz0AestjyEul8dt+ekBz7s48YQj/L5eTUQ6nEDYX+9eAtALjb+/
         VjV7aC4IPHHQeJMRZN6YzAc1ttMFLsmYj+HxUxcnOSiFvOLptT7mTbkI8eOF61yXz0+f
         GrKpJeZEcYYFvL1Mcm0sRYBi0AgWe6iv+lxTBWLSAdspuJOeGfY71ucVPDmzsKELkkLK
         xvog==
X-Gm-Message-State: AOAM532hj+IFjXlXmYDb8Vok+zhaOCcex3QRKkpbVsITg5t/gHRq6+xA
        eXiIOqMfyhwj3bZTxOUoMkJZFPlDw26Cpg==
X-Google-Smtp-Source: ABdhPJzEHUOAjnjFN5WMueprwpGvbk2IVk8sFhCXSzXznznJgef8oui8dhSrK/ofNra31XYktrqYwxoyTr8Uaw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:2ec4:: with SMTP id
 h4mr5855701pjs.173.1643151925442; Tue, 25 Jan 2022 15:05:25 -0800 (PST)
Date:   Tue, 25 Jan 2022 23:05:13 +0000
Message-Id: <20220125230518.1697048-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH 0/5] KVM: x86/mmu: Clean up {Host,MMU}-writable documentation
 and validation
From:   David Matlack <dmatlack@google.com>
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series cleans up some documentation and WARNings related to
MMU-writable and Host-writable bits based on suggestions from Sean on
another patch [1].

[1] https://lore.kernel.org/kvm/YeH5QlwgGcpStZyp@google.com/

David Matlack (5):
  KVM: x86/mmu: Move SPTE writable invariant checks to a helper function
  KVM: x86/mmu: Check SPTE writable invariants when setting leaf SPTEs
  KVM: x86/mmu: Move is_writable_pte() to spte.h
  KVM: x86/mmu: Rename DEFAULT_SPTE_MMU_WRITEABLE to
    DEFAULT_SPTE_MMU_WRITABLE
  KVM: x86/mmu: Consolidate comments about {Host,MMU}-writable

 arch/x86/kvm/mmu.h         |  38 -------------
 arch/x86/kvm/mmu/mmu.c     |  11 ++--
 arch/x86/kvm/mmu/spte.c    |  13 +----
 arch/x86/kvm/mmu/spte.h    | 113 +++++++++++++++++++++++++++----------
 arch/x86/kvm/mmu/tdp_mmu.c |   3 +
 5 files changed, 93 insertions(+), 85 deletions(-)


base-commit: e2e83a73d7ce66f62c7830a85619542ef59c90e4
-- 
2.35.0.rc0.227.g00780c9af4-goog

