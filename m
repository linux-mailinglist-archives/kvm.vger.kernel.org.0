Return-Path: <kvm+bounces-19614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B17C9907C91
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 21:27:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66AD2284793
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 19:27:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA22E14D290;
	Thu, 13 Jun 2024 19:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="bt2kt++M"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.smtpout.orange.fr (smtp-28.smtpout.orange.fr [80.12.242.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A152E2F50;
	Thu, 13 Jun 2024 19:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718306827; cv=none; b=m6BMcUDNeKBAvK6ejivKN+AjQuF8LaQB1tpiv2nhULHajaYxagMudcuCcTLUH3Ha/oIUTVBJeC2mNqNxk77gCL9gFagMiCQJsTus9OormP0ewHpgoyh2wwG1ExRMv2g6Sa5KuoZMklNGkFCxaCXf4/VytRXVmR9IJtwg3wYtOnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718306827; c=relaxed/simple;
	bh=iR03wWKlujeX7oOdXO4hQFtCxPJQYUULgYQx8HtY5iI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cNg8FlllpVtGe2WABRrP/uUTXdz7GC6okGoR+/PlUcc8E3asCcEj9q2FWQ7wJRYBdVyKowqBIu5zOXmgs2gsIuCyRNpOu3C10XYt+DTXcIY+amNamST2MXFLWcMj7AF7uSdMwMpkdc4waSkVuoABOJP4phDOyAAMNP2fKmRu68Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=bt2kt++M; arc=none smtp.client-ip=80.12.242.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Received: from [192.168.1.37] ([86.243.222.230])
	by smtp.orange.fr with ESMTPA
	id Hq4qsiAmMO9H2Hq4qsXnUo; Thu, 13 Jun 2024 21:25:46 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1718306746;
	bh=i69oGBBhy0DC1WVgyNfTe6OgxIKEj9+3O3Ybv1aCn9k=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=bt2kt++MjIGHTLasfpb9q50eNs/DUe0MQ++Ow6JSJUxzSXCCG7vU7h1TN6R3EpsRZ
	 7TZ4OEFW78PN1u9lbKZ65HP9kAL8GOUk8Fibdk0aa/OS9PUvwbi8yXCecBK+4XGM04
	 xJKhVKcNAE/kP/0BEEqh3dkiPj0itZJbqQc5Kbv0/ROw9H2YsMAG0Csr/eSCFTROB4
	 4yWab3Od5/VdPkF76i9hNsQyYxiz+DdueiO2TSLOyN0ax+Ltr4tSZizEvr6iMeHrvr
	 xctTObEO5CLNnCHlIEq47//xb5rQFjPI+ZyGziACCLce01b3SBtMx/biziGum3dqzg
	 b2ubYSj96+zDQ==
X-ME-Helo: [192.168.1.37]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 13 Jun 2024 21:25:46 +0200
X-ME-IP: 86.243.222.230
Message-ID: <115973a9-caa6-4d53-a477-dea2d2291598@wanadoo.fr>
Date: Thu, 13 Jun 2024 21:25:38 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: Remove duplicated zero clear with dirty_bitmap
 buffer
To: Bibo Mao <maobibo@loongson.cn>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240613125407.1126587-1-maobibo@loongson.cn>
Content-Language: en-MW
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20240613125407.1126587-1-maobibo@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 13/06/2024 à 14:54, Bibo Mao a écrit :
> Since dirty_bitmap pointer is allocated with function __vcalloc(),
> there is __GFP_ZERO flag set in the implementation about this function
> __vcalloc_noprof(). It is not necessary to clear dirty_bitmap buffer
> with zero again.
> 
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>   virt/kvm/kvm_main.c | 3 ---
>   1 file changed, 3 deletions(-)
> 

Hi,

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 14841acb8b95..c7d4a041dcfa 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1669,9 +1669,6 @@ static int kvm_prepare_memory_region(struct kvm *kvm,
>   			r = kvm_alloc_dirty_bitmap(new);
>   			if (r)
>   				return r;
> -
> -			if (kvm_dirty_log_manual_protect_and_init_set(kvm))
> -				bitmap_set(new->dirty_bitmap, 0, new->npages);

unless I miss something obvious, this does not clear anything, but set 
all bits to 1.

0 is not for "write 0" (i.e. clear), but for "start at offset 0".
So all bits are set to 1 in this case.

CJ

>   		}
>   	}
>   
> 
> base-commit: 83a7eefedc9b56fe7bfeff13b6c7356688ffa670


