Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA8BB5847F6
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 00:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbiG1WKC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 18:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbiG1WKA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 18:10:00 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C26525598;
        Thu, 28 Jul 2022 15:09:59 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id h8so3934655wrw.1;
        Thu, 28 Jul 2022 15:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cjOXTI1FlP6AWKnp27IshI2ukwUOxIl9rfjw4XiOLIs=;
        b=BCK0ahu9e9R7tKwfpQhoy3f0JqDIErosQ0uC34ILDzOAdqqvFfBp7+Ch+ZBxwsYYjl
         TkkscjwFZbIY6nR3mFJRgnwBayRQEuVOi0upicebDFQtCYlghB6hBcO886QTXYak08Ee
         lZISN85pCSEycewaE3VAxIZRjwZAARMF0dLriRnURt8IBmYu9xpkoVA0WgDU+s8EOaPu
         0FO9NM5pCkobucD1UMV8MqI7cReOtJKK5TrfZAJi+/SfDoTeBVaL6CfJILpP3+JsL/GT
         6QAQ4T38AqCCx5DfwLXoMMO+mzdNvqf0O0cBmvstwuQNuq3vMBKvza7pMpLRcUG2MPUt
         K4NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cjOXTI1FlP6AWKnp27IshI2ukwUOxIl9rfjw4XiOLIs=;
        b=F0nTsqWy/yD9nJ7guzGKvede9f6KquIU+W83m4kPVV509dVvscAAg4cztaAyp7h+H4
         gThwemS0Sg9k+FHXHSJZE/+DFK8+Rf+uLvPYsOuApV0JQxxD1WuScVWmvUYl8wrQw11L
         axsI28S5FobWtsp5XvkIue4KLl+s+XBridNfto7tEAKzYetEhz3c5j83awl6C58gFs19
         PytyETsZcf3nrqmqxtQo/n9lzQVOQNbVsP5bpLDnBP8NiL8fswuLUelL2B97cyeuEZzN
         OrVRzyTyX91REgvPiKuoIEt8sUriFgjgOapaOA/9t+976qnXkiccUtggMbbWIANR3/Cp
         vkUg==
X-Gm-Message-State: ACgBeo1L2of0IlENnQfn4UAjKT7X6RsbLQYgG2YSBFIcp6/x7fRoUQw6
        7z0Fe5F1c5lazMzRf6srjOdYGqOgeeJghw==
X-Google-Smtp-Source: AA6agR6uY51PbvG7tBL3HNN1RTQWBwP6UjD1JYu6vPplgKJ1o3Z3BmL+aCN8d5JYxtDDhHW5C9g8/g==
X-Received: by 2002:adf:db8e:0:b0:21e:3fff:6bae with SMTP id u14-20020adfdb8e000000b0021e3fff6baemr531876wri.184.1659046197747;
        Thu, 28 Jul 2022 15:09:57 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id k19-20020a05600c1c9300b003a31fd05e0fsm13107426wms.2.2022.07.28.15.09.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 15:09:57 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <f8ccb892-cf79-62df-2752-2333467245cd@redhat.com>
Date:   Fri, 29 Jul 2022 00:09:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 0/6] KVM: x86: Apply NX mitigation more precisely
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yosry Ahmed <yosryahmed@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Ben Gardon <bgardon@google.com>
References: <20220723012325.1715714-1-seanjc@google.com>
 <08c9e2ed-29a2-14ea-c872-1a353a70d3e5@redhat.com>
 <YuL9sB8ux88TJ9o0@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YuL9sB8ux88TJ9o0@google.com>
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

On 7/28/22 23:20, Sean Christopherson wrote:
> 
> Anyways, the bug we really care about is that by not precisely checking if a
> huge page is disallowed, KVM would refuse to create huge page after disabling
> dirty logging, which is a very noticeable performance issue for large VMs if
> a migration is canceled.  That particular bug has since been unintentionally
> fixed in the TDP MMU by zapping the non-leaf SPTE, but there are other paths
> that could similarly be affected, e.g. I believe zapping leaf SPTEs in response
> to a host page migration (mmu_notifier invalidation) to create a huge page would
> yield a similar result; KVM would see the shadow-present non-leaf SPTE and assume
> a huge page is disallowed.

Ok, thanks.  So this will be 5.21 material even during the -rc phase; I 
have posted a couple comments for patch 1 and 2.

One way to simplify the rmb/wmb logic could be to place the rmb/wmb 
respectively after loading iter.old_spte and in tdp_mmu_link_sp.  If you 
like it, feel free to integrate it in v3.

Paolo
