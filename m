Return-Path: <kvm+bounces-45005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09C02AA58D1
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 01:48:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E53B9C8168
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 23:47:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68A8122A7E1;
	Wed, 30 Apr 2025 23:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=rev.ng header.i=@rev.ng header.b="TKtaafEO"
X-Original-To: kvm@vger.kernel.org
Received: from rev.ng (rev.ng [94.130.142.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFAC0227E9F
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 23:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.130.142.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746056881; cv=none; b=gQuTYg5GVARU59f+MxeY7wFhIp5rcSyB5cdg0sRfpJpcVG0E3h6oma0c55BWAyHCnmMVeDnzG0LYnE1dXvqCc8B1A1JHQEabVPeuCvK4vSCsoUbZ1wZTOU2tvAVcAqitbS/cR+ifZRwPbsp/ylpnQmGXU6FhbhkoEoT0vxXPOE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746056881; c=relaxed/simple;
	bh=X2vtTb5B7V2pbVjv2mo550e8Cu4fJaqI0vOAi2rMqPw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aFNxdv2OY5oLCYGLDJGB3cLBJFZ1hFCEn7pLOraCFG7i46EpXZ8OanUoHxW3dSaqoTWzeVFF3tiOfpVbng59rU7TK2HwIDH8LOKuBbFCY43+MiD7rTZS1t4Mtl/YFKVFaCITte80eCadY0bEnvvF4d6I7YmYuop5rKtT5T6LtzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rev.ng; spf=pass smtp.mailfrom=rev.ng; dkim=pass (1024-bit key) header.d=rev.ng header.i=@rev.ng header.b=TKtaafEO; arc=none smtp.client-ip=94.130.142.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rev.ng
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rev.ng
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rev.ng;
	s=dkim; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
	:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive:List-Unsubscribe:List-Unsubscribe-Post:
	List-Help; bh=ODtBgca4sXD3KHTJuGek7w/NgcE5+epsaeewIw262FU=; b=TKtaafEOpGY8rbU
	U7EoTVA1oJ8lnIeS0eq9758xiq9F+d9lk8E6KX94/i0zgld/wKoKl2LrKfuJr7xgX6EtshRm3s7b7
	pLo7IsAaeFMMpRIbJre/nRIlYYN5ZToYQbB94mmnPe28o9g7EyY9ixuL0I637MqxVh8cNgy8RzlKh
	xQ=;
Date: Thu, 1 May 2025 01:49:06 +0200
From: Anton Johansson <anjo@rev.ng>
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Cc: qemu-devel@nongnu.org, qemu-arm@nongnu.org, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>, 
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>, alex.bennee@linaro.org, richard.henderson@linaro.org
Subject: Re: [PATCH v2 08/12] target/arm/cpu: remove TARGET_BIG_ENDIAN
 dependency
Message-ID: <jgakrza7l26w2xuf6q3avu3jpjk3wftrn7bvsjcfdgv2i4aalz@nbeabqxv5rkb>
References: <20250430145838.1790471-1-pierrick.bouvier@linaro.org>
 <20250430145838.1790471-9-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250430145838.1790471-9-pierrick.bouvier@linaro.org>

On 30/04/25, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>  target/arm/cpu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/target/arm/cpu.c b/target/arm/cpu.c
> index 07f279fec8c..37b11e8866f 100644
> --- a/target/arm/cpu.c
> +++ b/target/arm/cpu.c
> @@ -23,6 +23,7 @@
>  #include "qemu/timer.h"
>  #include "qemu/log.h"
>  #include "exec/page-vary.h"
> +#include "exec/tswap.h"
>  #include "target/arm/idau.h"
>  #include "qemu/module.h"
>  #include "qapi/error.h"
> @@ -1172,7 +1173,7 @@ static void arm_disas_set_info(CPUState *cpu, disassemble_info *info)
>  
>      info->endian = BFD_ENDIAN_LITTLE;
>      if (bswap_code(sctlr_b)) {
> -        info->endian = TARGET_BIG_ENDIAN ? BFD_ENDIAN_LITTLE : BFD_ENDIAN_BIG;
> +        info->endian = target_big_endian() ? BFD_ENDIAN_LITTLE : BFD_ENDIAN_BIG;
>      }
>      info->flags &= ~INSN_ARM_BE32;
>  #ifndef CONFIG_USER_ONLY
> -- 
> 2.47.2
> 

Reviewed-by: Anton Johansson <anjo@rev.ng>

