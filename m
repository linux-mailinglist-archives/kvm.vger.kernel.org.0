Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A58B4BA754
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 18:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242731AbiBQRjd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 12:39:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236986AbiBQRjc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 12:39:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C8BD06584
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 09:39:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645119557;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LwAXZjwbccWIhWsV1uTmYFUWMD/hhH8A5AMszxACjGY=;
        b=OZz2OCVbSte7tVTZSnsJQS+5GfGpyJiFWLaXi5xJCtlCrI+QmgsCpx6acTIH7qOgiuSklx
        zyVVTI9EzrbireZHJuUB3LHJxuVw5X7bKqVufDYaBAG+wXy5iyv9GOpz42F3dzojNCeTTx
        /TzOoWKlby8NqxuV9aUaCXQAat7fb7A=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-34-Yci31mHCMEmgBo5Jw6C7xQ-1; Thu, 17 Feb 2022 12:39:15 -0500
X-MC-Unique: Yci31mHCMEmgBo5Jw6C7xQ-1
Received: by mail-ed1-f72.google.com with SMTP id b26-20020a056402139a00b004094fddbbdfso3975146edv.12
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 09:39:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LwAXZjwbccWIhWsV1uTmYFUWMD/hhH8A5AMszxACjGY=;
        b=jmN1ACn9Nm0lEYDZjx+7QlPBAugH8uX1+a1k+rNASCAfJ7LRo5o1FkCVMxGhS5x1IK
         X1x25DO/RdW1xq6B776NTDyLlJQvI78vnQgAtEA/gfR61yJtFC4PZMhhp3qud2ta4jq2
         bZpT4ZfWPzF7tIlBSsSO+eDRIw9pkQHXfMHznxdTD4r/QQperHxhXsWTa5oSX13z0lHr
         UuS8Pa4du/WSRy6075d7h67tItTshCcP98a0kUpkX86ro2xaSxeECJgwTub7KobkZwV/
         HlO3tntV0U14O/VzT8O7m1+7ALXQRsHIjCPUgKFj+f5IJ9dpO2fjxX1DDrfXWngJbvn3
         bWPw==
X-Gm-Message-State: AOAM5311wf3j2oTCbK+VBoK1j0YgqU4Zw+agk5T38XCvzwn9Dv2HMong
        7nTAhydVSmzcPXr4X6VJ2/Z44L8Un6rPuFYRLIEELIkdwLlNJuUXuG2ttf5sgKuokbwRITtV9W3
        UeiQ7zp7rNyQe
X-Received: by 2002:a05:6402:4311:b0:408:71a7:13aa with SMTP id m17-20020a056402431100b0040871a713aamr3756813edc.54.1645119554467;
        Thu, 17 Feb 2022 09:39:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy9w+kmHeZbG1Fh98dvBnKddnsjDg1zQp/97Jljcnw6E+HYDtdeVtbTk1VuyJNGudOo4R5V7w==
X-Received: by 2002:a05:6402:4311:b0:408:71a7:13aa with SMTP id m17-20020a056402431100b0040871a713aamr3756794edc.54.1645119554270;
        Thu, 17 Feb 2022 09:39:14 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id r5sm1378089ejy.51.2022.02.17.09.39.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Feb 2022 09:39:13 -0800 (PST)
Message-ID: <6a177da7-254d-a4a2-8dc3-c7b36d8e0622@redhat.com>
Date:   Thu, 17 Feb 2022 18:39:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2] kvm: x86: Disable KVM_HC_CLOCK_PAIRING if tsc is in
 always catchup mode
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Anton Romanov <romanton@google.com>, mtosatti@redhat.com,
        kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
References: <20220215200116.4022789-1-romanton@google.com>
 <87zgmqq4ox.fsf@redhat.com> <Yg5sl9aWzVJKAMKc@google.com>
 <87pmnlpj8u.fsf@redhat.com> <de6a1b73-c623-4776-2f14-b00917b7d22a@redhat.com>
 <87mtippg5e.fsf@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <87mtippg5e.fsf@redhat.com>
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

On 2/17/22 18:16, Vitaly Kuznetsov wrote:
> Paolo Bonzini <pbonzini@redhat.com> writes:
> 
>> On 2/17/22 17:09, Vitaly Kuznetsov wrote:
> ...
>>> (but I still mildly dislike using 'EOPNOTSUPP' for a temporary condition
>>> on the host).
>>
>> It's not temporary, always-catchup is set on KVM_SET_TSC_KHZ and never
>> goes away.
> 
> Even if the guest is migrated (back) to the host which supports TSC
> scaling?

Ah right, in that case no.  But this hypercall does not have a CPUID 
bit, so the supported status can change on migration anyway.

Paolo

