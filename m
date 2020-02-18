Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7D7B162A61
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 17:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgBRQZl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 11:25:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31999 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726399AbgBRQZk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 11:25:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582043139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5ZaVBnl5LTDIz8p3MqR4G5st87wrZLl8IZBtXDiurEw=;
        b=TXHwJ3XIzCXn7r+bzXk3wTDIGaSd5p+DIzQQovW8glftUDKApnk4247YFnfFLuxVokCWIs
        QLM7aATD3b/WtUNBF13F/PahbEiYsKb3uwL8iFLmNhkSnZVwUB134T38czCDTHKn818t6j
        aLUA7xO9dJ0iTLX7QAZc/uEbyTdPMII=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-xmaD6siiMJ2qvKgfV-T-Ow-1; Tue, 18 Feb 2020 11:25:26 -0500
X-MC-Unique: xmaD6siiMJ2qvKgfV-T-Ow-1
Received: by mail-wm1-f69.google.com with SMTP id w12so280716wmc.3
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2020 08:25:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5ZaVBnl5LTDIz8p3MqR4G5st87wrZLl8IZBtXDiurEw=;
        b=W7ctwCsL0RAFCWvOM+Rrw7LatBr9JZEYa1ti5CLY5w1nnWtrZjm5VPVwvIiXsXZmZa
         2q5PltmJryXTRDprq08GJ10X8dfLxDqZVY95AFwyg80yJlJITM/8neEnMiikPQK3V8mA
         6GwfmYmilWgPebUS5X+I26rT751pP9h3teJLSlicg//8t1LsqfZZDYJ59gyhTF0sptGY
         vWIMRYm7XXSy1CRpw5j93kUmxva67P5tsOlNIuurMP5pgosrQZ1Hdya0QqjV38AHSFhJ
         isj10TOt6JsuMLGY5T8+U22bgqS8vGmUtY8JrpIMfDMhAtbPEfpWfN8f2eSfw23r3kXd
         D1hw==
X-Gm-Message-State: APjAAAX8zgMZTuSj/YYK40HxJRnqb5+RsL56hGOGCg6QqrZ2IJlF0eJO
        D8LXL9xYV3yw14M2Lvr98FmFnwbBGDgZr4/c2/IZ1C4RuqFnRHvRdvyrSKskrBlV90F23qBCE+m
        TJ++IJtrbqoOW
X-Received: by 2002:adf:e68d:: with SMTP id r13mr29533047wrm.349.1582043125162;
        Tue, 18 Feb 2020 08:25:25 -0800 (PST)
X-Google-Smtp-Source: APXvYqwNLjKGcihL8iLl16MvvwxIr4m9OPysTo+s7RHCHBY/nU4biCD6WeXWya+F/KA6iuYQonH+9Q==
X-Received: by 2002:adf:e68d:: with SMTP id r13mr29533023wrm.349.1582043124928;
        Tue, 18 Feb 2020 08:25:24 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:59c7:c3ee:2dec:d2b4? ([2001:b07:6468:f312:59c7:c3ee:2dec:d2b4])
        by smtp.gmail.com with ESMTPSA id x6sm4075105wmi.44.2020.02.18.08.25.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 08:25:24 -0800 (PST)
Subject: Re: [PATCH] KVM: VMX: replace "fall through" with "return true" to
 indicate different case
To:     Joe Perches <joe@perches.com>, linmiaohe <linmiaohe@huawei.com>,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
References: <1581997168-20350-1-git-send-email-linmiaohe@huawei.com>
 <0e28c46fe2361f0bedf438818eb7bfd1197706e2.camel@perches.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <013d2bbc-6948-ab49-71ca-25da77915f63@redhat.com>
Date:   Tue, 18 Feb 2020 17:25:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <0e28c46fe2361f0bedf438818eb7bfd1197706e2.camel@perches.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/02/20 04:42, Joe Perches wrote:
> On Tue, 2020-02-18 at 11:39 +0800, linmiaohe wrote:
>> The second "/* fall through */" in rmode_exception() makes code harder to
>> read. Replace it with "return true" to indicate they are different cases
>> and also this improves the readability.
> []
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> []
>> @@ -4495,7 +4495,7 @@ static bool rmode_exception(struct kvm_vcpu *vcpu, int vec)
>>  		if (vcpu->guest_debug &
>>  			(KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP))
>>  			return false;
>> -		/* fall through */
>> +		return true;
> 
> perhaps
> 		return !(vcpu->guest_debug & (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP));

Nice, thanks Joe.

Paolo

