Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 024915847F9
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 00:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbiG1WLJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 18:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbiG1WLH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 18:11:07 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29DB5FD05;
        Thu, 28 Jul 2022 15:11:05 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id r1-20020a05600c35c100b003a326685e7cso3698080wmq.1;
        Thu, 28 Jul 2022 15:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=q2/z+7O4E17iIS07AIkl4QnBTdGWTDMPIVTs4ITLA3c=;
        b=UdAYIgX3QnJ+zCPpv5ngrq1lAvvosnMRgn5q9rc47OC/o8am/v/DwLn8s+AAaq7jkY
         dks9vXZ9WLVFKbXopbNuDy2zZlqMAIWgsmBWJdBYlmZeLkDJYS+bgf2LPF1x2T7wbYj7
         vs6n0smR5/rGJfzQuyaC9A2iBSB9P8w6Z14oOK7BzwB7k49wY3CL/Nvd2KOdpCMZb0ZX
         /XUozKLgyIJMuHLrMzjJHfEsTlI4VbbgdFOmK0cpOKJamYPKcmzTEO9JfdTFY3L4V+gv
         CfKh/fJLrTlC0i8S3dLp+DmISvPIGYcnaSLP1yz6oWzWGcdXa/t5YEXnuGswE0uM+gQH
         dr6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=q2/z+7O4E17iIS07AIkl4QnBTdGWTDMPIVTs4ITLA3c=;
        b=qzI+kLyh3iA5sjmg5Tcq8Yx3WXTzMBbeli58L2wr/DN9hRbiQllIzYWEFWxr5BEzGO
         0Kyn5CbKOL3IaRwvAspDKWyfFMwLTfr2NovIfyEI8uVadm/KS2JsxhesxyLMmqQxOOyF
         NoXiRmMU95EaJcv+zxNN6dMmgF9uCGriEZpj5vWsJZgo8vawgcIxinCy8jEbcdnLbMaT
         ZceLbvCzMJjPccLl+ZFJagYgmNGZBX4VuYGfKVceJ2tBUK5iQGUi5n1J004ZC/p3eVOn
         bJWLca4ERlvVbByo34Qpp2eQabZBLBGGQiJrQdPfb6QiG17mPZVmgwPAuV7WSyZUKVfH
         a0IA==
X-Gm-Message-State: AJIora/O5QkLE8ZIf9GY2fK9WcfCwEi/DoOCfjUebBszfjbLWSBFkUM1
        t+bFSpQOrMoEsmGGTChZXOs=
X-Google-Smtp-Source: AGRyM1uT4dr9G2iKVcNG5Z7Zve1cM+mhX0bkVdF4U2dM1BceH9FJUEGUOew6sFEQcNvfp0+0gQgfXA==
X-Received: by 2002:a1c:a444:0:b0:3a3:53e6:fd3d with SMTP id n65-20020a1ca444000000b003a353e6fd3dmr811870wme.173.1659046263431;
        Thu, 28 Jul 2022 15:11:03 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id v21-20020a7bcb55000000b003a3270735besm2364725wmj.28.2022.07.28.15.11.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 15:11:02 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <16036872-43d6-fdef-b262-1423fd6207bc@redhat.com>
Date:   Fri, 29 Jul 2022 00:11:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 1/6] KVM: x86/mmu: Tag disallowed NX huge pages even if
 they're not tracked
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yosry Ahmed <yosryahmed@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Ben Gardon <bgardon@google.com>
References: <20220723012325.1715714-1-seanjc@google.com>
 <20220723012325.1715714-2-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220723012325.1715714-2-seanjc@google.com>
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

On 7/23/22 03:23, Sean Christopherson wrote:
> Tag shadow pages that cannot be replaced with an NX huge page even if
> zapping the page would not allow KVM to create a huge page, e.g. because
> something else prevents creating a huge page.  This will allow a future
> patch to more precisely apply the mitigation by checking if an existing
> shadow page can be replaced by a NX huge page.  Currently, KVM assumes
> that any existing shadow page encountered cannot be replaced by a NX huge
> page (if the mitigation is enabled), which prevents KVM from replacing
> no-longer-necessary shadow pages with huge pages, e.g. after disabling
> dirty logging, zapping from the mmu_notifier due to page migration,
> etc...
> 
> Failure to tag shadow pages appropriately could theoretically lead to
> false negatives, e.g. if a fetch fault requests a small page and thus
> isn't tracked, and a read/write fault later requests a huge page, KVM
> will not reject the huge page as it should.
> 
> To avoid yet another flag, initialize the list_head and use list_empty()
> to determine whether or not a page is on the list of NX huge pages that
> should be recovered.
> 
> Opportunstically rename most of the variables/functions involved to
> provide consistency, e.g. lpage vs huge page and NX huge vs huge NX, and
> clarity, e.g. to make it obvious the flag applies only to the NX huge
> page mitigation, not to any condition that prevents creating a huge page.

Please do this in a separate patch, since this one is already complex 
enough.

>   	 * The following two entries are used to key the shadow page in the
> @@ -100,7 +106,14 @@ struct kvm_mmu_page {
>   		};
>   	};
>   
> -	struct list_head lpage_disallowed_link;
> +	/*
> +	 * Use to track shadow pages that, if zapped, would allow KVM to create

s/Use/Used/

Thanks,

Paolo
