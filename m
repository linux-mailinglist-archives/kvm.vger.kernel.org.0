Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A20E33EF7E
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 12:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbhCQL0Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 07:26:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59420 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231402AbhCQLZ6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Mar 2021 07:25:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615980357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hf3ahyJnG7KBq8dYUu13erhwR3Va8RMaptoKSf/MrjA=;
        b=D1wMQk2AvOyZ//bnyqreifWGV83srYN4GllUdxt14pnwQse1hvgxS4H9Oz4/NQq7tuI4eN
        akAgNNwaJDx16f5t038UQ3We9a8LtU5t2KQ7X3WLAzfqDQEyd958bq/RCDyFBP25elAKuH
        JNf+r0tenLIq+uTX7GAC6D9Cr0JhoEs=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-deq6kA8AMwK-mltGcJoFIA-1; Wed, 17 Mar 2021 07:25:55 -0400
X-MC-Unique: deq6kA8AMwK-mltGcJoFIA-1
Received: by mail-ed1-f72.google.com with SMTP id q12so3776379edv.9
        for <kvm@vger.kernel.org>; Wed, 17 Mar 2021 04:25:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hf3ahyJnG7KBq8dYUu13erhwR3Va8RMaptoKSf/MrjA=;
        b=uaMnhGsG2nsPxGIHqUlWm8ilATujDkxCy/iwNo6Hfbl8AeibjVvU+lTBDrWiBexKMT
         UEKmpPlvESGuhviNOfkCHEbtngdLG6kwCsVQiUFRFTC2MuuyYCUmjFd6a/XkSQlvOpAe
         qnKnu+CmejYna3EoPAduXm0MlsR5dD/4PDUopRveWCi9d9mgEj/0JXXtjBB4umOz4cyn
         uGlCA24wG3jVI+0EEPaO1KYsXz5srORZrc/d1z19zN2MjtPZHIZliw1c3d6usF2rugn8
         hmVLPPkTgjOX5gDN0d6DV45/VvCG7mXcFA8hDs5ncS3GXBg3PtFiosSZK8o49xLiip5m
         qTMA==
X-Gm-Message-State: AOAM5312MbTeSolsAX3zQ8f582uZY6XAPurqKSBkuPBop2Iv3IhpjAEq
        1GmN7Nibd83Rexv/lNiNXYHY7Dc4ticeRhUtktgdbjj6OjDF0fApHJ8vg3PsiKjYfaEUpwz5O11
        Q7o1Yl20vuWXp1SmxvByd90dadcxcToXuqLmsC9aRjfj5QuqdCXRluMHlO5ngKEPb
X-Received: by 2002:aa7:cd63:: with SMTP id ca3mr41862741edb.265.1615980354393;
        Wed, 17 Mar 2021 04:25:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx542/MtHcjVj7T6Y1o987zHhETplS0SvtnlCENkTe2wcSrH1QkY3UECfjJKv/OX6Yb9NTx+Q==
X-Received: by 2002:aa7:cd63:: with SMTP id ca3mr41862719edb.265.1615980354183;
        Wed, 17 Mar 2021 04:25:54 -0700 (PDT)
Received: from localhost.localdomain ([194.230.155.192])
        by smtp.gmail.com with ESMTPSA id s20sm11264312ejj.38.2021.03.17.04.25.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Mar 2021 04:25:53 -0700 (PDT)
Subject: Re: [PATCH] selftests/kvm: add test for
 KVM_GET_MSR_FEATURE_INDEX_LIST
To:     Paolo Bonzini <pbonzini@redhat.com>,
        linux-kselftest@vger.kernel.org
Cc:     Shuah Khan <shuah@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20210317074552.8550-1-eesposit@redhat.com>
 <ac3ba1c0-450e-4e24-c2a2-39d037358758@redhat.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
Message-ID: <61d11f32-a2da-b593-1c62-bbadc6408215@redhat.com>
Date:   Wed, 17 Mar 2021 12:25:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <ac3ba1c0-450e-4e24-c2a2-39d037358758@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 17/03/2021 11:49, Paolo Bonzini wrote:
> On 17/03/21 08:45, Emanuele Giuseppe Esposito wrote:
>> +    struct kvm_msr_list features_list;
>>       buffer.header.nmsrs = 1;
>>       buffer.entry.index = msr_index;
>> +    features_list.nmsrs = 1;
>> +
>>       kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
>>       if (kvm_fd < 0)
>>           exit(KSFT_SKIP);
>> +    r = ioctl(kvm_fd, KVM_GET_MSR_FEATURE_INDEX_LIST, &features_list);
>> +    TEST_ASSERT(r < 0 && r != -E2BIG, "KVM_GET_MSR_FEATURE_INDEX_LIST 
>> IOCTL failed,\n"
>> +        "  rc: %i errno: %i", r, errno);
> 
> Careful: because this has nsmrs == 1, you are overwriting an u32 of the 
> stack after struct kvm_msr_list.  You need to use your own struct 
> similar to what is done with "buffer.header" and "buffer.entry".
> 
>>       r = ioctl(kvm_fd, KVM_GET_MSRS, &buffer.header);
>>       TEST_ASSERT(r == 1, "KVM_GET_MSRS IOCTL failed,\n"
>>           "  rc: %i errno: %i", r, errno);
>>
> 
> More in general, this is not a test, but rather a library function used 
> to read a single MSR.
> 
> If you would like to add a test for KVM_GET_MSR_FEATURE_INDEX_LIST that 
> would be very welcome.  That would be a new executable.  Looking at the 
> logic for the ioctl, the main purpose of the test should be:
> 
> - check that if features_list.nmsrs is too small it will set the nmsrs 
> field and return -E2BIG.
> 
> - check that all MSRs returned by KVM_GET_MSR_FEATURE_INDEX_LIST can be 
> accessed with KVM_GET_MSRS
> 
> So something like this:
> 
>    set nmsrs to 0 and try the ioctl
>    check that it returns -E2BIG and has changed nmsrs
>    if nmsrs != 1 {
>      set nmsrs to 1 and try the ioctl again
>      check that it returns -E2BIG
>    }
>    malloc a buffer with room for struct kvm_msr_list and nmsrs indices
>    set nmsrs in the malloc-ed buffer and try the ioctl again
>    for each index
>      invoke kvm_get_feature_msr to read it
> 
> (The test should also be skipped if KVM does not expose the 
> KVM_CAP_GET_MSR_FEATURES capability).

Thank you for the feedback, the title is indeed a little bit misleading. 
My idea in this patch was to just add an additional check to all usages 
of KVM_GET_MSRS, since KVM_GET_MSR_FEATURE_INDEX_LIST is used only to 
probe host capabilities and processor features.
But you are right, a separate test would be better.

Thank you,
Emanuele

