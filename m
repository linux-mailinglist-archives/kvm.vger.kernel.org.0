Return-Path: <kvm+bounces-1238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD4D17E5D10
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 19:20:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60F72281651
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 18:20:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C64F336B06;
	Wed,  8 Nov 2023 18:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uidFvFLQ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F50358AF
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 18:19:56 +0000 (UTC)
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B43AD1FF9
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 10:19:55 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-54357417e81so988a12.0
        for <kvm@vger.kernel.org>; Wed, 08 Nov 2023 10:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699467594; x=1700072394; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lPzDJOHXaMQ7hDr4fQaud0AOapaYXuR24Rsqmx39kT4=;
        b=uidFvFLQKH6OQ+EuPzqiej4boBUNsl2clO/meRsB93hUfbpqTXkLPf3FjPx3FoWbpQ
         HylpPoRgBKzhjL9TF1QKNpD3q8cYuahE/2S/7OLexwPuGuMks1mJEZlcOiAaeqfpXTKc
         JEljQO4zn3svcbWtV/y4GjmW6i7fiorUUyS4eYqVHbeGjBeCDxDquxoYIMjCxlmnp6ol
         jXMq1asrezkCwEfMIDUWRdpf3v5iiQkyHlueDWN3f65NnD84DUHi1guTYV4IhHpvOhQ2
         J9IqyBdUOZC5iZbs5MH+7UTLgGe9g0AfIiaCbUEijU+oajsCAWjuQvuso3Z4rvXaS/CZ
         4PUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699467594; x=1700072394;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lPzDJOHXaMQ7hDr4fQaud0AOapaYXuR24Rsqmx39kT4=;
        b=STP2M0j3DDWndk087od5qmo7zhVG3NgA4WrXZfNtXGHgk/Vu5FDIUHBPiVdiS6nxQP
         C47xZHaqufas1KPD3Pe3J0Q3WgUjvNKV13o4RAtbLN5I8ZBT7G61tjrU5+/EWEjranWh
         3pVX/aylqkzQhAzLKfJT/OrFFEU0X3f6ykzLSkMccpmwEYng6a69rBxiPsFHnOlzhSpK
         91H11BVvPWjFXCDg6NsbMut5XGb7NguJxjMTeiVoi5WXMwDJsRIChytueq96Fgso6y3E
         M43GWiK5wMPdV/I6r02W1CvPU5Zn6aES8z7TOTdsCAd28nnHyzyztpf2yuODgYl/gJ4Q
         yYQw==
X-Gm-Message-State: AOJu0Yy2Wd5UqS4ZtIaNzVgZFGa8sMC2gebHPyMIeiRZqgwwmD5k9p0k
	oII5rRF+fZSxrK5KmZojCKPSuz+tXdut17TzY7fYYQ==
X-Google-Smtp-Source: AGHT+IHSTdnHpU+tkokUoN2IxJr6aTuVShMIUkzmKD2yI2R4C/2lgCPoCvm1H+r3Y/W0c7msPJZNhRs4cza7jp5Alq8=
X-Received: by 2002:aa7:d34a:0:b0:543:fb17:1a8 with SMTP id
 m10-20020aa7d34a000000b00543fb1701a8mr11251edr.3.1699467594084; Wed, 08 Nov
 2023 10:19:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231108111806.92604-1-nsaenz@amazon.com> <20231108111806.92604-30-nsaenz@amazon.com>
 <ZUvDZUbUR4s_9VNG@google.com> <c867cd1f-9060-4db9-8a00-4b513f32c2b7@amazon.com>
In-Reply-To: <c867cd1f-9060-4db9-8a00-4b513f32c2b7@amazon.com>
From: Jim Mattson <jmattson@google.com>
Date: Wed, 8 Nov 2023 10:19:39 -0800
Message-ID: <CALMp9eTmAR_yMMxujiMDQ6_VpUF3ghoKAdy_SYvu-QOAThntZA@mail.gmail.com>
Subject: Re: [RFC 29/33] KVM: VMX: Save instruction length on EPT violation
To: Alexander Graf <graf@amazon.com>
Cc: Sean Christopherson <seanjc@google.com>, Nicolas Saenz Julienne <nsaenz@amazon.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	pbonzini@redhat.com, vkuznets@redhat.com, anelkz@amazon.com, 
	dwmw@amazon.co.uk, jgowans@amazon.com, corbert@lwn.net, kys@microsoft.com, 
	haiyangz@microsoft.com, decui@microsoft.com, x86@kernel.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 8, 2023 at 9:27=E2=80=AFAM Alexander Graf <graf@amazon.com> wro=
te:

> My point with the comment on this patch was "Don't break AMD (or ancient
> VMX without instruction length decoding [Does that exist? I know SVM has
> old CPUs that don't do it]) please".

VM-exit instruction length is not defined for all VM-exit reasons (EPT
misconfiguration is one that is notably absent), but the field has
been there since Prescott.

