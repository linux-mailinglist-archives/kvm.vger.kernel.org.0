Return-Path: <kvm+bounces-6098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C52A482B247
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 17:00:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D727BB22B8E
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 16:00:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64FB94F61D;
	Thu, 11 Jan 2024 16:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iAIp9ESR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C54156CB
	for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 16:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbeac1f5045so6629045276.1
        for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 08:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704988807; x=1705593607; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JxN7R377bwy0eVKj0G4Rz7CiNeL7SD47OvC/Yydz4N4=;
        b=iAIp9ESRiT4KZxhu4joy8o8utXwsHC4VBhtQKqDS4Q97s4xLLanH4k6bisIn1bNxQj
         gspevdfYmcxrAqNOVMaxuwyaWQGrSItt8T2ciCku6xXRglmOww08pPh/qWsu1x1G7Ii3
         43OExbsGQDjmWtLzrthS20D26xWTbxQxdZR8vr0TvtHNmgiHZvlTPgSRY+c9jvUPwNQn
         djnz3FyalPXBbsdPfbhKT9BTliq0PaO6XApoDlgBxXViMPGN1CG4rU2eQHaux4AwqirK
         Dp02kew0zgjJqmUO4Bwmo78eYIRKb9RKEQ+ZZXV/lsI4K8DnCBD5KZY28LG2iLm6vQR+
         MsLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704988807; x=1705593607;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JxN7R377bwy0eVKj0G4Rz7CiNeL7SD47OvC/Yydz4N4=;
        b=Q43Vj6B5/x1E/GkBGU6V5nZLVZI5nj97tJZUJkJpdADr1BtHgR9f+iWntKbnB3lzxC
         lTyWnMf87ovDaAzP/XCC6KT3Oj7OHZPav/XH0hON7lZ9aZUfQaeZIjeTXIQzXv7qlx8y
         rkG7zbeQEfCHuFqURbrZ1qEHngEcmnq2JmxdY+2YrDmM0kst4zVrcf49G5DhjJoc/ME1
         5+yQNNbybDTQ7HIPXZNyWbHmm5wHci+7aRjZyJXh5OwPkKAZQ2Zk65IOC30o6A25xbH6
         ZpGSTkcKi3u4qX4r4a1zHKfDqyHP2AmV8jSfI7RTRa2qs4L5PDSF5zOyulwktCSYDc+6
         3PBw==
X-Gm-Message-State: AOJu0Ywo58Bw02Pn68EWHCQcesXJabAM3zQm5qaB0HcosFqfRUrw3Ifg
	8miicLWKb0ULyZfGxHCc03khqk6mE5KM0fg4GA==
X-Google-Smtp-Source: AGHT+IE30GMehPurCyiES1cREhJREwfrrR4fxbnpplJHm846Ao21KoBD2vg4J2OgkIxidWjcBwnCdxeO62M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:72a:b0:dbf:4556:2c58 with SMTP id
 l10-20020a056902072a00b00dbf45562c58mr241806ybt.1.1704988806911; Thu, 11 Jan
 2024 08:00:06 -0800 (PST)
Date: Thu, 11 Jan 2024 08:00:05 -0800
In-Reply-To: <832697b9-3652-422d-a019-8c0574a188ac@proxmox.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <832697b9-3652-422d-a019-8c0574a188ac@proxmox.com>
Message-ID: <ZaAQhc13IbWk5j5D@google.com>
Subject: Re: Temporary KVM guest hangs connected to KSM and NUMA balancer
From: Sean Christopherson <seanjc@google.com>
To: Friedrich Weber <f.weber@proxmox.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 04, 2024, Friedrich Weber wrote:
> Hi,
> 
> some of our (Proxmox VE) users have been reporting [1] that guests
> occasionally become unresponsive with high CPU usage for some time
> (varying between ~1 and more than 60 seconds). After that time, the
> guests come back and continue running fine. Windows guests seem most
> affected (not responding to pings during the hang, RDP sessions time
> out). But we also got reports about Linux guests. This issue was not
> present while we provided (host) kernel 5.15 and was first reported when
> we rolled out a kernel based on 6.2. The reports seem to concern NUMA
> hosts only. Users reported that the issue becomes easier to trigger the
> more memory is assigned to the guests. Setting mitigations=off was
> reported to alleviate (but not eliminate) the issue. The issue seems to
> disappear after disabling KSM.
> 
> We can reproduce the issue with a Windows guest on a NUMA host, though
> only occasionally and not very reliably. Using a bpftrace script like
> [7] we found the hangs to correlate with long-running invocations of
> `task_numa_work` (more than 500ms), suggesting a connection to the NUMA
> balancer. Indeed, we can't reproduce the issue after disabling the NUMA
> balancer with `echo 0 > /proc/sys/kernel/numa_balancing` [2] and got a
> user confirming this fixes the issue for them [3].
> 
> Since the Windows reproducer is not very stable, we tried to find a
> Linux guest reproducer and have found one (described below [0]) that
> triggers a very similar (hopefully the same) issue. The reproducer
> triggers the hangs also if the host is on current Linux 6.7-rc8
> (610a9b8f). A kernel bisect points to the following as the commit
> introducing the issue:
> 
> f47e5bbb ("KVM: x86/mmu: Zap only TDP MMU leafs in zap range and
> mmu_notifier unmap")
> 
> which is why I cc'ed Sean and Paolo. Because of the possible KSM
> connection I cc'ed Andrew and linux-mm.
> 
> Indeed, on f47e5bbb~1 = a80ced6e ("KVM: SVM: fix panic on out-of-bounds
> guest IRQ") the reproducer does not trigger the hang, and on f47e5bbb it
> triggers the hang.
> 
> Currently I don't know enough about the KVM/KSM/NUMA balancer code to
> tell how the patch may trigger these issues. Any idea who we could ask
> about this, or how we could further debug this would be greatly appreciated!

This is a known issue.  It's mostly a KVM bug[1][2] (fix posted[3]), but I suspect
that a bug in the dynamic preemption model logic[4] is also contributing to the
behavior by causing KVM to yield on preempt models where it really shouldn't.

[1] https://lore.kernel.org/all/ZNnPF4W26ZbAyGto@yzhao56-desk.sh.intel.com
[2] https://lore.kernel.org/all/bug-218259-28872@https.bugzilla.kernel.org%2F
[3] https://lore.kernel.org/all/20240110012045.505046-1-seanjc@google.com
[4] https://lore.kernel.org/all/20240110214723.695930-1-seanjc@google.com

