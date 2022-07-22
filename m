Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C91257E53C
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 19:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236017AbiGVRS3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 13:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235631AbiGVRS1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 13:18:27 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56F61CFDD;
        Fri, 22 Jul 2022 10:18:25 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id y4so6635725edc.4;
        Fri, 22 Jul 2022 10:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=foxH3rHhRPgtf4syZS9ZyQqEcF6wD+SNSuScXFbUvG0=;
        b=QxBPhnrSOWqnIJd43lGO0/gWcM8avq0E8xAoznnlwOdLvCCXkZD8K3UwrpYbHEVdUX
         jQfJKUrV05E+0+2xarcUGpaO2se43L/3/xYdUsvvu95Z6WBiGEG3WwAJw6Ku2vjWcyx/
         MjYKk1Tf2JMx90waYb5Z0hMmSziBGDdTtuc0XO1dryK6bdlslawz/xmt/KDPYb14xhOY
         dace6GBzHw5oWcl/KeC2E1Z66phUK/HMP+95GDCXiKxEjcF7RQdXRyENVqO+9UkvLzf5
         OAAjRH2IVOJhjuOS3aYG/K/ooNRat0oK4gJ46U+LyZlhRF62NlQN3gnSiCRekDoXo8L2
         24eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=foxH3rHhRPgtf4syZS9ZyQqEcF6wD+SNSuScXFbUvG0=;
        b=TAby+sEBzZM+InBpWjHkyCfDsuIq1HIPcnShnngIZ1Rdw2E8AzK4yR9LaXuS9w93rv
         G2BB4Bc575P38VH0Y/L4pyCO1A5HNiVDfq56NoVNP85BDx4sFXGDUV0GuoRCAcfN0uAA
         qd0fjJG2HHcyPSc+5nxRNVZFcxbM5TX/UuKghgHuij2axNqnIE/146EaJz+dwujHW1RU
         YAGo5RKnkwCcYYCuG9p5loeyfojM/N6GXbFCsM1vy0vCFgDE8vBNPhrkT1XvwVi+7SW1
         KmeYVkwJTeNmswVXfP5BueJrUJqTPKdMdCIrV+xDpXKuqi7p7KTzUOVi4+28cWTxBsc2
         xqAg==
X-Gm-Message-State: AJIora/4Zhf+wMYxtFE4XsJUhnxz8UI8VJQPMg3NIgPk/hyOxbF4sb77
        zVEZEdBcteyCkq7OeZcEpOsHW7yrDF9rYQ==
X-Google-Smtp-Source: AGRyM1v14b6KQLZqGhKGEQKVL1vQWfB+6T5FoNKkvPj0AwUq2PkMI5vnQlIBGGBE1Z0ffuH51zMsWQ==
X-Received: by 2002:a05:6402:5167:b0:43b:b6fe:f4d6 with SMTP id d7-20020a056402516700b0043bb6fef4d6mr894486ede.316.1658510304046;
        Fri, 22 Jul 2022 10:18:24 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id w7-20020aa7dcc7000000b0043a83f77b59sm2823150edu.48.2022.07.22.10.18.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jul 2022 10:18:23 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <0f8dde12-576b-1579-38c9-496306aeeb81@redhat.com>
Date:   Fri, 22 Jul 2022 19:18:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] Revert "KVM: nVMX: Do not expose MPX VMX controls when
 guest MPX disabled"
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        oliver.upton@linux.dev
References: <20220722104329.3265411-1-pbonzini@redhat.com>
 <YtrB8JEuc1Il1EOO@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YtrB8JEuc1Il1EOO@google.com>
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

On 7/22/22 17:27, Sean Christopherson wrote:
>> So revert it, at the potential cost
>> of breaking L1s with a 6 year old kernel.
> I would further qualify this with "breaking L1s with an_unpatched_  6 year old
> kernel".  That fix was tagged for stable and made it way to at least the 4.9 and
> 4.4 LTS releases.
> 

Well, there _are_ people that use very old kernels and keep them 
up-to-date with fixes for only critical CVEs (for example by, ehm, 
paying my employer to do so).  But still it's way way unlikely for them 
to be used as L1 in a nested setup, whether on their own hardware or in 
the cloud.

I pushed everything to kvm/queue, but depending on what you post it may 
be deferred to 5.21.

Paolo
