Return-Path: <kvm+bounces-21855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8382F9350D7
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 18:45:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 27E501F2256C
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 16:45:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E75A91459E1;
	Thu, 18 Jul 2024 16:45:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE48714372D;
	Thu, 18 Jul 2024 16:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721321110; cv=none; b=sz2vBcYmPqGDVMNj+gUU7xEmE2iCEeXU0PfArjS76A5GooyBD1bzbTFmQc6qRXiu8r6TzKLz9dCC9qApiPzv4F1r6KqaYsc2ZukkP6uUUnQ3rvd3TjlSm+aeK2Ssgtngw+KYmIcTgWeg5JgafThkiO+gcJVaihimz7HCdy6HJh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721321110; c=relaxed/simple;
	bh=ho4kXrb83dG7s2zTkRmierlLx/1L8Hdnc7xDarwrA6Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rzM2HLH+sKV/X2esjVgIO/pk6uOqFfuXJL6gLLxW2fGBsrIP6+KTfAXP+0YB22KxrupqK4FloIP+JnzmJ6jc3SL/BFz2O2V/nOZ4Ly1wMIO8R6Tkgxr0oTdkOsPHtQnlKtsd9VeHj1Q2lm1LTm5Rh0EB2HGhIWUMtCvJmQcyZSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr; spf=pass smtp.mailfrom=ghiti.fr; arc=none smtp.client-ip=217.70.183.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id C9676FF808;
	Thu, 18 Jul 2024 16:45:00 +0000 (UTC)
Message-ID: <6908e437-bf1c-4fae-bb34-b5c30dae97ff@ghiti.fr>
Date: Thu, 18 Jul 2024 18:45:00 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/4] dt-bindings: riscv: Add Svade and Svadu Entries
Content-Language: en-US
To: Yong-Xuan Wang <yongxuan.wang@sifive.com>, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org,
 kvm@vger.kernel.org
Cc: greentime.hu@sifive.com, vincent.chen@sifive.com,
 Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 devicetree@vger.kernel.org
References: <20240712083850.4242-1-yongxuan.wang@sifive.com>
 <20240712083850.4242-3-yongxuan.wang@sifive.com>
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <20240712083850.4242-3-yongxuan.wang@sifive.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-Sasl: alex@ghiti.fr

On 12/07/2024 10:38, Yong-Xuan Wang wrote:
> Add entries for the Svade and Svadu extensions to the riscv,isa-extensions
> property.
>
> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> ---
>   .../devicetree/bindings/riscv/extensions.yaml | 28 +++++++++++++++++++
>   1 file changed, 28 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
> index 468c646247aa..e91a6f4ede38 100644
> --- a/Documentation/devicetree/bindings/riscv/extensions.yaml
> +++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
> @@ -153,6 +153,34 @@ properties:
>               ratified at commit 3f9ed34 ("Add ability to manually trigger
>               workflow. (#2)") of riscv-time-compare.
>   
> +        - const: svade
> +          description: |
> +            The standard Svade supervisor-level extension for SW-managed PTE A/D
> +            bit updates as ratified in the 20240213 version of the privileged
> +            ISA specification.
> +
> +            Both Svade and Svadu extensions control the hardware behavior when
> +            the PTE A/D bits need to be set. The default behavior for the four
> +            possible combinations of these extensions in the device tree are:
> +            1) Neither Svade nor Svadu present in DT => It is technically
> +               unknown whether the platform uses Svade or Svadu. Supervisor
> +               software should be prepared to handle either hardware updating
> +               of the PTE A/D bits or page faults when they need updated.
> +            2) Only Svade present in DT => Supervisor must assume Svade to be
> +               always enabled.
> +            3) Only Svadu present in DT => Supervisor must assume Svadu to be
> +               always enabled.
> +            4) Both Svade and Svadu present in DT => Supervisor must assume
> +               Svadu turned-off at boot time. To use Svadu, supervisor must
> +               explicitly enable it using the SBI FWFT extension.
> +
> +        - const: svadu
> +          description: |
> +            The standard Svadu supervisor-level extension for hardware updating
> +            of PTE A/D bits as ratified at commit c1abccf ("Merge pull request
> +            #25 from ved-rivos/ratified") of riscv-svadu. Please refer to Svade
> +            dt-binding description for more details.
> +
>           - const: svinval
>             description:
>               The standard Svinval supervisor-level extension for fine-grained


Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>

Thanks,

Alex


