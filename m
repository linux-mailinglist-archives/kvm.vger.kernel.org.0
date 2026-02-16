Return-Path: <kvm+bounces-71127-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YKjZMdM9k2kg2wEAu9opvQ
	(envelope-from <kvm+bounces-71127-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 16:54:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 48B74145D2E
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 16:54:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 62424303428F
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 15:52:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FB2D3321BE;
	Mon, 16 Feb 2026 15:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="O2+9IVzF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B45331237
	for <kvm@vger.kernel.org>; Mon, 16 Feb 2026 15:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771257177; cv=pass; b=RSiMnik4PWzQM20ycvOnH5Zx7mNSMVCLsIl0yz9MWrtwGCQ738sUVfnYDhsTW8hoC0awehrtVu7QoIIM8iBzPmwJ1QtkMGD4pYAycHfP1o8+QzzZpAS2L6L9DP/1W0VSyiSzSZd9vzcfvZzSvTKOwX410vdoDp5/itFphHMk6tE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771257177; c=relaxed/simple;
	bh=DVgZs0T8Bk7PTjBucWJPircNUuuYdnAroDO4LS4PT6Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e4JJOlwWZBiz8k8mTqbN6vTvOvgphEWJ7oUAAWYkYYuJYkLOSr4orV5mp9PYEXxUFV5wmSOvwAA9NuWCE4qFINo8YLOC86tW+8OVL4OUQmm9bV3lzKG8xdeaHHp/azy9/lCSe7x0FEtHo2Ns+TJPItk+6IVT16vJlivyWHKm8R0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=O2+9IVzF; arc=pass smtp.client-ip=74.125.224.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-64ad79df972so2900063d50.1
        for <kvm@vger.kernel.org>; Mon, 16 Feb 2026 07:52:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771257175; cv=none;
        d=google.com; s=arc-20240605;
        b=bO4qqE2ICIwBQ8bf2dAPUw0YmBEEUVsWf0QFKX5c063i6cNinBduGHCCQmCW7lu8Px
         CwuD2YOhB1SDFXpxvkYhA+WniQJpgw4BLTz9d5ObH3VnEgH9CsjhDfgfdazhPwbjn0QR
         NAcre4i1LzsbJpaLOoOEgJUVuj2MzSIpx+c3O0X44pQMMbso98mOD1hW26+36eBPSpVq
         D7m2/OT+wMYm7R2RDcrJj/hnggHpYvmparMS7rqaV0IUCNjS7zXVf6T0Mw7pslSQvuBe
         pV/9znmnbvcNHyV0i2A96OCyo7zcw4hMJDRffBXcHwLq3MqS76abZcbdkjH6awUcGJcQ
         QrjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=dP7OJCe4IFWPzF0ucWa9rG4RGTcEJ98iWAzWk9PebNw=;
        fh=4ukGYD/7fJ58gqTQi9uy+UhyAimvVb0OmmKmfedgkvo=;
        b=Y9nsyOZracgUvbEcX7+7SbSDBxPfq+flgtV/gNz65s79kCZ2P2+sjOwQk4ky2fZHb/
         rhafy63AAjz/Mc4oOPipNHL/NpKGnqP383cqc3O0FfzMl8KkIhR4+Hewk02y88c0byir
         g5Bgi0WqGdpkrH5Su/44LEvf4Vhx0lo+ZSsQtdxRj7S8Zt6fYQBERUDVYzxbnrMSEC+I
         cP4OeX6NyWJTApxe3p9xrpJUBjTRQ7dMXxD2B0QSJOp/GR6xZKa03EtA6mkSBhTz2RrL
         O6ZR7ILeqb5zuAAHIfGppoAYTnRLdWu8P0eixTdM2vOUHgrOJjsMsVvjjEloFBkBm+pt
         RNkg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771257175; x=1771861975; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dP7OJCe4IFWPzF0ucWa9rG4RGTcEJ98iWAzWk9PebNw=;
        b=O2+9IVzFq1nWFeKCq3Ri4SxxS83aJtL9kmCJRkcwnz+koWX4PHQC/dGZkCWyCKGX2o
         aKPsMTFcHm05Ll6QKJ+2+/eTWdWZqHzvtChvnBAcfiK2CDw1yFHqr4CZWD2HyR/Jknjb
         c2+ph3FPm1QVnXcJ87Kw6cOp+slbwWTVRGVOmrN8JHfDbIICm+S+QE4NNc3+/qcGYYk0
         iitOZiZB3stH+K4qpnhfD5wB/FxNO4AQPRwYKQfK3xxfPi4V5s+cAlHi+AURrxaYeqMK
         5rInWqgi7Kzkn6yRv5LqVufcCME8Pz8iaV1eOAfP7MkX0cX96cPxIETiUP16ABlVpAz3
         7+Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771257175; x=1771861975;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dP7OJCe4IFWPzF0ucWa9rG4RGTcEJ98iWAzWk9PebNw=;
        b=W6mrnrXXDpg6WeU7jlD9mSqXRSx5xPE7xdk8XVxF6n+AlnddUUH2O6VPfTf/kvMrUR
         /8PWu4A84B+WOV/GOytMolpV3KsTa7OhU/8honJN6F9r7e6ykzdNUuES2JtXF2F5nl1M
         kuBvwWXE1PWY/K3iBWnRDPk+NG8nF/D0aSWIWWGcpf+QzZxBxa+sQiFJZ7A1jmbr7dCJ
         kFIcsjnMHkAiOyrD9QJTgljCZHDj/+b3gxyI+CwQp60Q5mudJBTY3b6TfzL3RMhunLgE
         HdjMRv/IIZwEsOBtbnAIRdrfzomin0WG8DVLvd1wnE9Tp48o4FT5IPJbOrUUa4Y7Eph9
         Zwmg==
X-Forwarded-Encrypted: i=1; AJvYcCXNg4ovLYQCpc9ESARaY9yXbCZdsqDerI1dzfK4ev4q26ypM/KPuQG6U+fsskZGGlf3vDQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy47E57inFPPIHvDgTug+92fgafgRmYgGQq/GpqiH+eQiulkYjV
	/DfYZAeSqr1cDCKEkofjvsPxpaQTpjmqDTNJAH2U1tvm1GcnYnJUMgC7TIaFaY6jekJX0LhDbMU
	noEgGFcEa15TwZOLm1SuIgDLBOFdran3i0hJnlX8j8A==
X-Gm-Gg: AZuq6aJAXfd5HUsWjLU063/zwmv4FXomDzy9jgYj3DAdoV2SM+tMyt4iG7cxQb2o3iF
	Ru6uN4yy3hz8HzNCo1JV7t27CBBu0FX6eAslQZVGDa8qduZITjkPhcGRFFfM2FM76zSnr5MJS2g
	JFmltRMQHPjlwYwQ3WDfwQQC1itZ2J5DiVWkC2DYaOwloh0r32sQJsHW9MF+9YWNf+Wzq86vnDP
	UeDw/P5lcnGPljP1491mAWZQw7wQHv9SJLKkzLlGQ4MBAwUAdGdK/suepceKXtFpn8kKYm2TRT8
	1sBl/9CBDyxAWINElhtXyuEfvwpGdtM5tHArsT4bOsa2Mgn/Do0KnON2LpqYSVh/4HBpPrj+FJD
	S9w==
X-Received: by 2002:a05:690e:13c4:b0:64a:ee12:e7c3 with SMTP id
 956f58d0204a3-64c21b27b78mr6172226d50.49.1771257175307; Mon, 16 Feb 2026
 07:52:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260210201540.1405424-1-pierrick.bouvier@linaro.org>
 <93f8f250-7899-4528-b277-1ddd469c192c@linaro.org> <CAFEAcA9YUOxko51ziY3yAOaDfTCEAwqmXnifF=q_mkyotFHTcg@mail.gmail.com>
In-Reply-To: <CAFEAcA9YUOxko51ziY3yAOaDfTCEAwqmXnifF=q_mkyotFHTcg@mail.gmail.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 16 Feb 2026 15:52:44 +0000
X-Gm-Features: AZwV_Qhn_PA25doQjTID65lEcz5xT-1XaHevKcqNoTL7fZxazaWzkWciCHn6keY
Message-ID: <CAFEAcA8XCSjjb2opkf2A5WZwCa5THNswOOUO=fpj7kUJEc79qQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/12] target/arm: single-binary
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Cc: qemu-devel@nongnu.org, anjo@rev.ng, 
	Jim MacArthur <jim.macarthur@linaro.org>, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	=?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	qemu-arm@nongnu.org, Richard Henderson <richard.henderson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peter.maydell@linaro.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-71127-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linaro.org:email,linaro.org:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,gitlab.com:url,target-arm.next:url,mail.gmail.com:mid];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[linaro.org:+]
