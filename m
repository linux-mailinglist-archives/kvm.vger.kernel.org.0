Return-Path: <kvm+bounces-260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B74F7DD94F
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 00:41:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 040AB2818F8
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 23:41:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F7C41D69C;
	Tue, 31 Oct 2023 23:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Adja7pE2"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B501DFC9
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 23:40:58 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AEB510C
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 16:40:56 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5b0c27d504fso3063627b3.1
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 16:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698795655; x=1699400455; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pAuUiRH/6IYineqwKVLSSqFiEk7BGaE+7e5FuTbpUqg=;
        b=Adja7pE2JWKvu5DGEoLgfRycuEAvfRAjg3W6cstyCXZzdV95NwXzsftW3wzxXdiSAO
         JN2Hvf125VWbKzbgzMGqbvz8rqjJ6ghZQa3PbdylZ7bGQ/nbRElkApvn/up07zvmf10K
         p/7dWIyGnappHvwCNkLa170F2wjNWlVNQQoWIiZrePOhNygndqsTvGW3LYcvNfrNEQRS
         T/72ICvl8Q9m28SVF+srWSLheJ0UbOTkDRwgdRYLEvG+wMYcY8LfKoRONvbhA1Xtx+U3
         W7T4xIqmd+xaZBuUT/yzxNTUO6J9Piq6BnVnO5dVt1fLUhl8YHWimZreBSkMb9W+WuBT
         7d4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698795655; x=1699400455;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pAuUiRH/6IYineqwKVLSSqFiEk7BGaE+7e5FuTbpUqg=;
        b=RLYe/PUrYUMbolw/h00iwkdIXnc2msghPNbnV6sBIt0y/B+BkdhAsg4gJOexGDiXLw
         AqpfuNe7UMbG+ccmNxpZ09cczbRJb+b4EOw701IEqAzs/VDFlKI5XPeQjnF/JDrcQaOm
         SCxiURwgJ5CnKgMuaQfOFi8RPjhgur/9EsMJyAug3CpgKJMBDs/z+AS+TKCv/mYf+umg
         32i6E/vWU3dCprvybSB1k0503ha3A3PFQFWhFM1mSpeIrkyaMKM6+caEZgA9bvHePODW
         4fh3mwDzF9kDQ8QGzrMyEvPT8pPGCv/9qITi9m7l+sfXc6ei5LOQ8JmFKNg8FrsBum9i
         w4uQ==
X-Gm-Message-State: AOJu0YzNCX28Vr5XZSMHuT42BL2thaHtNuSK9O0SQ3Z4a824CaAejud2
	V38a08cFkUKKsgyWTFUUCTred7Feayg=
X-Google-Smtp-Source: AGHT+IGLbwlANyjrrJ36/sGvijbFIoZawEfNxiVzXOWt+q7P+31wikkSTQv3XGE6y3vIzBujHun7BLsPkvI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:ecb:b0:5a7:b95c:a58f with SMTP id
 cs11-20020a05690c0ecb00b005a7b95ca58fmr34239ywb.1.1698795655480; Tue, 31 Oct
 2023 16:40:55 -0700 (PDT)
Date: Tue, 31 Oct 2023 16:40:53 -0700
In-Reply-To: <20231002095740.1472907-5-paul@xen.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231002095740.1472907-1-paul@xen.org> <20231002095740.1472907-5-paul@xen.org>
Message-ID: <ZUGQhfH3HE-y6_5C@google.com>
Subject: Re: [PATCH v7 04/11] KVM: pfncache: base offset check on khva rather
 than gpa
From: Sean Christopherson <seanjc@google.com>
To: Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	David Woodhouse <dwmw2@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 02, 2023, Paul Durrant wrote:
> From: Paul Durrant <pdurrant@amazon.com>
> 
> After a subsequent patch, the gpa may not always be set whereas khva will
> (as long as the cache valid flag is also set).

This holds true only because there are no users of KVM_GUEST_USES_PFN, and
because hva_to_pfn_retry() rather oddly adds the offset to a NULL khva.

I think it's time to admit using this to map PFNs into the guest is a bad idea
and rip out KVM_GUEST_USES_PFN before fully relying on khva.

https://lore.kernel.org/all/ZQiR8IpqOZrOpzHC@google.com

