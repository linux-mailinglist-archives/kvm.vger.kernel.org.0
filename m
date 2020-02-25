Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 529FC16C329
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 15:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730455AbgBYOB6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 09:01:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59656 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730340AbgBYOB6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 09:01:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582639317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cy4Mge9KuRHZ+vguZEp3MFbF3jZxqc31nOjzMlddL7c=;
        b=BZjsPQ/KWIXemI6+c8WFO5hd77as+4Uf6aaalsJ5KWGRkR3TZbn8QYXprnM9yBZsBbQMgl
        VwTh31gE+aGZlAvWONXjyOAHmTP5NfVFU2wz4uVAF2mjTvHoLLiGWOtgw4ypetYeuX5hhl
        bfoU7YBqCIZ4SXCw6M7i13WBThIuRyg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-0YBDugrTOWiHLJ1X7mDiXA-1; Tue, 25 Feb 2020 09:01:55 -0500
X-MC-Unique: 0YBDugrTOWiHLJ1X7mDiXA-1
Received: by mail-wr1-f71.google.com with SMTP id o6so7327930wrp.8
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 06:01:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Cy4Mge9KuRHZ+vguZEp3MFbF3jZxqc31nOjzMlddL7c=;
        b=jPZJE7MDdF8z6nLgwFCz3xUBHazLsFhqzjh5bM+aCb6Lbs0QXuDHx9kbAf9nNfBSCt
         V4Z2QnRX/mGdmbtwbDj5AUKBxo+ncyv2en4bqfIdrMKFXmoLAEOAhbo3yxShHM9ykcK9
         ABebWKq3b3J0ZOgt+57SVP5utPFl4YbnsP7suWgfwZrHGJkVYo5LW6OQkl4/13Uh5d6k
         9CO4w1Ce2K5MakPP4mP7/JN2huP9Ew898wJJZ0RVtHrDm03SivAlSgcDjxrdA65pv4TY
         pTCcuEkMdzRjiKgJKnpmDQnUbr9pYjpwQHMBB/m631arCVySplGPdcTVyihYmlviFIdE
         zPFA==
X-Gm-Message-State: APjAAAUhQ3gKsR4CF9kMoXn114abMhXg+vZ5r82JdTy6zHG5ORL4aZzH
        MdQXkuPpZcdvIQDEGNkLHCagSRUnMbwoeq3bzkUIDKHVoMo3PNsO/OzWyLwiZKu2ygRCplTtIa7
        cCyhli8GzJXKK
X-Received: by 2002:a1c:cc06:: with SMTP id h6mr5676624wmb.118.1582639313983;
        Tue, 25 Feb 2020 06:01:53 -0800 (PST)
X-Google-Smtp-Source: APXvYqwcqZv16UHutDm/y3gCnBP3VcZYojhMIJsMMUPRJNFOL5jWS8OmVMbBl1uO6UKRP4W4maomyw==
X-Received: by 2002:a1c:cc06:: with SMTP id h6mr5676587wmb.118.1582639313626;
        Tue, 25 Feb 2020 06:01:53 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:3577:1cfe:d98a:5fb6? ([2001:b07:6468:f312:3577:1cfe:d98a:5fb6])
        by smtp.gmail.com with ESMTPSA id c9sm4324260wmc.47.2020.02.25.06.01.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 06:01:52 -0800 (PST)
Subject: Re: [PATCH] KVM: SVM: allocate AVIC data structures based on kvm_amd
 moduleparameter
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     rmuncrief@humanavance.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <1582617278-50338-1-git-send-email-pbonzini@redhat.com>
 <874kven5kv.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d2c3471d-3234-5e0a-0c76-872040a65bb6@redhat.com>
Date:   Tue, 25 Feb 2020 15:01:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <874kven5kv.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/02/20 14:45, Vitaly Kuznetsov wrote:
>>  	int ret;
>> +	struct kvm_vcpu *vcpu = &svm->vcpu;
>>  
>> -	if (!kvm_vcpu_apicv_active(&svm->vcpu))
>> +	if (!avic || !irqchip_in_kernel(vcpu->kvm))
>>  		return 0;
>>  
>>  	ret = avic_init_backing_page(&svm->vcpu);
> Out of pure curiosity,
> 
> when irqchip_in_kernel() is false, can we still get to .update_pi_irte()
> (svm_update_pi_irte()) -> get_pi_vcpu_info() -> "vcpu_info->pi_desc_addr
> = __sme_set(page_to_phys((*svm)->avic_backing_page));" -> crash! or is
> there anything which make this impossible?

No, because kvm_arch_irqfd_allowed returns false so you cannot create
any irqfd (svm_update_pi_irte is called when virt/lib/irqbypass.c finds
a match between two eventfds in KVM and VFIO).

Paolo

