Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A53979D8E8
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 20:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbjILSqC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 14:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjILSqB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 14:46:01 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A2510D9
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 11:45:56 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d8011973047so4728449276.3
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 11:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694544356; x=1695149156; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B2rRRkwJ624R5lilgRAD1s7bupuYQgBUdfkfMGTk6KY=;
        b=0Vrf8PpaJgPaG1NInwpZkFj3QKA6OKrWMCQrdWSFQokD789OVkzTvavBg+e7BseuAN
         dy1K3SNyP0RfB0a2ggMuRhGC17wIPXW0fM/msKmcbhArwlPlZP+AHx7K9kK4TNEczEuj
         lbZGQ0WdZTdCcPiK2u+z4fg1uel10J9vKM/JrnYfUe0LwphHw4rIoQvFtNQX4v7pSgiF
         EzOgSFYzhRiZo/CPSlNUVXHca/ib/cruJ5DYRaV65Cgz44l2e046kYHW8ZLJGq925Voj
         9E08rXC+1w4qCBXj2pcthYP0RjBm+u/1Fa2XaGQf81aLU3v73BoaacGJA56ebvXjG2sz
         0nag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694544356; x=1695149156;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B2rRRkwJ624R5lilgRAD1s7bupuYQgBUdfkfMGTk6KY=;
        b=XSJ1uIl0U+E/5Pt+Srz5jlSQcPQpPf1ScHGml+WAt5XoIG6xL81fJBlYXP1Z0sXR2V
         oaPPRHzyk4jNs3+PxxLLzifl5nxR+zGuO3QlNZkhyPAyVn33/VhZJsXMnKtLlodOGPrT
         Zpjg2ludgVWRdKfc6r+nsQ3o3slypfFvdwh5PJSashLn4Z0nsSlc6IofOvZzX1HQpg/v
         dnqzBGxlxHFKlBUywKopsSq/PkzUDqD8Iu5KHe+yB4aFJ1LCLWrFXK5Fu4a75g/uRjMV
         43WImE6P8A+GGJInUiGJwKlMYCz41R85diN71hUghBJ1De5RFC7ezq06pUJI9ZIEUoBZ
         THWw==
X-Gm-Message-State: AOJu0YzWwpDAUx1ma9yFqk+R1+b5VIsDzUTJ5b0N21nYqjFw/DKQbYAX
        ldCflhXPP2X7x8xI1z1jyR9tQzsz/Zno
X-Google-Smtp-Source: AGHT+IFDuqBuF6faoNV5q4VGomEhZd9Dl3ZyjNcfkE8WbBIXxXHrtJMPGLwSJb7NeeDo77cPg+GWEFU1FWN+
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a25:8201:0:b0:d7b:9d44:7578 with SMTP id
 q1-20020a258201000000b00d7b9d447578mr4147ybk.12.1694544356015; Tue, 12 Sep
 2023 11:45:56 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Tue, 12 Sep 2023 18:45:47 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230912184553.1887764-1-mizhang@google.com>
Subject: [PATCH v4 0/6] Update document description for kvm_mmu_page and kvm_mmu_page_role
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>, Xu Yilun <yilun.xu@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is 4th version of the series, minor fixes as follows:
 - correct the descripotion of tdp_mmu_root_count [seanjc]
 - update the descripotion of mmu_valid_gen [seanjc]

v3: https://lore.kernel.org/all/20230801002127.534020-1-mizhang@google.com/

Mingwei Zhang (6):
  KVM: Documentation: Add the missing description for guest_mode in
    kvm_mmu_page_role
  KVM: Documentation: Update the field name gfns and its description in
    kvm_mmu_page
  KVM: Documentation: Add the missing description for ptep in
    kvm_mmu_page
  KVM: Documentation: Add the missing description for tdp_mmu_root_count
    into kvm_mmu_page
  KVM: Documentation: Add the missing description for mmu_valid_gen into
    kvm_mmu_page
  KVM: Documentation: Add the missing description for tdp_mmu_page into
    kvm_mmu_page

 Documentation/virt/kvm/x86/mmu.rst | 43 +++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 9 deletions(-)


base-commit: bfd926291c585600ace63ea3b6eb1458aa067f4f
-- 
2.42.0.283.g2d96d420d3-goog

