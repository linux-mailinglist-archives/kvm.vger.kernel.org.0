Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3EE66E47D1
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 14:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbjDQMct (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 08:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbjDQMcl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 08:32:41 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9378F6194
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 05:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1681734753; x=1713270753;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=FMyY6FKc1+FIbGIUGUz70gAh1LT1uFb9VjrjzX1/T/Y=;
  b=HEz9UGNBZ9hAC/F0dVs8iNAnkk44kV2ecb8dka3uAFz9GmMh93MgECBy
   v1C9sLrVHnkipErAI/TQkvlyCiM3tmfwRiO5hKdoUgir1zgqtHCd3U1uA
   o0RhvqKMlGscZ4wGB3pc+zXKzmtIXszEmQT8BGEJr+FKq1l1tvVzKvegy
   A=;
X-IronPort-AV: E=Sophos;i="5.99,204,1677542400"; 
   d="scan'208";a="205111107"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-0aba4706.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 12:22:19 +0000
Received: from EX19MTAUEA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-m6i4x-0aba4706.us-east-1.amazon.com (Postfix) with ESMTPS id D5030A261B;
        Mon, 17 Apr 2023 12:22:15 +0000 (UTC)
Received: from EX19D008UEA003.ant.amazon.com (10.252.134.116) by
 EX19MTAUEA001.ant.amazon.com (10.252.134.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 17 Apr 2023 12:22:15 +0000
Received: from EX19MTAUWA001.ant.amazon.com (10.250.64.204) by
 EX19D008UEA003.ant.amazon.com (10.252.134.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 17 Apr 2023 12:22:14 +0000
Received: from dev-dsk-metikaya-1c-d447d167.eu-west-1.amazon.com
 (10.13.250.103) by mail-relay.amazon.com (10.250.64.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26 via Frontend Transport; Mon, 17 Apr 2023 12:22:12 +0000
From:   Metin Kaya <metikaya@amazon.co.uk>
To:     <kvm@vger.kernel.org>, <pbonzini@redhat.com>
CC:     <x86@kernel.org>, <bp@alien8.de>, <dwmw@amazon.co.uk>,
        <paul@xen.org>, <seanjc@google.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
        <joao.m.martins@oracle.com>
Subject: 
Date:   Mon, 17 Apr 2023 12:22:05 +0000
Message-ID: <20230417122206.34647-1-metikaya@amazon.co.uk>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2: Removed an internal URL from the commit message.


