Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C868151D8F
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 16:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbgBDPoa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 10:44:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26825 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727334AbgBDPo3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 10:44:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580831069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0vwXFSaSl40J1FkNNvku6P1ALhyHoP4TEE129R0MITY=;
        b=crbXHQvfA3+WNN86PEZGgnRc/Yg1xrk0uJFtKScnN+DD/G+c+z41vyS514f0TIZ5pkJSK3
        JR6l8Agqp+RIISGOXoUvzTtDlJIon0IiKaC76E7pUkXjPs6AMaErF21hjtc9iX7df+nLSF
        Co6SPIh0DtV297vIdal03HUyqYcJjac=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-ZTNdWfBsP_CoLRhzfq3rtw-1; Tue, 04 Feb 2020 10:44:27 -0500
X-MC-Unique: ZTNdWfBsP_CoLRhzfq3rtw-1
Received: by mail-wr1-f72.google.com with SMTP id o6so10429629wrp.8
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2020 07:44:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=0vwXFSaSl40J1FkNNvku6P1ALhyHoP4TEE129R0MITY=;
        b=NSDtblt+mGPiNXk627TV7s/XPhDY/OJT9q4o1hrk52pvqvPNES+eVP3B8RewDqPB2p
         FKVJ43hrV+G2mPpJY9BtuOC5NEVTxYscpmXGhfMKKURmttDdCk1WREbMIbMxdk6klMNH
         ytE+MfiQg3eeCJuCZbrH3PRNNybOiRgRzfHGsVx54M0fw+UOYsQPQG0reyt8HQvw+JrQ
         Kr6hdZK/Ok1Dcawhn9UgHQO8RMEoJ1WpyQf1loO29C7sF1Ldq0nBy2afJ+zqZcyTzURc
         eg/5R0SB1TFgSTdcbpJzA1Jt0AKBbz/VsieEypB64XBERfXBomLYcfDpc3A0q0nOKnd/
         zE0A==
X-Gm-Message-State: APjAAAW39yfC1H+wRENhHEtOdi4f0Momk9n5igiUv4nX4nG0lQxhEgxD
        PKgDSCsQeR3qwA7c5IbsUfWdlmAXGO4ShftnjSHRPHz2wLwxuLpJ7rcvTjWopXWt0WNSk7nrdRC
        jXaqA1UGvBM8J
X-Received: by 2002:adf:f58a:: with SMTP id f10mr24341719wro.105.1580831065883;
        Tue, 04 Feb 2020 07:44:25 -0800 (PST)
X-Google-Smtp-Source: APXvYqxwDx/I4vTg/SxYW41BiQRlGoEm+2lFdAFLqZEnpwiOtn/GnZl4INGu2P+XSYN73hA3IdQ/2A==
X-Received: by 2002:adf:f58a:: with SMTP id f10mr24341714wro.105.1580831065692;
        Tue, 04 Feb 2020 07:44:25 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id i204sm4499498wma.44.2020.02.04.07.44.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 07:44:24 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     thuth@redhat.com, drjones@redhat.com, wei.huang2@amd.com,
        eric.auger.pro@gmail.com, eric.auger@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com
Subject: Re: [PATCH v3 1/3] selftests: KVM: Replace get_gdt/idt_base() by get_gdt/idt()
In-Reply-To: <20200204150040.2465-2-eric.auger@redhat.com>
References: <20200204150040.2465-1-eric.auger@redhat.com> <20200204150040.2465-2-eric.auger@redhat.com>
Date:   Tue, 04 Feb 2020 16:44:23 +0100
Message-ID: <87r1zamk6g.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Eric Auger <eric.auger@redhat.com> writes:

> get_gdt_base() and get_idt_base() only return the base address
> of the descriptor tables. Soon we will need to get the size as well.
> Change the prototype of those functions so that they return
> the whole desc_ptr struct instead of the address field.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  tools/testing/selftests/kvm/include/x86_64/processor.h | 8 ++++----
>  tools/testing/selftests/kvm/lib/x86_64/vmx.c           | 6 +++---
>  2 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index aa6451b3f740..6f7fffaea2e8 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -220,20 +220,20 @@ static inline void set_cr4(uint64_t val)
>  	__asm__ __volatile__("mov %0, %%cr4" : : "r" (val) : "memory");
>  }
>  
> -static inline uint64_t get_gdt_base(void)
> +static inline struct desc_ptr get_gdt(void)
>  {
>  	struct desc_ptr gdt;
>  	__asm__ __volatile__("sgdt %[gdt]"
>  			     : /* output */ [gdt]"=m"(gdt));
> -	return gdt.address;
> +	return gdt;
>  }
>  
> -static inline uint64_t get_idt_base(void)
> +static inline struct desc_ptr get_idt(void)
>  {
>  	struct desc_ptr idt;
>  	__asm__ __volatile__("sidt %[idt]"
>  			     : /* output */ [idt]"=m"(idt));
> -	return idt.address;
> +	return idt;
>  }
>  
>  #define SET_XMM(__var, __xmm) \
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
> index 85064baf5e97..7aaa99ca4dbc 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
> @@ -288,9 +288,9 @@ static inline void init_vmcs_host_state(void)
>  	vmwrite(HOST_FS_BASE, rdmsr(MSR_FS_BASE));
>  	vmwrite(HOST_GS_BASE, rdmsr(MSR_GS_BASE));
>  	vmwrite(HOST_TR_BASE,
> -		get_desc64_base((struct desc64 *)(get_gdt_base() + get_tr())));
> -	vmwrite(HOST_GDTR_BASE, get_gdt_base());
> -	vmwrite(HOST_IDTR_BASE, get_idt_base());
> +		get_desc64_base((struct desc64 *)(get_gdt().address + get_tr())));
> +	vmwrite(HOST_GDTR_BASE, get_gdt().address);
> +	vmwrite(HOST_IDTR_BASE, get_idt().address);
>  	vmwrite(HOST_IA32_SYSENTER_ESP, rdmsr(MSR_IA32_SYSENTER_ESP));
>  	vmwrite(HOST_IA32_SYSENTER_EIP, rdmsr(MSR_IA32_SYSENTER_EIP));
>  }

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

