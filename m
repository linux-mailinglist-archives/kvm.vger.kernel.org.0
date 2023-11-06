Return-Path: <kvm+bounces-775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DEC9D7E274C
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 15:43:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 944DC2811BC
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 14:43:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B175B28DB0;
	Mon,  6 Nov 2023 14:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZiU9OBxE"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F6BAD21
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 14:43:30 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE31EA
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 06:43:28 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-da0c4ab85e2so2648924276.2
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 06:43:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699281808; x=1699886608; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VxhFFdGA0ojufmjeJNUhYbX6mfIrV7txvfMvwhSfBvI=;
        b=ZiU9OBxEeF3BDTeqyGOH4aUPDjpQiz1Jiqxn+UfoMjzf5xw0aDbwoUjR/UIAfwI3hW
         +9gv7hQ8VYVEl0kwTLWpVX0Idjmz8uEHRAZ9YXXXiI2I7koAKLz/ITMczlYoe3h2tuvm
         fhWP3Xm5R80YSa3Sv72nLnyaak0Jdc/V7vjnh/KVR4ZWhbDhbYTubqpVDew01Nz4rBT5
         7smsx88D/bJz+tzwhchhedPJ98s4F/SMvb2EyH3E5SD7kUzj+msO2yKT/JFTd0gSoxrP
         u71I6Ta2IUFCR3Ao7R6kunLz/hzaAozbTY99r5QdpbuPJoi8YM6Qjv+c0/UjjDsMPMCP
         vpHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699281808; x=1699886608;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VxhFFdGA0ojufmjeJNUhYbX6mfIrV7txvfMvwhSfBvI=;
        b=BVlxHdIkBctajaxZxz7Bi9NmU8ZkxvtqL1gs/QnnthioE3fmde+AKD9rMAfrBjYpRD
         cgtU51Y8uUbG0Wbps694DGKhTs6VxoSe7fafrpqN0/tBNS+ISGbS3tcAEMAEfMKB9qYr
         TpC8GTq0wCOCZIl2tFGB5q1UAOS+qBSpK+k/z2M2sUnFMYW/pVNWw+bZ0p8lHbIcxck/
         tdybqXqyMm1pdDJq9MElO8yK0dWIw3I3frUiy6brdC5btLRY/4X7nC8MweKh5zvnyyRq
         OgHKCiym1sUa4ixgA1Qj5bILTERehTD88OU9CuWJkUSezx8a6I8l2lqnnPGjRNi9Jsxh
         9mVg==
X-Gm-Message-State: AOJu0YxajtErj19ak7Va2fJCq8YGSxvwjsLolsdXROcvhXfisRAPq5nN
	JDikNV+B80tYavHzbWgXgVdE+diDopQ=
X-Google-Smtp-Source: AGHT+IEeaK2OvSI6L2Xq4KzsQ2jm/Pbk5vY3mHTW2bRkFtSlTE2uRjmmAIgguun4lL3NuXFip0HnmlUhXYY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ce94:0:b0:da0:3bea:cdc7 with SMTP id
 x142-20020a25ce94000000b00da03beacdc7mr523910ybe.2.1699281807938; Mon, 06 Nov
 2023 06:43:27 -0800 (PST)
Date: Mon, 6 Nov 2023 06:43:26 -0800
In-Reply-To: <CALMp9eSgvq1zOZ4KFnsPHQWk62AGYj560SvVops-bmtpyLGPRQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231104000239.367005-1-seanjc@google.com> <20231104000239.367005-2-seanjc@google.com>
 <CALMp9eSgvq1zOZ4KFnsPHQWk62AGYj560SvVops-bmtpyLGPRQ@mail.gmail.com>
Message-ID: <ZUj7jj-8pzvMDXDA@google.com>
Subject: Re: [PATCH v6 01/20] KVM: x86/pmu: Don't allow exposing unsupported
 architectural events
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Like Xu <likexu@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 04, 2023, Jim Mattson wrote:
> On Fri, Nov 3, 2023 at 5:02=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > Hide architectural events that unsupported according to guest CPUID *or=
*
> > hardware, i.e. don't let userspace advertise and potentially program
> > unsupported architectural events.
>=20
> The bitmask, pmu->available_event_types, is only used in
> intel_hw_event_available(). As discussed
> (https://lore.kernel.org/kvm/ZUU12-TUR_1cj47u@google.com/),
> intel_hw_event_available() should go away.

Ah drat, I completely forgot about this patch when I added the patch to rem=
ove
intel_hw_event_available().

