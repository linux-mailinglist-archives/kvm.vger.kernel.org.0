Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C78363596EC
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 09:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232373AbhDIH4F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 03:56:05 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:15228 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbhDIH4F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Apr 2021 03:56:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1617954953; x=1649490953;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=BJxY6uzNd1eqL/AmYQtKHlFqsRdbG/hESPW6+LfJYVU=;
  b=W/765iYj1um90S53kp6bWWzQgpncOnxV6H9LDyVBab/zUVcJoQlVv+JA
   1kUXm3PTWhdrslEEdMI+mhX2AFj4c76WJ4gKGyfURtGX4cy8Nanpz9+7F
   1I1piw1GxFMr1ITE+frmZz7Ry/WMaUf2kLxs/e3JdgqYQLRWbVWS6ovmo
   o=;
X-IronPort-AV: E=Sophos;i="5.82,208,1613433600"; 
   d="scan'208";a="106476224"
Subject: Re: [PATCH 4/4] KVM: hyper-v: Advertise support for fast XMM hypercalls
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 09 Apr 2021 07:55:46 +0000
Received: from EX13D28EUC003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id 1317C28BCBD;
        Fri,  9 Apr 2021 07:55:39 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.162.207) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 9 Apr 2021 07:55:32 +0000
Date:   Fri, 9 Apr 2021 09:55:28 +0200
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     Alexander Graf <graf@amazon.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        <linux-hyperv@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "Jim Mattson" <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>
Message-ID: <20210409075335.GA26597@uc8bbc9586ea454.ant.amazon.com>
References: <20210407211954.32755-1-sidcha@amazon.de>
 <20210407211954.32755-5-sidcha@amazon.de>
 <87blap7zha.fsf@vitty.brq.redhat.com>
 <20210408142053.GA10636@u366d62d47e3651.ant.amazon.com>
 <8735w096pk.fsf@vitty.brq.redhat.com>
 <20210408155220.GB32315@u366d62d47e3651.ant.amazon.com>
 <87zgy77vs4.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87zgy77vs4.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.162.207]
X-ClientProxiedBy: EX13D20UWC002.ant.amazon.com (10.43.162.163) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 09, 2021 at 09:38:03AM +0200, Vitaly Kuznetsov wrote:
> Siddharth Chandrasekaran <sidcha@amazon.de> writes:
> > On Thu, Apr 08, 2021 at 04:44:23PM +0200, Vitaly Kuznetsov wrote:
> >> Siddharth Chandrasekaran <sidcha@amazon.de> writes:
> >> > On Thu, Apr 08, 2021 at 02:05:53PM +0200, Vitaly Kuznetsov wrote:
> >> >> Siddharth Chandrasekaran <sidcha@amazon.de> writes:
> >> >>
> >> >> > Now that all extant hypercalls that can use XMM registers (based on
> >> >> > spec) for input/outputs are patched to support them, we can start
> >> >> > advertising this feature to guests.
> >> >> >
> >> >> > Cc: Alexander Graf <graf@amazon.com>
> >> >> > Cc: Evgeny Iakovlev <eyakovl@amazon.de>
> >> >> > Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
> >> >> > ---
> >> >> >  arch/x86/include/asm/hyperv-tlfs.h | 4 ++--
> >> >> >  arch/x86/kvm/hyperv.c              | 1 +
> >> >> >  2 files changed, 3 insertions(+), 2 deletions(-)
> >> >> >
> >> >> > diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
> >> >> > index e6cd3fee562b..1f160ef60509 100644
> >> >> > --- a/arch/x86/include/asm/hyperv-tlfs.h
> >> >> > +++ b/arch/x86/include/asm/hyperv-tlfs.h
> >> >> > @@ -49,10 +49,10 @@
> >> >> >  /* Support for physical CPU dynamic partitioning events is available*/
> >> >> >  #define HV_X64_CPU_DYNAMIC_PARTITIONING_AVAILABLE    BIT(3)
> >> >> >  /*
> >> >> > - * Support for passing hypercall input parameter block via XMM
> >> >> > + * Support for passing hypercall input and output parameter block via XMM
> >> >> >   * registers is available
> >> >> >   */
> >> >> > -#define HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE                BIT(4)
> >> >> > +#define HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE                BIT(4) | BIT(15)
> >> >>
> >> >> TLFS 6.0b states that there are two distinct bits for input and output:
> >> >>
> >> >> CPUID Leaf 0x40000003.EDX:
> >> >> Bit 4: support for passing hypercall input via XMM registers is available.
> >> >> Bit 15: support for returning hypercall output via XMM registers is available.
> >> >>
> >> >> and HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE is not currently used
> >> >> anywhere, I'd suggest we just rename
> >> >>
> >> >> HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE to HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE
> >> >> and add HV_X64_HYPERCALL_XMM_OUTPUT_AVAILABLE (bit 15).
> >> >
> >> > That is how I had it initially; but then noticed that we would never
> >> > need to use either of them separately. So it seemed like a reasonable
> >> > abstraction to put them together.
> >> >
> >>
> >> Actually, we may. In theory, KVM userspace may decide to expose just
> >> one of these two to the guest as it is not obliged to copy everything
> >> from KVM_GET_SUPPORTED_HV_CPUID so we will need separate
> >> guest_cpuid_has() checks.
> >
> > Makes sense. I'll split them and add the checks.
> >
> >> (This reminds me of something I didn't see in your series:
> >> we need to check that XMM hypercall parameters support was actually
> >> exposed to the guest as it is illegal for a guest to use it otherwise --
> >> and we will likely need two checks, for input and output).
> >
> > We observed that Windows expects Hyper-V to support XMM params even if
> > we don't advertise this feature but if userspace wants to hide this
> > feature and the guest does it anyway, then it makes sense to treat it as
> > an illegal OP.
> >
> 
> Out of pure curiosity, which Windows version behaves like that? And how
> does this work with KVM without your patches?

The guest is a Windows Server 2016 on which we are trying to enable VBS
and handle it through the VSM API. When VBS is enabled on the guest, it
starts using many other (new) hypercalls and some of them don't honor
the CPUID bits (4, 15) that indicate the presence of XMM params support.

> Sane KVM userspaces will certainly expose both XMM input and output
> capabilities together but having an ability to hide one or both of them
> may come handy while debugging.
> 
> Also, we weren't enforcing the rule that enlightenments not exposed to
> the guest don't work, even the whole Hyper-V emulation interface was
> available to all guests who were smart enough to know how to enable it!
> I don't like this for two reasons: security (large attack surface) and
> the fact that someone 'smart' may decide to use Hyper-V emulation
> features on KVM as 'general purpose' features saying 'they're always
> available anyway', this risks becoming an ABI.
> 
> Let's at least properly check if the feature was exposed to the guest
> for all new enlightenments.

Agreed.

~ Sid.



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



