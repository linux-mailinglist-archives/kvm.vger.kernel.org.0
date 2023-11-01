Return-Path: <kvm+bounces-309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C1AE77DE120
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 13:52:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 82AE8280F9F
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 12:52:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A572B12B8F;
	Wed,  1 Nov 2023 12:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sLch8VwW"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DAD610974
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 12:52:00 +0000 (UTC)
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B08EFC
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 05:51:59 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-54357417e81so12967a12.0
        for <kvm@vger.kernel.org>; Wed, 01 Nov 2023 05:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698843117; x=1699447917; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y5Xp3E2sNGurYgFgV4DFltI61gPnCGK2ee6FfBRryFI=;
        b=sLch8VwWZ1zSWfBadZ8y7Hj0W93EptAw+uscEv3zuRfnDoneD/GWEIwccnaJtKnxpf
         vFsn8hIS1x2CMwzQzmSDZZnmop/xOmlII+340ZCPhU/1KoclJPJ+CSMrAXE7p6DhurSt
         md6ZiVmounouybPxqU7CeYRNyM0gRKUmtx8+He/5rHhv6f27izWempfoQ0l//9da2DfF
         gHn1Wo/Xzo8J4mCy5MTm6SjY5owjbQZkJ3tVfBKY6iY010ECa+zX1NpOfb3opKfrOyE3
         U47zzgT4vNH4SseHHP85nne4/JEdnvFd2zloEHFvYnlhszAr7KFSqK7P1no+9JnoNNz7
         5Scg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698843117; x=1699447917;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y5Xp3E2sNGurYgFgV4DFltI61gPnCGK2ee6FfBRryFI=;
        b=cN/Ht16iUkqaCzvm3Ojv+wNRQMauXR5LG2C8UH7dZj4izG0sVGFIskqpCm5OrC94oT
         xplyxuK3HIUeNxx/dgIgdbxnLI6hSyGGFtVhPSsaSfrFOqq0Ba+635/gtn7QVZTruDq0
         qeVAgaNpDrupfDJKAXzv7/QBDrzvsSv/ZhVSHGtrPIYwEnFl5ZdiC47dYkVTaEhhwyxb
         gJZ9smTTKApLLlW2YFJcB2gt1Pk24AlUApAZY6xkD4INrBtf3dbQ6HBY/4eHlXzpBoHM
         yVVgiNKsLMpUiqNPbzdUVvsGDB2PVQlLFm7u0uc3IBPeArVbBuMtIVfD3wXTn9C98iH+
         siig==
X-Gm-Message-State: AOJu0YwYKFAnzJR9pBnVLQ1fthg81YCr6lfkc4Bgb2zkefNg9yBSBz8H
	Pvi9s6Clj6R+PSqderjx07xLTWmS+d11f9tIuPvvuw==
X-Google-Smtp-Source: AGHT+IFkCTEbSFkG7scGgC6TPzXxes69hSs6N5IfbBplDhafMoz8fYHl4lzT4ijrjOXjRvVuuGWhG1FmH8yvUfSka2I=
X-Received: by 2002:a05:6402:17da:b0:543:72e1:7f7 with SMTP id
 s26-20020a05640217da00b0054372e107f7mr210251edy.1.1698843117362; Wed, 01 Nov
 2023 05:51:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231031092921.2885109-1-dapeng1.mi@linux.intel.com> <20231031092921.2885109-2-dapeng1.mi@linux.intel.com>
In-Reply-To: <20231031092921.2885109-2-dapeng1.mi@linux.intel.com>
From: Jim Mattson <jmattson@google.com>
Date: Wed, 1 Nov 2023 05:51:41 -0700
Message-ID: <CALMp9eTB-uPOnUchFsX=-JDz3Pu-OjdSksOEVQvz3htNazDhvQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests Patch v2 1/5] x86: pmu: Remove duplicate code in pmu_init()
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Zhang Xiong <xiong.y.zhang@intel.com>, Mingwei Zhang <mizhang@google.com>, 
	Like Xu <like.xu.linux@gmail.com>, Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 31, 2023 at 2:21=E2=80=AFAM Dapeng Mi <dapeng1.mi@linux.intel.c=
om> wrote:
>
> From: Xiong Zhang <xiong.y.zhang@intel.com>
>
> There are totally same code in pmu_init() helper, remove the duplicate
> code.
>
> Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>

