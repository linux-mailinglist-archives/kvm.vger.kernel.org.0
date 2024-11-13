Return-Path: <kvm+bounces-31779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DF1F69C7888
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 17:16:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9CCDD2860EB
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 16:16:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E9C04D8A3;
	Wed, 13 Nov 2024 16:15:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619A73214;
	Wed, 13 Nov 2024 16:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731514527; cv=none; b=ua5TbBouaU7yb25Z54nmof3SQpkBLR5nArqX/Ruf4OudK2sfRpRpsnt8hl7RPr/Ssj8zt7V6DAWHy79pzCM/+4y+nrfa0sB5itWoUcgBPlJ6+AypSAK68IqlJJqwLY2g9g2PT24HEyKyB82lbCpckprS0+pGOOMlpGf5jXoZB6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731514527; c=relaxed/simple;
	bh=Et2OQrt7QfZfer35DfenxBJwk+yqUJBiNr5T+VABZmM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pRoGXi/ioFSfGhK6mQ7mCXY9nF/lVc00nBPfRcPt6QphBTdo2pbtkEOx3aS/ZhjryxdZTqGZSkjmB49JfX6qHVxLbPo0X3oCQ0suK+Uj5EAqr/e/zWJ9z0f1WqTyZA7o0OJ3AiabXcZq44mjQmPKVolHV3AT6qUMpSrI3phawCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr; spf=pass smtp.mailfrom=ghiti.fr; arc=none smtp.client-ip=217.70.183.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 959321BF20A;
	Wed, 13 Nov 2024 16:15:20 +0000 (UTC)
Message-ID: <eb8f399b-fa09-47fd-8102-9b65b0839dd5@ghiti.fr>
Date: Wed, 13 Nov 2024 17:15:20 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/3] dt-bindings: riscv: Add Svukte entry
Content-Language: en-US
To: Max Hsu <max.hsu@sifive.com>, Conor Dooley <conor@kernel.org>,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>
Cc: Palmer Dabbelt <palmer@sifive.com>, linux-riscv@lists.infradead.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Samuel Holland <samuel.holland@sifive.com>
References: <20240920-dev-maxh-svukte-rebase-v1-0-7864a88a62bd@sifive.com>
 <20240920-dev-maxh-svukte-rebase-v1-1-7864a88a62bd@sifive.com>
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <20240920-dev-maxh-svukte-rebase-v1-1-7864a88a62bd@sifive.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-Sasl: alex@ghiti.fr

Hi Max,

On 20/09/2024 09:39, Max Hsu wrote:
> Add an entry for the Svukte extension to the riscv,isa-extensions
> property.
>
> Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
> Signed-off-by: Max Hsu <max.hsu@sifive.com>
> ---
>   Documentation/devicetree/bindings/riscv/extensions.yaml | 7 +++++++
>   1 file changed, 7 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
> index a06dbc6b4928958704855c8993291b036e3d1a63..df96aea5e53a70b0cb8905332464a42a264e56e6 100644
> --- a/Documentation/devicetree/bindings/riscv/extensions.yaml
> +++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
> @@ -171,6 +171,13 @@ properties:
>               memory types as ratified in the 20191213 version of the privileged
>               ISA specification.
>   
> +        - const: svukte
> +          description:
> +            The standard Svukte supervisor-level extensions for making user-mode


s/extensions/extension


> +            accesses to supervisor memory raise page faults in constant time,
> +            mitigating attacks that attempt to discover the supervisor
> +            software's address-space layout, as PR#1564 of riscv-isa-manual.
> +
>           - const: zacas
>             description: |
>               The Zacas extension for Atomic Compare-and-Swap (CAS) instructions
>

You'll need a new version for the proper commit sha1 once it gets 
ratified anyway, so with the typo fixed, you can add:

Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>

Thanks,

Alex


