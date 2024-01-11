Return-Path: <kvm+bounces-6105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D151C82B371
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 17:56:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6966E28C843
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 16:56:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E86CF51C2E;
	Thu, 11 Jan 2024 16:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cWljiVBI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17F951C2D
	for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 16:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-40d6b4e2945so64661725e9.0
        for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 08:56:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704992180; x=1705596980; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oR1Y72TSfaMJp+R/VUfn33uF7MHUwj+BmNXeEjIXlZc=;
        b=cWljiVBI6jOLU7lJLki2AmWcGELQIPU2SNs6E0LgEH1L4JnphLecP2cgKxAPQRcK5w
         dt5ZC8aEBEXgMacRhQ1zIUQYywPQdDBW7FAeFfGO/7fsVBReSW8c6YN54Rz14RyjvmXF
         TKndDpP0XgXVqnBGjsPQFZbJldXCEFI9YQxjuOnlu+98HTsE2w55E9ESHBqRKEuOWZMu
         SyB1a3eu3Tj+d5QoLcNg8+mn+9Z7VzUJUe6PAXEVkJSuc0FI+HtFQXYJOfbWDiM+ktxM
         8ljYJaDnl2N+JEWfA900cRKrYS1PhXBsOlE3Vy75QvNJoKTQbwWXpL0LuKzIEx5oj98n
         38dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704992180; x=1705596980;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oR1Y72TSfaMJp+R/VUfn33uF7MHUwj+BmNXeEjIXlZc=;
        b=c/zr7NtYTBZeQzB7DQ42xHGHij8bL/UiSBAuhDIr/r8VMGUFcU9UAtSQvVjflU0z4X
         p+mBFABVq5sAJY24tDsjl8CpwOvj4KOKIi1gSSs7Q0HwJCTqzrXGoOOpMQ9j3ydY7iP6
         zpKIcqmtpLaKr2Bg9gB8yaILBt1mzgjHLuFP0pcE2KfZuR0po5INlFj6ExQ/REKMCsKQ
         UxfnZ4esI/IqivIg7jOCUUyRy8zSE5FuQL3aFlcgIQ6DcSZ9PmUvSDu3T4xm267gMfEX
         +JCwrj+HukUyALIbSyLXP8FxQxnmb+AT4JARuOlt/MUO1k5Vl5DWA790FkMOdxcDauw9
         o7FQ==
X-Gm-Message-State: AOJu0Ywj67o0fH7wFWcHTk/qP+FMeNGwfADNodIXUK6PZW0fpPtY6RtB
	4BZPvOnnKDKo2E8X5CuVOjpZAcnf/nYZLEesvvwIlNlTiCKv
X-Google-Smtp-Source: AGHT+IFO+12NRgsnH6/JwiBlniz0V4FLpV8h+YgGqs9r0sGuaygO8JEdrt/GsmZIUFTc4j79TZGLMzHHjnj6wz0qssQ=
X-Received: by 2002:a1c:7510:0:b0:40e:4244:c01b with SMTP id
 o16-20020a1c7510000000b0040e4244c01bmr55868wmc.7.1704992179857; Thu, 11 Jan
 2024 08:56:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231205181645.482037-1-dmatlack@google.com>
In-Reply-To: <20231205181645.482037-1-dmatlack@google.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 11 Jan 2024 08:55:50 -0800
Message-ID: <CALzav=d0w=u3n4CcSWVOv=A-9v+x54aP+KVGBOrZ0=F+R5Yy-A@mail.gmail.com>
Subject: Re: [PATCH] KVM: Aggressively drop and reacquire mmu_lock during CLEAR_DIRTY_LOG
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 5, 2023 at 10:16=E2=80=AFAM David Matlack <dmatlack@google.com>=
 wrote:
>
> Aggressively drop and reacquire mmu_lock during CLEAR_DIRTY_LOG to avoid
> blocking other threads (e.g. vCPUs taking page faults) for too long.

Ping.

KVM architecture maintainers: Do you have any concerns about the
correctness of this patch? I'm confident dropping the lock is correct
on x86 and it should be on other architectures as well, but
confirmation would be helpful.

Thanks.

