Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 863E741CA04
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 18:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345481AbhI2QZ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 12:25:26 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:50671 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233501AbhI2QZZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 12:25:25 -0400
Received: from [192.168.100.1] ([82.142.21.142]) by mrelayeu.kundenserver.de
 (mreue011 [213.165.67.103]) with ESMTPSA (Nemesis) id
 1MZTa2-1mHxLg3qiM-00WXPj; Wed, 29 Sep 2021 18:23:15 +0200
Subject: Re: [PATCH] target/i386: Include 'hw/i386/apic.h' locally
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        QEMU Trivial <qemu-trivial@nongnu.org>, haxm-team@intel.com,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org, Cameron Esfahani <dirty@apple.com>,
        Kamil Rytarowski <kamil@netbsd.org>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Colin Xu <colin.xu@intel.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Wenchao Wang <wenchao.wang@intel.com>
References: <20210902152243.386118-1-f4bug@amsat.org>
 <a4cba848-e668-7cf1-fe93-b5da3a4ac6dc@redhat.com>
 <f3e89488-0d05-657a-34f7-060a7250517d@amsat.org>
 <f9e3c54f-a7cb-a043-f7fd-9d9d0dd61c16@vivier.eu>
 <6fa5f79c-8d3b-9534-26d6-ebe1ba937491@vivier.eu>
 <01ea5ea0-a61c-7bea-e1a6-639e3b9a2988@amsat.org>
From:   Laurent Vivier <laurent@vivier.eu>
Message-ID: <93245807-dfa9-be11-ccda-4601b09b204e@vivier.eu>
Date:   Wed, 29 Sep 2021 18:23:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <01ea5ea0-a61c-7bea-e1a6-639e3b9a2988@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:ujUwILF+IaWrbUmDUK4535pOr0wgpL/NREUKJ//ndHRlP4XxWTT
 V59KEogt101pcbP67gmnRi19v/k8pOWuLXuAxpDAf4T4DDBIkfY3ZaEfjoZIITnKEYrDoju
 1Po+ZcfFaf2GW/S8VAsTY7fMbdKeCxU//J+tdyRUyQzkuEwyl1upmb+v0MLFdj5e3qe5d6X
 jgKkaCCCx8Vc/eUlg5sxA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:F5SE9UbnGXY=:ddTan/dSSXrU2CtCSwZL+U
 P3Steu/BIpv1WE4MlydqOiSIo1YND1ceDwGPKIarokF4ElJQ1o3mj3ODmPQVAuzq39Q36ynG9
 KeqT0qrE3dZeqFjQuoTwiBgMPwagbSpumP6T8JnmQyXxPPl0AD8LKL1PyUkHHtY8+YfJAof1W
 GXUOV41kuanSO5YLlTMAspclfmirke2h3S/aNB152Hq9tAFJI0ufkhygK2Yk4JYatprxmsaQC
 e92aBzx9cON8VCAK9CP5IVWFCzqSluap/NBiB7FebL4CpXtdPG9t2xBgL/vhR4pqCUAbJ9qY2
 Zwf8scmQcafJ6ER+ruBKHU3Aus9aw9gTjVOU+VuZbd/+OxmnKYlD+vB6CZWfuB5gWnY5SIyKe
 RI9TDvw8WO1mLNVargg/cUlyNjulrX9Ri+9D2UQmngM7zLXKKIIUK4bh5x4zacKmy06czqCks
 SfZm1gStvdCjMQA2Fjj1xapOa1gCiL+uQ9pC/q6XrTVaRk6TpLKiQdU7Eq5puFQ8qHY4YUrY0
 YFXeP5WrRCCLm6v+nyfjOq9iifrvvNuK4Z/wPSJ2slMld5c8jhEDee1Lhp9xQBS4lNF55x6bf
 hVt8vlgLU3J3uKSrDpI8a/2D8TzZWzXzk4FXpOBPQKPSQNvZrVi7iAzZOz2xxf59Qa5CxS7/N
 ATn+Fn1h3+g1fz2XESiL3T5aVQylOIW4a4fY9GVDaxOdw8fg4SG/uM0YYEHx2Q9UPK1JFS0VH
 eXRK1qgmsbWsrkTDvhtXn+EzvwOQT/2b8jERZA==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Le 29/09/2021 à 18:06, Philippe Mathieu-Daudé a écrit :
> On 9/29/21 17:16, Laurent Vivier wrote:
>> Le 29/09/2021 à 17:00, Laurent Vivier a écrit :
>>> Le 29/09/2021 à 16:08, Philippe Mathieu-Daudé a écrit :
>>>> On 9/16/21 00:05, Paolo Bonzini wrote:
>>>>> On 02/09/21 17:22, Philippe Mathieu-Daudé wrote:
>>>>>> Instead of including a sysemu-specific header in "cpu.h"
>>>>>> (which is shared with user-mode emulations), include it
>>>>>> locally when required.
>>>>>>
>>>>>> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
>>>>>> ---
>>>>>
>>>>> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
>>>>
>>>> Thank you, Cc'ing qemu-trivial@ :)
>>>>
>>>
>>> Applied to my trivial-patches branch.
>>>
>>
>> We have a problem:
>>
>> .../target/i386/tcg/sysemu/seg_helper.c:145:9: error: implicit declaration of function
>> 'apic_poll_irq' [-Werror=implicit-function-declaration]
>>   145 |         apic_poll_irq(cpu->apic_state);
>>       |         ^~~~~~~~~~~~~
>> .../target/i386/tcg/sysemu/seg_helper.c:145:9: error: nested extern declaration of 'apic_poll_irq'
>> [-Werror=nested-externs]
> 
> Hmm I'll check what changed since I sent that. It was working the day
> Paolo Acked, because have the patch rebased / tested on top of commit
> c99e34e537f ("Merge remote-tracking branch
> 'remotes/vivier2/tags/linux-user-for-6.2-pull-request' into staging").
> 
> I should have rebased/retested today before Cc'ing you, sorry.
> 

On top of c99e34e537f I have the same error...

Thanks,
Laurent
