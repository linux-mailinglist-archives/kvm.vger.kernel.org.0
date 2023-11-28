Return-Path: <kvm+bounces-2654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AA7E7FBF7E
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 17:48:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C9630B20D6D
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 16:48:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB71D56463;
	Tue, 28 Nov 2023 16:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yN4tDn5H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CDB5D51
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 08:48:24 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-da3dd6a72a7so7924142276.0
        for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 08:48:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701190104; x=1701794904; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uA6IXD+Y3WRAlqXJ/CITjoEeJvV8WozOfc0Um1r0Klo=;
        b=yN4tDn5HJWeYr0l+fYp9PpLEGYA/ueaTCQaVJJwPyJZ6FVHIUnzOjz0vBmFqWnI3yI
         0mPUEmxUhVhw1hVGLqCht3HtBOTX7L4R5JW90r+o/SC30DhjKiTiZrK63C6SCOyYZtLM
         dfmbvQgLRdlTBu67Hbyy0xIlAlm2ynB8JBEkrWJO7XJKEuRXxvWHrcTQ6dUfzJJiA4C3
         lS/+DfUJe84jc/5bRo5ZTKQfTCU0ahdmrwepjW+GIA2RSLTRssppru81SRm2aYOQ9l+5
         F3g3p5Gbiw+G0RQ1SF7/4irSv2VrdvadI9xlHjp0DZtXQ5DOd50O/HSAficrwPQIKnrd
         3N6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701190104; x=1701794904;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uA6IXD+Y3WRAlqXJ/CITjoEeJvV8WozOfc0Um1r0Klo=;
        b=Yjzal6fj41sTas6TmSqrBYB/H+dDyudAiLjT7hor6fyfsaH4FjekWBIVscl/Z8fi+l
         8Uc3fP1wp8WZuwPFC2YJjFcbJjz9sycHOj0+fWq/i1QjnuhE4gqtQgiJWvtEfU4wXmz9
         W5hxLYbtznwe+tQDqi+5FJj8jjtXudCBH7KZZRoRqjUrL1XiCILjfUh4/L0C4Ewo2OZ1
         V0QFqDvZjNWjwp4wMMTkm1ytsOnFpODLmuMvNp2MBHBn6a2Dw7hptNacji+JCvLmyLJu
         qhrN7SkmQlVYKBdRvwrVZgzP5RoZTE+jUGzPtVjOvaNgVdGHLLS/47883fUk4WeYy41y
         0aiA==
X-Gm-Message-State: AOJu0Yyd8b3VQlKnTTpLVhajBDJVNlqFOvwkJ7G3MWD8tDxZRHB7KlOf
	EQQzMSosp/D1fN/gNAp/jAgGmS9lXWI=
X-Google-Smtp-Source: AGHT+IFUGK7/QTbQin6XENsFSAaDkeT3IWWH8DLbxWfvEu8yMLlQc6felk11vuaE8kO9WUWqRWfY2d5B078=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:3d44:0:b0:da0:567d:f819 with SMTP id
 k65-20020a253d44000000b00da0567df819mr515103yba.10.1701190103797; Tue, 28 Nov
 2023 08:48:23 -0800 (PST)
Date: Tue, 28 Nov 2023 08:48:22 -0800
In-Reply-To: <50076263-8b4f-4167-8419-e8baede7e9b0@maciej.szmigiero.name>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <c858817d3e3be246a1a2278e3b42d06284e615e5.1700766316.git.maciej.szmigiero@oracle.com>
 <ZWTQuRpwPkutHY-D@google.com> <50076263-8b4f-4167-8419-e8baede7e9b0@maciej.szmigiero.name>
Message-ID: <ZWYZ1ldqQ1Q-7Jk0@google.com>
Subject: Re: [PATCH] KVM: x86: Allow XSAVES on CPUs where host doesn't use it
 due to an errata
From: Sean Christopherson <seanjc@google.com>
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Nov 27, 2023, Maciej S. Szmigiero wrote:
> On 27.11.2023 18:24, Sean Christopherson wrote:
> > On Thu, Nov 23, 2023, Maciej S. Szmigiero wrote:
> > > From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> > > 
> > > Since commit b0563468eeac ("x86/CPU/AMD: Disable XSAVES on AMD family 0x17")
> > > kernel unconditionally clears the XSAVES CPU feature bit on Zen1/2 CPUs.
> > > 
> > > Since KVM CPU caps are initialized from the kernel boot CPU features this
> > > makes the XSAVES feature also unavailable for KVM guests in this case, even
> > > though they might want to decide on their own whether they are affected by
> > > this errata.
> > > 
> > > Allow KVM guests to make such decision by setting the XSAVES KVM CPU
> > > capability bit based on the actual CPU capability
> > 
> > This is not generally safe, as the guest can make such a decision if and only if
> > the Family/Model/Stepping information is reasonably accurate.
> 
> If one lies to the guest about the CPU it is running on then obviously
> things may work non-optimally.

But this isn't about running optimally, it's about functional correctness.  And
"lying" to the guest about F/M/S is extremely common.

> > > This fixes booting Hyper-V enabled Windows Server 2016 VMs with more than
> > > one vCPU on Zen1/2 CPUs.
> > 
> > How/why does lack of XSAVES break a multi-vCPU setup?  Is Windows blindly doing
> > XSAVES based on FMS?
> 
> The hypercall from L2 Windows to L1 Hyper-V asking to boot the first AP
> returns HV_STATUS_CPUID_XSAVE_FEATURE_VALIDATION_ERROR.

If it's just about CPUID enumeration, then userspace can simply stuff the XSAVES
feature flag.  This is not something that belongs in KVM, because this is safe if
and only if F/M/S is accurate and the guest is actually aware of the erratum (or
will not actually use XSAVES for other reasons), neither of which KVM can guarantee.

