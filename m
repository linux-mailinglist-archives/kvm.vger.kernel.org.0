Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED4F07A501E
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 18:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbjIRRAA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 13:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbjIRQ7l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 12:59:41 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 592E6FF;
        Mon, 18 Sep 2023 09:59:34 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id 2adb3069b0e04-500bbe3ef0eso5607721e87.1;
        Mon, 18 Sep 2023 09:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695056372; x=1695661172; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JZ3JSQvJQMgOVE1TzYd6UzlsQe8p5pvEt2T0V1nl2QE=;
        b=j6yDprONRh8TGwEjLzzNvsz0syrDz7khaN823VxMly4IE+9F8CB8GjGft6jgxJaqba
         TtCsrxwOtoEtOZuWtlfkz5ofbpCFKwAzAHYz2HUCU4Bvdnafh1k7OS9twBXrNdUTnNzF
         Uo9K/oRzV8djYxYs2CCcWd5lzyov6iZGO/dpbbyIanjp89cRdtD+n7ZHi0RSAXog6CHN
         5urt/bPCLX9JxposblWcSzTQ1JPKGp4Z4LIvBDjTlmjPZaO6vlRGqiJ13PlzJtltApvB
         Lc5CJ+MS//0DMXkozifbcHX+gvV/byrUBJNHSMFdz6isp5NXcyqA8Vwr9I4RNjaxlXqo
         utyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695056372; x=1695661172;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JZ3JSQvJQMgOVE1TzYd6UzlsQe8p5pvEt2T0V1nl2QE=;
        b=mhpFEk7jBBkAFnXYh8JIIpFZbuj/NrLJPewBYj+mAdpIhQ0LI/lodwHSKYGMFEHkWM
         Mjhp+bwVXZqvaj+YkrBNiUb3aXAH9HQZOkmSDF9+Igbei56Rx7a7nEUm6w0cHVQ8AvdD
         bb/QflXbpmKJwwwUBkxNAN0A/cWmMPRRFI6AZC4OrfxypZG14f38xy1V9VwdVHz47nmq
         9z6tjP8unINYwR3rMn6nLIH8RIByA/5HcktIZ8lnkEYg+dEQsUkTRvHWYpIB3xwWfZBu
         lX6zVwYbMqI0RfYQF7VeAKWihpYolWPaFgJqR4t44mf8hKEwkA0bA7ma2oFM8oZmQeEU
         aHcg==
X-Gm-Message-State: AOJu0YzaFbfzhMg3hE6SJ5rU1y0Ya9NYAf1cMTujtMDqQbgBrUQCIMYH
        xqWj/ZDmhEdlH3JrJbHNxcKHNjHopBz92oEM
X-Google-Smtp-Source: AGHT+IHiY3ygkpt27RsjdstCa+owCt8QxrBpaJEks5YBvvQao+Gho/8tmhzfNsHciUKwo2fmMl+uQA==
X-Received: by 2002:a05:600c:1914:b0:401:bcec:be3e with SMTP id j20-20020a05600c191400b00401bcecbe3emr9304019wmq.17.1695046492186;
        Mon, 18 Sep 2023 07:14:52 -0700 (PDT)
Received: from [192.168.7.59] (54-240-197-228.amazon.com. [54.240.197.228])
        by smtp.gmail.com with ESMTPSA id a4-20020a05600c068400b004042dbb8925sm12393009wmn.38.2023.09.18.07.14.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 07:14:51 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <27d414c3-095b-3304-f99e-72c105a30ac0@xen.org>
Date:   Mon, 18 Sep 2023 15:14:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Reply-To: paul@xen.org
Subject: Re: [PATCH v2 11/12] KVM: selftests / xen: don't explicitly set the
 vcpu_info address
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Paul Durrant <xadimgnik@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230918112148.28855-1-paul@xen.org>
 <20230918112148.28855-12-paul@xen.org>
 <f649285c0973ec59180ed51c4ee10cdc51279505.camel@infradead.org>
 <56dad458-8816-2de5-544e-a5e50c5ad2a2@xen.org>
 <c9a1961812b0cbb6e9f641dec5c6edcb21482161.camel@infradead.org>
 <f5eab713-fa74-2cbc-7df5-81d8d26fee0a@xen.org>
 <425F7A5D-58D1-4D94-A88C-E7B1EAEAD084@infradead.org>
Organization: Xen Project
In-Reply-To: <425F7A5D-58D1-4D94-A88C-E7B1EAEAD084@infradead.org>
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

On 18/09/2023 15:05, David Woodhouse wrote:
> 
> 
> On 18 September 2023 14:41:08 BST, Paul Durrant <xadimgnik@gmail.com> wrote:
>> Well, if the VMM is using the default then it can't unmap it. But setting a vcpu_info *after* enabling any event channels would be a very odd thing for a guest to do and IMO it gets to keep the pieces if it does so.
> 
> 
> Hm, I suppose I'm OK with that approach. The fact that both VMM implementations using this KVM/Xen support let the guest keep precisely those pieces is a testament to that :)
> 

I can have the selftest explicitly set the vcpu_info to point at the one 
that's already in use, I suppose... so the would at least make sure the 
attribute is functioning.

> But now we're hard-coding the behaviour in the kernel and declaring that no VMM will be *able* to "fix" that case even if it does want to. So perhaps it wants a modicum more thought and at least some explicit documentation to that effect?
> 
> And a hand-wavy plan at least for what we'd do if we suddenly did find a reason to care?

Handwavy plan would be for the VMM to:

a) Mask all open event channels targetting the vcpu
b) Copy vcpu_info content to the new location
c) Tell KVM where it is
d) Unmask the masked event channels

Does that sound ok? If so I can stick it in the API documentation.



