Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8728C4D9267
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 03:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344364AbiCOCCu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 22:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234046AbiCOCCu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 22:02:50 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D575E12A83
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 19:01:38 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id n15so15086387plh.2
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 19:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=iUfF+WCTjrbsCXHKV4lddJ1I8Kz2/BCoTPrTLSPUtRE=;
        b=W6w9vVrpMsMVWgQAqN/0jBMpWBeeJBo6DnfiJ0JUDQ1lPzXiu3u1xzHuAzdGmAgMiJ
         iVLyNEpnug2G4o04nIrkRREmr78O9X4p6b+7fDirOaE7EOkhY4fBBL7E8sxAmbRycO4t
         3TPTa/F0XCcgsyXUMZjt2NYmLJt9fJsk2/aJuf+9ZAMB3Equxf+vhEy5ZdtsqwiT+dAX
         I+OT/fQvdE6pxndgzXuT+cnTkgBvOEEzwmqx7E2WxtKDN/pzrslAWd5nPxTBlZv+FZ/M
         yj7jjF4d9wq0g1Yvx8oUm2PEulp8X6iksKCKkdO1qjODFHnFjeG1mosEfivX3OOk76Zg
         Nhlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=iUfF+WCTjrbsCXHKV4lddJ1I8Kz2/BCoTPrTLSPUtRE=;
        b=65Elonx3n88vLMQeT/O17oPjM6RGqkIEs6hzr4Ja96w4sKLyOlNQjwwy5HdkFhkD9R
         0v4bpLjuKX6RobleKckYwV7RCaB7FC3o2Ha95ftXSWc3a17qXAuhoM9ODLB1+NkF5SlJ
         vnoIJGxjm0mm1huLMaCfPPoNJkvOkMyf0ncwLBxCNQ6PwVFuI+M4BlF9/uHk6xSH2R9l
         O+5Y9fHtVIE2ltpUsoDnUhs3sXDeYdzUuo1GSJiB5PvEZga15Yy1FGnonkY4yOE3xY8+
         qyrGcAJxS9kKrA36up4a/F4zXI/bE7f1GJz073TX0zgCHiSIZVsiPksktX2mEO/JHZmA
         jtng==
X-Gm-Message-State: AOAM533gOPWoRFVe+TaePHFSv5e1Sori0LdlDTw3lfGDOZuNo4Kivda7
        la5+ipjWvX2zmfXes0bGx5b6pQ==
X-Google-Smtp-Source: ABdhPJx8Z20U/6UQfFscmQ+wKverU190z3bXx6BwlzRY98FtPPk4dWoyYJ+bay1Jvs/oofjYjaD65A==
X-Received: by 2002:a17:902:dac1:b0:151:952a:8821 with SMTP id q1-20020a170902dac100b00151952a8821mr25214435plx.11.1647309697794;
        Mon, 14 Mar 2022 19:01:37 -0700 (PDT)
Received: from ?IPV6:2600:1700:38d4:55df:e6f2:9562:60a7:682a? ([2600:1700:38d4:55df:e6f2:9562:60a7:682a])
        by smtp.gmail.com with ESMTPSA id i11-20020a63bf4b000000b00380d3454c38sm14837963pgo.13.2022.03.14.19.01.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Mar 2022 19:01:37 -0700 (PDT)
Message-ID: <9f2f1226-f398-f132-06f4-c21a2a2d1033@google.com>
Date:   Mon, 14 Mar 2022 19:01:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [RFC PATCH 04/47] mm: asi: ASI support in interrupts/exceptions
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        pjt@google.com, oweisse@google.com, alexandre.chartre@oracle.com,
        rppt@linux.ibm.com, dave.hansen@linux.intel.com,
        peterz@infradead.org, luto@kernel.org, linux-mm@kvack.org
References: <20220223052223.1202152-1-junaids@google.com>
 <20220223052223.1202152-5-junaids@google.com> <87pmmofs83.ffs@tglx>
From:   Junaid Shahid <junaids@google.com>
In-Reply-To: <87pmmofs83.ffs@tglx>
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

On 3/14/22 08:50, Thomas Gleixner wrote:
> On Tue, Feb 22 2022 at 21:21, Junaid Shahid wrote:
>>   #define DEFINE_IDTENTRY_RAW(func)					\
>> -__visible noinstr void func(struct pt_regs *regs)
>> +static __always_inline void __##func(struct pt_regs *regs);		\
>> +									\
>> +__visible noinstr void func(struct pt_regs *regs)			\
>> +{									\
>> +	asi_intr_enter();						\
> 
> This is wrong. You cannot invoke arbitrary code within a noinstr
> section.
> 
> Please enable CONFIG_VMLINUX_VALIDATION and watch the build result with
> and without your patches.
> 
> Thanks,
> 
>          tglx

Thank you for the pointer. It seems that marking asi_intr_enter/exit and asi_enter/exit, and the few functions that they in turn call, as noinstr would fix this, correct? (Along with removing the VM_BUG_ONs from those functions and using notrace/nodebug variants of a couple of functions).

Thanks,
Junaid
