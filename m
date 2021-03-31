Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8300634FD16
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 11:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234627AbhCaJiM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 05:38:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39296 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234707AbhCaJhv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 31 Mar 2021 05:37:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617183470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LKblSJ4G0KZUK+AaVEZrXgxohGJNTUFgpIBBMocDTZk=;
        b=WKgu+UnvUWjdfo0zClqIZ8QuuY43BcWyzLAeM+BMmuiGWLTg5qbDMqqHhAkxRGLHdAsK66
        7wVWzZwYMJYPCxmy41reYfe70BhbfF9dPgK/aQ933vB//WEmVKUXgYM5CX8KFIETY9gud5
        TF3f6JNI12Z0XY+q2gtV2aHgdvi3kMM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-RYuSO28cP5aEKcDPytmSJw-1; Wed, 31 Mar 2021 05:37:48 -0400
X-MC-Unique: RYuSO28cP5aEKcDPytmSJw-1
Received: by mail-ed1-f70.google.com with SMTP id j18so809290edv.6
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 02:37:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LKblSJ4G0KZUK+AaVEZrXgxohGJNTUFgpIBBMocDTZk=;
        b=XlcIzWSE5Sr6xZnKu9GIHlVvVxI1uRQ9rtRomA29nGkvKzyZV6I/C5f3a4dcHGOqXX
         eTL3kJIRyQLgq/WzT4x+3JROF+HFMIwwjbJPfAr2sbrxZb9jPs3vjYnsrulgRWtumo34
         A2wRHzNv2AFvbHidrrfYuOgq4mM9SwaWcfFbC7oFwUDeKsqfDK41k0+1dfsypvnB0VCF
         816ZBZ1Ri8nZU1tMD6sL5cAe7fS+d2sG2XHAV6A1hckPeetZJPpnSEJ0tUxKPHBMK9nu
         7z4oGuqHvABiRGO67/Pt20I/oqTOJHGyw2t4UJT4GE9Gbvx1Brj4M5N8dS/osVVKUmNM
         4ZPQ==
X-Gm-Message-State: AOAM532buyD7HcysYe9pd+r/+47St6URHaYeDMhNYfhaD6V0p6meUbyj
        84KyhnbdTpZse+xDfWyrP/Bw0zSQbZQXpRlg321i60qKHqysvAxoK4vl3Hd5IKveAnr2L1mpNA+
        svIRkaPxJHSOc
X-Received: by 2002:a17:907:1c05:: with SMTP id nc5mr2690484ejc.320.1617183467654;
        Wed, 31 Mar 2021 02:37:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZcxSfehGEq1uk0BhaU+rqvnGQbflSyBdwqBUHUIWYd27faaA/TMixMBIoJUdVVqwTGBc/mg==
X-Received: by 2002:a17:907:1c05:: with SMTP id nc5mr2690475ejc.320.1617183467509;
        Wed, 31 Mar 2021 02:37:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id p24sm1149846edt.5.2021.03.31.02.37.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Mar 2021 02:37:46 -0700 (PDT)
Subject: Re: [PATCH 0/3] KVM: SVM: SEV{-ES} bug fixes
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20210331031936.2495277-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8d1f42be-9e9d-2fb8-cc82-f4ebdbb6147c@redhat.com>
Date:   Wed, 31 Mar 2021 11:37:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210331031936.2495277-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/03/21 05:19, Sean Christopherson wrote:
> Misc bug fixes in SEV/SEV-ES to protect against a malicious userspace.
> All found by inspection, I didn't actually crash the host to to prove that
> userspace could hose the kernel in any of these cases.  Boot tested an SEV
> guest, though the SEV-ES side of patch 2 is essentially untested as I
> don't have an SEV-ES setup at this time.
> 
> Sean Christopherson (3):
>    KVM: SVM: Use online_vcpus, not created_vcpus, to iterate over vCPUs
>    KVM: SVM: Do not set sev->es_active until KVM_SEV_ES_INIT completes
>    KVM: SVM: Do not allow SEV/SEV-ES initialization after vCPUs are
>      created
> 
>   arch/x86/kvm/svm/sev.c | 37 ++++++++++++++++++-------------------
>   1 file changed, 18 insertions(+), 19 deletions(-)
> 

Queued, thanks.

Paolo

