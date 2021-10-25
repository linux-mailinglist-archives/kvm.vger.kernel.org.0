Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCAB0439648
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 14:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233070AbhJYM1i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 08:27:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58893 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232951AbhJYM1h (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Oct 2021 08:27:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635164715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=18r9doZrRUt+BZbjEGhEOloW0CqhcTxE7FqwLW3Bz2k=;
        b=hqdsRpzfGFcYRNI71ni+PV9L7mZ902W9cwpp/kzVKzrBnH42Z/4PohX9xCX7OAaM8MqfMn
        cz8GS429fnatk95P/Zmh+O0/OArfS9CaRAz/e8PnOUCejfv/lbccxj56Qo0pkRPfMXdEZj
        1fDnBymR6NJCJTenxZAwCKtshOqXsw4=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-566-oUCcMcJbP_eukkRc05QGXg-1; Mon, 25 Oct 2021 08:25:14 -0400
X-MC-Unique: oUCcMcJbP_eukkRc05QGXg-1
Received: by mail-ed1-f72.google.com with SMTP id u10-20020a50d94a000000b003dc51565894so9670136edj.21
        for <kvm@vger.kernel.org>; Mon, 25 Oct 2021 05:25:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=18r9doZrRUt+BZbjEGhEOloW0CqhcTxE7FqwLW3Bz2k=;
        b=Yysvk0B4PXJGMzV6T8xrXHFTelBNwefV1+7OFqNckJp3gUDncftFnbG2Wr0neP/0ru
         3VsB15bhiewkz30KxtGNNq5r38CSxvmFVTuJ18U1BfwYAOBK7wH+xU/jq/vXSL9o/uIv
         /6acWcDMij3p0bobEqGkpXYgt0t2yWEZcGa2uVkZS7kgOLJIk+ZVbj+A6Ye5T1PHw5w5
         PVohshh23DUB0z2rVfg+6x/ybKu5CLcc/CUVunQVVcRlSy1wDFXR7z6wP5MQL+vHXBNv
         j8u0Kx/23dAqIZikKJybJLZfL2z673IfJplgpMYhrF25tq5+ZwUnrR+VsdAgApuVkRUz
         wTrA==
X-Gm-Message-State: AOAM531KhKSOyv3kr7UZbPqQvuzIkPhzD7H4iCQlnwh1OJ9zEXRfLAtt
        QujrL8EORwIoJW9nUOWE5z6Bi+OliKtZHh34jfFQML6WTQ58PeHXBTNGI7mIPvsKRPpXvefU+Zs
        UKzyHJABI2BPZ
X-Received: by 2002:a05:6402:5114:: with SMTP id m20mr25817493edd.256.1635164712941;
        Mon, 25 Oct 2021 05:25:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyDE2vtGk/FAnvNWNoKQg2UsRP1gq3GewEgLeJl6BRtSGccZejtvGjAdkUOW/VFxysNmyOaYw==
X-Received: by 2002:a05:6402:5114:: with SMTP id m20mr25817469edd.256.1635164712785;
        Mon, 25 Oct 2021 05:25:12 -0700 (PDT)
Received: from thuth.remote.csb (tmo-096-150.customers.d1-online.com. [80.187.96.150])
        by smtp.gmail.com with ESMTPSA id j11sm7341803ejt.114.2021.10.25.05.25.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 05:25:12 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v3 1/1] s390x: Add specification exception
 interception test
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janosch Frank <frankja@de.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20211022131057.1308851-1-scgl@linux.ibm.com>
 <20211022131057.1308851-2-scgl@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <e1448e42-3023-ec4f-8c57-bef4d1850b1a@redhat.com>
Date:   Mon, 25 Oct 2021 14:25:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211022131057.1308851-2-scgl@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/10/2021 15.10, Janis Schoetterl-Glausch wrote:
> Check that specification exceptions cause intercepts when
> specification exception interpretation is off.
> Check that specification exceptions caused by program new PSWs
> cause interceptions.
> We cannot assert that non program new PSW specification exceptions
> are interpreted because whether interpretation occurs or not is
> configuration dependent.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@de.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
>   s390x/Makefile             |  2 +
>   lib/s390x/sie.h            |  1 +
>   s390x/snippets/c/spec_ex.c | 21 ++++++++++
>   s390x/spec_ex-sie.c        | 82 ++++++++++++++++++++++++++++++++++++++
>   s390x/unittests.cfg        |  3 ++
>   5 files changed, 109 insertions(+)
>   create mode 100644 s390x/snippets/c/spec_ex.c
>   create mode 100644 s390x/spec_ex-sie.c

Thanks, I've pushed it to the repository now.

  Thomas

