Return-Path: <kvm+bounces-13373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF208895725
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 16:42:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F0B831C222BE
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 14:42:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A1BD132C36;
	Tue,  2 Apr 2024 14:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h8/Ch1Ok"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884C81327FE;
	Tue,  2 Apr 2024 14:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712068760; cv=none; b=K9dJkobsV02aKfL6dohbJpvWnkgo1NmjwZwoWljr588eRBb0aiBjGOqROhJ/EvWL3Z9FUHkxIpLtzc3EqqXVz0LxVhqZ7Yq/ZRAAkBeGPNMi18hiIuhtlNkH9d7f1AsJSiWGhp8EimsA9Q7AhDEA3NyUWIgllmeGIN46K2CwbBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712068760; c=relaxed/simple;
	bh=G9e3W6N3bGr1P9TdCCpqgJEi3f3tuItHV5g5Hh8D9nI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FGS8OF43mpr+/xNDOdTko52zKNeNxKjzQ7GXyGUwLPdz2c8fEFPQc52noInX2QOAmSCPzuQfeRnOlz6ujTDTcYMdH2pwfQ1p48AJM706aE9eb13NtmalBWtIR4Y0UayDanwTqXquFYJ5TzlhqifIYcDvuMwvYXvjIR3LIytXQyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h8/Ch1Ok; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B97BC43143;
	Tue,  2 Apr 2024 14:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712068760;
	bh=G9e3W6N3bGr1P9TdCCpqgJEi3f3tuItHV5g5Hh8D9nI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=h8/Ch1OkS7CAP5n+48xcvGIE7UgD2heYBNjBFPUSY0UtPT7iahu/crhpOqwbN1/wt
	 GeoiaX8ti1adi9NdAf7YNZ2g41djcGdMFl8RGx/CCaLFytbDByMmbTBikgynXmu3Bu
	 yZ6gexjek6WsGEXN38EG95dT91IZUX2qBlJDGbNZYepcqbXAwbg29qwowe6+nDItCk
	 HSWGwlm/ivw1lrWMx1rrNr+T/ar1R867hrkCBbBx3msQgUR/8cCBa4+PH9ojGBk1UH
	 eWvs4fvgy8g10nb0RMY0MgNXO83gLbb9zEOx9rmda3HspF/27kMZidj+ARDffmiVnH
	 JKoVlcdjS2MGQ==
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-56899d9bf52so6701165a12.2;
        Tue, 02 Apr 2024 07:39:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWLqZitLG4SmXcY+veQa5CaBfTcbx7SVfltzYxrxEWg90NMDg0ZZMgQL7faUgZhzcsHhxLh2xQJc15iB40Xq+tvojq8XJnxzlzbqx1fOPSJfKPDHQxPfLNdZSu/Ka9UNfFx
X-Gm-Message-State: AOJu0Yy+VHC0MCu/SJQH4CN2W7VU+AODz3J9xDDILr7fdktj7g7x5eo1
	RcrYR+haEWJnQEWyI46ycxsb2bC2NTl9QLwa1c5lEJ3otB+RRoot/0dRWM/AAVTgP0O/lueQ6in
	MFbGNugzujyt93JkGHlZH4s5hw8M=
X-Google-Smtp-Source: AGHT+IEDdSG9sDtVsGsvj6ZspsV1SWCK7mu10zLwlkz1tnJkelJ4bPKskClQLYly4SO9mHsh+ctTQKTSSIS21vop3EU=
X-Received: by 2002:a17:906:957:b0:a4e:2ad1:52f2 with SMTP id
 j23-20020a170906095700b00a4e2ad152f2mr9051652ejd.6.1712068758766; Tue, 02 Apr
 2024 07:39:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240402103942.20049-1-guanwentao@uniontech.com>
 <453b49801d789523f7366507d1620728315b1097.camel@xry111.site> <tencent_411F127936C0F14A261A445E@qq.com>
In-Reply-To: <tencent_411F127936C0F14A261A445E@qq.com>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 2 Apr 2024 22:39:07 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4bCA=9yMEtDgpuj7bp5tE_+M0O2y22MBAvP8BhWXHO7Q@mail.gmail.com>
Message-ID: <CAAhV-H4bCA=9yMEtDgpuj7bp5tE_+M0O2y22MBAvP8BhWXHO7Q@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: KVM: Remove useless MODULE macro for MODULE_DEVICE_TABLE
To: Wentao Guan <guanwentao@uniontech.com>
Cc: Xi Ruoyao <xry111@xry111.site>, zhaotianrui <zhaotianrui@loongson.cn>, 
	loongarch <loongarch@lists.linux.dev>, linux-kernel <linux-kernel@vger.kernel.org>, 
	=?UTF-8?B?546L5pix5Yqb?= <wangyuli@uniontech.com>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 2, 2024 at 6:46=E2=80=AFPM Wentao Guan <guanwentao@uniontech.co=
m> wrote:
>
> OK, it will resend in PATCH V2.
> I have a mistake to not add "__maybe_unused" in cpu_feature structure.

__maybe_unused is not encouraged unless there is no other solution, in
this case it is better to keep the old style, which is the same as
vmx.c and svm.c in x86.

Huacai

