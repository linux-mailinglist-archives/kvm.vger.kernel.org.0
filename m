Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41233A5F88
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 11:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232718AbhFNJ5I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 05:57:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21228 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232630AbhFNJ5H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Jun 2021 05:57:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623664504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5GpSfzrx0xJrJtYkyiWQUMGDvrq/2BMaXO5677R7IKE=;
        b=RYCcivvO4BsWm1hlYtv5UT9oPAFoNJHbSiIT/4mQiOeadFY/zbouTtu2f6hdFiSHkKlaoy
        EnlTiAJlmt+gFXb54rJ2wgQ4pwqZ/tSDyBapD+CWzmK4vcae8QBJJNv8eyoN8dJh3tyPDI
        wI0M2DFTsDNJQS1bLpa4ZIDX1Oe8Qcg=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-YFYzoSO8Nl6rDl_t26bo3w-1; Mon, 14 Jun 2021 05:55:03 -0400
X-MC-Unique: YFYzoSO8Nl6rDl_t26bo3w-1
Received: by mail-ed1-f70.google.com with SMTP id p24-20020aa7c8980000b0290393c37fdcb8so8795091eds.6
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 02:55:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5GpSfzrx0xJrJtYkyiWQUMGDvrq/2BMaXO5677R7IKE=;
        b=OUUnimE1Zoq+sv+VzcwhcFcUtRICcT/gZICb5UY9o3oSQK3nUaehIcfZw4COD4wblU
         DAzAB0yfY19w3YC4raGsAMUU6GnUs7IGdXcEgNsdopnUlkFFlLmxq4zXTuFqkdgLFta1
         MTNHj0CrFxBWnZ0CLn/qwRcJTAbsbee8Y6b7Z1HIIRDhaSrojAkAM6dt+MDppXGVXEju
         zAy+dGU9sJwgR7Jmkq+SY//TOZJelv2MYLAzh2vM+IYtVCvs/+s/GDW2L2psAmIRKjL2
         ptP1YlFkftxCOjgtOfOi83QpuUEpboN0RrGuCa04lYAgvEFgJIOSMWASa1HurMzyu6nP
         rDYw==
X-Gm-Message-State: AOAM532eXtagBhv29m8tqvMQixhXAwp7l5Bto72l8AAkTAYRFtQ8n/5z
        CKySVG0C+w9kBtZz9WwWmqJyQSrXlQ7PPesIhvQF4906A/QACGkjc3BStihX7km7ZxZiglqfC1X
        Utccwo2xfkMbG
X-Received: by 2002:a17:906:c314:: with SMTP id s20mr14579796ejz.355.1623664501890;
        Mon, 14 Jun 2021 02:55:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwWNeLkqs/C9K4xRGmFGyx+BAjVTd2ZevdqxiEUIYgVkivaKVYWkbSy2j655l8bktpDoPsDkA==
X-Received: by 2002:a17:906:c314:: with SMTP id s20mr14579786ejz.355.1623664501756;
        Mon, 14 Jun 2021 02:55:01 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id gw7sm6876865ejb.5.2021.06.14.02.55.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jun 2021 02:55:01 -0700 (PDT)
Subject: Re: [PATCH 0/8] KVM: x86/mmu: Fast page fault support for the TDP MMU
To:     David Matlack <dmatlack@google.com>, kvm@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>
References: <20210611235701.3941724-1-dmatlack@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <639c54a4-3d6b-8b28-8da7-e49f2f87e025@redhat.com>
Date:   Mon, 14 Jun 2021 11:54:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210611235701.3941724-1-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/06/21 01:56, David Matlack wrote:
> This patch series adds support for the TDP MMU in the fast_page_fault
> path, which enables certain write-protection and access tracking faults
> to be handled without taking the KVM MMU lock. This series brings the
> performance of these faults up to par with the legacy MMU.

Hi David,

I have one very basic question: is the speedup due to lock contention, 
or to cacheline bouncing, or something else altogether? In other words, 
what do the profiles look like before vs. after these patches?

Thanks,

Paolo

