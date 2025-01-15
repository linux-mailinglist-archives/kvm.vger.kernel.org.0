Return-Path: <kvm+bounces-35488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C0125A1164F
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 01:58:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6EE9C3A6C92
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 00:58:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A76F5D8F0;
	Wed, 15 Jan 2025 00:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rFiEz9sd"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B239741760;
	Wed, 15 Jan 2025 00:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736902655; cv=none; b=e5lrfhNWPgibkCQG/0VBrDjGIPmFG6tttuazpZIqoeueKJEmZms+Rrj7MEDV78MP2WjWGsfaRe5lTJlDK7En3f9/FsAqAU7MwVt1NiQ5LGSo8Tjw1k1wpWMxhgfG7MBcAwAD/nGvjvzD705rHE9+UujoMADqL1BpYYvmaW1AcQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736902655; c=relaxed/simple;
	bh=l+9twYi0Uwgk+vxDb18woIEDFmtH67VIxPOkzuSyE9I=;
	h=Date:Content-Type:MIME-Version:From:Cc:To:In-Reply-To:References:
	 Message-Id:Subject; b=BcX+ukWMq+cCgH+1K1MmtE4zqH/qaPvjRl4/q5qGY0b+Ut3c8OG9bpTPAmb7YMp407gt/afi20nZ+26kDh4rriLPxABDaJmwOTN9zNtF3DUn5dLDx1B55mrvIU40UAaqjQIEAynwW10hI00MQXSLD6pjLR6SqDo+Tx+x5nGRYUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rFiEz9sd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC13EC4CEE6;
	Wed, 15 Jan 2025 00:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736902655;
	bh=l+9twYi0Uwgk+vxDb18woIEDFmtH67VIxPOkzuSyE9I=;
	h=Date:From:Cc:To:In-Reply-To:References:Subject:From;
	b=rFiEz9sdhNL1vEEfFmlCwjSPfCJhRy58Tc5CsvZ05oGqRKI6H+gGqCXvMFxcwcYZg
	 wQvdQgnB4miB73msApRp2XtVaIaznh/qWrPzZ30oWn8usbxBva2Y3t6cIUDkUxtT7u
	 65qG2n2zNlS1V92zM5bQlfH1dMSY513GmD1wxhNPs6GRfmgT4SUl3Eu5/FO+Vgwu5W
	 6CdBe8WoS53Q6akeOV6W3AArLH8y3iPvf5vp9NNQTdXpZM4/aSxoxvvARE+OJ4t8eM
	 cWUAGlUtsX8m8POXWpXpKNlL0h4bn2zhxixyMxVeHzUsElPzgyuhpEqiojgv97JHLZ
	 ZMD5n7EiLgGtA==
Date: Tue, 14 Jan 2025 18:57:33 -0600
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Rob Herring (Arm)" <robh@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, Peter Zijlstra <peterz@infradead.org>, 
 Mark Rutland <mark.rutland@arm.com>, linux-riscv@lists.infradead.org, 
 weilin.wang@intel.com, Will Deacon <will@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Anup Patel <anup@brainfault.org>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>, 
 Ingo Molnar <mingo@redhat.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Ian Rogers <irogers@google.com>, linux-perf-users@vger.kernel.org, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@sifive.com>, Conor Dooley <conor@kernel.org>, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Conor Dooley <conor+dt@kernel.org>, Atish Patra <atishp@atishpatra.org>, 
 kvm@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
 kvm-riscv@lists.infradead.org
To: Atish Patra <atishp@rivosinc.com>
In-Reply-To: <20250114-counter_delegation-v2-10-8ba74cdb851b@rivosinc.com>
References: <20250114-counter_delegation-v2-0-8ba74cdb851b@rivosinc.com>
 <20250114-counter_delegation-v2-10-8ba74cdb851b@rivosinc.com>
Message-Id: <173690265103.2069740.11443232308035656965.robh@kernel.org>
Subject: Re: [PATCH v2 10/21] dt-bindings: riscv: add Smcntrpmf ISA
 extension description


On Tue, 14 Jan 2025 14:57:35 -0800, Atish Patra wrote:
> Add the description for Smcntrpmf ISA extension
> 
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  Documentation/devicetree/bindings/riscv/extensions.yaml | 7 +++++++
>  1 file changed, 7 insertions(+)
> 

My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:

dtschema/dtc warnings/errors:


doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20250114-counter_delegation-v2-10-8ba74cdb851b@rivosinc.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.


