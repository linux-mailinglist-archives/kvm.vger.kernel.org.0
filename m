Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E093D30D535
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 09:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbhBCI3m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 03:29:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44900 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232517AbhBCI3i (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 03:29:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612340892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hwrk+FTuLG7Q9mmQWSF89fyayVM9Juk+kBi6JrWoyJM=;
        b=DudyKzUXbQb66jy16nOaArrT4HDD/JQji7+xMuk1qBPCIgKSDQtK+W2LTRl7AuQu0Ey0xG
        NXvJv9iTL8AYByT/VpYCoZLjNV8FwkZEFRYa1jV/WxpQxtc0238p/g43noWON/oTXMt1zx
        25rWdVnMgrTBTqeu4S4DE1bsQSHJfgY=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-1BVDLe5UO0OcEAq27cImbA-1; Wed, 03 Feb 2021 03:28:10 -0500
X-MC-Unique: 1BVDLe5UO0OcEAq27cImbA-1
Received: by mail-ej1-f70.google.com with SMTP id eb5so1861636ejc.6
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 00:28:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Hwrk+FTuLG7Q9mmQWSF89fyayVM9Juk+kBi6JrWoyJM=;
        b=JYha81kbmWIOIqWpnVufxXwR1h2xPV+2PNGfvFlo1isD1LVx099oTqkjXa/Jpyhmrt
         4Hi9Ft0jnPWlho1DpPuUlp9H9gRCuWQT94BeXMl7U0XiwWJ+jMap+EilbtF0sC++rVlw
         3EhVWdK28OsLvDtrRRe/xd3yoyOxKEdnegIypRZRLQZ3FMnbMg/Esj+5PryIRurlKih5
         W/USGu8TwHuYcR7l/QSpMIC6rHWtlJJDYFgUnJ4wlv0WZgTB4ldMz6cJmxBhL0Zv+P81
         pbErxgRi47tXV1vPiU4SqTU4wIAvkxyjUWJQERpfFxISS81R9U72YlfBMwyNY6ueOEDW
         b+hQ==
X-Gm-Message-State: AOAM531yfvPbdXpoUYJ+WZX2bLD1p99WWZJuPXXeZh3gHyqQJ2X2dUgM
        4eNgi9CBa9nZ+t83ZfFMqCOKNj3Jb+l5Qf+Rw34huSV9TW+5ASiP0DelkpxX/hC1LoUYggZpZ8O
        vRq95WT0XOzES/uCVa/wE1Q/3u0fSkBZn1ZR1Xm56YHYWbINBdkgTIjklI4AS2ilz
X-Received: by 2002:a17:906:c00a:: with SMTP id e10mr2091763ejz.501.1612340889252;
        Wed, 03 Feb 2021 00:28:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwUvkxOC7hKKIz7OGBgJZSpg8doxelK0Cjst9iB13YoHobfg46zDnGcT5IzRnbxhQ0vS+MkRw==
X-Received: by 2002:a17:906:c00a:: with SMTP id e10mr2091744ejz.501.1612340888985;
        Wed, 03 Feb 2021 00:28:08 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id l13sm649535eji.49.2021.02.03.00.28.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 00:28:08 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: cleanup CR3 reserved bits checks
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20210202170244.89334-1-pbonzini@redhat.com>
 <YBmbM8PToDWr9ti/@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7077098b-d5f0-afe1-9924-def460d06f96@redhat.com>
Date:   Wed, 3 Feb 2021 09:28:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YBmbM8PToDWr9ti/@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/02/21 19:34, Sean Christopherson wrote:
> On Tue, Feb 02, 2021, Paolo Bonzini wrote:
>> If not in long mode, the low bits of CR3 are reserved but not enforced to
>> be zero, so remove those checks.  If in long mode, however, the MBZ bits
>> extend down to the highest physical address bit of the guest, excluding
>> the encryption bit.
>>
>> Make the checks consistent with the above, and match them between
>> nested_vmcb_checks and KVM_SET_SREGS.
>>
> Fixes + Cc:stable@?

Difficult to say what it fixes, it's been there forever for KVM_SET_SREGS.

For the nSVM part I'll go with

Fixes: 761e41693465 ("KVM: nSVM: Check that MBZ bits in CR3 and CR4 are 
not set on vmrun of nested guests")

Paolo

>> Signed-off-by: Paolo Bonzini<pbonzini@redhat.com>
> Reviewed-by: Sean Christopherson<seanjc@google.com>  
> 

