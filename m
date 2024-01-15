Return-Path: <kvm+bounces-6255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79F2F82DC83
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 16:42:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 87FCC1C21CF3
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 15:42:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4582317BC6;
	Mon, 15 Jan 2024 15:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="in4w1tCh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1E517BBE
	for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 15:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-554fe147ddeso9941610a12.3
        for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 07:41:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1705333283; x=1705938083; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IoPBd+9cqFRLXfeae6ug1abvNfzBQzrAtdxiFLBULy8=;
        b=in4w1tChfAKwkV+SbJJHCH7kBtKUxUL1R/zgajr+9q+bNP8HvT05ND7kP+cUAYWtVU
         fOlZqR+UsyIlHfk42uvTVHw5593d7qRrdE4sBo2BVAl8j2qj4cS957JEbOKzZS1ibibi
         qrnfB3rMUxdwVdcmNXD5g0jrGR4mA065/vnSkyo1H39KdjiQ9+k5oUJ7kWIODPzPLQtI
         K+SWVWXJwBeVnzfpPjKkmG6xcQoe9wLQOkwLIzFSCBVQdQg8zlPja9hpRaNNYqZ4MYKT
         ZNPdNtzMI5/HCEeCXZUMdZDnP0Zt6lWoGGtvncFKC36rGdln+O2qMjn2iKVacRFK3+6d
         KUdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705333283; x=1705938083;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IoPBd+9cqFRLXfeae6ug1abvNfzBQzrAtdxiFLBULy8=;
        b=RD3MANAg7zeH7cB0y8hM+kxxAho3CR1ArWeTnUv4kyLYuiJ29kLLbcb9gQNVMjHySg
         OyF9VeB7OAp/pp+Dz0uMHiMVWyYgZ7BIzkeEidgZkZoF2ji7x63SAuCkWpaJPygIlNUE
         fZDOPRvczi5qL0370LOgJ0X4qx6FFxeAtUay5mhL9og7/gQ6Shc0T/LpdVgjALGJ66Go
         BHvDLeeeAB5YuXTBBCMPU1L32MVBkLmMGKpeqZtKE9IFIto6LnNFa4ZVeD9qOzPZEAIZ
         ChC7/fkb7vA3SoRw2gH++gNfjYI/I2JcyvO+cKAF2lvwmMFZgmdzKb9zwl0W8NN0jB4T
         Qnxw==
X-Gm-Message-State: AOJu0YzfPT73VUQKfuRH/AZlDGc8NPdy1RoaVtCqxvPN9TY4DkS2JubM
	3xPrdds75jxVQ7ih6LGgyNBBOGXgvvmpIg==
X-Google-Smtp-Source: AGHT+IFKkPeCi7wmzN9qV4FM3v9RTTO3ePVJwXYR2KVsSk7g3fKbnojc19QbqZiEL00Tk7sLG0iIGA==
X-Received: by 2002:a17:907:20e3:b0:a2b:2615:25d1 with SMTP id rh3-20020a17090720e300b00a2b261525d1mr1367400ejb.90.1705333283455;
        Mon, 15 Jan 2024 07:41:23 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id v24-20020a1709067d9800b00a2a4efe7d3dsm5425091ejo.79.2024.01.15.07.41.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jan 2024 07:41:23 -0800 (PST)
Date: Mon, 15 Jan 2024 16:41:22 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Anup Patel <apatel@ventanamicro.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Atish Patra <atishp@atishpatra.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Shuah Khan <shuah@kernel.org>, Anup Patel <anup@brainfault.org>, 
	devicetree@vger.kernel.org, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 07/15] KVM: riscv: selftests: Add vector crypto
 extensions to get-reg-list test
Message-ID: <20240115-8ab964d5a932bc2c5d9da188@orel>
References: <20231128145357.413321-1-apatel@ventanamicro.com>
 <20231128145357.413321-8-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231128145357.413321-8-apatel@ventanamicro.com>

On Tue, Nov 28, 2023 at 08:23:49PM +0530, Anup Patel wrote:
> The KVM RISC-V allows vector crypto extensions for Guest/VM so let us
> add these extensions to get-reg-list test. This includes extensions
> Zvbb, Zvbc, Zvkb, Zvkg, Zvkned, Zvknha, Zvknhb, Zvksed, Zvksh, and Zvkt.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  .../selftests/kvm/riscv/get-reg-list.c        | 40 +++++++++++++++++++
>  1 file changed, 40 insertions(+)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

