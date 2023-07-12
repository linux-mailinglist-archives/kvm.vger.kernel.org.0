Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F66E750BC3
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 17:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233151AbjGLPF6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 11:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233279AbjGLPFy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 11:05:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E13A91BC6;
        Wed, 12 Jul 2023 08:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=RMZe4T8kBC9ECxrBWJXYNp/hYKxd2kpjlbkqK4iN4h4=; b=OA3FsJQZt+BevImFp3+Qf5NlBA
        2uhd8WEICN/BGyIyOKA8RZv2n7xzjYlOWvbGxVLojOCwCSefbsiEMT6A8E3fs+GRUCLWJKgCXvp9j
        Ov2Q1AcuBthrqSMuBvPU0dGhXSM7teqpsbhXYevQmYC3pkaE27fMCpnpGDjTbTVmFrkWZFb044iVY
        3y+zRDyDZfsdL5OM8Vf4rSKxTGFNgpGrcdObzh3aYdaFqVSj3oSVmlY0vfmz93Jv/xxZP0iweBkma
        +2JSUbUl3DNmrV+Xjs5jNVsMGaSk7wBtanEeOz32fl2Bti7V9X0YO+u1IdB3MjxaV/EuUoOqTos9r
        fjEJbysQ==;
Received: from [2601:1c2:980:9ec0::2764]
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qJbPN-000HnU-2P;
        Wed, 12 Jul 2023 15:05:37 +0000
Message-ID: <d0c763aa-b32c-835b-43b7-43a028ea5473@infradead.org>
Date:   Wed, 12 Jul 2023 08:05:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] SVM: Fix warnings in svm.h
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>, huzhi001@208suo.com
Cc:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <tencent_B97FAD99B25D9BCC5AB9EA89BA04061D7B07@qq.com>
 <e541a2b2fe55ade4277f34fa64953683@208suo.com>
 <20230712135956.GA3100121@hirez.programming.kicks-ass.net>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20230712135956.GA3100121@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/12/23 06:59, Peter Zijlstra wrote:
> On Wed, Jul 12, 2023 at 09:39:24PM +0800, huzhi001@208suo.com wrote:
>> The following checkpatch warnings are removed:
>> WARNING: Prefer __packed over __attribute__((__packed__))
> 
> Can you please stop with these pointless checkpatch things?

We should probably document that checkpatch should usually just be used
on patches and not on entire files.

-- 
~Randy
