Return-Path: <kvm+bounces-577-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F1D087E0F67
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 13:41:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1FE271C20A0C
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 12:41:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83DA9179B0;
	Sat,  4 Nov 2023 12:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OS9v9fgo"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975A011700
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 12:41:43 +0000 (UTC)
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3382B8
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 05:41:41 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-53eeb28e8e5so3701a12.1
        for <kvm@vger.kernel.org>; Sat, 04 Nov 2023 05:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699101700; x=1699706500; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UDLXHh1LCLlpUklSjpCr9GbpnRrH5B2wrUnHq5eFYtU=;
        b=OS9v9fgop2zlPAwzYZQjlJNenTd3Cs9pbbyStQwKPvJgNMDzUI2H7jZgKEcNuGkYo2
         C/owzWkJfe5ywnszlby2gbyoIDVqXlZyfeTJZFZGD2WIcoPD5mnfVmkQ2RpKGvBAju99
         lc1jYp95c622/Or+T5G+hWuIaATrIudOE6k2ME1UKz/gUrXov+Xj0/ZbowoL3tAgFGEO
         aJFMM0UFQIg/py/QqIp3K09Ru4qTfWjCe/XKyCWbSp73V01ZsvH/b3PcFo/VvuDADXcu
         4zOUUt1qTKGlwyj3MvmMktl3/Cb3c48H3R8GcYm+mOrmz+f83Y2YkJTo1yqeKVZ54WJJ
         bG6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699101700; x=1699706500;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UDLXHh1LCLlpUklSjpCr9GbpnRrH5B2wrUnHq5eFYtU=;
        b=nCQKYnHnRxETn5MCGHjrofCLG4eJ9XN5vPpYKIFw1tLclghbl7GIkxVokC3CqySoUu
         U2i6uCht+nyJQokJqjJ9+HO/vZ3XSNeBmBfyLSf8WqE8RffB0cqZ7XPO74z5z9teev//
         jXDVgOqM5XSzyTiIw1H0YbY98bs5rkCplNIWKpatHMVa7UsfPDC6JrahOZNzTX2F8wpS
         41WMjQFCuK0GOefGGqH6JA7oK0s8XDHJoTzVhTtlfwHIOvKOBnlCBCn+8kYkz2AW47Sf
         1tpV2RDJn5VgJh2iXG5vPt+8s6zQ+wbHmbsuUNPaSFa//fFjNT9BPAl6emlS/y4G9sv1
         Ogww==
X-Gm-Message-State: AOJu0YwCh6Yq3gaA8GR4iyRtnBkZZNv29EFlt3vxIt+v2dLdovxeZPKV
	C8u7oSnV4BxnHV5KwiKq2UREARXivQlIuCY3wPPX3Q==
X-Google-Smtp-Source: AGHT+IFkXalbdwBfeoAIHUWyQHkwpD5Z8rrMweO/5POj2B5sOClOhec7eb1BZ5pHAnLPe5ok0uoTxXHk1QyhnxweAAA=
X-Received: by 2002:a50:8757:0:b0:540:e4c3:430 with SMTP id
 23-20020a508757000000b00540e4c30430mr83579edv.6.1699101699899; Sat, 04 Nov
 2023 05:41:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231104000239.367005-1-seanjc@google.com> <20231104000239.367005-4-seanjc@google.com>
In-Reply-To: <20231104000239.367005-4-seanjc@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Sat, 4 Nov 2023 05:41:24 -0700
Message-ID: <CALMp9eTvR1mNw7PEms7840t13dD_VGhEWpaz9w6prSiyDR9GtA@mail.gmail.com>
Subject: Re: [PATCH v6 03/20] KVM: x86/pmu: Don't enumerate arch events KVM
 doesn't support
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Like Xu <likexu@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 3, 2023 at 5:02=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> Don't advertise support to userspace for architectural events that KVM
> doesn't support, i.e. for "real" events that aren't listed in
> intel_pmu_architectural_events.  On current hardware, this effectively
> means "don't advertise support for Top Down Slots".

NR_REAL_INTEL_ARCH_EVENTS is only used in intel_hw_event_available().
As discussed (https://lore.kernel.org/kvm/ZUU12-TUR_1cj47u@google.com/),
intel_hw_event_available() should go away.

Aside from mapping fixed counters to event selector and unit mask
(fixed_pmc_events[]), KVM has no reason to know when a new
architectural event is defined.

The variable that this change "fixes" is only used to feed
CPUID.0AH:EBX in KVM_GET_SUPPORTED_CPUID, and kvm_pmu_cap.events_mask
is already constructed from what host perf advertises support for.

> Mask off the associated "unavailable" bits, as said bits for undefined
> events are reserved to zero.  Arguably the events _are_ defined, but from
> a KVM perspective they might as well not exist, and there's absolutely no
> reason to leave useless unavailable bits set.
>
> Fixes: a6c06ed1a60a ("KVM: Expose the architectural performance monitorin=
g CPUID leaf")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/pmu_intel.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 3316fdea212a..8d545f84dc4a 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -73,6 +73,15 @@ static void intel_init_pmu_capability(void)
>         int i;
>
>         /*
> +        * Do not enumerate support for architectural events that KVM doe=
sn't
> +        * support.  Clear unsupported events "unavailable" bit as well, =
as
> +        * architecturally such bits are reserved to zero.
> +        */
> +       kvm_pmu_cap.events_mask_len =3D min(kvm_pmu_cap.events_mask_len,
> +                                         NR_REAL_INTEL_ARCH_EVENTS);
> +       kvm_pmu_cap.events_mask &=3D GENMASK(kvm_pmu_cap.events_mask_len =
- 1, 0);
> +
> +        /*
>          * Perf may (sadly) back a guest fixed counter with a general pur=
pose
>          * counter, and so KVM must hide fixed counters whose associated
>          * architectural event are unsupported.  On real hardware, this s=
hould
> --
> 2.42.0.869.gea05f2083d-goog
>

