Return-Path: <kvm+bounces-319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AFA1E7DE26F
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 15:42:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3F7E6B20C29
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 14:42:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F0FD12B6B;
	Wed,  1 Nov 2023 14:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LfDKBilu"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74241DDB0
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 14:41:59 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61CDDE
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 07:41:57 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-da3a891bf3aso1444229276.1
        for <kvm@vger.kernel.org>; Wed, 01 Nov 2023 07:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698849717; x=1699454517; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vY+whK5XqbSYsbcvwYkxlvLDj7c4sWYoMlLiCl+8FOk=;
        b=LfDKBilu4NrSerjztc1lrZy8phroJv/F2apm3wn0KDjMa59lUkyl1NpYYdI9OvIEOL
         TClkgg2MVEVcDljIhz4wlqODduPTbjuizVIPoH3QQPtd/lSMvjumg8lvM4/Pxa29M+Ae
         zko2FcItwkGq8s9JuKbDRnHa6QAxZ0EVzEE2APspZVCuRY94vFxXYZNmWqzpjryecr0f
         ZnxW6RN7/QIrxuVswW+PWOU1FgonTqVmvrHspdovd7/FYt0t4F8sa3TEtceGlSdrlauA
         x/u8N7Y9K6fR1O/J7ML45OBqHD9dMqd11ZzYo05RWVtONBMCCTQ5H8OGYbJpdDm/DYLW
         TgHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698849717; x=1699454517;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vY+whK5XqbSYsbcvwYkxlvLDj7c4sWYoMlLiCl+8FOk=;
        b=mtoHcDwEZ97bztcf9oRjjh/E3qexeDEYioxoY0yBOgaoQYMSMSiYltIQaDEU4lBUWV
         UNX/cofRNLdB7SXAS2PiV9K21DUQAUDQzg96aIkRmQRiW4fTa1FLM6bVGUEvK7BH0VsM
         LCeTuXnDcni+a9jHSMIrQkD163poOsKSEHXeMWki0LkWjK4dxdFSu/OT5Nx5TuBwvapq
         lGkHxRLKbP823ZP9bAAr7L8i7PznGsfL3gJqMmV9EhyMbpbqd75OxCVmrVUS2tPkN3kb
         7w+kzfpdWUG3EbP+nV/O0U8flnIi8DmgaKuQbCVTrJOX9DspYNpTSt0LxJGJtX9SrVnW
         VI7A==
X-Gm-Message-State: AOJu0YxmGv8ixohatMO1gL5+iA6AR7xDAzwCRBT2xJkL0wqMDk8XXeEf
	pOhe5h5xljOQ6cVwP9OBo2vQquYXEro=
X-Google-Smtp-Source: AGHT+IGOo/h7yYknoNxH9zuetv1Jm66TgYYqm36QaUrElC5TUX1EIZWIQhjKSSLNgDJc5UoA6/jD+vUPb8Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:549:b0:da3:b96c:6c48 with SMTP id
 z9-20020a056902054900b00da3b96c6c48mr39857ybs.9.1698849717105; Wed, 01 Nov
 2023 07:41:57 -0700 (PDT)
Date: Wed, 1 Nov 2023 07:41:55 -0700
In-Reply-To: <96c30a78fa95071e87045b7293c2cf796d4182a0.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-10-weijiang.yang@intel.com> <96c30a78fa95071e87045b7293c2cf796d4182a0.camel@redhat.com>
Message-ID: <ZUJjs2F-vD1-cZS4@google.com>
Subject: Re: [PATCH v6 09/25] KVM: x86: Rework cpuid_get_supported_xcr0() to
 operate on vCPU data
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dave.hansen@intel.com, peterz@infradead.org, 
	chao.gao@intel.com, rick.p.edgecombe@intel.com, john.allen@amd.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 31, 2023, Maxim Levitsky wrote:
> On Thu, 2023-09-14 at 02:33 -0400, Yang Weijiang wrote:
> > From: Sean Christopherson <seanjc@google.com>
> > 
> > Rework and rename cpuid_get_supported_xcr0() to explicitly operate on vCPU
> > state, i.e. on a vCPU's CPUID state.  Prior to commit 275a87244ec8 ("KVM:
> > x86: Don't adjust guest's CPUID.0x12.1 (allowed SGX enclave XFRM)"), KVM
> > incorrectly fudged guest CPUID at runtime,
> Can you explain how commit 275a87244ec8 relates to this patch?
>
> > which in turn necessitated massaging the incoming CPUID state for
> > KVM_SET_CPUID{2} so as not to run afoul of kvm_cpuid_check_equal().
> 
> Can you link the commit that added this 'massaging' and explain on how this
> relates to this patch?

It's commit 275a87244ec8, which is right above.  I think the missing part is an
explicit call out that the massaging used cpuid_get_supported_xcr0() with the
incoming "struct kvm_cpuid_entry2", i.e. without a "struct kvm_vcpu".

> Can you explain what is the problem that this patch is trying to solve?

Is this better?

--
Rework and rename cpuid_get_supported_xcr0() to explicitly operate on vCPU
state, i.e. on a vCPU's CPUID state, now that the only usage of the helper
is to retrieve a vCPU's already-set CPUID.

Prior to commit 275a87244ec8 ("KVM: x86: Don't adjust guest's CPUID.0x12.1
(allowed SGX enclave XFRM)"), KVM incorrectly fudged guest CPUID at
runtime, which in turn necessitated massaging the incoming CPUID state for
KVM_SET_CPUID{2} so as not to run afoul of kvm_cpuid_check_equal().  I.e.
KVM also invoked cpuid_get_supported_xcr0() with the incoming CPUID state,
and thus without an explicit vCPU object.
--

> Is it really allowed in x86 spec to have different supported mask of XCR0 bits
> on different CPUs (assuming all CPUs of the same type)?

Yes, nothing in the SDM explicitly states that all cores in have identical feature
sets.  And "assuming all CPUs of the same type" isn't really a valid constraint
because it's very doable to put different SKUs into a multi-socket system.

Intel even (somewhat inadvertantly) kinda sorta shipped such CPUs, as Alder Lake
P-cores support AVX512 but E-cores do not, and IIRC early (pre-production?) BIOS
didn't disable AVX512 on the P-Cores, i.e. software could observe cores with and
without AVX512.  That quickly got fixed because it confused software, but until
Intel squashed AVX512 entirely with a microcode update, disabling E-Cores in BIOS
would effectively enable AVX512 on the remaining P-Cores.

And it's not XCR0-related, but PMUs on Alder Lake (and all Intel hybrid CPUs) are
truly heterogenous.  It's a mess for virtualization, but concrete proof that there
are no architectural guarantees regarding homogeneity of feature sets.

> If true, does KVM supports it?

Yes.  Whether or not that's a good thing is definitely debatle, bug KVM's ABI for
a very long time has allowed userspace to expose whatever it wants via KVM_SET_CPUID.

Getting (guest) software to play nice is an entirely different matter, but exposing
heterogenous vCPUs isn't an architectural violation.

