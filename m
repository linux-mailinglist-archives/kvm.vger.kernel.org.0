Return-Path: <kvm+bounces-1489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AF517E7D32
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 15:57:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E72DA28116D
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 14:57:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 200851C694;
	Fri, 10 Nov 2023 14:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dOSmT828"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32EA1C28A
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 14:57:00 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F8B73A208
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 06:56:59 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a7aa161b2fso29216267b3.2
        for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 06:56:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699628219; x=1700233019; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=F1V/300+xWnAnwKdMsbjGUliUN30rs1/xBn5NBDIxfI=;
        b=dOSmT82877Rp1xmkoDaltiaoVgfV1JBFKfR3Eazpe3jGvGKNM96J+PViP74iIk62bU
         3HxZIHHcwnhsfVyY9yUrYz65+uLzSBblO6zNFrMt1Rh58haC6Oqs/tlMBh3oqFF7gahk
         HwUBdVbwzP33OB0J78BkAqL2wSs7dYFR79caMaxLYmXvH7xv2t3gloSY+QuV/Vb6cKxx
         kY0Boc74vaAR1N74n2QWblXDkY0jMHdrRWmwKM9b27kY49Cl0rTmEYcKwwdzRC1e/76W
         NZ4PnOSr77vF1sCG/x3vTozhizfKXPz/OjcSrj5lr2JEMcjvB6poqYWHFDC6oupm2+O2
         AIuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699628219; x=1700233019;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F1V/300+xWnAnwKdMsbjGUliUN30rs1/xBn5NBDIxfI=;
        b=mtQ1BM5LV/yU+dvj3aGeJRpb7oX1ZvIR4k9A6C9q3r6+7yEqdEQfWhlLntQ/SOCeRa
         ntogTpN3sUNM79wjPY+O6jHZtGcH0FxLF01I7W51H8hDB5k8qSaj/esDxyS0ofuqpL/T
         pIn9Jcs7PPGnWIMmsixe5D8g1u6u5OE2fMYmNttlnprIy4ijCDvAQYtxai8q9r5M5ADh
         KHSNU55beLRFc3MEZWNlioSip2wWj6SXR264rxQVL8n6xgokUpdyQHLZfb0kGljftu2m
         QVMDQu/cwYmIvgTUFRHC29KBIxRzVmlcNB9BS/9N3kWXQKK/nJ4APK9cOtU3NwyW7y2x
         FxKg==
X-Gm-Message-State: AOJu0Yz+FPYWWGiJnMl2gAtExkitNXhfuZLVphMgYM9jgMjJNcYqS0GY
	55bcrzE8KaY/yh4ONobzPEFO71IG7pk=
X-Google-Smtp-Source: AGHT+IGQQ94Jip81SrrWdG7OjYYcza9XRu3pKVZNh6sGbJ1fShKRc5nNwka3brsZBy1qO94ybUhnFiOwTFo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:24c:b0:da3:ba0f:c84f with SMTP id
 k12-20020a056902024c00b00da3ba0fc84fmr216147ybs.4.1699628218895; Fri, 10 Nov
 2023 06:56:58 -0800 (PST)
Date: Fri, 10 Nov 2023 06:56:57 -0800
In-Reply-To: <6e101707-f652-73f8-5052-b4c6c351e308@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110022857.1273836-1-seanjc@google.com> <6e101707-f652-73f8-5052-b4c6c351e308@oracle.com>
Message-ID: <ZU5Euc29B_UjiUot@google.com>
Subject: Re: [PATCH 00/10] KVM: x86/pmu: Optimize triggering of emulated events
From: Sean Christopherson <seanjc@google.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Konstantin Khorenko <khorenko@virtuozzo.com>, Jim Mattson <jmattson@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 09, 2023, Dongli Zhang wrote:
> Hi Sean,
> 
> On 11/9/23 18:28, Sean Christopherson wrote:
> > 
> > base-commit: ef1883475d4a24d8eaebb84175ed46206a688103
> 
> May I have a silly question?
> 
> May I have the tree that the commit is the base? I do not find it in kvm-x86.
> 
> https://github.com/kvm-x86/linux/commit/ef1883475d4a24d8eaebb84175ed46206a688103

It's kvm-x86/next (which I failed to explicitly call out), plus two PMU series
as mentioned in the cover letter.

  https://lore.kernel.org/all/20231103230541.352265-1-seanjc@google.com
  https://lore.kernel.org/all/20231110021306.1269082-1-seanjc@google.com

