Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBE8D155449
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 10:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgBGJFi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 04:05:38 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26216 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726867AbgBGJFi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 04:05:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581066336;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2TFD9rG7vA4FDrUIR6pMmUw/PlKpoAIbTdMQNf1sIX4=;
        b=g+o5SDvyv3ILn6cZTY725p+e61VeqbF8jv9RPRrCzJk/9p+T1FHlsFgYqOUr5zKFbGR8qj
        eiNx2gX5QJjGWQ6ezuDukt6uXs8Gntt3OeRMD1svz/cE3HWyD+Ig3V2aVeGynv4tdoaWfn
        WaLjvz5BSn3YLi4MlZcUUQOlj2mr6kQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-DJakZkDgODiXcqldhy8MJg-1; Fri, 07 Feb 2020 04:05:35 -0500
X-MC-Unique: DJakZkDgODiXcqldhy8MJg-1
Received: by mail-wm1-f69.google.com with SMTP id y125so1394302wmg.1
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2020 01:05:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=2TFD9rG7vA4FDrUIR6pMmUw/PlKpoAIbTdMQNf1sIX4=;
        b=JImAThZ+CJ+MFuJSH/vb5nRuP6ur0ZFLF6Li43oJR/M4H0bqjoBnhStqanewc4v+OH
         sI28mQvBEZGza57w1DVQ0cYAvte0Bsd8F55c3oJ2qDuDdvKW6GrHIKillgm39Qn/bw2b
         2X+FZXERsWVVY+pYBqDJiIVq15RtqeliqCCwAw05RagXoJufYp7FFf5E79PU+QtqpV3/
         myFYsZC/FPYEm6nRxAjVS5dC5CgJxHdmR/fQt2xyxmak8uNE6nl0b/emgQjri7VVZDA0
         7wclpnbD09Xu/KPj9tGf3KmNhVXVm9jRvLQp9buU0VygKsAIjnv8PmObiDTG5RV5hXUm
         oWUQ==
X-Gm-Message-State: APjAAAXzi1xXja1B3KstNj3Wx1ktg3eJhPLOYEhcYGWsmP2/072mUzuL
        N38+v5BzsqdGety6L/9+7VeNDPu1lKEfGNEc0GNfl5twHfEqgnXS2nLqOR9v//Gq6uGey3qTBUr
        3kxAptn/H7Vrb
X-Received: by 2002:a5d:6b82:: with SMTP id n2mr3721295wrx.153.1581066334202;
        Fri, 07 Feb 2020 01:05:34 -0800 (PST)
X-Google-Smtp-Source: APXvYqz6O3wbeZZQCUtS6dsN5hRsa9i0lefOI3eygicXS4BIRznUA5cVKuqZiLR+ei7uBb07X4RFTQ==
X-Received: by 2002:a5d:6b82:: with SMTP id n2mr3721243wrx.153.1581066333856;
        Fri, 07 Feb 2020 01:05:33 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id y7sm2571820wrr.56.2020.02.07.01.05.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 01:05:33 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86\@kernel.org" <x86@kernel.org>,
        "pbonzini\@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar\@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson\@intel.com" <sean.j.christopherson@intel.com>,
        "wanpengli\@tencent.com" <wanpengli@tencent.com>,
        "jmattson\@google.com" <jmattson@google.com>,
        "joro\@8bytes.org" <joro@8bytes.org>,
        "tglx\@linutronix.de" <tglx@linutronix.de>,
        "mingo\@redhat.com" <mingo@redhat.com>,
        "bp\@alien8.de" <bp@alien8.de>, "hpa\@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH] KVM: x86: remove duplicated KVM_REQ_EVENT request
In-Reply-To: <a95c89cdcdca4749a1ca4d779ebd4a0a@huawei.com>
References: <a95c89cdcdca4749a1ca4d779ebd4a0a@huawei.com>
Date:   Fri, 07 Feb 2020 10:05:32 +0100
Message-ID: <87h802g42r.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

linmiaohe <linmiaohe@huawei.com> writes:

> Hi：
> Vitaly Kuznetsov <vkuznets@redhat.com> writes:
>> linmiaohe <linmiaohe@huawei.com> writes:
>>> From: Miaohe Lin <linmiaohe@huawei.com>
>>>
>>> The KVM_REQ_EVENT request is already made in kvm_set_rflags(). We 
>>> should not make it again.
>>>  	kvm_rip_write(vcpu, ctxt->eip);
>>>  	kvm_set_rflags(vcpu, ctxt->eflags);
>>> -	kvm_make_request(KVM_REQ_EVENT, vcpu);
>>
>> I would've actually done it the other way around and removed
>> kvm_make_request() from kvm_set_rflags() as it is not an obvious behavior (e.g. why kvm_rip_write() doens't do that and kvm_set_rflags() does ?) adding kvm_make_request() to all call sites.
>>
>>In case this looks like too big of a change with no particular gain I'd suggest you at least leave a comment above kvm_set_rflags(), something like
>>
>>"kvm_make_request() also requests KVM_REQ_EVENT"
>
> I think adding kvm_make_request() to all call sites is too big without particular gain. And also leave a comment above
> kvm_set_rflags() maybe isn't needed as rflags updates is an site that can trigger event injection. Please see commit
> (3842d135ff24 KVM: Check for pending events before attempting injection) for detail.
>
> What do you think?

I don't have a strong opinion on this and your change is correct so feel
free to throw my

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>


-- 
Vitaly

