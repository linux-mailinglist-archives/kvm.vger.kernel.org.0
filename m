Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED83F750F32
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 19:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbjGLRD3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 13:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjGLRD2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 13:03:28 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB661703;
        Wed, 12 Jul 2023 10:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1689181407; x=1720717407;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pOw98pQ3Xg4VKFxy4pt18FR+Wh1ZzoBxMRhMX9aZkCE=;
  b=jo/eNKemh3rUC8io42SAHv31/6aT/2tn1DCrNIJYcDQJ0cfj6XtpdL/v
   q/1JlINJpQZboq53EK+v9kS0pu+dewnxlQqrh9XU/8W6ZA3rM+UVdn392
   XjD3flxELT6Zog2YnmMeuRkW+zgUlq0lfnBfy97buQeLaHVk3qyklD4Kf
   Y=;
X-IronPort-AV: E=Sophos;i="6.01,200,1684800000"; 
   d="scan'208";a="344233840"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-bbc6e425.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 17:03:24 +0000
Received: from EX19MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-m6i4x-bbc6e425.us-east-1.amazon.com (Postfix) with ESMTPS id 1C23E80CB2;
        Wed, 12 Jul 2023 17:03:24 +0000 (UTC)
Received: from EX19D002ANA003.ant.amazon.com (10.37.240.141) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Wed, 12 Jul 2023 17:03:23 +0000
Received: from b0f1d8753182.ant.amazon.com (10.106.83.21) by
 EX19D002ANA003.ant.amazon.com (10.37.240.141) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Wed, 12 Jul 2023 17:03:19 +0000
From:   Takahiro Itazuri <itazur@amazon.com>
To:     <seanjc@google.com>
CC:     <itazur@amazon.com>, <jmattson@google.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <x86@kernel.org>, <zulinx86@gmail.com>
Subject: Re: [PATCH 1/1] KVM: pass through CPUID(0x80000006)
Date:   Wed, 12 Jul 2023 18:02:58 +0100
Message-ID: <20230712170258.75355-1-itazur@amazon.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <ZK7NmfKI9xur/Mop@google.com>
References: <ZK7NmfKI9xur/Mop@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.83.21]
X-ClientProxiedBy: EX19D040UWA004.ant.amazon.com (10.13.139.93) To
 EX19D002ANA003.ant.amazon.com (10.37.240.141)
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 12 Jul 2023, Sean Christopherson wrote:
> Trimmed the Cc to remove folks that no longer directly work on any of this stuff.

I apologize for it and appreciate your reply on this.

> > Regard security aspect, I'm a bit concerned that it could help malicious
> > guests to know something to allow cache side channel attacks. However,
> > CPUID 0x80000006 has already passed through L2 Cache and TLB and L3
> > Cache Information. If passing through CPUID 0x80000006 is really fine,
> > I'm guessing it is the case with CPUID 0x80000005 as well.
> 
> It's definitely harmless from a security perspective.  Userspace already has
> access to this information as CPUID is NOT a priveleged instructions.  And the
> kernel also publishes this information in sysfs, e.g. /sys/devices/system/cpu/cpuN/cache,
> and AFAIK that's not typically restricted.

I'm releaved to hear that.

> I'm mildly tempted to remove 0x80000006, for similar reasons as commit 45e966fcca03
> ("KVM: x86: Do not return host topology information from KVM_GET_SUPPORTED_CPUID"),
> but I suspect that would do more harm than good, e.g. Linux falls back to
> 0x80000005 and 0x80000006 when running on AMD without extended topology info.

Actually I also saw the commit and I was a bit confused about which
leaves to pass through. As you mentioned, CPUID is accessible from
userspace and VMM can query it if they want.

> I think it makes sense to enumerate 0x80000005.  Reporting 0x80000006 but not
> 0x80000005 seems to be the *worst* behavior, so as I see it, the decision is
> really between adding 0x80000005 and removing 0x80000006.  Adding 0x80000005
> appears to be the least risky choice given that KVM has reported 0x80000006 for
> over three years.

I'm on the same page that either reporting both or none of them is
better. I'll create a patch for the least risky one.

Best regards,
Takahiro Itazuri

