Return-Path: <kvm+bounces-5068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89E0A81B609
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 13:34:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 14DC4B271BC
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 12:34:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B6DA745CD;
	Thu, 21 Dec 2023 12:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="FhPg5Ncj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F58487B7
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 12:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-50e64eb3bc7so14779e87.0
        for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 04:32:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1703161924; x=1703766724; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WVkUcaB6rcrsUYTEds8AlF4OZ5kEBnxC4/WA5YErqSQ=;
        b=FhPg5NcjjktILuiJHkOcgkaSLZIfvsYv1Co4P1Ixi0zE2Uw1jWVTHFp/IelvSnOLyg
         H7ggM26moUd96kl265fpov+/b3qAnb0o9m2iAWMYmGO8Ghuc6FhJMtaBkbknCU6kJjRr
         Mp9CPNrCIgwA4ro0yPrQLbCAV/5PflXju2JdWdFOFvRRZXOjke2FzO4aCfB7PBxmLyin
         CsImjPevY+Z56wi4nDfMeTyFh8hxLxizVyD5jbAjaVFACW7H4oCmQ74xBHyiwlFldqay
         iE8V75/Tuzh4o0AhErJkCK1jS5o54c6AwyxZcMcWCJIK4dWtYDamD8HJnRIsVn7nQV68
         huxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703161924; x=1703766724;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WVkUcaB6rcrsUYTEds8AlF4OZ5kEBnxC4/WA5YErqSQ=;
        b=gupNNJLsVSWoUBB8yNwrD/UZeClt0dNy6qEMh7XYtqXuXiB5jT6hc1xidO8IhYsLn6
         RvneDBfGYw1Wtvs68nsScHDIOz9ragCz8TkZKHsCYl9Ym/PEPrfnVl0xhMxXLWhwKQ8O
         uidyvhwXrmk5X8nrfPhhmI9PJTR4XOw48MObKJtk0kju/YvZmQnxCZfRnnyh8QZ9APXP
         5N6PBZwoCAhQugfYU+zRtwE27lCEDWpJyQuk7Ub7Cxx7rw85zHl+REudEs3iLXNHk23a
         rIe7hvqfGJo9M//EcmPHSQkKBSJ92ghyI3SEJ3R1DuWfeDEzCV93YVGKqB7IjUvBSSuy
         Q95Q==
X-Gm-Message-State: AOJu0YwGe+2zYaag7ijrOoKPXD22bc63EUBx8zqNRLqAuORe5IpDKNvq
	neGuJgTsk3iG4Ph/VrbjuNgQZ8KHubhQq3FzIgK69w==
X-Google-Smtp-Source: AGHT+IGwBLiEjc39v6ncHpMvWhk/849vsFVYcEttFHneQSjq1MwdXtib9IQOjnA7+sD1SvAzAP3UJ8Tzx2hMY9atk+A=
X-Received: by 2002:ac2:4c33:0:b0:50e:4b1f:5ddb with SMTP id
 u19-20020ac24c33000000b0050e4b1f5ddbmr400789lfq.16.1703161923218; Thu, 21 Dec
 2023 04:32:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231221095002.7404-1-duchao@eswincomputing.com>
In-Reply-To: <20231221095002.7404-1-duchao@eswincomputing.com>
From: Anup Patel <apatel@ventanamicro.com>
Date: Thu, 21 Dec 2023 18:01:51 +0530
Message-ID: <CAK9=C2Wfv7=fCitUdjBpC9=0icN82Bb+9p1-Gq5ha8o9v13nEg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] RISC-V: KVM: Guest Debug Support
To: Chao Du <duchao@eswincomputing.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, anup@brainfault.org, 
	atishp@atishpatra.org, dbarboza@ventanamicro.com, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 21, 2023 at 3:21=E2=80=AFPM Chao Du <duchao@eswincomputing.com>=
 wrote:
>
> This series implements KVM Guest Debug on RISC-V. Currently, we can
> debug RISC-V KVM guest from the host side, with software breakpoints.
>
> A brief test was done on QEMU RISC-V hypervisor emulator.
>
> A TODO list which will be added later:
> 1. HW breakpoints support
> 2. Test cases

Himanshu has already done the complete HW breakpoint implementation
in OpenSBI, Linux RISC-V, and KVM RISC-V. This is based on the upcoming
SBI debug trigger extension draft proposal.
(Refer, https://lists.riscv.org/g/tech-debug/message/1261)

There are also RISE projects to track these efforts:
https://wiki.riseproject.dev/pages/viewpage.action?pageId=3D394541
https://wiki.riseproject.dev/pages/viewpage.action?pageId=3D394545

Currently, we are in the process of upstreaming the OpenSBI support
for SBI debug trigger extension. The Linux RISC-V and KVM RISC-V
patches require SBI debug trigger extension and Sdtrig extension to
be frozen which will happen next year 2024.

Regards,
Anup

>
> This series is based on Linux 6.7-rc6 and is also available at:
> https://github.com/Du-Chao/linux/tree/riscv_gd_sw
>
> The matched QEMU is available at:
> https://github.com/Du-Chao/qemu/tree/riscv_gd_sw
>
> Chao Du (3):
>   RISC-V: KVM: Enable the KVM_CAP_SET_GUEST_DEBUG capability
>   RISC-V: KVM: Implement kvm_arch_vcpu_ioctl_set_guest_debug()
>   RISC-V: KVM: Handle breakpoint exits for VCPU
>
>  arch/riscv/include/uapi/asm/kvm.h |  1 +
>  arch/riscv/kvm/vcpu.c             | 15 +++++++++++++--
>  arch/riscv/kvm/vcpu_exit.c        |  4 ++++
>  arch/riscv/kvm/vm.c               |  1 +
>  4 files changed, 19 insertions(+), 2 deletions(-)
>
> --
> 2.17.1
>
>
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

