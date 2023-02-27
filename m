Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40D666A4D64
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 22:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbjB0VkD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 16:40:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjB0VkB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 16:40:01 -0500
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DB2E166E3;
        Mon, 27 Feb 2023 13:40:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:Subject:From:Cc:To:
        In-Reply-To:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hzEROybYxR9f0YfPj15fjs4bdgcQk2VX+RCv2jenSfg=; b=sLkIjWF8nsb8kUnXIqsMF7algc
        0ItvipbvBhuEropN1DtR9dWJrPfZyk60a3qFUhRPsrBBvgAuk5PupSEKWrwPboLEusbQyk2r+Y+Wk
        Kwr4wNA/IUcZ2cDSEYRL4diOeRgOkFi3F5ZR5MChtPnx5ivbGOckNjJL/8AGXqwlcRJPoDAfqNIH6
        lvaUuIwQFTNGg2t9g1WgMHAxk4hP4C18FM9ckp5WLRp0sXxElSLWD150rRe1+Ulf8C2L+tk9b6Toe
        yUY+tzAfyyYsvDHplgY4e3YfU9rIoqOOgKSJZoNfQRj240ZRchZ42Syd6KLEUiXBcXVTd6FaOP90C
        i2C4g6jw==;
Received: from [152.254.196.162] (helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1pWlDI-00H8W2-Jz; Mon, 27 Feb 2023 22:39:16 +0100
Message-ID: <3ca3b60e-47a2-640a-cad3-e3e110d3aaf7@igalia.com>
Date:   Mon, 27 Feb 2023 18:39:05 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
In-Reply-To: <20230226110802.103134-1-usama.arif@bytedance.com>
To:     usama.arif@bytedance.com, David Woodhouse <dwmw2@infradead.org>
Cc:     Arjan van de Ven <arjan@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, brgerst@gmail.com,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        fam.zheng@bytedance.com, hewenliang4@huawei.com,
        "H. Peter Anvin" <hpa@zytor.com>, kim.phillips@amd.com,
        kvm@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, liangma@liangbit.com,
        mimoja@mimoja.de, oleksandr@natalenko.name,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, piotrgorski@cachyos.org,
        pmenzel@molgen.mpg.de, punit.agrawal@bytedance.com,
        "rcu@vger.kernel.org" <rcu@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        simon.evans@bytedance.com, Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        "x86@kernel.org" <x86@kernel.org>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Subject: Re: [PATCH v12 00/11] Parallel CPU bringup for x86_64
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Usama and David, thanks for the great series!

I've tested it on Steam Deck (with and without the "no_parallel_bringup"
parameter), it works fine - also tested S3/deep sleep-resume cycle.

Feel free to add (to the series):
Tested-by: Guilherme G. Piccoli <gpiccoli@igalia.com>

Also, just taking the opportunity since I'm already replying here: on
patch 09, found two typos:

s/correect/correct (commit message)
s/brinugp/bring-up (kernel-parameters.txt)

Cheers,


Guilherme
