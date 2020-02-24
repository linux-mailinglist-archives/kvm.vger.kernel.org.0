Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0B8216B0F7
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 21:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbgBXU13 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 15:27:29 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:42582 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727267AbgBXU13 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 15:27:29 -0500
X-Greylist: delayed 1021 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Feb 2020 15:27:28 EST
Received: from MUA
        by vps-vb.mhejs.net with esmtps (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92.3)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1j6K3b-0001SI-W7; Mon, 24 Feb 2020 21:10:24 +0100
Subject: Re: [PATCH] cpuidle-haltpoll: allow force loading on hosts without
 the REALTIME hint
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
References: <20200221174331.1480468-1-mail@maciej.szmigiero.name>
Autocrypt: addr=mail@maciej.szmigiero.name; prefer-encrypt=mutual; keydata=
 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 Iw==
Message-ID: <114f7b8d-6f88-222a-d1fa-abcfc0e6a1f2@maciej.szmigiero.name>
Date:   Mon, 24 Feb 2020 21:10:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200221174331.1480468-1-mail@maciej.szmigiero.name>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

(CC'ing also Marcelo as the cpuidle-haltpoll driver author and the KVM ML).

On 21.02.2020 18:43, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> Before commit 1328edca4a14 ("cpuidle-haltpoll: Enable kvm guest polling
> when dedicated physical CPUs are available") the cpuidle-haltpoll driver
> could also be used in scenarios when the host does not advertise the
> KVM_HINTS_REALTIME hint.
> 
> While the behavior introduced by the aforementioned commit makes sense as
> the default there are cases where the old behavior is desired, for example,
> when other kernel changes triggered by presence by this hint are unwanted,
> for some workloads where the latency benefit from polling overweights the
> loss from idle CPU capacity that otherwise would be available, or just when
> running under older Qemu versions that lack this hint.
> 
> Let's provide a typical "force" module parameter that allows restoring the
> old behavior.
> 
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> ---
>  drivers/cpuidle/cpuidle-haltpoll.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/cpuidle/cpuidle-haltpoll.c b/drivers/cpuidle/cpuidle-haltpoll.c
> index b0ce9bc78113..07e5b36076bb 100644
> --- a/drivers/cpuidle/cpuidle-haltpoll.c
> +++ b/drivers/cpuidle/cpuidle-haltpoll.c
> @@ -18,6 +18,11 @@
>  #include <linux/kvm_para.h>
>  #include <linux/cpuidle_haltpoll.h>
>  
> +static bool force __read_mostly;
> +module_param(force, bool, 0444);
> +MODULE_PARM_DESC(force,
> +		 "Load even if the host does not provide the REALTIME hint");
> +
>  static struct cpuidle_device __percpu *haltpoll_cpuidle_devices;
>  static enum cpuhp_state haltpoll_hp_state;
>  
> @@ -90,6 +95,11 @@ static void haltpoll_uninit(void)
>  	haltpoll_cpuidle_devices = NULL;
>  }
>  
> +static bool haltpool_want(void)
> +{
> +	return kvm_para_has_hint(KVM_HINTS_REALTIME) || force;
> +}
> +
>  static int __init haltpoll_init(void)
>  {
>  	int ret;
> @@ -102,7 +112,7 @@ static int __init haltpoll_init(void)
>  	cpuidle_poll_state_init(drv);
>  
>  	if (!kvm_para_available() ||
> -		!kvm_para_has_hint(KVM_HINTS_REALTIME))
> +	    !haltpool_want())
>  		return -ENODEV;
>  
>  	ret = cpuidle_register_driver(drv);
> 
