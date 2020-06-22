Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13C77203DC3
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 19:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729975AbgFVRXD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 13:23:03 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:51545 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729309AbgFVRXD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Jun 2020 13:23:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592846581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tu8Iz36ZUW/maYvXKJmpjHIzM+VvRtZSCZ2QmGMzS1o=;
        b=iCocAWB/jsP3wOIXwSugOzBrTQNXFpxCu3duZ6+qtdpF8u71hjcLs24431edVL5V3GN8qn
        Wqw+JT6wUQ4mYXmjgiD7P5yjNWVrl8bU6L1A86oHoMN7NPcCeSTSnrKCCFqLqCp+KP54N2
        mhzRq6zmCr22GVEW+5m5dFHNeBL627Q=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-Hl8cLpTZM2KY67QeMabq5A-1; Mon, 22 Jun 2020 13:22:59 -0400
X-MC-Unique: Hl8cLpTZM2KY67QeMabq5A-1
Received: by mail-wm1-f69.google.com with SMTP id g124so143829wmg.6
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 10:22:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Tu8Iz36ZUW/maYvXKJmpjHIzM+VvRtZSCZ2QmGMzS1o=;
        b=mPmOtNcxmSN3KNHgEgeqGAJ3rQiJoMNeorHrqoF40pCc/H1mTn6xPs3FpTkoU+76pv
         SBx92MlwhVkr7BKyQTwIfsoD3MHG3wiIoSrHxWef6oxwtBMbxdjoh2sYDEewlW2OH5yj
         i4UEzJL4etxBw9f1ZsHEGuMTe4HxJwikENn8uhYb5/HD6xyh5zDpLNX2RvLzWBe4qWjG
         azq1LHUpwXyIDhCMyu/kpvtx1krsrtu4CEZN7sGYerPUXcXUfnjKPFi3+kVdoVlJH0yS
         RN849zOtadtb9kFXv8/DcMSCvuIMWGsDyMXxpPGRe49fuBi31c9U0miDT8XCR9zoQuSg
         JquA==
X-Gm-Message-State: AOAM531gbK9qIYFNURz3e427Icq7dDQZ69IsN4YEtoA0MyAOkSzDrMKa
        7KEHVaCbSUlcrTBAWAKDLfbsD+eGIu/6+W3px13HfN7ZYnv+Bonnt8OPkcL2AbRFKZ3PNMLkjzD
        rrQBufGWvulJz
X-Received: by 2002:a1c:4302:: with SMTP id q2mr19491767wma.54.1592846577863;
        Mon, 22 Jun 2020 10:22:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx3TA/WezWP7YTHzv6GWH63LAkJq/RHvWZ6HaBWsYWNdd9IYoT8NorLFI2PbeP6FWV9wNMjfw==
X-Received: by 2002:a1c:4302:: with SMTP id q2mr19491749wma.54.1592846577662;
        Mon, 22 Jun 2020 10:22:57 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id g3sm21014843wrb.46.2020.06.22.10.22.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 10:22:57 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: fix build with GCC10
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
References: <20200617152124.402765-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6fd8c087-af56-0a89-ff6c-a23be1ec8b80@redhat.com>
Date:   Mon, 22 Jun 2020 19:22:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200617152124.402765-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/06/20 17:21, Vitaly Kuznetsov wrote:
> kvm-unit-tests fail to build with GCC10:
> 
> /usr/bin/ld: lib/libcflat.a(usermode.o):
>   ./kvm-unit-tests/lib/x86/usermode.c:17:  multiple definition of `jmpbuf';
>  lib/libcflat.a(fault_test.o):
>   ./kvm-unit-tests/lib/x86/fault_test.c:3: first defined here
> 
> It seems that 'jmpbuf' doesn't need to be global in either of these files,
> make it static in both.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  lib/x86/fault_test.c | 2 +-
>  lib/x86/usermode.c   | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/x86/fault_test.c b/lib/x86/fault_test.c
> index 078dae3da640..e15a21864562 100644
> --- a/lib/x86/fault_test.c
> +++ b/lib/x86/fault_test.c
> @@ -1,6 +1,6 @@
>  #include "fault_test.h"
>  
> -jmp_buf jmpbuf;
> +static jmp_buf jmpbuf;
>  
>  static void restore_exec_to_jmpbuf(void)
>  {
> diff --git a/lib/x86/usermode.c b/lib/x86/usermode.c
> index f01ad9be1799..f0325236dd05 100644
> --- a/lib/x86/usermode.c
> +++ b/lib/x86/usermode.c
> @@ -14,7 +14,7 @@
>  #define USERMODE_STACK_SIZE	0x2000
>  #define RET_TO_KERNEL_IRQ	0x20
>  
> -jmp_buf jmpbuf;
> +static jmp_buf jmpbuf;
>  
>  static void restore_exec_to_jmpbuf(void)
>  {
> 

Applied, thanks.

Paolo

