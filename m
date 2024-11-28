Return-Path: <kvm+bounces-32730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2947B9DB3A4
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 09:21:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8A4EDB216C1
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 08:21:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E0A914D2AC;
	Thu, 28 Nov 2024 08:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b="Ybom1M6F"
X-Original-To: kvm@vger.kernel.org
Received: from sender4-op-o12.zoho.com (sender4-op-o12.zoho.com [136.143.188.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A2F1482ED;
	Thu, 28 Nov 2024 08:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732782062; cv=pass; b=XXxS6nLQm4gqMd42FPSdCBlr0dPT5H7uXu17rgR4gmScO9GVB4OUXtlj21Y+RMk5SKCfM/ufHGsn1EtmFxWiooEZ49lOYiV9aVMhVHx32p0KZEhjYokOGUvIteRf8bIg/1/+Dwd7z4Wq8kFJQ4KpP9JjM9RkH+tAwlAqNVwzatM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732782062; c=relaxed/simple;
	bh=+M7xPzt2i62PN7Nkw+Fy/ukBuJjrTY+BaxMbP+8Z8YE=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=g2J2an0RFSRlWyMhI3gPY/8jdyESu7DM/uWk0k5BiIlAlhOLywZ8GpGnSUpZa2PDU1nKyl3mRQbN5SuroilnSNW+3UHxhgBvUo5BTRyBFQCa7edSDCFpdbUffBUg6yjpODcbL6d6voezeTvQtxzNBIMiZZUJqfZ3H1GEf+LzrbE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b=Ybom1M6F; arc=pass smtp.client-ip=136.143.188.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
ARC-Seal: i=1; a=rsa-sha256; t=1732782042; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=XImBeHOkLpA8UCB4fYH0J1zo2i19uh5hZl7MrXFC2+LP/gMyXB8PMemBckDTdeU36RSTHSmf2wThNisSlosHiAaNx7zo3Uu+/nN1EhvhTkY5uYa9ZO3hhi2pQvAhzyoIc5rzJDMoYNxr+R+YEEdJR42mKk+aQ9tnqoec8rB2SuQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1732782042; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=uCVnPofV123Xc79SvY5WnBgk7dTIXFiFte5YfteSzjQ=; 
	b=YvoMPLpfVcc2aBh+5lPAAY2lyy5cKaAFSpphDbaQPJMK4xcj+Js+gvR+IqDvmSWcKVAOP0HHACub/MCRlq24HqfUo2+UoS3MyShncePzVPoqKpuTnBFQaiMDlGHKdLITLENAf6vlj2xr6CVJgxQlzEp5TU43uyjx271AciL0wes=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=Usama.Anjum@collabora.com;
	dmarc=pass header.from=<Usama.Anjum@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1732782042;
	s=zohomail; d=collabora.com; i=Usama.Anjum@collabora.com;
	h=Message-ID:Date:Date:MIME-Version:Cc:Cc:Subject:Subject:To:To:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=uCVnPofV123Xc79SvY5WnBgk7dTIXFiFte5YfteSzjQ=;
	b=Ybom1M6F0ULyVyv06seLGcNpx8iAElyVpbbxi9CtDworL8eTUJYpPP2YzhWnPiSh
	zEHCeDSWWUq3GliaUNUVVKO+bHo4d26o4kMpZnVLN5U7w6m9qDQogFhzQdkcd+HP2/s
	w3E4uNVnaBd3CTZNaNF02KNPanF7YxpxUgjG6xKE=
Received: by mx.zohomail.com with SMTPS id 1732782041480722.5762124602666;
	Thu, 28 Nov 2024 00:20:41 -0800 (PST)
Message-ID: <1d5a0d11-273b-4b0c-9ac4-597ad675defb@collabora.com>
Date: Thu, 28 Nov 2024 13:20:41 +0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: Usama.Anjum@collabora.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 Andrew Jones <ajones@ventanamicro.com>,
 James Houghton <jthoughton@google.com>
Subject: Re: [PATCH v4 16/16] KVM: selftests: Override ARCH for x86_64 instead
 of using ARCH_DIR
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>
References: <20241128005547.4077116-1-seanjc@google.com>
 <20241128005547.4077116-17-seanjc@google.com>
Content-Language: en-US
From: Muhammad Usama Anjum <Usama.Anjum@collabora.com>
In-Reply-To: <20241128005547.4077116-17-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External

On 11/28/24 5:55 AM, Sean Christopherson wrote:
> Now that KVM selftests uses the kernel's canonical arch paths, directly
> override ARCH to 'x86' when targeting x86_64 instead of defining ARCH_DIR
> to redirect to appropriate paths.  ARCH_DIR was originally added to deal
> with KVM selftests using the target triple ARCH for directories, e.g.
> s390x and aarch64; keeping it around just to deal with the one-off alias
> from x86_64=>x86 is unnecessary and confusing.
> 
> Note, even when selftests are built from the top-level Makefile, ARCH is
> scoped to KVM's makefiles, i.e. overriding ARCH won't trip up some other
> selftests that (somehow) expects x86_64 and can't work with x86.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>

> ---
>  tools/testing/selftests/kvm/Makefile     |  4 +---
>  tools/testing/selftests/kvm/Makefile.kvm | 20 ++++++++++----------
>  2 files changed, 11 insertions(+), 13 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 9bc2eba1af1c..20af35a91d6f 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -6,9 +6,7 @@ ARCH            ?= $(SUBARCH)
>  ifeq ($(ARCH),$(filter $(ARCH),arm64 s390 riscv x86 x86_64))
>  # Top-level selftests allows ARCH=x86_64 :-(
>  ifeq ($(ARCH),x86_64)
> -	ARCH_DIR := x86
> -else
> -	ARCH_DIR := $(ARCH)
> +	ARCH := x86
>  endif
>  include Makefile.kvm
>  else
> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
> index 9888dd6bb483..4277b983cace 100644
> --- a/tools/testing/selftests/kvm/Makefile.kvm
> +++ b/tools/testing/selftests/kvm/Makefile.kvm
> @@ -207,10 +207,10 @@ TEST_GEN_PROGS_riscv += steal_time
>  SPLIT_TESTS += arch_timer
>  SPLIT_TESTS += get-reg-list
>  
> -TEST_PROGS += $(TEST_PROGS_$(ARCH_DIR))
> -TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(ARCH_DIR))
> -TEST_GEN_PROGS_EXTENDED += $(TEST_GEN_PROGS_EXTENDED_$(ARCH_DIR))
> -LIBKVM += $(LIBKVM_$(ARCH_DIR))
> +TEST_PROGS += $(TEST_PROGS_$(ARCH))
> +TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(ARCH))
> +TEST_GEN_PROGS_EXTENDED += $(TEST_GEN_PROGS_EXTENDED_$(ARCH))
> +LIBKVM += $(LIBKVM_$(ARCH))
>  
>  OVERRIDE_TARGETS = 1
>  
> @@ -222,14 +222,14 @@ include ../lib.mk
>  INSTALL_HDR_PATH = $(top_srcdir)/usr
>  LINUX_HDR_PATH = $(INSTALL_HDR_PATH)/include/
>  LINUX_TOOL_INCLUDE = $(top_srcdir)/tools/include
> -LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH_DIR)/include
> +LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include
>  CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
>  	-Wno-gnu-variable-sized-type-not-at-end -MD -MP -DCONFIG_64BIT \
>  	-fno-builtin-memcmp -fno-builtin-memcpy \
>  	-fno-builtin-memset -fno-builtin-strnlen \
>  	-fno-stack-protector -fno-PIE -fno-strict-aliasing \
>  	-I$(LINUX_TOOL_INCLUDE) -I$(LINUX_TOOL_ARCH_INCLUDE) \
> -	-I$(LINUX_HDR_PATH) -Iinclude -I$(<D) -Iinclude/$(ARCH_DIR) \
> +	-I$(LINUX_HDR_PATH) -Iinclude -I$(<D) -Iinclude/$(ARCH) \
>  	-I ../rseq -I.. $(EXTRA_CFLAGS) $(KHDR_INCLUDES)
>  ifeq ($(ARCH),s390)
>  	CFLAGS += -march=z10
> @@ -273,7 +273,7 @@ LIBKVM_S_OBJ := $(patsubst %.S, $(OUTPUT)/%.o, $(LIBKVM_S))
>  LIBKVM_STRING_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_STRING))
>  LIBKVM_OBJS = $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ) $(LIBKVM_STRING_OBJ)
>  SPLIT_TEST_GEN_PROGS := $(patsubst %, $(OUTPUT)/%, $(SPLIT_TESTS))
> -SPLIT_TEST_GEN_OBJ := $(patsubst %, $(OUTPUT)/$(ARCH_DIR)/%.o, $(SPLIT_TESTS))
> +SPLIT_TEST_GEN_OBJ := $(patsubst %, $(OUTPUT)/$(ARCH)/%.o, $(SPLIT_TESTS))
>  
>  TEST_GEN_OBJ = $(patsubst %, %.o, $(TEST_GEN_PROGS))
>  TEST_GEN_OBJ += $(patsubst %, %.o, $(TEST_GEN_PROGS_EXTENDED))
> @@ -282,7 +282,7 @@ TEST_DEP_FILES += $(patsubst %.o, %.d, $(LIBKVM_OBJS))
>  TEST_DEP_FILES += $(patsubst %.o, %.d, $(SPLIT_TEST_GEN_OBJ))
>  -include $(TEST_DEP_FILES)
>  
> -$(shell mkdir -p $(sort $(OUTPUT)/$(ARCH_DIR) $(dir $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ))))
> +$(shell mkdir -p $(sort $(OUTPUT)/$(ARCH) $(dir $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ))))
>  
>  $(filter-out $(SPLIT_TEST_GEN_PROGS), $(TEST_GEN_PROGS)) \
>  $(TEST_GEN_PROGS_EXTENDED): %: %.o
> @@ -290,9 +290,9 @@ $(TEST_GEN_PROGS_EXTENDED): %: %.o
>  $(TEST_GEN_OBJ): $(OUTPUT)/%.o: %.c
>  	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
>  
> -$(SPLIT_TEST_GEN_PROGS): $(OUTPUT)/%: $(OUTPUT)/%.o $(OUTPUT)/$(ARCH_DIR)/%.o
> +$(SPLIT_TEST_GEN_PROGS): $(OUTPUT)/%: $(OUTPUT)/%.o $(OUTPUT)/$(ARCH)/%.o
>  	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $^ $(LDLIBS) -o $@
> -$(SPLIT_TEST_GEN_OBJ): $(OUTPUT)/$(ARCH_DIR)/%.o: $(ARCH_DIR)/%.c
> +$(SPLIT_TEST_GEN_OBJ): $(OUTPUT)/$(ARCH)/%.o: $(ARCH)/%.c
>  	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
>  
>  EXTRA_CLEAN += $(GEN_HDRS) \


-- 
BR,
Muhammad Usama Anjum

