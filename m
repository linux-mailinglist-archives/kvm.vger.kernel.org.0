Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B80F46A7419
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 20:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbjCATOO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 14:14:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjCATOH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 14:14:07 -0500
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 132FC34015;
        Wed,  1 Mar 2023 11:14:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1677698046; x=1709234046;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3wwzPb0/fcEw/uxsWSGn8+ksVDNwZHA6YXQnQDFNs3I=;
  b=l2nYOPdmNJC542F6MTGph5fweeumSPoATCE+EwGoL7vg/OXUVgYDvSZm
   oZpNmy7zGLAfFjo0veepl9j4OGRRvzCrFRMp+X7VUtU8Kg+w0KtrVvVVM
   YTAHBJojnSXIaHaJ82q/qpaj/NGVtlqX2fBtaM5U5Uz0xxPVD1Q4cZf4K
   A=;
X-IronPort-AV: E=Sophos;i="5.98,225,1673913600"; 
   d="scan'208";a="1108222414"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-0aba4706.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 18:59:01 +0000
Received: from EX13MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-m6i4x-0aba4706.us-east-1.amazon.com (Postfix) with ESMTPS id B46B7AA1A5;
        Wed,  1 Mar 2023 18:59:00 +0000 (UTC)
Received: from EX19D002ANA002.ant.amazon.com (10.37.240.152) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Wed, 1 Mar 2023 18:58:59 +0000
Received: from b0f1d8753182.ant.amazon.com.com (10.95.161.59) by
 EX19D002ANA002.ant.amazon.com (10.37.240.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.24;
 Wed, 1 Mar 2023 18:58:56 +0000
From:   Takahiro Itazuri <itazur@amazon.com>
To:     <kvm@vger.kernel.org>, Sean Christopherson <seanjc@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>
CC:     <linux-kernel@vger.kernel.org>,
        Takahiro Itazuri <zulinx86@gmail.com>,
        Takahiro Itazuri <itazur@amazon.com>
Subject: [PATCH v2 0/1] KVM: x86: Propagate AMD-specific IBRS bits to guests
Date:   Wed, 1 Mar 2023 18:58:37 +0000
Message-ID: <20230301185838.21659-1-itazur@amazon.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.95.161.59]
X-ClientProxiedBy: EX19D035UWB004.ant.amazon.com (10.13.138.104) To
 EX19D002ANA002.ant.amazon.com (10.37.240.152)
X-Spam-Status: No, score=-10.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since v2:
* Move feature bits macros from arch/x86/include/asm/cpufeatures.h to
  arch/x86/kvm/reverse_cpuid.h.

Takahiro Itazuri (1):
  KVM: x86: Propagate AMD-specific IBRS bits to guests

 arch/x86/kvm/cpuid.c         | 5 +++--
 arch/x86/kvm/reverse_cpuid.h | 5 +++++
 2 files changed, 8 insertions(+), 2 deletions(-)

-- 
2.38.0

