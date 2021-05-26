Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7C9A391366
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 11:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbhEZJLJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 05:11:09 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:52747 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233240AbhEZJLJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 05:11:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1622020179; x=1653556179;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=qbkbNRhn352fmLF1J2wDXbPVZ5g4pF7whTLHfrx7g4E=;
  b=AxGJ6LF04D0l8J5hwuUVwbJY94hfcXbpHdOBKZGmaViKJF76qGrORrz+
   G9PNLrwpXDeHwmJdirqZ7wMLYW1dzDxroRuUvGxE7DXv+dGw5/NJxUwO4
   GcVXNaQpg0HkX9auwZM5ZbtZ6qmcG533igYLGLAJcuxcXXbr78Tlru3Kw
   w=;
X-IronPort-AV: E=Sophos;i="5.82,331,1613433600"; 
   d="scan'208";a="136917606"
Subject: Re: [PATCH v3 4/4] KVM: hyper-v: Advertise support for fast XMM hypercalls
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2c-76e0922c.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 26 May 2021 09:09:39 +0000
Received: from EX13D28EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-76e0922c.us-west-2.amazon.com (Postfix) with ESMTPS id 94B5DA2BE1;
        Wed, 26 May 2021 09:09:31 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.160.17) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 26 May 2021 09:09:23 +0000
Date:   Wed, 26 May 2021 11:09:19 +0200
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Alexander Graf <graf@amazon.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>,
        <linux-hyperv@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>
Message-ID: <20210526090830.GA24931@uc8bbc9586ea454.ant.amazon.com>
References: <cover.1618349671.git.sidcha@amazon.de>
 <33a7e27046c15134667ea891feacbe3fe208f66e.1618349671.git.sidcha@amazon.de>
 <17a1ab38-10db-4fdf-411e-921738cd94e1@redhat.com>
 <20210525085708.GA26335@uc8bbc9586ea454.ant.amazon.com>
 <7fb8d792-e6e5-c241-6903-2a8c66fc2268@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7fb8d792-e6e5-c241-6903-2a8c66fc2268@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.160.17]
X-ClientProxiedBy: EX13D41UWC003.ant.amazon.com (10.43.162.30) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 25, 2021 at 01:20:41PM +0200, Paolo Bonzini wrote:
> On 25/05/21 11:00, Siddharth Chandrasekaran wrote:
> > Have you already picked these? Or can you still wait for v4? I can send
> > send separate patches too if it is too late to drop them. I had one
> > minor fixup and was waiting for Vitaly's changes to get merged as he
> > wanted me to add checks on the guest exposed cpuid bits before handling
> > XMM args.
>
> You can still send v4.

Thanks, I've sent v4 with just the fixup. I'll send a separate patch for
the guest cpuid check later.

~ Sid.



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



