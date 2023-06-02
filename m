Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51DC271FC42
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 10:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234619AbjFBIml (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 04:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234617AbjFBImj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 04:42:39 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6FA913D;
        Fri,  2 Jun 2023 01:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1685695360; x=1717231360;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aqeLaj4InU7hZID0f/fNPIZOwI5sblKIxvQvW1SOYU4=;
  b=v8tmHRK3rqZV8TNRzzW5asVII4LBRY5tU7l5qGzqKkN5bvPps8sS3t/2
   H3GhZSCoGdERMAKmlHg+ObTvgmvw/oVx/y5WkzBinxUGKLIOkDsaNqWqO
   w00hr42Cbaov/UhcqeJ4p3EIyiOq8z9GOxkRQYhMALRQ1umfX8g+6q/YA
   k=;
X-IronPort-AV: E=Sophos;i="6.00,212,1681171200"; 
   d="scan'208";a="336042304"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-94edd59b.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 08:42:37 +0000
Received: from EX19MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-m6i4x-94edd59b.us-west-2.amazon.com (Postfix) with ESMTPS id 4BAF84146A;
        Fri,  2 Jun 2023 08:42:35 +0000 (UTC)
Received: from EX19D002ANA003.ant.amazon.com (10.37.240.141) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 2 Jun 2023 08:42:34 +0000
Received: from b0f1d8753182.ant.amazon.com (10.95.97.250) by
 EX19D002ANA003.ant.amazon.com (10.37.240.141) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 2 Jun 2023 08:42:31 +0000
From:   Takahiro Itazuri <itazur@amazon.com>
To:     <seanjc@google.com>
CC:     <itazur@amazon.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>
Subject: Re: [PATCH v3 0/2] KVM: x86: Report actual nent from KVM_GET_CPUID2
Date:   Fri, 2 Jun 2023 09:42:21 +0100
Message-ID: <20230602084221.9056-1-itazur@amazon.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230526210340.2799158-1-seanjc@google.com>
References: <20230526210340.2799158-1-seanjc@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.95.97.250]
X-ClientProxiedBy: EX19D033UWA003.ant.amazon.com (10.13.139.42) To
 EX19D002ANA003.ant.amazon.com (10.37.240.141)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Date:   Fri, 26 May 2023 14:03:38 -0700
From:   Sean Christopherson <seanjc@google.com>
> Essentially v3 of Takahiro's patch.  Update cpuid->nent on a successful
> KVM_GET_CPUID2 so that userspace knows exactly how many entries were
> filled.  Add a testcase to verify KVM's ABI.

Sorry for my late reply and thank you for posting this revision!

Best regards,
Takahiro Itazuri

