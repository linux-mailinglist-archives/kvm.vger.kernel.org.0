Return-Path: <kvm+bounces-1939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EFDE17EEDEA
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 09:54:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9C0541F261E0
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 08:54:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3039AD50F;
	Fri, 17 Nov 2023 08:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E3anzLOX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D9B9D68;
	Fri, 17 Nov 2023 00:54:35 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id 98e67ed59e1d1-28398d6c9f3so404582a91.0;
        Fri, 17 Nov 2023 00:54:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700211275; x=1700816075; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DvDuSF1H8xZtYo/FFdoMBT6Yb7qFROSx7X15RtrWD0o=;
        b=E3anzLOX3u4CzpZN6OfXwbcGTcX6Trrx3lstia2F6IXkzl24gnQe9mGmvROgdiKuB6
         gSMMj22Ll0ybUoPrvXURmBkqQlDd6fEa8gYtmMGaMTD84AeYyBTUQYejfE52dFFwo8f/
         IDsDbmebETHdNN1VbbaxtLHdvGKMkS954zV/i7pZLCsvy/5vZM6SWgOYYuS9bOYEgFds
         M/AV24fenEdK36xn8j8r/d1vks/vvbq2AmN6zJj2GlunoODh5sPAn0cys78jyNEN/0dl
         J0UFB736VvCYIdrXGJtUxCFykjjdr3j6W3gVU0rWW+r2lg66DC5kE9kU2VXIRH6Gh+UD
         3tJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700211275; x=1700816075;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DvDuSF1H8xZtYo/FFdoMBT6Yb7qFROSx7X15RtrWD0o=;
        b=qS2TCdjmJm9JBnTLdTe9TIvKQcXk7NPKH9Md06BTzDrUb2X01VHBMMhY9C3DXFGWWK
         PQZumua9COxwt2sw5FIe3cTpe2g5lj2InDE0Xp3TlAYt3ZR8is4XNW52YfrHZsj/zQdq
         JZp546HQpOrr5Dpytr/DhyUxSH4Vzo08VNL5huzXZMbLcWDmeg52lBvF2BoyweRjRgcd
         uLNr7Rov3sR1RsvTdvO9n7ZkwYQT9SOgNTur2nzGUyhRhvZ/3GYBxfnvLIDhPRoI0TG0
         rrwXtCQ1csjeKARb0u7gwdlkiesirLo0t280prDWve3Bj9RpmmYW7Jx0Bf6M7r/660ZQ
         p1zw==
X-Gm-Message-State: AOJu0YxgPtLirMFaBdvejnbOxDGMtYwrCKD9wxjnjpAnMEjPmzbhXnIB
	TBIV4hbxjsdcs4mZ0sge3B6vT3x7ZizApV1akHU=
X-Google-Smtp-Source: AGHT+IGZkeY9JpRXzUxqS+r7e+83Il9eK6QHRQNw6bLNB+IwqFM8fII8MIkkQSTppU0RF54P4afXbXweBod8Rnzi3cU=
X-Received: by 2002:a17:90b:4d89:b0:280:c0:9d3f with SMTP id
 oj9-20020a17090b4d8900b0028000c09d3fmr20935210pjb.34.1700211274979; Fri, 17
 Nov 2023 00:54:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231107202002.667900-1-aghulati@google.com> <20231107202002.667900-10-aghulati@google.com>
In-Reply-To: <20231107202002.667900-10-aghulati@google.com>
From: Lai Jiangshan <jiangshanlai@gmail.com>
Date: Fri, 17 Nov 2023 16:54:23 +0800
Message-ID: <CAJhGHyAiYxyiC+oepgqHofBpKVXLyqOUS=PjXppesx4AS3++-w@mail.gmail.com>
Subject: Re: [RFC PATCH 09/14] KVM: x86: Move shared KVM state into VAC
To: Anish Ghulati <aghulati@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, hpa@zytor.com, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, peterz@infradead.org, paulmck@kernel.org, 
	Mark Rutland <mark.rutland@arm.com>, Venkatesh Srinivas <venkateshs@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 8, 2023 at 4:21=E2=80=AFAM Anish Ghulati <aghulati@google.com> =
wrote:
>
> From: Venkatesh Srinivas <venkateshs@chromium.org>
>
> Move kcpu_kick_mask and vm_running_vcpu* from arch neutral KVM code into
> VAC.

Hello, Venkatesh, Anish

IMO, the allocation code for cpu_kick_mask has to be moved too.

Thanks

Lai

