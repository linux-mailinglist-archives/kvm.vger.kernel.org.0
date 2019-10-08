Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21942CFF35
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 18:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728734AbfJHQrA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 12:47:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33528 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725966AbfJHQrA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 12:47:00 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CB8192026F
        for <kvm@vger.kernel.org>; Tue,  8 Oct 2019 16:46:59 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id b6so9437706wrw.2
        for <kvm@vger.kernel.org>; Tue, 08 Oct 2019 09:46:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L/V1/+YV0YRnUvVx+rL2Yqx0LkkiPHAbp4PRzsPp/b8=;
        b=grMqV1JnByV6uviQPVbX4Pj51KF0LncOXI5xMnuaQbh9yH+yx+W2pgml+8tMDUQHzP
         YvVR6Oj5020mDuLGqt7EwRqDKzoDkEAktro6xDDlZUqI5XxfeCvp106NspLnUl2s3N5Y
         jI89JLQAamAnVtR1/y0NA8A/lhRSaiJaBXSyIJ9Ksh048lpi9zxDPDW/y15w8TsW6Qsa
         pQxfXQVmOeythUCzue1Cc07eYLU8arB2gVZBtGQtUU+7cWo3kLD0dcFlrZ3Bel8vPZRH
         StxjOiomwz6e+uAPiWRrxEXpHcICcRfSjm6ICKQxP1AVaWVU4nCsO932zCLsOUaoT6PR
         tHVA==
X-Gm-Message-State: APjAAAVzRn5vAPvE7th92YyuwMy3CrM6gNcyRfnA9D3JdyZi9vrGXRcl
        Vd0zfdld6s9gg+JDxavw8Z5MvG4z2Sn9F00xNTmVA+4jKazIsUiZ1SyebPeqkdosbtBT1hOkIkA
        Kk0s20b6rEcRY
X-Received: by 2002:a7b:ce0a:: with SMTP id m10mr4543523wmc.121.1570553218257;
        Tue, 08 Oct 2019 09:46:58 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw8oIBt/ym677QA6bp7JZzkq5d06i53XQCy+rRUyx5s3kfyBRnvGsy+Duv8cHPeYi12/EFomg==
X-Received: by 2002:a7b:ce0a:: with SMTP id m10mr4543512wmc.121.1570553218000;
        Tue, 08 Oct 2019 09:46:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f4b0:55d4:57da:3527? ([2001:b07:6468:f312:f4b0:55d4:57da:3527])
        by smtp.gmail.com with ESMTPSA id u4sm6889623wmg.41.2019.10.08.09.46.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Oct 2019 09:46:57 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] x86: svm: run svm.flat unit tests with
 -cpu host
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Jack Wang <jack.wang.usish@gmail.com>,
        Nadav Amit <nadav.amit@gmail.com>
References: <20191008163829.1003-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <781ec80b-3aee-9979-05a8-e1482612df8a@redhat.com>
Date:   Tue, 8 Oct 2019 18:46:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191008163829.1003-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/10/19 18:38, Vitaly Kuznetsov wrote:
> With -cpu qemu64 we skip many good tests (next_rip, npt_*) and
> tsc_adjust is failing. VMX tests already use '-cpu host'.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  x86/unittests.cfg | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index 8156256146c3..e7aa1e9844f1 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -198,7 +198,7 @@ arch = x86_64
>  [svm]
>  file = svm.flat
>  smp = 2
> -extra_params = -cpu qemu64,+svm
> +extra_params = -cpu host,+svm
>  arch = x86_64
>  
>  [taskswitch]
> 

Queued, thanks.

Paolo
