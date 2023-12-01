Return-Path: <kvm+bounces-3181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C255A8017C5
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 00:30:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F1E5C1C20EBF
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 23:30:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BCBB3F8F7;
	Fri,  1 Dec 2023 23:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V9lJelFV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4031B3
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 15:30:41 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5d10f5bf5d9so45059507b3.3
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 15:30:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701473441; x=1702078241; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pFtKRJPt7zxEv0tffHLPtKUpr/5KbMlnf6dTP8uAgt0=;
        b=V9lJelFVfAuMQvXoED5BRlK0yRV7Q6YtuMUejP5T5kSVcloGibl/w6DnhFyiAqkJJU
         CBPlK8ygcuRKI2ASo2D3ctXvp3PuYvmBLO4ijkqb3rIMY00mE2hMD0RJhE7v39+7UtoB
         pnmHVCtFhzB1mXCMjy+JslGJOXf2K8F9TDq/4UrEutHtLEKjs/q2e7xtzqrlwKoHm4O0
         uQ8bCkPl2RKbVL7NDPXrEO+LYcq1y+/yM2rsIJENQw7h0fB92LBvK7rDkrM4O2Pk1JFe
         qkRbvOmeB0Sc1ai2TYkH5ELdEm20fcH8m/OsjvB4xsyMTRjezEuDc5Z/U6oSfnE3uzXY
         9Fvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701473441; x=1702078241;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pFtKRJPt7zxEv0tffHLPtKUpr/5KbMlnf6dTP8uAgt0=;
        b=it4D3lXAZv4FiFdXrJHFdKYrmsNRygChRTiGr0h4Lhw8Oo8oivWWyF7x2rnC3vi5kR
         jA8IwwZzVdaq5ClBKW71+irPrOurPeqeV4WgMb8eNr10was7FdZe0sy5+S1pLUdYCo/8
         thqedjKH86FCBjWCY9xVQcYsKKOor2KjIEhnXw3ZZuOov1DL2gp+6RId243pnICTvfRU
         /VMvh7gVGuAvEfyzmcn5mISzYb5IRLpEAsKvGu09b2sTnMVw6FqApj90XVG6NsubheXK
         jaJcmqkwQ23yzxwqKiHvOaB95aukU7/iHztyXXdECbbszL+DPhZ/se/ssuEfQ7pCbeL0
         9+RQ==
X-Gm-Message-State: AOJu0YxNdlwcg2SgmRqklMdNClsGoGzpLS0FiyHpvQLM4EVDHT2Z/kcX
	Nvy9yXwvznJkHUv39gWzmnnBu0Hd4UQ=
X-Google-Smtp-Source: AGHT+IFB9y2kEWO8Kpe0q9euDjDBWyWXgxQFrXBuoZzF9XdZUaidnZVS7jJDK5kMO6grQ22oMvcjhXzqCVk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d40f:0:b0:59b:e684:3c7a with SMTP id
 w15-20020a0dd40f000000b0059be6843c7amr886798ywd.4.1701473441225; Fri, 01 Dec
 2023 15:30:41 -0800 (PST)
Date: Fri,  1 Dec 2023 15:30:33 -0800
In-Reply-To: <20231007064019.17472-1-likexu@tencent.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231007064019.17472-1-likexu@tencent.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <170144728224.840084.5797440525158883360.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86/xsave: Remove 'return void' expression for 'void function'
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Like Xu <like.xu.linux@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Sat, 07 Oct 2023 14:40:19 +0800, Like Xu wrote:
> The requested info will be stored in 'guest_xsave->region' referenced by
> the incoming pointer "struct kvm_xsave *guest_xsave", thus there is no need
> to explicitly use return void expression for a void function "static void
> kvm_vcpu_ioctl_x86_get_xsave(...)". The issue is caught with [-Wpedantic].
> 
> 

Applied to kvm-x86 fixes, thanks!

[1/1] KVM: x86/xsave: Remove 'return void' expression for 'void function'
      https://github.com/kvm-x86/linux/commit/ef8d89033c3f

--
https://github.com/kvm-x86/linux/tree/next

