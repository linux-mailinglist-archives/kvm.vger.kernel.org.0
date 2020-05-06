Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37CCA1C765A
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 18:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730228AbgEFQa6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 12:30:58 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58308 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730109AbgEFQa5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 12:30:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588782655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tSUQHAQlY7PhB1CMSPEa9ZgQrRD15euTGzalw6ZzZR8=;
        b=WV35MQD06vkvVsk8LCAua89e3gG1JG8xysgdNTxnUtvLOlsVDUV0jSO27EY1hIp+cUsc1+
        TpZjRqVQgZFE8L/d06sjm5yRuOQXEtreVZFjOZx2ZRadraCJBciareBk0D8il6/SKD4IE/
        609UoHglql17nFhyca8K6c7KuR4BdPY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-rYBLFsxVN2yEkzk0Vk1alA-1; Wed, 06 May 2020 12:30:53 -0400
X-MC-Unique: rYBLFsxVN2yEkzk0Vk1alA-1
Received: by mail-wm1-f71.google.com with SMTP id l21so1536254wmh.2
        for <kvm@vger.kernel.org>; Wed, 06 May 2020 09:30:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tSUQHAQlY7PhB1CMSPEa9ZgQrRD15euTGzalw6ZzZR8=;
        b=sjue6Mx5Fp5wTONX100qxYi1fYrMPB4Wjg/fcrLO+wBbS14CNVYYN0A5O0E1YTZiQ4
         t6tGzs9aPyhvkbyCtHMhXjnVmDwK++z1CJTJUsOxM8J/ZHFvnJ/isAgNR827j6YnY+Rr
         JRJLTjeYzavnCiazg0oq92FCzz7HZ3mleLm0SkWATKg36TLImkDp2EqWStBowwWCDR66
         m/cO5RE4nS5kNN+mLlJV0mjyd6f3B/3rYNvZiGcA4LSszHZKsru87A711LH23aKZYIHD
         OL0fX6nxIKcvcfJVRAlY0XvqIps435zQk6e6YKlQjvfxefoVbju7ieh0ESFc4p0P+d+K
         B99w==
X-Gm-Message-State: AGi0PuaFcmIH1SvDkx1lkBcFzZuvSyI+sGA9VAG12BtT/ptwl+KJ/8xC
        9bO9PCjTT3WNCXNp9hPRfQEPjW2UKKzg7GaniCF7OSUZgsLyi2rnYwCZdWMZ8bzudeopbbVSPLa
        0YxHLsYuQsTZB
X-Received: by 2002:a7b:c399:: with SMTP id s25mr5140607wmj.169.1588782652111;
        Wed, 06 May 2020 09:30:52 -0700 (PDT)
X-Google-Smtp-Source: APiQypJTP3V/5TCFRJx9MxMBaSz92xOqGZitDKvJVsqE7DLtHLB+Swt6r384A6P5/3ZRst3QHjuzDw==
X-Received: by 2002:a7b:c399:: with SMTP id s25mr5140588wmj.169.1588782651844;
        Wed, 06 May 2020 09:30:51 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:11d7:2f21:f38b:17e? ([2001:b07:6468:f312:11d7:2f21:f38b:17e])
        by smtp.gmail.com with ESMTPSA id x5sm3240420wro.12.2020.05.06.09.30.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2020 09:30:51 -0700 (PDT)
Subject: Re: [PATCH 0/4] KVM: SVM: Fix AVIC warning when enable irq window
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     joro@8bytes.org, jon.grimm@amd.com, mlevitsk@redhat.com
References: <1588771076-73790-1-git-send-email-suravee.suthikulpanit@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d918ad5a-f7c0-7915-9a98-e33bef34b623@redhat.com>
Date:   Wed, 6 May 2020 18:30:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <1588771076-73790-1-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/05/20 15:17, Suravee Suthikulpanit wrote:
> Introduce kvm_make_all_cpus_request_except(), which is used
> in the subsequent patch 2 to fix AVIC warning.
> 
> Also include miscelleneous clean ups.
> 
> Thanks,
> Suravee
> 
> Suravee Suthikulpanit (4):
>   KVM: Introduce kvm_make_all_cpus_request_except()
>   KVM: SVM: Fixes setting V_IRQ while AVIC is still enabled
>   KVM: SVM: Merge svm_enable_vintr into svm_set_vintr
>   KVM: SVM: Remove unnecessary V_IRQ unsetting
> 
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/kvm/hyperv.c           |  6 ++++--
>  arch/x86/kvm/i8254.c            |  4 ++--
>  arch/x86/kvm/svm/avic.c         |  2 +-
>  arch/x86/kvm/svm/svm.c          | 18 ++++++------------
>  arch/x86/kvm/x86.c              | 16 +++++++++++++---
>  include/linux/kvm_host.h        |  3 +++
>  virt/kvm/kvm_main.c             | 14 +++++++++++---
>  8 files changed, 41 insertions(+), 24 deletions(-)
> 

I merged patches 1-3-4, you can send out 2 independently.

Thanks,

Paolo

