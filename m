Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32CB4B50C3
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 16:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728710AbfIQOwR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 10:52:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45312 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727708AbfIQOwR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 10:52:17 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BC81CC04BD48
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 14:52:16 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id t11so1188316wro.10
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 07:52:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LKcUVwO1sdRtpluTQr2J32+/AFRPR470aZtrdtqZOVA=;
        b=BH5BKLg69BP/+PjrJOTOPq1H/loQkyaEmP9xMYUg115IriOdKObcqAyPO9ej0m99sa
         7nubqhcOJm1XQMYagAXiklU5WdmLG3Bs3wDmzx7UjTKYJVZUOnjA5TK7MRIBhioPWHXK
         hMf87KnNCJmKhJxqOdn9XGYoabtOeHGIZ6K8lb99M9O4xpKSF1IBZGNb/x01ZxiAoszf
         YyEie48qTSOQAkLY0MH3kz3JzwouoL+SZh4YYyxoW4Y+hF9D5zphDpp/VGNE3Wmqz14L
         at+aoPH7aIIddrnymjXCQqajWrOoXnt3BxviU+cwtNvJQkpKEH1geBAfXRMi92oaL9LC
         YKRw==
X-Gm-Message-State: APjAAAXoWd4S2m+RzzdAPP2UR8tQPjOo2Oq3EjdulX5J/FkVCTftnWrS
        mf0bl3tA8HxwxYfHh2gURXeUD4BxfE1vv1kKosCbOW1uN6gjW24YOQr8+Fe60xPj3+bCWzdkUst
        vphXMHJooBub0
X-Received: by 2002:a1c:48d5:: with SMTP id v204mr4118895wma.109.1568731935363;
        Tue, 17 Sep 2019 07:52:15 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzAXgHcnqOs807aoMAmXxDh+uEdRnh717s6RCf8PO2ct39gLVsq07/zzLh622Q0fiqQ/5v73g==
X-Received: by 2002:a1c:48d5:: with SMTP id v204mr4118880wma.109.1568731935126;
        Tue, 17 Sep 2019 07:52:15 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c46c:2acb:d8d2:21d8? ([2001:b07:6468:f312:c46c:2acb:d8d2:21d8])
        by smtp.gmail.com with ESMTPSA id m16sm3201785wml.11.2019.09.17.07.52.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Sep 2019 07:52:14 -0700 (PDT)
Subject: Re: [PATCH 0/2] KVM: nVMX: Check Host Address Space Size on vmentry
 of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, jmattson@google.com
References: <20190809192620.29318-1-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <2399bced-d88b-bd2d-c5f7-63de39d7bd96@redhat.com>
Date:   Tue, 17 Sep 2019 16:52:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190809192620.29318-1-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/08/19 21:26, Krish Sadhukhan wrote:
> Patch# 1 adds the necessary KVM checks while patch# 2 adds the kvm-unit-tests.
> Note that patch# 2 only tests those scenarios in which the "Host Address-Space
> Size" VM-Exit control field can only be 1 as nested guests are 64-bit only.
> 
> 
> [PATCH 1/2] KVM: nVMX: Check Host Address Space Size on vmentry of nested
> [PATCH 2/2] kvm-unit-test: nVMX: Check Host Address Space Size on vmentry of nested
> 
>  arch/x86/kvm/vmx/nested.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> Krish Sadhukhan (1):
>       nVMX: Check Host Address Space Size on vmentry of nested guests
> 
>  x86/vmx_tests.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 63 insertions(+)
> 
> Krish Sadhukhan (1):
>       nVMX: Check Host Address Space Size on vmentry of nested guests
> 

Queued, thanks.

Paolo
