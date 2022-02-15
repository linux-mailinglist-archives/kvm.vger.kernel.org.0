Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D37A4B7867
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 21:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242237AbiBORJz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 12:09:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242231AbiBORJy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 12:09:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2E61711ACE3
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 09:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644944983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3G5j4kEwfW/KskenRRmTNu3NeddBDSDhRd8IfvVzTbA=;
        b=UYb2G8dMX6l6kNw6JQkTWpIxvIB/4bMZhmvRJLGi90jdQq2eATdsBXocKZ9qg6b+IQjP0z
        mgI1ijT/w8Z8/lWDCdTJ1azz+DZie3TSQm7xmS8xJxanRgkBTKvnjFuTgM6TRNJ07Xyq6R
        J0/QjsRSbVJbo0Lwua5/HGAIqQKl1qk=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-548-shki_0_pMTmAbpISe3OOVg-1; Tue, 15 Feb 2022 12:09:42 -0500
X-MC-Unique: shki_0_pMTmAbpISe3OOVg-1
Received: by mail-ed1-f69.google.com with SMTP id k5-20020a508ac5000000b00408dec8390aso192263edk.13
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 09:09:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3G5j4kEwfW/KskenRRmTNu3NeddBDSDhRd8IfvVzTbA=;
        b=L9dpEpu+bkiM7FHxxbzEDDG4D6k1YJltTLiy2XiYXnh2cKZx9FUDzfxRIftziPvmPX
         OVpNe0/RkQFUw9vtdHIayNFaj55Sm5CYcBTYJCets1u6T/XOuckd9TDA5U+RT/Uaowlv
         iNGTetOWbIxjAudhgs5a0/eOORG/QBey/Axv0dPQuhvYjdQ8wIiwJYbNZlJtZizR73hn
         zRTOQzw/8tS0lr/2E1OjdCntSoUo0fe+N1pq3134fBIp/TgwoOHnk6DqRBchcqm6CbAx
         eL2rfhoRXpKiWj/NgrXj5a96aB7lqZ5PLxUDzmNtJP2lRqbMhWL4AovZMCesnO5a82nA
         lI+w==
X-Gm-Message-State: AOAM533swC06QLk1P0r6kWa3ly8SL4EDnQJt8AfSPN0txbgBZuPwICnj
        0+cToOpB0cMmU/URxVf+4cYjPBCjhXMmW+bnNHO2ek+fAT2M+5TS1mG3EXViv4AZZoOqmt6R2YD
        xloWYnpu2RrtV
X-Received: by 2002:a17:907:94d4:: with SMTP id dn20mr58484ejc.208.1644944980586;
        Tue, 15 Feb 2022 09:09:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzjgzIx+YSERRX1DGrlJmAIzLBv1Ph6gFQmdmnSXDpycNs0lQ/i0lPcNqwqQKBOjSzUFJ+4FQ==
X-Received: by 2002:a17:907:94d4:: with SMTP id dn20mr58475ejc.208.1644944980392;
        Tue, 15 Feb 2022 09:09:40 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id h21sm169428edt.26.2022.02.15.09.09.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 09:09:39 -0800 (PST)
Message-ID: <50c5692d-a6a6-6e38-cb8a-5def631841de@redhat.com>
Date:   Tue, 15 Feb 2022 18:09:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 2/5] KVM: x86: remove KVM_X86_OP_NULL and mark optional
 kvm_x86_ops
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220214131614.3050333-1-pbonzini@redhat.com>
 <20220214131614.3050333-3-pbonzini@redhat.com> <Ygvd9Q+R+tt6WfC2@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Ygvd9Q+R+tt6WfC2@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/15/22 18:08, Sean Christopherson wrote:
>> - * KVM_X86_OP() and KVM_X86_OP_NULL() are used to help generate
>> + * KVM_X86_OP() and KVM_X86_OP_OPTIONAL() are used to help generate
>>    * "static_call()"s. They are also intended for use when defining
>> - * the vmx/svm kvm_x86_ops. KVM_X86_OP() can be used for those
>> - * functions that follow the [svm|vmx]_func_name convention.
>> - * KVM_X86_OP_NULL() can leave a NULL definition for the
>> - * case where there is no definition or a function name that
>> - * doesn't match the typical naming convention is supplied.
>> + * the vmx/svm kvm_x86_ops.
> But assuming your veto of actually using kvm-x86-ops to fill vendor ops isn't
> overriden, they're_not_  "intended for use when defining the vmx/svm kvm_x86_ops."

True, and the original veto was actually how KVM_X86_OP_NULL() became 
unused.

Paolo

