Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6805842BC
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 17:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiG1POC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 11:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiG1POA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 11:14:00 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1878B52446
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 08:14:00 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id z22so2573982edd.6
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 08:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BwfcMljdVanr7R7QAMsX3kgi9lFparn5kv+0sGb6tKk=;
        b=aqfUbZ8907siRZ1apUf8RCuya/yaIL99tDZyXhe8qMq/bUPkz7NnfAug14wukx93gV
         vhmtnzz6PPLBOL85/qLqXIw22yAHlGILrbsjpd/8oTY9GTT2NIHjg0IzxuFcOlxfCBHM
         N0ZdQAmuN+NpjSwjJbr15J56dwnYpyI6dzSAR6yqwlW/sjVXNiUJe8oQ32HhYNQvvvox
         ImcFvEd4Xc6fhgN7nsxySZfLENiX5JRiCENF7rbbiyscp3SF1dmgtS0QD6xFgtT9Cjpz
         ccKQPtmw96r6aU6spOlhj0dHd/oJVJ0L/bi0bzYJK9bbQUc2NnRgTD863rZXaecKIVib
         ubNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BwfcMljdVanr7R7QAMsX3kgi9lFparn5kv+0sGb6tKk=;
        b=UAJacTreHywnSj0fKZGc+r9fkaYdPIPWtviWlvsDjncsCdOpt8HyFwsBzgKe13VCU7
         J9SjUGX76EHYvZmnSGkXI5IfZnSAmY01cRRRggLX0eIo/+mliHmx/xfStoSnbT2NTgi4
         AD8LeuPgNeKzpJuNMjV7ZXU6MHn3nDtgwLmr3iYXw+ZHbaHIwgeLy2ueNbHw7FaYB3jy
         FA1sOVCDeZ73AuPJjQmiLPgKJSfp0JqRpZ0jGKWwP1sapBDc00FxL8iaim+heBGo7tTJ
         66D3xRkMbC7CLWsM5UB7hHOI965E/F2kw3upfbf6RxwAEMv/H5YJWUh+f/6AEp1Y5g2B
         TByg==
X-Gm-Message-State: AJIora+hRaJjkbhjMIW9R0wQtAX27n/Goa3UODNOzTLzTTYPNb9envQL
        ZBiIR/kQUYdCEF4PB8kyQEA=
X-Google-Smtp-Source: AGRyM1tzgZ7gj0IpjrNRJSBEzPuxNH5sJ2VWf2mtp6b8pRnn0Jngd0zsZWtehWwnFL6AETOztzFWbg==
X-Received: by 2002:a05:6402:274b:b0:43b:f23f:e011 with SMTP id z11-20020a056402274b00b0043bf23fe011mr21887162edd.259.1659021238574;
        Thu, 28 Jul 2022 08:13:58 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id g8-20020a17090669c800b00726abf9a32bsm511029ejs.138.2022.07.28.08.13.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 08:13:57 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <0fcfac63-bbba-779f-6393-bcf1e1f790d7@redhat.com>
Date:   Thu, 28 Jul 2022 17:13:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH kvm-unit-tests] x86: add and use *_BIT constants for CR0,
 CR4, EFLAGS
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <20220726151232.92584-1-pbonzini@redhat.com>
 <YuAlHgkpBZS0QJ5e@google.com>
 <162240da-39c5-bed2-166c-58d34bcd4130@redhat.com>
 <YuF9QA3v5lQLvDVM@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YuF9QA3v5lQLvDVM@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/27/22 20:00, Sean Christopherson wrote:
>> I saw a failure on older binutils where 1UL is not accepted by the
>> assembler.
> 
> Mostly out of curiosity, how old?  I thought I was running some ancient crud in some
> of my VMs, but even they play nice with this.

CentOS 7, so 2014-vintage.

>> An alternative is to have some kind of __ASSEMBLY__ symbol as in Linux.
> 
> I've no objection to this approach, but can you reword the changelog to call out
> that it's only older binutils that's problematic?  I was truly confused by the
> "cannot be used" blurb.
> 
> And a nit, add spaces around the shift (largely because they're needed around the
> string), e.g.
> 
>    "orl $(1 << " xstr(X86_EFLAGS_AC_BIT) "), 2*"S"(%"R "sp)\n"  // set EFLAGS.AC and retry
> 
> I'm indifferent about the lack of spaces for the existing multiplication, I just
> found the shift a little hard to read.

Ok, will do.

Paolo
