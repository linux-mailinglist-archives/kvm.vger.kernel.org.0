Return-Path: <kvm+bounces-5094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A131B81BC8B
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 18:01:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C3FEC1C25DA8
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 17:01:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ACE0627E0;
	Thu, 21 Dec 2023 17:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MOY7DnoZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7915991B
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 17:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703178072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MTJ5ESIOyUqDB8n0Xz8qCRHr+4/Mt0yPLsVWj0QhBx4=;
	b=MOY7DnoZ/b4FCXh9kHlVaPLlKuclFCkcs8rUZSDU0W6Is84CQAhj92KZhQARqQUABoObPG
	k6+q50o6e16WkpnCLGcpmsrL59ETVcye9fwD9O+WUhoIp3EwVk78GjR2RC22ftxhSaaZE9
	FS1IJWVIVcblQN8y+Tji8jfgfPXc9t8=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-341-tZ_eSriBMN-OqGNhoUv-Ww-1; Thu, 21 Dec 2023 12:01:10 -0500
X-MC-Unique: tZ_eSriBMN-OqGNhoUv-Ww-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-553ae98aa2fso1110351a12.1
        for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 09:01:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703178069; x=1703782869;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MTJ5ESIOyUqDB8n0Xz8qCRHr+4/Mt0yPLsVWj0QhBx4=;
        b=LVjGzf8GsBF+MG33L4APfYbJi6QXfNvQZw0YpV7zIiaP9EL6I2ZFTmlM7w1u88B66N
         MA/rYxRFaIdexGP4LBJYNaSwP3HVMNzGzwY8C+2HJ6E2yeZyc4xX9zye2vfPVcSv1A7N
         mPOcFUeE+E6OiNweSqc9fCmfAoCDSJNjF4bbZDXmrCGw8AhT21e7KXMBlbz8pwA+9QrK
         /wxSKKNizYXAdXTLdrUnE8aCUkXhjfyFqL1MAh4y7Q8CiCl61Yh1jxfrsvWs3dke615x
         5ugRLSRr0MbCmX3t8NtCIdUAE2sfThtT/zSZbpUMml13OQ0noZzBd1WhsGDRScv5Rxtq
         qRhw==
X-Gm-Message-State: AOJu0Yyohplx0zA14TfdKUZDqzcOicu+ljk0pPSJ1r3ePVwX7+YQpt48
	s3aamc2NP3QjE5GdhygDbX3GIOjmosrY7ZPl2D88sjXOkh+yHEjyJS4mPZhH7KmL6u5aup2b1Fa
	sFb34qa4oKrEU
X-Received: by 2002:aa7:cf99:0:b0:552:fccb:c3b0 with SMTP id z25-20020aa7cf99000000b00552fccbc3b0mr1154662edx.25.1703178069314;
        Thu, 21 Dec 2023 09:01:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG7+Kx8aYbDCznZCj24KpGmL00NeWvL5EXT10506ac0wUHvn3R/Pf/ORUj9FK42eGybxOZbwA==
X-Received: by 2002:aa7:cf99:0:b0:552:fccb:c3b0 with SMTP id z25-20020aa7cf99000000b00552fccbc3b0mr1154644edx.25.1703178069009;
        Thu, 21 Dec 2023 09:01:09 -0800 (PST)
Received: from starship ([77.137.131.62])
        by smtp.gmail.com with ESMTPSA id f20-20020a056402195400b005543f50e53asm258311edz.93.2023.12.21.09.01.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 09:01:08 -0800 (PST)
Message-ID: <c7fdb72fc8ae79148a7be6c1668f6310f98b468c.camel@redhat.com>
Subject: Re: [PATCH v2 1/3] KVM: x86: Make the hardcoded APIC bus frequency
 vm variable
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Isaku Yamahata <isaku.yamahata@linux.intel.com>, Sean Christopherson
	 <seanjc@google.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org,  isaku.yamahata@gmail.com, Paolo Bonzini
 <pbonzini@redhat.com>,  erdemaktas@google.com, Vishal Annapurve
 <vannapurve@google.com>, Jim Mattson <jmattson@google.com>
