Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E79A633EB12
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 09:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhCQIH2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 04:07:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47848 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230507AbhCQIHF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Mar 2021 04:07:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615968425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dcMTJRNAMaTVmBvmYGY35EO0Qdp45/koaA0NF3skgR4=;
        b=KjO/a9opzIb1ATgLqC7cXG9+vXmIg0gHLTtusZKiZnBPrAxGCXjeFKH7YfzUIyE8fEl7hk
        RelHqr67DidZ+GgL87TlfghqdDcWOwjj25waIc73hea/X2sxOZjxZx6D/mqQ2j44zc4tzA
        lCJEnWhqgxPn5Uc+IDUUZ6L5bgk4++U=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-H9VccpBRP5WThZJTUnCDFA-1; Wed, 17 Mar 2021 04:07:03 -0400
X-MC-Unique: H9VccpBRP5WThZJTUnCDFA-1
Received: by mail-wr1-f71.google.com with SMTP id h21so17849451wrc.19
        for <kvm@vger.kernel.org>; Wed, 17 Mar 2021 01:07:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dcMTJRNAMaTVmBvmYGY35EO0Qdp45/koaA0NF3skgR4=;
        b=Or1jC1W+snZMPDA1Wxdw7jPxdk+FKNjWeYEK4cIo55OS1IcJx4Qw9PbqwQzjLZoOTF
         wAqHV6jMg631sRTsqGDsCM7JXfP/BpPwJH3YAzkgV8znH/hfADUspO9IAL7Zk7IGN8Y8
         /j9EXM5L3brqvS3JveAoKz2b6MNQA8FeV26fUzrFRkq1eSGi3iLqLDKoZmr/S2cUgut3
         jTVyJez3yIsfG5HR2UXQMs0XyPWxm7D3pQHXBhA3ZMe4F0A2EALJv0lV8uwKp3ROd7wt
         FWnrRxaO9FjjxnBvTQWdZqb242lay19o2/Ns4KZnsiedJGTPkAT1VyR/hvZ+YWnjVxEo
         G7Kg==
X-Gm-Message-State: AOAM530fqY729Ya0BCpLQlceKjsnOSb9IKeccWxRi/JfRXocX2maNSke
        ZLvB1QWAXDF7wBaye6RVBFIheGH+iEWYYlZnWNtfJICIWXq6r8OgtyRqBmnmMGN7+MMsqCmqXvs
        o9J7IyMK6fdDJ
X-Received: by 2002:a1c:ba88:: with SMTP id k130mr2503265wmf.42.1615968422226;
        Wed, 17 Mar 2021 01:07:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzkEjhZ5/qTitb/GgiLqMLSJu2Hcb05j7BoGd3r4mASYXf4Wxab3kcmmXQtgsx9IevWb6j+XA==
X-Received: by 2002:a1c:ba88:: with SMTP id k130mr2503255wmf.42.1615968422109;
        Wed, 17 Mar 2021 01:07:02 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y18sm24928963wrw.39.2021.03.17.01.07.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Mar 2021 01:07:01 -0700 (PDT)
Subject: Re: [PATCH v2 3/4] KVM: x86: hyper-v: Track Hyper-V TSC page status
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
References: <20210316143736.964151-1-vkuznets@redhat.com>
 <20210316143736.964151-4-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <71484ff3-491a-e8a2-3ef4-e21adb4259ee@redhat.com>
Date:   Wed, 17 Mar 2021 09:07:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210316143736.964151-4-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/03/21 15:37, Vitaly Kuznetsov wrote:
>   
> +enum hv_tsc_page_status {
> +	HV_TSC_PAGE_UNSET = 0,
> +	HV_TSC_PAGE_GUEST_CHANGED,
> +	HV_TSC_PAGE_HOST_CHANGED,
> +	HV_TSC_PAGE_SET,
> +	HV_TSC_PAGE_UPDATING,
> +	HV_TSC_PAGE_BROKEN,
> +};
> +

Can you add comments here?  No need to send the whole series, I can 
squash in the changes.

Paolo

