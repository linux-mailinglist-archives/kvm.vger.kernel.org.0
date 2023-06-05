Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0935E722D4B
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 19:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235236AbjFERHB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 13:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232400AbjFERG7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 13:06:59 -0400
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE41CE47;
        Mon,  5 Jun 2023 10:06:38 -0700 (PDT)
Received: from [172.27.2.41] ([73.231.166.163])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 355H6G5H3948784
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Mon, 5 Jun 2023 10:06:16 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 355H6G5H3948784
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2023051001; t=1685984777;
        bh=vGhVxD5zoDwQ5tRTjjgYq0ku41yGbDZA/+RRBNh+ffM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ypvr/F6YHfGHPoI0eDs0jXHWLjqZroJ+qx8YcOpCij/ZFphzx6rG0GKg10naaN6dO
         Gtg0iVoC7VbeNwuBviYqrklg8/snNhOzQ4YWPIPq4qNiUda344ImQ6AXoBcZa/oRUe
         jGtMa/k8zEXhCqzTyL6T6f0NxKSrR4tYpGAmx4s4EXwntG5DOjkxgVqda0DOxT3awK
         6KUvPjUqVIdSau5ejdPqLFpcEaaB2MWIXpveGMqGk+F2NwH3qZjsro/s4YNqq1Av6l
         qiuiDrR5p5olSy3mB5012Yy95T3j9PtgXTZrcpTVfMXXwGZWJVtyoBrXtZbWnWTCBz
         qcfTsn6+6B+Bw==
Message-ID: <e45b8bac-8df8-acf3-aa48-f8a51594ca13@zytor.com>
Date:   Mon, 5 Jun 2023 10:06:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v8 09/33] x86/cpu: add X86_CR4_FRED macro
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>, Xin Li <xin3.li@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        peterz@infradead.org, andrew.cooper3@citrix.com, seanjc@google.com,
        pbonzini@redhat.com, ravi.v.shankar@intel.com,
        jiangshanlai@gmail.com, shan.kang@intel.com
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-10-xin3.li@intel.com> <87r0qq6rtm.ffs@tglx>
From:   "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <87r0qq6rtm.ffs@tglx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/5/23 05:01, Thomas Gleixner wrote:
> On Mon, Apr 10 2023 at 01:14, Xin Li wrote:
> 
>> From: "H. Peter Anvin (Intel)" <hpa@zytor.com>
>>
>> Add X86_CR4_FRED macro for the FRED bit in %cr4. This bit should be a
> 
> s/should/must/ no?
> 

Technically no bit "must" be set in the fixed bit variable, but it would 
obviously be insane not to. But it makes it a "should", both in 
dictionary and RFC 2119 definitions.

Incidentally, I strongly advice everyone to use the RFC 2119 definitions 
of technical requirement terms when possible.

	-hpa