X-Rspamd-Queue-Id: 48B74145D2E
X-Rspamd-Action: no action

On Thu, 12 Feb 2026 at 10:59, Peter Maydell <peter.maydell@linaro.org> wrote:
>
> On Tue, 10 Feb 2026 at 20:19, Pierrick Bouvier
> <pierrick.bouvier@linaro.org> wrote:
> >
> > On 2/10/26 12:15 PM, Pierrick Bouvier wrote:
> > > This series continues cleaning target/arm, especially tcg folder.
> > >
> > > For now, it contains some cleanups in headers, and it splits helpers per
> > > category, thus removing several usage of TARGET_AARCH64.
> > > First version was simply splitting 32 vs 64-bit helpers, and Richard asked
> > > to split per sub category.
> > >
> > > v3
> > > --
> > >
> > > - translate.h: missing vaddr replacement
> > > - move tcg_use_softmmu to tcg/tcg-internal.h to avoid duplicating compilation
> > >    units between system and user builds.
> > > - eradicate TARGET_INSN_START_EXTRA_WORDS by calling tcg_gen_insn_start with
> > >    additional 0 parameters if needed.
> > >
> > > v2
> > > --
> > >
> > > - add missing kvm_enabled() in arm-qmp-cmds.c
> > > - didn't extract arm_wfi for tcg/psci.c. If that's a hard requirement, I can do
> > >    it in next version.
> > > - restricted scope of series to helper headers, so we can validate things one
> > >    step at a time. Series will keep on growing once all patches are reviewed.
> > > - translate.h: use vaddr where appropriate, as asked by Richard.
>
> > Patches 1-11 are reviewed and ready to be pulled.
>
> Looks like patch 12 has also now been reviewed, so I've applied
> the whole series to target-arm.next.

