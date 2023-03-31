Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE236D1B21
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 11:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231980AbjCaJBg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 05:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231909AbjCaJBJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 05:01:09 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C5A1E705;
        Fri, 31 Mar 2023 02:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1680253266; x=1711789266;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lGcln1Yy38FB1FKyZC1hblnNAiyDPepXHR1cvFJANnM=;
  b=GXw6GWY6mTTgX/LS6IcDT4Sb/+QtwxExQ+aRKfoy0dQE6cB/FYI6GhBs
   cS7lbhhqbRukN5LFrJBJy+Uwcs91Jqfi1x58pdoNlhmrUCCm9bQ2SM18B
   nXotcEd1OaP8CWOoM6PazrBXY6KLua1tL4FLYozUxhS3g8uyCDvokyxuS
   o=;
X-IronPort-AV: E=Sophos;i="5.98,307,1673913600"; 
   d="scan'208";a="324644567"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-a893d89c.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2023 09:01:00 +0000
Received: from EX19MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-a893d89c.us-west-2.amazon.com (Postfix) with ESMTPS id 86F5C415C9;
        Fri, 31 Mar 2023 09:00:59 +0000 (UTC)
Received: from EX19D002ANA003.ant.amazon.com (10.37.240.141) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Fri, 31 Mar 2023 09:00:59 +0000
Received: from b0f1d8753182.ant.amazon.com (10.106.83.11) by
 EX19D002ANA003.ant.amazon.com (10.37.240.141) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.26;
 Fri, 31 Mar 2023 09:00:55 +0000
From:   Takahiro Itazuri <itazur@amazon.com>
To:     <bagasdotme@gmail.com>
CC:     <corbet@lwn.net>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <zulinx86@gmail.com>
Subject: Re: [PATCH] docs: kvm: x86: Fix a broken field list
Date:   Fri, 31 Mar 2023 10:00:46 +0100
Message-ID: <20230331090046.98633-1-itazur@amazon.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <ZCZeWlhQ8GK7gYSi@debian.me>
References: <ZCZeWlhQ8GK7gYSi@debian.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.83.11]
X-ClientProxiedBy: EX19D045UWC003.ant.amazon.com (10.13.139.198) To
 EX19D002ANA003.ant.amazon.com (10.37.240.141)
X-Spam-Status: No, score=-7.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Date:   Fri, 31 Mar 2023 11:15:22 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
> Please don't say "This commit does foo", but rather "Do foo".
> Also, add:
> Fixes: ba7bb663f5547e ("KVM: x86: Provide per VM capability for disabling P=
> MU virtualization")

Thanks for correcting me! I'll fix it in PATCH v2.

Best regards,
