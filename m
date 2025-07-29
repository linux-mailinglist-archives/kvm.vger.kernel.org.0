Return-Path: <kvm+bounces-53635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 20702B14D10
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 13:37:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 34BAF3AEA18
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 11:36:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23E6828DF0C;
	Tue, 29 Jul 2025 11:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="mXOPsRtM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94827254841
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 11:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753789032; cv=none; b=TAKkzAUD9SsK9yYCOCPCVBREic2Zkq9ev+p7Lal9aRRFrTKW35jI0vA9V2dHYT9iYmrLuFRQ/B5h6VdtWJ11/fGEDZ/lQkqWfXLzPVwPPJdPl4NvA/xSkXrO0PINJ89PAVXipU4wAsfEYuenJuoE8gQMNkoV4gZLiBi3ZBL8pok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753789032; c=relaxed/simple;
	bh=mNd74IQITEorMs9LyfvIzBFQmBs+koTjl7VxtOqVCCw=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=K8ekqI//6bqBb3QZuiPjlpcbhr3UgXTne49oWfaEMqy9fCreihxX/RaOHIWLKO85N46wFj6dKzHo1yx/WT7Uurg03yyw6jsr40u8BUQMd4Tb3fQXu6+JdNeu0J1BFN6kEVO2kgu7GybkTgfBUlol5Fu/f7QRPA/aYGjQeC3+MFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=mXOPsRtM; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-456133b8d47so3229355e9.2
        for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 04:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1753789029; x=1754393829; darn=vger.kernel.org;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mNd74IQITEorMs9LyfvIzBFQmBs+koTjl7VxtOqVCCw=;
        b=mXOPsRtMnNqvlz0Pnkb6JB9WLnCCGl41bH9J5DbczE4MMvssYeg1Y+5g1IjL2/iHZx
         LhLlfiAhE0gYr0oD0+C/9xSB4wDSzPpc0D2j31kdXxVbVwcXqyVezfLrFcRHQ7SZkYje
         chBsgBT3LYF+cPPK7dGedkwny8G/s8Mk73fWjhwdS5bu3ug/5Y3Ys+5j4FeJYsVm0hJK
         UH1HhIAgCIOjspezwM7sIHvhTMi0vJqKWQNHZp0pKnRbwCi44UHURHmMFXOL7CB/GeSi
         FRURq5qFL4mItjE9OoMwzwgm58yZAZT1LlP33eWDCSlLnQ9gPgJFydB81mj7y+06tE5q
         Ld9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753789029; x=1754393829;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mNd74IQITEorMs9LyfvIzBFQmBs+koTjl7VxtOqVCCw=;
        b=hek5SOt8wPgfsGnuHNfIyCRfLNROHfqUweUIihI7pZ32qgT25GtjnF9k/JP9YEzywL
         d29R9i7RQxgeD/KUGUXnEgQjvXJyDQQI0fI3ccdSDx1AeCW0YKOTIpwN3i+gECW0M1ne
         +gC1fNu+huAhA8MhNIkMpZiRq7PjZOKY3FTTG/xlHYX3ujQBUD16x4j7Vuvxfzatyspw
         0cqn/UlWeEkp0aan219OAcK3qXC6255b9Uw2t6njsAKRKG2uUkMr4ZckNuu/w7cKSPku
         MTxzwZ+W4cGXoJUloSYet/U72L5nwzj4F3WozOusEw0M+gFYovD5X4gtsgrkcZWXA9Zv
         pyoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVPmGsS5b9tEg6UQ/CIkqNYCyclzaulRtl/1+xdbMvbxpSOv0HJdMciQ+6sFYcCsY6uUkM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCLZBnkBdf7a29p/QoZEoqgWJMNzIQh81nyRtVH8438x5+0558
	R5+TjVQc2sMjN6tFDUwRm6UWEFrhN7ync2A6Mkg3eO+9dYiPUJykU7HCUN5gPYYNjuY=