I meant to send this to the list, but accidentally sent it to
Pierrick only:

I just ran this (plus some other patches) through gitlab CI, and
it fails to build on the kvm-only and xen-only jobs:

https://gitlab.com/pm215/qemu/-/jobs/13131658696

In file included from /builds/pm215/qemu/include/exec/helper-gen.h.inc:9,
                 from /builds/pm215/qemu/include/exec/helper-gen-common.h:11,
                 from ../target/arm/helper.h:7,
                 from ../target/arm/helper.c:13:
/builds/pm215/qemu/include/tcg/tcg.h:35:10: fatal error: tcg-target.h:
No such file or directory
   35 | #include "tcg-target.h"
      |          ^~~~~~~~~~~~~~


https://gitlab.com/pm215/qemu/-/jobs/13131658593

In file included from /builds/pm215/qemu/include/exec/helper-gen.h.inc:9,
                 from /builds/pm215/qemu/include/exec/helper-gen-common.h:11,
                 from ../target/arm/helper.h:7,
                 from ../target/arm/debug_helper.c:11:
/builds/pm215/qemu/include/tcg/tcg.h:35:10: fatal error: tcg-target.h:
No such file or directory
    35 | #include "tcg-target.h"
       | ^~~~~~~~~~~~~~

I think the problem looks like it's in "move exec/helper-* plumbery to
helper.h", which has put the "emit the TCG gen_helper_foo inline
functions" into target/arm/helper.h, when they were previously
handled by target/arm/tcg/translate.h and so only in source files
that are part of the TCG translate-time code. helper.h only needs the
prototypes of the helper functions themselves.

Some of the other new helper-foo.h files look like they would
also have this problem, except they happen to only be included
from tcg files. For instance target/arm/helper-mve.h is only
included from files in target/arm/tcg (so it maybe could be
in target/arm/tcg itself).

I couldn't see an obvious easy fixup for this, so I'm afraid
I've removed the series from target-arm.next.

thanks
-- PMM

