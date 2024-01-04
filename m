Return-Path: <kvm+bounces-5640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B16C78240B2
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 12:33:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 449D12835A9
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 11:33:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0191621361;
	Thu,  4 Jan 2024 11:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="qP8srV68"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B02721344
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 11:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3606ac90de0so18555ab.0
        for <kvm@vger.kernel.org>; Thu, 04 Jan 2024 03:33:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1704368001; x=1704972801; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5Dt7uLNKLulzrg/dNC959xAVcdyKjB2fv5qTZvClME8=;
        b=qP8srV683Nx5VjKLocNoI3lP4d1WSQwwYemqOPlfTCt9LUKdj1V09Ba2t28qrFgzFc
         7by1AYbyw0bzfgGrgY+9ZuC8s03kOUUEm/W0ulGTKQFIXtSSgrhuuN9lLJh8XHkYpt7W
         hk9yUoaYC1EWBgEgkmR06zRTu/3IAurCPUg4zt0A2i/5OqY01n+uPEgeNkuB1bhejEvk
         Uo43G0mls0vRZTyJhrlqyvjsBNhx0Xrj0YhEtGb0eDbOUpGmpa/F8YOu06DaVHWrN4Dt
         vmv8TWZgMPepuYRxxehNfddm3MYjqLP9AjCJjznQ2lKgvMb0ioCQCsxP37N7TR80kS8c
         TLHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704368001; x=1704972801;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5Dt7uLNKLulzrg/dNC959xAVcdyKjB2fv5qTZvClME8=;
        b=nqLTDguPOckpNEApbQP4qeWhRRpW48iDksEfF4aA8MWayQ6r2lDxl8K5FOEy5zbB9N
         +7Ft4DDw/Ng0V1nxOXZJM+81EsO51g08Xl/EUAgjUr/VABANNAh/LOsSWyrzXbfxK0TO
         V9n+6GWfOJCF+gx8DhcJCklE46rxIwF4qS8sj12/CEkPbSAWfCKXZq9Vr6v7GRlPgzPJ
         ZbdB5IFQ9Doh9wSyL2fs0Xt5Glfac0r+Jw+n4f7qsGRrlO5vveL1RyPBS6nzbr1Yitx1
         R41KVqiS1VPlCn6ZOE5nGWnfkACeFQsugfSzpvKpeO2QNXqk0U5ptLTxRoxo/X/2HceA
         C4hw==
X-Gm-Message-State: AOJu0YwaO2xzDcwb5fm4rIV7tN2ML7+MiD/bnzR/Wpc2flWNwiku1BIq
	HvxWEoLQbwDO0MPBqDYEjjszvPnVnnwgKYKaWHEXlTiFFN1Iqg==
X-Google-Smtp-Source: AGHT+IEiLv7qiits4vk8xdWF1s4r4OiPqhbNMM2mLBiLLO2wGlETEHoIcyBn6dRE3jspd9+Bb4GSzadf5GgKpkLl1DU=
X-Received: by 2002:a05:6e02:17c9:b0:360:16c7:2d6a with SMTP id
 z9-20020a056e0217c900b0036016c72d6amr482112ilu.48.1704368001050; Thu, 04 Jan
 2024 03:33:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240104104307.16019-2-ajones@ventanamicro.com>
 <20240104-d5ebb072b91a6f7abbb2ac76@orel> <752c11ea-7172-40ff-a821-c78aeb6c5518@ghiti.fr>
 <20240104-6a5a59dde14adcaf3ac22a35@orel>
In-Reply-To: <20240104-6a5a59dde14adcaf3ac22a35@orel>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 4 Jan 2024 17:03:10 +0530
Message-ID: <CAAhSdy0uVZXsP1_3zZiwXXEXBZGkmWX5ujptirojD8S4nuzQpQ@mail.gmail.com>
Subject: Re: Re: [PATCH] RISC-V: KVM: Require HAVE_KVM
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, linux-riscv@lists.infradead.org, 
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, atishp@atishpatra.org, rdunlap@infradead.org, 
	sfr@canb.auug.org.au, mpe@ellerman.id.au, npiggin@gmail.com, 
	linuxppc-dev@lists.ozlabs.org, pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 4, 2024 at 4:51=E2=80=AFPM Andrew Jones <ajones@ventanamicro.co=
m> wrote:
>
> On Thu, Jan 04, 2024 at 12:07:51PM +0100, Alexandre Ghiti wrote:
> > On 04/01/2024 11:52, Andrew Jones wrote:
> > > This applies to linux-next, but I forgot to append -next to the PATCH
> > > prefix.
> >
> >
> > Shoudn't this go to -fixes instead? With a Fixes tag?
>
> I'm not sure how urgent it is since it's a randconfig thing, but if we
> think it deserves the -fixes track then I can do that. The Fixes tag isn'=
t
> super easy to select since, while it seems like it should be 8132d887a702
> ("KVM: remove CONFIG_HAVE_KVM_EVENTFD"), it could also be 99cdc6c18c2d
> ("RISC-V: Add initial skeletal KVM support").
>
> I'll leave both the urgency decision and the Fixes tag selection up to
> the maintainers. Anup? Paolo?

Lets add

Fixes: 99cdc6c18c2d ("RISC-V: Add initial skeletal KVM support")

Regards,
Anup

