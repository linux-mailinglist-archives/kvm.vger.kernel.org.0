Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CAF041CAA5
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 18:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344155AbhI2QyG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 12:54:06 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:43451 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245180AbhI2QyF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 12:54:05 -0400
Received: from [192.168.100.1] ([82.142.21.142]) by mrelayeu.kundenserver.de
 (mreue010 [213.165.67.103]) with ESMTPSA (Nemesis) id
 1MUGyh-1mNkrM3Col-00RImz; Wed, 29 Sep 2021 18:51:59 +0200
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-trivial@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Cameron Esfahani <dirty@apple.com>,
        Kamil Rytarowski <kamil@netbsd.org>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Colin Xu <colin.xu@intel.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, haxm-team@intel.com,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Wenchao Wang <wenchao.wang@intel.com>
References: <20210929163124.2523413-1-f4bug@amsat.org>
From:   Laurent Vivier <laurent@vivier.eu>
Subject: Re: [PATCH v3] target/i386: Include 'hw/i386/apic.h' locally
Message-ID: <bee85404-7092-5565-aa77-165b35db10ee@vivier.eu>
Date:   Wed, 29 Sep 2021 18:51:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210929163124.2523413-1-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:VHCygShHmm5lkuRdmYl0n8jXTGLVo014Pc6rEYQlAMZPMqqY3A8
 26nrU38g9+9fxjB2h+yqV79i74Sk7GkpqSk5+kruGgXSZVAzLWMb81pRgjyiUYy+/OPIiEZ
 +MlHs+BlegEgNtG8sYMnL+pz1A+xLrG0ZuiL3J++cq1z0YXkPUQxEmpYKNCtEEAZu5bDmlL
 ilo5QMyHAZlSjjuz3q2oQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:/ngWqlchEnA=:Smohn14fEXftSRde+V6C2H
 ih9WY/RaxqKquMI9YZp4DXsbRpzTw9URCmMxWDhSXcEOFNN+YKwtprcTmFOOsAUferjpdyYja
 nBGHmQHibh/EA69RU/NO7JmyCzEUvpOWSFHmaA6pp/+nBiXjuQK/x9QIcM129R7Z/BH2MGdRz
 ptP8qHLlx3RWxa5mR9rtbKf2THxMj1Db1UrdYv5Eg92/mmv0PrkepQfNzdUcY89Sgpz1yzgLZ
 DDot7EueHgEFK1H6vKPs7pieWevf7p/K7NZPiLqQcr3pIXf8O0GQmNlsUVsF4dEyAkn8zJIdk
 DoeXiwVItKVQdAVDhKehf1Xp1iEKJLZv7U6wQ/EvMAkpHas1uqgEdE7K4KB5TqlYntGvJzVDF
 Tt2WrVtL75N5/DtW5A84NDUjEDPTfQeHRr44Dj97Zji7dQP6r8H4HACdQWZy+Cv+yJ+Op7F/Q
 RclOEOXmYtvj2euxIl1xFDXPAT4xou96/bcPlb1s6pRBWIp9cJvqKgDFwK7M4wXNDzBQ8ZeEi
 XYOFb4VfbTCARDrAlv+zq9i1CmKja9U8f9XxYLFvZ6LSPuYGQNh/BgUE378gMQoJYFjqCBeym
 JO6aTBNrDwdiaqOuAsAxGCY/Ccq47xkMvLqcVC0boEDlSweTUZK8zsOtPwNgVZUf2tO+U0/vQ
 4t8L9Age5g7EW3J6wiBf8HAkCZQNQnI1o6tyT1ZjC4vUZV2VJcWnNcCH0C5uC1fS5Jsg/bMJX
 PILFbj6TU+1cGk7oCZIq5MPqigNNh7NnFxirEA==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Le 29/09/2021 à 18:31, Philippe Mathieu-Daudé a écrit :
> Instead of including a sysemu-specific header in "cpu.h"
> (which is shared with user-mode emulations), include it
> locally when required.
> 
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/i386/cpu.h                    | 4 ----
>  hw/i386/kvmvapic.c                   | 1 +
>  hw/i386/x86.c                        | 1 +
>  target/i386/cpu-dump.c               | 1 +
>  target/i386/cpu-sysemu.c             | 1 +
>  target/i386/cpu.c                    | 1 +
>  target/i386/gdbstub.c                | 4 ++++
>  target/i386/hax/hax-all.c            | 1 +
>  target/i386/helper.c                 | 1 +
>  target/i386/hvf/hvf.c                | 1 +
>  target/i386/hvf/x86_emu.c            | 1 +
>  target/i386/nvmm/nvmm-all.c          | 1 +
>  target/i386/tcg/sysemu/misc_helper.c | 1 +
>  target/i386/tcg/sysemu/seg_helper.c  | 1 +
>  target/i386/whpx/whpx-all.c          | 1 +
>  15 files changed, 17 insertions(+), 4 deletions(-)
> 
...
> diff --git a/target/i386/cpu-dump.c b/target/i386/cpu-dump.c
> index 02b635a52cf..0158fd2bf28 100644
> --- a/target/i386/cpu-dump.c
> +++ b/target/i386/cpu-dump.c
> @@ -22,6 +22,7 @@
>  #include "qemu/qemu-print.h"
>  #ifndef CONFIG_USER_ONLY
>  #include "hw/i386/apic_internal.h"
> +#include "hw/i386/apic.h"
>  #endif
>  
>  /***********************************************************/

Why do you add this part compared to v1?

...

> diff --git a/target/i386/hvf/hvf.c b/target/i386/hvf/hvf.c
> index 4ba6e82fab3..50058a24f2a 100644
> --- a/target/i386/hvf/hvf.c
> +++ b/target/i386/hvf/hvf.c
> @@ -70,6 +70,7 @@
>  #include <sys/sysctl.h>
>  
>  #include "hw/i386/apic_internal.h"
> +#include "hw/i386/apic.h"
>  #include "qemu/main-loop.h"
>  #include "qemu/accel.h"
>  #include "target/i386/cpu.h"

Same question

Thanks,
Laurent
