Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C9B233F4F
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 08:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731447AbgGaGpD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 02:45:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41246 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731224AbgGaGpD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 02:45:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596177901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=akcf5o31IxmDQVV9nGhhRCpgu422ncpTC7D3b7rqbA4=;
        b=FdAebtOA95UDn4MRlqXB/Oj3N5hSQyi3CIRQqQzx4tmUXgvWj/9DITBTqaAgKOySAAAGEh
        qy/qFWdxBId0+P/ZZAYbA7Rr4ZoLdfZow8s1uM99yx8OXnIraS3wnbFZzWsUXut5Zvnxto
        +2ZfEfB+Vxf/prsys7S98csZokiXJHw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-iceKlaKqMMuhmap-eETy3w-1; Fri, 31 Jul 2020 02:44:59 -0400
X-MC-Unique: iceKlaKqMMuhmap-eETy3w-1
Received: by mail-wr1-f70.google.com with SMTP id w7so6446934wre.11
        for <kvm@vger.kernel.org>; Thu, 30 Jul 2020 23:44:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=akcf5o31IxmDQVV9nGhhRCpgu422ncpTC7D3b7rqbA4=;
        b=AUmZ8swb6V2CW3r59kt1T6lmRy0v9lyp5EjVqAcOcOq1jMWrJ2QOVgvx67iqYW5ZeH
         yIdpQZpQHPA/ZtUa6Yz4JjJMYKL73rEce/wCwdK7/xJXzicIMU2YEymGBHTKAqRxMa/3
         OH4r4ekNZdhjsVLmwXW0BHfNnDM75l+sOq7+VmDgzp+j6ZOQdCE89RDHnOyYc7SBIeXn
         wSqyREI3wrDodDB86IcriaOwP2nNzDcJLb5drMJzyqrgeENfAz0iHXWmPcfMdzLVDP+8
         M2sonjDSshwCQUlqGHPT/XVPop8XjoBTC9xq1F9gY0gOoIXQlBUM7jI0MRkuCMxyc2lg
         0Yww==
X-Gm-Message-State: AOAM533Oig4uu8z1nRr9f2wUcCa3uH9ST2nVNTvXjcbfhk9vM4DlhRPc
        3fFUFvG3lf9jyhBWWZlLxxL4cNqHE64CCf9Rs5bIwrs1xhNMl2ZjhNY3DWyGi7RKkjlzf7kMCB+
        nZol8pfp0vrSq
X-Received: by 2002:a5d:4109:: with SMTP id l9mr2102413wrp.398.1596177897799;
        Thu, 30 Jul 2020 23:44:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxb5GRvfk7uYiQKiLNWu3grzIfY78jWIsuxWLgPwULOyAUG8/2c+Tmj75lzVnz9+VNZS5ExPA==
X-Received: by 2002:a5d:4109:: with SMTP id l9mr2102394wrp.398.1596177897568;
        Thu, 30 Jul 2020 23:44:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:90a5:f767:5f9f:3445? ([2001:b07:6468:f312:90a5:f767:5f9f:3445])
        by smtp.gmail.com with ESMTPSA id 32sm14850330wrh.18.2020.07.30.23.44.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2020 23:44:57 -0700 (PDT)
Subject: Re: [Question] the check of ioeventfd collision in
 kvm_*assign_ioeventfd_idx
To:     Zhenyu Ye <yezhenyu2@huawei.com>
Cc:     "S. Tsirkin, Michael" <mst@redhat.com>, gleb@redhat.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Xiexiangyou <xiexiangyou@huawei.com>
References: <bbece68b-fb39-d599-9ba7-a8ee8be16525@huawei.com>
 <CABgObfbFXYodCeGWSnKw0j_n2-QLxpnD_Uyc5r-_ApXv=x+qmw@mail.gmail.com>
 <4aa75d90-f2d2-888c-8970-02a41f3733e4@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cffcf9e1-6675-6815-ccfc-f48497ade818@redhat.com>
Date:   Fri, 31 Jul 2020 08:44:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <4aa75d90-f2d2-888c-8970-02a41f3733e4@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/07/20 08:39, Zhenyu Ye wrote:
> On 2020/7/31 2:03, Paolo Bonzini wrote:
>> Yes, I think it's not needed. Probably the deassign check can be turned into an assertion?
>>
>> Paolo
>>
> 
> I think we can do this in the same function, and turnt he check of
> p->eventfd into assertion in kvm_deassign_ioeventfd_idx(). Just like:
> 
> ---8<---
> static inline struct _ioeventfd *
> get_ioeventfd(struct kvm *kvm, enum kvm_bus bus_idx,
>               struct kvm_ioeventfd *args)
> {
>         static struct _ioeventfd *_p;
>         bool wildcard = !(args->flags & KVM_IOEVENTFD_FLAG_DATAMATCH);
> 
>         list_for_each_entry(_p, &kvm->ioeventfds, list)
>                 if (_p->bus_idx == bus_idx &&
>                     _p->addr == args->addr &&
>                     (!_p->length || !args->len ||
>                      (_p->length == args->len &&
>                       (_p->wildcard || wildcard ||
>                        _p->datamatch == args->datamatch))))
>                         return _p;
> 
>         return NULL;
> }
> 
> kvm_deassign_ioeventfd_idx() {
> 	...
> 	p = get_ioeventfd(kvm, bus_idx, args);
> 	if (p) {
> 		assert(p->eventfd == eventfd);
> 		...
> 	}
> 
> ---8<----
> 
> This may be easier to understand (keep the same logic in assign/deassign).

I think you should also warn if:

1) p->length != args->len

2) p->wildcard != args->wildcard if p->length

3) p->datamatch != args->datamatch if p->length && !p->wildcard

but yeah it sounds like a plan.

Paolo

