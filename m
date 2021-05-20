Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 610B138ADBE
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 14:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241972AbhETMLz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 08:11:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55601 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242247AbhETMLP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 May 2021 08:11:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621512593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2dAV78HOpA0s1qDhNtkCx6CZU7A5bPuHPyNp12FridI=;
        b=Wv2jH4lsdg6zCYbLRh0F803tOMmb1YX2ZkvQRnScZCMxdC8wb5Xn4vybQT5u2KZgptniD0
        PVEbthPLsZkcc1nB4MaKHhDKazTQxB+G3YM1kYIlJEC+qKpkMos7ujQeTONMrU6u/SRLPJ
        ChPlCuthQyQ9gldYLsvfr4F5xwD1W28=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-of2oq72HPrODnUqHOyomqw-1; Thu, 20 May 2021 08:09:51 -0400
X-MC-Unique: of2oq72HPrODnUqHOyomqw-1
Received: by mail-wm1-f70.google.com with SMTP id u19-20020a05600c19d3b029017ae5ad2798so441833wmq.3
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 05:09:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2dAV78HOpA0s1qDhNtkCx6CZU7A5bPuHPyNp12FridI=;
        b=mcCgeHJknE3ttboO9U1p8ccIJ28FLWQ0zJErOu5EWA72zUxt1jCZcTA3Ir0XiaWVao
         DqJ/Ll3/glLhVXRe0rwNraS1SyX/lvRJEQGADRSY5/X/9I//g3MrbCnU2Pt7E99oRzaZ
         1yBAbnKDnet7XNrjtSE9fXylP4myN3LXyM9KG1EeCqx1R8FmuJ1tgy91/+FNHEOODXmh
         0M2VleQIu6133Z1bM83MbPpO2M6zkptIK8z1BEpQusAEEFXPM5Np2ZcoKLmNPiLepjPu
         qdn/mrboG0iUpmCoCVmYGFQIhpyQs0hRRUntGHKzvijjuD1r+O0TXPGwgDEtvokpKM8m
         AtwA==
X-Gm-Message-State: AOAM531kS56f9eH7laABNI4LpAdS9peOJiORZxUbA3tXgrdpFAbaDVXT
        VPoG8Xsvq0fb0Z/o1ayzcTVN0PuV90etVi3tQIOkPfjc0427nKCza2CuoV3li0rVb6Al1xhT53a
        57MgQ0AJZQuQT
X-Received: by 2002:a05:6000:2ca:: with SMTP id o10mr4036128wry.234.1621512590004;
        Thu, 20 May 2021 05:09:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx6d5uWDaH9xRwXmWQ6G/SkWg2HrDiHqSGmItKZYKWhxlzobkIg+2IdRlmIWTQ/Bbzt4aE8Mw==
X-Received: by 2002:a05:6000:2ca:: with SMTP id o10mr4036090wry.234.1621512589783;
        Thu, 20 May 2021 05:09:49 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u11sm1215500wrw.14.2021.05.20.05.09.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 May 2021 05:09:48 -0700 (PDT)
Subject: Re: [PATCH 0/6] Don't use BIT() macro in UAPI headers
To:     Joe Richey <joerichey94@gmail.com>, trivial@kernel.org
Cc:     Joe Richey <joerichey@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-accelerators@lists.ozlabs.org
References: <20210520104343.317119-1-joerichey94@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cda47735-3448-9450-1bf4-51a8cb9c43b0@redhat.com>
Date:   Thu, 20 May 2021 14:09:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210520104343.317119-1-joerichey94@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/05/21 12:43, Joe Richey wrote:
> From: Joe Richey <joerichey@google.com>
> 
> The BIT(n) macro is used in the kernel as an alias for (1 << n).
> However, it is not defined in the UAPI headers, which means that any
> UAPI header files must be careful not to use it, or else the user
> will get a linker error. For example, compiling the following program:
> 
>      #include <sys/auxv.h>
>      #include <asm/hwcap2.h>
> 
>      // Detect if FSGSBASE instructions are enabled
>      int main() {
>          unsigned long val = getauxval(AT_HWCAP2);
>          return !(val & HWCAP2_FSGSBASE);
>      }
> 
> Results in the following likner error:
> 
>      /usr/bin/ld: /tmp/cceFpAdR.o: in function `main':
>      gs.c:(.text+0x21): undefined reference to `BIT'
> 
> This patch series changes all UAPI uses of BIT() to just be open-coded.
> However, there really should be a check for this in checkpatch.pl
> Currently, the script actually _encourages_ users to use the BIT macro
> even if adding things to UAPI.
> 
> Running `rg "BIT\(" **/uapi/**` shows no more usage of BIT() in any
> UAPI headers. Tested by building a basic kernel. Changes are trivial.
> 
> Joe Richey (6):
>    x86/elf: Don't use BIT() macro in UAPI headers
>    KVM: X86: Don't use BIT() macro in UAPI headers
>    drivers: firmware: psci: Don't use BIT() macro in UAPI headers
>    uacce: Don't use BIT() macro in UAPI headers
>    media: vicodec: Don't use BIT() macro in UAPI headers
>    tools headers UAPI: Sync pkt_sched.h with the kernel sources
> 
>   arch/x86/include/uapi/asm/hwcap2.h   |   2 +-
>   include/uapi/linux/kvm.h             |   4 +-
>   include/uapi/linux/psci.h            |   2 +-
>   include/uapi/linux/v4l2-controls.h   |  22 ++---
>   include/uapi/misc/uacce/uacce.h      |   2 +-
>   tools/include/uapi/linux/kvm.h       |   4 +-
>   tools/include/uapi/linux/pkt_sched.h | 122 ++++++++++++++++++++++++---
>   7 files changed, 130 insertions(+), 28 deletions(-)
> 

Will queue the KVM one, thanks!

Paolo

