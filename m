Return-Path: <kvm+bounces-5659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2A398246BD
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 17:54:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59055287BD1
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 16:54:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62F4328695;
	Thu,  4 Jan 2024 16:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y3WjDS6D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612A225558
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 16:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1d4931d651aso6622975ad.2
        for <kvm@vger.kernel.org>; Thu, 04 Jan 2024 08:54:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704387247; x=1704992047; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IOc7yn03uRFuf4SJHIxKkjx7X83ZD2IbJiA9ijVZtUI=;
        b=Y3WjDS6DP4xVK8OIYTYdVhz/d+BvvBO7/nPe/tGR+H2oWZM2qb3gE48vGFlQPCFcbO
         wkhcXk0lrp6JAOJ5pX/KrC87icdjWVN6HvGGV9dWl2L+As4drYp1AUY5xaAx7Tj/faVW
         I/tKdmzg5LDaBmOYeq2St36+AXDlpcmEJPBV10I97Bm/r2ZkRzstR91Wn9H6Es8FXIUZ
         MUPVTNLBA2//0zIGbdXaL7IU+7xH+NlxqHEAS3YmUoBfEHV1j7vdtCJhursXbRmzZ4Bn
         pft89GFhxcQ9tbzxsMoezJ2Qx2eDEvgYltfsA8kfCUaiXyB3dykSmsL+mJSdX/Gq4HeP
         DunQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704387247; x=1704992047;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IOc7yn03uRFuf4SJHIxKkjx7X83ZD2IbJiA9ijVZtUI=;
        b=jPnx3rpdEKnOKpTC0OUHZaS8hhJFMb64agbpt0Ajl+PnNkN1uOcG1mCGvUMA5VIrzS
         8T9ct+WELzSReiRnFQZAnecLObn5TrxBfLil3JVpQ71Fnf7WMecu71Z/GNlnuQl3pSYe
         chyF1unPyVa/AH62tiosMal0vH8qTeM5/rmWXo6OD9a9n6APjBjTcIGRAkp+HroKV2oF
         NnH8D3E/5SFgw65VdYdmAKEdObWLK0nMZSv0fjdL94kaKeaLDG42SFCY3UeCX7WhUeu8
         rJ4zeviSZWNwabXlQqtMMCsnXrh0KNp6UOVkY9LrnC7VB/C8MCYfg9QsAY+QCwRpwNcT
         Ogag==
X-Gm-Message-State: AOJu0YzGqO7X0ShKmc70dKH95r2zqPGntBu23k316xm3l22tiVGzv/YS
	tqBzqonZHtXYXgErIrpNPB31Ag6Aboi0onkfbQ==
X-Google-Smtp-Source: AGHT+IFmLxHHNgdX4Fuyvx4f7rjYsIcTNXONQ6lx9rKIuUnwdVGJFKZSbPUrwZXJ85nIEJRCrkSIzi6zQm0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:11c6:b0:1d4:ac32:e9aa with SMTP id
 q6-20020a17090311c600b001d4ac32e9aamr4738plh.12.1704387247515; Thu, 04 Jan
 2024 08:54:07 -0800 (PST)
Date: Thu, 4 Jan 2024 08:54:05 -0800
In-Reply-To: <bug-218339-28872@https.bugzilla.kernel.org/>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <bug-218339-28872@https.bugzilla.kernel.org/>
Message-ID: <ZZbh_wVqwwB-gxFv@google.com>
Subject: Re: [Bug 218339] New: kernel goes unresponsive if single-stepping
 over an instruction which writes to an address for which a hardware
 read/write watchpoint has been set
From: Sean Christopherson <seanjc@google.com>
To: bugzilla-daemon@kernel.org
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 04, 2024, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=218339
> 
>             Bug ID: 218339
>            Summary: kernel goes unresponsive if single-stepping over an
>                     instruction which writes to an address for which a
>                     hardware read/write watchpoint has been set
>            Product: Virtualization
>            Version: unspecified
>           Hardware: All
>                 OS: Linux
>             Status: NEW
>           Severity: normal
>           Priority: P3
>          Component: kvm
>           Assignee: virtualization_kvm@kernel-bugs.osdl.org
>           Reporter: anthony.louis.eden@gmail.com
>         Regression: No
> 
> In a debian QEMU/KVM virtual machine, run `gdb` on any executable (e.g.
> `/usr/bin/ls`). Run the program by typing `starti`. Proceed to `_dl_start`
> (i.e. `break _dl_start`, `continue`). When you get there disassemble the
> function (i.e. `disas`). Find an instruction that's going to be executed for
> which you can compute the address in memory it will write to. Run the program
> to that instruction (i.e. `break *0xINSN`, `continue`). When you're on that
> instruction, set a read/write watchpoint on the address it will write to, then
> single-step (i.e. `stepi`) and the kernel will go unresponsive.

By "the kernel", I assume you mean the guest kernel?

> >(gdb) x/1i $pc
> >=> 0x7ffff7fe6510 <_dl_start+48>:      mov    %rdi,-0x88(%rbp)
> >(gdb) x/1wx $rbp-0x88
> >0x7fffffffec28:        0x00000000
> >(gdb) awatch *0x7fffffffec28
> >Hardware access (read/write) watchpoint 2: *0x7fffffffec28
> >(gdb) stepi
> 
> 
> Looking with `journalctl`, I cannot find anything printed to dmesg.
> 
> The kernel of the guest inside the virtual machine is Debian 6.1.0-15-amd64.
> The kernel of the host running qemu-system-x86_64 is Archlinux 6.6.7-arch1-1.
> gdb is version 13.1.

Is this a regression or something that has always been broken?  I.e. did this work
on previous host kernels?


