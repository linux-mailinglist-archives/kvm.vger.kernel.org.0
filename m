Return-Path: <kvm+bounces-1384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37E437E7363
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 22:08:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A833280EBE
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 21:08:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6C43374DF;
	Thu,  9 Nov 2023 21:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D5iLtVn+"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4F337157
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 21:08:22 +0000 (UTC)
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC1FD54
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 13:08:21 -0800 (PST)
Received: by mail-oo1-xc35.google.com with SMTP id 006d021491bc7-586753b0ab0so717860eaf.0
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 13:08:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699564101; x=1700168901; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WwzUvezY0TT5a+4rjK2kfgmTX3xfdRUs3hXfF4JhRg8=;
        b=D5iLtVn+JQvR7ydGM3N25izbB56bYgzXFzr55R4TAVN45S++/ZbdL509ISmdvyQ026
         f1eFXeMI9wq9uxbJcZMShQo/W4X7sDg5OHaVueJxQe4W3b1NslKiIcVM+RSQeYu+qeMw
         ASfxNBfiFUwO/w9rDbCsBIZANjhLO12XfEtVGPpHh1tlNV86LZW/EJavamBuFhZZA3KJ
         1ERWJCNlXX7edeF8mh9L9u/hbvSEJqtOIzAoB4fFUIIPIhZej68gCnrMY9YExnMdDE9m
         tpfByM7CN8htBGedml3aipjcSZgcsOXWMo+/89SsKPMTONMrG90X0DyJIknJvnNaO7ab
         kaWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699564101; x=1700168901;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WwzUvezY0TT5a+4rjK2kfgmTX3xfdRUs3hXfF4JhRg8=;
        b=HCEGQnWOj1CU7kueLuCokv1ZtcMl/hTeEKF9+4aMpMWQjLnitsSK2ENc+nbZMkToPj
         30NpkCNxNgGuEM+UqhioGp3WVZ2kMOPPe3J0+kJHZHzeIFSyxtQTQekR9eLqbHvdOW4O
         gNtTvdMpaASNEeqoSgT3LN7N578stuPzWTyqPO4iUesThIMuiM6BZjo91zegO+Z8b5s4
         DnLN7qNSkrmlVOo/TLgS7+nQ7xOxKOMvvzhbNvzMMMGDpveNQep2ehMiFYboIgzsHBNQ
         oTckXY1DVlGVotcL18etc8FBhiIeYXmMjXaENT+Pmah51stbaIVI3nmR1UQSLrZiWKKi
         UcKw==
X-Gm-Message-State: AOJu0YxhvMpUsz8K1/xVqYjimuGFMXR4DZ6nvUEStBQfkAv+iuMv34e7
	25credwT07TlTOvkruMKpp6Vng1jPf+dr0i6mVpv8A==
X-Google-Smtp-Source: AGHT+IFAQMNWwb3nRd/a34yxC1D05fbG/9Rr4JjxxNKqar/u/WETqb6q0Ou2d8oD2pLa9W+efKiwGneqNA5DFdUuVyI=
X-Received: by 2002:a4a:c68d:0:b0:571:aceb:26c8 with SMTP id
 m13-20020a4ac68d000000b00571aceb26c8mr5973766ooq.3.1699564101067; Thu, 09 Nov
 2023 13:08:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-9-amoorthy@google.com>
In-Reply-To: <20231109210325.3806151-9-amoorthy@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Thu, 9 Nov 2023 13:07:45 -0800
Message-ID: <CAF7b7mqDN97OM7kgS--KsDygokUHd=wiZjYPVz3yk7UB0jF_6w@mail.gmail.com>
Subject: Re: [PATCH v6 08/14] KVM: arm64: Enable KVM_CAP_MEMORY_FAULT_INFO
To: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, dmatlack@google.com, 
	axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com, 
	isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 9, 2023 at 1:03=E2=80=AFPM Anish Moorthy <amoorthy@google.com> =
wrote:
>
> TODO: Changelog -- and possibly just merge into the "god" arm commit?

*Facepalm*

Well as you can tell, I wasn't sure if there was anything to actually
put in the long-form log. Lmk if you have suggestions

