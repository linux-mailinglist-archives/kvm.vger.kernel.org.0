Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2DEE128D7A
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2019 11:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbfLVKqY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Dec 2019 05:46:24 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:23608 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726053AbfLVKqY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 22 Dec 2019 05:46:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577011581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BbS/SraLV7W9+Kigv33qodrGuRZjCR+UJjm1tm4Wd3Y=;
        b=VmuRfSce3q90V62xCQ5iFYYr1wevD/l1nhrQGlprYvwijsEoPQ2405gp24wXTHHkY6sFHl
        quvPcMfN/0Okbwxszsw/hbi8++nlgmfGzG7PNlyOPdxoCA6SEAM/LZs5cI+1EthllSBuNJ
        Z9E9fvBCGsvpQJwf2ExRId2aldhNWW0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-5E8IO1ZzM4uyPLViZiI0Tg-1; Sun, 22 Dec 2019 05:46:20 -0500
X-MC-Unique: 5E8IO1ZzM4uyPLViZiI0Tg-1
Received: by mail-wr1-f70.google.com with SMTP id o6so2545534wrp.8
        for <kvm@vger.kernel.org>; Sun, 22 Dec 2019 02:46:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BbS/SraLV7W9+Kigv33qodrGuRZjCR+UJjm1tm4Wd3Y=;
        b=meYDpA1EH6ydxkCHQrlg7P8SJ/ZZ0cYEmLuKbiO2CV7vkQzXEgS0HEntRLEwpgUl6g
         C5wEo3maF7Nke0JJDRoDkLVXLrtz5PxGesfkBZR0Lpvozux5VTA3c/4AjQ2bNht9kRBi
         lXWtkV7OtndQG47Rtq35DF4FuvhShgZqZqsGs4CQ4VTQ+zKeuJPj9XlUzjTAtMnY0FjM
         TZpcSBC/dp4NUpYO1aTZCkdPPhiqkrqB32QQ9U9TyM4f1vvfm6dSLLS/zznD4/fvrpJM
         1y3CQ4Sxfb3O91+JDnG6O757M3iu2ENhsP2+uTdwG0owOUHnmpKdg8esO/7amETOZPtW
         7uUQ==
X-Gm-Message-State: APjAAAVLEXLUqgPruZ2jG++nz77rDoRZBENB/htJkZd4f2F2QsMBay79
        CpTHRQ7u8QdIuy0Syu/O2iKRuQXTVg3f7++sy0ma+uS2cfgmzA57pS1YM83nHpDxpoL8tySrFJP
        gdH4PZUVRoW9W
X-Received: by 2002:a7b:cf26:: with SMTP id m6mr24625361wmg.17.1577011579039;
        Sun, 22 Dec 2019 02:46:19 -0800 (PST)
X-Google-Smtp-Source: APXvYqxEiX4VWTXOI53mxlk30oTDucDZUgIaRnuexHTgJaD/Reqh/MG0OUWxqiv7iMUeHJRC+MgISw==
X-Received: by 2002:a7b:cf26:: with SMTP id m6mr24625345wmg.17.1577011578838;
        Sun, 22 Dec 2019 02:46:18 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:7009:9cf0:6204:f570? ([2001:b07:6468:f312:7009:9cf0:6204:f570])
        by smtp.gmail.com with ESMTPSA id g21sm17499777wrb.48.2019.12.22.02.46.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Dec 2019 02:46:18 -0800 (PST)
Subject: Re: [PATCH] MAINTAINERS: Orphan KVM for MIPS
To:     James Hogan <jhogan@kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Paul Burton <paulburton@kernel.org>
Cc:     Ralf Baechle <ralf@linux-mips.org>, kvm@vger.kernel.org,
        linux-mips@vger.kernel.org
References: <20191221155013.49080-1-jhogan@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4ba9fcff-5088-e60f-11a8-f2d158dbf848@redhat.com>
Date:   Sun, 22 Dec 2019 11:46:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191221155013.49080-1-jhogan@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/12/19 16:50, James Hogan wrote:
> I haven't been active for 18 months, and don't have the hardware set up
> to test KVM for MIPS, so mark it as orphaned and remove myself as
> maintainer. Hopefully somebody from MIPS can pick this up.
> 
> Signed-off-by: James Hogan <jhogan@kernel.org>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: "Radim Krčmář" <rkrcmar@redhat.com>
> Cc: Paul Burton <paulburton@kernel.org>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: kvm@vger.kernel.org
> Cc: linux-mips@vger.kernel.org
> ---
>  MAINTAINERS | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 19d17815c0fb..010bb51bedcb 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9074,9 +9074,8 @@ F:	virt/kvm/arm/
>  F:	include/kvm/arm_*
>  
>  KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)
> -M:	James Hogan <jhogan@kernel.org>
>  L:	linux-mips@vger.kernel.org
> -S:	Supported
> +S:	Orphan
>  F:	arch/mips/include/uapi/asm/kvm*
>  F:	arch/mips/include/asm/kvm*
>  F:	arch/mips/kvm/
> 

Applied, adding kvm@vger.kernel.org to the lists as well.  Thanks for
your work!

Paolo

