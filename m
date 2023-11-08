Return-Path: <kvm+bounces-1267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A13987E5E62
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 20:11:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D200D1C20C93
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 19:11:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7962E36B1F;
	Wed,  8 Nov 2023 19:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aCbLCl9I"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7546536B0C
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 19:11:34 +0000 (UTC)
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732F72110
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 11:11:33 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-51e24210395so1737a12.0
        for <kvm@vger.kernel.org>; Wed, 08 Nov 2023 11:11:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699470692; x=1700075492; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IYVVEM5BaLTPikbfmS5FtqNhSFPaOYY2B62Q14yU+zo=;
        b=aCbLCl9ITxuprqPs8aKg4u7PijhE3sf3iBSYt8SIBB6SnZMRrCAoTQ8vyn0wtpT0Qn
         0Gte5R3ADrN4uqoXxMZyhAGA1ircbLhCwtOJbQWL01U1hungH4bEItIG0u7JY944utGC
         ZWd7XtuMbi9nbmpBc4X8ssRzXadAjWNRjC1EnDtYkXSo0Hwhe3OXDGrmFFK/cxWlvZQ7
         1bUdjvPJBEkF8uTQQ6Dg4zcGVF3NwPWiHFvZqgrRpLYa/YPHYG10QKipRv8bhuBZDLlQ
         GZBbGio6WaNLkrTu+biX4gAeUfIrbbCBqGluhYhyDKcJ3o8/edjgWyJXQEui0z2wEVsh
         K03Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699470692; x=1700075492;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IYVVEM5BaLTPikbfmS5FtqNhSFPaOYY2B62Q14yU+zo=;
        b=YrwP07IXYDVay0iJdi5P1rWGHtZzqGVsFSy5Ae5Ko0+WEHNf2nUtC+miMTHTIihXtU
         7iyzpjA0X8lwzd0DvF9dZaGAn0Q9MUitC25u4avYix+cHcOGmCMyTogFeK1w9PCGDaYS
         qbXu639Pqvc6hwbIYx2Ys0Yrg2SBPGkap0WpQoA6N2XJL+Fjqo4lH69AM2g4UrpSQvBy
         JRPkar9hB2A5iGUr6fYe3EynE2RBN4sykCgShfqr4Ny3RKIXCwRk5iSjLsqPV9axlEGy
         hAQG1e2G969wo6Bv/cX09zjvMjXWllGICjbFFKJcNtrNaF8qAdgqBQRfuQpnBE+226lt
         DruQ==
X-Gm-Message-State: AOJu0Yy68snHKHfX2Qe15az/DULBkb6E5HqlNfq+9pbght6mx3p5AQmH
	p774pNzGr/PlEunuk6VCmDSrJdHKtKNJLfhd1vSGuQ==
X-Google-Smtp-Source: AGHT+IF2nRIkMOOTvlH5caJpGlI6ZYnAbP33whKypeay5+v/AlbMl6E48A4pnbXb1m1FO0Bx72dMrAwzMDVSDF3YfqA=
X-Received: by 2002:a05:6402:1518:b0:544:f741:62f4 with SMTP id
 f24-20020a056402151800b00544f74162f4mr12905edw.0.1699470691832; Wed, 08 Nov
 2023 11:11:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231108003135.546002-1-seanjc@google.com> <20231108003135.546002-6-seanjc@google.com>
In-Reply-To: <20231108003135.546002-6-seanjc@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Wed, 8 Nov 2023 11:11:20 -0800
Message-ID: <CALMp9eRh7uzx3=_UdNaudHCBw4C3UWt983qJvKft=RmaomVT0w@mail.gmail.com>
Subject: Re: [PATCH v7 05/19] KVM: selftests: Add vcpu_set_cpuid_property() to
 set properties
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Aaron Lewis <aaronlewis@google.com>, 
	Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 7, 2023 at 4:31=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> From: Jinrong Liang <cloudliang@tencent.com>
>
> Add vcpu_set_cpuid_property() helper function for setting properties, and
> use it instead of open coding an equivalent for MAX_PHY_ADDR.  Future vPM=
U
> testcases will also need to stuff various CPUID properties.
>
> Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>

