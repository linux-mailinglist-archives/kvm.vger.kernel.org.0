Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9417B722D67
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 19:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234244AbjFERMx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 13:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbjFERMw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 13:12:52 -0400
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D85491;
        Mon,  5 Jun 2023 10:12:51 -0700 (PDT)
Received: from [172.27.2.41] ([73.231.166.163])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 355HCVZ43949912
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Mon, 5 Jun 2023 10:12:32 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 355HCVZ43949912
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2023051001; t=1685985153;
        bh=Mvs8SbMngXjEjPAUy2IQJojR86qTnbXoVHRbadGN9mA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=IoPSD7KcV4kuLCawffE3uhoHZ9hqwfHj8sreNm5AS9jXfnOJHRdAqyU7nUrFVEodh
         lkrE39Htgyi9D4DKhPJF5gifsVKfcq5rgLL2e6r7SYzSK5TnhHDYpmStGWxmLBAhLV
         hzV+/z7zrFeh6felZ8+12/YSY7oPLhS+ZclGm1dxQXdBIN8LY9o4Bksnoa0aYX48l/
         TYUcwXg4q/0A3ScIdj5jH1GfISbYKuv1ec+Qh2kcVtnk7IlQ7XlXgS5NQKTw4QNVR0
         Qbf3i9x/VtBM4G7Vr0zpTrav9MuXxO5AtBMTSn8MD6qinuwshIykbiKDlrOdSWW2oE
         sGKHXtg3dsbHg==
Message-ID: <303d5b3c-e33b-c6ef-544a-32d6497f891e@zytor.com>
Date:   Mon, 5 Jun 2023 10:12:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v8 02/33] x86/fred: make unions for the cs and ss fields
 in struct pt_regs
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>, Xin Li <xin3.li@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        peterz@infradead.org, andrew.cooper3@citrix.com, seanjc@google.com,
        pbonzini@redhat.com, ravi.v.shankar@intel.com,
        jiangshanlai@gmail.com, shan.kang@intel.com
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-3-xin3.li@intel.com> <87o7lu6rjf.ffs@tglx>
From:   "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <87o7lu6rjf.ffs@tglx>
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

> 
> This does not match section
> 
>      5.2.1 Saving Information on the Regular Stack?
> 
> of version 4 and later of the specification.
> 

Yes, this is correct. This patchset was posted in April, and once we got 
some very late requests for changes I asked Xin to hold off any further 
iterations until the spec had restabilized.

	-hpa
