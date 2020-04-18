Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D02C1AEB83
	for <lists+kvm@lfdr.de>; Sat, 18 Apr 2020 11:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725891AbgDRJ4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Apr 2020 05:56:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56731 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725857AbgDRJ4D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Apr 2020 05:56:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587203761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wTcRkdSTcnogmYKb1vyPZlIFr7BRZzMxTKvCBHcehjE=;
        b=EqcBmgf0Ge4kIAAnwN/8jX52eNtHu/Cs2UUVZtgA0XKikaClwVhK1O9v5HmMcllv5a6q6b
        GGEWqStR4oNM+TE84hzS0CdswCyM92GIvFhol6X5QOy/0S27KVoV535FCxUfISELblySuD
        blVyFSBYz0s1ePzVUZXSut4NLIXVOdY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-TiRftLzYPTeewKywJP4G5g-1; Sat, 18 Apr 2020 05:55:59 -0400
X-MC-Unique: TiRftLzYPTeewKywJP4G5g-1
Received: by mail-wr1-f69.google.com with SMTP id g7so1547881wrw.18
        for <kvm@vger.kernel.org>; Sat, 18 Apr 2020 02:55:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wTcRkdSTcnogmYKb1vyPZlIFr7BRZzMxTKvCBHcehjE=;
        b=Bi5WiO18SFfpm/7rlWU0H3hekavS55DMCWlHp74JHcQGm0ut2IiPmrK9sCcxFmo+A9
         KB4u0GQmR/xhwblznja3MDdZToHzuf3gdg+Do6xhp9sps3MV0hdoJrMGrOTFuKIIJcM4
         IdwScNRk+btcEfeAAwXrkCr3fgV4v/+qVIpt15q8GURJ6oEwrbO9HZ9C9EN/tGtjvTaR
         Kd0Khfu26rj6SNP0upP2gv6kK7qYrArl81stslYYPK1T8VNSUxXzQHYyH8GlEGCwZaJT
         /N7YF6qemHdvm37yUQlo7d8F7qa0BOHBpo90pqBNw+JD5Gdtv3o5RrycvQztcekPK+BH
         QH4w==
X-Gm-Message-State: AGi0PuZ1kfDM0AsYiu4p02jTkdeCNefYN+K/0XyA/y/Q1vjqkm2Dv3I1
        TLUTERUsFiQ464hTenhvxccMN2PVyIX3aGkVv957waMqRVG4WtkzupFIXZ+es0/cg4d1KWtusig
        E2k9kHu1el2Dj
X-Received: by 2002:a5d:5651:: with SMTP id j17mr8094494wrw.406.1587203757741;
        Sat, 18 Apr 2020 02:55:57 -0700 (PDT)
X-Google-Smtp-Source: APiQypKaFYVKYrHh6jgP/k8hU9lt1vzMRnvu1GNp+mZ/1QD5M7AdEyKXjR5tLK6F6ffWE/fvI94HJg==
X-Received: by 2002:a5d:5651:: with SMTP id j17mr8094485wrw.406.1587203757516;
        Sat, 18 Apr 2020 02:55:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e04c:97cb:a127:17b6? ([2001:b07:6468:f312:e04c:97cb:a127:17b6])
        by smtp.gmail.com with ESMTPSA id g15sm12971965wrp.96.2020.04.18.02.55.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 02:55:57 -0700 (PDT)
Subject: Re: [PATCH 0/3] KVM: x86: move nested-related kvm_x86_ops to a
 separate struct
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20200417164413.71885-1-pbonzini@redhat.com>
 <20200417190553.GI287932@xz-x1> <20200417191159.GA14609@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4c69d11e-40ab-fdb8-6f32-fdf7298d1277@redhat.com>
Date:   Sat, 18 Apr 2020 11:55:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200417191159.GA14609@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/04/20 21:11, Sean Christopherson wrote:
> Ya, my vote would be to copy by value as well.

I'd rather avoid useless churn, because

	vmx_x86_ops.nested = vmx_nested_ops;

is much uglier than

	.nested = &vmx_nested_ops,

and with static calls the latter would not have any performance downside.

> I'd also be in favor of
> dropping the _ops part, e.g.
> 
>   struct kvm_x86_ops {
>         struct kvm_x86_nested_ops nested;
> 
>         ...
>   };
> 
> and drop the "nested" parts from the ops, e.g.
> 
>   check_nested_events() -> check_events()

Agreed on both, I'll send v2 with these changes.

Paolo

