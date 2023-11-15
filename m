Return-Path: <kvm+bounces-1830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BA427EC6C0
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 16:09:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3BF2D1C208D8
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 15:09:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DBE7381AB;
	Wed, 15 Nov 2023 15:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2Y16O+5x"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C80381B6
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 15:09:19 +0000 (UTC)
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC8A8E
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 07:09:18 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1cc56cc8139so11196515ad.0
        for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 07:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1700060958; x=1700665758; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=r39GnHM5bN5YuWeX4taddVxZqZSztKdXAkWyIoY43Wo=;
        b=2Y16O+5x6Jbce4BxgT6Z+vMDFfRVva3mDQMtTO8/W8t1P7qw1vD94TYr+BBFGmIKih
         DyDpJtVwhFkXNRfI//1ZLFHNljMLI+4bdT3KT4P2AjPsKdt3qPIADeVNkRyEkY2lhT6W
         UMju58oifU4eAzkVzDciUHmUJbDVe042sVpmV/ngmjOZgT3DAJ0u9c8O8qgVTBp+J+km
         Gio6YnCprERGaujNjkVN106T0QmBsuaaBlWCRYzzymbBUoSF1R7SyhH5xUCY6rKtiqdL
         +g5vixlaY2uocmpuDaGNFcLh/aawLjRgJCz9H3IeNQBBaUPPavGedswcUErYK+Rr4vfa
         sMRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700060958; x=1700665758;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r39GnHM5bN5YuWeX4taddVxZqZSztKdXAkWyIoY43Wo=;
        b=iYwHxOM8rYIlTHgBlE8ENByswfxKh71F6ZJJ462yj0n8WEyW29qpEbiv+Ndh/lOPIJ
         e9F7Bk8hso2pyjBnP9wxUhCyPQz+Q5ccUAnXQDhnY2PYn3WjUBLg1BdhCO0LYWE0djQR
         wrC2ayRX87Mx4GEkcPKUhfgL6RbFXMgnFDqZV25Sq/TNV6NsHXq55uFb5Rlqxy4P9nFo
         V2/7Ng27EIcVwDs5G+QIwBaNOK8cMrK3DWJCBt4enDBwHASr8BexvdgZyfmrCSeShLn8
         lnFdr9YJK8OcBEL7a7nKM45hFht4K3zlGDe6DZZQ8Arwu4UXKE1lVs7PVQKMkUB1bawW
         w8cg==
X-Gm-Message-State: AOJu0YwmJAu0Tq5epNL0hUbziHfeL/8t68imQRaaC655xPajhLKPYzj5
	X78oxkFHd0THus9NnUI3Uyk1TEFxx1s=
X-Google-Smtp-Source: AGHT+IG3qu3lFpMuQCfcgeEIlbULEmHkvJwhR5/zE7upNlxp4Rd+jCAiKWz5+AvxCJXFT41oeQkNPes24J4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:4292:b0:1cc:166f:91c8 with SMTP id
 ju18-20020a170903429200b001cc166f91c8mr1456351plb.1.1700060958209; Wed, 15
 Nov 2023 07:09:18 -0800 (PST)
Date: Wed, 15 Nov 2023 07:09:15 -0800
In-Reply-To: <9395d416-cc5c-536d-641e-ffd971b682d1@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110235528.1561679-1-seanjc@google.com> <20231110235528.1561679-7-seanjc@google.com>
 <ffec2e93-cdb1-25e2-06ec-deccf8727ce4@gmail.com> <ZVN6w2Kc2AUmIiJO@google.com>
 <9395d416-cc5c-536d-641e-ffd971b682d1@gmail.com>
Message-ID: <ZVTfG6mARiyttuKj@google.com>
Subject: Re: [PATCH 6/9] KVM: x86: Update guest cpu_caps at runtime for
 dynamic CPUID-based features
From: Sean Christopherson <seanjc@google.com>
To: Robert Hoo <robert.hoo.linux@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 15, 2023, Robert Hoo wrote:
> On 11/14/2023 9:48 PM, Sean Christopherson wrote:
> > On Mon, Nov 13, 2023, Robert Hoo wrote:
> ...
> > > u32 *caps  = vcpu->arch.cpu_caps;
> > > and update guest_cpu_cap_set(), guest_cpu_cap_clear(),
> > > guest_cpu_cap_change() and guest_cpu_cap_restrict() to pass in
> > > vcpu->arch.cpu_caps instead of vcpu, since all of them merely refer to vcpu
> > > cap, rather than whole vcpu info.
> > 
> > No, because then every caller would need extra code to pass
> > vcpu->cpu_caps,
> 
> Emm, I don't understand this. I tried to modified and compiled, all need to
> do is simply substitute "vcpu" with "vcpu->arch.cpu_caps" in calling. (at
> the end is my diff based on this patch set)

Yes, and I'm saying that

	guest_cpu_cap_restrict(vcpu, X86_FEATURE_PAUSEFILTER);
	guest_cpu_cap_restrict(vcpu, X86_FEATURE_PFTHRESHOLD);
	guest_cpu_cap_restrict(vcpu, X86_FEATURE_VGIF);
	guest_cpu_cap_restrict(vcpu, X86_FEATURE_VNMI);

is harder to read and write than this

	guest_cpu_cap_restrict(vcpu->arch.cpu_caps, X86_FEATURE_PAUSEFILTER);
	guest_cpu_cap_restrict(vcpu->arch.cpu_caps, X86_FEATURE_PFTHRESHOLD);
	guest_cpu_cap_restrict(vcpu->arch.cpu_caps, X86_FEATURE_VGIF);
	guest_cpu_cap_restrict(vcpu->arch.cpu_caps, X86_FEATURE_VNMI);

a one-time search-replace is easy, but the extra boilerplate has a non-zero cost
for every future developer/reader.

> > and passing 'u32 *' provides less type safety than 'struct kvm_vcpu *'.
> > That tradeoff isn't worth making this one path slightly easier to read.
> 
> My point is also from vulnerability, long term, since as a principle, we'd
> better pass in param/info to a function of its necessity.

Attempting to apply the principle of least privilege to low level C helpers is
nonsensical.  E.g. the helper can trivially get at the owning vcpu via container_of()
(well, if not for typeof assertions not playing nice with arrays, but open coding
container_of() is also trivial and illustrates the point).

	struct kvm_vcpu_arch *arch = (void *)caps -  offsetof(struct kvm_vcpu_arch, cpu_caps);
	struct kvm_vcpu *vcpu = container_of(arch, struct kvm_vcpu, arch);

	if (!kvm_cpu_cap_has(x86_feature))
		guest_cpu_cap_clear(vcpu, x86_feature);

And the intent behind that principle is to improve security/robustness; what I'm
saying is that passing in a 'u32 *" makes the overall implementation _less_ robust,
as it opens up the possibilities of passing in an unsafe/incorrect pointer.  E.g.
a well-intentioned, not _that_ obviously broken example is:

	guest_cpu_cap_restrict(&vcpu->arch.cpu_caps[CPUID_1_ECX], X86_FEATURE_XSAVE);

> e.g. cpuid_entry2_find().

The main reason cpuid_entry2_find() exists is because KVM checks the incoming
array provided by KVM_SET_CPUID2, which is also the reason why
__kvm_update_cpuid_runtime() takes an @entries array instead of just @vcpu.

