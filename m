Return-Path: <kvm+bounces-1096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC4317E4DB5
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 01:05:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 98D48B20FC2
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 00:05:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBF17632;
	Wed,  8 Nov 2023 00:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uXmePdHO"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61827361
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 00:05:12 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C959110E4
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 16:05:11 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a90d6ab944so85000467b3.2
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 16:05:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699401911; x=1700006711; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zYsgmIOOmS8Ma/lVvfgZhN61BA2GcEA9M3I5G60SSFY=;
        b=uXmePdHO+Eprc97CN6/rv8cXO2mIf48V05qGz9mTgiNZk3qjlwDvT7YtT/CwcGVk6o
         +ndPdYij6BxrjeyhfTXIQMn6kOMhjTN+RNH4L7GuyQ4p4uVI3tW6U2gBFD9BacmPufO9
         WhUfUCvMI9riI9+1xlMIc7Oomrng8PmbU6rziunNrmCSepUa4bTnSP0kld1VPH031ic0
         icdcnUZmiBCHq7T8JkshdQHHDJDl0AclZoNXr6q6HSHiS/TWDi0ArKiwYdyBzUW4bH7D
         bhHXfWkhGQGYQ+MoXu73s0fVaRw3d2/BIOxCtbX6cnyVmZe3jd1BDGMH+IL+ykuicORB
         3hZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699401911; x=1700006711;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zYsgmIOOmS8Ma/lVvfgZhN61BA2GcEA9M3I5G60SSFY=;
        b=ehw4gnf/14kzlp+9hbAmYg/rHkiEtZy/GtY/1vaReF2+MAH1xkZDrun6rPfeFQXdDh
         0svoRi6CUSHfSCAcgGgvL5igveOy7Mr8RY9Hl3LdXnUrRM90WhCGS8Ami2hkplbO7GjK
         ftb+FHsvqX7KC5L5JQIFCUvb2jNwfDsTs+fd0fcu5dOOf/0YY5IamgfaC0U+7lmnLG9B
         K1oIM40Oem90LgNJB7qC9ihiyKXhevDPvyEz1H0tkkpSUtWfas2EpAlYy6TbfX0VppMz
         oYUKmbpoXPzfQQ4pBzOFK9q2CSpkYQNZbSyxWHK19DMWCvMabuHH+mxJJAiAjp+k8oIG
         EfVA==
X-Gm-Message-State: AOJu0Yw0eBKsn1I/i16DWLmafsBcfAZJtRU0vdBW2ZgH/wtSBUIHRmhP
	mL0ziMBbmPiemo6U+XWiM2VQagL78FY=
X-Google-Smtp-Source: AGHT+IGCsaj5BdD/HjQaFWevRyE7PWDH4FGp1LfNm48t2sbSpI+cNzZRgvKQCW2VV0e1r4Tkn1E4IRa2xyE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:cc05:0:b0:5a8:5653:3323 with SMTP id
 o5-20020a0dcc05000000b005a856533323mr3956ywd.2.1699401911025; Tue, 07 Nov
 2023 16:05:11 -0800 (PST)
Date: Tue, 7 Nov 2023 16:05:09 -0800
In-Reply-To: <20231027172640.2335197-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231027172640.2335197-1-dmatlack@google.com>
Message-ID: <ZUrQtbjLNOxsqpzf@google.com>
Subject: Re: [PATCH 0/3] KVM: Performance and correctness fixes for CLEAR_DIRTY_LOG
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Oct 27, 2023, David Matlack wrote:
> This series reduces the impact of CLEAR_DIRTY_LOG on guest performance
> (Patch 3) and fixes 2 minor bugs found along the way (Patches 1 and 2).
> David Matlack (3):
>   KVM: x86/mmu: Fix off-by-1 when splitting huge pages during CLEAR
>   KVM: x86/mmu: Check for leaf SPTE when clearing dirty bit in the TDP
>     MMU
>   KVM: Aggressively drop and reacquire mmu_lock during CLEAR_DIRTY_LOG

Is there an actual dependency between 1-2 and 3?  AFAICT, no?  I ask because I
can take the first two as soon as -rc1 is out, but the generic change definitely
needs testing and acks from other architectures.

