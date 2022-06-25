Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABE4955A883
	for <lists+kvm@lfdr.de>; Sat, 25 Jun 2022 11:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232458AbiFYJNa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Jun 2022 05:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232429AbiFYJN0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Jun 2022 05:13:26 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0DEEE38
        for <kvm@vger.kernel.org>; Sat, 25 Jun 2022 02:13:24 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id e40so6514503eda.2
        for <kvm@vger.kernel.org>; Sat, 25 Jun 2022 02:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TlzouQ4EiEKXh2lDZmZmMZHlP2qRS/FFD329EFEsl60=;
        b=jBa+CT3fhiiOIS85dR+gFJo8X9iGsoz3BVGRTRpshl2SIGV63IghMf4DwUGPaeBfby
         o3BAKJBvMtHsnl7JZJE0Y4yNJZMI6nj++kSPaGI8mEkUYSPM4k64ydntM4BCpZf9vqjB
         09XN8JEaGgn3HXtELdBfDuXIM2MTYw+pOhc24d6crtEUntLQbh/94ZheRcnMANTi/jri
         5DBtxrqeek2zvwfshkLJmJsoRCQkPl8fq+0AEEiZnd4IRuZwwL4Tmoe1t8r8/rHlKxjv
         bVPP5ZXbMeoe16Z34vMvkHrjT1jgCqj8LtBVNQ1qvfHX9opBAC7UgBfmYOrZ7LJkpqXu
         WvEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TlzouQ4EiEKXh2lDZmZmMZHlP2qRS/FFD329EFEsl60=;
        b=8LQeVcEvMa90jUyoUsqDiJjvVyrp+XPGwPAP9tMsXscJBKWKm0I9bSQJBMD3iikPMG
         kML/CzmgsagpE/hjyPDnV3g6efudYHzkRH3iz1wHdjUQkmnZVuYY8So7OFbogD7qnkM0
         45FHhdcDYxcbXGqbg3bU0pvp0NjGeECf4Fb+6redEH4lfbsmKBLSoJv8Wh351r5cLcHk
         sScJkuSNARvqBsb4mfPCoLU3AtnQGXhLuTOZARGGrP5p0j5ufTZHhj+MATMSbvxJpX+V
         AwGXB0k247Vzn3K47FK0Nt2KE6/XzzWBdq1uVcB+sr0FsLij6zyj5HKLLo36hlpVEFCS
         VYUA==
X-Gm-Message-State: AJIora8RmVbJEZl3AFkkHJsBKku0O0C5ynUO+s9do2QbjROs/nkdhmc9
        Ejd/YZ7wVnxwaZerWjUz6Wwjg1EIcnA=
X-Google-Smtp-Source: AGRyM1uQo7iZJvXXybfttRNJr6yh9lKVjKJrK2YDRhec8QoPmdp3TOkiVUpDp+cD3zAp8DARTE5SdA==
X-Received: by 2002:a05:6402:428a:b0:42e:8f7e:1638 with SMTP id g10-20020a056402428a00b0042e8f7e1638mr3938184edc.228.1656148403337;
        Sat, 25 Jun 2022 02:13:23 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id a18-20020aa7cf12000000b0043503d2fa35sm3735050edy.87.2022.06.25.02.13.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jun 2022 02:13:22 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <8b3d1e58-fb79-ca84-c396-a44318d3ebd1@redhat.com>
Date:   Sat, 25 Jun 2022 11:13:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 0/5] Fix wrong gfn range of tlb flushing with range
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc:     kvm@vger.kernel.org
References: <cover.1656039275.git.houwenlong.hwl@antgroup.com>
 <YrZDkBSKwuQSrK+r@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YrZDkBSKwuQSrK+r@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/25/22 01:06, Sean Christopherson wrote:
>> ("KVM: Replace old tlb flush function with new one to flush a specified range.")
>> replaces old tlb flush function with kvm_flush_remote_tlbs_with_address()
>> to do tlb flushing. However, the gfn range of tlb flushing is wrong in
>> some cases. E.g., when a spte is dropped, the start gfn of tlb flushing
> Heh, "some" cases.  Looks like KVM is wrong on 7 of 15 cases.  And IIRC, there
> were already several rounds of fixes due to passing "end" instead of "nr_pages".
> 
> Patches look ok on a quick read through, but I'd have to stare a bunch more to
> be confident.
> 
> Part of me wonders if we should just revert the whole thing and then only reintroduce
> range-based flushing with proper testing and maybe even require performance numbers
> to justify the benefits.  Give that almost 50% of the users are broken, it's pretty
> obvious that no one running KVM actually tests the behavior.
> 

I'm pretty sure it's in use on Azure.  Some of the changes are flushing 
less, for the others it's more than likely that Hyper-V treats a 1-page 
flush the same if the address points to a huge page.

Paolo
