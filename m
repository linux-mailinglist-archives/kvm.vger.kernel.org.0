Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF97696AE2
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 18:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjBNRK5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 12:10:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232234AbjBNRKy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 12:10:54 -0500
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C207FCA26;
        Tue, 14 Feb 2023 09:10:06 -0800 (PST)
Received: from c-24-17-218-140.hsd1.wa.comcast.net ([24.17.218.140] helo=srivatsab3MD6R.vmware.com)
        by outgoing2021.csail.mit.edu with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <srivatsa@csail.mit.edu>)
        id 1pRyod-003ROd-5s;
        Tue, 14 Feb 2023 12:10:03 -0500
Subject: Re: [PATCH] x86/hotplug: Remove incorrect comment about
 mwait_play_dead()
To:     tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        peterz@infradead.org, hpa@zytor.com
Cc:     bp@alien8.de, dave.hansen@linux.intel.com,
        rafael.j.wysocki@intel.com, paulmck@kernel.org, jgross@suse.com,
        seanjc@google.com, thomas.lendacky@amd.com,
        linux-kernel@vger.kernel.org, imammedo@redhat.com,
        amakhalov@vmware.com, ganb@vmware.com, ankitja@vmware.com,
        bordoloih@vmware.com, keerthanak@vmware.com, blamoreaux@vmware.com,
        namit@vmware.com, wyes.karny@amd.com, lewis.carroll@amd.com,
        pv-drivers@vmware.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org
References: <20230128003751.141317-1-srivatsa@csail.mit.edu>
From:   "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
Message-ID: <e6792ea0-d210-a31d-b7da-8525e1315505@csail.mit.edu>
Date:   Tue, 14 Feb 2023 09:09:58 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20230128003751.141317-1-srivatsa@csail.mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi,

On 1/27/23 4:37 PM, Srivatsa S. Bhat wrote:
> From: "Srivatsa S. Bhat (VMware)" <srivatsa@csail.mit.edu>
> 
> The comment that says mwait_play_dead() returns only on failure is a
> bit misleading because mwait_play_dead() could actually return for
> valid reasons (such as mwait not being supported by the platform) that
> do not indicate a failure of the CPU offline operation. So, remove the
> comment.
> 
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>


Gentle ping for review. Thank you!

Regards,
Srivatsa

> ---
>  arch/x86/kernel/smpboot.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 55cad72715d9..9013bb28255a 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -1833,7 +1833,7 @@ void native_play_dead(void)
>  	play_dead_common();
>  	tboot_shutdown(TB_SHUTDOWN_WFS);
>  
> -	mwait_play_dead();	/* Only returns on failure */
> +	mwait_play_dead();
>  	if (cpuidle_play_dead())
>  		hlt_play_dead();
>  }
> 
