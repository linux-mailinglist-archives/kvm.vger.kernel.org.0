Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5438F2314AB
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 23:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729400AbgG1Vda (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 17:33:30 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:57626 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729169AbgG1Vd1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Jul 2020 17:33:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595972005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ucbaNhCIcWnoeYDVhlch/z7Xj/tRzNtXuH/aDDtb1xo=;
        b=P6DrVGQM2jYkMwoofY9cNy2fuKZGqk2eigKk9ibvCxDWortbGjnw7dCFwp15TxTpujo+UX
        sB/QkP1ae5wpOk0YlBIObv2sNBhb+2aHsGhMUPsuUA/jfPvB+apTe3l7T7gTkEVcI9IjVG
        7i2AeTFeZqvOSrqMwmYRL4X/tVIQLts=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-YNOQkqi7OG6zWtaWYHcdQQ-1; Tue, 28 Jul 2020 17:27:17 -0400
X-MC-Unique: YNOQkqi7OG6zWtaWYHcdQQ-1
Received: by mail-wm1-f69.google.com with SMTP id s12so189057wmc.5
        for <kvm@vger.kernel.org>; Tue, 28 Jul 2020 14:27:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ucbaNhCIcWnoeYDVhlch/z7Xj/tRzNtXuH/aDDtb1xo=;
        b=kV68+9ZJCv4vgR1/VoTo+XQG7qVHAUsUedQ+tbLh1irH1uc2bEScfyHCdSgIHnbXfA
         gnJw4Bt7kccq50/LmYlP32e5mY5t1+R7dxI3eIYjAZLx8Sd/0k3j7WBQOfmwp9zHp3on
         eIabX5vkzIx9VGCi423wVWbkqjLzI75L1AhwLMhCg4UnzAVvAn20OP9UhHLCYlRoC/aN
         e9zYxq4Awtx8rzBOsOP917aMgCoKT8hDbEw43/YXJpId+NAhdnCiHZXGbTNL+5ll7fVm
         mmECp1+wvdzZiWFughJZ6EA74o9BjVu8DPfmpxzbmr8M+ONEpbHkeeR0bT21S6eedDsX
         LX1Q==
X-Gm-Message-State: AOAM5316fft9GqHHuUTMdoTUQW8KBziNo25rLIBpMM976NGe489GtuDQ
        wim230ED8a3B1NtraRJuFUcqZj8EKeVsCzZINPSWyFhtxIxvpxKppHTOicz+smM8ixbB+AxIizN
        2DS4pNT1OVvgv
X-Received: by 2002:adf:c981:: with SMTP id f1mr26318720wrh.14.1595971636258;
        Tue, 28 Jul 2020 14:27:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz0ceP7K9fO2YG5URsKwLh9tcv55UYIyjscyzlOwyNXpVC4Slz26EX1rC/fLdTZ/gqV8+B+4A==
X-Received: by 2002:adf:c981:: with SMTP id f1mr26318711wrh.14.1595971636067;
        Tue, 28 Jul 2020 14:27:16 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id o10sm129311wrw.79.2020.07.28.14.27.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2020 14:27:15 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: svm: low CR3 bits are not MBZ
To:     Nadav Amit <namit@vmware.com>
Cc:     kvm@vger.kernel.org
References: <20200713043908.39605-1-namit@vmware.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c6f4697d-9d51-18f1-a4cc-7c238112693a@redhat.com>
Date:   Tue, 28 Jul 2020 23:27:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200713043908.39605-1-namit@vmware.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/07/20 06:39, Nadav Amit wrote:
> The low CR3 bits are reserved but not MBZ according to tha APM. The
> tests should therefore not check that they cause failed VM-entry. Tests
> on bare-metal show they do not.
> 
> Signed-off-by: Nadav Amit <namit@vmware.com>
> ---
>  x86/svm.h       |  4 +---
>  x86/svm_tests.c | 26 +-------------------------
>  2 files changed, 2 insertions(+), 28 deletions(-)
> 
> diff --git a/x86/svm.h b/x86/svm.h
> index f8e7429..15e0f18 100644
> --- a/x86/svm.h
> +++ b/x86/svm.h
> @@ -325,9 +325,7 @@ struct __attribute__ ((__packed__)) vmcb {
>  #define SVM_CR0_SELECTIVE_MASK (X86_CR0_TS | X86_CR0_MP)
>  
>  #define	SVM_CR0_RESERVED_MASK			0xffffffff00000000U
> -#define	SVM_CR3_LEGACY_RESERVED_MASK		0xfe7U
> -#define	SVM_CR3_LEGACY_PAE_RESERVED_MASK	0x7U
> -#define	SVM_CR3_LONG_RESERVED_MASK		0xfff0000000000fe7U
> +#define	SVM_CR3_LONG_RESERVED_MASK		0xfff0000000000000U
>  #define	SVM_CR4_LEGACY_RESERVED_MASK		0xff88f000U
>  #define	SVM_CR4_RESERVED_MASK			0xffffffffff88f000U
>  #define	SVM_DR6_RESERVED_MASK			0xffffffffffff1ff0U
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index 3b0d019..1908c7c 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -2007,38 +2007,14 @@ static void test_cr3(void)
>  {
>  	/*
>  	 * CR3 MBZ bits based on different modes:
> -	 *   [2:0]		    - legacy PAE
> -	 *   [2:0], [11:5]	    - legacy non-PAE
> -	 *   [2:0], [11:5], [63:52] - long mode
> +	 *   [63:52] - long mode
>  	 */
>  	u64 cr3_saved = vmcb->save.cr3;
> -	u64 cr4_saved = vmcb->save.cr4;
> -	u64 cr4 = cr4_saved;
> -	u64 efer_saved = vmcb->save.efer;
> -	u64 efer = efer_saved;
>  
> -	efer &= ~EFER_LME;
> -	vmcb->save.efer = efer;
> -	cr4 |= X86_CR4_PAE;
> -	vmcb->save.cr4 = cr4;
> -	SVM_TEST_CR_RESERVED_BITS(0, 2, 1, 3, cr3_saved,
> -	    SVM_CR3_LEGACY_PAE_RESERVED_MASK);
> -
> -	cr4 = cr4_saved & ~X86_CR4_PAE;
> -	vmcb->save.cr4 = cr4;
> -	SVM_TEST_CR_RESERVED_BITS(0, 11, 1, 3, cr3_saved,
> -	    SVM_CR3_LEGACY_RESERVED_MASK);
> -
> -	cr4 |= X86_CR4_PAE;
> -	vmcb->save.cr4 = cr4;
> -	efer |= EFER_LME;
> -	vmcb->save.efer = efer;
>  	SVM_TEST_CR_RESERVED_BITS(0, 63, 1, 3, cr3_saved,
>  	    SVM_CR3_LONG_RESERVED_MASK);
>  
> -	vmcb->save.cr4 = cr4_saved;
>  	vmcb->save.cr3 = cr3_saved;
> -	vmcb->save.efer = efer_saved;
>  }
>  
>  static void test_cr4(void)
> 

Queued, thanks.

Paolo

