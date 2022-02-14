Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC3A4B4A40
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 11:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347109AbiBNKYy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 05:24:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346594AbiBNKYQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 05:24:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5D0DA6CA7B
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 01:56:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644832587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SLsDc3qsko5ZStHVuXDISh4k8xIj3+jxUHxwlaY2EiI=;
        b=NYI4pBft6JemInqhvFoDFDQtScG9nLEndl6OzxfW1XHu/h36TT/TOr+rrfdATbr0zharpy
        c/TbQNSMmoU+PqZWc726BzniMuIf67HAt9LETUZ/Ea6J6b1o8/6jN0ck14EXaSDIe+7Oav
        JnASm7tiULAqnDiHQcgY8QHHAw63apQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-133-OA4EyWa1NYSkqY0hcIy68A-1; Mon, 14 Feb 2022 04:56:25 -0500
X-MC-Unique: OA4EyWa1NYSkqY0hcIy68A-1
Received: by mail-ed1-f72.google.com with SMTP id g5-20020a056402090500b0040f28e1da47so9955231edz.8
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 01:56:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SLsDc3qsko5ZStHVuXDISh4k8xIj3+jxUHxwlaY2EiI=;
        b=NOzqv3qg0QapBiFbgkNbzBZgf+xOv9Rm/TU+vxPNflEmBTRxaPKNDfw/VdM2CWO/g4
         om9g1fnjc9FRdh8O8xaXBOeLUqpMDBk+kGsIgdO6qYUrKp1llk9oTY38yY5uf0POG2jn
         IXMZBerJRnPzG3yYi9tlFWuXqlPY5gwHFbZJENrFXghd3tzrG7d2puEJhHo8woxi7pNz
         cj6Yi1BGXP3zrXHdjGS6u08pKDEi60MzOCPXUJka6obEoxFaQp5fjGFgakNFb2tyV3xl
         7DB/FmNeEj7IouMyps00265yB4Rup4MW1zuZoMs9ps9/XodxJzI5ohjsDZJHTgYSECZd
         2QCw==
X-Gm-Message-State: AOAM531v1iv8TQ0E5tZJ7n7rtFN0R1khESaOIOgDeKcBnxaVASLeJKnB
        D4jofxCXo401oNQwkPI4vCWbXzo9OHCEv+2gUKt2h1Kh+3+y32j/U+Y1ppUrjcuthIX8Ju4wfYt
        JXUxYyPAU9NOt
X-Received: by 2002:a17:906:72c1:: with SMTP id m1mr11186700ejl.721.1644832584388;
        Mon, 14 Feb 2022 01:56:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzPSJr86OR0bAWvwpiFB7zD0OSccAYHsOwUsAXyqCn+3n/QqJQgehBaRd5o7nYGukbbYNzaBw==
X-Received: by 2002:a17:906:72c1:: with SMTP id m1mr11186678ejl.721.1644832584157;
        Mon, 14 Feb 2022 01:56:24 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id j5sm1792136ejs.69.2022.02.14.01.56.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Feb 2022 01:56:23 -0800 (PST)
Message-ID: <6bee793c-f7fc-2ede-0405-7a5d7968b175@redhat.com>
Date:   Mon, 14 Feb 2022 10:56:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 1/1] x86/kvm/fpu: Mask guest fpstate->xfeatures with
 guest_supported_xcr0
Content-Language: en-US
To:     David Edmondson <david.edmondson@oracle.com>
Cc:     Leonardo Bras <leobras@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220211060742.34083-1-leobras@redhat.com>
 <5fd84e2f-8ebc-9a4c-64bf-8d6a2c146629@redhat.com>
 <cunsfslpyvh.fsf@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <cunsfslpyvh.fsf@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/14/22 10:43, David Edmondson wrote:
> Sorry if this is a daft question:
> 
> In what situations will there be bits set in
> vcpu->arch.guest_supported_xcr0 that are not set in
> vcpu->arch.guest_fpu.fpstate->xfeatures ?
> 
> guest_supported_xcr0 is filtered based on supported_xcr0, which I would
> expect to weed out all bits that are not set in ->xfeatures.

Good point, so we can do just

	vcpu->arch.guest_fpu.fpstate->user_xfeatures =
		vcpu->arch.guest_supported_xcr0;

On top of this patch, we can even replace vcpu->arch.guest_supported_xcr0
with vcpu->arch.guest_fpu.fpstate->user_xfeatures.  Probably with local
variables or wrapper functions though, so as to keep the code readable.
For example:

static inline u64 kvm_guest_supported_xfd()
{
	u64 guest_supported_xcr0 = vcpu->arch.guest_fpu.fpstate->user_xfeatures;

	return guest_supported_xcr0 & XFEATURE_MASK_USER_DYNAMIC;
}

Also, already in this patch fpstate_realloc should do

         newfps->user_xfeatures = curfps->user_xfeatures | xfeatures;

only if !guest_fpu.  In other words, the user_xfeatures of the guest FPU
should be controlled exclusively by KVM_SET_CPUID2.

Thanks,

Paolo

