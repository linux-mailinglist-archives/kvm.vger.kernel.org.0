Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 063BD15337D
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 15:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgBEO5A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 09:57:00 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:53600 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727081AbgBEO5A (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 09:57:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580914619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QK9rDhAQMTvm/4oE1owAxCKM6SK1FUKWk+UU1I8wspU=;
        b=Don0MEq7VPayXQ1EBvjikjF+rsRCs2LLY/yrP6gleLjkH4wCTWjmyZHZiWxf9iXWjORz87
        4HUR/IPGT63h8lBeczHKuq+TdJHBvQqSuBh04OSB55GyXGVkgIa1rXhXaeuIJgSGFrBdPP
        K1zr0hn0sGi7CWPAEpbRFp+9kNYkin4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-y-ty2iL0N--w26rC6TJD4w-1; Wed, 05 Feb 2020 09:56:57 -0500
X-MC-Unique: y-ty2iL0N--w26rC6TJD4w-1
Received: by mail-wm1-f71.google.com with SMTP id m18so935791wmc.4
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 06:56:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QK9rDhAQMTvm/4oE1owAxCKM6SK1FUKWk+UU1I8wspU=;
        b=ojig5iUSfsRsHiz73fM8R6kA4hjJBTLV/3XmRb/p4fPuo/A1ZeOJWKZ4Y/PMo0mHEh
         DS5vp89CnwQjrXK7QQarXpWCb7NZgtaJFhNwvOPLd4A2lxZe0nMa+1C/fMYQAJqgJH5U
         JtTWEd1hzLJ+kysDAm+2NIzqfvHH+exYylMb6xIIggeljiUsx3iVMxqMaZHXo+rfzwsF
         +2Bf6/BiVTHw3cFuSEKiCAnkP85yjd52vM2f7gvGwFYQhGiCwFMI+BLxgNNcKfx1EXXc
         7Bz1NO0FaHV6tRXhq0EFE1WVzm0zKlxpXRSExBJc3n0PUSqViEtvKQzFx5NYiaDCEa8B
         7TQg==
X-Gm-Message-State: APjAAAVGwlVJ6dXO3bRD2EV316qUsLCaMm0ln0o0pJWQBTq0GzuDgbT3
        R1b3nv6s5n8BxLd809UGBx4XYlAkQIpLmfhmUemCZVxaPPnnS8EBfX41xI7mq5nS00My7mCo/k1
        QCX90HtrOzJBR
X-Received: by 2002:adf:e984:: with SMTP id h4mr29308656wrm.275.1580914616567;
        Wed, 05 Feb 2020 06:56:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqz9qVZf32IzPnrUnSW4dGxh2PrlWaXwxprYQ5Jf4CLVaSlHpYNNxo2ZuvnMLVpXaD/j4TWLmA==
X-Received: by 2002:adf:e984:: with SMTP id h4mr29308639wrm.275.1580914616383;
        Wed, 05 Feb 2020 06:56:56 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a9f0:cbc3:a8a6:fc56? ([2001:b07:6468:f312:a9f0:cbc3:a8a6:fc56])
        by smtp.gmail.com with ESMTPSA id f127sm8396652wma.4.2020.02.05.06.56.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2020 06:56:55 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH] x86: pmu: Test WRMSR on a running counter
To:     Eric Hankland <ehankland@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20200204012504.9590-1-ehankland@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ab91afac-baca-d901-67a7-04979bfcbbfa@redhat.com>
Date:   Wed, 5 Feb 2020 15:56:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200204012504.9590-1-ehankland@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/02/20 02:25, Eric Hankland wrote:
> Ensure that the value of the counter was successfully set to 0 after
> writing it while the counter was running.
> 
> Signed-off-by: Eric Hankland <ehankland@google.com>
> ---
>  x86/pmu.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/x86/pmu.c b/x86/pmu.c
> index cb8c9e3..8a77993 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -419,6 +419,21 @@ static void check_rdpmc(void)
>  	report_prefix_pop();

Queued, thanks.

Paolo

