Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54A336D943A
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 12:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbjDFKfc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 06:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbjDFKfb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 06:35:31 -0400
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC8F59D8;
        Thu,  6 Apr 2023 03:35:30 -0700 (PDT)
Received: by mail-ej1-f51.google.com with SMTP id qb20so228934ejc.6;
        Thu, 06 Apr 2023 03:35:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680777329; x=1683369329;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VGuAgbNs5CTknDNOGrtLvzwspFWhgu5cW+fjK35Mz+s=;
        b=lCXLJlQ05okjD1v8I8Qn6yqjnnq5ni94/ldOkuJoqje+mKYxO0KCv6eQEtFRGjlY0b
         2eo2yBqK4vYDF7vAGnbFRj1TnyDdFXTL6DxuPeuMHWKJyRUyLKUAoYYS5iTzP94x9yiD
         2sNIPr8IFOPFPDgdLMBjaH4Lu6dQtZbFp2KePtguHGU3cfTQI+dVh+P23J65FZ3qNr4d
         BZHgCul9A3uve2hJGbcfbpTBmFrFBBbitH+gu03GbnljbgDEDYKW3CVWaCmKMrvjyfcS
         6B57+oRCL+gHq6FnB1jVOjDJJoAJCyjOHxdU/0s6+TExnJ1hq3xFVy1zvqLLvuLS692r
         4MSQ==
X-Gm-Message-State: AAQBX9cpcF3twiOFbxtg3uJZAL7RpCnQYg0RZ6m1/Z9nr9e5mtLLOEqq
        MJiaHd3BZ0I2g8kj7yMrdSE=
X-Google-Smtp-Source: AKy350YXHjg34fLflvR+ude6ubhzFwE7wJPF3+v9yxjWMV1do1zeoA+wLilXlgnXWp9IgtkblGlegg==
X-Received: by 2002:a17:907:3201:b0:8b1:2eef:154c with SMTP id xg1-20020a170907320100b008b12eef154cmr6195530ejb.0.1680777328619;
        Thu, 06 Apr 2023 03:35:28 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::aaaa:49? ([2a0b:e7c0:0:107::aaaa:49])
        by smtp.gmail.com with ESMTPSA id xh8-20020a170906da8800b0094809142160sm642128ejb.55.2023.04.06.03.35.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Apr 2023 03:35:27 -0700 (PDT)
Message-ID: <26be2c81-9431-6b43-e3e9-52d7d184750e@kernel.org>
Date:   Thu, 6 Apr 2023 12:35:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        Dave Hansen <dave.hansen@intel.com>,
        linux-kernel@vger.kernel.org,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>,
        Asit Mallick <asit.k.mallick@intel.com>,
        Cfir Cohen <cfir@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Kaplan <David.Kaplan@amd.com>,
        David Rientjes <rientjes@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Joerg Roedel <joro@8bytes.org>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Kuppuswamy Sathyanarayanan <knsathya@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Stunes <mstunes@vmware.com>,
        Raj Ashok <ashok.raj@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, x86@kernel.org
References: <20230403140605.540512-1-jiangshanlai@gmail.com>
 <19035c40-e756-6efd-1c02-b09109fb44c1@intel.com>
 <CAJhGHyBHmC=UXr88GsykO9eUeqJZp59jrCH3ngkFiCxVBW2F3g@mail.gmail.com>
 <3591487f-96ae-3ab7-6ce7-e524a070c9e7@redhat.com>
 <20230406101254.GI386572@hirez.programming.kicks-ass.net>
From:   Jiri Slaby <jirislaby@kernel.org>
Subject: Re: [RFC PATCH 0/7] x86/entry: Atomic statck switching for IST
In-Reply-To: <20230406101254.GI386572@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06. 04. 23, 12:12, Peter Zijlstra wrote:
> On Tue, Apr 04, 2023 at 07:03:45PM +0200, Paolo Bonzini wrote:
>> On 4/4/23 05:17, Lai Jiangshan wrote:
>>> The cover letter has 800+ lines of comments.  About 100-300 lines
>>> of comments will be moved into the code which would make the diffstat
>>> not so appealing.
>>
>> Removing assembly from arch/x86/entry/ and adding English to Documentation/?
>> That's _even more_ appealing. :)
> 
> I *much* prefer in-code comments to random gibberish that's instantly
> out of date squirreled away somewhere in an unreadable format in
> Documentation/

+1 as one can link comments in the code to Documentation easily 
nowadays. They are sourced and end up in the generated Documentation [1] 
then. One only needs to type the kernel-doc properly.

[1] https://www.kernel.org/doc/html/latest

-- 
js
suse labs

