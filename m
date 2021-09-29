Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E5441C7B0
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 17:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344942AbhI2PCj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 11:02:39 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:58999 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344940AbhI2PCj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 11:02:39 -0400
Received: from [192.168.100.1] ([82.142.21.142]) by mrelayeu.kundenserver.de
 (mreue009 [213.165.67.103]) with ESMTPSA (Nemesis) id
 1MK3eI-1mFZ3n3IPG-00LUDT; Wed, 29 Sep 2021 17:00:33 +0200
Subject: Re: [PATCH] target/i386: Include 'hw/i386/apic.h' locally
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org,
        QEMU Trivial <qemu-trivial@nongnu.org>
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Kamil Rytarowski <kamil@netbsd.org>,
        Cameron Esfahani <dirty@apple.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Colin Xu <colin.xu@intel.com>, haxm-team@intel.com,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Wenchao Wang <wenchao.wang@intel.com>
References: <20210902152243.386118-1-f4bug@amsat.org>
 <a4cba848-e668-7cf1-fe93-b5da3a4ac6dc@redhat.com>
 <f3e89488-0d05-657a-34f7-060a7250517d@amsat.org>
From:   Laurent Vivier <laurent@vivier.eu>
Message-ID: <f9e3c54f-a7cb-a043-f7fd-9d9d0dd61c16@vivier.eu>
Date:   Wed, 29 Sep 2021 17:00:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <f3e89488-0d05-657a-34f7-060a7250517d@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:MNkton+xaTjRDiQ0TFtTeSBNISyX8iL9UuDuvfrqEqu2FvWULwI
 mrmubcHKuVh7dz9Am3j9Mn1Hcc+TBY6vbJIoAJTDJJxt93ESfGmYb/Q+DsAbjJNfB2506WB
 UGj5U6xCT5VjX7lhrwnrHTlXsdxbYYDY1JPa9VsK4NeqQdohCaxTRvMbA0dCybt0tRYvCdt
 ZqH6qGyEWAZm6lZlqMY2g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:m4bGmsUd0yY=:UZEE5/JKQR4ub4X2Nukcnq
 5cuLegB29KY0QOVdEt+8viIgBI5oLSi99MLHWAMVmADAAuobGKzoLk6+VKtUIKnBmwCVufe7c
 GqWuwd73ZdniOhq43kMa08b3UP1knxZzpDg5Cg/yrBq0mGdkxtnGuZDMM50Myjw/3rNyu609N
 5UgHoELUoLSHbjEW+jIDmvQ9kMleL8YtyqVuQJqwtpk8yMYVRmFiSudStVRc12IBxmwBYGVAP
 kHmonVXu8RxM/81i4NAlIBcSIgC5fhvkA+zQtcydwBlG94eyToiwJseRfHYAObyoBOS2c4PRg
 iYo90MpoYYrYXeoOHy8CuWEKQ0yoYZBmMG2PuSoxfkj3gblduakQ+SS8dSpYD0zJmCX/tzrPt
 CPO7Zi4x9ourIXrZR2xOy056sy8kIjKYBjZcMqS9gN9fh77vo5kc20cHHB9BPff91UjEH2gP/
 36F7Shb1RQRoYN8aI0xaxC4172pnctE0olMJiQyKmg/xc9IeVUIF9HATEdp+/0qCg+nDf65VR
 QeZoe3nTXDYs9AaLMnmcaVyyw/yKQuWSsFX9Gx9uFljRAXAYpg/VuVEpCv4MNqz7vV8iuufnC
 MtMkupDjCYw7th+4W07yulKfFFpTHp4S/c4/Luss6KQn3O4Bfv6OJRc+YLfpmWqCVxSMLbHXY
 gNmXhDpzw1E26Icui0VCQnO8b/CUsJixmkTecrFTpJDzA8evNfx2sSRh8rQXmPfYxKEq5DF6d
 jnlqr5jZBlHOC0z4TXivwF2g3EdgMYLJwNKnYw==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Le 29/09/2021 à 16:08, Philippe Mathieu-Daudé a écrit :
> On 9/16/21 00:05, Paolo Bonzini wrote:
>> On 02/09/21 17:22, Philippe Mathieu-Daudé wrote:
>>> Instead of including a sysemu-specific header in "cpu.h"
>>> (which is shared with user-mode emulations), include it
>>> locally when required.
>>>
>>> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
>>> ---
>>
>> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> Thank you, Cc'ing qemu-trivial@ :)
> 

Applied to my trivial-patches branch.

Thanks,
Laurent
