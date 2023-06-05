Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EAB5722DA7
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 19:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbjFERaR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 13:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235144AbjFER35 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 13:29:57 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E2190;
        Mon,  5 Jun 2023 10:29:56 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1685986194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u/U7ey0ax4H7vk1q0YaG9p2muTkse993fhrnpaApCl4=;
        b=3wfJ5XHDm1wn+owjjClyT4/JNsgSheCPTcDaQsd9uSwy7kx0BoDqJv6iOpT5Y5AiAj3yBe
        0XKS6Icnh+khsB6IzALmBcvlzWEju1BWc96oNOGewl2mMk07oRKtLs3PLqzeiT+dwMYmy6
        WQlfg7qu6Y/Oef4pprra9ruFSXjhOjYruff+AVV7+Uoe038Wfa3gNmheW28dIQxMrHhZtQ
        j8jOyVL0NMB2SFfgNQDOI9Y8lqYzNwWs6CpyAP2B6sYsNN7QkkuaKiA55cy4YyJ6ylStHj
        dzabDFi3/rSl195ovxfxUW06wI75hQcWxrp38r62OvEuAyAgrfousx/lym6dGg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1685986194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u/U7ey0ax4H7vk1q0YaG9p2muTkse993fhrnpaApCl4=;
        b=qYsA8plkT2ISgXnyAWuOQDM0MGAe2Ofwc8ko0HtNxam80ocmyazmBZ5uL5xKdOyAOi8Isp
        tCEImKRb8aUt6aCQ==
To:     "H. Peter Anvin" <hpa@zytor.com>, Xin Li <xin3.li@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        peterz@infradead.org, andrew.cooper3@citrix.com, seanjc@google.com,
        pbonzini@redhat.com, ravi.v.shankar@intel.com,
        jiangshanlai@gmail.com, shan.kang@intel.com
Subject: Re: [PATCH v8 02/33] x86/fred: make unions for the cs and ss fields
 in struct pt_regs
In-Reply-To: <303d5b3c-e33b-c6ef-544a-32d6497f891e@zytor.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-3-xin3.li@intel.com> <87o7lu6rjf.ffs@tglx>
 <303d5b3c-e33b-c6ef-544a-32d6497f891e@zytor.com>
Date:   Mon, 05 Jun 2023 19:29:54 +0200
Message-ID: <8735356cml.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05 2023 at 10:12, H. Peter Anvin wrote:
>> 
>> This does not match section
>> 
>>      5.2.1 Saving Information on the Regular Stack?
>> 
>> of version 4 and later of the specification.
>> 
>
> Yes, this is correct. This patchset was posted in April, and once we got 
> some very late requests for changes I asked Xin to hold off any further 
> iterations until the spec had restabilized.

I assumed that, but I stumbled over it when trying to review :)
