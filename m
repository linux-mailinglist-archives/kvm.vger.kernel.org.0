Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9CF4189B85
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 13:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgCRMDE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 08:03:04 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:58988 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726619AbgCRMDD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Mar 2020 08:03:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584532982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WQ9EBNaQhs0t/szRuDFEPEknOlYpsQ9VuOO5/nV1c3g=;
        b=IAUsOoRXMkxk3BUzgud9CnoV+jtNmvAN7khrM1K+BBC1aUfWvE3HUhzag5pZMdfFaSS13p
        TMNyRVgoiRegTrUthUR4ArTeMM4oWpRJ4ouYTl56p2BSdyHygDyUtR+YgZfdLDnQoTZ0kN
        0AKwq2ktaGotHJJQc74RRMpasVqHz9U=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-qgzh4TaNNHupytTUYNtc5g-1; Wed, 18 Mar 2020 08:03:00 -0400
X-MC-Unique: qgzh4TaNNHupytTUYNtc5g-1
Received: by mail-wr1-f69.google.com with SMTP id c3so501101wrx.13
        for <kvm@vger.kernel.org>; Wed, 18 Mar 2020 05:03:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WQ9EBNaQhs0t/szRuDFEPEknOlYpsQ9VuOO5/nV1c3g=;
        b=E8KFgpvE55i6Fxg8TKm0f5wxWjr8+iHQ9InRylAntWcvyNeCaXI6W/OCVkGoyLtfDq
         KLNA0UNUIqBhuEHfIP5NBANfyBKMFD3JleEgkDp1JSzUcPzokYvAElGb+KPPaodI5URH
         YeWO/LcDbMSWGERx1mZwKUD6MMy+nsB1/kO9cHa1wBCkWlrQIlrGzH2jpixqyi1fbEhH
         ig6gR6bV+xCN7u87Z9bzr7UTqkvpUpzUV+MCbcWw/BHdOdOrNKnOXzoLARWopKwebqdx
         0w9JYUezevRSwmNJHmF7rplNHAvwUUW1IVfkL3OKbgDP2O6DSLQ+uus5zswF0Ljj/P5r
         ZOXA==
X-Gm-Message-State: ANhLgQ0FU4cX3PLYLf2HK6EhSGOL3V1w9TBOIA1AXHNEYeBViRH2ONWC
        sYIn6kyZYmRTyZhiEr0Cf3q6eQhyjiwISJoRKjxCSxtU+eh95f1y003yRQVdiJrXRKzOSTnVzrz
        ctu40m/IQgeK5
X-Received: by 2002:adf:ed06:: with SMTP id a6mr5312269wro.346.1584532979318;
        Wed, 18 Mar 2020 05:02:59 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvFP+VmlsRq553UuUqN07YGoTpDPnzLWBE7tDKXtkoHSHoqWnj1dMTG7ipKJhtmIcbtdtddvA==
X-Received: by 2002:adf:ed06:: with SMTP id a6mr5312254wro.346.1584532979025;
        Wed, 18 Mar 2020 05:02:59 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.15.43])
        by smtp.gmail.com with ESMTPSA id d63sm3589120wmd.44.2020.03.18.05.02.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2020 05:02:58 -0700 (PDT)
Subject: Re: [PATCH] kvm-unit-test: nSVM: Restructure nSVM test code
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
References: <20200205205026.16858-1-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8ba27d4d-5a3d-5ef4-43e9-821e46d87281@redhat.com>
Date:   Wed, 18 Mar 2020 13:02:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200205205026.16858-1-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/02/20 21:50, Krish Sadhukhan wrote:
> This patch restructures the test code for nSVM in order to match its
> counterpart nVMX. This restructuring effort separates the test infrastructure
> from the test code and puts them in different files. This will make it
> easier to add future tests, both SVM and nSVM, as well as maintain them.
> 
> 
> [PATCH] kvm-unit-test: nSVM: Restructure nSVM test code
> 
>  x86/Makefile.x86_64 |    1 +
>  x86/svm.c           | 1718 +++++++--------------------------------------------
>  x86/svm.h           |   52 +-
>  x86/svm_tests.c     | 1279 ++++++++++++++++++++++++++++++++++++++
>  4 files changed, 1551 insertions(+), 1499 deletions(-)
> 
> Krish Sadhukhan (1):
>       nSVM: Restructure nSVM test code
> 

Merged, thanks.

Paolo

