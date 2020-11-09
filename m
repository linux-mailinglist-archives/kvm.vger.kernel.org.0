Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AECD62AB412
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 10:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729154AbgKIJzs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 04:55:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:58120 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727906AbgKIJzq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 04:55:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D4D67ABCC;
        Mon,  9 Nov 2020 09:55:45 +0000 (UTC)
Subject: Re: [PATCH 1/3] accel: Only include TCG stubs in user-mode only
 builds
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>, kvm@vger.kernel.org
References: <20201109094547.2456385-1-f4bug@amsat.org>
 <20201109094547.2456385-2-f4bug@amsat.org>
From:   Claudio Fontana <cfontana@suse.de>
Message-ID: <e9837717-b010-077e-2d68-0f03300793c4@suse.de>
Date:   Mon, 9 Nov 2020 10:55:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201109094547.2456385-2-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/9/20 10:45 AM, Philippe Mathieu-Daudé wrote:
> We only require TCG stubs in user-mode emulation.
> Do not build stubs restricted to system-mode emulation
> in a user-mode only build.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  accel/meson.build | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/accel/meson.build b/accel/meson.build
> index b26cca227a4..609772f129b 100644
> --- a/accel/meson.build
> +++ b/accel/meson.build
> @@ -1,10 +1,12 @@
>  softmmu_ss.add(files('accel.c'))
>  
> -subdir('qtest')
> -subdir('kvm')
>  subdir('tcg')
> -subdir('xen')
> -subdir('stubs')
> +if have_system
> +  subdir('qtest')
> +  subdir('kvm')
> +  subdir('xen')
> +  subdir('stubs')
> +endif
>  
>  dummy_ss = ss.source_set()
>  dummy_ss.add(files(
> 

Ciao Philippe,

I thought that the pattern used by Paolo was, recurse always, and put the check inside the recursed dir meson.build .
Paolo did you indeed intend meson use this way?

Ciao,

Claudio
