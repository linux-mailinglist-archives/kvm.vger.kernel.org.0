Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 249A41F1851
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 13:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729743AbgFHL5L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 07:57:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49643 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726597AbgFHL5K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 07:57:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591617428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ktaClkE3MjShq2aZhMBmdcl25fBRPEzNmpeADyl2Hek=;
        b=D8G+wwwG/uFWKAEns5849GU75j2vpIfdLJbItRQvYwsiUMl10Nb4c5q0zSXZ3qmC7hOjFo
        IWzAvjnv/kOVZMs3UQyXf4yfPGCDv/hoIDCBeDYQdel5osLkBpBeCED/n2WOxJoAlGZLxB
        +2BBlnHhxLm414Jg6jUu2iw3eDUPTx0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-su3iU05zPQe05RAhKaMWkA-1; Mon, 08 Jun 2020 07:57:06 -0400
X-MC-Unique: su3iU05zPQe05RAhKaMWkA-1
Received: by mail-wm1-f72.google.com with SMTP id j128so5158353wmj.6
        for <kvm@vger.kernel.org>; Mon, 08 Jun 2020 04:57:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ktaClkE3MjShq2aZhMBmdcl25fBRPEzNmpeADyl2Hek=;
        b=pv8yovPoe4YOTOv1dNxx1p8mEVl9L+ZxAZBtsczX8ag/LxnDGmhCZzRRUUvixxkJr7
         HbMPXLbvJm2kkVVOgR0QxM5T0BY3SjhSkYlFoGU3IV1v+3xdaaZSNjopM88kDnl+KHVY
         Ba1Y+f3t4bt47RvHIJZHTdoSLsoNuVL2a4sGIOIiBWWyI9j0Faqvq5Au5rzWpsZMunbF
         PK4Lpg9ckD3GosYqSpO84xAC6wsRQ3GHLrTF8X7YGZzavjXO6yrG3CE+Dm+mvOuYUFBX
         /3r9vwNjIcTn+EDT1pZck5SocdW29aSoNlL5JE0WKbafEsv32cJkrPqzn6w8BuK94XOr
         pAAQ==
X-Gm-Message-State: AOAM530j1AJKGdy96mJFoMe9t03G6+7NRnrHf3v4DYAZzwkLS8BZhkwR
        nKKLI4yZYkk6SPRPlXq8yAEYwpixqGad6y59trNbynjOCwMZ290vp83gtryUnJxkf01Hy2db/rM
        pFGkl80dIDSQC
X-Received: by 2002:a5d:42cd:: with SMTP id t13mr22660529wrr.355.1591617425723;
        Mon, 08 Jun 2020 04:57:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxUyKwN5T1nrrk4iLhBXqo9bzdSufX5DbLI/CXNpW9Q8LKuUKlJElowUVhid25ySEur6UpcAQ==
X-Received: by 2002:a5d:42cd:: with SMTP id t13mr22660499wrr.355.1591617425412;
        Mon, 08 Jun 2020 04:57:05 -0700 (PDT)
Received: from [192.168.178.58] ([151.30.87.23])
        by smtp.gmail.com with ESMTPSA id w17sm23722537wra.71.2020.06.08.04.57.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2020 04:57:04 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: selftests: fix vmx_preemption_timer_test build
 with GCC10
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Bandeira Condotta <mcondotta@redhat.com>,
        Makarand Sonare <makarandsonare@google.com>,
        Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org
References: <20200608112346.593513-1-vkuznets@redhat.com>
 <20200608112346.593513-2-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <39c73030-49ff-f25c-74de-9a52579eefbe@redhat.com>
Date:   Mon, 8 Jun 2020 13:57:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200608112346.593513-2-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/06/20 13:23, Vitaly Kuznetsov wrote:
> GCC10 fails to build vmx_preemption_timer_test:
> 
> gcc -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99
> -fno-stack-protector -fno-PIE -I../../../../tools/include
>  -I../../../../tools/arch/x86/include -I../../../../usr/include/
>  -Iinclude -Ix86_64 -Iinclude/x86_64 -I..  -pthread  -no-pie
>  x86_64/evmcs_test.c ./linux/tools/testing/selftests/kselftest_harness.h
>  ./linux/tools/testing/selftests/kselftest.h
>  ./linux/tools/testing/selftests/kvm/libkvm.a
>  -o ./linux/tools/testing/selftests/kvm/x86_64/evmcs_test
> /usr/bin/ld: ./linux/tools/testing/selftests/kvm/libkvm.a(vmx.o):
>  ./linux/tools/testing/selftests/kvm/include/x86_64/vmx.h:603:
>  multiple definition of `ctrl_exit_rev'; /tmp/ccMQpvNt.o:
>  ./linux/tools/testing/selftests/kvm/include/x86_64/vmx.h:603:
>  first defined here
> /usr/bin/ld: ./linux/tools/testing/selftests/kvm/libkvm.a(vmx.o):
>  ./linux/tools/testing/selftests/kvm/include/x86_64/vmx.h:602:
>  multiple definition of `ctrl_pin_rev'; /tmp/ccMQpvNt.o:
>  ./linux/tools/testing/selftests/kvm/include/x86_64/vmx.h:602:
>  first defined here
>  ...
> 
> ctrl_exit_rev/ctrl_pin_rev/basic variables are only used in
> vmx_preemption_timer_test.c, just move them there.
> 
> Fixes: 8d7fbf01f9af ("KVM: selftests: VMX preemption timer migration test")
> Reported-by: Marcelo Bandeira Condotta <mcondotta@redhat.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  tools/testing/selftests/kvm/include/x86_64/vmx.h              | 4 ----
>  .../testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c  | 4 ++++
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
> index ccff3e6e2704..766af9944294 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
> @@ -598,10 +598,6 @@ union vmx_ctrl_msr {
>  	};
>  };
>  
> -union vmx_basic basic;
> -union vmx_ctrl_msr ctrl_pin_rev;
> -union vmx_ctrl_msr ctrl_exit_rev;
> -
>  struct vmx_pages *vcpu_alloc_vmx(struct kvm_vm *vm, vm_vaddr_t *p_vmx_gva);
>  bool prepare_for_vmx_operation(struct vmx_pages *vmx);
>  void prepare_vmcs(struct vmx_pages *vmx, void *guest_rip, void *guest_rsp);
> diff --git a/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c b/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
> index cc72b6188ca7..a7737af1224f 100644
> --- a/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
> @@ -31,6 +31,10 @@ bool l2_save_restore_done;
>  static u64 l2_vmx_pt_start;
>  volatile u64 l2_vmx_pt_finish;
>  
> +union vmx_basic basic;
> +union vmx_ctrl_msr ctrl_pin_rev;
> +union vmx_ctrl_msr ctrl_exit_rev;
> +
>  void l2_guest_code(void)
>  {
>  	u64 vmx_pt_delta;
> 

Queued both, thanks.

Paolo

