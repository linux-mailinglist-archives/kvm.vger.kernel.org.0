Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19A844CB131
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 22:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245242AbiCBVXd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 16:23:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245229AbiCBVXa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 16:23:30 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8431C28E10
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 13:22:46 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id r10so4791016wrp.3
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 13:22:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VgJl7z7vuGWd7rHTz9gz4bq0cM5zqmJ89jDTxajC1wE=;
        b=f7Vmgbkie6QJS/6dyNXA90IcIa2QKzdhwmnUilLY0NTDeORT6zayqhgeCuGsyrc6WI
         RMS7gkQed4AGPIkG2zmtOjco9xI7CA5Bf8sFVCqDZwugNhhmwEvMShX7qzzRUkpagf14
         H/ud4X2UIyUY5Uw8b5TK5pyXJ5w/0vPr4DAk4OAgx/y/W/KU4k6Bkq/ppHGHKuHDGvnd
         VursWw4kOwWC4Wd/7nw03V3xzmBgeeofI2jxxbZPoY5ZCYHCYSZnekUD4cHwkQvfani9
         dqf8LZZ+OezEvFyZWCWo4k/i9dhUkR6U0j9Fcatawqkf/xdp0k0VxMAcP+mh7Ivbi7m2
         ra5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VgJl7z7vuGWd7rHTz9gz4bq0cM5zqmJ89jDTxajC1wE=;
        b=F4o43GOXCm18fr6hFKNtHFfKG/wwXHtY50nDIgind/wXexT5HFAa3mKxefsjCgTTt8
         Y4HtNjbUn5SH5odDM1jr8qV+gAkaSI8LAMXEg49obyZc0X5RAMNCdVNCqeSPH5JWvDyv
         pickfBnMF8EsSR93N3eC1jry6LuUtG7plcWRyb3H5lRtREwf1GHFnIEQ97Vc5Ntvfnf0
         oXQude8mPqncdXqAKsmsiXnqsiIML3QGtZefH4XHDgLFd8RVEahU9sXrjNdscnfXMv5B
         Fc50qmLSOxjF4u04nsfi4ZBqWCsQwKrgqMJ9uhnL6OWjSrFDmjPoGOOr/oD/8lWweO8Q
         +0mA==
X-Gm-Message-State: AOAM531oz9fUNf0bDUUTEUVqb/zwetxvHRlYWjsGzd4YZQtONfr/6CiE
        OmmCFEzSh6pXQeZ8UcC62kI=
X-Google-Smtp-Source: ABdhPJx6OHZAuDqfJV+2otcvseqemmZk95gZ48M0A/03y+RdmUX0CfDWEfsnMWAicKBWAaKjqU4cDQ==
X-Received: by 2002:adf:ec41:0:b0:1ed:beee:6f8f with SMTP id w1-20020adfec41000000b001edbeee6f8fmr23698778wrn.110.1646256165155;
        Wed, 02 Mar 2022 13:22:45 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id bd5-20020a05600c1f0500b00387d812a267sm97904wmb.37.2022.03.02.13.22.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 13:22:44 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <4d4606f4-dbc9-d3a4-929e-0ea07182054c@redhat.com>
Date:   Wed, 2 Mar 2022 22:22:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v4 1/8] KVM: nVMX: Keep KVM updates to BNDCFGS ctrl bits
 across MSR write
Content-Language: en-US
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>
References: <20220301060351.442881-1-oupton@google.com>
 <20220301060351.442881-2-oupton@google.com>
 <4e678b4f-4093-fa67-2c4e-e25ec2ced6d5@redhat.com>
 <Yh5pYhDQbzWQOdIx@google.com>
 <b839fa78-c8ec-7996-dba7-685ea48ca33d@redhat.com>
 <Yh/Y3E4NTfSa4I/g@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yh/Y3E4NTfSa4I/g@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/2/22 21:51, Oliver Upton wrote:
> On Wed, Mar 02, 2022 at 01:21:23PM +0100, Paolo Bonzini wrote:
>> On 3/1/22 19:43, Oliver Upton wrote:
>>> Right, a 1-setting of '{load,clear} IA32_BNDCFGS' should really be the
>>> responsibility of userspace. My issue is that the commit message in
>>> commit 5f76f6f5ff96 ("KVM: nVMX: Do not expose MPX VMX controls when
>>> guest MPX disabled") suggests that userspace can expect these bits to be
>>> configured based on guest CPUID. Furthermore, before commit aedbaf4f6afd
>>> ("KVM: x86: Extract kvm_update_cpuid_runtime() from
>>> kvm_update_cpuid()"), if userspace clears these bits, KVM will continue
>>> to set them based on CPUID.
>>>
>>> What is the userspace expectation here? If we are saying that changes to
>>> IA32_VMX_TRUE_{ENTRY,EXIT}_CTLS after userspace writes these MSRs is a
>>> bug, then I agree aedbaf4f6afd is in fact a bugfix. But, the commit
>>> message in 5f76f6f5ff96 seems to indicate that userspace wants KVM to
>>> configure these bits based on guest CPUID.
>>
>> Yes, but I think it's reasonable that userspace wants to override them.  It
>> has to do that after KVM_SET_CPUID2, but that's okay too.
>>
> 
> In that case, I can rework the tests at the end of this series to ensure
> userspace's ability to override w/o a quirk. Sorry for the toil,
> aedbaf4f6afd caused some breakage for us internally, but really is just
> a userspace bug.

How did vanadium break?

Paolo

> Is it possible to pick up patch 4/8 "KVM: x86: Introduce
> KVM_CAP_DISABLE_QUIRKS2" independent of the rest of this series?

