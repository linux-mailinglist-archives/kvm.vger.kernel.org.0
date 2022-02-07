Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0805A4AC660
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 17:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386548AbiBGQpG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 11:45:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353078AbiBGQmT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 11:42:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 63713C0401D5
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 08:42:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644252137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u+CL0KUtQWIFIsBQcgovKxwmmoLpjMGkHHquq+gSRNM=;
        b=QcYbeqtYEZLs++DOxq+FVIXpvzDtB9VxqxyIKVCVyg8qL7SXpS8kLbk2QFTCQcheU6te+C
        NubSqHgSVAR5HBEnZIQq+YXVN7fKNP85ZDglKbQWPVK4kot0NVOU3Moa+3Rww4aZqCEE2e
        2hZtycnmDBQdqMy387j6CAg+5qhy7t8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-0CKYaWARP5eNksrD7S0oIQ-1; Mon, 07 Feb 2022 11:42:16 -0500
X-MC-Unique: 0CKYaWARP5eNksrD7S0oIQ-1
Received: by mail-ed1-f72.google.com with SMTP id l19-20020a056402231300b0040f2d6b4ec4so4205194eda.0
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 08:42:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=u+CL0KUtQWIFIsBQcgovKxwmmoLpjMGkHHquq+gSRNM=;
        b=T5hHoQjI/K2BKXyLYGuiuYhaensL3SMJYQsmO5csRRgtF3+oEkeq80vN8EyU9kRd+f
         Thhrg5jaXEVf8f4Dy0TnB8t5D80wWV6Wu3UcsKrFRt1ElfWGhwMAjzU0Hlosb8zS6+mA
         o/vlQQO2Eu4JwLj+GnqCjjLivvzLwZMuAz/A16YLIzfTH2N4jh0mG0nGi8lSv+RJ1qDj
         J63Qe8d+3yQCYqb2baVdCF4eX4lY9pbHQuR3LCI4v3UgtLVRj1ort968YtJNZu79eaov
         xHT+iME7B8lXc9h17raP3vXyMF46sQVQ9A0dejTxoeouf1/ese6LcdjQjvpHmgkn2Ec5
         +g/g==
X-Gm-Message-State: AOAM533piACyXIBropw1isr6qWyEX+zE+oX/myXqox9aCPeVgePfAPye
        5w8Ag6B9Z1d+1/9qMkHwoDJqYrjGGTa8uXj7gVOYcFMAUetAVewplMjm+YIy8xCDWv0UHOTNBYf
        k4TAKY2Bx+fhs
X-Received: by 2002:a17:907:ea2:: with SMTP id ho34mr446840ejc.698.1644252135077;
        Mon, 07 Feb 2022 08:42:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxNpEU6WytiUFnQp7PYfH3Tt6sU8xxTEi7RAX+E4JzEB3Jp3zq/IxyRZu2VJHKsJPI1lt8B2w==
X-Received: by 2002:a17:907:ea2:: with SMTP id ho34mr446829ejc.698.1644252134896;
        Mon, 07 Feb 2022 08:42:14 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id ot38sm1445092ejb.131.2022.02.07.08.42.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 08:42:14 -0800 (PST)
Message-ID: <f73f73a0-1fbc-dcf7-efb7-776ef9818406@redhat.com>
Date:   Mon, 7 Feb 2022 17:42:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 6/7] selftests: KVM: Add test for BNDCFGS VMX control
 MSR bits
Content-Language: en-US
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20220204204705.3538240-1-oupton@google.com>
 <20220204204705.3538240-7-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220204204705.3538240-7-oupton@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/4/22 21:47, Oliver Upton wrote:
> +	/*
> +	 * Test that KVM will set these bits regardless of userspace if the
> +	 * guest CPUID exposes MPX.
> +	 */
> +	test_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_ENTRY_CTLS, 0,
> +			     VM_ENTRY_LOAD_BNDCFGS,
> +			     VM_ENTRY_LOAD_BNDCFGS,
> +			     0);
> +	test_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_EXIT_CTLS, 0,
> +			     VM_EXIT_CLEAR_BNDCFGS,
> +			     VM_EXIT_CLEAR_BNDCFGS,
> +			     0);
> +

I wouldn't expect this behavior.

> +	/*
> +	 * Disable the quirk, giving userspace control of the VMX capability
> +	 * MSRs.
> +	 */
> +	cap.cap = KVM_CAP_DISABLE_QUIRKS;
> +	cap.args[0] = KVM_X86_QUIRK_TWEAK_VMX_CTRL_MSRS;
> +	vm_enable_cap(vm, &cap);
> +
> +	/*
> +	 * Test that userspace can clear these bits, even if it exposes MPX.
> +	 */
> +	test_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_ENTRY_CTLS, 0,
> +			     VM_ENTRY_LOAD_BNDCFGS,
> +			     0,
> +			     VM_ENTRY_LOAD_BNDCFGS);
> +	test_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_EXIT_CTLS, 0,
> +			     VM_EXIT_CLEAR_BNDCFGS,
> +			     0,
> +			     VM_EXIT_CLEAR_BNDCFGS);

and likewise I would have expected this one to work without need for a 
quirk.

It's also missing a testcase that sets clears MPX and checks that the 
BNDCFGS controls disappear, I think.

Paolo

