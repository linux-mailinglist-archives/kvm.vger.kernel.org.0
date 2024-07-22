Return-Path: <kvm+bounces-22036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 51F4C938A84
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 09:55:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E6F3281631
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 07:55:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8702A1607BD;
	Mon, 22 Jul 2024 07:55:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8175A381BA;
	Mon, 22 Jul 2024 07:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721634928; cv=none; b=DgCP4M5enO2DxS7uaj/7VtwmME+lVS7UZ0qYi8vjfX4swjcXbjYJMFEvKoKoCb6LGZ5oCeDJeVeiww+NmBSxq4+ik/6KlkQbc4eZCEWvhas3u3O3BRXTvxdehof+elClEc2vpksZpfPnYmX9F1dgz0UG5+fv2U25jkhWyt/vZWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721634928; c=relaxed/simple;
	bh=/GqmcqtTaDbS5cQZIIQi0gOJw88P25ZDGG0pgSEFHqw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KIqwIcFzCvDFtBCO/qjc/pO7pG/4s0oEM/Y17/xA8V04Fegc0glRg0MJnZwRxP60qz33Wuek2xca+MJHKo5LlyYe94Hf2KRFtbiX//RRmAY4qpAI+BWxcGR37Uy+jEJ/QNaZ2tM5gK5CWWkpm2Ly+5h9Ke7WJfZdOSZOEtHI9Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-6519528f44fso37781677b3.1;
        Mon, 22 Jul 2024 00:55:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721634923; x=1722239723;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LbmEHONiIOsJnXV6cT/utXHZ8eRTc+tn637CN6hGkTg=;
        b=O4LeuhiYI8Nf5tEbhSlW+YDYkYhY2yOJCRGg/Omg3qDg3zIFtkC3hDOI2sro98veJQ
         izR1dAnxknNb0Ztds7SuSr9qlYxaeIWGpoPSqQaCYSZppMrdP/VDdlg8Ol08V9B037ig
         ZkpagmD25ZlWMyn/2YkmpThjBb7o5QdgJ0rEqKcUjU1mq9T7Dr5v/Bea0cigKyyt2rIV
         bRHIwxZqenmfGIW6dcJzku9n8Xe+P9F1eLfSaloxGgY5CUAurBFCY76H1Cfd4z3t9XtE
         ifYNaSbPjdznyJucVdbdOkxyratOVWDsWfujD52TD42QmyNVcHAfRfP8HpvfQ6PrOgIl
         I4pw==
X-Forwarded-Encrypted: i=1; AJvYcCVT0sEv7tf/AvxLkIeUsbSgV3uwEDOUR6fy1ksbv6iyje2vkwgACocML2YFYK5R2z8CLqiHlgLKQ2AETb3w8Yf7hPohKOgIMuHp0Lt6bXgzK752Q0ll37q3WBEAYolE6QkG
X-Gm-Message-State: AOJu0YzBfJ0cM/+Pm/yFkl+SGjsLkB8lio/mGJTSyy0GB5g9e2aTPIhk
	zBtsdVf6kExAzOfEWlvGIDka2Bx+NXzwFpgaQshaC4YQU7BhyqlDScVZnrZr
X-Google-Smtp-Source: AGHT+IFMy/1NnuQYOnebFEbm8fja/IH1+D4IzHQq5yyejx9BwaaJxhilImZRklgIdEWn8Q8dloupeg==
X-Received: by 2002:a05:690c:6084:b0:64b:6f7f:bc29 with SMTP id 00721157ae682-66a688a5872mr88425047b3.16.1721634923345;
        Mon, 22 Jul 2024 00:55:23 -0700 (PDT)
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com. [209.85.128.179])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-66951f728bdsm15609107b3.23.2024.07.22.00.55.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jul 2024 00:55:21 -0700 (PDT)
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-6694b50a937so29589007b3.0;
        Mon, 22 Jul 2024 00:55:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUKmf0KDbo4b1/QGT/gwrlytSVxxXJBAVskz15Gfye8+SB9HCOG1S5Zi0IWkhOdJhq4olZU7Zf4ZMDl567vqKV0QwGCjxvFfGN7r23m9SkEu2pQO9Pung/NHqp8kaNXEnLL
X-Received: by 2002:a05:690c:6604:b0:646:5f0b:e54 with SMTP id
 00721157ae682-66a682cbfa1mr105939367b3.8.1721634921356; Mon, 22 Jul 2024
 00:55:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com> <20240712-asi-rfc-24-v1-2-144b319a40d8@google.com>
In-Reply-To: <20240712-asi-rfc-24-v1-2-144b319a40d8@google.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 22 Jul 2024 09:55:09 +0200
X-Gmail-Original-Message-ID: <CAMuHMdX+2SUdvJ7xoJtxtKRi_QkCc-tcL138A2PQffqPH3h5yw@mail.gmail.com>
Message-ID: <CAMuHMdX+2SUdvJ7xoJtxtKRi_QkCc-tcL138A2PQffqPH3h5yw@mail.gmail.com>
Subject: Re: [PATCH 02/26] x86: Create CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
To: Brendan Jackman <jackmanb@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexandre Chartre <alexandre.chartre@oracle.com>, Liran Alon <liran.alon@oracle.com>, 
	Jan Setje-Eilers <jan.setjeeilers@oracle.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, 
	Lorenzo Stoakes <lstoakes@gmail.com>, David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Michal Hocko <mhocko@kernel.org>, Khalid Aziz <khalid.aziz@oracle.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Valentin Schneider <vschneid@redhat.com>, Paul Turner <pjt@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Junaid Shahid <junaids@google.com>, Ofir Weisse <oweisse@google.com>, 
	Yosry Ahmed <yosryahmed@google.com>, Patrick Bellasi <derkling@google.com>, 
	KP Singh <kpsingh@google.com>, Alexandra Sandulescu <aesa@google.com>, 
	Matteo Rizzo <matteorizzo@google.com>, Jann Horn <jannh@google.com>, x86@kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Brendan,

On Fri, Jul 12, 2024 at 7:01=E2=80=AFPM Brendan Jackman <jackmanb@google.co=
m> wrote:
> Currently a nop config. Keeping as a separate commit for easy review of
> the boring bits. Later commits will use and enable this new config.
>
> This config is only added for non-UML x86_64 as other architectures do
> not yet have pending implementations. It also has somewhat artificial
> dependencies on !PARAVIRT and !KASAN which are explained in the Kconfig
> file.
>
> Co-developed-by: Junaid Shahid <junaids@google.com>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Thanks for your patch!

> --- a/arch/csky/include/asm/Kbuild
> +++ b/arch/csky/include/asm/Kbuild
> @@ -10,3 +10,4 @@ generic-y +=3D qspinlock.h
>  generic-y +=3D parport.h
>  generic-y +=3D user.h
>  generic-y +=3D vmlinux.lds.h
> +generic-y +=3D asi.h
> \ No newline at end of file

Oops...

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds

