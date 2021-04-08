Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C60493589BF
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 18:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232236AbhDHQ2m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 12:28:42 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:19501 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231918AbhDHQ2m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 12:28:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1617899311; x=1649435311;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=nMOUzFDnk5fm+FTvgXSXFX2ZDTXd0y1hb+al8HGRTjE=;
  b=nF+GNRsNoY/zGPG3j27/0yOIJsyzWr33KkbUq2tG81mo9YxJFJU6jmGO
   j0Gfs6xf4kK3AQFel4v/LUxfPyOcZgVhQJwFLTbZChkcta8ZeOaGx7Aa7
   Y73uvtq6uqNng8lxRCWoAFyfbPyMOmNkm59oCo5ZMitBXY7ez7zfzeg4I
   0=;
X-IronPort-AV: E=Sophos;i="5.82,206,1613433600"; 
   d="scan'208";a="100469738"
Subject: Re: [PATCH 0/4] Add support for XMM fast hypercalls
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 08 Apr 2021 16:21:21 +0000
Received: from EX13D28EUC003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (Postfix) with ESMTPS id 1CB9CA1E52;
        Thu,  8 Apr 2021 16:21:14 +0000 (UTC)
Received: from u366d62d47e3651.ant.amazon.com (10.43.160.209) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 8 Apr 2021 16:21:07 +0000
Date:   Thu, 8 Apr 2021 18:21:03 +0200
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Wei Liu <wei.liu@kernel.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>, <kys@microsoft.com>,
        <haiyangz@microsoft.com>, <sthemmin@microsoft.com>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <x86@kernel.org>, <hpa@zytor.com>, <seanjc@google.com>,
        <vkuznets@redhat.com>, <wanpengli@tencent.com>,
        <jmattson@google.com>, <joro@8bytes.org>, <graf@amazon.com>,
        <eyakovl@amazon.de>, <linux-hyperv@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Message-ID: <20210408162102.GE32315@u366d62d47e3651.ant.amazon.com>
References: <20210407212926.3016-1-sidcha@amazon.de>
 <20210408152817.k4d4hjdqu7hsjllo@liuwe-devbox-debian-v2>
 <033e7d77-d640-2c12-4918-da6b5b7f4e21@redhat.com>
 <20210408153813.iu3teoor6c6m6kzb@liuwe-devbox-debian-v2>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210408153813.iu3teoor6c6m6kzb@liuwe-devbox-debian-v2>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.160.209]
X-ClientProxiedBy: EX13D49UWB001.ant.amazon.com (10.43.163.72) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 08, 2021 at 03:38:13PM +0000, Wei Liu wrote:
> On Thu, Apr 08, 2021 at 05:30:26PM +0200, Paolo Bonzini wrote:
> > On 08/04/21 17:28, Wei Liu wrote:
> > > > Although the Hyper-v TLFS mentions that a guest cannot use this feature
> > > > unless the hypervisor advertises support for it, some hypercalls which
> > > > we plan on upstreaming in future uses them anyway.
> > >
> > > No, please don't do this. Check the feature bit(s) before you issue
> > > hypercalls which rely on the extended interface.
> >
> > Perhaps Siddharth should clarify this, but I read it as Hyper-V being buggy
> > and using XMM arguments unconditionally.
> >
> 
> There is no code in upstream Linux that uses the XMM fast hypercall
> interface at the moment.
> 
> If there is such code, it has bugs in it and should be fixed. :-)

None of the existing hypercalls are buggy. These are some hypercalls we
are working on (and planning on upstreaming in the near future). 

~ Sid.



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



