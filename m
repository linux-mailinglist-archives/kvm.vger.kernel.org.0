Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F02CC3745C
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 14:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727310AbfFFMjP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 08:39:15 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38713 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfFFMjP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 08:39:15 -0400
Received: by mail-wr1-f68.google.com with SMTP id d18so2259705wrs.5
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 05:39:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VA4NRIaT3EdiBZnZ/KEWHClNcoj8m2EjqXtsdyURvi8=;
        b=Cn07UaJCFXpsABDKGW14WB9i+i33QYVeFWZVhuVSdzoDfaoPkSKZZx/zOJf7S05C2U
         O812LF0A1mUl8BHwQG0GlUWErGXFI+gDycKuscO7f+rcuoTPymRyGOpJ2x2W5nkVndlZ
         HzDw6iN+JFvfh+DepJErV0WbDeQDA1+jfEwHsQZhC/v0vZXQhO0f4WUigvKM//MPmPnv
         o1Z5mOEa+k8HHRYx9vcmzQsPL2qU90nu6kUXulyUi8kXuf2RyPPYqlw8vK8+S4qkdtd1
         FXpRv2/ZjFbPqP5ROO/1fKPty4dGqEQV5M7Cxlw+hnD+4QF7qxccJJ3UVdfboikKPLmA
         FimQ==
X-Gm-Message-State: APjAAAXkPxLW+PSqG9BMaKn9xlLqK/XuL2CmGBJa7by47a7xvhg0mQir
        Px7SF5BDmL3bej+0h1GkNspXog==
X-Google-Smtp-Source: APXvYqyvEIUGuKKN7+PL3P//eqdlqNfO5dUH/Yiq3O2gACBivkbQbqFsodxhsc7VPvCgtOe4yXGKFQ==
X-Received: by 2002:a5d:49c1:: with SMTP id t1mr2409943wrs.35.1559824754147;
        Thu, 06 Jun 2019 05:39:14 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id n4sm1747304wrp.61.2019.06.06.05.39.13
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 05:39:13 -0700 (PDT)
Subject: Re: [PATCH 0/4][kvm-unit-test nVMX]: Test "load
 IA32_PERF_GLOBAL_CONTROL" VM-entry control on vmentry of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, jmattson@google.com
References: <20190509212055.29933-1-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6363dc39-b44b-0cca-de2f-603703df41b9@redhat.com>
Date:   Thu, 6 Jun 2019 14:39:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190509212055.29933-1-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/05/19 23:20, Krish Sadhukhan wrote:
> This set contains the unit test, and related changes, for the "load
> IA32_PERF_GLOBAL_CONTROL" VM-entry control that was enabled in my previous
> patchset titled:
> 
> 	[KVM nVMX]: Check "load IA32_PERF_GLOBAL_CTRL" on vmentry of nested guests
> 
> 
> [PATCH 1/4][kvm-unit-test nVMX]: Rename guest_pat_main to guest_state_test_main
> [PATCH 2/4][kvm-unit-test nVMX]: Rename report_guest_pat_test to
> [PATCH 3/4][kvm-unit-test nVMX]: Add #define for "load IA32_PERF_GLOBAL_CONTROL" bit
> [PATCH 4/4][kvm-unit-test nVMX]: Test "load IA32_PERF_GLOBAL_CONTROL" VM-entry
> 
>  x86/vmx.h       |   1 +
>  x86/vmx_tests.c | 108 +++++++++++++++++++++++++++++++++++++++++++-----------
>  2 files changed, 87 insertions(+), 22 deletions(-)
> 
> Krish Sadhukhan (4):
>       nVMX: Rename guest_pat_main to guest_state_test_main
>       nVMX: Rename report_guest_pat_test to report_guest_state_test
>       nVMX: Add #define for "load IA32_PERF_GLOBAL_CONTROL" bit
>       nVMX: Test "load IA32_PERF_GLOBAL_CONTROL" VM-entry control on vmentry of nested guests
> 

Queued 1-3, but patch 4 does not apply.  It seems like you have another
patch that this sits on top of?

Paolo
