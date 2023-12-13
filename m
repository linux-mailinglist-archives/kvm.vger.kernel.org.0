Return-Path: <kvm+bounces-4408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FE2381229D
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 00:10:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3E8EE1F2189F
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 23:10:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E18283AE5;
	Wed, 13 Dec 2023 23:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ps6YFuZW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED43199
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 15:10:27 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5e2bf6066e4so15614507b3.2
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 15:10:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702509027; x=1703113827; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CUqoDbZM9AopeA8SWQ56D3q7Q5pOcG2dnxXupG6r4AM=;
        b=Ps6YFuZWcYOBgvbAejx+2etW7sQb71fvhn6DU5QSVgdDdRoCp7E4/qn/oWnb/4/q32
         +dCCQp1pBFtMaBanO9n96vbs3G8/NT9JlMw5vq9FaNDGdyr2qRZHDK5xxtXc1X+7Ie/j
         PRRjCvb+EZj3x9ruEH5cvuagLa7nvEhRGDfXxRrUlCI+78JpZbY9A1tExCvvfKRxcBI6
         hkMXGUVETtq/SAE1bwd1uYWwMZDh3TUaOQqJyqUj0ZGcT6g8Xws7thBAP4HdPz61Cdys
         yXtPnXIpj29B+1zO9I55kZvDjXzkZ2b4vSfVIcbfI4UlMYMbpyyKkG+YmtBqACwROnH8
         PCEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702509027; x=1703113827;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CUqoDbZM9AopeA8SWQ56D3q7Q5pOcG2dnxXupG6r4AM=;
        b=GM406GFja0FUGWO9j4gzKx73KuRBbv2KWpajfRYjwJX5OHHJvcpLkd4tL6VRDrYsaO
         5ZDxvkRKQrgv4OvqtdzJQE7Ge8XvdEyoDEy0mkqb9TIZc7DRFvaT8MlLkZrXl62nTYc2
         FzUMJA5lcJCtFBpk9Qft7up2tsP6NbNNm+2kDH089PJPOE2dG0TkkhxQ6VnGarmHvl+6
         OwFvUeL2JPvSYbiXVJXK160gfuFNNXWlGuozsLvHQFt1LKVeQbCII2OS+ZMAzOHwK9cs
         XaoUixB/5YdSQaIK3BWUcO9pqKkyp0skkfttELP2wjb0hEwmbxv5G8uQrJDW9X2CBnt4
         8nig==
X-Gm-Message-State: AOJu0Yyuk+TNuugrXJVCfSe4ftbUcofXZ1lFVWc7/7qH/SkAnaLZAjdp
	nbAOA6eB5voDSZxUSbL+AFZKUj+AYos=
X-Google-Smtp-Source: AGHT+IF4eGkuED2YgGkikQHjB/qkyEMf7VDdEnq9on8ks3iMiGrniK1KQ/mlVQ/drqNz1BaE3Btrpi0R9vk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:d0e:b0:5d7:9a6c:54aa with SMTP id
 cn14-20020a05690c0d0e00b005d79a6c54aamr98099ywb.5.1702509027129; Wed, 13 Dec
 2023 15:10:27 -0800 (PST)
Date: Wed, 13 Dec 2023 15:10:25 -0800
In-Reply-To: <938efd3cfcb25d828deab0cc0ba797177cc69602.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1699936040.git.isaku.yamahata@intel.com>
 <1c12f378af7de16d7895f8badb18c3b1715e9271.1699936040.git.isaku.yamahata@intel.com>
 <938efd3cfcb25d828deab0cc0ba797177cc69602.camel@redhat.com>
Message-ID: <ZXo54VNuIqbMsYv-@google.com>
Subject: Re: [PATCH v2 1/3] KVM: x86: Make the hardcoded APIC bus frequency vm variable
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com, 
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com, 
	Vishal Annapurve <vannapurve@google.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Dec 14, 2023, Maxim Levitsky wrote:
> On Mon, 2023-11-13 at 20:35 -0800, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > TDX virtualizes the advertised APIC bus frequency to be 25MHz. 
> 
> Can you explain a bit better why TDX needs this? I am not familiar
> with TDX well enough yet to fully understand.

TDX (the module/architecture) hardcodes the core crystal frequency to 25Mhz,
whereas KVM hardcodes the APIC bus frequency to 1Ghz.  And TDX (again, the module)
*unconditionally* enumerates CPUID 0x15 to TDX guests, i.e. _tells_ the guest that
the frequency is 25MHz regardless of what the VMM/hypervisor actually emulates.
And so the guest skips calibrating the APIC timer, which results in the guest
scheduling timer interrupts waaaaaaay too frequently, i.e. the guest ends up
gettings interrupts at 40x the rate it wants.

Upstream KVM's non-TDX behavior is fine, because KVM doesn't advertise support
for CPUID 0x15, i.e. doesn't announce to host userspace that it's safe to expose
CPUID 0x15 to the guest.  Because TDX makes exposing CPUID 0x15 mandatory, KVM
needs to be taught to correctly emulate the guest's APIC bus frequency, a.k.a.
the TDX guest core crystal frequency of 25Mhz.

I halfheartedly floated the idea of "fixing" the TDX module/architecture to either
use 1Ghz as the base frequency (off list), but it definitely isn't a hill worth
dying on since the KVM changes are relatively simple.

https://lore.kernel.org/all/ZSnIKQ4bUavAtBz6@google.com

