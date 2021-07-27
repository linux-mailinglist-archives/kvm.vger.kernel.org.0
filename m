Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40D633D6DE2
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 07:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234920AbhG0FQq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 01:16:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50100 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234905AbhG0FQo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Jul 2021 01:16:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627363004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GuOUsgjsv3LBv2ZWzdurVoq1rqwPXc4SiSA2qJZ61Yw=;
        b=chyH2etP2sci241YofCLYqFoD+SkAmiVMUKwO3+qTwosvcjpGs4sJwx8nvasIf3vQiO+Yc
        0fQZgorIt2fwQBMVwSXR+kjwaGmJnOX21G440QQXVVzgY2Fl6MmOP0rrA92EZfpQ3I+uEG
        L6KgrPRbOZbULkEtdlmJ3JLzIDDNQ4E=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-Tc2xfMAfN1K8kTgEedhWhQ-1; Tue, 27 Jul 2021 01:16:42 -0400
X-MC-Unique: Tc2xfMAfN1K8kTgEedhWhQ-1
Received: by mail-wm1-f71.google.com with SMTP id f142-20020a1c1f940000b029025093cddc1eso287954wmf.3
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 22:16:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GuOUsgjsv3LBv2ZWzdurVoq1rqwPXc4SiSA2qJZ61Yw=;
        b=Rxm+gh+vB/mVju/+DPA1G7FB6P+QdwO9ZZoaEki8b0C0oT0K5eJezcW+jOcSNDYNJj
         x4MVFm/iC2lFVzPCdL+okSmnqV/ncqiOa5jlT6spnTlK0EVPKeWsjtYeA+qeOUAzuqb6
         LvjFvsY8v5qxvLU388sbapTfRYvtRxRKdTFL3NC0Rep9+8KpD9Hg2Kx8ATAnzoKDXgK3
         Wbapz0zDx94QKYbqfe8b2iYSkwx/V5QqVpWg1TFtTcrmciwzRZ5woXC8KL/d5x8bCtpB
         +JeSuoPyqKt6/TP73XP5BpKbVKxlA1i33Bi0LiBROWCOq+BEgF2zxrctbO8bWC8OdgkF
         +rgw==
X-Gm-Message-State: AOAM532y1bpl/TJjkhFdSYKTXuPclWrwgJlf9Dq8sfjMlFiQOpCIMcFK
        L9pJ3PPdh58r8P8aieNmf9s+bNoXiD+2sewDFoy+Ysgha4LFKrFXsRYTNd4QkzPun4Vctr0x9Tb
        2yiNaRqhsUsJC
X-Received: by 2002:a05:600c:3397:: with SMTP id o23mr11270486wmp.143.1627363001172;
        Mon, 26 Jul 2021 22:16:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJznat4dW3ppL5oGQuvuuhcAKYDzGnlCPoqj/lKa4tTnWmFzMnke9RQcTg0UOJAaILNbwYvZ1A==
X-Received: by 2002:a05:600c:3397:: with SMTP id o23mr11270470wmp.143.1627363001002;
        Mon, 26 Jul 2021 22:16:41 -0700 (PDT)
Received: from thuth.remote.csb (pd9575250.dip0.t-ipconnect.de. [217.87.82.80])
        by smtp.gmail.com with ESMTPSA id j1sm1401844wmo.4.2021.07.26.22.16.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 22:16:40 -0700 (PDT)
Subject: Re: [PATCH] KVM: s390: restore old debugfs names
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        KVM <kvm@vger.kernel.org>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jing Zhang <jingzhangos@google.com>
References: <20210726150108.5603-1-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <6d643d0f-3402-3e05-e405-e66d74e98b94@redhat.com>
Date:   Tue, 27 Jul 2021 07:16:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210726150108.5603-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/07/2021 17.01, Christian Borntraeger wrote:
> commit bc9e9e672df9 ("KVM: debugfs: Reuse binary stats descriptors")
> did replace the old definitions with the binary ones. While doing that
> it missed that some files are names different than the counters. This
> is especially important for kvm_stat which does have special handling
> for counters named instruction_*.
> 
> Fixes: commit bc9e9e672df9 ("KVM: debugfs: Reuse binary stats descriptors")
> CC: Jing Zhang <jingzhangos@google.com>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>   arch/s390/include/asm/kvm_host.h | 18 +++++++++---------
>   arch/s390/kvm/diag.c             | 18 +++++++++---------
>   arch/s390/kvm/kvm-s390.c         | 18 +++++++++---------
>   3 files changed, 27 insertions(+), 27 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>

