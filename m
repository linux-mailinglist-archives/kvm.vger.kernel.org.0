Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C130741C820
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 17:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345012AbhI2PS7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 11:18:59 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:38943 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345098AbhI2PS6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 11:18:58 -0400
Received: from [192.168.100.1] ([82.142.21.142]) by mrelayeu.kundenserver.de
 (mreue012 [213.165.67.103]) with ESMTPSA (Nemesis) id
 1MZAvp-1mInOp42Mr-00V5qd; Wed, 29 Sep 2021 17:16:55 +0200
Subject: Re: [PATCH] target/i386: Include 'hw/i386/apic.h' locally
From:   Laurent Vivier <laurent@vivier.eu>
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Cameron Esfahani <dirty@apple.com>,
        Kamil Rytarowski <kamil@netbsd.org>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Colin Xu <colin.xu@intel.com>, haxm-team@intel.com,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Wenchao Wang <wenchao.wang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        QEMU Trivial <qemu-trivial@nongnu.org>, qemu-devel@nongnu.org
References: <20210902152243.386118-1-f4bug@amsat.org>
 <a4cba848-e668-7cf1-fe93-b5da3a4ac6dc@redhat.com>
 <f3e89488-0d05-657a-34f7-060a7250517d@amsat.org>
 <f9e3c54f-a7cb-a043-f7fd-9d9d0dd61c16@vivier.eu>
Message-ID: <6fa5f79c-8d3b-9534-26d6-ebe1ba937491@vivier.eu>
Date:   Wed, 29 Sep 2021 17:16:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <f9e3c54f-a7cb-a043-f7fd-9d9d0dd61c16@vivier.eu>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:gtnsvCqwUKzGHyV6y4weKFK8exTuhWuX2g6bjpWcuUwurd4lk6e
 PrV2g4Hf3i/XKW2ZWnRCLjAgqfFr81rf9/iv64/Uo8FV7AIQDe12uyOkV8/ViMhhPwm+7Sq
 41o25sQGF5OIQunSB9ySomY4PxOc8urm2ME1wTfc67m6Yi76Rk6rajSzUiiRTt7tE79C3av
 yRWPTeDQ03OsoPaZPeuVw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:kYB5Btne//E=:KUK6OkqEiUTBX1DphE7lRt
 xaAhUqj6Nvq3CDpF5HPiAUb2XySDNY4YsEuw5b1jAC0qNThTDFaP9JspZGDzCkuvl6YMsuRGS
 xPXLiBJmEbw21RadCmfnACxF/pbV1gqZmQiaVMeckSi3a09GDDHA+/Ot+LG6oZVvTYy7LMJjc
 vdu/PLxKStCcREi7TNP/NCFW3ZfeypO+rRh4RqOJKlgirXbm/xPNMq9JOUV2kyR8FI2uyYlmE
 rrrLUSKAJbiw4EmCBFljELMwPcsbThPAdZRHtQNDx+MVxIESAQT5sAvSFHaPjOAGmLuZosi3c
 V9CnHtZ/7EHxTUE+dPchQz8oAG3VU8qk5QFeVq6KPl2SEDtHr3GBqOK7Q5M+DnvmFX7oepy6G
 wIIOuo++Oso2uwMnAGocS4RSskUQFw7hxUN0lQEUyjoKeivW8mdoEuXOxV1JLXulDYIG//ecG
 nVcU92X/zmCHwVpvKydMiVfJ+Ugpluw6Bj4Wtaxg6GskdRXJ7P7yLeAE/s7vngXJ2b8LARr/q
 xNTPLC6T+oQColtNZrrzLXGm28mbZaLPmY5A69IK1lD0TLvNddXxneA05bFlU5sExHH1u9TMY
 rnzh29SICO6JHY+Ofr2LjCdNCNB9p8iCb3/jsxwpstZC0LSftQ8FSK5dZJ/TwkcoLw9W2711B
 EqUm7ntmTviN3fWORz0o8eHVpjtVq9VlgsSvDIGmEP1LgptMpJXGpePO5EsDayQNcw+clTzpA
 jhQ8S05rZ8EcxdFfktNc5k7xIOO0BYUTA4w8hg==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Le 29/09/2021 à 17:00, Laurent Vivier a écrit :
> Le 29/09/2021 à 16:08, Philippe Mathieu-Daudé a écrit :
>> On 9/16/21 00:05, Paolo Bonzini wrote:
>>> On 02/09/21 17:22, Philippe Mathieu-Daudé wrote:
>>>> Instead of including a sysemu-specific header in "cpu.h"
>>>> (which is shared with user-mode emulations), include it
>>>> locally when required.
>>>>
>>>> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
>>>> ---
>>>
>>> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
>>
>> Thank you, Cc'ing qemu-trivial@ :)
>>
> 
> Applied to my trivial-patches branch.
> 

We have a problem:

.../target/i386/tcg/sysemu/seg_helper.c:145:9: error: implicit declaration of function
'apic_poll_irq' [-Werror=implicit-function-declaration]
  145 |         apic_poll_irq(cpu->apic_state);
      |         ^~~~~~~~~~~~~
.../target/i386/tcg/sysemu/seg_helper.c:145:9: error: nested extern declaration of 'apic_poll_irq'
[-Werror=nested-externs]


