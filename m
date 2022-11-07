Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 804F461F7CE
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 16:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbiKGPi5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 10:38:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbiKGPiz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 10:38:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116841C11B
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 07:37:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667835478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dNfP2j3bbtVZitCEodZjiNfOPVCG/GmURhlA5yLx2ao=;
        b=P0O12kj2BjN5X3Y7PEGf05g3shLzdjPJ1yXrPe0Q4Ii3La2XGMWGs4X4ArEd/rqnXaExxz
        Lr68+lvEMD1DtoQIYG45yMrVOOOwkgvILyIzzlxvLHY2Juv5sR//BpanKnZJvDao723tHA
        uGQzVOQOLEWmcb2SD08rhXLJrEvwujA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-189-yCeH2vNWOy2yDR8QSah6ag-1; Mon, 07 Nov 2022 10:37:57 -0500
X-MC-Unique: yCeH2vNWOy2yDR8QSah6ag-1
Received: by mail-wm1-f72.google.com with SMTP id r187-20020a1c44c4000000b003c41e9ae97dso8599955wma.6
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 07:37:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dNfP2j3bbtVZitCEodZjiNfOPVCG/GmURhlA5yLx2ao=;
        b=5G7Hq1pbIBhYV30eBEDqy+MpY/9MfBTcwc13kPpBA29gAGHbUg+Gcb4n8+fcGBaa/4
         ozafrDe8b4ycn61uXpGr84YKQ6kMBjLloTGNf7nuYb6srKnZ8rKgtaiPOpAPIyjudgQk
         cxOBJzQn0LybbtSrMR7YKeBElThS9ANbUp7I4gXTHWLSqRNZOSbyyxkbLX0K5eFMAL06
         9pSLfBuuFQ0EA2Ct+9FWoWyzCveohyy3Meg8wqXN3eC7dux46Ux3BpW/1OL4nvJffI/W
         9zBxsQGV6sR2a29r9fk8qVFQM+x4fho9h9X6+nz7PV/TxE1MA97VBiJXxaqu0P9m5vKA
         giuA==
X-Gm-Message-State: ACrzQf3wjhnKTAJdAXPAqBu4C1WCbPc8dVdGDXb4DVOdJtakRRsxW8yd
        nCVX+gytBFB4VIHPPvfFF9/Y5ZUnxPEHo4rKXj883dn2v1B/rjG4Dza6iidy5lnLpAsOkQY+Gdc
        ESSzJdtinu+Qi
X-Received: by 2002:adf:e890:0:b0:22c:f296:1120 with SMTP id d16-20020adfe890000000b0022cf2961120mr572072wrm.369.1667835475782;
        Mon, 07 Nov 2022 07:37:55 -0800 (PST)
X-Google-Smtp-Source: AMsMyM7Eq0lPe1aa4L/JM3FdjO2s3r41N1HB7mWOJ7dQXLUKvWX5gLCAh8J75OzN26tyCHQlyFviSg==
X-Received: by 2002:adf:e890:0:b0:22c:f296:1120 with SMTP id d16-20020adfe890000000b0022cf2961120mr572064wrm.369.1667835475560;
        Mon, 07 Nov 2022 07:37:55 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id k28-20020a5d525c000000b0022e653f5abbsm7507544wrc.69.2022.11.07.07.37.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Nov 2022 07:37:54 -0800 (PST)
Message-ID: <19c32786-6f5b-d438-269b-d29c104817ac@redhat.com>
Date:   Mon, 7 Nov 2022 16:37:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 4/8] KVM: SVM: move guest vmsave/vmload to assembly
Content-Language: en-US
To:     Andrew Cooper <Andrew.Cooper3@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "nathan@kernel.org" <nathan@kernel.org>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "jmattson@google.com" <jmattson@google.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20221107145436.276079-1-pbonzini@redhat.com>
 <20221107145436.276079-5-pbonzini@redhat.com>
 <6c8539fa-38b5-d307-675a-2e272f7a83d3@citrix.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <6c8539fa-38b5-d307-675a-2e272f7a83d3@citrix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/7/22 16:32, Andrew Cooper wrote:
>> -		vmload(svm->vmcb01.pa);
>>   		__svm_vcpu_run(vmcb_pa, svm);
>> -		vmsave(svm->vmcb01.pa);
>> -
>>   		vmload(__sme_page_pa(sd->save_area));
>
> %gs is still the guests until this vmload has completed.  It needs to
> move down into asm too.

Sure, that's patch 6 in the series.  See also cover letter: "this means 
moving guest vmload/vmsave and host vmload to assembly".

Paolo

