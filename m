Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E72C283AFF
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 17:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728641AbgJEPjL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 11:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727758AbgJEPi7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Oct 2020 11:38:59 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F231C0613A7;
        Mon,  5 Oct 2020 08:38:59 -0700 (PDT)
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id E21D62E4;
        Mon,  5 Oct 2020 15:38:58 +0000 (UTC)
Date:   Mon, 5 Oct 2020 09:38:56 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Li Qiang <liq3ea@163.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        liq3ea@gmail.com
Subject: Re: [PATCH] Documentation: kvm: fix a typo
Message-ID: <20201005093856.61f1bef2@lwn.net>
In-Reply-To: <20201002150422.6267-1-liq3ea@163.com>
References: <20201002150422.6267-1-liq3ea@163.com>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  2 Oct 2020 08:04:22 -0700
Li Qiang <liq3ea@163.com> wrote:

> Fixes: 9824c83f92bc8 ("Documentation: kvm: document CPUID bit for MSR_KVM_POLL_CONTROL")
> Signed-off-by: Li Qiang <liq3ea@163.com>
> ---
>  Documentation/virt/kvm/cpuid.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
> index a7dff9186bed..9150e9d1c39b 100644
> --- a/Documentation/virt/kvm/cpuid.rst
> +++ b/Documentation/virt/kvm/cpuid.rst
> @@ -78,7 +78,7 @@ KVM_FEATURE_PV_SEND_IPI           11          guest checks this feature bit
>                                                before enabling paravirtualized
>                                                sebd IPIs
>  
> -KVM_FEATURE_PV_POLL_CONTROL       12          host-side polling on HLT can
> +KVM_FEATURE_POLL_CONTROL          12          host-side polling on HLT can
>                                                be disabled by writing
>                                                to msr 0x4b564d05.

Applied, thanks.

jon
