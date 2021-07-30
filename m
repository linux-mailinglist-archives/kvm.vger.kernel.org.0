Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4CD83DBA9B
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 16:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239239AbhG3ObO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 10:31:14 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:4984 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239079AbhG3ObN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 10:31:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1627655469; x=1659191469;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=r2ducjlY6kfmrauZUJ+kTKzaQXO5R1S1nGgp9OvdPsM=;
  b=bg0z1rXlfbgqiMhdh790cq/R11Qk85sPwD2v5cxA9wxbbpRExUr1RKE6
   EmXDqplJVcVG0J6OKe+JMDhXzb2HcoIb4e3+EOyX5FfsA+bSJowDaA+JB
   38iT0KCTABqGpu+J9WcoaTWMi67jDG/rfk6IcHxAwB8YH8Y9w4DpU/7I1
   Q=;
X-IronPort-AV: E=Sophos;i="5.84,282,1620691200"; 
   d="scan'208";a="149304825"
Subject: Re: [PATCH 2/4] KVM: x86: Introduce trace_kvm_hv_hypercall_done()
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-2b-55156cd4.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 30 Jul 2021 14:31:01 +0000
Received: from EX13D28EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-55156cd4.us-west-2.amazon.com (Postfix) with ESMTPS id BDC43A20FD;
        Fri, 30 Jul 2021 14:31:00 +0000 (UTC)
Received: from u366d62d47e3651.ant.amazon.com (10.43.160.189) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Fri, 30 Jul 2021 14:30:17 +0000
Date:   Fri, 30 Jul 2021 16:30:13 +0200
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        <linux-kernel@vger.kernel.org>
Message-ID: <20210730143012.GB20232@u366d62d47e3651.ant.amazon.com>
References: <20210730122625.112848-1-vkuznets@redhat.com>
 <20210730122625.112848-3-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210730122625.112848-3-vkuznets@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.160.189]
X-ClientProxiedBy: EX13D48UWB002.ant.amazon.com (10.43.163.125) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 30, 2021 at 02:26:23PM +0200, Vitaly Kuznetsov wrote:
> Hypercall failures are unusual with potentially far going consequences
> so it would be useful to see their results when tracing.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Reviewed-by: Siddharth Chandrasekaran <sidcha@amazon.de>



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



