Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216D8373EC6
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 17:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233536AbhEEPpL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 11:45:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25416 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233466AbhEEPpK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 May 2021 11:45:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620229453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kB18wOq0wwABF209vAjteUSBdk4dEBLdqvgC2SNz17Y=;
        b=V1/RVaZVC7yVZ+8QXueKZMvUwp/94dKmWqEUjDXMTcy1ebiECI6giTHcZehxUNuOlerzTe
        Z3MwTMPNJIl+RpLQoFEbDpg+lOFE7Tc68v+P1DrBRylJszSeTr4w2HfaoaNva0FdG8+m+Z
        bGEEsdGLP1QxnzdNeoPB/l2KJJ3Q4A0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-hWPe5lHXNsKTVieuR7uhFQ-1; Wed, 05 May 2021 11:44:10 -0400
X-MC-Unique: hWPe5lHXNsKTVieuR7uhFQ-1
Received: by mail-wm1-f71.google.com with SMTP id r10-20020a05600c2c4ab029014b601975e1so1567725wmg.0
        for <kvm@vger.kernel.org>; Wed, 05 May 2021 08:44:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kB18wOq0wwABF209vAjteUSBdk4dEBLdqvgC2SNz17Y=;
        b=RR/ZG7vtYpGhSj71H+Z4Xjr6QSQxMlvXPn1prQzYTK7ZqtnD9cKR5UW6liN+fMXl5n
         6w+U2x6yOA2GkEI0MbgeFkRsHHPi7iyk3LiW+rbdYqVPctzeCqXCpo8zpAub2GY7hznY
         EbwGq0JxrhB99pO9Bta2dw/kRBlnxpnxz6ommxykjCplgVAtUVMJHioujvOWL6Lv3EsD
         9siJaw6W/OzGsCNSoHXF3HgMuBDHLFcvcFFnkbnwyu5kN01+CLB3bsYDPJMr6hcyRqZd
         ZFdP2DkLYsWuM9w4i3P7rBEaY8EJNY1kzkYGyHtL5POrTSYrJ4eZ2MY4Pw2od02cFr1c
         HtzA==
X-Gm-Message-State: AOAM531b+a+YDr3eI+Cwvi3cChz4bUBurqUBLtqlhbiIrVydfrQ76EAh
        6FgQjWo6mRLFPut3/v+8MxCmi7PwauzWNnDYtDXEFGW7yi9c2eKbPcZXQ2RPGXy/6/KUfzhfK8H
        SEJqRHV/AfRiV
X-Received: by 2002:a7b:c217:: with SMTP id x23mr10447910wmi.26.1620229449401;
        Wed, 05 May 2021 08:44:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwKkqKQ1KzwKdPY3wUmcuteH0Wwcuufh6A7pvdXG1H6KtXZqt1tXR+oSHmXTNUpeIXf5TOB8g==
X-Received: by 2002:a7b:c217:: with SMTP id x23mr10447895wmi.26.1620229449206;
        Wed, 05 May 2021 08:44:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id 61sm21723917wrm.52.2021.05.05.08.44.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 08:44:08 -0700 (PDT)
Subject: Re: [PATCH 0/3] KVM: selftests: evmcs_test: Check issues induced by
 late eVMCS mapping upon restore
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20210505151823.1341678-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f394cc20-8123-2b79-c95e-0aad784a3344@redhat.com>
Date:   Wed, 5 May 2021 17:44:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210505151823.1341678-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/05/21 17:18, Vitaly Kuznetsov wrote:
> A regression was introduced by commit f2c7ef3ba955
> ("KVM: nSVM: cancel KVM_REQ_GET_NESTED_STATE_PAGES on nested vmexit"). When
> L2->L1 exit is forced immediately after restoring nested state,
> KVM_REQ_GET_NESTED_STATE_PAGES request is cleared and VMCS12 changes (e.g.
> fresh RIP) are not reflected to eVMCS. The consequent nested vCPU run gets
> broken. Add a test for the condition (PATCH2). PATCH1 is a preparatory
> change, PATCH3 adds a test for a situation when KVM_GET_NESTED_STATE is
> requested right after KVM_SET_NESTED_STATE, this is still broken in KVM
> (so the patch is not to be committed).
> 
> Vitaly Kuznetsov (3):
>    KVM: selftests: evmcs_test: Check that VMLAUNCH with bogus EVMPTR is
>      causing #UD
>    KVM: selftests: evmcs_test: Check that VMCS12 is alway properly synced
>      to eVMCS after restore
>    KVM: selftests: evmcs_test: Test that KVM_STATE_NESTED_EVMCS is never
>      lost
> 
>   .../testing/selftests/kvm/x86_64/evmcs_test.c | 150 +++++++++++++-----
>   1 file changed, 108 insertions(+), 42 deletions(-)
> 

Queued 1-2, thanks.

Paolo

