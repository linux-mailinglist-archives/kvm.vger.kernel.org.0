Return-Path: <kvm+bounces-15967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D46D8B281A
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 20:18:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5328DB2329F
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 18:18:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4260815250E;
	Thu, 25 Apr 2024 18:16:41 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EF821482EF;
	Thu, 25 Apr 2024 18:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714069000; cv=none; b=AIHf9bS3JtJS5/BRUbAD3Ktoz/gcZvKxsEKJSYv5dMFD2LgeUJuvn+YVrie2XvdKjWp2IRx2/tMtgYhsOFgnrJ8LaIYfkdRI7a3nk+zT2qAiKvm9VJY+6lwqvNkrdAr97SGpNsypzMVT2UYjxzjpaDEicER1DT0+eq+hcsb4hlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714069000; c=relaxed/simple;
	bh=osvQDcfth2oHBETtvgsqxTXc9soDQsyNFetTLK7ImU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XiVus0btIHkrkT33QLOFkrA/yGpSnFIz3GEHQ08BbmPzIlz2xH1Zs6XmWgJAmrHrlFxoI4VRp9FXH41vRZLlX5cub+8jtW8QlcKvDP5gFaDOhwX5TVFkNWa83vSERMdzTqKuYL/Zq1u73RdswmDUU/k6mPffYKKQmSm5CCBGkL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 41D731007;
	Thu, 25 Apr 2024 11:17:04 -0700 (PDT)
Received: from NH27D9T0LF (unknown [10.57.56.86])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 336303F793;
	Thu, 25 Apr 2024 11:16:32 -0700 (PDT)
Date: Thu, 25 Apr 2024 20:16:28 +0200
From: Emanuele Rocca <emanuele.rocca@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kernel test robot <lkp@intel.com>, Steven Price <steven.price@arm.com>,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, llvm@lists.linux.dev,
	oe-kbuild-all@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH v2 09/14] arm64: Enable memory encrypt for Realms
Message-ID: <Ziqd_OHm8_rQNuxV@NH27D9T0LF>
References: <20240412084213.1733764-10-steven.price@arm.com>
 <202404151003.vkNApJiS-lkp@intel.com>
 <f11e6d5d-d2b9-400e-96c3-5d1ded827720@arm.com>
 <5bba262f-6d30-417b-8a6f-fc03b86c47bd@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5bba262f-6d30-417b-8a6f-fc03b86c47bd@arm.com>

Hi,

On 2024-04-25 05:29, Suzuki K Poulose wrote:
> Emmanuele reports that these need to be exported as well, something
> like:
> 
> 
> diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
> index 229b6d9990f5..de3843ce2aea 100644
> --- a/arch/arm64/mm/pageattr.c
> +++ b/arch/arm64/mm/pageattr.c
> @@ -228,11 +228,13 @@ int set_memory_encrypted(unsigned long addr, int
> numpages)
>  {
>         return __set_memory_encrypted(addr, numpages, true);
>  }
> +EXPORT_SYMBOL_GPL(set_memory_encrypted);
> 
>  int set_memory_decrypted(unsigned long addr, int numpages)
>  {
>         return __set_memory_encrypted(addr, numpages, false);
>  }
> +EXPORT_SYMBOL_GPL(set_memory_decrypted);
> 
>  #ifdef CONFIG_DEBUG_PAGEALLOC
>  void __kernel_map_pages(struct page *page, int numpages, int enable

Indeed, without exporting the symbols I was getting this build failure:

 ERROR: modpost: "set_memory_encrypted" [drivers/hv/hv_vmbus.ko] undefined!
 ERROR: modpost: "set_memory_decrypted" [drivers/hv/hv_vmbus.ko] undefined!

I can now build 6.9-rc1 w/ CCA guest patches if I apply Suzuki's
changes:

1) move set_memory_encrypted/decrypted from asm/mem_encrypt.h to
   asm/set_memory.h
2) export both symbols in mm/pageattr.c

See diff below.

Thanks,
  Emanuele

diff --git a/arch/arm64/include/asm/mem_encrypt.h b/arch/arm64/include/asm/mem_encrypt.h
index 7381f9585321..e47265cd180a 100644
--- a/arch/arm64/include/asm/mem_encrypt.h
+++ b/arch/arm64/include/asm/mem_encrypt.h
@@ -14,6 +14,4 @@ static inline bool force_dma_unencrypted(struct device *dev)
        return is_realm_world();
 }

-int set_memory_encrypted(unsigned long addr, int numpages);
-int set_memory_decrypted(unsigned long addr, int numpages);
 #endif
diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include/asm/set_memory.h
index 0f740b781187..9561b90fb43c 100644
--- a/arch/arm64/include/asm/set_memory.h
+++ b/arch/arm64/include/asm/set_memory.h
@@ -14,4 +14,6 @@ int set_direct_map_invalid_noflush(struct page *page);
 int set_direct_map_default_noflush(struct page *page);
 bool kernel_page_present(struct page *page);

+int set_memory_encrypted(unsigned long addr, int numpages);
+int set_memory_decrypted(unsigned long addr, int numpages);
 #endif /* _ASM_ARM64_SET_MEMORY_H */
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index 229b6d9990f5..de3843ce2aea 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -228,11 +228,13 @@ int set_memory_encrypted(unsigned long addr, int numpages)
 {
        return __set_memory_encrypted(addr, numpages, true);
 }
+EXPORT_SYMBOL_GPL(set_memory_encrypted);

 int set_memory_decrypted(unsigned long addr, int numpages)
 {
        return __set_memory_encrypted(addr, numpages, false);
 }
+EXPORT_SYMBOL_GPL(set_memory_decrypted);

 #ifdef CONFIG_DEBUG_PAGEALLOC
 void __kernel_map_pages(struct page *page, int numpages, int enable)

