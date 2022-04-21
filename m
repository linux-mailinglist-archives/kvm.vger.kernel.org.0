Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 531B9509D21
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 12:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388093AbiDUKK0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 06:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354947AbiDUKKY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 06:10:24 -0400
X-Greylist: delayed 411 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 21 Apr 2022 03:07:35 PDT
Received: from mail.mimoja.de (mail.mimoja.de [213.160.72.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1BE5B25E8D;
        Thu, 21 Apr 2022 03:07:35 -0700 (PDT)
Received: from [IPV6:2003:cf:571f:200:d4c7:7b5a:7538:c333] (p200300cf571f0200d4c77b5a7538c333.dip0.t-ipconnect.de [IPv6:2003:cf:571f:200:d4c7:7b5a:7538:c333])
        by mail.mimoja.de (Postfix) with ESMTPSA id 0D2CA2223B;
        Thu, 21 Apr 2022 12:00:41 +0200 (CEST)
Message-ID: <e3ef8236-344d-e840-575c-a5fb1450a13b@mimoja.de>
Date:   Thu, 21 Apr 2022 12:00:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v3 0/9] Parallel CPU bringup for x86_64
Content-Language: en-US
To:     Paul Menzel <pmenzel@molgen.mpg.de>,
        David Woodhouse <dwmw2@infradead.org>, thomas.lendacky@amd.com,
        mimoja@mimoja.de
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, hewenliang4@huawei.com, hushiyuan@huawei.com,
        luolongjun@huawei.com, hejingxian@huawei.com
References: <20211215145633.5238-1-dwmw2@infradead.org>
 <9a47b5ec-f2d1-94d9-3a48-9b326c88cfcb@molgen.mpg.de>
 <ab28d2ce-4a9c-387d-9eda-558045a0c35b@molgen.mpg.de>
 <3bfacf45d2d0f3dfa3789ff5a2dcb46744aacff7.camel@infradead.org>
 <ea433e41-0038-554d-3348-70aa98aff9e1@molgen.mpg.de>
 <efbe0d3d92e6c279e3a6d7a4191ca7470bc4beec.camel@infradead.org>
 <74d2302f-88fc-c75c-6d2d-4aece1a515bb@molgen.mpg.de>
From:   Mimoja <mimoja@mimoja.de>
In-Reply-To: <74d2302f-88fc-c75c-6d2d-4aece1a515bb@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear Paul,

> Sorry for replying so late. I saw your v4 patches, and tried commit 
> 5e3524d21d2a () from your branch `parallel-5.17-part1`. Unfortunately, 
> the boot problem still persists on an AMD Ryzen 3 2200 g system, I 
> tested with. Please tell, where I should report these results too 
> (here or posted v4 patches).

We have confirmed the issue on multiple AMD CPUs from multiple 
generations, leading to the guess that only Zen and Zen+ CPU seem 
affected with Zen3 and Zen2 (only tested ulv) working fine. Tho we 
struggled to get any output as the failing machines just go silent.

Not working:

Ryzen 5 Pro 2500u and 7 2700U
Ryzen 3 2300G

while e.g.

Ryzen 7 Pro 4750U
Ryzen 9 5950X

both work fine. We will continue to investigate the issue but are 
currently a bit pulled into other topics.

Thomas, could please maybe help us identify which CPUs and MC-Versions 
are worth looking at? David suggested you might have a good overview here.


Best regards

Johanna "Mimoja"

