Return-Path: <kvm+bounces-3136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AAACA800EE3
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 16:59:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E213281BA3
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 15:59:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61FEE4BA88;
	Fri,  1 Dec 2023 15:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yAoTfPyd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D66310D0
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 07:59:07 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-5c5c8ece6c4so695553a12.0
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 07:59:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701446346; x=1702051146; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TkpVjWAyYjS0I9CzEWlixDUtvIIe2C439SDqnfwwj5c=;
        b=yAoTfPyd8wn7jXkf35nee7CeQYmXIt4c8dEY+3sSRYy3GejpHR4JScV2gKBEUIkcV8
         hRSSjOZ0QeaEyijBVwRMCeJ7n9Zxb0MBGjpo5sx1iHpqqFqHUBVSiFOFRpbgJK5n+1Op
         tjqBOS0vQDWoj7gUEizQSl+XdaWV3kBNmjbGFZmXclZ2Qf8Zk5hxaXBsR1PaTEYeglhI
         rHqhrREFr3eMLhtMxo6f0Tv4udDoKLv0hqtJiOXJj+L6WBerVJnqGbYmzRGeYIpbCV1i
         ftOUfs82NW7DroLtIWq/QMW2SiKvWw9yjRy7IjFHm4bjXNfVBs5h7NJ2uH2SiWkdyAHq
         F0vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701446346; x=1702051146;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TkpVjWAyYjS0I9CzEWlixDUtvIIe2C439SDqnfwwj5c=;
        b=QLsnGFw/3No+/It1gExcVMpYnYGthJ8nHjC9tKbTxcLuMAuHAKthbrDAmNhBAfuULF
         q+QNHzyWQScqREr1/EFv02YqoYqfUZKlJL7PzEi1sxBsn0KnI3kaxz+ETe97g9Xgcj5N
         3LUZ1GAJb3gBmPwj5kvbc2q6D8nzWU7EdtxehVQINgD7bm8NeDn6RPZALZF969/WhR6c
         6SK5MQLd6v7KfWg+rs0b2kI57xbOsNMPlCgvfLyQhwhjHDgMSbnaAvyaJlODpgaPQKjd
         8axl7y7f2Pry07ru2DK9mPtaAV631BYfKisdKGA8q84SKz9hm6CsbtlB7VsNwiu6NRqv
         GQzw==
X-Gm-Message-State: AOJu0YxxOa9W/DJ+9R/DTXGW7JKxGGakMneQxnRi6q+WxgnFIbrxUo6U
	aR63ZFKOer86nR36Fz9gJS9aBoV0OfI=
X-Google-Smtp-Source: AGHT+IFQk1XnNU9lk5sGP4QKGn8r3BGGo+JStCTEyXf61qFDDgjeYjiIMUMMnnyHMrlDrGaZu//9PdVF4uc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:4d1b:0:b0:5bd:d60f:231d with SMTP id
 a27-20020a634d1b000000b005bdd60f231dmr3915914pgb.3.1701446346665; Fri, 01 Dec
 2023 07:59:06 -0800 (PST)
Date: Fri, 1 Dec 2023 07:59:05 -0800
In-Reply-To: <170137684236.660121.11958959609300046312.b4-ty@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231027172640.2335197-1-dmatlack@google.com> <170137684236.660121.11958959609300046312.b4-ty@google.com>
Message-ID: <ZWoCye5oaJX_VV9Q@google.com>
Subject: Re: [PATCH 0/3] KVM: Performance and correctness fixes for CLEAR_DIRTY_LOG
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, David Matlack <dmatlack@google.com>
Cc: kvm@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 30, 2023, Sean Christopherson wrote:
> On Fri, 27 Oct 2023 10:26:37 -0700, David Matlack wrote:
> > This series reduces the impact of CLEAR_DIRTY_LOG on guest performance
> > (Patch 3) and fixes 2 minor bugs found along the way (Patches 1 and 2).
> > 
> > We've observed that guest performance can drop while userspace is
> > issuing CLEAR_DIRTY_LOG ioctls and tracked down the problem to
> > contention on the mmu_lock in vCPU threads. CLEAR_DIRTY_LOG holds the
> > write-lock, so this isn't that surprising. We previously explored
> > converting CLEAR_DIRTY_LOG to hold the read-lock [1], but that has some
> > negative consequences:
> > 
> > [...]
> 
> Applied 1 and 2 to kvm-x86 mmu.  To get traction on #3, I recommend resending it
> as a standalone patch with all KVM arch maintainers Cc'd.
> 
> [1/3] KVM: x86/mmu: Fix off-by-1 when splitting huge pages during CLEAR
>       https://github.com/kvm-x86/linux/commit/7cd1bf039eeb
> [2/3] KVM: x86/mmu: Check for leaf SPTE when clearing dirty bit in the TDP MMU
>       https://github.com/kvm-x86/linux/commit/76d1492924bc

Force pushed because the Fixes: in patch 1 referenced a Google-internal commit.
New hashes:

[1/2] KVM: x86/mmu: Fix off-by-1 when splitting huge pages during CLEAR
      https://github.com/kvm-x86/linux/commit/1aa4bb916808
[2/2] KVM: x86/mmu: Check for leaf SPTE when clearing dirty bit in the TDP MMU
      https://github.com/kvm-x86/linux/commit/45a61ebb2211

