Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E45614FE76D
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 19:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244494AbiDLRqt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 13:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237821AbiDLRqp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 13:46:45 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE6A4B861
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 10:44:26 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id c10so7691488wrb.1
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 10:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MesTeAQiR5MsWz1PF2h9v/br1yfvh2N2OY7/RCqRFXA=;
        b=jNsEKvb+PTg445VqdjpvWYBaVSQO7P7DXUvWvuTUHYY6YP+3hRT+yEuOlO7Y6ih5Lp
         FFaku5RN7Mtwb8h1Brrz2H/uETMnh5RMow1Y3RGJ1DncW8u56GFvrZ06iK05OfmmFQnO
         MVxP8hrd9wnNO7EZvrYHbBx0RSbmAGqZZP957iQHUz+ApJw/OZKZDGZ7ZO2IB3RdfVoY
         ka92o3R+6z1kVq5gGCXkslj1BME5bwvHxPBGYf+IvcTrad1xQ7uatiZHfzBZuoshv0kM
         GM+gIJF+E38BIjoTtukLfpD7nGQA0zp52X86u16wtHNt9qXyl8RjjQZdV5nxDdYlzkYp
         fpKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MesTeAQiR5MsWz1PF2h9v/br1yfvh2N2OY7/RCqRFXA=;
        b=Us4ED5bbfWZvMfVaohKrPbLxfp/HYg6lAh52DTipQXqALnmyXHeHJcIde0+Do/dcqf
         cMs2A7qFEHxkRZ21rPxGW9ZfU8Bhva57+3Q5GnBadG5YBQDzCCUkKA1Sz88VWnR/N37o
         TdXaiFS9ttlOa1werT8t6d4bA/R2nEtSe+QA5zR5QH5UDJfKcwwbxZaG8RYgEb0pOlK2
         Rv6NXNXig8bZMk9pCWuJwvQr8QvLqdvPFaBO17znUFY69ZdTYNBwICqiEJDlNhSX0q72
         Dg3adxrJK6207oLYfAMpV/9TU4h3HsaUwN1fR2fOOFsavY+od4h2snnF6mDKcTAv/v+C
         TZLA==
X-Gm-Message-State: AOAM532VXu8qL6+KQ81o9CuM4H1azL1w4899pRV0AxN06Ux4YZLHJedN
        YEmZsI5846Z/7CPTXSMsbYwHOHYNr31lAg==
X-Google-Smtp-Source: ABdhPJzDo+gqxEpGSLYj1qMznDxo/h4SBvRdl8FRFbJSWDI7o9GyMeNDTAwovy3AjsRWlAK3Wth4Nw==
X-Received: by 2002:a05:6000:1882:b0:205:e697:b51d with SMTP id a2-20020a056000188200b00205e697b51dmr28966216wri.643.1649785465135;
        Tue, 12 Apr 2022 10:44:25 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id ay41-20020a05600c1e2900b0038e75fda4edsm98355wmb.47.2022.04.12.10.44.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 10:44:24 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <390f6cd9-1757-b83c-ab97-5a991559e998@redhat.com>
Date:   Tue, 12 Apr 2022 19:44:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] KVM: x86: Add support for CMCI and UCNA.
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>, Jue Wang <juew@google.com>
Cc:     kvm@vger.kernel.org
References: <20220323182816.2179533-1-juew@google.com>
 <YlR8l7aAYCwqaXEs@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YlR8l7aAYCwqaXEs@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/11/22 21:08, Sean Christopherson wrote:
>> +			if (!(mcg_cap & MCG_CMCI_P) &&
>> +			    (data || !msr_info->host_initiated))
> This looks wrong, userspace should either be able to write the MSR or not, '0'
> isn't special.  Unless there's a danger to KVM, which I don't think there is,
> userspace should be allowed to ignore architectural restrictions, i.e. bypass
> the MCG_CMCI_P check, so that KVM doesn't create an unnecessary dependency between
> ioctls.  I.e. this should be:
> 
> 		if (!(mcg_cap & MCG_CMCI_P) && !msr_info->host_initiated)
> 			return 1;
> 

This is somewhat dangerous as it complicates (or removes) the invariants 
that other code can rely on.  Thus, usually, only the default value is 
allowed for KVM_SET_MSR.

See commit b1e34d325397 ("KVM: x86: Forbid VMM to set SYNIC/STIMER MSRs 
when SynIC wasn't activated", 2022-03-29) for a case where this practice 
avoids a NULL pointer dereference.  Though in there, Vitaly wrote:

     Note, it would've been better to forbid writing anything to
     SYNIC/STIMER MSRs, including zeroes, however, at least QEMU tries
     clearing HV_X64_MSR_STIMER0_CONFIG without SynIC.

and I don't really agree with him, in that writing the default value of 
an MSR is safe and should always be allowed for userspace.


Paolo
