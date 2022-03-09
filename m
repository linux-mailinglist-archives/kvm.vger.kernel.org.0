Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B12BB4D2F4C
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 13:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232812AbiCIMnm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 07:43:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231786AbiCIMnl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 07:43:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 493071114F
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 04:42:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646829762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sQEnwjEtcicWnYoesvXexhdEur6LAlBt9IJ3nywMJRs=;
        b=YVl465nsNf4exBX+Ic2Ay2UCfn7OctFFyOWU6VdKoyTKsuP37llMZB/gK+l1hf7pw6oB6Y
        0SDszsEo923S8iPcy7JXlqiQRrdl+Zs1pFLNZfcGQirf5I7zbnD4gOyHhC3PwMWma+ut6I
        aIp5mycVPl7tiMno/USUn92JSHM7U58=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-573-V5SmnomxN66txpxAiTxhxA-1; Wed, 09 Mar 2022 07:42:41 -0500
X-MC-Unique: V5SmnomxN66txpxAiTxhxA-1
Received: by mail-ed1-f71.google.com with SMTP id u28-20020a50d51c000000b004159ffb8f24so1218146edi.4
        for <kvm@vger.kernel.org>; Wed, 09 Mar 2022 04:42:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sQEnwjEtcicWnYoesvXexhdEur6LAlBt9IJ3nywMJRs=;
        b=XZKFWXOVlHAbgpJaw4mJH64ft7oPyuXBIqd6bNXzgVrzkzKeRovRyMAYuSVR8aWLVI
         szj4TMRe8nk2CpdSo8zAaUBqTnYz4EFvkpq30TpFsdekPfsXXErDoToFg2YmXIUNm3rU
         bVeKhBo/JBYEVuo5c1foWE07Uoe9byN2Fp+0qiXvPEx2CJFzdyDK0Hw/OvatGPXYNxtJ
         CdIamMGPiFvipIixjUps8MCXf3jVIuoLT9VT9Ja6o/HmK/fXCWsByLlO7Kx9f0sgw8HX
         9Kixze6hDaD/FbwiwRTVAW8rdVFUjc99eNhosZCrEMr/bS30ps7wLtOrwgZ/hjzrHhXu
         wTNg==
X-Gm-Message-State: AOAM531eP6xZO/bPnbOD7vx6UuR5KyVnRIedXEPM4ovZWI6iXFNyGx5o
        JBpnDQBPpgd5YzZWF0yxxyEQffD2liROfV92ZF0VLs+fpYPzqb1gf7hnnvQHNOJNkLOmCGV1S9s
        DBQiEp4p//c5n
X-Received: by 2002:a50:d097:0:b0:415:cec5:3b31 with SMTP id v23-20020a50d097000000b00415cec53b31mr20985644edd.377.1646829760169;
        Wed, 09 Mar 2022 04:42:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwgREHxqP5I7jmCz3SjerX+ths8SWbHJduAvA8V0Vq+TYiRtfSGmlW21sNgM626wCU2n889BQ==
X-Received: by 2002:a50:d097:0:b0:415:cec5:3b31 with SMTP id v23-20020a50d097000000b00415cec53b31mr20985621edd.377.1646829759958;
        Wed, 09 Mar 2022 04:42:39 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id h12-20020a056402280c00b004169d789f26sm602703ede.0.2022.03.09.04.42.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 04:42:39 -0800 (PST)
Message-ID: <a5d2a8c4-b907-91f9-e320-43fbba92a50d@redhat.com>
Date:   Wed, 9 Mar 2022 13:42:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: =?UTF-8?B?UmU6IOetlOWkjTogW1BBVENIXVt2M10gS1ZNOiB4ODY6IFN1cHBvcnQg?=
 =?UTF-8?Q?the_vCPU_preemption_check_with_nopvspin_and_realtime_hint?=
Content-Language: en-US
To:     "Li,Rongqing" <lirongqing@baidu.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
Cc:     Peter Zijlstra <peterz@infradead.org>
References: <1646815610-43315-1-git-send-email-lirongqing@baidu.com>
 <7746aad0-3968-ffba-1b7e-97e52b1afd6a@redhat.com>
 <172ca8e11130473c90c5533ce51dfa49@baidu.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <172ca8e11130473c90c5533ce51dfa49@baidu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/9/22 12:17, Li,Rongqing wrote:
>> Is it necessary to check PV_UNHALT?  The bit is present anyway in
>> the steal time struct, unless it's a very old kernel.  And it's
>> safe to always return zero if the bit is not present.
> 
> I think calling _kvm_vcpu_is_preempted should be avoid in some
> unnecessary condition, like no unhalt, which means that vcpu do not
> exit for hlt and vcpu is not preempted?

PV_UNHALT can be cleared by userspace just because the user requested 
it.  (In fact, what KVM does when it clears it automatically is not 
really a good idea...).

Paolo

