Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDC23589C1
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 18:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbhDHQ3C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 12:29:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39931 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231918AbhDHQ3C (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Apr 2021 12:29:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617899330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5wrbAOZjrEmBl3SUhRJwLLYwLvrtd7NpWnCWVbIkN2Q=;
        b=WNV0rfN2mXXhVinwtYwmfXdYFkRCUta3Nm0DgNqYTRR+Fw58IivYRRrG4p5E3LM2zCVW4p
        I6ICCol5d+WyLWYmlYYkbOfxFl4IzCunxS56jFQoUgNDz3v4O/3UmZBtIeXDtpImHrDb+d
        qgAlXb+L/aGOVUnWxT1F443cnpPfcZs=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-vHTap12LOea3mq-tq5K04Q-1; Thu, 08 Apr 2021 12:28:48 -0400
X-MC-Unique: vHTap12LOea3mq-tq5K04Q-1
Received: by mail-ed1-f69.google.com with SMTP id a8so1298448edt.1
        for <kvm@vger.kernel.org>; Thu, 08 Apr 2021 09:28:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5wrbAOZjrEmBl3SUhRJwLLYwLvrtd7NpWnCWVbIkN2Q=;
        b=p7SZTwp6MwXE0UA8UY8uKMcjCv6/FakSh0VaSZAqCMSeaDG4TNm4iSYly7nRFh+wgR
         MKAQ3DXKGWLQmEofLG4BaBjrtEJOEhC+gruqqsmiIb05hFAaLtwuOPC58pxlCELKXg9v
         aZUnZFRjCLk0UcH/00jCqISKcd50fdV0MbfY1npARdUaYA++x4VWzohl1cllUYRFj8Xk
         DdDSeopWpDbjhkc14/4BfNcH7xakSSeJLVS3IBkuwfuvYU6dBMdyu16Es6HN11LX50zn
         3R4Z6qEkpGnbBex9/EOGuqHnEGhnr6S4t78lgBDgxzNSc+Jka6Cg6oorykbHFnHeyOJP
         ds/w==
X-Gm-Message-State: AOAM53378sIrdlzxtsvoYd34cH0KyTHkR9IKT+MFwqxoC1hDhMWbWiQe
        D876T6Mv6MaWOzOKv0JLhldiuUNqRRDElc0Y7qyu3DtGF5EJCxxwAOvgDIzivYpa+FEva2ZoRwn
        Ght3NwkFKS7Vj
X-Received: by 2002:a50:ff13:: with SMTP id a19mr8705262edu.300.1617899327693;
        Thu, 08 Apr 2021 09:28:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxRv3PJSwaeiHkKwTDMJVVmVj8qxGMjV4KPxbuV0IsMXJsgngLozjwulkFyEEMQZpwz0bE3kw==
X-Received: by 2002:a50:ff13:: with SMTP id a19mr8705244edu.300.1617899327555;
        Thu, 08 Apr 2021 09:28:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id r26sm6685065edc.43.2021.04.08.09.28.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Apr 2021 09:28:47 -0700 (PDT)
Subject: Re: [PATCH] KVM: vmx: add mismatched size in vmcs_check32
To:     Sean Christopherson <seanjc@google.com>, lihaiwei.kernel@gmail.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, Haiwei Li <lihaiwei@tencent.com>
References: <20210408075436.13829-1-lihaiwei.kernel@gmail.com>
 <YG8pwERmjxYQoquP@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c24c9d96-37c5-cfb4-8b84-cb3f8daee500@redhat.com>
Date:   Thu, 8 Apr 2021 18:28:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YG8pwERmjxYQoquP@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/04/21 18:05, Sean Christopherson wrote:
>    Add compile-time assertions in vmcs_check32() to disallow accesses to
>    64-bit and 64-bit high fields via vmcs_{read,write}32().  Upper level
>    KVM code should never do partial accesses to VMCS fields.  KVM handles
>    the split accesses automatically in vmcs_{read,write}64() when running
>    as a 32-bit kernel.

KVM also uses raw vmread/vmwrite (__vmcs_readl/__vmcs_writel) when 
copying to and from the shadow VMCS, so that path will not go through 
vmcs_check32 either.

Paolo

