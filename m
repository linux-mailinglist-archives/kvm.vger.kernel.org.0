Return-Path: <kvm+bounces-8949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AF2BA858CFC
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 03:34:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E24321C21094
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 02:34:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 559211CA9B;
	Sat, 17 Feb 2024 02:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TAdqEnNF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6401BF38;
	Sat, 17 Feb 2024 02:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708137219; cv=none; b=Lp5ycs5obvBQxqQjwMTC24dF+uA+bxHogLs8KCjG6Zg+IXnvb8m80R3j1WM4kcDBX5ps40YXx4ou0WHBr2DtVxnl6xS0KbW2CZD7sSmQL3qaJ/Uc6woST5u75l1xSFPcWBIlgmaxIqd4b+3dOCBQkpzpaE50sNR7l4+gRPXzFI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708137219; c=relaxed/simple;
	bh=haW+Geg9Bw9o5VNvbhSkBi54T3SIdZhLVbkvZSHVfug=;
	h=Date:Content-Type:MIME-Version:From:To:Cc:In-Reply-To:References:
	 Message-Id:Subject; b=PswhJY4oeBbpKj4AZBl/qlbryXA2FquNbEjAhrOxWd99Q3C58Hj88WOHKXZjk/1DUGb+xh3YK6LstDc29hu786uKF3kg31VvtlXXCFrppBroHB4x+uPLzmer9m70Py0TQWSrGJmXyvp3mkrUlVpmFWNoEWiSBGT678kL/hz/Lmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TAdqEnNF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0062DC433C7;
	Sat, 17 Feb 2024 02:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708137219;
	bh=haW+Geg9Bw9o5VNvbhSkBi54T3SIdZhLVbkvZSHVfug=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=TAdqEnNFcSJfD3bOPI1EINwJx7FszBiVIwFOA3zMEaTkObGLRoZjOTratYn0b5Nna
	 yZfq/eY/nLs4qzPIKZ95OQQeGjSEySP3+ozJAt+oYBhtm82DoOZVXeMQsDo4X7hDmp
	 N6FxBrhpr+h8Jd0Sn7oyVjyHAUXKLCjkSiHAnyfmS8BjHEDO7N6BqwS5eHCW6mT8EJ
	 zrChd9I6JCiTMnmILWmQdOdy6Asx+wLWJCenXaEfEt9z1DU/bUxMqgtb6zGwl4pBdl
	 QAJLMWDV2TuvtZ9Jm++JJzBIHs88GYcFNOoR2yVm17FRw7wzFc6SJhbnF8D+Xzm2+R
	 6wwPzFNws8HGw==
Date: Fri, 16 Feb 2024 20:33:38 -0600
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Rob Herring <robh@kernel.org>
To: Atish Patra <atishp@rivosinc.com>
Cc: Guo Ren <guoren@kernel.org>, 
 Ji Sheng Teoh <jisheng.teoh@starfivetech.com>, 
 linux-perf-users@vger.kernel.org, Weilin Wang <weilin.wang@intel.com>, 
 Ian Rogers <irogers@google.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
 Heiko Stuebner <heiko@sntech.de>, Yang Jihong <yangjihong1@huawei.com>, 
 =?utf-8?q?Cl=C3=A9ment_L=C3=A9ger?= <cleger@rivosinc.com>, 
 kvm-riscv@lists.infradead.org, Evan Green <evan@rivosinc.com>, 
 Christian Brauner <brauner@kernel.org>, 
 John Garry <john.g.garry@oracle.com>, 
 Ley Foon Tan <leyfoon.tan@starfivetech.com>, 
 Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@kernel.org>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, 
 Andrew Jones <ajones@ventanamicro.com>, 
 Kan Liang <kan.liang@linux.intel.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, kvm@vger.kernel.org, 
 Alexandre Ghiti <alexghiti@rivosinc.com>, Jonathan Corbet <corbet@lwn.net>, 
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
 Jing Zhang <renyu.zj@linux.alibaba.com>, 
 Peter Zijlstra <peterz@infradead.org>, linux-doc@vger.kernel.org, 
 Samuel Holland <samuel.holland@sifive.com>, 
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, kaiwenxue1@gmail.com, 
 Conor Dooley <conor@kernel.org>, Rob Herring <robh+dt@kernel.org>, 
 linux-riscv@lists.infradead.org, devicetree@vger.kernel.org, 
 James Clark <james.clark@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
 linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>
In-Reply-To: <20240217005738.3744121-11-atishp@rivosinc.com>
References: <20240217005738.3744121-1-atishp@rivosinc.com>
 <20240217005738.3744121-11-atishp@rivosinc.com>
Message-Id: <170813721439.1034411.7264728567495824984.robh@kernel.org>
Subject: Re: [PATCH RFC 10/20] dt-bindings: riscv: add Smcntrpmf ISA
 extension description


On Fri, 16 Feb 2024 16:57:28 -0800, Atish Patra wrote:
> Add the description for Smcntrpmf ISA extension
> 
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  Documentation/devicetree/bindings/riscv/extensions.yaml | 7 +++++++
>  1 file changed, 7 insertions(+)
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:


doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20240217005738.3744121-11-atishp@rivosinc.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.


