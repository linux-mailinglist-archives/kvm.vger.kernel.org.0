Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5ADE1A36D1
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 17:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbgDIPS1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 11:18:27 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:29687 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727919AbgDIPS0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Apr 2020 11:18:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586445505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P/uxkowYsowape0Y4ksEgyT2eO5nsy6RsnVun4UJyPM=;
        b=Cd5NW70479EpwDpdyfnsFGhvsuJc5Kpd02+j7R1HJ+p2QHCyaBrO8sqGIRz7AbnngQAt9u
        gjdd4xgPqhpBHCfIFjmzxuSBqlcLxmKBJYdW4KVF4X41xzrgzwcLMA1/OtTM8eWXD4NIW3
        UwlTqK0L0dZZ3l066R/c9CgzZi3G5UM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-sYjBcLthPDar0mZiHuFONg-1; Thu, 09 Apr 2020 11:18:23 -0400
X-MC-Unique: sYjBcLthPDar0mZiHuFONg-1
Received: by mail-wr1-f71.google.com with SMTP id w12so6521953wrl.23
        for <kvm@vger.kernel.org>; Thu, 09 Apr 2020 08:18:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P/uxkowYsowape0Y4ksEgyT2eO5nsy6RsnVun4UJyPM=;
        b=DM8NCmaK0QSvU14Dcb6PB2vp73wFhkvETpuSElGyjSQDMyB7lFRaOWbCyvyzFAUgbR
         ELoIPZWA8ZOvaSQvrgcE6y/Jmr8jlqdt/EE43sbr7Qdo08MbDQXy0coeGYu/SgMKWvcQ
         /d0ZVcvcFHCd1NWoPAvbG2GkzWC+qFDp1yeg4Y7Rrp/eow0LpaNVMBiC6gM/iZ6y0RuE
         FsbX2ssy9WV1EApYzi9u06+CJXrAh8BpZLcGGKBAaXZDWJ0JG0C0Wv8jnE03JMd7vrsB
         dFIAaOxh4B0z0nE/R+/LDyI/HWoszfWlqvNt4CAsaxd/aZGRUt4S0RWsbNDpLgfKIL4o
         z0Rw==
X-Gm-Message-State: AGi0PuYiI8QqCx1EvqKs3MisoIE4dCgRT3CG7PxBTPpJ9IXTsD2cOJDL
        oQZjIxXJOLuwg98HpaKYeNilrNZaDHDqjCrURB//mIip722sdkUWyHFKmDWqVuQefpmS3a/j2r+
        IhunNkeqswXAG
X-Received: by 2002:a1c:3b0a:: with SMTP id i10mr393151wma.26.1586445502452;
        Thu, 09 Apr 2020 08:18:22 -0700 (PDT)
X-Google-Smtp-Source: APiQypJSEdpB71WwvcgVKDvxrAeFHpVG0NC4zp1FkqjC/MCvTLAufBL2UOm6iPjHXhxSa5QGXGswxQ==
X-Received: by 2002:a1c:3b0a:: with SMTP id i10mr393131wma.26.1586445502248;
        Thu, 09 Apr 2020 08:18:22 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id y22sm4295809wma.18.2020.04.09.08.18.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2020 08:18:21 -0700 (PDT)
Subject: Re: [PATCH] KVM: SVM: Fix __svm_vcpu_run declaration.
To:     like.xu@intel.com, Uros Bizjak <ubizjak@gmail.com>,
        kvm@vger.kernel.org
References: <20200409114926.1407442-1-ubizjak@gmail.com>
 <0ee54833-bbed-4263-7c7e-4091ab956168@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <21e04917-d651-b50b-5ecf-dfe27aec6f0a@redhat.com>
Date:   Thu, 9 Apr 2020 17:18:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <0ee54833-bbed-4263-7c7e-4091ab956168@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/04/20 17:11, Xu, Like wrote:
>>
>>   -bool __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs);
> Just curious if __svm_vcpu_run() will fail to enter SVM guest mode,
> and a return value could indicate that nothing went wrong rather than
> blindly keeping silent.

That's already available in the exit code (which is 0xffffffff when
vmentry fails).

Paolo

