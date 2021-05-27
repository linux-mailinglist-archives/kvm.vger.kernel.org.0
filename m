Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1DB8392F23
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 15:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236255AbhE0NJw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 09:09:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20828 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235963AbhE0NJw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 May 2021 09:09:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622120899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4/m/R0Y4SSIGq3cr+IGc7ZzV74IkxCMTJe5tIS2RfzU=;
        b=QQaQ/W7tqm9AFxSL/ap5IKyAaHNN0jvTsxAfvyoEt1VP2q9yr8qSworUmiawbdQbv8lSz1
        p0DBtbkcXN8j3ZdmHK/W3nTppn7/NId9vKC/WPdZAriZldDMHVswc4ltNfDeq3NPTq87Yi
        VwLaTBZ50ie5k6hJ9BSH0tE+iCKFi3o=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-O3pu3WFGNyucAsXl3HxnbA-1; Thu, 27 May 2021 09:08:17 -0400
X-MC-Unique: O3pu3WFGNyucAsXl3HxnbA-1
Received: by mail-ej1-f71.google.com with SMTP id p18-20020a1709067852b02903dab2a3e1easo1651708ejm.17
        for <kvm@vger.kernel.org>; Thu, 27 May 2021 06:08:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4/m/R0Y4SSIGq3cr+IGc7ZzV74IkxCMTJe5tIS2RfzU=;
        b=YqsXGI0N68GQYdlgc/NoqrSGcoojF6qq8/H24G4d+4srRSJc4VoqB7UqohWU70UeYa
         6muM9oPYWHqNyIr5qKh5CR3vtsGq1bsliPK/1w5EyMyCj7FTVn40+tPYLKORQGeQv9Xa
         svbXEZQo3xzc2k223OY2VzIShl+relbThqYtDtdfO7oKe+0rUmOtJeGat3+I2RdjqYGp
         UUixG7+G2B8fyKWs900V6Cg43AvpWMzhPyRXAbHM/olGbZpFqIXfhUso8knn25fFklN0
         t748Mhjljo/RbOB8SuQrQnFWE0T85bxLSKe1mTBlnwCZ4CANZdGf3GZENAjJ6v1X7i81
         gRCg==
X-Gm-Message-State: AOAM533hHhGjsski7rkL1mOxcNmf6TJCGhvZhF88kCE5MNuzFudho/4+
        gmTPZzFSbKVPbdbf/qS56M3AEU4aJMf1L0Dh5FA8wgMK1X/lTz30g8PWLStDnvY+UWEECYXqsja
        TrSeJZvzh0IHz
X-Received: by 2002:a05:6402:268f:: with SMTP id w15mr3915295edd.321.1622120896106;
        Thu, 27 May 2021 06:08:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwbFOvAXWs89cDDtIzzw6gRGYvp7A0dnMp3IKHJUpfq+3OyEwsfxK65t5dXbkPwYYGx4PKWQg==
X-Received: by 2002:a05:6402:268f:: with SMTP id w15mr3915270edd.321.1622120895958;
        Thu, 27 May 2021 06:08:15 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y23sm1063513eds.60.2021.05.27.06.08.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 May 2021 06:08:15 -0700 (PDT)
To:     "Stamatis, Ilias" <ilstam@amazon.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "jmattson@google.com" <jmattson@google.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "zamsden@gmail.com" <zamsden@gmail.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
References: <20210526184418.28881-1-ilstam@amazon.com>
 <20210526184418.28881-10-ilstam@amazon.com>
 <faa225b3b7518feea7df0ee69d6bf386a04824dc.camel@amazon.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v4 09/11] KVM: X86: Add vendor callbacks for writing the
 TSC multiplier
Message-ID: <9e971115-5634-e64e-72b6-5e41c024c796@redhat.com>
Date:   Thu, 27 May 2021 15:08:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <faa225b3b7518feea7df0ee69d6bf386a04824dc.camel@amazon.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/05/21 10:33, Stamatis, Ilias wrote:
>>   #ifdef CONFIG_X86_64
>> @@ -10444,6 +10461,7 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
>>   		return;
>>   	vcpu_load(vcpu);
>>   	kvm_synchronize_tsc(vcpu, 0);
>> +	kvm_vcpu_write_tsc_multiplier(vcpu, kvm_default_tsc_scaling_ratio);
> Hmm, I'm actually thinking now that this might not be correct. For example in
> case we hotplug a new vCPU but the other vCPUs don't use the default ratio.

It is correct, the TSC frequency can be set per CPU (which is useless 
except possibly for debugging OS timekeeping, but still).  So, the 
default kHz after hotplug is the host frequency.

It doesn't really matter because it only affects the fixed delta between 
the hotplugged CPU and the others as soon as userspace sets the 
frequency to the correct value.

Paolo

