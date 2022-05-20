Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4E0252EE27
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 16:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346419AbiETO14 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 10:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbiETO1z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 10:27:55 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C589D070;
        Fri, 20 May 2022 07:27:54 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id f10so8198595pjs.3;
        Fri, 20 May 2022 07:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=e/BxaCGwoTXoWwunEnqynIa8+N5sGoeIeIe1Ccn6W9I=;
        b=ERCwGBrs57mFGNC4fes16Vjat0N/TUvrwtJJeKEBM5VKYKQRUw0hdjJp/Eryk5nAzl
         Y8X0UGkKfsfvAlGBOLxpscMpSYxE4P3+UTTsbxQXnOC6uIiKiajzu2xL2nNPwSeyXvPX
         Oj9y5lDZCIsb8bj2u5nyo4+RhD4mLCxOX9PSl1CfmNlEKIiVvQ05/3s+tKjXd3BQ04YG
         CHphuIm/27rKtsb2QV8qFWwFISm2YzfGQsJnYaDS2lB1T3kBYX0tLIwNjrwivioV1swZ
         a4gAT3C+ftOjFqJzUdYvRzeX1gX8mvUywvu3Wvz2Y6lkmaR4AcqtKel2cWwboGChU63R
         81uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=e/BxaCGwoTXoWwunEnqynIa8+N5sGoeIeIe1Ccn6W9I=;
        b=Ubf3kS50qWGPZnHivri3VUE2P24VLqlOZ1GVK8yWBZ8l9bG/WeELkDNG9VrXYt0sjv
         l2rsKBAT1UQVSqv70nJzftxLgmXhNrVeHNA9htHw5Lc0gDlxjuwmWigCJm9XogG1q6WF
         li+wn7c9FWqh51DjJo6r7E+rEhOy6cRFWbPr5O8ouJVU8aPQDSa8OQbz1dbksHGQ9pLk
         FkcLVdnvGrnOAYwEmgQwFjuUHPC7T96vrsxVsW/DRf4Ltnba509L8S4y31pMHtJAFKr8
         svaRhy8mKXRvMN5KF6econN7FmLXcy7dUwIJTdtHFt48s+OVaLc7Yo1/Qzoz85BlsyST
         yQOA==
X-Gm-Message-State: AOAM531XUHh8pGOIXnahDwWVfz/6K+HhR1UOHl/Jd2zSUas7aXEYCP8I
        biQ2pzCoSVr8lzxQyt+r2Gw=
X-Google-Smtp-Source: ABdhPJwHg5c5kj95RzEA+bjxuOVzHhqqpZehk6Kc6vcq+H4Cutqmq1JrnaevsS9E8v+vSHJEtK2H4w==
X-Received: by 2002:a17:902:d711:b0:161:f859:bed7 with SMTP id w17-20020a170902d71100b00161f859bed7mr2166167ply.31.1653056873690;
        Fri, 20 May 2022 07:27:53 -0700 (PDT)
Received: from [192.168.255.10] ([203.205.141.20])
        by smtp.gmail.com with ESMTPSA id d14-20020a170902654e00b0015e8d4eb1c1sm5716016pln.11.2022.05.20.07.27.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 May 2022 07:27:53 -0700 (PDT)
Message-ID: <6b30a3bc-9509-d506-4f81-2db0baeedad2@gmail.com>
Date:   Fri, 20 May 2022 22:27:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH RESEND v3 11/11] KVM: x86/pmu: Drop amd_event_mapping[] in
 the KVM context
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20220518132512.37864-1-likexu@tencent.com>
 <20220518132512.37864-12-likexu@tencent.com>
 <3d30f1ac-558f-0ce6-3d46-e223f117899b@redhat.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <3d30f1ac-558f-0ce6-3d46-e223f117899b@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/5/2022 8:59 pm, Paolo Bonzini wrote:
> On 5/18/22 15:25, Like Xu wrote:
>> +    if (static_call(kvm_x86_pmu_hw_event_is_unavail)(pmc))
>> +        return false;
>> +
> 
> I think it's clearer to make this positive and also not abbreviate the name; 
> that is, hw_event_available.

Indeed.

> 
> Apart from patch 3, the series looks good.  I'll probably delay it to 5.20 so 
> that you can confirm the SRCU issue, but it's queued.

I have checked it's protected under srcu_read_lock/unlock() for existing usages, 
so did JimM.

TBH, patch 3 is only inspired by the fact why the protection against 
kvm->arch.msr_filter
does not appear for kvm->arch.pmu_event_filter, and my limited searching scope 
has not
yet confirmed whether it prevents the same spider.

No comments on the target kernel cycle, Capt.

> 
> Thanks,
> 
> Paolo
