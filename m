Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 450D9525424
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 19:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238771AbiELRvl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 13:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357351AbiELRvj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 13:51:39 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81E2434BBD
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 10:51:34 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id m6so6209275iob.4
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 10:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6zJtowkNav+j8c99jQGawGovDBowhLxY1bWFnapGg24=;
        b=CiEjvxp7OBwBNNMimrdjh6JcHnxJcPPB6GZXoTvudqsWA1RnZMgrx8hgOxLNRgyrTu
         sAh2UyxTfXvlC9uAtD+5RCbdWQ/Phi+G8G/3wmcx2yMv+B8LGax4UmLFRVPzVAQmTwPw
         QZS1vtWrQED8t1c1f1fDcmfZKDJSfCpzqSsuo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6zJtowkNav+j8c99jQGawGovDBowhLxY1bWFnapGg24=;
        b=V8YqNiZ3sgOWo8j/cOEisPbw/99XvqNqDApj0rHSgmaM58e9w0pDpE2uknAWe+957D
         cNWarcXrCRInephhNq4yghmdHSnV3RjM/p8cJFPocmH+IxvHciefkhg3BZAm4RVg/LVH
         JBvgXQ3Y7GVHBLPKthp7pf79zQ2hJoKFoM7VoIFaU/zJ9z5Lb5LybeAfjMxF6xezXuUN
         2DkNNynYbWvEySAF5u1V6SellIAekZY9eBHSgt2V+NC2BYTQ7aHFge1yOkJ2KxABtMCY
         dhr5Q2bgKpoMstbiR65uJxY2OsVsMLsdhQDHvUlDOwIw9+Z6Z8BOXxB9/hZ+/kzQ5bL0
         OeIA==
X-Gm-Message-State: AOAM531EN7tf4jiaai1qhzpz3/PmXTmceMOPAXCgGTeHs9+N1F9NVB7W
        P2J9ca1g5CfOo5eANH3kBj7dAw==
X-Google-Smtp-Source: ABdhPJzGJ3oE9fRz9MvUu+SHXJDyvxY5C8WQoZUCS7zIhcGZgdHf351/z+GJnK7omiHdcv58EQa1VA==
X-Received: by 2002:a05:6638:3804:b0:32b:8eeb:da96 with SMTP id i4-20020a056638380400b0032b8eebda96mr625746jav.71.1652377893344;
        Thu, 12 May 2022 10:51:33 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id x4-20020a056602210400b0065a47e16f4dsm124620iox.31.2022.05.12.10.51.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 10:51:33 -0700 (PDT)
Subject: Re: [RFC V2 PATCH 7/8] selftests: kvm: Add hugepage support to
 priv_memfd_test suite.
To:     Vishal Annapurve <vannapurve@google.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, shauh@kernel.org, yang.zhong@intel.com,
        drjones@redhat.com, ricarkol@google.com, aaronlewis@google.com,
        wei.w.wang@intel.com, kirill.shutemov@linux.intel.com,
        corbet@lwn.net, hughd@google.com, jlayton@kernel.org,
        bfields@fieldses.org, akpm@linux-foundation.org,
        chao.p.peng@linux.intel.com, yu.c.zhang@linux.intel.com,
        jun.nakajima@intel.com, dave.hansen@intel.com,
        michael.roth@amd.com, qperret@google.com, steven.price@arm.com,
        ak@linux.intel.com, david@redhat.com, luto@kernel.org,
        vbabka@suse.cz, marcorr@google.com, erdemaktas@google.com,
        pgonda@google.com, nikunj@amd.com, seanjc@google.com,
        diviness@google.com, Shuah Khan <skhan@linuxfoundation.org>
References: <20220511000811.384766-1-vannapurve@google.com>
 <20220511000811.384766-8-vannapurve@google.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <2a9ffa3d-cc74-a2e8-54c5-3f5321556c13@linuxfoundation.org>
Date:   Thu, 12 May 2022 11:51:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220511000811.384766-8-vannapurve@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/10/22 6:08 PM, Vishal Annapurve wrote:
> From: Austin Diviness <diviness@google.com>
> 
> Adds ability to run priv_memfd_test test suite across various sizes of pages
> for shared/private memory. Shared and private memory can be allocated
> with different sized pages. In order to verify that there isn't a
> behavior change based on different page sizes, this change runs the
> tests using the currently supported permutations.
> 
> Adds command line flags to adjust whether the tests should run with
> hugepages backing the test memory.
> 
> Signed-off-by: Austin Diviness <diviness@google.com>
> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> ---

Please see comments about coding style related comments on other
patches in this series.

thanks,
-- Shuah

