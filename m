Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 163154DAC05
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 08:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354323AbiCPHtV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 03:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354319AbiCPHtT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 03:49:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3CDB411C36
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 00:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647416884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=omXZfO6xARlVTfhyRY+yv1CA8Jr1VfDo6PHJuPbIhsQ=;
        b=gvoyiWjWvSu4mFKW4lK9xla4G4cbHTnAPd4Gau2fY9Uc2ekJHzADuwBCqoVfwd21KC4APq
        gsdq82rxRUgP78cVLAn9oZTBW8sCPLDwhhY6nmerZJ9vtc2VsrUXEU0310MepKXX+U+XqK
        E+X/zQONzlXi9ZI0U3y30rMxK9o4V24=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-29-2d2yPfAmOBO5D4jjZgdqPw-1; Wed, 16 Mar 2022 03:48:02 -0400
X-MC-Unique: 2d2yPfAmOBO5D4jjZgdqPw-1
Received: by mail-ej1-f71.google.com with SMTP id qf24-20020a1709077f1800b006ce8c140d3dso686613ejc.18
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 00:48:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=omXZfO6xARlVTfhyRY+yv1CA8Jr1VfDo6PHJuPbIhsQ=;
        b=wEl5+GZ811pHNNNwOAykQVnmXOK7d7esXeAXqiTayJJp0H0SGA63Mt2oN3MSyida3u
         NS1PNI+vH2r0guRNk5j+KCtMkaf0FgL/qttduVqFwbrd+8JX7TN41Sa2alP+7rAEzava
         NDzN4HuFA6wJMZZmDjIWKRZ+CS852NW5It+xTj6NDmU4R/JJd52ca2PgEQ++ru4RDwPW
         OqPYGn66VMwCXdMg9TdFXTLrTpycIq/F+FQStGkoD/3G/FjyBvQANImmBuw1uMgxjeta
         gAaFAn4AEYyi/LLK1jrbTSqa1EYEw6VxsdERrRbga2B1QqpsCcmUg1QY0WS8gJnlZ3Cc
         LkDg==
X-Gm-Message-State: AOAM531GtLYx9EmMZNfFl7mahlb97pigzcivTsH34oYhXLLORIRHeSKi
        RIO/nRh+oZ5hYgsNnsA+TekxbZs+oijJjzSLOMkCrjIo0CgJfVuSBkH18hFUT5I9X4zXMUuuxz3
        AKzLPKX2STlW7
X-Received: by 2002:a17:907:7fa2:b0:6d8:2397:42 with SMTP id qk34-20020a1709077fa200b006d823970042mr25839937ejc.218.1647416881464;
        Wed, 16 Mar 2022 00:48:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzfuhT5xnQLH0xDf2uE7luk1dcgcpjwMtgmgTXahFC8jYvOjZUcmE2+uWi9mGIBM+6U6plZXA==
X-Received: by 2002:a17:907:7fa2:b0:6d8:2397:42 with SMTP id qk34-20020a1709077fa200b006d823970042mr25839928ejc.218.1647416881251;
        Wed, 16 Mar 2022 00:48:01 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id e12-20020a170906748c00b006df7c570d81sm406820ejl.104.2022.03.16.00.48.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Mar 2022 00:48:00 -0700 (PDT)
Message-ID: <34ccef81-fe54-a3fc-0ba9-06189b2c1d33@redhat.com>
Date:   Wed, 16 Mar 2022 08:47:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] Documentation: KVM: Describe guest TSC scaling in
 migration algorithm
Content-Language: en-US
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        David Woodhouse <dwmw@amazon.co.uk>
References: <20220316045308.2313184-1-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220316045308.2313184-1-oupton@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/16/22 05:53, Oliver Upton wrote:
> The VMM has control of both the guest's TSC scale and offset. Extend the
> described migration algorithm in the KVM_VCPU_TSC_OFFSET documentation
> to cover TSC scaling.
> 
> Reported-by: David Woodhouse<dwmw@amazon.co.uk>
> Signed-off-by: Oliver Upton<oupton@google.com>
> ---
> 
> Applies to kvm/queue (references KVM_{GET,SET}_TSC_KHZ on a VM fd).

A few more things that have to be changed:

> 1. Invoke the KVM_GET_CLOCK ioctl to record the host TSC (tsc_src),
>    kvmclock nanoseconds (guest_src), and host CLOCK_REALTIME nanoseconds
>    (host_src).
> 

One of two changes:

a) Add "Multiply tsc_src by guest_freq / src_freq to obtain 
scaled_tsc_src", add a new device attribute for the host TSC frequency.

b) Add "Multiply tsc_src by src_ratio to obtain scaled_tsc_src", add a 
new device attribute for the guest_frequency/host_frequency ratio.

A third would be scaling the host TSC frequency in KVM_GETCLOCK, but 
that's confusing IMO.

> 3. Invoke the KVM_GET_TSC_KHZ ioctl to record the frequency of the
>    guest's TSC (freq).

Replace freq with guest_freq.

> 6. Adjust the guest TSC offsets for every vCPU to account for (1) time
>    elapsed since recording state and (2) difference in TSCs between the
>    source and destination machine:
> 
>    ofs_dst[i] = ofs_src[i] -
>      (guest_src - guest_dest) * freq +
>      (tsc_src - tsc_dest)
> 

Replace freq with guest_freq.

Replace tsc_src with scaled_tsc_src; replace tsc_dest with tsc_dest * 
guest_freq / dest_freq.

>    ("ofs[i] + tsc - guest * freq" is the guest TSC value corresponding to

Replace with "ofs[i] + tsc * guest_freq / host_freq - guest * 
guest_freq", or "ofs[i] + tsc * ratio - guest * guest_freq".

Paolo

