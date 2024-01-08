Return-Path: <kvm+bounces-5812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 45C3F826F1A
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 13:58:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EAAF5283B03
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 12:58:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58CBA41232;
	Mon,  8 Jan 2024 12:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AhKsGvVK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA344121C
	for <kvm@vger.kernel.org>; Mon,  8 Jan 2024 12:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704718708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lSelulcvnKE/3GrBpLw9pzPjSsB+J8h6YDrw26eu480=;
	b=AhKsGvVKRqUoTun3R58cTlti/0/yjX5O4UeJB52pe8Hik97VK/8qCrb7xoz5tXB2ldojWR
	YP+Ig/inD7XZi88Outn9cwewmHJw7Q11MfSgF9MUexvmeALQHZaMlT0wduYOxUb/Vmslut
	jn9ndA4RQOQGFVy60HPcGn7lnMa25As=
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com
 [209.85.217.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-524-8wRwQ3eTOlC7QSI45ARusw-1; Mon, 08 Jan 2024 07:58:27 -0500
X-MC-Unique: 8wRwQ3eTOlC7QSI45ARusw-1
Received: by mail-vs1-f70.google.com with SMTP id ada2fe7eead31-46734fa034cso126363137.2
        for <kvm@vger.kernel.org>; Mon, 08 Jan 2024 04:58:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704718705; x=1705323505;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lSelulcvnKE/3GrBpLw9pzPjSsB+J8h6YDrw26eu480=;
        b=lu9GMLzedGBlxiPjWi2ExCIqRADp1AKKW8dHaOfdkUUkQNFUleQT96yXwO4jqLIamQ
         7FCOyFqKLjQ3gjQYd6Y5QrRQO4+t0CobLOp78aJ3PnuM7YvIM/cwRII1AJeYd0xk9Gte
         z5b0Zwu9RdMLMbKzeua0YqQcRHKFGvASkav4Xbv1TqHIcMNlELNablmLESkprILuAtPe
         rcq6TEpcOMq4jh//Fj83pLJL0kcjGYplRJGnf91k0O+RIxEob92j/Bz8IPw8i55yVbZV
         f95IcpjhZ4qhUIz4dlr2XzGzqTy53n8kn9p4viLDRmPBbc6c/CMk+IqjcIMvI/hBK4cx
         RYbA==
X-Gm-Message-State: AOJu0Yy8M/EEoaCKJyPPwscMAqaDIWMIp4GCFuFzmQ9M2/gj3vqc5DhB
	igD6gTpCeyMLz/yNTuJq7uATwFJ04QHniM6nbZ7u8eCDm/OuRRZEjjh4fV7JwPIMIe4hR601Jqq
	Nr9WxLvG5PhGj65c20RJu3JNxgMHpAdkJXIjyaPMWpARshbc=
X-Received: by 2002:a05:6102:32c3:b0:467:c620:2ca6 with SMTP id o3-20020a05610232c300b00467c6202ca6mr1052964vss.17.1704718705506;
        Mon, 08 Jan 2024 04:58:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHKSVUGs7BVL3BdtFjy45+2FHYrgGv+oG3o6UXZHhFff0T6HCckIodjFGBXnoZK+FlkGMhwHoRTckhVhLLGoSI=
X-Received: by 2002:a05:6102:32c3:b0:467:c620:2ca6 with SMTP id
 o3-20020a05610232c300b00467c6202ca6mr1052956vss.17.1704718705195; Mon, 08 Jan
 2024 04:58:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240104193303.3175844-1-seanjc@google.com> <20240104193303.3175844-5-seanjc@google.com>
In-Reply-To: <20240104193303.3175844-5-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 8 Jan 2024 13:58:12 +0100
Message-ID: <CABgObfbGtN5AZrqNAhwT7qawuNZA9UW_CoHDULzT191b=eb78Q@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: Misc changes for 6.8
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 4, 2024 at 8:33=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> A variety of one-off changes...
>
> The following changes since commit e9e60c82fe391d04db55a91c733df4a017c28b=
2f:
>
>   selftests/kvm: fix compilation on non-x86_64 platforms (2023-11-21 11:5=
8:25 -0500)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-misc-6.8
>
> for you to fetch changes up to 15223c4f973a6120665ece9ce1ad17aec0be0e6c:
>
>   KVM: SVM,VMX: Use %rip-relative addressing to access kvm_rebooting (202=
3-11-30 12:51:54 -0800)
>
> ----------------------------------------------------------------
> KVM x86 misc changes for 6.8:
>
>  - Turn off KVM_WERROR by default for all configs so that it's not
>    inadvertantly enabled by non-KVM developers, which can be problematic =
for
>    subsystems that require no regressions for W=3D1 builds.
>
>  - Advertise all of the host-supported CPUID bits that enumerate IA32_SPE=
C_CTRL
>    "features".
>
>  - Don't force a masterclock update when a vCPU synchronizes to the curre=
nt TSC
>    generation, as updating the masterclock can cause kvmclock's time to "=
jump"
>    unexpectedly, e.g. when userspace hotplugs a pre-created vCPU.
>
>  - Use RIP-relative address to read kvm_rebooting in the VM-Enter fault p=
aths,
>    partly as a super minor optimization, but mostly to make KVM play nice=
 with
>    position independent executable builds.
>
> ----------------------------------------------------------------

Pulled, thanks.

Paolo

> Jim Mattson (2):
>       KVM: x86: Advertise CPUID.(EAX=3D7,ECX=3D2):EDX[5:0] to userspace
>       KVM: x86: Use a switch statement and macros in __feature_translate(=
)
>
> Sean Christopherson (2):
>       KVM: x86: Turn off KVM_WERROR by default for all configs
>       KVM: x86: Don't unnecessarily force masterclock update on vCPU hotp=
lug
>
> Uros Bizjak (1):
>       KVM: SVM,VMX: Use %rip-relative addressing to access kvm_rebooting
>
>  arch/x86/kvm/Kconfig         | 14 +++++++-------
>  arch/x86/kvm/cpuid.c         | 21 ++++++++++++++++++---
>  arch/x86/kvm/reverse_cpuid.h | 33 ++++++++++++++++++++++-----------
>  arch/x86/kvm/svm/vmenter.S   | 10 +++++-----
>  arch/x86/kvm/vmx/vmenter.S   |  2 +-
>  arch/x86/kvm/x86.c           | 29 ++++++++++++++++-------------
>  6 files changed, 69 insertions(+), 40 deletions(-)
>


