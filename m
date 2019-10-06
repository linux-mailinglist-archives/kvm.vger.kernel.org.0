Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44C51CD36B
	for <lists+kvm@lfdr.de>; Sun,  6 Oct 2019 18:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfJFQIY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Oct 2019 12:08:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14877 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726349AbfJFQIX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Oct 2019 12:08:23 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7D9F83DE0C
        for <kvm@vger.kernel.org>; Sun,  6 Oct 2019 16:08:23 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id m14so5761330wru.17
        for <kvm@vger.kernel.org>; Sun, 06 Oct 2019 09:08:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JpUUvq7TdpHWK/oJt1Hyc4zywgI4ZqBPJjGMbhOuXvg=;
        b=mRnjYUQvjmG8L/NmQnHoVh3MJDnKniuWTvHTVWsxTRFv0WwzdcEqdHuhOd9pLVNq89
         3mNcXExKII2AaafNXt9yec3lhz3faltuF4nG23LTo6cy3q69GG0D11+E9GDJRPv25hhY
         r3vj/waOER3FBu4tnLL5RfxEslHrYDXwH3l6br1IUWns0/ad1aOo0gPV0DaBzliVaxxX
         bhdxALDMG8QhjOZu48fOdnGFeEb7m8I3JZ+x37qribIplxqCom+bE9PB/s8mtmBxzThR
         5hO50nnSOjGhHDyI+sBbzqll5/o1BWZo0VM1iSmAsdzpvARWReHMiBNQHpJ89UV4JYm6
         48Hg==
X-Gm-Message-State: APjAAAWUP5cUt8FWdkCo3m7zWoNc9FkfUzJPYkQU5MP2w2IRo+CLvmzw
        12Y1UWeSxnusjYFJM6LVetDUwkdFLn/NjhBX518NcOQOe4yX4V6Wmog+pjLlnPMug2kjF5GepvB
        o4Be2pVhdPHWo
X-Received: by 2002:adf:f00d:: with SMTP id j13mr7490020wro.140.1570378102191;
        Sun, 06 Oct 2019 09:08:22 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwn07XGlWG9aFiuAXSb0CLn7dLoAyisaKRcX6XiJg17I7XfoY2AukCqMHctQ9p6r1wcci9a+w==
X-Received: by 2002:adf:f00d:: with SMTP id j13mr7490001wro.140.1570378101946;
        Sun, 06 Oct 2019 09:08:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e876:e214:dc8e:2846? ([2001:b07:6468:f312:e876:e214:dc8e:2846])
        by smtp.gmail.com with ESMTPSA id g185sm13155693wme.10.2019.10.06.09.08.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Oct 2019 09:08:21 -0700 (PDT)
Subject: Re: [PATCH 2/3] KVM: x86: always expose VIRT_SSBD to guests
To:     Eduardo Habkost <ehabkost@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>, konrad.wilk@oracle.com
References: <1566376002-17121-1-git-send-email-pbonzini@redhat.com>
 <1566376002-17121-3-git-send-email-pbonzini@redhat.com>
 <20191001221646.GN4084@habkost.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <a15e4b77-22ca-e92d-b170-e40b845a5bd1@redhat.com>
Date:   Sun, 6 Oct 2019 18:08:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191001221646.GN4084@habkost.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/10/19 00:16, Eduardo Habkost wrote:
> Wasn't the old code at arch/x86/kvm/cpuid.c:__do_cpuid_func()
> supposed to be deleted?
> 
>                /*
>                 * The preference is to use SPEC CTRL MSR instead of the
>                 * VIRT_SPEC MSR.
>                 */
>                if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) &&
>                    !boot_cpu_has(X86_FEATURE_AMD_SSBD))
>                        entry->ebx |= F(VIRT_SSBD);

Yeah, it's harmless but also useless.

Paolo
