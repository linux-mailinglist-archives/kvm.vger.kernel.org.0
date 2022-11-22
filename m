Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE376341E0
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 17:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233774AbiKVQtm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 11:49:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232355AbiKVQtk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 11:49:40 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE286D494
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 08:49:39 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id s5so8421276wru.1
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 08:49:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WYdwvHIi6DqjXCDAORbhbwu4G8zzO6vRrPEDwC0sCPE=;
        b=kNJg8I+unKo2QwPHf/4lQ1ohU2IwJZ6VbzuvuJ6xz3CgDuReNWeyoZwA2q4whLzM5K
         L7lRo1DwcHIPy9D2q6RUtuJDKpPYsgTW1q9xsRkTmA/lEjHp1fD1bN1oeALm11tQXoGf
         KE+jNQoRRLjqc1eQGVpwBn2EuNLfp3A1hmraLXSCGIfYMk2la3C+xWHTvqEtpPnaRNad
         mnRPUHz0SFGCzWqMP8LwM4Y1xtJNpx7KyCeiN2lPY7NSdWD2eILK54CFg83ex9L+PWve
         Qh7HkyDmtnssa84y75DL4XcM+6UnQ157JGSulnQ6RjMHIydCfw68cWikFisARlWHo99k
         3hdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WYdwvHIi6DqjXCDAORbhbwu4G8zzO6vRrPEDwC0sCPE=;
        b=Wy3tJgOaf9hxvg3dgCZMY3+Jp9bbnsG2wm6nL11Y1UDDU681s7/guk5RzG/VBS18tY
         fGwoWQ77t06b1vSoDNG8AAjJ7IE449+E0qMfqj5sltABlGmmFgPeFxmZVEGB9NULWz/j
         rc/TlzsR5fqiPXtzX60EWomNdnxoSTM4WSvJKgOeWWErdIUDR8gNyeiIAhJCpFQy+DcJ
         g0sxBQohOEjynW4pFhiiCCwnWkGTDX4PZB/Cg+GnAwhzL4hOmBJwzcfpjUL8kkd5S5C9
         1f0ZTqPH/xUDN48IpwSIo0gtHdedPuOdDkrhcZEAPiNK/UvqWZB3vhWiQJVRkxd6kszw
         sT/A==
X-Gm-Message-State: ANoB5pnQC+kQFbWHf0o3ch3AihqE9CyqsC11meLRd2ETSgpbr+dCwE9q
        f1KwQlBWYrumb+FgXnLak88=
X-Google-Smtp-Source: AA0mqf4VgjxBWl9MpFhuBLDKpovDEfLPL2S+egq4EUh6DbQYoBpADh8PhFw6Uumgwz4P+7LUyjC0Nw==
X-Received: by 2002:adf:ea81:0:b0:241:bcc1:7643 with SMTP id s1-20020adfea81000000b00241bcc17643mr3239264wrm.673.1669135778170;
        Tue, 22 Nov 2022 08:49:38 -0800 (PST)
Received: from [192.168.6.138] (54-240-197-238.amazon.com. [54.240.197.238])
        by smtp.gmail.com with ESMTPSA id c9-20020a5d5289000000b00236545edc91sm14392514wrv.76.2022.11.22.08.49.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Nov 2022 08:49:37 -0800 (PST)
Message-ID: <d7ae4bab-e826-ad0f-7248-81574a5f2b5c@gmail.com>
Date:   Tue, 22 Nov 2022 16:49:36 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 3/4] KVM: Update gfn_to_pfn_cache khva when it moves
 within the same page
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        "Durrant, Paul" <pdurrant@amazon.co.uk>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mhal@rbox.co" <mhal@rbox.co>
References: <20221119094659.11868-1-dwmw2@infradead.org>
 <20221119094659.11868-3-dwmw2@infradead.org>
 <681cf1b4edf04563bba651efb854e77f@amazon.co.uk> <Y3z3ZVoXXGWusfyj@google.com>
From:   Paul Durrant <xadimgnik@gmail.com>
In-Reply-To: <Y3z3ZVoXXGWusfyj@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/11/2022 16:23, Sean Christopherson wrote:
> On Sat, Nov 19, 2022, Durrant, Paul wrote:
>>> -----Original Message-----
>>> From: David Woodhouse <dwmw2@infradead.org>
>>> Sent: 19 November 2022 09:47
>>> To: Paolo Bonzini <pbonzini@redhat.com>; Sean Christopherson
>>> <seanjc@google.com>
>>> Cc: kvm@vger.kernel.org; mhal@rbox.co
>>> Subject: [EXTERNAL] [PATCH 3/4] KVM: Update gfn_to_pfn_cache khva when it
>>> moves within the same page
> 
> Please use a mail client that doesn't include the header gunk in the reply.
> 

Sorry about that; it's not just a change of client unfortunately but I 
should be avoiding the problem now...

>>> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
>>
>> Reviewed-by: <paul@xen.org>
> 
> Tags need your real name, not just your email address, i.e. this should be:
> 
>    Reviewed-by: Paul Durrant <paul@xen.org>

Yes indeed it should. Don't know how I managed to screw that up... It's 
not like haven't type that properly hundreds of times on Xen patch reviews.

   Paul

