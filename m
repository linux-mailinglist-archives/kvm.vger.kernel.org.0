Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 180BF7A5CE0
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 10:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbjISIsi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Sep 2023 04:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjISIsh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Sep 2023 04:48:37 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E0D5E6;
        Tue, 19 Sep 2023 01:48:31 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id ffacd0b85a97d-3200bc30666so2146515f8f.2;
        Tue, 19 Sep 2023 01:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695113310; x=1695718110; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wsOUbToZQ1AdP+t85PWWVZhgYd99YzCsWjDsvb5/YKs=;
        b=k0BBwEpsCVAZpLkuWGJtr6JljdguGgFXdf4oVzuZkwj6ugDyQ21Z+j5dSeQ+y78p4B
         sk2qZ0SgQONT9NOFWpt9PTAb/WrSPlVODSiHW/3dvNTHsaVe5AdzUuv5V+/zy1wQdd64
         h6t68egqjVLgX4z8La7BILlWk8JE6LCuzuu9fgGyoXQSe2RFKliCbvwsdz8syXU+/3rd
         p5L0uHffBTFJ2e5fju94KDHBm4wo8eSRbcOMoADLG9hEBC0Zsys1QPGzfUSP72ddNGUO
         XiclTY/MUHQI2ExLPdPGaojOtoye69hp/WfgAdYJJRg1M5MHVreMB34K1jsZ1Gvo6N1p
         199A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695113310; x=1695718110;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wsOUbToZQ1AdP+t85PWWVZhgYd99YzCsWjDsvb5/YKs=;
        b=aHKKQagIVzrxiWApDb/jFrAWfQNxstR9l+/NKPl1MAGTB8hUrIX/3DPTTdxo505KJU
         msCfYkjV14cYMBPj3rfX0uf4gN+5/Mwj0PFpZ8EdhgEBsiggylWBv3zkUtHorL2FaQ08
         UYwfvc+d+pyzwwmL4XOGQ8NDJCG10pflI3zfV91tPw93zocLdThuVC1zmL3yuBmxF3Wv
         H1NTeBE8eqs1/r8sQWT5iBCLX5hbnttSMK0dv3/2wNUE1791WolbTy06ZNUhMVVCTKrg
         AekZPXsY/lRVJ/ewMIxD3lCb0gr36YjibE0xhR4bcrksoDTxWo7qwplLSW1sj89v7b7Z
         rK2Q==
X-Gm-Message-State: AOJu0Yzpb7Wo+Nb1hXjNKwuilnb0rtZXfimbSI7uIX7vJlxSsBhLr6yC
        B3bzCV+p1ZgDR/nTS7mn/2o=
X-Google-Smtp-Source: AGHT+IG/iqd+XbdFNcO6Y5Z6/czCw+v5RuHHV50uuxp6vnts0OajHIw68akSQSir+vARyEG3+OB3vw==
X-Received: by 2002:adf:a301:0:b0:321:6833:b930 with SMTP id c1-20020adfa301000000b003216833b930mr894608wrb.16.1695113309897;
        Tue, 19 Sep 2023 01:48:29 -0700 (PDT)
Received: from [192.168.4.177] (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id q11-20020adff50b000000b0031c71693449sm14994344wro.1.2023.09.19.01.48.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Sep 2023 01:48:29 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <196a645c-f41d-8f35-d854-f30b66aff2a6@xen.org>
Date:   Tue, 19 Sep 2023 09:48:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Reply-To: paul@xen.org
Subject: Re: [PATCH v3 00/13] KVM: xen: update shared_info and vcpu_info
 handling
To:     Sean Christopherson <seanjc@google.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Durrant <pdurrant@amazon.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
References: <20230918144111.641369-1-paul@xen.org>
 <ZQh4Zi5Rj3RP9Niw@google.com>
 <8527f707315812d9ac32201b37805256fab4a0a1.camel@infradead.org>
 <ZQiE7SExjbCVffAE@google.com>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <ZQiE7SExjbCVffAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/09/2023 18:12, Sean Christopherson wrote:
[snip]
> 
> Tag them RFC, explain your expectations, goals, and intent in the cover letter,
> don't copy+paste cover letters verbatim between versions, and summarize the RFC(s)
> when you get to a point where you're ready for others to jump in.  The cover
> letter is *identical* from v1=>v2=>v3, how is anyone supposed to understand what
> on earth is going on unless they happened to be in the same room as ya'll on
> Friday?

The cover letter is indeed identical because the purpose of the series 
has not changed. Each individual patch has a commit comment summarizing 
what changed from version to version or whether it is new in a 
perticular version. I thought this would be enough for any reviewer to 
be able to see what is going on. In future I will also roll these up 
into the cover letter.

> 
> Doing rapid-fire, early review on beta-quality patches is totally fine, so long
> as it's clear that others can effectively ignore the early versions unless they
> are deeply interested or whatever.
> 
> A disclaimer at the top of the cover letter, e.g.
> 
>    This series is a first attempt at an idea David had to improve performance
>    of the pfncache when KVM is emulating Xen.  David and I are still working out
>    the details, it's probably not necessary for other folks to review this right
>    now.
> 
> along with a summary of previous version and a transition from RFC => non-RFC
> makes it clear when I and others are expected to get involved.
> 
> In other words, use tags and the cover letter to communicate, don't just view the
> cover letter as a necessary evil to get people to care about your patches.

That was not the intention at all; I put all the detailed explanation in 
the commit comments because I thought that would make review *easier*.

   Paul
