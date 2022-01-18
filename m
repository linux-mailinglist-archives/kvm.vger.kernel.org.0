Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02083492C0A
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 18:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347071AbiARRM1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 12:12:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48864 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346947AbiARRMY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 12:12:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642525944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CTFcvZshGd418XxQ4f5JMIidhKASZvElX59Zaynhob4=;
        b=aopeD5+oiyszdQ522kMhW5R1F4CAJztoJVdZm7qOnbdbtk12hAFBuIJzp8hTV/h7MYPRBX
        v30CzLC0fxDiZ+vDTS9MM+Q6Ve6EBjEw8CoWQx+jv4Y+ZsajoJ8w+Nd2vy6RpbjCp5FW1k
        Q7DdzY8LOC9MHn7+YBmAy6G+2GuSMww=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-YKW-Ga2XPOqkCpzoOTT86g-1; Tue, 18 Jan 2022 12:12:20 -0500
X-MC-Unique: YKW-Ga2XPOqkCpzoOTT86g-1
Received: by mail-ed1-f72.google.com with SMTP id k10-20020a50cb8a000000b00403c8326f2aso1453377edi.6
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 09:12:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CTFcvZshGd418XxQ4f5JMIidhKASZvElX59Zaynhob4=;
        b=McWxy22MlU0ecxTD5SNrN+8nM8nkp1nYggyxYi3Yh94V+EMk4c1py4AK0X55q+dGDk
         TTQOFeD45ufXl0PuFcWryXe95t7vUrOmoqsx0NfgZraMgGzEUVR1R/jqt+LiMe3NiPdY
         hfX7Ql8FylytiZdZlv62r2Bp5G6kCCqMOgA21puh5i5lMzzbXLEaaxJhlXGjpdYoxsaf
         m+iZ/KiBTat2X+ruaBgGl68gDTiOCJSjki0dXESLmwt5hnGMM0dNUqFimPVhytVnh08K
         wqIVnJ1ox/TAV0rO03nV6rx172ZuRqrTOXSRfEEXoO7QfEmhVy235ab8BlC7I4abV1ck
         WN/g==
X-Gm-Message-State: AOAM533kd0D9j/cGsYYH76cVV4LjYuX7vtyX2UgSG5MNqOg/UkdsfFOd
        qABfVFo2YCg5esLyzAkl9b/7p14/6LLdlnYYS5pkDIZm7F2UiIVJmHoheObQ3B/i0v2WgJ9MW6K
        4GfE223S1tp8k
X-Received: by 2002:a17:906:9746:: with SMTP id o6mr20727227ejy.112.1642525937918;
        Tue, 18 Jan 2022 09:12:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwljlno0wVWgKk1pGv+IEFTQBr9kKOJljcK59bCW2njywhQcJtIwVh22D7avYUEqToB1+2oCw==
X-Received: by 2002:a17:906:9746:: with SMTP id o6mr20727210ejy.112.1642525937722;
        Tue, 18 Jan 2022 09:12:17 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id 16sm5601542ejx.149.2022.01.18.09.12.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 09:12:17 -0800 (PST)
Message-ID: <4a87b289-05a7-8247-9529-a8148924a7c5@redhat.com>
Date:   Tue, 18 Jan 2022 18:12:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 0/4] KVM: x86: Partially allow KVM_SET_CPUID{,2} after
 KVM_RUN for CPU hotplug
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Igor Mammedov <imammedo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
References: <20220117150542.2176196-1-vkuznets@redhat.com>
 <20220118153531.11e73048@redhat.com>
 <498eb39c-c50a-afef-4d46-5c6753489d7e@redhat.com>
 <YebwkcAgszlyTzJ+@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YebwkcAgszlyTzJ+@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/18/22 17:53, Sean Christopherson wrote:
>>
>> and I think we should redo all or most of kvm_update_cpuid_runtime
>> the same way.
> Please no.  xstate_required_size() requires multiple host CPUID calls, and glibc
> does CPUID.0xD.0x0 and CPUID.0xD.0x1 as part of its initialization, i.e. launching
> a new userspace process in the guest will see additional performance overhread due
> to KVM dynamically computing the XSAVE size instead of caching it based on vCPU
> state.  Nested virtualization would be especially painful as every one of those
> "host" CPUID invocations will trigger and exit from L1=>L0.
> 

Agreed, but all of the required data is by Linux cached in 
xstate_offsets, xstate_sizes and xstate_comp_offsets; moving 
xstate_required_size to xstate.c and skipping the host CPUID would 
probably be a good idea nevertheless.

Paolo

