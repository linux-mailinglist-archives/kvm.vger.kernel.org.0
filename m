Return-Path: <kvm+bounces-5454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EBE188220DC
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 19:19:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A07031F23297
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 18:19:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EB5F156E4;
	Tue,  2 Jan 2024 18:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eCxXarr+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D1115AC1
	for <kvm@vger.kernel.org>; Tue,  2 Jan 2024 18:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704219562;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/nCI2XqcgtmfKoc7R6akxQ8EGO852Fcbw810Pl2QliE=;
	b=eCxXarr+kuEZqh/VU3cd26IJyjQQ4WEHNcWGw3VjgPf5c4WX7MWr+GFH5Q5CqRosmdcEnd
	5fY49JaUKo/JwFYSVhGXuta4OR+Vh+lzNnftb3P+ZrWtYWX/pkyXJAHoRkVMYBiI79nVxZ
	uEI3TxrvmsRTRlPNudO1R/eG/+I7f+E=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-339-eZh0wHyCOeSS625Xa6xcSQ-1; Tue, 02 Jan 2024 13:19:21 -0500
X-MC-Unique: eZh0wHyCOeSS625Xa6xcSQ-1
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-466f7eef6feso1516335137.1
        for <kvm@vger.kernel.org>; Tue, 02 Jan 2024 10:19:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704219561; x=1704824361;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/nCI2XqcgtmfKoc7R6akxQ8EGO852Fcbw810Pl2QliE=;
        b=Ci8KPOMe11BoA6/6vqJU4ThZOYV2z04sp4TxFVF4QwZBcrSVhSsF4gaqHZfNRtkF3Q
         JxPMKPbZ8lVUGRWrYu5pBWNu+Gf/SAjRxZJxMegG1gunaLdkT+iFc3y7VRH5NNDakux7
         Nq49sr7IPaThjuE8eJOXt1xuu/4b96jtpIv0E8prBAWTQpsMKKuWr1pfyXMAOPljsWzd
         qpo0RbKdQEtzI3mFTV/PyJqMCyXeoKG6HlzKzv2xW5xVEGCHDi7N/NhcnOyBSDh8wdHh
         JPHBg0Vud+0FebCnt2AHQL65jLfx4w14UTFmr6VXxsZSS+ZDWITS5Lud8IOMx9I8sjEp
         H/rg==
X-Gm-Message-State: AOJu0Ywg5WCdEBE9eHyx0o8lSPClHoD1Tl2vnG7Sk0ETJH+zEJJQ9NaR
	bZ+fRiB2wWElepZHm+rP1z/jQs7ssL8Arjo+bF74HpeWhCCecYsOCIB+eHlI5nMnVCfcV7k5mGh
	dY6aMF7OU/wrMhp8SUpePAGrVUSWt4WA/l303
X-Received: by 2002:a05:6102:f9a:b0:467:6ca:b4ea with SMTP id e26-20020a0561020f9a00b0046706cab4eamr7415148vsv.27.1704219560852;
        Tue, 02 Jan 2024 10:19:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFPp0hG5WfkeH0LzbjHWajPiAB+9qxqxdd6BihIJP6uy3Mm09c3D7x8kSQRjFEc/rxbGbMilzXbl6vnT7O0UpU=
X-Received: by 2002:a05:6102:f9a:b0:467:6ca:b4ea with SMTP id
 e26-20020a0561020f9a00b0046706cab4eamr7415124vsv.27.1704219560266; Tue, 02
 Jan 2024 10:19:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240102133629.108405-1-frankja@linux.ibm.com>
In-Reply-To: <20240102133629.108405-1-frankja@linux.ibm.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 2 Jan 2024 19:19:09 +0100
Message-ID: <CABgObfZYzBgtLVhqH+ADXM0kEkK9F_MK0jcjjhOPooSU1YQFHw@mail.gmail.com>
Subject: Re: [GIT PULL 0/4] KVM: s390: Changes for 6.8
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, david@redhat.com, borntraeger@linux.ibm.com, 
	cohuck@redhat.com, linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, 
	seiden@linux.ibm.com, nsg@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 2, 2024 at 2:37=E2=80=AFPM Janosch Frank <frankja@linux.ibm.com=
> wrote:
>
> Dear Paolo,
>
> please pull the following changes for 6.8.
>
> The changes are fixes/cleanups that didn't require a fix pull and
> hence landed in next.
>
> -The uvdevice didn't return a firmware return value to
>  userspace. This didn't matter since that value was unused but might
>  be used in the future.
>
> -The stfle vsie code was not 100% spec compliant because it checked
>  for readability of an area that was larger than the one accessed by
>  firmware. Additionally there was an issue with a mask being applied
>  to early.
>
> The following changes since commit 98b1cc82c4affc16f5598d4fa14b1858671b22=
63:
>
>   Linux 6.7-rc2 (2023-11-19 15:02:14 -0800)
>
> are available in the Git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/=
kvm-s390-next-6.8-1
>
> for you to fetch changes up to 10f7b1dcdfe05efcd26e90e337daf1bfd8f4a6da:
>
>   KVM: s390: cpu model: Use proper define for facility mask size (2023-12=
-23 10:41:09 +0100)
>
> ----------------------------------------------------------------
> - uvdevice fixed additional data return length (Steffen)
> - stfle (feature indication) vsie fixes and minor cleanup (Nina)
> ----------------------------------------------------------------

Pulled, thanks.

Paolo


