Return-Path: <kvm+bounces-5710-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E87CE8250F0
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 10:37:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8A4BBB24881
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 09:37:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82A75249E1;
	Fri,  5 Jan 2024 09:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="jhfbCnyx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8CB241F1
	for <kvm@vger.kernel.org>; Fri,  5 Jan 2024 09:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-556eadd5904so1504234a12.2
        for <kvm@vger.kernel.org>; Fri, 05 Jan 2024 01:37:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1704447442; x=1705052242; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=T8Qc+DAOtmpEj+ygGinAvQ01y6FiLQ/IoAOtnKnganw=;
        b=jhfbCnyxDD+caE9biJ1d+jAPwh4HJn9SS9T371H4jpTeYi/Wb943n0RqstVkaVdou5
         08Za9d8v13m3MFM2XDqdt3ocNd2HMaoTNoEdEa86gCkrHcrabNxBqG5viZYE5+/58joU
         3oXSJjan+mhOvV26yUFaJ68jnx+MFrnsMFyPXPijy9gaqePdWZIYHeYVC+hgDwAfq0I5
         JCYNpIXmy4tAtl7pnU+dkW6OwCngUyYF/DpFweqS0m/nyKF7w6tqMKvU6XWFG3bMPfY9
         Q/7LG1YrNhxLQjEcjo2/RvnC/s/mjbtv5mZvdlDalseIC5rs8aujnmYcQDDkG901j1wK
         WQmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704447442; x=1705052242;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T8Qc+DAOtmpEj+ygGinAvQ01y6FiLQ/IoAOtnKnganw=;
        b=Rtr69hcxkvrQbuLbRy4p8c+hXc96DfM5QlBnPPTme8indr+TTe4XxOMAjABUi7Q9Ui
         w7vaqaU4biCd69Njox9V9uDMxu5718Sz8ZFREbXhp4L2744Q9mPrP+HxpoSPmF1pN/R/
         RkRGA0Kp4C5YFduk7aWXVTh83AiU7ji22NhbygZNLbAT7zPSRH0CRSA8ydx3YFwJfXu8
         K1/HH+rR4IkQbrIr0TomqpWKQ/KhqLB9WZ9XC60Xbn0KmL1IPBfmEP+SlhSpv8lfoi5C
         tnQcOZiq8Xsvu2bXZgfRrmCswd3rmijTQy3nJg0gcdX/yjfdw5ivyxWFtxy6kTFypbZe
         z8XQ==
X-Gm-Message-State: AOJu0YyFUExr7kPBB9nFkO6oZmr7SGJbJ7HQRqojxnrEWhqAjaQ4Z7Z2
	2qw1jLi+mw7prrngsn1qPexyMWi1r40/wQ==
X-Google-Smtp-Source: AGHT+IF8fQXbP1BRpg30Hrn1hWWnXwz5MlDf/25VLJggd7Wh/H7izjD31EsFPbs3NtBzMgPs/Zvg8Q==
X-Received: by 2002:a17:906:54e:b0:a28:b34d:8693 with SMTP id k14-20020a170906054e00b00a28b34d8693mr477120eja.186.1704447442355;
        Fri, 05 Jan 2024 01:37:22 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id u16-20020a170906409000b00a28a7f56dc4sm675313ejj.188.2024.01.05.01.37.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jan 2024 01:37:22 -0800 (PST)
Date: Fri, 5 Jan 2024 10:37:21 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 1/4] KVM: introduce CONFIG_KVM_COMMON
Message-ID: <20240105-f3084386048af455001fd2e3@orel>
References: <20240104205959.4128825-1-pbonzini@redhat.com>
 <20240104205959.4128825-2-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240104205959.4128825-2-pbonzini@redhat.com>

On Thu, Jan 04, 2024 at 03:59:56PM -0500, Paolo Bonzini wrote:
> CONFIG_HAVE_KVM is currently used by some architectures to either
> enabled the KVM config proper, or to enable host-side code that is
> not part of the KVM module.  However, the "select" statement in
> virt/kvm/Kconfig corresponds to a third meaning, namely to
> enable common Kconfigs required by all architectures that support
> KVM.
> 
> These three meanings can be replaced respectively by an
> architecture-specific Kconfig, by IS_ENABLED(CONFIG_KVM), or by
> a new Kconfig symbol that is in turn selected by the
> architecture-specific "config KVM".
> 
> Start by introducing such a new Kconfig symbol, CONFIG_KVM_COMMON.
> Unlike CONFIG_HAVE_KVM, it is selected by CONFIG_KVM, not by
> architecture code.
> 
> Fixes: 8132d887a702 ("KVM: remove CONFIG_HAVE_KVM_EVENTFD", 2023-12-08)
> Cc: Andrew Jones <ajones@ventanamicro.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/arm64/kvm/Kconfig     | 1 +
>  arch/loongarch/kvm/Kconfig | 1 +
>  arch/mips/kvm/Kconfig      | 1 +
>  arch/powerpc/kvm/Kconfig   | 1 +
>  arch/riscv/kvm/Kconfig     | 1 +
>  arch/s390/kvm/Kconfig      | 1 +
>  arch/x86/kvm/Kconfig       | 1 +
>  virt/kvm/Kconfig           | 3 +++
>  8 files changed, 10 insertions(+)

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

