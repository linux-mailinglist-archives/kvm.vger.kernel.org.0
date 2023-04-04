Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58CD36D5BE3
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 11:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234023AbjDDJ3R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 05:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbjDDJ3Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 05:29:16 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B10919BF;
        Tue,  4 Apr 2023 02:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1680600555; x=1712136555;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C5mQMP0x01Rrk1sey3GbQMsD215Z+M11qPtbaqbwWLU=;
  b=vfH7qUmMpB9c1MC8ZaW1zngK4e0fT29ErAfHpmHD82P8U4/QxEEkQc6O
   rEDkp5++euIksKUYLX/nBDknu9G/u/GIBegNdKupGhdP8GqhH/wx8Fq1V
   CJZjZqWExWjWOKHz1PVr5Td9dJfqyVD6kLJffWcpY1eMSRvRPNOepzZ3d
   M=;
X-IronPort-AV: E=Sophos;i="5.98,317,1673913600"; 
   d="scan'208";a="314520683"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-b1c0e1d0.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 09:29:11 +0000
Received: from EX19MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-m6i4x-b1c0e1d0.us-west-2.amazon.com (Postfix) with ESMTPS id F0E4C80456;
        Tue,  4 Apr 2023 09:29:09 +0000 (UTC)
Received: from EX19D002ANA003.ant.amazon.com (10.37.240.141) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Tue, 4 Apr 2023 09:29:09 +0000
Received: from b0f1d8753182.ant.amazon.com (10.95.136.176) by
 EX19D002ANA003.ant.amazon.com (10.37.240.141) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 4 Apr 2023 09:29:06 +0000
From:   Takahiro Itazuri <itazur@amazon.com>
To:     <sfr@canb.auug.org.au>
CC:     <itazur@amazon.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-next@vger.kernel.org>,
        <pbonzini@redhat.com>
Subject: Re: linux-next: build warning after merge of the kvm-fixes tree
Date:   Tue, 4 Apr 2023 10:28:55 +0100
Message-ID: <20230404092855.15368-1-itazur@amazon.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230404153642.769f5fb3@canb.auug.org.au>
References: <20230404153642.769f5fb3@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.95.136.176]
X-ClientProxiedBy: EX19D032UWB002.ant.amazon.com (10.13.139.190) To
 EX19D002ANA003.ant.amazon.com (10.37.240.141)
X-Spam-Status: No, score=-9.7 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Date:   Tue, 4 Apr 2023 15:36:42 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
> After merging the kvm-fixes tree, today's linux-next build (htmldocs)
> produced this warning:
> 
> Documentation/virt/kvm/api.rst:8343: WARNING: Field list ends without a blank line; unexpected unindent.
> 
> Introduced by commit
> 
>   c2594091d0e5 ("docs: kvm: x86: Fix broken field list")

It is my mistake. I do apologize.

I sent a new patch version to remove the warning.
https://lore.kernel.org/all/20230404090052.9872-1-itazur@amazon.com/

Best regards,
Takahiro Itazuri

