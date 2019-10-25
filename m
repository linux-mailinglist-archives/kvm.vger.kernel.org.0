Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 060D3E5014
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 17:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440697AbfJYP0D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 11:26:03 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:36044 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731226AbfJYP0C (ORCPT <rfc822;kvm@vger.kernel.orG>);
        Fri, 25 Oct 2019 11:26:02 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iO1TE-0001r6-Vm; Fri, 25 Oct 2019 23:25:45 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iO1T9-0007so-Kt; Fri, 25 Oct 2019 23:25:39 +0800
Date:   Fri, 25 Oct 2019 23:25:39 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Kalra, Ashish" <Ashish.Kalra@amd.com>
Cc:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "allison@lohutok.net" <allison@lohutok.net>,
        "info@metux.net" <info@metux.net>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] crypto: ccp - Retry SEV INIT command in case of
 integrity check failure.
Message-ID: <20191025152539.tkiqe22ixftkbpul@gondor.apana.org.au>
References: <20191017223459.64281-1-Ashish.Kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017223459.64281-1-Ashish.Kalra@amd.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 17, 2019 at 10:35:11PM +0000, Kalra, Ashish wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> SEV INIT command loads the SEV related persistent data from NVS
> and initializes the platform context. The firmware validates the
> persistent state. If validation fails, the firmware will reset
> the persisent state and return an integrity check failure status.
> 
> At this point, a subsequent INIT command should succeed, so retry
> the command. The INIT command retry is only done during driver
> initialization.
> 
> Additional enums along with SEV_RET_SECURE_DATA_INVALID are added
> to sev_ret_code to maintain continuity and relevance of enum values.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/crypto/ccp/psp-dev.c | 12 ++++++++++++
>  include/uapi/linux/psp-sev.h |  3 +++
>  2 files changed, 15 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
