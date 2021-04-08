Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7059D3588F2
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 17:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbhDHPzN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 11:55:13 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:5339 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbhDHPzM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 11:55:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1617897301; x=1649433301;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=tnSfbdlPVrnoXs/CcVWL+1OsISLvlQaieFsHWyaOUNM=;
  b=AOs+UGYway5XaaaKu8gJKCc6aONtLi+VhI+s7l8Vvxzz2XgBi8PAtZBQ
   OI9BRfWgE3ODAnEFCwzVrLdTQwe+SweSypQWVjwioGC59Vy5fqcz9s12U
   DCjOwLnZ9P98re/Jlbt7mp4DKZeYTnuLSQ9AYcvtKwU+itwA9bnMRES2o
   4=;
X-IronPort-AV: E=Sophos;i="5.82,206,1613433600"; 
   d="scan'208";a="101984579"
Subject: Re: [PATCH 0/4] Add support for XMM fast hypercalls
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-c7f73527.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 08 Apr 2021 15:54:56 +0000
Received: from EX13D28EUC003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-c7f73527.us-east-1.amazon.com (Postfix) with ESMTPS id 91701C138C;
        Thu,  8 Apr 2021 15:54:54 +0000 (UTC)
Received: from u366d62d47e3651.ant.amazon.com (10.43.162.104) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 8 Apr 2021 15:54:46 +0000
Date:   Thu, 8 Apr 2021 17:54:43 +0200
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Wei Liu <wei.liu@kernel.org>, <kys@microsoft.com>,
        <haiyangz@microsoft.com>, <sthemmin@microsoft.com>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <x86@kernel.org>, <hpa@zytor.com>, <seanjc@google.com>,
        <vkuznets@redhat.com>, <wanpengli@tencent.com>,
        <jmattson@google.com>, <joro@8bytes.org>, <graf@amazon.com>,
        <eyakovl@amazon.de>, <linux-hyperv@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Message-ID: <20210408155442.GC32315@u366d62d47e3651.ant.amazon.com>
References: <20210407212926.3016-1-sidcha@amazon.de>
 <20210408152817.k4d4hjdqu7hsjllo@liuwe-devbox-debian-v2>
 <033e7d77-d640-2c12-4918-da6b5b7f4e21@redhat.com>
 <20210408154006.GA32315@u366d62d47e3651.ant.amazon.com>
 <53200f24-bd57-1509-aee2-0723aa8a3f6f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <53200f24-bd57-1509-aee2-0723aa8a3f6f@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.162.104]
X-ClientProxiedBy: EX13D07UWA002.ant.amazon.com (10.43.160.77) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 08, 2021 at 05:48:19PM +0200, Paolo Bonzini wrote:
> On 08/04/21 17:40, Siddharth Chandrasekaran wrote:
> > > > > Although the Hyper-v TLFS mentions that a guest cannot use this feature
> > > > > unless the hypervisor advertises support for it, some hypercalls which
> > > > > we plan on upstreaming in future uses them anyway.
> > > > No, please don't do this. Check the feature bit(s) before you issue
> > > > hypercalls which rely on the extended interface.
> > > Perhaps Siddharth should clarify this, but I read it as Hyper-V being
> > > buggy and using XMM arguments unconditionally.
> > The guest is at fault here as it expects Hyper-V to consume arguments
> > from XMM registers for certain hypercalls (that we are working) even if
> > we didn't expose the feature via CPUID bits.
>
> What guest is that?

It is a Windows Server 2016.



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