X-Gm-Gg: ASbGncvQ90gRPWuPqoz8zEWjs/bKu8bS4YL/wBY8A/dtZgHN23XjdF7h/jbGus4HUSE
	9yCUatVc9peTENVKrJtpZTX58YHavjHzktXLu9Ln6xf/82Br7qR7ez8C7LBZwbGZR+3t62VEI6c
	t+e7mDJRXOhNeVgJyk7oIwnV3ULmtx+VcV4lBs5xkVFWTpjpgChnuBuQrZi6mycu3LmxmB36l+4
	TSczLXEfI3YNNo1/IpaegEhhe1iyZn7DsuBmRkE+xjg3kh2EgSXqhln2fobWS2hakkp7w4lnVRP
	DGFxIpzUmKDWVhHKO0thMeowQpF7aNBBn6qiPJ6FPB7Z8JBDwB6TXJa+lc24JAYn1dJhHKfIhqv
	NXSA4pq401VqmPMmdoBdiWOlJSOcroqymPrn7Qv2F
X-Google-Smtp-Source: AGHT+IGx/xqumpoXOavJf3Q9WFPJjniNReIvUAgEgTBSvd6YC7kBN//pTA0UjL3asQ8LZFYOCaj+XA==
X-Received: by 2002:a05:600c:46ce:b0:43b:c844:a4ba with SMTP id 5b1f17b1804b1-4587654b656mr47415595e9.3.1753789028662;
        Tue, 29 Jul 2025 04:37:08 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200:293e:b70a:263b:689c])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4588e5cc2aasm22325705e9.16.2025.07.29.04.37.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jul 2025 04:37:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 29 Jul 2025 13:37:07 +0200
Message-Id: <DBOIBORLK6YM.7SND5YPEJR60@ventanamicro.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.17
Cc: "Anup Patel" <anup@brainfault.org>, "Palmer Dabbelt"
 <palmer@dabbelt.com>, "Andrew Jones" <ajones@ventanamicro.com>, "Atish
 Patra" <atishp@rivosinc.com>, "Atish Patra" <atish.patra@linux.dev>, "open
 list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)"
 <kvm-riscv@lists.infradead.org>, "KVM General" <kvm@vger.kernel.org>,
 "linux-riscv" <linux-riscv@lists.infradead.org>, "linux-riscv"
 <linux-riscv-bounces@lists.infradead.org>
To: "Paolo Bonzini" <pbonzini@redhat.com>, "Anup Patel"
 <apatel@ventanamicro.com>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
References: <CAAhSdy12xtRRem-AybfymGHh+sj4qSDDG0XL6M6as=cD5Y2tkA@mail.gmail.com> <CABgObfYEgf9mTLWByDJeqDT+2PukVn3x2S0gu4TZQP6u5dCtoQ@mail.gmail.com> <CAAhSdy3Jr1-8TVcEhiCUrc-DHQSTPE1RjF--marQPtcV6FPjJA@mail.gmail.com> <CABgObfaDkfUa+=Dthqx_ZFy418KLFkqy2+tKLaGEZmbZ6SbhBA@mail.gmail.com> <CAK9=C2VamSz4ySKc6JKjrLv9ugcTOONAL4+NmKAexoUgw7kP6w@mail.gmail.com> <CABgObfZu2fPFaSy2EHzpD_MUwYYeYMfz6BfXmTw_h3ob1q2=yg@mail.gmail.com>
In-Reply-To: <CABgObfZu2fPFaSy2EHzpD_MUwYYeYMfz6BfXmTw_h3ob1q2=yg@mail.gmail.com>

2025-07-28T18:50:10+02:00, Paolo Bonzini <pbonzini@redhat.com>:
> Il lun 28 lug 2025, 18:21 Anup Patel <apatel@ventanamicro.com> ha scritto=
:
>> Currently, userspace only has a way to enable/disable the entire
>> SBI FWFT extension. We definitely need to extend ONE_REG
>> interface to allow userspace save/restore SBI FWFT state. I am
>> sure this will happen pretty soon (probably next merge window).
>>
>> At the moment, I am not sure whether userspace also needs a
>> way to enable/disable individual features of SBI FWFT extension.
>> What do you think ?
>
> Yes, you do. FWFT extensions are equivalent to CPU extensions. But all
> this should have been done before including Clement's work. Without it
> userspace has no way to support FWFT.
>
> Drew, I see you have Reviewed-by on the patches; please keep an eye on
> this stuff.

Sorry, I didn't try too hard to convince others after noticing it, and
planned to fix the most significant breakage in later rcs.
(If FWFT wasn't enabled by default, sane userspace just wouldn't expose
 FWFT to the guest until a proper KVM configuration was added).

