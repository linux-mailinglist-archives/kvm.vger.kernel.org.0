Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7C7B155A5B
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 16:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgBGPIF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 10:08:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38739 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726901AbgBGPIF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 10:08:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581088083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5g8c3Dt5YGFnyjeCvdVnSkJ8OoAq7ZLBS2fAhe/Z94c=;
        b=AopPWNdNQZwWsEx1RCQSlHfNPsRpQ1XaxoZ6MzFPk2/TMiJQsB5wFimeaHI6/1wM9TWlvE
        xPtJq6I0clOMnxWMBZpMh6KHkgfnFFLP9G+avSixcd7c5KcnwH/l3roAkQK+aSWzfLWvvy
        v5YAUb+ui1MfdmJDe6iU/RjnZlhDDrE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-FY8fffcpNMO2T4SoxAO6Ng-1; Fri, 07 Feb 2020 10:08:02 -0500
X-MC-Unique: FY8fffcpNMO2T4SoxAO6Ng-1
Received: by mail-wm1-f72.google.com with SMTP id l11so1746676wmi.0
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2020 07:07:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=5g8c3Dt5YGFnyjeCvdVnSkJ8OoAq7ZLBS2fAhe/Z94c=;
        b=ltMrlB7HCws8CfS6tbzXFulvjKQ/uJ9B3vepRHf+F23IqQJvjuNKVAmFTuHqvgpDXf
         fYtbLBXZMRuBhfsIpGKkcSBi672LfwQ4RjlZaVO1j1qyjZbPJzhSU7Qn3Ad+YJPJHSpY
         8MU8I0BUicO30OPMgrjYzZ7nglyFm4okOmPrmyWqOP6A3bKToA18doIBUlUSqr4aum6c
         kvWaNJA8J/u9CG09oRZ4ECZdd5s/OWDqCU8cgFnRFoVT5iIfl3IP4Bzk1m47xPIS3I+6
         q8YbF6CtoAlOY5ETMpuFZRXafCLSEvZGnZFMnYBHzUFNXv+K317qdeqtpzNwYrF/ALYt
         PzLQ==
X-Gm-Message-State: APjAAAUTPQ0e6cM2MY22BNdf9XZooPVdqkQZxrvSq5GGPXRt4Nes4Oha
        xYvmad2yqeD7nbVFlfHwPZaaawdmhY4T5MP+fNIvgRi2PvBbgIkGbJZF+Ggl/UZhCoQs4loAsNx
        RWOLN2+7AwsXi
X-Received: by 2002:adf:f28c:: with SMTP id k12mr5384300wro.360.1581088078032;
        Fri, 07 Feb 2020 07:07:58 -0800 (PST)
X-Google-Smtp-Source: APXvYqygyybBx8aip4PiQSeNZI4d9+MbdXWU5727okvl0YyzWFNc854rtOn5bfI+PF71Bdg58IOdxQ==
X-Received: by 2002:adf:f28c:: with SMTP id k12mr5384273wro.360.1581088077787;
        Fri, 07 Feb 2020 07:07:57 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id e16sm3662109wrs.73.2020.02.07.07.07.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 07:07:57 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     thuth@redhat.com, drjones@redhat.com, wei.huang2@amd.com,
        krish.sadhukhan@oracle.com, eric.auger.pro@gmail.com,
        eric.auger@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH v5 2/4] selftests: KVM: Remove unused x86_register enum
In-Reply-To: <20200207142715.6166-3-eric.auger@redhat.com>
References: <20200207142715.6166-1-eric.auger@redhat.com> <20200207142715.6166-3-eric.auger@redhat.com>
Date:   Fri, 07 Feb 2020 16:07:56 +0100
Message-ID: <87mu9uqvub.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Eric Auger <eric.auger@redhat.com> writes:

> x86_register enum is not used. Its presence incites us
> to enumerate GPRs in the same order in other looming
> structs. So let's remove it.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  .../selftests/kvm/include/x86_64/processor.h  | 20 -------------------
>  1 file changed, 20 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 6f7fffaea2e8..e48dac5c29e8 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -36,26 +36,6 @@
>  #define X86_CR4_SMAP		(1ul << 21)
>  #define X86_CR4_PKE		(1ul << 22)
>  
> -/* The enum values match the intruction encoding of each register */
> -enum x86_register {
> -	RAX = 0,
> -	RCX,
> -	RDX,
> -	RBX,
> -	RSP,
> -	RBP,
> -	RSI,
> -	RDI,
> -	R8,
> -	R9,
> -	R10,
> -	R11,
> -	R12,
> -	R13,
> -	R14,
> -	R15,
> -};
> -
>  struct desc64 {
>  	uint16_t limit0;
>  	uint16_t base0;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

