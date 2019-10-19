Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5BADD78E
	for <lists+kvm@lfdr.de>; Sat, 19 Oct 2019 10:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbfJSI7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Oct 2019 04:59:05 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45159 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbfJSI7F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Oct 2019 04:59:05 -0400
Received: by mail-pg1-f195.google.com with SMTP id r1so4670459pgj.12
        for <kvm@vger.kernel.org>; Sat, 19 Oct 2019 01:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=9P1Hc5zx6KpRJ1G0QDp0Is0b1Emh/h9sENDo50qYI+0=;
        b=SLFAWYRRuzx0BVXm1R600VMfhtaXBl6PtH7su/FogBYhDtCIjomJmM39OqKr6+Wbwe
         gTusfVa5GpPt+Qj7S24AfwOjwWhMvz/nBeioFA4uAerjvZsdmP2o58lmAFSE/Xke42Vx
         aQZ6ELf9LeXI0LTYqr0+TuJkrmbOwZPxD1l5WhUn5ejUJepWWv29MATcr/I2WV4OzCU5
         DZv1G5Ns7MYGsI0isGkelC4SlvkeCNAiOA2khWCUQ620NEKAAxSgRmcm+YsSaGUi1mJf
         0cjlEryBk6hVzBw6ZjdmeTTsf5Xap7lI3a/D2f3vwvUdheBqOwEOApbEIb80dsJSjiZA
         c9Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=9P1Hc5zx6KpRJ1G0QDp0Is0b1Emh/h9sENDo50qYI+0=;
        b=kTs4MBF4rk+wzYtR1/7gzgPs7fjOmb4G1xCF4S/RKobn1MDM73fSnzRo1qH1gfUcOv
         ksKPKjfRSs0WJeiE2qCYwYSnBz5CBLOEqzF/c+gZosvpXNCeSjjRRTUGquBLihSL+Wmk
         Gjp9x7bqOFdL36plJrlhpiCHoOKAZoyV9HrqzaOHeg8rWmbtBquX5j+It7QRdkmJJcjW
         0XtS7gl8G2p8kv/tFt+jUJCOlr98riXyYQi2COyZALcsn6X0p968XEqrOo/l5XHgeYis
         quk/yCTfhx0Iz66sPozPw2gUf9c+gGB0rcJZXAk6cQ8opF5+Rzidzbz7K0uYSz2suXKv
         /vbg==
X-Gm-Message-State: APjAAAWcMALIlBLzlKOPEjfanwpUpIDNXRGuYaLGtjmzoAP0FzyJx7sq
        TA07laOQdXqQVN59j/FJD44x3g==
X-Google-Smtp-Source: APXvYqx01bELy8Vsdb65I8HmRPcBNWlKJoUuWytBKnuVV3b6pEgQDNnpTSe5QSXLIHzXuDLGD24tpg==
X-Received: by 2002:aa7:9156:: with SMTP id 22mr11523471pfi.246.1571475543864;
        Sat, 19 Oct 2019 01:59:03 -0700 (PDT)
Received: from [2620:15c:17:3:3a5:23a7:5e32:4598] ([2620:15c:17:3:3a5:23a7:5e32:4598])
        by smtp.gmail.com with ESMTPSA id y20sm4045137pge.48.2019.10.19.01.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2019 01:59:02 -0700 (PDT)
Date:   Sat, 19 Oct 2019 01:59:02 -0700 (PDT)
From:   David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To:     "Kalra, Ashish" <Ashish.Kalra@amd.com>
cc:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
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
Subject: Re: [PATCH] crypto: ccp - Retry SEV INIT command in case of integrity
 check failure.
In-Reply-To: <20191017223459.64281-1-Ashish.Kalra@amd.com>
Message-ID: <alpine.DEB.2.21.1910190156210.140416@chino.kir.corp.google.com>
References: <20191017223459.64281-1-Ashish.Kalra@amd.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 17 Oct 2019, Kalra, Ashish wrote:

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
> 
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index 6b17d179ef8a..f9318d4482f2 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -1064,6 +1064,18 @@ void psp_pci_init(void)
>  
>  	/* Initialize the platform */
>  	rc = sev_platform_init(&error);
> +	if (rc && (error == SEV_RET_SECURE_DATA_INVALID)) {
> +		/*
> +		 * INIT command returned an integrity check failure
> +		 * status code, meaning that firmware load and
> +		 * validation of SEV related persistent data has
> +		 * failed and persistent state has been erased.
> +		 * Retrying INIT command here should succeed.
> +		 */
> +		dev_dbg(sp->dev, "SEV: retrying INIT command");
> +		rc = sev_platform_init(&error);
> +	}
> +
>  	if (rc) {
>  		dev_err(sp->dev, "SEV: failed to INIT error %#x\n", error);
>  		return;

Curious why this isn't done in __sev_platform_init_locked() since 
sev_platform_init() can be called when loading the kvm module and the same 
init failure can happen that way.

> diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
> index 8654b2442f6a..a8537f4e5e08 100644
> --- a/include/uapi/linux/psp-sev.h
> +++ b/include/uapi/linux/psp-sev.h
> @@ -58,6 +58,9 @@ typedef enum {
>  	SEV_RET_HWSEV_RET_PLATFORM,
>  	SEV_RET_HWSEV_RET_UNSAFE,
>  	SEV_RET_UNSUPPORTED,
> +	SEV_RET_INVALID_PARAM,
> +	SEV_RET_RESOURCE_LIMIT,
> +	SEV_RET_SECURE_DATA_INVALID,
>  	SEV_RET_MAX,
>  } sev_ret_code;
>  
