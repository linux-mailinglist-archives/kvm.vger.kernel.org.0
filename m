Return-Path: <kvm+bounces-20211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4FE0911DD6
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 10:07:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5FD1F283D50
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 08:07:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7950816F0E0;
	Fri, 21 Jun 2024 07:56:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7F6169AD5;
	Fri, 21 Jun 2024 07:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718956580; cv=none; b=UvBvtYd0BDLTUo4i3bAs9KjfGwD0nLx1naL6Ba4QJyFFAc7IGil2KEgjQzsstaBZ9O/13ZAgDKa6szs3h7la87OxD2npMdLArPnaHsQDypf9eFASs+foOHPqkBFjfKRE6nLAf/1nOoxEQP5HV1FYmRJfIpAa+qPUpY0YzzLdP+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718956580; c=relaxed/simple;
	bh=CsFufhOFqjnMj7rvVP4i0ao+HsmJtJeZf7aJzAnmHUM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b3lF/aFpOIRU34ebZ0fYEDXI7ezt1jT0H1WRj7lsHlO01scKV1qr7MXf9/pfj+khQgnjgYHlx3C2RZPyuY2VgEe1bV3uCJ5HO7Mv3/4kIC71QdgU9MdPaHmxa2XnoOKeeCiSYFdr4oGLD+5tCVISJlKKs4m0/emrDIfRZdpURw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr; spf=pass smtp.mailfrom=ghiti.fr; arc=none smtp.client-ip=217.70.183.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id F00E7240004;
	Fri, 21 Jun 2024 07:56:06 +0000 (UTC)
Message-ID: <1ade7f97-d837-428d-b056-f0a3121b0c71@ghiti.fr>
Date: Fri, 21 Jun 2024 09:56:05 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/4] dt-bindings: riscv: Add Svade and Svadu Entries
Content-Language: en-US
To: Yong-Xuan Wang <yongxuan.wang@sifive.com>, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org,
 kvm@vger.kernel.org
Cc: apatel@ventanamicro.com, ajones@ventanamicro.com,
 greentime.hu@sifive.com, vincent.chen@sifive.com,
 Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 devicetree@vger.kernel.org
References: <20240605121512.32083-1-yongxuan.wang@sifive.com>
 <20240605121512.32083-3-yongxuan.wang@sifive.com>
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <20240605121512.32083-3-yongxuan.wang@sifive.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-Sasl: alex@ghiti.fr

On 05/06/2024 14:15, Yong-Xuan Wang wrote:
> Add entries for the Svade and Svadu extensions to the riscv,isa-extensions
> property.
>
> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> ---
>   .../devicetree/bindings/riscv/extensions.yaml | 30 +++++++++++++++++++
>   1 file changed, 30 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
> index 468c646247aa..1e30988826b9 100644
> --- a/Documentation/devicetree/bindings/riscv/extensions.yaml
> +++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
> @@ -153,6 +153,36 @@ properties:
>               ratified at commit 3f9ed34 ("Add ability to manually trigger
>               workflow. (#2)") of riscv-time-compare.
>   
> +        - const: svade
> +          description: |
> +            The standard Svade supervisor-level extension for raising page-fault
> +            exceptions when PTE A/D bits need be set


Maybe something like:

"The standard Svade supervisor-level extension for SW-managed PTE A/D 
bit updates as ratified..."

would be better, WDYT?


> as ratified in the 20240213
> +            version of the privileged ISA specification.
> +
> +            Both Svade and Svadu extensions control the hardware behavior when
> +            the PTE A/D bits need to be set. The default behavior for the four
> +            possible combinations of these extensions in the device tree are:
> +            1. Neither svade nor svadu in DT: default to svade.
> +            2. Only svade in DT: use svade.
> +            3. Only svadu in DT: use svadu.
> +            4. Both svade and svadu in DT: default to svade (Linux can switch to
> +               svadu once the SBI FWFT extension is available).
> +
> +        - const: svadu
> +          description: |
> +            The standard Svadu supervisor-level extension for hardware updating
> +            of PTE A/D bits as ratified at commit c1abccf ("Merge pull request
> +            #25 from ved-rivos/ratified") of riscv-svadu.
> +
> +            Both Svade and Svadu extensions control the hardware behavior when
> +            the PTE A/D bits need to be set. The default behavior for the four
> +            possible combinations of these extensions in the device tree are:
> +            1. Neither svade nor svadu in DT: default to svade.
> +            2. Only svade in DT: use svade.
> +            3. Only svadu in DT: use svadu.
> +            4. Both svade and svadu in DT: default to svade (Linux can switch to
> +               svadu once the SBI FWFT extension is available).


I would not duplicate this text, but rather say something like "Please 
refer to Svade dt-binding description for more details.".


> +
>           - const: svinval
>             description:
>               The standard Svinval supervisor-level extension for fine-grained

