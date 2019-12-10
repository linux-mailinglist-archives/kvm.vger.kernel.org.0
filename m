Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 051F1118EB1
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 18:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbfLJRMT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 12:12:19 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:49749 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727525AbfLJRMS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Dec 2019 12:12:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575997937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bzj43lN3OwZXvtBIk2gUIyd7rTRhI5j/lQBM40cyy8g=;
        b=SOaJWN5Rci+DLSmw/Kuig401f4FHd+Le3Uh2W+2t0yKQAyLrzGjyGMyaaaQqpTIoVazowM
        rkr5Mxzh+G61cPWxaRzdiNkwrdE/nTvfBR3/Z9Mr9Geb5Qn/4vSVn8nKa+dwJ8CeS0gI8R
        qq9QRi+6/2bI1j4AV2MEytDsCp8Te9c=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-PUFysVHMNOGgRfY007t9eg-1; Tue, 10 Dec 2019 12:12:16 -0500
Received: by mail-wm1-f70.google.com with SMTP id g1so1247676wmg.4
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2019 09:12:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Bzj43lN3OwZXvtBIk2gUIyd7rTRhI5j/lQBM40cyy8g=;
        b=XQpXoA7g9AIgsboy7kWAhB2p1xlc1++hc3nnke7KORCaQzlmGhQIvT/RFNxQD/AQqO
         TYrPvCnj29Mjg/1BT+8PA6zW/kKgy1GuGqEyVvytGTMss/RlP+7R0oc+031h7+l+zXqI
         FuMZmXrXKOlncUsRnWuJw1mY2fzfJ1yqUYiVGeTPcwn1IP2BUei/osCIeGpzcElHa6qt
         NTjSVBu4iVSMNZBJ3IIh43+u/RBzB+O6cu2nN+Vc1DLXFxQsL3gBUPHmdZpBYDz6WVTC
         6f2ozt7Pjp9qoh2SIij91Ec3Ng8PDMtllVuB0pZU5dOSJKuJOYOIVN/Y3WDEZA41BGCR
         prRA==
X-Gm-Message-State: APjAAAVGE7QVgQdRZ+S/rV4DX26PXh761MMgh5ZUjT4MuZ5pKWwBvx+a
        CX+c4qGw/SmL5/t0xKAS50R5iORBX5dfksnB0ftFRiQJTtwEFQnyvK3j/JkoszJ8N31woiRRufV
        X1Wj8Kok96rxu
X-Received: by 2002:a7b:c00c:: with SMTP id c12mr6453837wmb.34.1575997935025;
        Tue, 10 Dec 2019 09:12:15 -0800 (PST)
X-Google-Smtp-Source: APXvYqzZ3WqP8KNB6pAAEJYJ7k+GCErjhkgvrXUObbk9Zc6VTZi1iPG+2/nrU14Val+D0kT8Q1RASw==
X-Received: by 2002:a7b:c00c:: with SMTP id c12mr6453814wmb.34.1575997934814;
        Tue, 10 Dec 2019 09:12:14 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id x11sm4141932wre.68.2019.12.10.09.12.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2019 09:12:14 -0800 (PST)
Subject: Re: [PATCH][kvm-unit-test VMX]: Use #define for bit# 1 in
 GUEST_RFLAGS
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com
References: <20190328023246.12087-1-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7688f358-c8e9-4ef0-cf6a-12be85155616@redhat.com>
Date:   Tue, 10 Dec 2019 18:12:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20190328023246.12087-1-krish.sadhukhan@oracle.com>
Content-Language: en-US
X-MC-Unique: PUFysVHMNOGgRfY007t9eg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/03/19 03:32, Krish Sadhukhan wrote:
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Reviewed-by: Mark Kanda <mark.kanda@oracle.com>
> 
> ---
>  x86/vmx.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/x86/vmx.c b/x86/vmx.c
> index 6ba56bc..d1a0da8 100644
> --- a/x86/vmx.c
> +++ b/x86/vmx.c
> @@ -1193,7 +1193,7 @@ static void init_vmcs_guest(void)
>  	/* 26.3.1.4 */
>  	vmcs_write(GUEST_RIP, (u64)(&guest_entry));
>  	vmcs_write(GUEST_RSP, (u64)(guest_stack + PAGE_SIZE - 1));
> -	vmcs_write(GUEST_RFLAGS, 0x2);
> +	vmcs_write(GUEST_RFLAGS, X86_EFLAGS_FIXED);
>  
>  	/* 26.3.1.5 */
>  	vmcs_write(GUEST_ACTV_STATE, ACTV_ACTIVE);
> @@ -1705,7 +1705,7 @@ static int test_run(struct vmx_test *test)
>  	test->exits = 0;
>  	current = test;
>  	regs = test->guest_regs;
> -	vmcs_write(GUEST_RFLAGS, regs.rflags | 0x2);
> +	vmcs_write(GUEST_RFLAGS, regs.rflags | X86_EFLAGS_FIXED);
>  	launched = 0;
>  	guest_finished = 0;
>  	printf("\nTest suite: %s\n", test->name);
> 

Applied, better late than never...

Paolo

