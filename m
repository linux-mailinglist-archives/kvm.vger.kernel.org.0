Return-Path: <kvm+bounces-2697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D5AB7FCAF2
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 00:42:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C97D1C20F87
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 23:42:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 866255C3C2;
	Tue, 28 Nov 2023 23:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mgCxOmkN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B49A41B4
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 15:42:43 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5cdde93973aso79492527b3.1
        for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 15:42:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701214963; x=1701819763; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iZUCKF6M2pncs6ikf31MzfqFi00tloLxxIfq7BGycqs=;
        b=mgCxOmkNpxwd+gH23CfHATU5w412/KoL2bkNEmfm8tQEHy1pX1BQ1MpQTT8/2cuurN
         wDXW1T6h+i8y9Vnw+jND4/qaZqhPnpfbYfaJQISN2ZwW/wLGc2G/zTJ1pPkKL5glYecG
         PwQ2PeB5miNMDqC1MYxkloGGIm7iE4ERjFsPdXPQdcNu3nTGLCoObiAhc9sbrzs97Mn0
         Q+AltMl+D7fjVamHpXeWKymopzA8rUVEtiDNjUz0u0RahvMHb0dfioUFoVfK/tQrEBAf
         Dh/q8BBgp1F26kqCO0i5RROLftd0lWh7O3l2m0IFl0SOm2N+LopfM55pQQrsmsKBsyNA
         JghQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701214963; x=1701819763;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iZUCKF6M2pncs6ikf31MzfqFi00tloLxxIfq7BGycqs=;
        b=LYn+eBSE+dkklE7J1BAMYN05+dcw4XHA20WNucNqtS2j+qas4Zi7nLM/o5J2ixTiJt
         Ecsh7gLT2+CpoSeFmKrLWiX4rXe4vI3grnEDTl1d9+ZC7mSog23KVydJMvLc4pB2vbdG
         7UCclbyPlYJuLkGHj5v8HWMQmowKxfljjGLKIPRU6itB0rtB1IgzD+HwbTvhRu2g1TCw
         5ThA+oRyK0BdKlWs5IvwUBRZcwBX7PyPc2AvizUBAiXJ19FJME1TBxqLvlJasZ6KOt8p
         GbLGAiJDg9bFXF25QImxZ0blIP1k1AyvAwuOapH9FLuKu9ao+xk4RR02A0RV1GVJQ9t1
         2Hkw==
X-Gm-Message-State: AOJu0YwtLGTK6efnQ1x1wwBBQqUHhuBIVOq7tTf+jr//7xKd2903je3+
	ArQyINxuIkdhyQ95nm3bhSKX4g7zcCk=
X-Google-Smtp-Source: AGHT+IHpFOEL1gyxHa1zaN2y8eJYkQ1EOMhY3SOo4hd+HFqQ1xE2I6Dg0+o7NSgCjsfpJ/RwcscFOhGbDwU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ae56:0:b0:5cb:4e0e:59c1 with SMTP id
 g22-20020a81ae56000000b005cb4e0e59c1mr474555ywk.1.1701214962937; Tue, 28 Nov
 2023 15:42:42 -0800 (PST)
Date: Tue, 28 Nov 2023 15:42:41 -0800
In-Reply-To: <edaa230f-37c1-498c-8ff1-a9a238ed0cd7@maciej.szmigiero.name>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <c858817d3e3be246a1a2278e3b42d06284e615e5.1700766316.git.maciej.szmigiero@oracle.com>
 <ZWTQuRpwPkutHY-D@google.com> <50076263-8b4f-4167-8419-e8baede7e9b0@maciej.szmigiero.name>
 <ZWYZ1ldqQ1Q-7Jk0@google.com> <edaa230f-37c1-498c-8ff1-a9a238ed0cd7@maciej.szmigiero.name>
Message-ID: <ZWZ68SXyh_RpHRB9@google.com>
Subject: Re: [PATCH] KVM: x86: Allow XSAVES on CPUs where host doesn't use it
 due to an errata
From: Sean Christopherson <seanjc@google.com>
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 28, 2023, Maciej S. Szmigiero wrote:
> On 28.11.2023 17:48, Sean Christopherson wrote:
> > On Mon, Nov 27, 2023, Maciej S. Szmigiero wrote:
> > > On 27.11.2023 18:24, Sean Christopherson wrote:
> > > > On Thu, Nov 23, 2023, Maciej S. Szmigiero wrote:
> > > > > From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> > > > > 
> > > > > Since commit b0563468eeac ("x86/CPU/AMD: Disable XSAVES on AMD family 0x17")
> > > > > kernel unconditionally clears the XSAVES CPU feature bit on Zen1/2 CPUs.
> > > > > 
> > > > > Since KVM CPU caps are initialized from the kernel boot CPU features this
> > > > > makes the XSAVES feature also unavailable for KVM guests in this case, even
> > > > > though they might want to decide on their own whether they are affected by
> > > > > this errata.
> > > > > 
> > > > > Allow KVM guests to make such decision by setting the XSAVES KVM CPU
> > > > > capability bit based on the actual CPU capability
> > > > 
> > > > This is not generally safe, as the guest can make such a decision if and only if
> > > > the Family/Model/Stepping information is reasonably accurate.
> > > 
> > > If one lies to the guest about the CPU it is running on then obviously
> > > things may work non-optimally.
> > 
> > But this isn't about running optimally, it's about functional correctness.  And
> > "lying" to the guest about F/M/S is extremely common.
> > 
> > > > > This fixes booting Hyper-V enabled Windows Server 2016 VMs with more than
> > > > > one vCPU on Zen1/2 CPUs.
> > > > 
> > > > How/why does lack of XSAVES break a multi-vCPU setup?  Is Windows blindly doing
> > > > XSAVES based on FMS?
> > > 
> > > The hypercall from L2 Windows to L1 Hyper-V asking to boot the first AP
> > > returns HV_STATUS_CPUID_XSAVE_FEATURE_VALIDATION_ERROR.
> > 
> > If it's just about CPUID enumeration, then userspace can simply stuff the XSAVES
> > feature flag.  This is not something that belongs in KVM, because this is safe if
> > and only if F/M/S is accurate and the guest is actually aware of the erratum (or
> > will not actually use XSAVES for other reasons), neither of which KVM can guarantee.
> 
> In other words, your suggestion is that QEMU (or other VMM) not KVM
> should be the one setting the XSAVES CPUID bit back, correct?
> 
> I don't think this would work with the current KVM code since it seems
> to make various decisions depending on presence of XSAVES bit in KVM
> caps rather than the guest CPUID and on boot_cpu_has(XSAVES) - one of
> such code blocks was even modified by this patch.
> 
> It even says in the comment above that code that it is not possible to
> actually disable XSAVES without disabling all other variants on SVM so
> this has to be enabled if CPU supports it to switch the XSS MSR at
> guest entry/exit (in this case it looks harmless since Zen1/2
> supposedly don't support any supervisor extended states).
> 
> So it looks like we would need changes to *both* KVM and QEMU to
> restore the XSAVES support this way.

I'm not suggesting we restore XSAVES support, I'm suggesting that _if_ someone
wants to hack their setup to let the guest use broken hardware, then they should
do that in userspace or in an a private kernel, not in upstream KVM.

