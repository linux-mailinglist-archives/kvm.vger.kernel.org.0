Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81DB95392F1
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 16:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345145AbiEaOKW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 10:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345105AbiEaOKU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 10:10:20 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42EBB663D3;
        Tue, 31 May 2022 07:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1654006220; x=1685542220;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=x2yPGrbQEvZ7qvzj6D7a5D6J1wQ2pUt6/iDyChuBM2A=;
  b=DZGlgbCFgSG1gztyoX0pIi/XYYY7S46zvZ+GhGVNIYhls7XLwt1GJcBZ
   GLCrPqDg3/lD+aP73Qe7+4dpEtOaqN5GrgnSfKHTNHtFhzqO3QHo8bINL
   HOV1PCWM2DvcViVOdmtS3gleTW9Xnx1HvOAEYr7f9Zj3z8GYrsJTPR6Li
   k=;
X-IronPort-AV: E=Sophos;i="5.91,265,1647302400"; 
   d="scan'208";a="223960787"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-7a21ed79.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 31 May 2022 14:02:46 +0000
Received: from EX13D33EUC003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-7a21ed79.us-east-1.amazon.com (Postfix) with ESMTPS id 5B757220F0A;
        Tue, 31 May 2022 14:02:40 +0000 (UTC)
Received: from EX13MTAUEA002.ant.amazon.com (10.43.61.77) by
 EX13D33EUC003.ant.amazon.com (10.43.164.166) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Tue, 31 May 2022 14:02:39 +0000
Received: from dev-dsk-jalliste-1c-387c3ddf.eu-west-1.amazon.com
 (10.13.250.64) by mail-relay.amazon.com (10.43.61.169) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36 via Frontend Transport; Tue, 31 May 2022
 14:02:36 +0000
From:   Jack Allister <jalliste@amazon.com>
To:     <peterz@infradead.org>
CC:     <bp@alien8.de>, <diapop@amazon.co.uk>, <hpa@zytor.com>,
        <jalliste@amazon.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <metikaya@amazon.co.uk>, <mingo@redhat.com>, <pbonzini@redhat.com>,
        <rkrcmar@redhat.com>, <sean.j.christopherson@intel.com>,
        <tglx@linutronix.de>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <x86@kernel.org>
Subject: ...\n
Date:   Tue, 31 May 2022 14:02:36 +0000
Message-ID: <20220531140236.1435-1-jalliste@amazon.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <YpYaYK7a28DFT5Ne@hirez.programming.kicks-ass.net>
References: <YpYaYK7a28DFT5Ne@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-15.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The reasoning behind this is that you may want to run a guest at a
lower CPU frequency for the purposes of trying to match performance
parity between a host of an older CPU type to a newer faster one.

