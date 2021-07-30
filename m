Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 379EB3DBA94
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 16:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239108AbhG3O34 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 10:29:56 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:10765 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbhG3O3z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 10:29:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1627655391; x=1659191391;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=4ugGiWQLoikc/lxB+XFb2AusVBQMiZ2U9lIaxumsem8=;
  b=UBa70MqBX7NOlP4fYWMWG7nAdfG1RD+awih3V3tJoKgaguzUKxCZ03W7
   Xm7rDXA8WMAVcP4TqN+KxtNoYi1TBWphmD8Ozmu48A4qeVrvmMAIvV0RR
   Z0TGGMbEgoCoAFoRWBqIfBqJv1O1o1Ewf1M0Wot2QUKBLh0683u7FfyLA
   A=;
X-IronPort-AV: E=Sophos;i="5.84,282,1620691200"; 
   d="scan'208";a="947326459"
Subject: Re: [PATCH 1/4] KVM: x86: hyper-v: Check access to hypercall before reading
 XMM registers
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 30 Jul 2021 14:29:43 +0000
Received: from EX13D28EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com (Postfix) with ESMTPS id 97D37A232E;
        Fri, 30 Jul 2021 14:29:42 +0000 (UTC)
Received: from u366d62d47e3651.ant.amazon.com (10.43.160.41) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Fri, 30 Jul 2021 14:29:38 +0000
Date:   Fri, 30 Jul 2021 16:29:34 +0200
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        <linux-kernel@vger.kernel.org>
Message-ID: <20210730142933.GA20232@u366d62d47e3651.ant.amazon.com>
References: <20210730122625.112848-1-vkuznets@redhat.com>
 <20210730122625.112848-2-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210730122625.112848-2-vkuznets@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.160.41]
X-ClientProxiedBy: EX13D10UWB001.ant.amazon.com (10.43.161.111) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 30, 2021 at 02:26:22PM +0200, Vitaly Kuznetsov wrote:
> In case guest doesn't have access to the particular hypercall we can avoid
> reading XMM registers.
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



