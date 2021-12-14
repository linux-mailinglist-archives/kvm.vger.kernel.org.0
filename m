Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11C0B47425D
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 13:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233820AbhLNMTu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 07:19:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231994AbhLNMTt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 07:19:49 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4627C061574
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 04:19:48 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id 137so14090689wma.1
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 04:19:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JWAY5L711tTj2/GFa/GO69wdROFlkBhuP6a7dqDdXcY=;
        b=By0YQW599bp7AwDOtV1g9cPSwTU3AvPjtYWmOFGL/XBUAI95uR8tBtQpxpPJ3zBgNU
         5eFa7audd94g4xO7oSvUz9iJ1Sj0RhqJmI1/axhg9eDFhMoeex1gZe61j0KMqmBNrdIU
         V8mEPJosh/Dm67aMl/WtPjpcwkO8wKt2mrxLlFZuy+/+1hFPHFO+2XKQLGiTR8aJygyG
         rOJ8/yBKEYL6/hwrMbz8Eo8BRRKS8PI9rMpQ96szcajh3R1Nl1YgA0+QKzKBolVxGKCF
         cLJerH32snjBks6WUVc14EoBYDuMRKhw4pT6Muy2x2bOnYJCtAww3Kc+bJDNtraVMw1P
         sdzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JWAY5L711tTj2/GFa/GO69wdROFlkBhuP6a7dqDdXcY=;
        b=RfumJMzp/lTbTJpoKwYziOLg8d5yeqAoM52KNJMixb3j5/QomiRnI4CxhrLkAglf6/
         xHC/I/lZZ7n2KZR+xERSciZ3JpP0sTPcOa5W0snxr5WMhM7dNEd0jUeBYYtnRJeDzkPq
         6mjcLK/c8p90n8/0WQGGdUDb777+hFM2Ekizj++Xh6niRZou2SisLNJBirQ/C852S0wk
         SJZk10xedT82clmXAp1+ErN1eXWVNtrsmfVBjIqS1Nf2kKCyKMlOhc0B6Z310DShhFB7
         +F4GhLGM0JWhnsSo2hBLJpTuEcITjrb/EajjWtqscCxSb/eZJBP5p6QLDWoMw2PNp+Dc
         1Cyw==
X-Gm-Message-State: AOAM533GGlFZmJF4xKT5qbVaf11LhAl1c8yjdMwTXA+1g5oakWVfVy0E
        3w4PJJtjrjPAvy5y5ikdIrHSHEfUYgE=
X-Google-Smtp-Source: ABdhPJwuo57GKKFdlpSGJwczm3+J3OogQUwZQ4qH4xkNju9i23lZnxidC0zgrjEeRHD1HzlJa64u7g==
X-Received: by 2002:a1c:2047:: with SMTP id g68mr47329825wmg.181.1639484387431;
        Tue, 14 Dec 2021 04:19:47 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id y142sm2000105wmc.40.2021.12.14.04.19.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Dec 2021 04:19:47 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <387b118d-dcb9-f528-c643-aa3b3c389901@redhat.com>
Date:   Tue, 14 Dec 2021 13:19:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH v2 0/4] Add additional testing for routing
 L2 exceptions
Content-Language: en-US
To:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com
References: <20211214011823.3277011-1-aaronlewis@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211214011823.3277011-1-aaronlewis@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/21 02:18, Aaron Lewis wrote:
> In a previous series testing was added to verify that when a #PF occured
> in L2 the exception was routed to the correct place.  In this series
> other exceptions are tested (ie: #GP, #UD, #DE, #DB, #BP, #AC).
> 
> The first two commits in this series are bug fixes that were discovered
> while making these changes.  The last two implement the tests.
> 
> v1 -> v2:
>   - Add guest_stack_top and guest_syscall_stack_top for aligning L2's
>     stacks.
>   - Refactor test to make it more extensible (ie: Added
>     vmx_exception_tests array and framework around it).
>   - Split test into 2 commits:
>     1. Test infrustructure.
>     2. Test cases.
> 
> Aaron Lewis (4):
>    x86: Fix a #GP from occurring in usermode library's exception handlers
>    x86: Align L2's stacks
>    x86: Add a test framework for nested_vmx_reflect_vmexit() testing
>    x86: Add test coverage for nested_vmx_reflect_vmexit() testing
> 
>   lib/x86/desc.c     |   2 +-
>   lib/x86/desc.h     |   5 ++
>   lib/x86/usermode.c |   3 +
>   x86/unittests.cfg  |   7 ++
>   x86/vmx.c          |  28 ++++++--
>   x86/vmx.h          |   2 +
>   x86/vmx_tests.c    | 161 +++++++++++++++++++++++++++++++++++++++++++++
>   7 files changed, 201 insertions(+), 7 deletions(-)
> 

Queued patches 1-2 for now, thanks.

Paolo
