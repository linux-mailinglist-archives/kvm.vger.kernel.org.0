Return-Path: <kvm+bounces-271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EE307DDB1F
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 03:48:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9232C1C20D45
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 02:48:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B385E10EF;
	Wed,  1 Nov 2023 02:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I7dELkTH"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B462DA32
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 02:48:09 +0000 (UTC)
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B5BF3
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 19:48:07 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-51e24210395so7194a12.0
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 19:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698806886; x=1699411686; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GBisgJ9QGTELvVjJu1jW4LEFa5KH3eLa6pgyaizlfpI=;
        b=I7dELkTHRZI6Ft2T6W/D0rvxDBBGekrzgAHyQr2b0yQmEw9fYhi1HeYBrok/rA61pV
         VP7+4CIdQFgUDuq0XE/Uw8wftwB8EWY6VTpcKfFV52zHP3w6t0J05lZ9Hw16Zo8II4Zs
         i/8nmO4EzIErXPSICrecy5r+fO15tKrS2eWUk5cZ77FvetPRHHzFL6U7vwc5GWJqvavS
         DP416C2DDAruw9c+jTZmvlDPpPfSVZb568uEyOKcmsiK0+eK8IQ07CBurRvBhFqckaBp
         RPt9IdoQyTL1ild93s2Gf3q026CAXUnFO2g++jARNw3rdFiXqBoFOjqBL3Ez734FW2oZ
         FsxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698806886; x=1699411686;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GBisgJ9QGTELvVjJu1jW4LEFa5KH3eLa6pgyaizlfpI=;
        b=b3ryAY2LbqzJHNp3QObCB41B+fhA1midk+CQO0V6Ar5/VhtO45x7QtOkeEKmLKvB3U
         WEDyWGoWYtayzajIe6L1LKE6X1nerF9+92pawPlSq+TmQHytlcAlPEnkrnDW/HKn2ijO
         wPb3kbxa15C9VmC7Fo1Xe7vu7sJiBOm5iejCIyZ2uvz+iNjPI7tEYNKDllJDOZCgCxCN
         eTAlBJmkjmCIIiVFqzgzSYcqyJTXFM6msNDDGXRRmxqTN3kGyJW8t+Sv3eIXeYEKu0Ha
         82mDe2vDdrEWdhE75Ddm4Q85SigHDFVwRZVz7hRhSPPGon6tPxpqlxYCGU5JY+Qkq77o
         pBww==
X-Gm-Message-State: AOJu0YzPaG++XaBV9EPAZKu8FcJqOQjPr4n+KMpvtKntvMbS+SAqZnbw
	zyIuUhipsTuH13yFwSeJXIJzsbVaccqzlEwiARktVw==
X-Google-Smtp-Source: AGHT+IFBES0LJlTgryIhVSib3Wvc/VZriFT7FNc4avva3KWlfHL4RO1f5PaYTbdAncKIyKrpFeVFxO1RxrdLPc/rNKQ=
X-Received: by 2002:aa7:c718:0:b0:543:7345:6283 with SMTP id
 i24-20020aa7c718000000b0054373456283mr181280edq.3.1698806885966; Tue, 31 Oct
 2023 19:48:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231031092921.2885109-1-dapeng1.mi@linux.intel.com>
 <20231031092921.2885109-5-dapeng1.mi@linux.intel.com> <CALMp9eQ4Xj5D-kgqVMKUNmdF37rLcMRXyDYdQU339sRCKZ7d9A@mail.gmail.com>
 <28796dd3-ac4e-4a38-b9e1-f79533b2a798@linux.intel.com>
In-Reply-To: <28796dd3-ac4e-4a38-b9e1-f79533b2a798@linux.intel.com>
From: Jim Mattson <jmattson@google.com>
Date: Tue, 31 Oct 2023 19:47:50 -0700
Message-ID: <CALMp9eRH5pttOA5BApdVeSbbkOU-kWcOWAoGMfK-9f=cy2Jf0g@mail.gmail.com>
Subject: Re: [kvm-unit-tests Patch v2 4/5] x86: pmu: Support validation for
 Intel PMU fixed counter 3
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Zhang Xiong <xiong.y.zhang@intel.com>, Mingwei Zhang <mizhang@google.com>, 
	Like Xu <like.xu.linux@gmail.com>, Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 31, 2023 at 7:33=E2=80=AFPM Mi, Dapeng <dapeng1.mi@linux.intel.=
com> wrote:
>
>
> On 11/1/2023 2:47 AM, Jim Mattson wrote:
> > On Tue, Oct 31, 2023 at 2:22=E2=80=AFAM Dapeng Mi <dapeng1.mi@linux.int=
el.com> wrote:
> >> Intel CPUs, like Sapphire Rapids, introduces a new fixed counter
> >> (fixed counter 3) to counter/sample topdown.slots event, but current
> >> code still doesn't cover this new fixed counter.
> >>
> >> So this patch adds code to validate this new fixed counter can count
> >> slots event correctly.
> > I'm not convinced that this actually validates anything.
> >
> > Suppose, for example, that KVM used fixed counter 1 when the guest
> > asked for fixed counter 3. Wouldn't this test still pass?
>
>
> Per my understanding, as long as the KVM returns a valid count in the
> reasonable count range, we can think KVM works correctly. We don't need
> to entangle on how KVM really uses the HW, it could be impossible and
> unnecessary.

Now, I see how the Pentium FDIV bug escaped notice. Hey, the numbers
are in a reasonable range. What's everyone upset about?

> Yeah, currently the predefined valid count range may be some kind of
> loose since I want to cover as much as hardwares and avoid to cause
> regression. Especially after introducing the random jump and clflush
> instructions, the cycles and slots become much more hard to predict.
> Maybe we can have a comparable restricted count range in the initial
> change, and we can loosen the restriction then if we encounter a failure
> on some specific hardware. do you think it's better? Thanks.

I think the test is essentially useless, and should probably just be
deleted, so that it doesn't give a false sense of confidence.

