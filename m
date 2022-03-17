Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA1384DD026
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 22:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbiCQVZ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 17:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbiCQVZ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 17:25:26 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B73C4389D
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 14:24:08 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id mr5-20020a17090b238500b001c67366ae93so4284341pjb.4
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 14:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=WIe3D5+ePhkPZn/3RQ1oBQYxy3ysEY3SEmYSs340hZE=;
        b=jFn0CkqZROMhdVM40ZKnNqQV9cOoRUy5Q+JZqc9yI0kvVx5yP9V4r8UWUFnlH+Abt+
         KhRKEvr1CUsYbM4sgBvEjEIeHaXmHBQnHd6HS44n1uv7WhcNcShX33s/bbDxtSgpc7t/
         B32v9Lo0HGWOhLJCkliWdwOWAspA6qfA3fDLjcDh7SrQ11CHgf3XjV/3RjpdDxZQ5grb
         hQBAI6GqdwgE9DaPdaAhWxBy3Gdi1kHH0PnpYbTWBJ/4WhpNk+roNhE+SmZljIITY8wm
         0iExGClDo26JI9hYyNebYpXe7pEq+di1J0JNdS0243gqZEcfz+lDue/KcUbXka/3HQkP
         /POQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WIe3D5+ePhkPZn/3RQ1oBQYxy3ysEY3SEmYSs340hZE=;
        b=ifU5Csd9ia3VCnIyPS2qXhi5AF5Kr32XbI6CVEGJTBC2YLqFYOwJljK9amBMXfkgH4
         FXlDXDkVeuzVhEC0XSQi+m5vgK1zMk9eiTOOFgmUOeI/syzCKahudbSytxBEomTEtKg6
         mBkYoO2sRoTPhtWfI5YRLydbE41fMSxXLzEoVxoL3R93Lvyud4Qpf3ReuddmGiq/LAH4
         dznc/NI53uZl8ckvySoJCtUXLehFUJjL9J+EgwLA3CvDhinv/O0VvdM87YjTZBTjm83N
         0YnVdhhaXF4e9GgMxRahh8wpQPqbaeTOwzkoDCMANpbxytPtx5WYwkKB1NaQBySqx4Ck
         wTuA==
X-Gm-Message-State: AOAM530SX4bVb2/aPuY9+AGiA1kwQRum1ePeZzb7GdF4c8wPVQTfH2n/
        6AeVMPVOoWt8E0Q8KDrlokJvpV9iKYE/T+/g
X-Google-Smtp-Source: ABdhPJwZVPJSdruZ+pO18HT47fRCQgTApX4Z1RusxL4vRiIf7iuDH/NTvwTUbikHQV2jpOb+p6m1tw==
X-Received: by 2002:a17:902:7296:b0:151:62b1:e2b0 with SMTP id d22-20020a170902729600b0015162b1e2b0mr6936666pll.165.1647552247973;
        Thu, 17 Mar 2022 14:24:07 -0700 (PDT)
Received: from ?IPV6:2600:1700:38d4:55df:8747:480:f0df:4c1a? ([2600:1700:38d4:55df:8747:480:f0df:4c1a])
        by smtp.gmail.com with ESMTPSA id k186-20020a636fc3000000b00381ef1e50a2sm5399417pgc.25.2022.03.17.14.24.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Mar 2022 14:24:07 -0700 (PDT)
Message-ID: <897714f7-033f-a888-aba5-e0bd275effd0@google.com>
Date:   Thu, 17 Mar 2022 14:24:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [RFC PATCH 00/47] Address Space Isolation for KVM
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        pjt@google.com, oweisse@google.com, alexandre.chartre@oracle.com,
        rppt@linux.ibm.com, dave.hansen@linux.intel.com,
        peterz@infradead.org, luto@kernel.org, linux-mm@kvack.org
References: <20220223052223.1202152-1-junaids@google.com>
 <87sfrh3430.ffs@tglx>
From:   Junaid Shahid <junaids@google.com>
In-Reply-To: <87sfrh3430.ffs@tglx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/16/22 15:49, Thomas Gleixner wrote:
> Junaid,
> 
> On Tue, Feb 22 2022 at 21:21, Junaid Shahid wrote:
>>
>> The patches apply on top of Linux v5.16.
> 
> Why are you posting patches against some randomly chosen release?
> 
> Documentation/process/ is pretty clear about how this works. It's not
> optional.

Sorry, I assumed that for an RFC, it may be acceptable to base on the last release version, but looks like I guessed wrong. I will base the next version of the RFC on the HEAD of the Linus tree.

> 
>> These patches are also available via
>> gerrit at https://linux-review.googlesource.com/q/topic:asi-rfc.
> 
> This is useful because?
> 
> If you want to provide patches in a usable form then please expose them
> as git tree which can be pulled and not via the random tool of the day.

The patches are now available as the branch "asi-rfc-v1" in the git repo https://github.com/googleprodkernel/linux-kvm.git

Thanks,
Junaid

> 
> Thanks,
> 
>          tglx
> 
> 

