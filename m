Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6743A7D87A5
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 19:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbjJZRki (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 13:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjJZRkg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 13:40:36 -0400
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAAD010E;
        Thu, 26 Oct 2023 10:40:33 -0700 (PDT)
Received: from [192.168.7.187] ([76.103.185.250])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 39QHe3dG212792
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Thu, 26 Oct 2023 10:40:03 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 39QHe3dG212792
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2023101201; t=1698342004;
        bh=FNrhIteOWF3uJmsFb5bV5Sso1fDVYo8hPurD9rN2UVM=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=ErmBckXkZ6inBpQvtx4DBIj4iFWob5bH+lyHcr67GRC4DsIkHhmKaQzO7AYSTNWiY
         xsex/odsaEXYW3TzeKZiYySvtbtOH3rO6dCjpDMFKFszkEP7y0kmJrt5efnqTBt9PM
         cFwaVh6i64KfXEd/OB9aT1QDgzNb2eb8Xz5U053toa0CzlHLYW+L0QeTZFaAD/d62K
         Yz21/UkPFF+LJrhMy2P4zhvorS9x5FhpWmzYliWt4SdxqR1J+owWcR7RFEhynaJDsu
         qOVpERJATfVxGKLXEEQAWeaAaRkH2eNLNvxDYPuqSH/hdJanPgr4YVgOHU2+WoUoem
         v1I21fteEhUDg==
Message-ID: <06927b58-f5d7-4000-a2ce-ba55c666a0e9@zytor.com>
Date:   Thu, 26 Oct 2023 10:40:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] KVM: VMX: Cleanup VMX basic information defines
 and usages
Content-Language: en-US
From:   Xin Li <xin@zytor.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, weijiang.yang@intel.com
References: <20231026172530.208867-1-xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <20231026172530.208867-1-xin@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/26/2023 10:25 AM, Xin Li (Intel) wrote:
> From: Xin Li <xin3.li@intel.com>
> 
> Define VMX basic information fields with BIT_ULL()/GENMASK_ULL(), and
> replace hardcoded VMX basic numbers with these macros.
> 
> Per Sean's ask, read MSR_IA32_VMX_BASIC into an u64 to get rid of the
> hi/lo crud.
> 
> Tested-by: Shan Kang <shan.kang@intel.com>
> Signed-off-by: Xin Li <xin3.li@intel.com>
> ---
> 
> Changes since v1:
> * Don't add field shift macros unless it's really needed, extra layer
>    of indirect makes it harder to read (Sean Christopherson).
> * Add a static_assert() to ensure that VMX_BASIC_FEATURES_MASK doesn't
>    overlap with VMX_BASIC_RESERVED_BITS (Sean Christopherson).
> * read MSR_IA32_VMX_BASIC into an u64 rather than 2 u32 (Sean
>    Christopherson).
> * Add 2 new functions for extracting fields from VMX basic (Sean
>    Christopherson).
> * Drop the tools header update (Sean Christopherson).
> * Move VMX basic field macros to arch/x86/include/asm/vmx.h.
> ---
>   arch/x86/include/asm/msr-index.h |  9 ---------
>   arch/x86/include/asm/vmx.h       | 16 ++++++++++++++++
>   arch/x86/kvm/vmx/nested.c        | 25 ++++++++++++++++++-------
>   arch/x86/kvm/vmx/vmx.c           | 22 ++++++++++------------
>   4 files changed, 44 insertions(+), 28 deletions(-)

Sigh, forgot to add "--base=HEAD~2".

This is based on commit c076acf10c78c0d7e1aa50670e9cc4c91e8d59b4 of the 
'next' branch in the kvm-x86 tree.

Thanks!
     Xin

