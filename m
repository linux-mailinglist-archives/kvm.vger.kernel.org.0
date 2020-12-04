Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 066E02CF438
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 19:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728553AbgLDSi7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 13:38:59 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:37028 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgLDSi7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 13:38:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607107139; x=1638643139;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=XlrKYk/M1jvQ0MDnIc5xTmRqCYJAUffLFZVUo9xuEeI=;
  b=YwWN4Bdxj+ioVGL8OaTevrxBWK5SgNGRIOtzyMWOnBofh5hNmc1xiCfr
   zzRr5mFFzAGxKEAY7zxoCaDlmHEY5CzTjzzvLvv+EqwsCTi3WSKrJtHNh
   +mmSRtITzpWaxzdlhJBi0WkbBFoZeETHyG0ilDBjKgYg6xckXLVKvwoQ2
   g=;
X-IronPort-AV: E=Sophos;i="5.78,393,1599523200"; 
   d="scan'208";a="69210751"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-41350382.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 04 Dec 2020 18:38:12 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-41350382.us-west-2.amazon.com (Postfix) with ESMTPS id C62D0C2C77;
        Fri,  4 Dec 2020 18:38:10 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Dec 2020 18:38:10 +0000
Received: from Alexanders-MacBook-Air.local (10.43.160.229) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Dec 2020 18:38:07 +0000
Subject: Re: [PATCH 06/15] KVM: x86/xen: latch long_mode when hypercall page
 is set up
To:     David Woodhouse <dwmw2@infradead.org>, <kvm@vger.kernel.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>
References: <20201204011848.2967588-1-dwmw2@infradead.org>
 <20201204011848.2967588-7-dwmw2@infradead.org>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <85442dac-7ed9-73d0-f8b3-2750dffa5278@amazon.com>
Date:   Fri, 4 Dec 2020 19:38:05 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201204011848.2967588-7-dwmw2@infradead.org>
Content-Language: en-US
X-Originating-IP: [10.43.160.229]
X-ClientProxiedBy: EX13D38UWB002.ant.amazon.com (10.43.161.171) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.12.20 02:18, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>

If the shared_info page was maintained by user space, you wouldn't need =

any of this, right?


Alex




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



