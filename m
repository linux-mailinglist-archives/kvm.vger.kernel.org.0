Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75D441735EB
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 12:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725856AbgB1LQs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 06:16:48 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:45657 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725805AbgB1LQs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Feb 2020 06:16:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582888606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8juBUIQcASEQkK4RsQ4PbQ+cv9mXIpgo3gtzRWCJ7tg=;
        b=CX/NWNXpWTUgJJ0r2dEFPGVMl5RDJ45sSWHcEnbuOLtBGb2c8/qYecrjLIIs6h0ZE36NNA
        XwaWSBaN2OwFx4Aa4t8e07ls4HbbWCE1UxofyOTp4iRb+ZKEpFnogGLqN3OrDFdS8Q+rlp
        BpNbfhkSULtLoLI5VkJsndra+Sz4E+c=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-cO9oFK5BM_y4Cwx3ff7QMg-1; Fri, 28 Feb 2020 06:16:45 -0500
X-MC-Unique: cO9oFK5BM_y4Cwx3ff7QMg-1
Received: by mail-wr1-f72.google.com with SMTP id t14so1186256wrs.12
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2020 03:16:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8juBUIQcASEQkK4RsQ4PbQ+cv9mXIpgo3gtzRWCJ7tg=;
        b=FYHRv1Vg4x33vYEJeSYVzhIaxeV427VWxgz0GBPZCMATrDkDiMkPNFdBi3jIAcobw+
         4Hv7ByRLTdPv9abU69moyqsLVzESMEJ9S52RCnrw0i+nor6Bhi3ZgvUmp7v/IeHkRNv6
         5jgGTAoedX51A0vBTJY1//iF5xiV6CDrrPVzdxi534HfF1PhIts6VZK1QSmPB7cU1v2E
         33FC/FsPpv+iq+0BHA6ef0eGH6SoqWFFix1ZiuCTP5bvNTHS4xhkOhv1FRMb1MtRM7Lw
         la4FH1eVO1uONm/lV84+JdTlvtLmRtF8rjBYH7MqNzZ3NDiR4irGA9iU4he0jLXGljbJ
         C/Cw==
X-Gm-Message-State: APjAAAVMKvv7QBHX5s867BIe5H/5ToEGohkreWYpQXBsnwS6wIZTNomc
        sR40Xat75TcaX6L6FkdAfSVuhaXP30jZTNdz4YJcw/zBucCNNQhOL/uKX12iXVnE+l/UTytpWjk
        /aF4UA52tLdrJ
X-Received: by 2002:adf:cf02:: with SMTP id o2mr1602870wrj.27.1582888603834;
        Fri, 28 Feb 2020 03:16:43 -0800 (PST)
X-Google-Smtp-Source: APXvYqycwsOKNNEFeHqcno6E3ygb3mwbu43znKVGY4wXFMTRy9aJvtPesjSASOO66zMl5xj7QJfoAg==
X-Received: by 2002:adf:cf02:: with SMTP id o2mr1602859wrj.27.1582888603602;
        Fri, 28 Feb 2020 03:16:43 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:d0d9:ea10:9775:f33f? ([2001:b07:6468:f312:d0d9:ea10:9775:f33f])
        by smtp.gmail.com with ESMTPSA id b10sm12070614wrw.61.2020.02.28.03.16.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2020 03:16:42 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 7/7] x86: VMX: the "noclone" attribute is
 gcc-specific
To:     Bill Wendling <morbo@google.com>, kvm@vger.kernel.org
Cc:     oupton@google.com, drjones@redhat.com
References: <20200226074427.169684-1-morbo@google.com>
 <20200226094433.210968-1-morbo@google.com>
 <20200226094433.210968-15-morbo@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <643086be-7251-92cf-c9f5-5a467dd2827d@redhat.com>
Date:   Fri, 28 Feb 2020 12:16:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200226094433.210968-15-morbo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/02/20 10:44, Bill Wendling wrote:
> Don't use the "noclone" attribute for clang as it's not supported.
> 
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>  x86/vmx_tests.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index ad8c002..ec88016 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -4976,7 +4976,10 @@ extern unsigned char test_mtf1;
>  extern unsigned char test_mtf2;
>  extern unsigned char test_mtf3;
>  
> -__attribute__((noclone)) static void test_mtf_guest(void)
> +#ifndef __clang__
> +__attribute__((noclone))
> +#endif
> +static void test_mtf_guest(void)
>  {
>  	asm ("vmcall;\n\t"
>  	     "out %al, $0x80;\n\t"
> 

It's not needed at all, let's drop it.

Paolo

