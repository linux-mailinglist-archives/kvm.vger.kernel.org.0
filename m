Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B540B2744DC
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 16:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgIVO7L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 10:59:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27876 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726614AbgIVO7K (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 10:59:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600786749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FhMB5yyYZNB1qWJzcsUXinlb9ObQwU6S06iLfnb9Gwk=;
        b=aEwpYULIQ4swekTW5nivbnQLqUZxWknARtaKHP8gd7y7+g+uOKgluiEQVrxtBZ2ZXBlM/L
        juK7TQb0YkpgrVKmgSVIq6r/wNpeVgiZgvCbGXm6jcUElxoJx6IBqz9nOjlCCHouQFHxRF
        rnEO07BrvAPUNNpwdzQ/K9IGfCoWl+E=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-koLHCqCXPUGgM9wNJnHDzw-1; Tue, 22 Sep 2020 10:59:07 -0400
X-MC-Unique: koLHCqCXPUGgM9wNJnHDzw-1
Received: by mail-wm1-f70.google.com with SMTP id x6so1017635wmi.1
        for <kvm@vger.kernel.org>; Tue, 22 Sep 2020 07:59:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FhMB5yyYZNB1qWJzcsUXinlb9ObQwU6S06iLfnb9Gwk=;
        b=M05ojeAverG21PMSVWl9X1OOobXm6798lkrpcbCKKFaxVVz0UdlUC/IfGOHAV7Agy6
         DMByEaxX/W6lT5GZVKWsnx9iYnMcYQerZwtJzv0AvSwN2TbFox89jT3C6rKv+kmFJ38c
         Ulo5gKxUnxEjG54Lm6fWxWfO8FhwmaIfFdWb2h5bvdvBJFdtJ5kJ7SplC2Im55dQK8ue
         eTZ/4PmAcn+JAx7msI4n78khYQFrk2y4NerRNXqbS4YcVFTyAoE6h3oU/NHKRdi7r17Q
         H4tSvIXWO6AZtjY1NBLgVWDQIdYkvRZxKFvFIYm0rc9r/vT2gjTMBg7AVBei0sFSimZs
         N9WA==
X-Gm-Message-State: AOAM533Vy4TxGLX4VlPM3UCRkI0ytFSg+t8pMf6hZo0+QgaeZW2L+WvM
        JRFrMARN4JUKPCPSABGp6vmeqEXPU/buLwW5/fTK+1Kqr5XKEvxIRJrM1a32ewV//MprzLWwmpy
        nhDR+S7Uhlbl2
X-Received: by 2002:adf:e9c7:: with SMTP id l7mr3458768wrn.212.1600786746371;
        Tue, 22 Sep 2020 07:59:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxPRwg/C4oFJ45jouj/JKySQrFdcDAsv6x9BKrC+eS3QWVC/Yd6F1VbisyA/RQ5LTjmrGSltQ==
X-Received: by 2002:adf:e9c7:: with SMTP id l7mr3458746wrn.212.1600786746192;
        Tue, 22 Sep 2020 07:59:06 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec2c:90a9:1236:ebc6? ([2001:b07:6468:f312:ec2c:90a9:1236:ebc6])
        by smtp.gmail.com with ESMTPSA id q15sm26209795wrr.8.2020.09.22.07.59.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 07:59:05 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 0/2] Use same test names in the default
 and the TAP13 output format
To:     Marc Hartmayer <mhartmay@linux.ibm.com>, kvm@vger.kernel.org
Cc:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Andrew Jones <drjones@redhat.com>
References: <20200825102036.17232-1-mhartmay@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d62a5fc6-b476-0c7a-491e-e057c6ff4a38@redhat.com>
Date:   Tue, 22 Sep 2020 16:59:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200825102036.17232-1-mhartmay@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/08/20 12:20, Marc Hartmayer wrote:
> For everybody's convenience there is a branch:
> https://gitlab.com/mhartmay/kvm-unit-tests/-/tree/tap_v2
> 
> Changelog:
> v1 -> v2:
>  + added r-b's to patch 1
>  + patch 2:
>   - I've not added Andrew's r-b since I've worked in the comment from
>     Janosch (don't drop the first prefix)
> 
> Marc Hartmayer (2):
>   runtime.bash: remove outdated comment
>   Use same test names in the default and the TAP13 output format
> 
>  run_tests.sh         | 15 +++++++++------
>  scripts/runtime.bash |  9 +++------
>  2 files changed, 12 insertions(+), 12 deletions(-)
> 

Queued, thanks.

Paolo

