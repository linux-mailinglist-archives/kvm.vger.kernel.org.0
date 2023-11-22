Return-Path: <kvm+bounces-2255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 797307F3F64
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 09:01:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A84E11C20B20
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 08:01:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 290AA20B35;
	Wed, 22 Nov 2023 08:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="icZpjwJh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED2DF9
	for <kvm@vger.kernel.org>; Wed, 22 Nov 2023 00:01:09 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-4084de32db5so35981645e9.0
        for <kvm@vger.kernel.org>; Wed, 22 Nov 2023 00:01:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1700640068; x=1701244868; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D9ADCjEI7o9dzGO9BsaR3z0G/sfMu5E5t4/ZTd2GGTs=;
        b=icZpjwJh1sWUkCtAtuflLi5IEcMejHOvrHDiAqgoQRla9xec3R1DS2P5LF3Gyg3A7x
         IrOpuPRwfGHatdcfsgkkyg4ExFMi2dWt1ZXj4Ik/LhpMkW9Ey8yhbysJFdiYLs2kgVYO
         7wrVjOXBsBSLI5hnk9MUNWQDSia4Er3/PHcdNjqjfMppcYeZleCU6M/QYR/BzWYoYOtO
         KKsDPAGxvoFBcvx/+ZN/x/RE4IbFC1e/0errSjjC2Ktv6MOIGN0u+3Oxk+ggk2cmbfkS
         FpkHiMy+dPyA23Q1B+yvr7zs7Ju7LA/t5jb5xe/FbwN9lJCVPW09TCUvnalzUkNlEMsx
         E4ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700640068; x=1701244868;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D9ADCjEI7o9dzGO9BsaR3z0G/sfMu5E5t4/ZTd2GGTs=;
        b=HfuyeJY/Bk0CFUO08C0xHwT1nVpt/VWsYKFsIVL3Ok1KQ09Vq8sAb0Cir6b42eVlP+
         x1eRfTqDsE3aBAwj/AixD7Zgq7SL5/f/Bm3WU+E0LPcxMcZ+h+wNdim1dqvrdZ87IbLe
         gbQYM0FR3FFZsyD62xdlmf8TnjzQQ8PusrggDF575Mc1FWvv5z1DJD6AB+E34TMzNCH+
         d5QwMj9Nbolwa2x4/gVaeQhq4fc1c+BJ5SO1aRzAAyE5EQsGOGF5Bht+2IEW3cPUJ7mh
         Xxz+yF52PZs2pZr+b+XXQ+GhhQ2M0w7mFk31ji5AAdEA9RHkqDqAfutwGfF/ko0cM8Ls
         CLrg==
X-Gm-Message-State: AOJu0Yw6DoO864Vmw6AWRDlE8Y3nltpCoSTC08Ri7LrjuxGHwtF4n3RI
	O4OsU85MXA+VkOBFvYDWIG0mh/DFy34py1Cmj20=
X-Google-Smtp-Source: AGHT+IE1/C3weLHdhpWJSWXJPJYT4boAklbn3sgz4rb9EWKq6qitvv5j2eDGac4BGRWMcwTjthYjsw==
X-Received: by 2002:a05:600c:4fcc:b0:40b:2b82:dad8 with SMTP id o12-20020a05600c4fcc00b0040b2b82dad8mr1190319wmq.5.1700640068378;
        Wed, 22 Nov 2023 00:01:08 -0800 (PST)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id n44-20020a05600c502c00b004083a105f27sm1326932wmr.26.2023.11.22.00.01.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Nov 2023 00:01:08 -0800 (PST)
Date: Wed, 22 Nov 2023 09:01:06 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] selftests/kvm: Fix issues with $(SPLIT_TESTS)
Message-ID: <20231122-ef1578645fb74a7aa0fca822@orel>
References: <20231121165631.1170797-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231121165631.1170797-1-pbonzini@redhat.com>

On Tue, Nov 21, 2023 at 11:56:31AM -0500, Paolo Bonzini wrote:
> The introduction of $(SPLIT_TESTS) also introduced a warning when
> building selftests on architectures that include get-reg-lists:
> 
>     make: Entering directory '/root/kvm/tools/testing/selftests/kvm'
>     Makefile:272: warning: overriding recipe for target '/root/kvm/tools/testing/selftests/kvm/get-reg-list'
>     Makefile:267: warning: ignoring old recipe for target '/root/kvm/tools/testing/selftests/kvm/get-reg-list'
>     make: Leaving directory '/root/kvm/tools/testing/selftests/kvm'
> 
> In addition, the rule for $(SPLIT_TESTS_TARGETS) includes _all_
> the $(SPLIT_TESTS_OBJS), which only works because there is just one.
> So fix both by adjusting the rules:
> 
> - remove $(SPLIT_TESTS_TARGETS) from the $(TEST_GEN_PROGS) rules,
>   and rename it to $(SPLIT_TEST_GEN_PROGS)
> 
> - fix $(SPLIT_TESTS_OBJS) so that it plays well with $(OUTPUT),
>   rename it to $(SPLIT_TEST_GEN_OBJ), and list the object file
>   explicitly in the $(SPLIT_TEST_GEN_PROGS) link rule
> 
> Fixes: 17da79e009c3 ("KVM: arm64: selftests: Split get-reg-list test code", 2023-08-09)
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  tools/testing/selftests/kvm/Makefile | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
>

Thanks for these fixes, Paolo! And thanks for keeping my old @redhat.com
address alive!

I've tested this on riscv,

Tested-by: Andrew Jones <ajones@ventanamicro.com>

Thanks,
drew

