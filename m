Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF7D42B231F
	for <lists+kvm@lfdr.de>; Fri, 13 Nov 2020 18:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgKMR6z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 12:58:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50634 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726301AbgKMR6z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Nov 2020 12:58:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605290333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O5BKgRlDzjTzAb+liqgxWnaX18EKLrQ791MVleM/3MA=;
        b=UfkZzEqyN96wa0zr14TX4Jv8f4M/ocxC2rc0ZDLinTMZTGAk4CO6wblnvSsm7bFfslvRu6
        9FCaoyl0+ZDvK2ZtZYd+B2Trt4MXyEIqlxvjZO3PNDNG7P2u9LltCw5zV7fs9EOSZhSkz8
        GF7Fp7WKlVIN2yM7vtibUCSDed/22II=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-zO8hS7oWMD6uQBK3tiV3fQ-1; Fri, 13 Nov 2020 12:58:52 -0500
X-MC-Unique: zO8hS7oWMD6uQBK3tiV3fQ-1
Received: by mail-wm1-f70.google.com with SMTP id a134so3591623wmd.8
        for <kvm@vger.kernel.org>; Fri, 13 Nov 2020 09:58:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O5BKgRlDzjTzAb+liqgxWnaX18EKLrQ791MVleM/3MA=;
        b=e2ofTjgcKF7LL0OOgpZfiKvXCkiu9HdS/5YVK7Squ4BoN06XEBY5uL6dR+l0bsLUQH
         kXahy/BUZy9jr/O4ykdZ3Y6zUMbqv041AIkjJvNB2D5QyA/c2zHE1oIC2HPDZgr5QLx2
         kIlw0ubgdjPB7WTO7FilExLu7WQ8n5Ti/S95LjGLvwgcKs5Q88JFG++l2ldsQHHI3ywr
         g/5pnRPpzQWHz/ZCa3ippIUdDy1P0iXBVENZvUU5haAD/B6ShuACYk803tz0a/CbfVL4
         70h6iahJkWy9tSjmeG5+UjIUEMI1X9zoOdcOeenfyxNq43PjjH8MSmQYSNP+f4KXutBh
         rQpA==
X-Gm-Message-State: AOAM533hb9CO1MUGDpeDOX5/kUr/52GQGF5RLZ2INTr27TteBoPcfsHA
        2Vdcuo72nB0qynDrWcXyjWKVf6BXEwmYPa9zK/6T7Wdy46nsSlffFNcHsFBuNS+xVyTeu5qogg1
        KNHtps0yJfuTl
X-Received: by 2002:adf:9461:: with SMTP id 88mr4739031wrq.171.1605290329060;
        Fri, 13 Nov 2020 09:58:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzpyEBuynksW6JDjBXyrJxyes9a4eVuRyvimJYtDo9Ih9P76sqjzmzYU6u4WzI7g3NBf01hXQ==
X-Received: by 2002:adf:9461:: with SMTP id 88mr4738692wrq.171.1605290323999;
        Fri, 13 Nov 2020 09:58:43 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id i11sm12198292wro.85.2020.11.13.09.58.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2020 09:58:43 -0800 (PST)
To:     Cathy Avery <cavery@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, wei.huang2@amd.com, mlevitsk@redhat.com
References: <20201011184818.3609-1-cavery@redhat.com>
 <20201011184818.3609-3-cavery@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 2/2] KVM: SVM: Use a separate vmcb for the nested L2
 guest
Message-ID: <80b02c13-dc69-783a-9431-41b4a5188c0b@redhat.com>
Date:   Fri, 13 Nov 2020 18:58:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201011184818.3609-3-cavery@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/10/20 20:48, Cathy Avery wrote:
> @@ -432,6 +432,16 @@ int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
>   	int ret;
>   
>   	svm->nested.vmcb = vmcb_gpa;
> +
> +	WARN_ON(svm->vmcb == svm->nested.vmcb02);
> +
> +	svm->nested.vmcb02->control = svm->vmcb01->control;

This assignment of the control area should be in 
nested_prepare_vmcb_control, which is already filling in most of 
vmcb02->control.

Right now, we save a copy_vmcb_control-area in nested_svm_vmexit so it 
evens out.

Later, it should be possible to remove most of the assignments from 
nested_prepare_vmcb_control.

> +	svm->nested.vmcb02->save.cr4 = svm->vmcb01->save.cr4;

I cannot understand this statement.

> +	nested_svm_vmloadsave(svm->vmcb01, svm->nested.vmcb02);

This is because the vmsave just after the vmexit has moved the 
vmloadsave registers from vmcb12 to vmcb01, but the next vmload will use 
vmcb02.

> +	svm->vmcb = svm->nested.vmcb02;
> +	svm->vmcb_pa = svm->nested.vmcb02_pa;
>   	load_nested_vmcb_control(svm, &nested_vmcb->control);
>   	nested_prepare_vmcb_save(svm, nested_vmcb);
>   	nested_prepare_vmcb_control(svm);


> @@ -628,8 +620,10 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>   	nested_vmcb->control.pause_filter_thresh =
>   		svm->vmcb->control.pause_filter_thresh;
>   
> -	/* Restore the original control entries */
> -	copy_vmcb_control_area(&vmcb->control, &hsave->control);
> +	nested_svm_vmloadsave(svm->nested.vmcb02, svm->vmcb01);

Same here: the next vmentry's vmload will move the vmloadsave registers 
from vmcb01 to vmcb12, but for now they are in vmcb02.

It's 16+16 memory-to-memory u64 copies.  They mostly even out with the 
14+14 copies that we don't have to do anymore on registers handled by 
VMRUN (es/cs/ss/ds/gdt/idt/rsp/rax---they don't have to be stashed away 
in hsave anymore).  Also, we are able to reuse nested_svm_vmloadsave, 
which makes it overall a fair tradeoff... but it would have been worth a 
comment or two. :)

> +	svm->nested.vmcb02->control = svm->vmcb01->control;
> +	svm->nested.vmcb02->save = svm->vmcb01->save;
> +	svm->vmcb01->save = save;

I would have moved these after the comment, matching the existing 
copy_vmcb_control_area and save-area assignment.

Also, the first save-area assignment should be (because the WARN_ON 
below must be removed)

	svm->nested.vmcb02->save = svm->vmcb->save;

or

	if (svm->vmcb == svm->vmcb01)
		svm->nested.vmcb02->save = svm->vmcb01->save;

I have applied the patch and fixed the conflicts, so when I have some 
time I will play a bit more with it and/or pass the updated version back 
to you.

In the meanwhile, perhaps you could write a new selftests testcase that 
tries to do KVM_SET_NESTED_STATE while in L2.  It can be a simplified 
version of state-test that invokes KVM_GET_NESTED_STATE + 
KVM_SET_NESTED_STATE when it gets back to L0.

Paolo

