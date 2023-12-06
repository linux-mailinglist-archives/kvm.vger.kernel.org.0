Return-Path: <kvm+bounces-3780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 65A9E807BA1
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 23:45:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1CB801F219D3
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 22:45:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF77C18E1E;
	Wed,  6 Dec 2023 22:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WFld93N9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB5AD59
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 14:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701902718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IZn1S9TK1RDCj7RxM/b8SSbDoPqt7weXZUABUV6sUMI=;
	b=WFld93N9K5z6wyBcqpg0qJN0WX7tCbgmv95pPON2ocdUeZCmLKIyic3EzoJ/koU9WBiP5O
	/fmadk46Xur/UbmfPq7m/FgTxG7vIr8An4ZM5TwZ+cVMJvoAjGw7o4ncczPY3q0T+plgcp
	NmN4/X68mYarkjpOR3zp4Jr8LGPmSl4=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-134-V1kdsov9NkOtxYoV3NXDxA-1; Wed, 06 Dec 2023 17:45:16 -0500
X-MC-Unique: V1kdsov9NkOtxYoV3NXDxA-1
Received: by mail-ua1-f70.google.com with SMTP id a1e0cc1a2514c-7c58cbb5a5bso15159241.3
        for <kvm@vger.kernel.org>; Wed, 06 Dec 2023 14:45:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701902716; x=1702507516;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IZn1S9TK1RDCj7RxM/b8SSbDoPqt7weXZUABUV6sUMI=;
        b=kgODehPg6KTBCrVarF6wMCa+81yHPeFf3NQg2YMGti8IAd0D8X08AkjucTzhhR2TdL
         L8Hkb44g1dGDJNqcxgoHYAIJWhaf/VoQXyoCL933oTs8As2pUOXULd+MQ9PuGgbALPiY
         cZQbPRvYYbyY8AMwpBwbkliOWX/rRh4fsdm7WY12BpmMa7iJPZNlN0H7ffIL7EKKP5tq
         Jq2PahqjkADaUiQKqs8OdCR3YeDZ3EP8TtglQmCo55rNhYAZJ61qyoHBuydwNgBHYOPP
         2+qIjfVgi6aiNa5SH34rHnnS4VF0Eb7a7a7hulDMFhyPqpyYgpfvR44g1rKtigtEBUe1
         apcg==
X-Gm-Message-State: AOJu0YzlRu9FuJX1zGunjqPr3pAN9FUMutnth7Wz/Qh7qJQAD/mmq92/
	cRp0ScgVE9Eai17B7fdan9sJx1XL4wI7IjbzxPuQbmpJdJ1bTl3trrC37rpwW3WkSOSH3iwN/v7
	P3RsQIht3CKtk81KWQ05XoW/JRwX1
X-Received: by 2002:a05:6102:6d1:b0:464:cac8:a03e with SMTP id m17-20020a05610206d100b00464cac8a03emr1957063vsg.1.1701902716167;
        Wed, 06 Dec 2023 14:45:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFyLxIvkPiRa2M7n8tSqh+BF6QFOiI3tq/gZRUueOYOXw7oyWK3kLWbW/nDqJ4G5XcLMXhDdWeJGlMU3YLuzyc=
X-Received: by 2002:a05:6102:6d1:b0:464:cac8:a03e with SMTP id
 m17-20020a05610206d100b00464cac8a03emr1957051vsg.1.1701902715890; Wed, 06 Dec
 2023 14:45:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c858817d3e3be246a1a2278e3b42d06284e615e5.1700766316.git.maciej.szmigiero@oracle.com>
 <ZWTQuRpwPkutHY-D@google.com> <9a8e3cb95f3e1a69092746668f9643a25723c522.camel@redhat.com>
 <b3aec42f-8aa7-4589-b984-a483a80e4a42@maciej.szmigiero.name>
 <CALMp9eQvLpYdq=2cYyOBERBh2G+xubo6Mb0crWO=dugpie4BRg@mail.gmail.com> <00fa768e-eceb-48c3-ae23-1966f110ec49@maciej.szmigiero.name>
In-Reply-To: <00fa768e-eceb-48c3-ae23-1966f110ec49@maciej.szmigiero.name>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 6 Dec 2023 23:45:02 +0100
Message-ID: <CABgObfb_hv=_ksOrDLRSKjFpkQtjWh4oYHxzvK6oH=_YLgTn0A@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Allow XSAVES on CPUs where host doesn't use it
 due to an errata
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: Jim Mattson <jmattson@google.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 1, 2023 at 5:05=E2=80=AFPM Maciej S. Szmigiero
<mail@maciej.szmigiero.name> wrote:
>
> On 1.12.2023 00:57, Jim Mattson wrote:
> > On Thu, Nov 30, 2023 at 2:00=E2=80=AFPM Maciej S. Szmigiero
> > <mail@maciej.szmigiero.name> wrote:
> >> I think that if particular guest would work on bare metal it should
> >> work on "-cpu host" too - no tinkering should be required for such
> >> basic functionality as being able to successfully finish booting.
> >
> > I disagree. Let's not focus on one particular erratum. If, for
> > whatever reason, the host kernel is booted with "noxsaves," I don't
> > think KVM should allow a guest to bypass that directive.
>
> This could be achieved by either adding special "noxsaves" flag
> or by setting X86_BUG_XSAVES_AVOID instead of clearing
> X86_FEATURE_XSAVES on these CPUs.
>
> Then the core kernel XSAVES code would check for lack of
> X86_BUG_XSAVES_AVOID (in addition to checking for
> presence of X86_FEATURE_XSAVES) while KVM would keep using
> only X86_FEATURE_XSAVES.

This is feasible, on the other hand the erratum is pretty bad. Since
the workaround is easy (just disable XSAVEC; and maybe XGETBV1 as
well?), you could just do a printk_ratelimited() on the write to
HV_X64_MSR_GUEST_OS_ID, in particular if:

1) guest CPUID has XSAVEC and SVM

2) host CPUID does not have XSAVES

3) guest OS id indicates Windows Server 10.x (which is 2016 to 2022),
which should be 0x0001040A00??????.

Paolo


