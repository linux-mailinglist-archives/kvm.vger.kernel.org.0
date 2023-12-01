Return-Path: <kvm+bounces-3154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63139801222
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 19:00:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D90DBB20FB8
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 18:00:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43D014EB34;
	Fri,  1 Dec 2023 18:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TVQXaR6y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3508AD3
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 10:00:17 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5caf86963ecso35396487b3.3
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 10:00:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701453616; x=1702058416; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9ZePHCPhQX116CwaY2xHtQ1mXfBf5n235ILerCpw56I=;
        b=TVQXaR6y1vkHv4rxOwi3Yl/aNqxczuKKI2MAq6DRo3s+hczBLe/k4/AlbDm8Pbpxy9
         pbvwxuBp6yEZVznVsSacuFT81yfg7A8EGj6CkX8RVSIOsv2USjLnSd5wvNODmPwPLiPw
         teSQHnh8d2fV68/3lkkccyqWUswyBoCMXtXTPM+QJv523ZxYeLqNzHhk39MdkEma6KCH
         wNqWZ2mBLl1akvRqwy5ePdwxgHFZl8CZqVvnkAuRopWM3Ys+pNZwaSSr9o6rnesbjal0
         xi0KOyXsf0t9m471HkGaNeySQBSy2JHjzq5MIGZEozBqvAWE0xF/OybQ1scznC6vIK8L
         hEGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701453616; x=1702058416;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9ZePHCPhQX116CwaY2xHtQ1mXfBf5n235ILerCpw56I=;
        b=PKEgYizcE5FL3Xa/6QfJVBgkbr/C3B9uduA548zfR0AqisP5BPJ2xRNKDg3TFU+yij
         tih0wBs9Z4ZMGu5GZ7wBSD5q471Ok5VJy/WqeW0B+ROXNogRI8KZ1jOSsrwArfSx47h5
         I3VlTx7sPLR2pUreXq2CEnqR+IaIR0RqXEBi+YxirUnfNFCAWjfvsJNfACb2KaDp5Bu8
         8/heVEPO9odnPdNjWQGAbtGyT5EKdHnC72oJcuTUAd8IprVyQ63LfWGsyxgxMYA2orF+
         osiMjpncZDBEZZnIESjlWeqIvb//D5JJ3TuSCaE2JLyOmHYnCjYp+0B4oNKhPnrIVmD5
         AOqw==
X-Gm-Message-State: AOJu0Yxubotuz588/+/GjPCmtyVpR13W8BimZXQIEh5kZJvyR67TMbny
	lMrJdDGkcAHMRs0yWQhsZK2PofYEtlo=
X-Google-Smtp-Source: AGHT+IGEqFlEwP+HZKqTte45sG22B1+iMD3htkL6ZTCifMNazXp9qt+yTk3JueDnJKYrdFy/ixPq190uVa4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2849:b0:5d4:1b2d:f43f with SMTP id
 ed9-20020a05690c284900b005d41b2df43fmr96271ywb.6.1701453616433; Fri, 01 Dec
 2023 10:00:16 -0800 (PST)
Date: Fri, 1 Dec 2023 10:00:14 -0800
In-Reply-To: <20231110003734.1014084-5-jackyli@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110003734.1014084-1-jackyli@google.com> <20231110003734.1014084-5-jackyli@google.com>
Message-ID: <ZWofLnuB7_BcTxDK@google.com>
Subject: Re: [RFC PATCH 4/4] KVM: SEV: Use a bitmap module param to decide
 whether a cache flush is needed during the guest memory reclaim
From: Sean Christopherson <seanjc@google.com>
To: Jacky Li <jackyli@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Ovidiu Panait <ovidiu.panait@windriver.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Ashish Kalra <Ashish.Kalra@amd.com>, 
	David Rientjes <rientjes@google.com>, David Kaplan <david.kaplan@amd.com>, 
	Peter Gonda <pgonda@google.com>, Mingwei Zhang <mizhang@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 10, 2023, Jacky Li wrote:
> Use a bitmap to provide the flexibility on deciding whether the flush is
> needed for a specific mmu notifier event. The cache flush during memory
> reclamation was originally introduced to address the cache incoherency
> issues in some SME_COHERENT platforms. User may configure the bitmap
> depending on the hardware (e.g. No flush needed when SME_COHERENT can
> extend to DMA devices) or userspace VMM (e.g. No flush needed when VMM
> ensures guest memory is properly unpinned).

Absolutely not.  KVM and the kernel must know when a flush is needed and when it
is not.  The various errata around cache line aliasing is far too messy to punt
to userspace.  Not to mention this bleeds kernel internals to userspace and thus
risks unintentionally creating an ABI.

