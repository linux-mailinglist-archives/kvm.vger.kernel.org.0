Return-Path: <kvm+bounces-326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D4D397DE542
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 18:21:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E5201C204AB
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 17:21:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 601E815E98;
	Wed,  1 Nov 2023 17:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nuXm2Koc"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9EB14F70
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 17:21:05 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98573136
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 10:20:56 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d81e9981ff4so6117704276.3
        for <kvm@vger.kernel.org>; Wed, 01 Nov 2023 10:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698859256; x=1699464056; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TDeMHyg6nuM6uHT2NhRlyelK+fI/RFOQGU6FtIWq+2I=;
        b=nuXm2KocmpbxdbmXC+RtU7wGzmV0XtSzPB/k+4qzCth2TwazsSLX7PN0/rZ1zlQZJD
         VKcmWJfjCrCvn7AfEI+stBdTXKzpnOdUiE6YUNPl2ApjjBkUqj9z4lAffMcU+Xlszani
         lvauQkrJI4j4WtxHeYS1QguZYRIDohvpgZuzMWEUGZRaTMepGNdsg5piEJF3syRCRDvJ
         aoDVKgQtahhFcz7fNT55NBQH0JxS6YJF0vXBDLxOQRsplMLRsiWzBF8Emlz7aOIfRfpn
         HUDkKaEu8xhFAeUXZjG+QQLtuIppMrGplUvRq8OJf9DLLZAZ00IntUyx7XzikS8vx4sF
         gpIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698859256; x=1699464056;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TDeMHyg6nuM6uHT2NhRlyelK+fI/RFOQGU6FtIWq+2I=;
        b=hxXQgrTGuZ0WsIhhR6jQn8QzFbHXuElLMZiac+8lwjvxroYBTjYtX4mb5hP/0kfBcU
         pbRBXjDToE7+Uz+K86Eb+9mzxgexafUWq7bhM4OMDq1RFLQsWyvkrlw2v626lh/CWhXB
         Z1pDHgEaHkca5ebjUuqa4XSq3UUMtcYc+B5jfhJh3IR/UYGRdP7LIR65uDmMH/hTEy9X
         2E1rwjpc/b9jhTiqaT6p91yZ8badkuI82hU/Pl+Dliyiz2U5CzH1rjgCaGFrtSViH6w6
         PifZIakP9/i1J5DyTuXtmaxzUpPdtjyp4aa22imEOERg++aQwsh7gllQA9sGyExZdCHz
         ZaAw==
X-Gm-Message-State: AOJu0YwWY3D0OeHQxgrpa46HHPuOeAdjhcbFgY7f0B59TBbn875A19GP
	OrX3QqR3tS0rYII33nNaHJZOeJ6v+D8=
X-Google-Smtp-Source: AGHT+IFwGVOPpso45s8V613XF539Qxh3lGXMwKqbbJhIsTxBDYEsG0+0t68Cu9sJzvzKgPmuAbddDRn/tvw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:7702:0:b0:d9a:6007:223a with SMTP id
 s2-20020a257702000000b00d9a6007223amr319245ybc.8.1698859255708; Wed, 01 Nov
 2023 10:20:55 -0700 (PDT)
Date: Wed, 1 Nov 2023 10:20:54 -0700
In-Reply-To: <5c5eb1cc92d05fb7717fe3480aeb7b20e7842d05.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-13-weijiang.yang@intel.com> <5c5eb1cc92d05fb7717fe3480aeb7b20e7842d05.camel@redhat.com>
Message-ID: <ZUKI9oqwaZ46dHeX@google.com>
Subject: Re: [PATCH v6 12/25] KVM: x86: Refresh CPUID on write to guest MSR_IA32_XSS
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dave.hansen@intel.com, peterz@infradead.org, 
	chao.gao@intel.com, rick.p.edgecombe@intel.com, john.allen@amd.com, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 31, 2023, Maxim Levitsky wrote:
> On Thu, 2023-09-14 at 02:33 -0400, Yang Weijiang wrote:
> > @@ -312,6 +313,17 @@ static u64 vcpu_get_supported_xcr0(struct kvm_vcpu *vcpu)
> >  	return (best->eax | ((u64)best->edx << 32)) & kvm_caps.supported_xcr0;
> >  }
> >  
> > +static u64 vcpu_get_supported_xss(struct kvm_vcpu *vcpu)
> > +{
> > +	struct kvm_cpuid_entry2 *best;
> > +
> > +	best = kvm_find_cpuid_entry_index(vcpu, 0xd, 1);
> > +	if (!best)
> > +		return 0;
> > +
> > +	return (best->ecx | ((u64)best->edx << 32)) & kvm_caps.supported_xss;
> > +}
> 
> Same question as one for patch that added vcpu_get_supported_xcr0()
> Why to have per vCPU supported XSS if we assume that all CPUs have the same
> CPUID?
> 
> I mean I am not against supporting hybrid CPU models, but KVM currently doesn't
> support this and this creates illusion that it does.

KVM does "support" hybrid vCPU models in the sense that KVM has allow hybrid models
since forever.  There are definite things that won't work, e.g. not all relevant
CPUID bits are captured in kvm_mmu_page_role, and so KVM will incorrectly share
page tables across vCPUs that are technically incompatible.

But for many features, heterogenous vCPU models do Just Work as far as KVM is
concerned.  There likely isn't a real world kernel that supports heterogenous
feature sets for things like XSS and XCR0, but that's a guest software limitation,
not a limitation of KVM's CPU virtualization.

As with many things, KVM's ABI is to let userspace shoot themselves in the foot.