Date: Thu, 21 Dec 2023 19:01:06 +0200
In-Reply-To: <20231219014045.GA2639779@ls.amr.corp.intel.com>
References: <cover.1699936040.git.isaku.yamahata@intel.com>
	 <1c12f378af7de16d7895f8badb18c3b1715e9271.1699936040.git.isaku.yamahata@intel.com>
	 <938efd3cfcb25d828deab0cc0ba797177cc69602.camel@redhat.com>
	 <ZXo54VNuIqbMsYv-@google.com>
	 <aa7aa5ea5b112a0ec70c6276beb281e19c052f0e.camel@redhat.com>
	 <ZXswR04H9Tl7xlyj@google.com>
	 <20231219014045.GA2639779@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2023-12-18 at 17:40 -0800, Isaku Yamahata wrote:
> On Thu, Dec 14, 2023 at 08:41:43AM -0800,
> Sean Christopherson <seanjc@google.com> wrote:
> 
> > On Thu, Dec 14, 2023, Maxim Levitsky wrote:
> > > On Wed, 2023-12-13 at 15:10 -0800, Sean Christopherson wrote:
> > > > Upstream KVM's non-TDX behavior is fine, because KVM doesn't advertise support
> > > > for CPUID 0x15, i.e. doesn't announce to host userspace that it's safe to expose
> > > > CPUID 0x15 to the guest.  Because TDX makes exposing CPUID 0x15 mandatory, KVM
> > > > needs to be taught to correctly emulate the guest's APIC bus frequency, a.k.a.
> > > > the TDX guest core crystal frequency of 25Mhz.
> > > 
> > > I assume that TDX doesn't allow to change the CPUID 0x15 leaf.
> > 
> > Correct.  I meant to call that out below, but left my sentence half-finished.  It
> > was supposed to say:
> > 
> >   I halfheartedly floated the idea of "fixing" the TDX module/architecture to either
> >   use 1Ghz as the base frequency or to allow configuring the base frequency
> >   advertised to the guest.
> > 
> > > > I halfheartedly floated the idea of "fixing" the TDX module/architecture to either
> > > > use 1Ghz as the base frequency (off list), but it definitely isn't a hill worth
> > > > dying on since the KVM changes are relatively simple.
> > > > 
> > > > https://lore.kernel.org/all/ZSnIKQ4bUavAtBz6@google.com
> > > > 
> > > 
> > > Best regards,
> > > 	Maxim Levitsky
> 
> The followings are the updated version of the commit message.
> 
> 
> KVM: x86: Make the hardcoded APIC bus frequency VM variable
> 
> The TDX architecture hard-codes the APIC bus frequency to 25MHz in the
> CPUID leaf 0x15.  The
> TDX mandates it to be exposed and doesn't allow the VMM to override
> its value.  The KVM APIC timer emulation hard-codes the frequency to
> 1GHz.  It doesn't unconditionally enumerate it to the guest unless the
> user space VMM sets the CPUID leaf 0x15 by KVM_SET_CPUID.
> 
> If the CPUID leaf 0x15 is enumerated, the guest kernel uses it as the
> APIC bus frequency.  If not, the guest kernel measures the frequency
> based on other known timers like the ACPI timer or the legacy PIT.
> The TDX guest kernel gets timer interrupt more times by 1GHz / 25MHz.
> 
> To ensure that the guest doesn't have a conflicting view of the APIC
> bus frequency, allow the userspace to tell KVM to use the same
> frequency that TDX mandates instead of the default 1Ghz.

Looks great!

In theory this gives me an idea that KVM could parse the guest CPUID leaf
0x15 and deduce the frequency from it automatically instead of a new capability,
but I understand that this is (also in theory) not backward compatible assuming
that some hypervisors already expose this leaf for some reason,
thus a new capability will be needed anyway.

Thus I have no more complaints, and thanks for addressing my feedback!

Best regards,
	Maxim Levitsky

> 
> There are several options to address this.
> 1. Make the KVM able to configure APIC bus frequency (This patch).
>    Pros: It resembles the existing hardware.  The recent Intel CPUs
>    adapts 25MHz.
>    Cons: Require the VMM to emulate the APIC timer at 25MHz.
> 2. Make the TDX architecture enumerate CPUID 0x15 to configurable
>    frequency or not enumerate it.
>    Pros: Any APIC bus frequency is allowed.
>    Cons: Deviation from the real hardware.
> 3. Make the TDX guest kernel use 1GHz when it's running on KVM.
>    Cons: The kernel ignores CPUID leaf 0x15.
> 
> 



