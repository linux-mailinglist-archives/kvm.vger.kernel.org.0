Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2F4B117268
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2019 18:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbfLIRFn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Dec 2019 12:05:43 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56991 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726408AbfLIRFn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Dec 2019 12:05:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575911141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wIL9P9E+t0Af0cB2lnnGX6O0iOj+o/yCtp56yQPQwkQ=;
        b=EwdI6Sjpz58nDF6eCBW3Xxa/xaG/KB1vkHoM7rqakJXJdluKNRJ894NVPVqAbuYSx6bgQ7
        W5G8NNPTQNBTEXNCS6UGInl6S4gywdP+sY30WuK/Ol/TCHqvL4oXD2X7vE60NEf6QSG9l2
        ziAtD6YFh8z6SsCVgaA6VlQHA2FiyVE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-YS7EUktANNKAVTN8AmBIpA-1; Mon, 09 Dec 2019 12:05:38 -0500
Received: by mail-wr1-f70.google.com with SMTP id l20so7793600wrc.13
        for <kvm@vger.kernel.org>; Mon, 09 Dec 2019 09:05:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wIL9P9E+t0Af0cB2lnnGX6O0iOj+o/yCtp56yQPQwkQ=;
        b=aAWPlRe+ntLoPDPOgsa7zVJYms4UBCuPf1prQdgbrs3aEctj8c8XLrxu88WDd3Kk7t
         ihLt+vkibSusF3ERX+1H99hI5QKDmuHs1sqftgXOKlgqeqako+dLpB4UEhnF+gne1W92
         uAZJdIkhrk4RRSpdTu6JtVkkfkjMWNm92aQCkIeHyBiY4r2DT04miKFZAjg1FxnFFOCR
         w2Ve8OS5fYx9bZBVgSjfs3SgWDy15g4BewYEMSgSYYAK+haQDwO5RkY0iG9uNRVkM4Ej
         l2Dg/CDMJS836HJe6KHhbwn9sAx8fsR4+m2o5kThfHUyTQHyIcSaYDODz/2PExU3JK5x
         8Y6w==
X-Gm-Message-State: APjAAAX3aK+4zTSMiTw85a64ekykmseUHkg++KFL/LkyUasuVqIS/wLi
        lcwKnHxD4Aex60I5GXnD5wytnQjiYcEqSkmx8Fs3IliSSu4JENmtUC8dUw8ZQgLn5Tu/fcjRjwx
        K2JhCyvp4txIN
X-Received: by 2002:a7b:c74c:: with SMTP id w12mr34135wmk.1.1575911137566;
        Mon, 09 Dec 2019 09:05:37 -0800 (PST)
X-Google-Smtp-Source: APXvYqxKwynLR6vYeRDh6BKaDO4EA5HcVr4+oiiNnycyJhRCVOHGm6bTC7g+DgAPIxwaEfhVjnQv4w==
X-Received: by 2002:a7b:c74c:: with SMTP id w12mr34113wmk.1.1575911137320;
        Mon, 09 Dec 2019 09:05:37 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id x18sm72699wrr.75.2019.12.09.09.05.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Dec 2019 09:05:36 -0800 (PST)
Subject: Re: [PATCH 0/2] use jump label to handle resource release in
 irq_bypass_register_*
To:     linmiaohe <linmiaohe@huawei.com>, alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1575600833-12839-1-git-send-email-linmiaohe@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2900fcd4-f08e-0508-8b6a-4e7d82fbba78@redhat.com>
Date:   Mon, 9 Dec 2019 18:05:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1575600833-12839-1-git-send-email-linmiaohe@huawei.com>
Content-Language: en-US
X-MC-Unique: YS7EUktANNKAVTN8AmBIpA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/12/19 03:53, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> Use out_err jump label to help handle resource release.
> It's a good practice to release resource in one place
> and help eliminate some duplicated code.
> 
> Miaohe Lin (2):
>   KVM: lib: use jump label to handle resource release in
>     irq_bypass_register_consumer()
>   KVM: lib: use jump label to handle resource release in
>     irq_bypass_register_producer()
> 
>  virt/lib/irqbypass.c | 38 ++++++++++++++++++++------------------
>  1 file changed, 20 insertions(+), 18 deletions(-)
> 

Queued, thanks.

Paolo

