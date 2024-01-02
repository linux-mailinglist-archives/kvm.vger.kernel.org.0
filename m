Return-Path: <kvm+bounces-5462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6329E822282
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 21:26:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 01087B2274C
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 20:26:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3504816417;
	Tue,  2 Jan 2024 20:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="pWDfKG/b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D432416402
	for <kvm@vger.kernel.org>; Tue,  2 Jan 2024 20:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-55692ad81e3so1041652a12.1
        for <kvm@vger.kernel.org>; Tue, 02 Jan 2024 12:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1704227151; x=1704831951; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NExEDV8tMM90xF5QlyIZ/qRPsBLYQaG4/Qh4/SWZL/Q=;
        b=pWDfKG/bl8WbtJT6VLUxbhvZmiayGUu8UfH5fJFpEFx53boJ71/9VFNFOOUVaxicdE
         aM8+1tsF1ssJMOTSGpJM7lniIYpnzAp1iatB8dzt7wvNbEAEdY+RepSv4OKt0DNF6Q7G
         7j6BmAKeDZ7ry4k5AfZeEYd+fm8TSNC4WpwjqRt2eWlP16EhZBRhZiKVUpiXPUCOwaxB
         NwV8+TIdhIzA/MT0Th6f/iY0xfZWolV5dlNmcgYNmdFfv665FPPk1MlE7F3opeuT50E3
         4q+tjxIJNLQ9MgywhKmo3zndXZ1W2MkXMvPf7KMpcPUGuFN40lyqX3taPrvFUx8gCtG8
         YHpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704227151; x=1704831951;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NExEDV8tMM90xF5QlyIZ/qRPsBLYQaG4/Qh4/SWZL/Q=;
        b=PES+s8QBM5ex0hWlbUqtHw4v1IVg4RovXbSIQdkR+yVgQ2b/z24m5tSIt+Pgl3vhIr
         +kPTp5kRATW1TG8AXIjiwXWE3oMHkrA6Y5QfzdC8ekLr1dDg6Z4BcpIQw7RxBNqRSPuX
         GjCPUV5ORq6ptp8jJhMq30dYcsA+5xwU2KbwwoEPoKGVfiT+BCT2ikX/hgOHEePcz/VM
         6rsGy4bkxqshaZQQKgGd++NzxjINwQKzjIJGAKK8VVMa1JH+MlTsvcQk+2p/4I8KDoSl
         N+0bq0lUQBiQgQEOs3vFHO7wxZfb/EpXInao1+iU1uj+t6FtTHBrVFigKzIEQ6uTKFCM
         9EPA==
X-Gm-Message-State: AOJu0YxX4hI4Crvhe1tfq+mFQqkEi61lvRtNwjJz0M+hZ6pycYseVp0l
	5mRcng5/HUOpb05hBP2F+ScI3W3ylXfeCQ==
X-Google-Smtp-Source: AGHT+IGoZoqDAXnZi0UM3QsliCD4sz5wHpUirjmUAYgkmubdexz5ZCsn37/7027mpZ7WypUu2miOjg==
X-Received: by 2002:a17:906:1186:b0:a28:2ce:fa93 with SMTP id n6-20020a170906118600b00a2802cefa93mr1527288eja.15.1704227150959;
        Tue, 02 Jan 2024 12:25:50 -0800 (PST)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id vl8-20020a17090730c800b00a27eddc3dcbsm2463253ejb.198.2024.01.02.12.25.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jan 2024 12:25:50 -0800 (PST)
Date: Tue, 2 Jan 2024 21:25:49 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Anup Patel <anup@brainfault.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Palmer Dabbelt <palmer@rivosinc.com>, Atish Patra <atishp@atishpatra.org>, 
	Atish Patra <atishp@rivosinc.com>, KVM General <kvm@vger.kernel.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, linux-riscv <linux-riscv@lists.infradead.org>
Subject: Re: Re: [GIT PULL] KVM/riscv changes for 6.8 part #1
Message-ID: <20240102-c07d32a585f11ee80bd7b70b@orel>
References: <CAAhSdy1QsMuAmr+DFxjkf3a2Ur91AX9AnddRnBHGM6+exkAn1g@mail.gmail.com>
 <CABgObfZN4_xvOHr8aukZZGZj5teWZ7rt5RJU5Y0YFewQk19FRw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfZN4_xvOHr8aukZZGZj5teWZ7rt5RJU5Y0YFewQk19FRw@mail.gmail.com>

On Tue, Jan 02, 2024 at 07:24:26PM +0100, Paolo Bonzini wrote:
> On Sun, Dec 31, 2023 at 6:33 AM Anup Patel <anup@brainfault.org> wrote:
> >
> > Hi Paolo,
> >
> > We have the following KVM RISC-V changes for 6.8:
> > 1) KVM_GET_REG_LIST improvement for vector registers
> > 2) Generate ISA extension reg_list using macros in get-reg-list selftest
> > 3) Steal time account support along with selftest
> 
> Just one small thing I noticed on (3), do you really need cpu_to_le64
> and le64_to_cpu on RISC-V? It seems that it was copied from aarch64.
> No need to resend the PR anyway, of course.

While Linux/KVM is only LE, the arch doesn't prohibit S-mode being
configured to use BE memory accesses, so I kept the conversions. They
at least provide some self-documenting of the code. The biggest
problem with them, though, is that I didn't use __le64 types and now
sparse is yelling at me. I patched that this morning, but didn't get
a chance to post yet. I could instead rip out the conversions to
quiet sparse, if that would be preferred.

Thanks,
drew

