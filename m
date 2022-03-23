Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE514E5C03
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 00:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244312AbiCWXvR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 19:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347584AbiCWXuc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 19:50:32 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C421CB2E
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 16:49:01 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id g3so3077563plo.6
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 16:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=OqY1xTeVRlw2nfYyxxPoQU/LOGXlMjj+SpATPbEYmHk=;
        b=QPglaTyMq/OcPmXLWAnAvpGHghRviGDrt5W9reAcKupVIszxI8a6HgU8atAN5p8bd2
         XSNMBxzaLe/XNjMPXpZ47CWOTtp0wNGcjxu30YaBrv7SHHr3/LgVb5kzxCKIEyK35gmQ
         5SDHpHMC5ZwEGYGPGd8OHpxYIBoQudDrOchfOhg+0ocWziqEtPkjjSDpoW9527AiDJX6
         MaiXtTYGfq2GQXCsO+Y3bjDDNqRUPCMlzDnHRQXV50J4Cm/xEo+4tuuK805aocqGzS1o
         Os6w0vupztZM/VelhVI1KwYsHM4YC1Zt8Ak9Fws20xETp+XRrxCRColPxu2RmdZOKONr
         0CmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OqY1xTeVRlw2nfYyxxPoQU/LOGXlMjj+SpATPbEYmHk=;
        b=laeVTkO0oD/WCU3mHxiVOxRQ0Wuw+xq9BprFmq7cq6L1cqyLaEUWNysS2lVn/dx1PH
         lBXvdKwyCdNJEsqwNJJ3tC5aenx2xdlTgvWc73Byz/S2LaCnywru5c7BhxytorDhaSQv
         oDmC7z1J5+no9ceynif4ZKcvfqb8VMGPs46+Wtjs2UbkENXnNEQqsaKNqpjQl/Fy8+fm
         Cv+XIGw0xTL8GgfC77+RCDzaFlaInJx+yx0ckJKsYYDvsSIO0JZjBT/XgkhpMVCJZsy6
         Ut65LXvpehWjc28hw+zqsKrLVfghTloAFyJ4T8ZYrfJOiisea69CkbxYwjfiJoWAy28H
         sRmQ==
X-Gm-Message-State: AOAM531Gn1OEpMcV5NhNmw4m3XK1UqcVFjaRCsNAT+HXcGVYsd5L9eSR
        Fd29uOReYRzn9fHnUL1c6azHTw==
X-Google-Smtp-Source: ABdhPJxlBFuH7Nhi8Qp9G1SpsD27wA5t3nVbN3x89MKrvpsFO3GJ9or400etjmvjzNtg0wD6aIwTHw==
X-Received: by 2002:a17:903:1205:b0:151:8ae9:93ea with SMTP id l5-20020a170903120500b001518ae993eamr2691148plh.37.1648079340546;
        Wed, 23 Mar 2022 16:49:00 -0700 (PDT)
Received: from ?IPV6:2600:1700:38d4:55df:aed0:ee00:7944:65f6? ([2600:1700:38d4:55df:aed0:ee00:7944:65f6])
        by smtp.gmail.com with ESMTPSA id 124-20020a621682000000b004f6a2e59a4dsm921771pfw.121.2022.03.23.16.48.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Mar 2022 16:48:59 -0700 (PDT)
Message-ID: <3a7c3a71-0be7-261e-20b7-54b4864eedb5@google.com>
Date:   Wed, 23 Mar 2022 16:48:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [RFC PATCH 10/47] mm: asi: Support for global non-sensitive
 direct map allocations
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com, pjt@google.com,
        oweisse@google.com, alexandre.chartre@oracle.com,
        rppt@linux.ibm.com, dave.hansen@linux.intel.com,
        peterz@infradead.org, tglx@linutronix.de, luto@kernel.org,
        linux-mm@kvack.org
References: <20220223052223.1202152-1-junaids@google.com>
 <20220223052223.1202152-11-junaids@google.com>
 <YjuL80tuvUbAWWKW@casper.infradead.org>
From:   Junaid Shahid <junaids@google.com>
In-Reply-To: <YjuL80tuvUbAWWKW@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Matthew,

On 3/23/22 14:06, Matthew Wilcox wrote:
> On Tue, Feb 22, 2022 at 09:21:46PM -0800, Junaid Shahid wrote:
>> standard ASI instances. A new page flag is also added so that when
>> these pages are freed, they can also be unmapped from the ASI page
>> tables.
> 
> It's cute how you just throw this in as an aside.  Page flags are
> in high demand and just adding them is not to be done lightly.  Is
> there any other way of accomplishing what you want?
> 

I suppose we may be able to use page_ext instead. That certainly should be 
feasible for the PG_local_nonsensitive flag introduced in a later patch, 
although I am not completely sure about the PG_global_nonsensitive flag. That 
could get slightly tricky (though likely still possible to do) in case we need 
to allocate any non-sensitive memory before page_ext is initialized. One concern 
with using page_ext could be the extra memory usage on large machines.

BTW is page flag scarcity an issue on 64-bit systems as well, or only 32-bit 
systems? ASI is only supported on 64-bit systems (at least currently).

>> @@ -542,6 +545,12 @@ TESTCLEARFLAG(Young, young, PF_ANY)
>>   PAGEFLAG(Idle, idle, PF_ANY)
>>   #endif
>>   
>> +#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
>> +__PAGEFLAG(GlobalNonSensitive, global_nonsensitive, PF_ANY);
> 
> Why is PF_ANY appropriate?
> 

I think we actually can use PF_HEAD here. That would make the alloc_pages path 
faster too. I'll change to that. (Initially I had gone with PF_ANY because in 
theory, you could allocate a compound page and then break it later and free the 
individual pages, but I don't know if that actually happens apart from THP, and 
certainly doesn't look like the case for any of the stuff that we have marked as 
non-sensitive.)

Thanks,
Junaid
