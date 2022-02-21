Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1F034BE964
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 19:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359021AbiBUNWy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 08:22:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359011AbiBUNWv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 08:22:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E15E5220C6
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 05:22:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645449743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IUxPuTiqjwjRtgGd1O/WAIWMjnIm6uWh+GDnc5nUQEw=;
        b=IB4YgrJgVLp0JgSxQ35ZXrvv9HojWAAUcSiZ+PkQ+l4bulLzCO7GkyfPV2/D0CLogES5M7
        4PHvS+P/WThuSaT2s7MIVBNOtUQ565aA0/brx0r7LpThKhsewjvhpXStIhstiYRw9BklIa
        GRa3hzmUsSVrrMVo6yHBsiEuqtZKVsQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-615-Gb7KXMI1MWmt3SA8SZ8bkg-1; Mon, 21 Feb 2022 08:22:21 -0500
X-MC-Unique: Gb7KXMI1MWmt3SA8SZ8bkg-1
Received: by mail-ed1-f72.google.com with SMTP id bq19-20020a056402215300b0040f276105a4so10150985edb.2
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 05:22:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IUxPuTiqjwjRtgGd1O/WAIWMjnIm6uWh+GDnc5nUQEw=;
        b=T8XQRz6d4hgGY/0sBvPjqacIJz+lLgDXfM4/8uBG3ubOHlUpa9E4SQfbwwhzQZzzL6
         KNoBYrwYGFCWPhLHgSan0Zmn6EVpwywfwniWu6T2kl/Yu77E6/+93/dijTpwK7g5pZdZ
         e/Tuwa8bhdFW+aqfFsuJgBRm0a3PxkcAa+31BfGBmZe+UgVhkxxjqGxnK7YSOWanGjeq
         pMI4GoiKACMoVeyoXlp+dsP4yn9WMBDXADcltK44XyFlpHXJZoX+RswfZaztyIccXwtv
         cDLrvdQLN3Vg9zgs/eyR44djZjJySw/SrSCLwehfQvzeLspRy1Ovqh2uzZJr6/xsl3+7
         ZRpA==
X-Gm-Message-State: AOAM530o7xcOPjasZkRzdtpfjdLLs1O8mF7Ardng+ZaMHM4P6WN4Li0+
        JfflBsRxGFqCC7IfctBroXpP0XHP0+3GWfA1fl9XkMlmw1MD1KrXjMxovENAMtOMbG07jnvQLOM
        d0DFY39YQ7r6L
X-Received: by 2002:a05:6402:1e8c:b0:411:7180:7dfc with SMTP id f12-20020a0564021e8c00b0041171807dfcmr21552011edf.74.1645449740574;
        Mon, 21 Feb 2022 05:22:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy2jozE/HKpdYV2YtHKjdyhTYjY8fpRSimjhfi/b8wrwkoJU700GkPkJr7G7EmpUZFD0rqW1w==
X-Received: by 2002:a05:6402:1e8c:b0:411:7180:7dfc with SMTP id f12-20020a0564021e8c00b0041171807dfcmr21551991edf.74.1645449740361;
        Mon, 21 Feb 2022 05:22:20 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id hs25sm5167755ejc.172.2022.02.21.05.22.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 05:22:19 -0800 (PST)
Message-ID: <76493240-46c4-61d1-8ce5-a4c5f6c1ecb8@redhat.com>
Date:   Mon, 21 Feb 2022 14:22:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] KVM: nSVM: fix nested tsc scaling when not enabled but
 MSR_AMD64_TSC_RATIO set
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
References: <0a0b61c5c071415f213a4704ebd73e65761ec1a3.camel@redhat.com>
 <20220221103331.58956-1-mlevitsk@redhat.com>
 <44604447-9686-24b3-4216-71d52eb1a6c2@redhat.com>
 <263fc33973fa6cea8001bddceed1f69153db5174.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <263fc33973fa6cea8001bddceed1f69153db5174.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/21/22 14:17, Maxim Levitsky wrote:
>> It's not clear how QEMU ends up writing MSR_AMD64_TSC_RATIO_DEFAULT
>> rather than 0, but we clearly have a bug in KVM.  It should not allow
>> writing 0 in the first place if tsc-ratio is not available in the VM.
> 
> Qemu currently (the code is very new so it can be changed) writes the initial value of
> 0 to this msr if tsc scaling is disabled in the guest, or MSR_AMD64_TSC_RATIO_DEFAULT
> if the tsc scaling is enabled.

It's released in 6.2, though, right?

> The guest can change it only when TSC scaling is enabled for it.
> If tsc scaling is not enabled, both guest reads or writes of this MSR get #GP.
> I only allowed qemu writes of this msr because I thought that qemu might
> first set the MSR and then set guest CPUID.
> 
> Also, for example the MSR_IA32_XSS uses the same logic in KVM.
> 
> As for why qemu sets this msr regardless of guest CPUID bit,
> it seemed to be cleaner this way - kvm_put_msrs in qemu seems not to
> check guest CPUID but rather only check that KVM supports this msr,
> which will be true regardless of guest's CPUID bit.

Yes, I agree it's cleaner in QEMU and consistent with others in KVM. 
However the value that is written should be the default one (which is 
usually zero, but not always and not in this case).

Paolo

