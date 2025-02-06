Return-Path: <kvm+bounces-37455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0939CA2A357
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 09:39:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5D12B1611B5
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 08:39:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 368A7225796;
	Thu,  6 Feb 2025 08:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZREJ8x2z"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A32122488E;
	Thu,  6 Feb 2025 08:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738831161; cv=none; b=Ir+HAEQrAbMn23HXpxf9qVC6FYsEOKWh7NihgSms5RkVu9j5R4f/zewsomlZv/nNANR9fk91uv4hkeRIoU7mb4v14N3iCgglmCWB5HzjRIX+aEhBCbegwrwvxV0E3t7Ntw8SW9g7EpHqr/AvEosExe8IvRihsbSI0YbcfscEK4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738831161; c=relaxed/simple;
	bh=4EoQP8op2lAGcHar7BdkrcIMw40H7AoccbKxT2py+Qw=;
	h=Date:Content-Type:MIME-Version:From:Cc:To:In-Reply-To:References:
	 Message-Id:Subject; b=RnXzEzZUWWUEwOtMzlGm6vFSnG7y/rNr52TX8VLW/ubwpop8pcugRb04BZEaqK4wFtzc74bSIGCP0oe5jxo/PuoOysghvt8vYKHgzklazUX5HO0imyY03i/0NxwtFjtqySzyoBE83JbSNuFpeDcwAYL1sNAF/M5nWxv2ksLxH1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZREJ8x2z; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78557C4CEDD;
	Thu,  6 Feb 2025 08:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738831160;
	bh=4EoQP8op2lAGcHar7BdkrcIMw40H7AoccbKxT2py+Qw=;
	h=Date:From:Cc:To:In-Reply-To:References:Subject:From;
	b=ZREJ8x2zY6TIGZHCfl/84rBc0S2xinJlMJs2/w3GoQEOc8gA82c3EZaZA/1evU9Dw
	 SOEdkFtAWEQ+Pule34w3jSIfcjF/Q6U8Sl4THNRKWchC0T+7gTllGLGavdKOMYPnFV
	 dFETGh+TWLGqDKOn+UQ+gfsBACv+TAbbX6elvZCIrPm4zSrhjl5WlgrpRYneiX7ArY
	 sLH4awxLQr31h653xp03Vxh0ePK2IyGcruO/zYGGMQDLUU8TGuP5nDHe8Sy99nkZjc
	 gw7495UUpZsVzmLv8bz9eJaFihO1wlcvcqZ3yRpCu6Q2o9So3ObsZiJI0TbsCw/cxQ
	 bOfz0PQL1wEtQ==
Date: Thu, 06 Feb 2025 02:39:19 -0600
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Rob Herring (Arm)" <robh@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, weilin.wang@intel.com, 
 devicetree@vger.kernel.org, kvm@vger.kernel.org, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Conor Dooley <conor+dt@kernel.org>, Atish Patra <atishp@atishpatra.org>, 
 linux-riscv@lists.infradead.org, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Conor Dooley <conor@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Anup Patel <anup@brainfault.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Will Deacon <will@kernel.org>, Jiri Olsa <jolsa@kernel.org>, 
 kvm-riscv@lists.infradead.org, Ian Rogers <irogers@google.com>, 
 linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>, 
 Ingo Molnar <mingo@redhat.com>
To: Atish Patra <atishp@rivosinc.com>
In-Reply-To: <20250205-counter_delegation-v4-10-835cfa88e3b1@rivosinc.com>
References: <20250205-counter_delegation-v4-0-835cfa88e3b1@rivosinc.com>
 <20250205-counter_delegation-v4-10-835cfa88e3b1@rivosinc.com>
Message-Id: <173883115938.126290.3444587267516997369.robh@kernel.org>
Subject: Re: [PATCH v4 10/21] dt-bindings: riscv: add Counter delegation
 ISA extensions description


On Wed, 05 Feb 2025 23:23:15 -0800, Atish Patra wrote:
> Add description for the Smcdeleg/Ssccfg extension.
> 
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  .../devicetree/bindings/riscv/extensions.yaml      | 45 ++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
> 

My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/riscv/extensions.yaml: properties:riscv,isa-extensions:allOf:4: 'if' is a dependency of 'then'
	hint: Keywords must be a subset of known json-schema keywords
	from schema $id: http://devicetree.org/meta-schemas/keywords.yaml#
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/riscv/extensions.yaml: properties:riscv,isa-extensions:allOf:4: 'anyOf' conditional failed, one must be fixed:
	'If' is not one of ['$ref', 'additionalItems', 'additionalProperties', 'allOf', 'anyOf', 'const', 'contains', 'default', 'dependencies', 'dependentRequired', 'dependentSchemas', 'deprecated', 'description', 'else', 'enum', 'exclusiveMaximum', 'exclusiveMinimum', 'items', 'if', 'minItems', 'minimum', 'maxItems', 'maximum', 'multipleOf', 'not', 'oneOf', 'pattern', 'patternProperties', 'properties', 'required', 'then', 'typeSize', 'unevaluatedProperties', 'uniqueItems']
	'type' was expected
	from schema $id: http://devicetree.org/meta-schemas/keywords.yaml#
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/riscv/extensions.yaml: properties:riscv,isa-extensions:allOf:5: 'if' is a dependency of 'then'
	hint: Keywords must be a subset of known json-schema keywords
	from schema $id: http://devicetree.org/meta-schemas/keywords.yaml#
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/riscv/extensions.yaml: properties:riscv,isa-extensions:allOf:5: 'anyOf' conditional failed, one must be fixed:
	'If' is not one of ['$ref', 'additionalItems', 'additionalProperties', 'allOf', 'anyOf', 'const', 'contains', 'default', 'dependencies', 'dependentRequired', 'dependentSchemas', 'deprecated', 'description', 'else', 'enum', 'exclusiveMaximum', 'exclusiveMinimum', 'items', 'if', 'minItems', 'minimum', 'maxItems', 'maximum', 'multipleOf', 'not', 'oneOf', 'pattern', 'patternProperties', 'properties', 'required', 'then', 'typeSize', 'unevaluatedProperties', 'uniqueItems']
	'type' was expected
	from schema $id: http://devicetree.org/meta-schemas/keywords.yaml#

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20250205-counter_delegation-v4-10-835cfa88e3b1@rivosinc.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.


