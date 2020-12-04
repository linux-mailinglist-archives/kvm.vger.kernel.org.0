Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF0632CF410
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 19:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730269AbgLDS2i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 13:28:38 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:51905 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727729AbgLDS2f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 13:28:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607106515; x=1638642515;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=9MociZt7TNSr5XPcL9H6jylYOX127/dLuihvGAG30Ek=;
  b=c4ce5O94NK2jLjdTcUlsehWGO0mnEIDWwBwdjxuK37agwUTPhh4okKXl
   GSZhFLY5XJX3CtaHnogSW9sXh3nDYRI7UbLmMUf7WM2kyptJ6JyX5ph+B
   s4vTaKA2NaHoYSP/nmtFpZYHQCpEGN4vcW6rOfnyDM7PXSdQtmNinPnXl
   Y=;
X-IronPort-AV: E=Sophos;i="5.78,393,1599523200"; 
   d="scan'208";a="900705563"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9103.sea19.amazon.com with ESMTP; 04 Dec 2020 18:27:42 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id 06E01A2177;
        Fri,  4 Dec 2020 18:27:39 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Dec 2020 18:27:39 +0000
Received: from Alexanders-MacBook-Air.local (10.43.160.21) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Dec 2020 18:27:36 +0000
Subject: Re: [PATCH 01/15] KVM: Fix arguments to kvm_{un,}map_gfn()
To:     David Woodhouse <dwmw2@infradead.org>, <kvm@vger.kernel.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>
References: <20201204011848.2967588-1-dwmw2@infradead.org>
 <20201204011848.2967588-2-dwmw2@infradead.org>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <cdee7797-b21b-2dad-0692-207dfe464980@amazon.com>
Date:   Fri, 4 Dec 2020 19:27:34 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201204011848.2967588-2-dwmw2@infradead.org>
Content-Language: en-US
X-Originating-IP: [10.43.160.21]
X-ClientProxiedBy: EX13D18UWA001.ant.amazon.com (10.43.160.11) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.12.20 02:18, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> =

> It shouldn't take a vcpu.

This is not a patch description. Please provide an actual rationale.


Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



