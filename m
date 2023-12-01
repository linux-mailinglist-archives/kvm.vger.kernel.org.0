Return-Path: <kvm+bounces-3137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A4DF800EE7
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 17:00:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3BF731C20C25
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 16:00:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77FD44BA8C;
	Fri,  1 Dec 2023 16:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oSGx4aw8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5BF310DB
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 08:00:18 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-5aaae6f46e1so749971a12.3
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 08:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701446418; x=1702051218; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=crvm5e2ydDZMUM2EHuPCr67zijP1BJbvH57wgKGfkc4=;
        b=oSGx4aw83nAs9hJ7rtA9uik28ECNKILlwli8YxyXg44Gos4yZUlmSRewsEo2KIoOl7
         VllN5OjiIZEGm8BxlQFs7sesFbX+J8HIlXFw40VnasiZf8Ki+46LO9jdR/+jEjq0WisP
         VyaH+7zw77LzV/UcIfUYciZ6dSASiWnN8BA4TibV7Y25uNvaCUiCIWi+cA95XqdgByZI
         5D00levSwADTFj6s/J6MD8GGVACl790CoziEz+Vwr7Pwj7mdpUDxo4COq7OAHXaCGPRk
         8R6NlD/kD+KMLkqBOIdTPYaaxFDFb9Zv08YWJ5yxaaRmsv0crZ4lJhXTHl0sso8+qHGp
         YQsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701446418; x=1702051218;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=crvm5e2ydDZMUM2EHuPCr67zijP1BJbvH57wgKGfkc4=;
        b=BK6vIFbdjA4Rr2yLZGObRJK6WWdVooTKbeJ3/P+TtE0S5TqOn89kacD6Ar5ICVAVVB
         tmRg/8XlqK2on9QbaVBl5HYpX4+1lUIwVOLFmYRmDxBCkHbrDPMtDexQJvcGRDkcw7fq
         LeOFNzgBSiL99jFcSYjR8EfwE5lpMNWFBbfNezhl405+95p+XYYVKtgm6sgHCDvp/AkT
         LNHvr5TYuEWpu8OgOLRRr9hLbL5uNB17A0UQXDvYXNXwY3/RzOwN4YcWebwXpmA9sAWI
         mJZWcP//ODxGtSCthTVR1Xr1ZSULODewCJauyzDQbaool14Y/IWtBoT3qK/BCTCvGu8b
         2xhQ==
X-Gm-Message-State: AOJu0YykxftzXwOvKOghIGRnKUrySy+f0sW/eiGce0iO3apYz+N6LjHA
	F7b+4BUrEkvsi7Bea4fcWj6WM9ITAnw=
X-Google-Smtp-Source: AGHT+IHo21+oBQWexEhm/gxZmQsFScsbXTirStRty1cwR0cGqSYO0hxdNViq14P4BW30477qGXZixHekO6o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6142:0:b0:5bd:d3f7:5192 with SMTP id
 o2-20020a656142000000b005bdd3f75192mr3924418pgv.6.1701446418251; Fri, 01 Dec
 2023 08:00:18 -0800 (PST)
Date: Fri, 1 Dec 2023 08:00:16 -0800
In-Reply-To: <170137684485.660161.8230111667906795222.b4-ty@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231125083400.1399197-1-pbonzini@redhat.com> <170137684485.660161.8230111667906795222.b4-ty@google.com>
Message-ID: <ZWoDEIJHD7cv-LU9@google.com>
Subject: Re: [PATCH v2 0/4] KVM: x86/mmu: small locking cleanups
From: Sean Christopherson <seanjc@google.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: mlevitsk@redhat.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 30, 2023, Sean Christopherson wrote:
> On Sat, 25 Nov 2023 03:33:56 -0500, Paolo Bonzini wrote:
> > Remove "bool shared" argument from functions and iterators that need
> > not know if the lock is taken for read or write.  This is common because
> > protection is achieved via RCU and tdp_mmu_pages_lock or because the
> > argument is only used for assertions that can be written by hand.
> > 
> > Also always take tdp_mmu_pages_lock even if mmu_lock is currently taken
> > for write.
> > 
> > [...]
> 
> Applied to kvm-x86 mmu, thanks!
> 
> [1/4] KVM: x86/mmu: remove unnecessary "bool shared" argument from functions
>       https://github.com/kvm-x86/linux/commit/2d30059d38e6
> [2/4] KVM: x86/mmu: remove unnecessary "bool shared" argument from iterators
>       https://github.com/kvm-x86/linux/commit/59b93e634b40
> [3/4] KVM: x86/mmu: always take tdp_mmu_pages_lock
>       https://github.com/kvm-x86/linux/commit/4072c73104f2
> [4/4] KVM: x86/mmu: fix comment about mmu_unsync_pages_lock
>       https://github.com/kvm-x86/linux/commit/9dc2973a3b20

FYI, I had to force push to mmu to fixup an unrelated Fixes: issue, new hashes:

[1/4] KVM: x86/mmu: remove unnecessary "bool shared" argument from functions
      https://github.com/kvm-x86/linux/commit/5f3c8c9187b6
[2/4] KVM: x86/mmu: remove unnecessary "bool shared" argument from iterators
      https://github.com/kvm-x86/linux/commit/484dd27c0602
[3/4] KVM: x86/mmu: always take tdp_mmu_pages_lock
      https://github.com/kvm-x86/linux/commit/250ce1b4d21a
[4/4] KVM: x86/mmu: fix comment about mmu_unsync_pages_lock
      https://github.com/kvm-x86/linux/commit/e59f75de4e50

