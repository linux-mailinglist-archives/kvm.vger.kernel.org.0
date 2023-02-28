Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD8566A5668
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 11:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbjB1KOB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 05:14:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbjB1KN4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 05:13:56 -0500
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2CAEC678;
        Tue, 28 Feb 2023 02:13:54 -0800 (PST)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 51CF361CC40F9;
        Tue, 28 Feb 2023 11:13:51 +0100 (CET)
Message-ID: <8b0cc6fa-8d40-7401-b8f9-559b5db3e8c9@molgen.mpg.de>
Date:   Tue, 28 Feb 2023 11:13:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v12 00/11] Parallel CPU bringup for x86_64
Content-Language: en-US
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc:     Usama Arif <usama.arif@bytedance.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, brgerst@gmail.com,
        dave.hansen@linux.intel.com, fam.zheng@bytedance.com,
        hewenliang4@huawei.com, "H. Peter Anvin" <hpa@zytor.com>,
        kim.phillips@amd.com, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, liangma@liangbit.com,
        mimoja@mimoja.de, oleksandr@natalenko.name,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, piotrgorski@cachyos.org,
        punit.agrawal@bytedance.com, rcu@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        simon.evans@bytedance.com, Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>, x86@kernel.org
References: <3ca3b60e-47a2-640a-cad3-e3e110d3aaf7@igalia.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <3ca3b60e-47a2-640a-cad3-e3e110d3aaf7@igalia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear Guilherme,


Am 27.02.23 um 22:39 schrieb Guilherme G. Piccoli:

> I've tested it on Steam Deck (with and without the "no_parallel_bringup"
> parameter), it works fine - also tested S3/deep sleep-resume cycle.
> 
> Feel free to add (to the series):
> Tested-by: Guilherme G. Piccoli <gpiccoli@igalia.com>

Thank you for testing the series. It’d be great if you could share the 
timing differences.

[…]


Kind regards,

Paul
