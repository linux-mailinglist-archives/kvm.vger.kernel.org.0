Return-Path: <kvm+bounces-1097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F26DF7E4DF1
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 01:24:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5A2628131F
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 00:24:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF1AF384;
	Wed,  8 Nov 2023 00:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R8Wlmxn9"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3497B190
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 00:24:13 +0000 (UTC)
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29EF810EB
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 16:24:13 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-507c5249d55so8313994e87.3
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 16:24:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699403051; x=1700007851; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fZH/Xm0AkX3FKtLE7MZHfOJ6vC7v59VXswR1EJRh/dw=;
        b=R8Wlmxn9OlBPm2CBqxEpmq6MnK0NduqMmp/Izk+UJFpQ6zDpha+SUg5BUKPKf8cvJo
         bKKJADxq9bcapgwcKis9IonGI1CirPGL6XYR3X8KbrjgD4eVI15WRhvjr5pVS8DiVbRM
         Vb2GW1SoziKqpt9J/+82U8utlDAvlocvY/qw7kgrQfARvGKYmYd7fJDN5GWZOR81IhKR
         fcd9R3BCEFPcD0ko9F1fz3pAioPJjag179k68+BxQtI6y0isiozn006zc4yb+P9hVPBS
         A82yhb0JVcMRbJD0fKGhoLCKgYm9t1ycWYr+M9N5e4X2vcmkHdqfMEnNW2uEQrfYqMHn
         FF2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699403051; x=1700007851;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fZH/Xm0AkX3FKtLE7MZHfOJ6vC7v59VXswR1EJRh/dw=;
        b=JOkve3gGycBcMMMIc3SKIX008YaaEZKNht6zbmIZCbkTpPodmfSxtA4ehQWsfxx7x5
         Fkb4JDsALIJnt6Zvl7eEBJeAqqqBiJx7rFiSeC3CBaL44qF8aAcIO4Cih0p8MUdtSdPF
         0V7rzkwV1xL4+Oc9uLrYIyq/gIvbomw7rOBsJLtFkFPz0FECNEPFIRXheLYWQugejwa0
         JsmBftd1YA5mkKwEhemX5grWQDKz+N93PxnogFJQ1iXBobGmejdjVY+ZLDgBML4OkSHk
         wOQrgq3usWGro64q79YOxXf42NOWspAPJ+PMMS4XUHfG3h4Ct5XmC5DuVBZjxyzAhZK+
         7igw==
X-Gm-Message-State: AOJu0YzHmQLX+EZkDpwlHpGG797sllS2Q1qgaQ/pP3PevS8SPfb36C1C
	J2tpWEu6CgveP4ApnE8eprr2oSjyXUclvo/5PVFhYg==
X-Google-Smtp-Source: AGHT+IHEgyOBeg8i0quqASVyY/hBTNBq2nUCcXOqCweAFE/wASW1AsExAxQWfn6lJQNXt24W7Oqw1y3QPvveL3kHRls=
X-Received: by 2002:a05:6512:3590:b0:507:a04c:1bcf with SMTP id
 m16-20020a056512359000b00507a04c1bcfmr103420lfr.58.1699403051218; Tue, 07 Nov
 2023 16:24:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231027172640.2335197-1-dmatlack@google.com> <ZUrQtbjLNOxsqpzf@google.com>
In-Reply-To: <ZUrQtbjLNOxsqpzf@google.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 7 Nov 2023 16:23:41 -0800
Message-ID: <CALzav=dM3oEt-HH09kCKj0rOKakxMwiJFC2CmNcAK2XG1DJt+g@mail.gmail.com>
Subject: Re: [PATCH 0/3] KVM: Performance and correctness fixes for CLEAR_DIRTY_LOG
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 7, 2023 at 4:05=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Fri, Oct 27, 2023, David Matlack wrote:
> > This series reduces the impact of CLEAR_DIRTY_LOG on guest performance
> > (Patch 3) and fixes 2 minor bugs found along the way (Patches 1 and 2).
> > David Matlack (3):
> >   KVM: x86/mmu: Fix off-by-1 when splitting huge pages during CLEAR
> >   KVM: x86/mmu: Check for leaf SPTE when clearing dirty bit in the TDP
> >     MMU
> >   KVM: Aggressively drop and reacquire mmu_lock during CLEAR_DIRTY_LOG
>
> Is there an actual dependency between 1-2 and 3?  AFAICT, no?  I ask beca=
use I
> can take the first two as soon as -rc1 is out, but the generic change def=
initely
> needs testing and acks from other architectures.

No, there isn't any dependency between any of the commits. Feel free
to grab 1-2 independent of 3.

