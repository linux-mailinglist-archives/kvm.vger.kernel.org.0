Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8BAA302BBE
	for <lists+kvm@lfdr.de>; Mon, 25 Jan 2021 20:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731973AbhAYThF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 14:37:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37834 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731953AbhAYTgp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Jan 2021 14:36:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611603313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dTm8KkWeoMqY1NMXfpUUnmE85GAUqbldlznQCf84YPQ=;
        b=DETj7xDHXKx+uCn+Pc7FgzYOnCgMI6I6woPKAovVWJfAFsI74da0rGCIp/1ppkaQfzg76O
        s0xY53DgkxLHkZfqfSjvnsmarMJ8o5ikWAfW907tIa9SSS6Hte8TibhD0ZJqsPXgoi8wat
        cruyzcwxqTCXQrExZokaVA+b4mdVaHo=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-_JiTthpOP2KE8JmOMhVo9Q-1; Mon, 25 Jan 2021 14:35:11 -0500
X-MC-Unique: _JiTthpOP2KE8JmOMhVo9Q-1
Received: by mail-ej1-f71.google.com with SMTP id jg11so4216787ejc.23
        for <kvm@vger.kernel.org>; Mon, 25 Jan 2021 11:35:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dTm8KkWeoMqY1NMXfpUUnmE85GAUqbldlznQCf84YPQ=;
        b=e+FZHuV8eFoagVQVqAzCNdsXk3K3wRuiUSklYFBa5fEJ2Nult8R/zQdXVXJX8UKM7A
         HlV+qv3OO/KAWG/l1rAEFi69ragLVMc0EE3wBrbn1H7DOM9hkMUiMJpAQAbOXA0KmflR
         tTKQIRoAQub8UIuPGxZgd7MADaH77LSdr5XRIoyZprc0DV/BEsyMgiE2nAi4QYz2Tzb0
         gmMp6SargTlJhQhBRKKl9CvCU1IQS63aodSOqMi65+oWiGxlTDYZQ7sYAvIh4Er4k+mg
         60Em7kqP4xPaHZshl33/cxDOuXVoT7cyCnl3Wys9wtRVNv8H+LTfn13RHveEVvMakkXM
         oRwQ==
X-Gm-Message-State: AOAM533s3TGuNZe+67jzxB96lidG0onOXyg243mVxcmojmTrOdkd2Nh9
        Z+IQPrjAw+mOkKb830u/XD2hBGtICPTIRF1jAcoffJ2sm4EstJ/JeGfts984JtmRZw3ZkgugApF
        eACfB2uOWF8t8
X-Received: by 2002:a50:d552:: with SMTP id f18mr1800606edj.168.1611603310260;
        Mon, 25 Jan 2021 11:35:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx7yvA/3vdrnGvBeOjexbw/4ggd4FoC4n3YqRVtQrKPUDJ+85s+hGxVzZmzSbJD4J9B2D/1Nw==
X-Received: by 2002:a50:d552:: with SMTP id f18mr1800600edj.168.1611603310149;
        Mon, 25 Jan 2021 11:35:10 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id cx6sm11511897edb.53.2021.01.25.11.35.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 11:35:09 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: allow KVM_REQ_GET_NESTED_STATE_PAGES outside
 guest mode for VMX
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
References: <20210125172044.1360661-1-pbonzini@redhat.com>
 <YA8ZHrh9ca0lPJgk@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0b90c11b-0dce-60f3-c98d-3441b418e771@redhat.com>
Date:   Mon, 25 Jan 2021 20:35:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YA8ZHrh9ca0lPJgk@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/01/21 20:16, Sean Christopherson wrote:
>>   }
>>   
>> +static bool vmx_get_nested_state_pages(struct kvm_vcpu *vcpu)
>> +{
>> +	if (!nested_get_evmcs_page(vcpu))
>> +		return false;
>> +
>> +	if (is_guest_mode(vcpu) && !nested_get_vmcs12_pages(vcpu))
>> +		return false;
> nested_get_evmcs_page() will get called twice in the common case of
> is_guest_mode() == true.  I can't tell if that will ever be fatal, but it's
> definitely weird.  Maybe this?
> 
> 	if (!is_guest_mode(vcpu))
> 		return nested_get_evmcs_page(vcpu);
> 
> 	return nested_get_vmcs12_pages(vcpu);
> 

I wouldn't say there is a common case; however the idea was to remove 
the call to nested_get_evmcs_page from nested_get_vmcs12_pages, since 
that one is only needed after KVM_GET_NESTED_STATE and not during 
VMLAUNCH/VMRESUME.

Paolo

