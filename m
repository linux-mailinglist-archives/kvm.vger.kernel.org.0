Return-Path: <kvm+bounces-5811-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B350826F18
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 13:58:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B27BF1C2279F
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 12:58:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C334F41752;
	Mon,  8 Jan 2024 12:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QUgwJxFn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED0141212
	for <kvm@vger.kernel.org>; Mon,  8 Jan 2024 12:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704718683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vZpnq4c+Vs6eiz9gYwBliSB+2qs3HTyiOGVk9N9ZUd4=;
	b=QUgwJxFnoWv69TsyrMlGs7QGJVUowUIY6HWsitglN8WxW9kL7+MlM27a4QZQcD6aqq6dno
	lg9fJsjLjHrac4lP/bTowmYIYLCRFVafW1/Hnb2x1zWRkmI6LNrWP5h0ntXuSn/yOSq8fB
	1Smnw/uaGqx3QBE5nDEIUKTbvqniHvw=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-88-JHVukIpkMSSIDV63_MifXA-1; Mon, 08 Jan 2024 07:58:00 -0500
X-MC-Unique: JHVukIpkMSSIDV63_MifXA-1
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-7ce090dc569so466600241.0
        for <kvm@vger.kernel.org>; Mon, 08 Jan 2024 04:58:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704718679; x=1705323479;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vZpnq4c+Vs6eiz9gYwBliSB+2qs3HTyiOGVk9N9ZUd4=;
        b=XDttQNu9Hw5yYc7b5k5vsq4lX1F7ApHXs11K+EC88GiFDvoAmCBQGkxpyS7KdBVNVz
         8er23LE8vmXWzj5EIv2TSRZZGZ+pLbFr1FUAutmiGrQTmipAegWDdHnUV6zVb9r9ApO+
         DE9oGjMA/jd4La6qt3v+2UZ0PNbSy2oI5P1GztA0sEn6IvZoCLsS3cGWCaRSW7BNQznX
         83oiAb7pIBZAXKOMoYcVRuNdLEQIyAezHYXIf6pmCkWvRvJ2gaqv054QCEgKfVlWebJL
         3J/RMlXVzJ10od3RiA1rZbvtmkVPI7Ppj1YRM+1e19YeZGGYb1lRlmtyDTCc4Hx/+nVj
         MoPA==
X-Gm-Message-State: AOJu0YwiB0tWUaNl368QPJgX9lOHTgQEc2afZ4zQmhc1omY3Q55wJtmy
	DaIyxi3YymFAmrxminIUT4dg87tx++YyMgRZMjMPyriqlbu/cfeFGJg7j5f9hG4fFeYsArjDUGL
	9/mknpEbLeaoa5vTqzYcgKbARto4xCE24j8TJ
X-Received: by 2002:a05:6102:510a:b0:467:d9f6:f96c with SMTP id bm10-20020a056102510a00b00467d9f6f96cmr355495vsb.1.1704718679617;
        Mon, 08 Jan 2024 04:57:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEwiRVFSpj6pU2tQle27Wl7LVL2AZ3IiIt2A08Xdq7I2pQsFRN+8eb1bErl+PdqGvbqKPYf+NpZMCnQVZPanp4=
X-Received: by 2002:a05:6102:510a:b0:467:d9f6:f96c with SMTP id
 bm10-20020a056102510a00b00467d9f6f96cmr355488vsb.1.1704718679357; Mon, 08 Jan
 2024 04:57:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240104193303.3175844-1-seanjc@google.com> <20240104193303.3175844-7-seanjc@google.com>
In-Reply-To: <20240104193303.3175844-7-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 8 Jan 2024 13:57:47 +0100
Message-ID: <CABgObfYR7a8+YUmLTZs=Wner+mQoEKsgQx4S70nHA2_nvOvNbg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: PMU changes for 6.8
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 4, 2024 at 8:33=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> PMU fixes and cleanups.  The highlight is a fix for a double-overflow PMI=
 bug
> when KVM manually emulates counter events, which was made mostly benign b=
y
> commit a16eb25b09c0 ("KVM: x86: Mask LVTPC when handling a PMI"), but is =
still
> a bug.
>
> Note, the "Track emulated counter events instead of previous counter" fix
> breaks the PMU KVM-Unit-Test due to a long-standing "bug" in perf[*].  If=
 need
> be, it's trivial to fudge around the shortcomings in the KUT code, I just
> haven't carved out time to push things along.
>
> [*] https://lore.kernel.org/all/20231107183605.409588-1-seanjc@google.com
>
> The following changes since commit e9e60c82fe391d04db55a91c733df4a017c28b=
2f:
>
>   selftests/kvm: fix compilation on non-x86_64 platforms (2023-11-21 11:5=
8:25 -0500)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-pmu-6.8
>
> for you to fetch changes up to fd89499a5151d197ba30f7b801f6d8f4646cf446:
>
>   KVM: x86/pmu: Track emulated counter events instead of previous counter=
 (2023-11-30 12:52:55 -0800)

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> KVM x86 PMU changes for 6.8:
>
>  - Fix a variety of bugs where KVM fail to stop/reset counters and other =
state
>    prior to refreshing the vPMU model.
>
>  - Fix a double-overflow PMU bug by tracking emulated counter events usin=
g a
>    dedicated field instead of snapshotting the "previous" counter.  If th=
e
>    hardware PMC count triggers overflow that is recognized in the same VM=
-Exit
>    that KVM manually bumps an event count, KVM would pend PMIs for both t=
he
>    hardware-triggered overflow and for KVM-triggered overflow.
>
> ----------------------------------------------------------------
> Sean Christopherson (6):
>       KVM: x86/pmu: Move PMU reset logic to common x86 code
>       KVM: x86/pmu: Reset the PMU, i.e. stop counters, before refreshing
>       KVM: x86/pmu: Stop calling kvm_pmu_reset() at RESET (it's redundant=
)
>       KVM: x86/pmu: Remove manual clearing of fields in kvm_pmu_init()
>       KVM: x86/pmu: Update sample period in pmc_write_counter()
>       KVM: x86/pmu: Track emulated counter events instead of previous cou=
nter
>
>  arch/x86/include/asm/kvm-x86-pmu-ops.h |   2 +-
>  arch/x86/include/asm/kvm_host.h        |  17 +++-
>  arch/x86/kvm/pmu.c                     | 140 +++++++++++++++++++++++++++=
------
>  arch/x86/kvm/pmu.h                     |  47 +----------
>  arch/x86/kvm/svm/pmu.c                 |  17 ----
>  arch/x86/kvm/vmx/pmu_intel.c           |  22 ------
>  arch/x86/kvm/x86.c                     |   1 -
>  7 files changed, 137 insertions(+), 109 deletions(-)
>


