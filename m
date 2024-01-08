Return-Path: <kvm+bounces-5808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D4981826F08
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 13:54:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 65F4EB21B6D
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 12:54:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CEC641222;
	Mon,  8 Jan 2024 12:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PrOWkqbf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA1741218
	for <kvm@vger.kernel.org>; Mon,  8 Jan 2024 12:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704718439;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gvglX5vfzLPGQZ0Qz47T67FC34QNQiEWEPjU/z3PgsI=;
	b=PrOWkqbfGq98qPqHLm+iFBKrR2zO5EOh8JwtUrRu0ZfECZeZ7Im1SVdq6BbHFmTUNUD50M
	DzjlVMisPaDkhCNFeDYdebRvtEgl8EOvi2rOJSYeL9lR9IcpZtvKG+dCHlu8FN09gF81Fj
	OmPlL+sNmfjAZ4PGj/sxrhv7l7FuY+I=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-37-A4LPHVgSPt2LEad64eoY7w-1; Mon, 08 Jan 2024 07:53:52 -0500
X-MC-Unique: A4LPHVgSPt2LEad64eoY7w-1
Received: by mail-vk1-f199.google.com with SMTP id 71dfb90a1353d-4b7242a3d15so275887e0c.3
        for <kvm@vger.kernel.org>; Mon, 08 Jan 2024 04:53:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704718432; x=1705323232;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gvglX5vfzLPGQZ0Qz47T67FC34QNQiEWEPjU/z3PgsI=;
        b=tTjgZ0dt5+siHjlyv/T8bUL14fu6nx4DrFEzeQmeRQwVHRqg4C/WM/5qi9cnC5vr9D
         Jx8C/Gg/9tZso80grP/SC0EQOX8Inuj4cuyFGqANDRp35u75mrAz+yu1IsxJ4VkAdNJs
         MEd8fCQ0mrQD3oOUdaZpAUT5pjzi31/HGEm97Mth2z1X9Xr0sPe1WvoOPik8UGO0HTip
         lVyICzMUsTFDsNamJtJFg8Zm+TJRN/zeEMbGQngVN6Hh5aBPSxIPNacLX7mb8cTJnFa5
         xqE0oGFF5TcLMmpbuPomCRAAb/FW0YUSXZKYfxeYDv+ENC4YGHbsicFi1o/g6b9JkbyS
         +/nQ==
X-Gm-Message-State: AOJu0YxjpTMW9E3quRb+uXTapS4Oy489nBK2Xx+wvJEmKka4V/Sdh5+2
	JxEEtSabHnGHGCU5RFT0oRGTnP06J0ZfDPDT3j8k/MGJC2CBTSx8Qs35pLA6hMkz+mO49zzfUAS
	MeubH/w0bbgAFB83A2mECancVR9kzHUx4TMNA
X-Received: by 2002:a05:6102:f14:b0:467:d295:377b with SMTP id v20-20020a0561020f1400b00467d295377bmr696758vss.45.1704718431973;
        Mon, 08 Jan 2024 04:53:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH4iZj6Z4CtUJTRdLavXSn1LD4TkVBf4/0EakNdwjXOF+p2sj0LPVYqkUxZ0kYYFZzYyEj/WY2OkrttCyG+zzY=
X-Received: by 2002:a05:6102:f14:b0:467:d295:377b with SMTP id
 v20-20020a0561020f1400b00467d295377bmr696748vss.45.1704718431762; Mon, 08 Jan
 2024 04:53:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240105111756.930029-1-maz@kernel.org>
In-Reply-To: <20240105111756.930029-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 8 Jan 2024 13:53:39 +0100
Message-ID: <CABgObfZFccM6vH4r7oVHgRc3fhgyd=Z5iGKbCar5EEywiFOcUQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 updates for 6.8
To: Marc Zyngier <maz@kernel.org>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, Andre Przywara <andre.przywara@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Ard Biesheuvel <ardb@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Joey Gouly <joey.gouly@arm.com>, 
	Kunkun Jiang <jiangkunkun@huawei.com>, Mark Brown <broonie@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Quentin Perret <qperret@google.com>, Russell King <rmk+kernel@armlinux.org.uk>, 
	Ryan Roberts <ryan.roberts@arm.com>, Will Deacon <will@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 5, 2024 at 12:18=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> Hi Paolo,
>
> Here's the set of KVM/arm64 updates for 6.8. The highlight this time
> around is the LPA2 work by Ryan, bringing 52bit IPA/PA support to 4k
> and 16k page sizes. Also of note is an extensive FGT rework by Fuad
> and another set of NV patches, mostly focusing on supporting NV2.
>
> The rest is a small set of fixes, mostly addressing vgic issues.
>
> Note that this PR contains a branch shared with the arm64 tree (sysreg
> definition updates), and that the LPA2 series is also shared with
> arm64 to resolve some conflicts.
>
> Please pull,
>
>         M.

Pulled, thanks.

Paolo


