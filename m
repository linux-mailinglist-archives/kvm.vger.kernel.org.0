Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C64EC52C068
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 19:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240661AbiERRBd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 13:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240651AbiERRB3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 13:01:29 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738FD326CF;
        Wed, 18 May 2022 10:01:27 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id c14so2720734pfn.2;
        Wed, 18 May 2022 10:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N88H0czoo1fdiyjAEuf4MZG6526sP958mco2gNiBpws=;
        b=HorzJBxEjlmcTT8opaMMa6B9CFCM1p1mgQhAA/QOj4RsVWMnEQIu2tqhPCV0qp7QtE
         +EgyA/i5YNeWWN1kpWeXBMvrjyEP3EzePzf7XoXTNwzqYpafsIcbMqprbxNXNL04ehRx
         7qImA7dOqNikh10nmUIj498rfLrOHpSRqUv7QmDzevuwPO9u2GBwRSbA8kWgTIHhpMQc
         6/eghuZx9u65eBgOnbPG53+ZN/BU/bGm8+KtvLMgRVPEiFOs3gVh1+R4+UjKpWaChpIr
         w19qGDdnHpVoioJlE3oYyoQPYKTF+cYfkTnMH6sf7N81REFV200JZDpZZ+brMuLz4m70
         jVGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N88H0czoo1fdiyjAEuf4MZG6526sP958mco2gNiBpws=;
        b=rimseVAOnPnsMTPjXi/c3q/Bsp/uMzwcOafF9p+MP/mObnqTBgo7FjQSggE0K8lVzz
         F6k9C06yRPauUXPlChwYtpsGQoryKgTgI4d7vY67dbZ90EOwd887IW7C1UjEkA6lSUbK
         0/jz0afsXzVbyC/T3RTW0i1FbUjKLZBvSimuAu7Z6Mo5mwcBPZY0AFtzeVJ0hSngushC
         Sb57YJr9JrHNiwdfKZXT1PVA3HFjIsTxn/LXuCukBoWOa7NmZmrpCSElnNqt3CSF7F2M
         v+GYTv1/FqYO4iFMzhHO2VKXdWMfisMdkFox4oxoTyA4oXIXxkSGpJpiSD4nk3yN/krK
         sG9Q==
X-Gm-Message-State: AOAM533iKydVKsJ2absGXI7G9f3ICBRz9zedwuul6gdUoeEob8s38aFb
        UohDOjZS7GMSLMwHe3dyBSk=
X-Google-Smtp-Source: ABdhPJx9SOEYrUMpZbFRADRHuw5lj2iLwsIlelmGmuXigva8cECOeeuQN8FE3PitM9BxagRsBFRA0g==
X-Received: by 2002:a63:28c:0:b0:3c1:6f72:7288 with SMTP id 134-20020a63028c000000b003c16f727288mr350389pgc.564.1652893286076;
        Wed, 18 May 2022 10:01:26 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.117])
        by smtp.gmail.com with ESMTPSA id p42-20020a056a0026ea00b0050dc762818dsm2283240pfw.103.2022.05.18.10.01.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 10:01:25 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] KVM: selftests: x86: Sync the new name of the test case to the .gitignore
Date:   Thu, 19 May 2022 01:01:17 +0800
Message-Id: <20220518170118.66263-2-likexu@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518170118.66263-1-likexu@tencent.com>
References: <20220518170118.66263-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Fixing side effect of the so-called opportunistic change in the commit.

Fixes: dc8a9febbab0 ("KVM: selftests: x86: Fix test failure on arch lbr capable platforms")
Signed-off-by: Like Xu <likexu@tencent.com>
---
 tools/testing/selftests/kvm/.gitignore | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 4f48f9c2411d..f18ae306c916 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -55,7 +55,7 @@
 /x86_64/xen_shinfo_test
 /x86_64/xen_vmcall_test
 /x86_64/xss_msr_test
-/x86_64/vmx_pmu_msrs_test
+/x86_64/vmx_pmu_caps_test
 /access_tracking_perf_test
 /demand_paging_test
 /dirty_log_test
-- 
2.36.1

