Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 671D71E8DF3
	for <lists+kvm@lfdr.de>; Sat, 30 May 2020 07:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728293AbgE3FKz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 May 2020 01:10:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39543 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726193AbgE3FKy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 May 2020 01:10:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590815453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/Kf6XO5g1mQ6NPxd92AMMUcl7wDe8Zvf48X720rxLRo=;
        b=ftFr0phxlcLpItXJlJpuKC5Rr08JopMjZNufKyxoYlZihfBqC6bmxEPtW92KPgg002ooUY
        MxmVUZSuuvW9pKwJ4lT2WqBb6SDntvKYw6QyT8S2b5rP6kLY7/ufFEkrH9+Sb/tNme18OQ
        n8uTGpyrfms2lcA4gY/3Ndh67GJQbwE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-tXGpRRkBMpS-shs2Em1rIg-1; Sat, 30 May 2020 01:10:49 -0400
X-MC-Unique: tXGpRRkBMpS-shs2Em1rIg-1
Received: by mail-wr1-f69.google.com with SMTP id e7so1307913wrp.14
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 22:10:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/Kf6XO5g1mQ6NPxd92AMMUcl7wDe8Zvf48X720rxLRo=;
        b=jXcQglunKpc6VjTKiuXlsvstSxCcqkz29vV+I7Ej7X8S6sH97dycKhdipO/xeKkgZW
         mJ5aAFtGz+4zQXyrjQZZn3Dh2BEox/yDzf4qvrxn7Pji3ZHUK3aTXfRjRKpTw/3PwtNv
         kmuBWER/dkgtbswTMiJLnkOVg3NIbPVfdODTPFwLa4fyB/tAdcrN5ZYNJdXT4KyPD5+b
         KZhkcEZ24ZnhEfUuOlhyI7WjgvgS/UlGp0qCx0Nf3DqYs266PMnLrL3jDGnV4meSUF+W
         xBSrM6aeI+GhmWms8x/K6FRo7DOhfJDccVsfl+jvir2PhKVeUcciFz1OlVe6Qh72e5UE
         ah2g==
X-Gm-Message-State: AOAM533vE51c0okv64Oy6Mh6+sgOB+nE1iUh7v0n1aFd3aEclaDbMsXa
        vdaHrJJDF1jBqze6Fpbb6OqqiwDDByy2w2+HxDdOQfqhufo01+eVMNNIYbZKAp/8hlszcohtR70
        OPlkzdyWqTzjV
X-Received: by 2002:a7b:cd94:: with SMTP id y20mr11333445wmj.87.1590815447746;
        Fri, 29 May 2020 22:10:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwRg40r5C7bTlx+kDl7KL+EfcxvhwaWd/5V7DTZRfgr2vb/jPzdmLxSIsGDaqjhAGNZhhfxtQ==
X-Received: by 2002:a7b:cd94:: with SMTP id y20mr11333434wmj.87.1590815447492;
        Fri, 29 May 2020 22:10:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3c1c:ffba:c624:29b8? ([2001:b07:6468:f312:3c1c:ffba:c624:29b8])
        by smtp.gmail.com with ESMTPSA id s2sm1949988wmh.11.2020.05.29.22.10.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 22:10:46 -0700 (PDT)
Subject: Re: [PATCH 17/30] KVM: nSVM: synchronize VMCB controls updated by the
 processor on every vmexit
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20200529153934.11694-1-pbonzini@redhat.com>
 <20200529153934.11694-18-pbonzini@redhat.com>
 <128fe186-219f-75d0-7ce2-9bb6317e1e7d@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b858b7ac-b815-6c23-0adc-354bd11d5205@redhat.com>
Date:   Sat, 30 May 2020 07:10:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <128fe186-219f-75d0-7ce2-9bb6317e1e7d@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/05/20 04:06, Krish Sadhukhan wrote:
>>
>>   -    nested_vmcb->control.int_ctl           = vmcb->control.int_ctl;
>> -    nested_vmcb->control.int_vector        = vmcb->control.int_vector;
> 
> 
> While it's not related to this patch, I am wondering if we need the
> following line in enter_svm_guest_mode():
> 
>     svm->vmcb->control.int_vector = nested_vmcb->control.int_vector;
> 
> If int_vector is used only to trigger a #VMEXIT after we have decided to
> inject a virtual interrupt, we probably don't the vector value from the
> nested vmcb.

KVM does not use int_vector, but other hypervisor sometimes trigger
virtual interrupts using int_ctl+int_vector instead of eventinj.
(Unlike KVM they don't intercept EXIT_VINTR).  Hyper-V operates like that.

Paolo

