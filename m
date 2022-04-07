Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24C874F7EC2
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 14:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238510AbiDGMOg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 08:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbiDGMOe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 08:14:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B59F51E95E5
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 05:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649333552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DGcIcM8gJ4Iu3qQi5hlBAso8Rq25Z0euqo8ngas0nfY=;
        b=QzRiiR3t0pGg9Y9OArnXVw55pTeHjQdL4sEYCq2CZq46B/kXZGP1N6m8FWol45JeQeyjvT
        adDi3V5rgnrM0KWtF/PXt6yuf3gAwGqXl23zsYj09Txf6ozbAYwHurdHaDwh0ffMQ5MeW7
        bUE4VO98rFe9lR9Xbr03C47ER5FasAk=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-425-3C2p00QrPIOcbOmwE_owmg-1; Thu, 07 Apr 2022 08:12:31 -0400
X-MC-Unique: 3C2p00QrPIOcbOmwE_owmg-1
Received: by mail-ed1-f72.google.com with SMTP id cx4-20020a05640222a400b0041cf617aefdso2576722edb.14
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 05:12:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DGcIcM8gJ4Iu3qQi5hlBAso8Rq25Z0euqo8ngas0nfY=;
        b=fSS+v244j0TNQvvgc1lBbWCsqIOnigjEqyYO7v1Ux0BcqjsKdkmz55jr8TNvjzoc4P
         u4UE7tgzIVYk+2YVXPDhRW5c6wkg/EMpTgcPREPSUbR9wrGSCKDrSeOkFwmxTYw0YvHv
         QYyoSB0dBtbRGQawb6JzfPr4pBpOW1HQTtNvqTO8LfQMborMnfb08RiONKIl1fdlLebv
         PTjOnTVayjlbvuGE17KDdSubyetg3GSLU5ezo9vy4v/nQYcCSndP2YuT9DC1nEqxGRDx
         Opv1Pe23qfwuIypcc6BgF7IXiFil4Iihb1Qn+tusXMteILfm8D8pPmfIHM6z9uiRw9NI
         UmfQ==
X-Gm-Message-State: AOAM530zzXa2gaPnnWeHSMoIFzTg4eceKZCgPmhOTsxptvCsXXeMlAJQ
        bwafR8gwmLT1TkBuw/p4UJV8F/6U0mNQb3DlCnxg4XQJnDqGtFngMbFtpcoPXbS5ohskGMLNV5z
        teTtcdXi167Uq
X-Received: by 2002:aa7:d311:0:b0:419:443b:6222 with SMTP id p17-20020aa7d311000000b00419443b6222mr13675493edq.161.1649333550543;
        Thu, 07 Apr 2022 05:12:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxl+xQ1ipUlMGquPKy+T2ZIFLwAwclwboSbty4izLi6yxlztoj7nwo020S5K2gVDdlVcMlaZA==
X-Received: by 2002:aa7:d311:0:b0:419:443b:6222 with SMTP id p17-20020aa7d311000000b00419443b6222mr13675475edq.161.1649333550365;
        Thu, 07 Apr 2022 05:12:30 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id k12-20020a170906054c00b006e8289dc23csm1302658eja.9.2022.04.07.05.12.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 05:12:29 -0700 (PDT)
Message-ID: <f13f2736-626a-267b-db38-70a81872a325@redhat.com>
Date:   Thu, 7 Apr 2022 14:12:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 101/104] KVM: TDX: Silently ignore INIT/SIPI
Content-Language: en-US
To:     Xiaoyao Li <xiaoyao.li@intel.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <d0eb8fa53e782a244397168df856f9f904e4d1cd.1646422845.git.isaku.yamahata@intel.com>
 <efbe06a7-3624-2a5a-c1c4-be86f63951e3@redhat.com>
 <48ab3a81-a353-e6ee-7718-69c260c9ea17@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <48ab3a81-a353-e6ee-7718-69c260c9ea17@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/7/22 13:09, Xiaoyao Li wrote:
> On 4/5/2022 11:48 PM, Paolo Bonzini wrote:
>> On 3/4/22 20:49, isaku.yamahata@intel.com wrote:
>>> +        if (kvm_init_sipi_unsupported(vcpu->kvm))
>>> +            /*
>>> +             * TDX doesn't support INIT.  Ignore INIT event.  In the
>>> +             * case of SIPI, the callback of
>>> +             * vcpu_deliver_sipi_vector ignores it.
>>> +             */
>>>               vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
>>> -        else
>>> -            vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
>>> +        else {
>>> +            kvm_vcpu_reset(vcpu, true);
>>> +            if (kvm_vcpu_is_bsp(apic->vcpu))
>>> +                vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
>>> +            else
>>> +                vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
>>> +        }
>>
>> Should you check vcpu->arch.guest_state_protected instead of 
>> special-casing TDX? 
> 
> We cannot use vcpu->arch.guest_state_protected because TDX supports 
> debug TD, of which the states are not protected.
> 
> At least we need another flag, I think.

Let's add .deliver_init to the kvm_x86_ops then.

Paolo

