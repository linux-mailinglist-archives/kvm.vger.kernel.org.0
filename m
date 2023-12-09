Return-Path: <kvm+bounces-3982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6D7980B1BD
	for <lists+kvm@lfdr.de>; Sat,  9 Dec 2023 03:30:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 36F06B20CF1
	for <lists+kvm@lfdr.de>; Sat,  9 Dec 2023 02:30:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D95371119;
	Sat,  9 Dec 2023 02:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nuDb//m6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467411712
	for <kvm@vger.kernel.org>; Fri,  8 Dec 2023 18:29:49 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-db54e86b2d1so3262462276.1
        for <kvm@vger.kernel.org>; Fri, 08 Dec 2023 18:29:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702088988; x=1702693788; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4KmejgukXo7m764qqW7DNGExe6RkwfWGfLJnqMZhyJs=;
        b=nuDb//m6XLvqeI/HIhB+wXYvF153oPs6aZ5hXK2s9jrSa1pjNPSkKvpo5QFQBGD/hr
         4J5pxT6Fbj9Kz1eNEEJQEKO6XiVLj82NCRVDA9l8F9h2gX/s9I9P8I7NRSNrQgvYCM2/
         yj3YGiE/zZ7tTpbyUK1kXSv0NxT6uaKmF8jDXcG9WhocwwhgIiWHp+6DSCt4SOxCPwac
         T4mpw76lFeQ0ZRigKXOjVR4vCt/X7tX9sQ3X9aSMROSPUwtR7fmanRYzOuPp9lpUUUJW
         u1yV3Aingvoca0fa5zOucDFI/vW6rYtPIDtOFrTqjbuxx8A2AGJGNkl7gIfnSxEDJNBI
         Wqxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702088988; x=1702693788;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4KmejgukXo7m764qqW7DNGExe6RkwfWGfLJnqMZhyJs=;
        b=m4OYh64x8uLxVLs1aiQEOdCJEDQ0fJqVq8EhaOUgrL/ZaeJB8igUlPqPajzpFoX//8
         6c/rGvCvaJEaSKZCI8Mp373ytuF3LXSFDeQUJp8ZWMYLCjODiEH+auCwjVcuSDPw3zCz
         jUpJ5Y6amWob5S9HDf8ZRKbMjnTPlVnwJy4+7J1XwXwakEwZi5hIGxtjijXON4iMjOzB
         lJTpo3iQ/dWmxkwe5bSVFArx0AubsL0CPg03vnhl7j+Vr5lBeBMO1kfWpSsLGpt33+zW
         7M7JMUGRbY42Zgdf6znMrxVmlMdbCpPaFjgnsIWAKwM7Acs+aKRJojXdJ+NYMp79HH0A
         eisQ==
X-Gm-Message-State: AOJu0YzpF29sM4alACEqgFyYpnXCPUoItXhbLpJxUJBdMQct4/kBIOqR
	2x0PhF1r3bwtmTjwWjcVGW1xt+EyS9E=
X-Google-Smtp-Source: AGHT+IF8bg9FcnNJFlvIumcFhDXG/a/z3zARXW8lhXG8Z7KoYcgKIL4eXnE4wsGqAe0l3/isXPMIand5drU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:14d:b0:db5:3aaf:5207 with SMTP id
 p13-20020a056902014d00b00db53aaf5207mr29309ybh.3.1702088988456; Fri, 08 Dec
 2023 18:29:48 -0800 (PST)
Date: Fri, 8 Dec 2023 18:29:47 -0800
In-Reply-To: <20231208184628.2297994-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231208184628.2297994-1-pbonzini@redhat.com>
Message-ID: <ZXPRGzgWFqFdI_ep@google.com>
Subject: Re: [PATCH] KVM: selftests: fix supported_flags for aarch64
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Dec 08, 2023, Paolo Bonzini wrote:
> KVM/Arm supports readonly memslots; fix the calculation of
> supported_flags in set_memory_region_test.c, otherwise the
> test fails.

You got beat by a few hours, and by a better solution ;-)

https://lore.kernel.org/all/20231208033505.2930064-1-shahuang@redhat.com

> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  tools/testing/selftests/kvm/set_memory_region_test.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
> index 6637a0845acf..dfd1d1e22da3 100644
> --- a/tools/testing/selftests/kvm/set_memory_region_test.c
> +++ b/tools/testing/selftests/kvm/set_memory_region_test.c
> @@ -333,9 +333,11 @@ static void test_invalid_memory_region_flags(void)
>  	struct kvm_vm *vm;
>  	int r, i;
>  
> -#ifdef __x86_64__
> +#if defined __aarch64__ || defined __x86_64__
>  	supported_flags |= KVM_MEM_READONLY;
> +#endif
>  
> +#ifdef __x86_64__
>  	if (kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM))
>  		vm = vm_create_barebones_protected_vm();
>  	else
> -- 
> 2.39.1
> 

