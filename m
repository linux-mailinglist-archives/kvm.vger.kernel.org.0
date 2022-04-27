Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42FA551213D
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 20:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238867AbiD0PFh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 11:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236491AbiD0PFg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 11:05:36 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB434D63D;
        Wed, 27 Apr 2022 08:02:25 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id z16so1819395pfh.3;
        Wed, 27 Apr 2022 08:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:organization:in-reply-to
         :content-transfer-encoding;
        bh=QnoE3ffrzubputntu4ko6+9+tzF97FQTX2tI8ulxeLc=;
        b=Ms/PKWQsVHy3HpCrfrT9M/J4BkWp7ChQewNIPTgiueXQ8w1EqAk/yYTHQBzWHJYwt5
         hxGByZmvtN8ZuQmTa3GSa/T8PQj07zeyFCMI/1x7AeI9ts0jCJFknKYvZ/PgTn6q+kpI
         pLXeXB2ra5JpS/GWACgQQxkDSc4aRvx5XSJ5vVTDg66+aL58vrxtl2BEb6gvDWpNbEdY
         ms+SaYf0d6nWh7W99Xz88/aZy9cuNZqw0+utdDhj9Z7jKwsrOEYlYURt2TmPI/p22AXm
         I7TDJh6Bio9d/VxL+mo8KCIf41y02NPMxxhH6BXKahrpywX1ibk4ehl1X9LTeqVjy61t
         dv1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:organization:in-reply-to
         :content-transfer-encoding;
        bh=QnoE3ffrzubputntu4ko6+9+tzF97FQTX2tI8ulxeLc=;
        b=u+ikt4dqZs+sA5+xbiCQ5zdhPRzQkpdcsYBqSEHHt+TfKkdGewrbzxkzj4/5PmuCaD
         93+6SlvONuRI1GwNNZfcgYoP5Hj4TBRHuzs3CCzML7ISqNrtqp9ZWRCNL+SPT9gPRp80
         kv2EI0dC37hMgbvn6gt6CM8uKAgBZUafr1xEuObdBPgceneHiBaJlSmUx9qdQGXjVncn
         NLpXUxcMf4UL8DOjvRSZms16cXn+xQD3cX93FGMnc+JTcZnz3zc7X7DwI4gjkf2opX6a
         YNM8oaVmViC8pxwOiECyfC2b7xNdHpnz5ngdMjRAzB3MWfNJAlH3wKJda+ay8PuXkQZQ
         EK3g==
X-Gm-Message-State: AOAM533Ze9A3pn/uIE2OdFMbW2DKit3GBSOBaa8SDJ41tCKg12x5GA8E
        YDFyLyaNq8cU7TRHNMB4DKU=
X-Google-Smtp-Source: ABdhPJz1gtWGqiJfDP8DiYowXbQqmh0I+6OR0KFoHUC0RF8SJu1dCym+Qe17bc/KRkZxO9WMn8gjww==
X-Received: by 2002:a63:175a:0:b0:3aa:4360:242 with SMTP id 26-20020a63175a000000b003aa43600242mr24649650pgx.120.1651071744592;
        Wed, 27 Apr 2022 08:02:24 -0700 (PDT)
Received: from [192.168.255.10] ([203.205.141.111])
        by smtp.gmail.com with ESMTPSA id z188-20020a6265c5000000b0050602bec574sm18949547pfb.209.2022.04.27.08.02.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 08:02:24 -0700 (PDT)
Message-ID: <12015d66-8505-0c68-c27c-46725f6b2cc4@gmail.com>
Date:   Wed, 27 Apr 2022 23:02:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH v3 00/11] KVM: x86/pmu: More refactoring to get rid of
 PERF_TYPE_HARDWAR
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <likexu@tencent.com>
References: <20220411093537.11558-1-likexu@tencent.com>
Organization: Tencent
In-Reply-To: <20220411093537.11558-1-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A kind ping on this collection of minor changes. :D
