Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5651938FD55
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 11:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbhEYJEW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 05:04:22 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:57005 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbhEYJEW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 May 2021 05:04:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1621933373; x=1653469373;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=WtzqT9o4zsMGoJ/sAIP+psmlg/qcjO7AW+EneulTjes=;
  b=Ezih+ptk95AMAT6UtRZzB7Gzbt48xmFxpLfZhIDvGGx+Awlb0qlwRkED
   BFBYYHZg3b8Cbh/BRlh+ZXzqm1nYoRsiKCFx0g/FXz95D8VOP9viWaoxB
   BR1Ddb3vOeYNRCA0iB9LEvkW51OLhGdfhxWgZdoFxrQ3WiCJ+k4jX+76F
   U=;
X-IronPort-AV: E=Sophos;i="5.82,328,1613433600"; 
   d="scan'208";a="109969001"
Subject: Re: [PATCH v3 4/4] KVM: hyper-v: Advertise support for fast XMM hypercalls
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-e7be2041.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-4101.iad4.amazon.com with ESMTP; 25 May 2021 09:00:44 +0000
Received: from EX13D28EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-e7be2041.us-west-2.amazon.com (Postfix) with ESMTPS id C5328A06F8;
        Tue, 25 May 2021 09:00:42 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.162.227) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Tue, 25 May 2021 09:00:35 +0000
Date:   Tue, 25 May 2021 11:00:30 +0200
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
Message-ID: <20210525085708.GA26335@uc8bbc9586ea454.ant.amazon.com>
References: <cover.1618349671.git.sidcha@amazon.de>
 <33a7e27046c15134667ea891feacbe3fe208f66e.1618349671.git.sidcha@amazon.de>
 <17a1ab38-10db-4fdf-411e-921738cd94e1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <17a1ab38-10db-4fdf-411e-921738cd94e1@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.162.227]
X-ClientProxiedBy: EX13D14UWB001.ant.amazon.com (10.43.161.158) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 24, 2021 at 02:00:22PM +0200, Paolo Bonzini wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> 
> 
> 
> On 13/04/21 23:50, Siddharth Chandrasekaran wrote:
> > Now that kvm_hv_flush_tlb() has been patched to support XMM hypercall
> > inputs, we can start advertising this feature to guests.
> > 
> > Cc: Alexander Graf <graf@amazon.com>
> > Cc: Evgeny Iakovlev <eyakovl@amazon.de>
> > Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
> > ---
> >   arch/x86/include/asm/hyperv-tlfs.h | 7 ++++++-
> >   arch/x86/kvm/hyperv.c              | 1 +
> >   2 files changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
> > index ee6336a54f92..597ae1142864 100644
> > --- a/arch/x86/include/asm/hyperv-tlfs.h
> > +++ b/arch/x86/include/asm/hyperv-tlfs.h
> > @@ -52,7 +52,7 @@
> >    * Support for passing hypercall input parameter block via XMM
> >    * registers is available
> >    */
> > -#define HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE                BIT(4)
> > +#define HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE         BIT(4)
> >   /* Support for a virtual guest idle state is available */
> >   #define HV_X64_GUEST_IDLE_STATE_AVAILABLE           BIT(5)
> >   /* Frequency MSRs available */
> > @@ -61,6 +61,11 @@
> >   #define HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE                BIT(10)
> >   /* Support for debug MSRs available */
> >   #define HV_FEATURE_DEBUG_MSRS_AVAILABLE                     BIT(11)
> > +/*
> > + * Support for returning hypercall output block via XMM
> > + * registers is available
> > + */
> > +#define HV_X64_HYPERCALL_XMM_OUTPUT_AVAILABLE                BIT(15)
> >   /* stimer Direct Mode is available */
> >   #define HV_STIMER_DIRECT_MODE_AVAILABLE                     BIT(19)
> > 
> > diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> > index cd6c6f1f06a4..0f6fd7550510 100644
> > --- a/arch/x86/kvm/hyperv.c
> > +++ b/arch/x86/kvm/hyperv.c
> > @@ -2235,6 +2235,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
> >                       ent->ebx |= HV_POST_MESSAGES;
> >                       ent->ebx |= HV_SIGNAL_EVENTS;
> > 
> > +                     ent->edx |= HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE;
> >                       ent->edx |= HV_FEATURE_FREQUENCY_MSRS_AVAILABLE;
> >                       ent->edx |= HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE;
> > 
> > 
> 
> Queued, thanks.

Have you already picked these? Or can you still wait for v4? I can send
send separate patches too if it is too late to drop them. I had one
minor fixup and was waiting for Vitaly's changes to get merged as he
wanted me to add checks on the guest exposed cpuid bits before handling
XMM args.

Apologies for the trouble.

~ Sid.



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



