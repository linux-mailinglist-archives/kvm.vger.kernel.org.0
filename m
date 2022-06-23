Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4A2B5587D5
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 20:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbiFWSxF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 14:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiFWSwb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 14:52:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 68AF3DB9
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 10:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656007094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hO3C7xO3ja36osrf6zGLlB+eVxsywrftX4QKaeVYSqQ=;
        b=ELWxKeaw0PYoyrl3dLIsO9T7dniViaKgGJyEwfy6CUvn3VwnKzllGPsGCWSqWfLyciH0lv
        8Xv7vC38sdgTWrXha4pO1yQzLFUmlN82l0IkOs+gjXk0TxPTGGQUFSCEf3drh9l4GSeABb
        PohLpbefnJG3vYqxss2ArtVG97QS79g=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-BOg4CWH0Oq6QQzrEx76VWQ-1; Thu, 23 Jun 2022 13:58:13 -0400
X-MC-Unique: BOg4CWH0Oq6QQzrEx76VWQ-1
Received: by mail-ed1-f72.google.com with SMTP id z13-20020a056402274d00b004357fcdd51fso14476edd.17
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 10:58:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hO3C7xO3ja36osrf6zGLlB+eVxsywrftX4QKaeVYSqQ=;
        b=6mrpptAz//2OOm5FjbuFpjqwoO58b+7BbrlJLIijmTlOmxQRdB6jlBhbibxRcX7v3A
         kX6kPC+btlLG0lRdZukwVSfo76xQabZWFBk79cFRvK793YP0sGf8DMHY8uvzjHDR4iu0
         EvIvCKa7IgsAnEVfJNRYhnU8A7gl8FEacOaSbM04oEFkoe5DJuZTb5UTUdibM+v8TIvZ
         +QdEo/Vt7FiByC/rRJCVeGwBlEyXNmSeHg+fn0kzqj7hI1m+LEWrd1oAvj9+1x+gZdm9
         H/dE1wXiU4Z5EvsxGnQGETRwb4fb0yD3plqPuP1mXj2mOw/Lna+0bcqMw2dTYgqZBBbC
         fj7Q==
X-Gm-Message-State: AJIora/oG+VzhwSgoQZQwjlBgNCPwWuA/aIsFg6GEJDHNPNfSBxEFznA
        7WdkJbevH8L7DTMjSXKXEaiKPDse77TeY+wpdgIWTPCvryl9EWW7hTt7BetcKQBka5JsKKej33y
        MJOP84OT7grIQ
X-Received: by 2002:aa7:c952:0:b0:434:edcc:f247 with SMTP id h18-20020aa7c952000000b00434edccf247mr12040737edt.412.1656007092246;
        Thu, 23 Jun 2022 10:58:12 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vY722wduq0ncSL6sZXrBQYki6fKrhE9WhJwCUn2NqaPkVZNv02PSySZU23VNdhAvPIG00oWQ==
X-Received: by 2002:aa7:c952:0:b0:434:edcc:f247 with SMTP id h18-20020aa7c952000000b00434edccf247mr12040713edt.412.1656007092013;
        Thu, 23 Jun 2022 10:58:12 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id l1-20020a1709063d2100b006fe8bf56f53sm11199042ejf.43.2022.06.23.10.58.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jun 2022 10:58:11 -0700 (PDT)
Message-ID: <21ac5af2-6cb7-29a9-dcc5-467336951982@redhat.com>
Date:   Thu, 23 Jun 2022 19:58:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] MAINTAINERS: Reorganize KVM/x86 maintainership
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20220623114615.2600316-1-pbonzini@redhat.com>
 <878rpny47v.fsf@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <878rpny47v.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/23/22 14:05, Vitaly Kuznetsov wrote:
>> +KVM PARAVIRT (KVM/paravirt)
>> +M:	Paolo Bonzini <pbonzini@redhat.com>
>> +R:	Wanpeng Li <wanpengli@tencent.com>
>> +L:	kvm@vger.kernel.org
>> +S:	Supported
>> +T:	git git://git.kernel.org/pub/scm/virt/kvm/kvm.git
>> +F:	arch/x86/kernel/kvm.c
>> +F:	arch/x86/kernel/kvmclock.c
>> +F:	arch/x86/include/asm/pvclock-abi.h
>> +F:	include/linux/kvm_para.h
>> +F:	include/uapi/linux/kvm_para.h
>> +F:	include/uapi/asm-generic/kvm_para.h
>> +F:	include/asm-generic/kvm_para.h
>> +F:	arch/um/include/asm/kvm_para.h
>> +F:	arch/x86/include/asm/kvm_para.h
>> +F:	arch/x86/include/uapi/asm/kvm_para.h
> 
> If we add Async PF to the 'KVM/paravirt' scope:
> 
> +F:   virt/kvm/async_pf.c
> and maybe even
> +F:   arch/x86/kvm/x86.c
> 
> then I can probably volunteer as a reviewer.

There is of course a host component to all paravirt infrastructure, the 
idea was to have a separate part specifically for the guest side.  It 
tends to have its own set of issues (e.g. suspend/resume, 32-bit, etc.). 
  I will add you anyway as reviewer, it makes sense.

>> +KVM X86 HYPER-V (KVM/hyper-v)
>> +M:	Vitaly Kuznetsov <vkuznets@redhat.com>
>> +M:	Sean Christopherson <seanjc@google.com>
>> +M:	Paolo Bonzini <pbonzini@redhat.com>
> 
> Don't we also need:
> 
> S:   Supported
> L:   kvm@vger.kernel.org
> 
> here?

Yeah, especially the "S" (the list is caught by the generic KVM part).

Paolo

>> +T:	git git://git.kernel.org/pub/scm/virt/kvm/kvm.git
>> +F:	arch/x86/kvm/hyperv.*
>> +F:	arch/x86/kvm/kvm_onhyperv.*
>> +F:	arch/x86/kvm/svm/svm_onhyperv.*
> 
> +F:   arch/x86/kvm/svm/hyperv.*
> 
>> +F:	arch/x86/kvm/vmx/evmcs.*
>> +
>>   KERNFS
>>   M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>   M:	Tejun Heo <tj@kernel.org>
> 

