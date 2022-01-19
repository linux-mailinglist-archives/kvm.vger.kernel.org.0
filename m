Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8EC8494003
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 19:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356803AbiASSfM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 13:35:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:58377 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1356805AbiASSfL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Jan 2022 13:35:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642617310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9Z79Qp+002+pJ4Ykx31vhrjoqnpJIZnn6NLEoaYOPdk=;
        b=fySPhDUxStGE/A8S6QEmY3l+xtyC6NXuAJSPDOtTX9bN8Zh2YOhimAlxZIkMEvQ9C00wug
        xP+kwaabh4K86RNtYvTRHaZN26c7Ti/Y2MjNf7BS3oeqiqj7+ktdDXyfWpWtfTpNYIADxN
        iFVN4tEwThJFpfsYLU451StvyPKPgLE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-413-ThmBQRsCMaiCb__voRTfJw-1; Wed, 19 Jan 2022 13:35:09 -0500
X-MC-Unique: ThmBQRsCMaiCb__voRTfJw-1
Received: by mail-wm1-f69.google.com with SMTP id bg23-20020a05600c3c9700b0034bb19dfdc0so1618627wmb.1
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 10:35:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9Z79Qp+002+pJ4Ykx31vhrjoqnpJIZnn6NLEoaYOPdk=;
        b=RXsrjikJm0xwJgU71Qr1HrFmlpa1WT/mxrtOyviVgaWfYO6fA8u9kH/UqHBPRocr55
         4bFBfWr2j7KKzjCxijA921HuN30ek3jfx+02f/keecmGxSE2ItumzG6QJIqy1QR1kjwV
         Rc9qiOFx7so3MUFz0edj7mgQtWG+XfkCpPsa5exy+Yeph7Sp+gxuqOu50jnbHsnUOJsy
         kGtGhqU/pVoY6aLkZicmgQJADWs0Fp7X0xUDBWICPFnbYEUFot0E155GLi/bNR5A1m/w
         B8WFoNBW8RHI2mF0raepvMteqRs8q7ALq0stL9ljULkb7TNtwf3HgRBIjNWKbhjP2tCa
         QkiA==
X-Gm-Message-State: AOAM532FRxfuyKZtHxguqzKxb2WuZwQQ9nLTZkB3ZG+Q7EZkDzmOIMLJ
        ZAK6rCYS45RNN5JFk7YOoKegqIfyEJax/RP8SCqQD3ky8qNaAabmNGw9dXBdpz325MLETcrMN9l
        RecDP8mYJowbs
X-Received: by 2002:a05:600c:4f11:: with SMTP id l17mr3420078wmq.112.1642617308259;
        Wed, 19 Jan 2022 10:35:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy0E304zG90AbsabSR0kmrOUy2+enT5zJtpaNGQSKunOGBGyOLgRC6Oe/BawbeeG97K6eFpZA==
X-Received: by 2002:a05:600c:4f11:: with SMTP id l17mr3420065wmq.112.1642617308077;
        Wed, 19 Jan 2022 10:35:08 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id r2sm870573wrz.76.2022.01.19.10.35.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jan 2022 10:35:07 -0800 (PST)
Message-ID: <990cf64b-1515-df67-5691-fd45c71abc3a@redhat.com>
Date:   Wed, 19 Jan 2022 19:35:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 0/2] kvm selftest cleanup
Content-Language: en-US
To:     Yang Zhong <yang.zhong@intel.com>, kvm@vger.kernel.org
Cc:     seanjc@google.com
References: <20220118140144.58855-1-yang.zhong@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220118140144.58855-1-yang.zhong@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/18/22 15:01, Yang Zhong wrote:
> Patch 1 to sync KVM_CAP_XSAVE2 to 208, and patch 2 only cleanup
> processor.c file with tabs as Sean requested before. Those two
> patches were based on latest Linux release(commit id: e3a8b6a1e70c).
> 
> Yang Zhong (2):
>    kvm: selftests: Sync KVM_CAP_XSAVE2 from linux header
>    kvm: selftests: Use tabs to replace spaces
> 
>   tools/include/uapi/linux/kvm.h                |  2 +-
>   .../selftests/kvm/lib/x86_64/processor.c      | 70 +++++++++----------
>   2 files changed, 36 insertions(+), 36 deletions(-)
> 

Hi,

I sent a slightly more complete version of both patches.

Thanks,

Paolo

