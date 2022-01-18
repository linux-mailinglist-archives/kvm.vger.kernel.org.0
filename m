Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0815E492851
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 15:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241940AbiAROYq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 09:24:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245426AbiAROYp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 09:24:45 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD43C061574;
        Tue, 18 Jan 2022 06:24:45 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id z22so80265825edd.12;
        Tue, 18 Jan 2022 06:24:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+w5G8meNUkhztVlqkGH1G1hRy+J0BOZ5F75gNYn8zLU=;
        b=mPGgCaJPHHFi4+XvczvV4IE0ZryBI8nlHttMEzS8I3trQL3ECU7YuiGYIUq3XRcp9S
         TQFvZUOMQ4XvdrHdU9coE+UpAc1hpz9yIGQn/DzeZJy3ssk/hDXIZ1tvq5ZTfbcaJSVf
         jcosAJmdORhGfue8u+nubxQS0P5FizLDrWd//T8yddEjZ3q8WdrGxKygqYHwA/eUvXlU
         p1saycr9wE7cun8UW+ZeMKkw5HzahHUl24tScDTVS1qI6ZV0c5Qoz8WQ2NWi+IiIwwsA
         amrYxs90mJv9yZFN7you3RajqXXUR57mjFYzywwuGAputsKnlDas4xCSmHuztpMXejXx
         v/Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+w5G8meNUkhztVlqkGH1G1hRy+J0BOZ5F75gNYn8zLU=;
        b=gGlraiYVbNd5IapCbGqP3ZBY+UFr3p18MMwLxR3O0gb9EoQav8k06I5kHdAoLtocc0
         z1DWT0Yp53xPQAHkw2/ZPUdV+S1YAxA+0xqDFAI3qT09Oagc8F00SMvC79/H2Wj5bbnt
         rWdS0GYuTxQEZT+t5kNGh/REQZi7/vQWDiQm0PDMH59WZYdBSYHyxI9YcJqN6m37n8hs
         0mbxNLadNbX+WycYzNyEYKQQVz6AhVC8C+6KfaTqjtK3EaZXJ/rZ6cbzrRwS6Qe5QhtM
         5x4CjrmDeZCaXtfQRR1qUYizfI0AQnGd5fkU8Rre/ohU8+y5qY32da0Z1p2C7HJcntpZ
         IaqQ==
X-Gm-Message-State: AOAM5316UM7LtkCmJnRGWuENHK7K8IApcQuC/psqY7fkQFRxVS4V4bkp
        hbbnIYs+YgFgPFPoOOTv2cxqS3jmQP4=
X-Google-Smtp-Source: ABdhPJxjTeGRzL3RdKO+B5/APk1sWMOrpa1fNRqUichOxYnNcXc16UhLYl12L+g6/ABCrmTq6f7sNw==
X-Received: by 2002:aa7:c6d7:: with SMTP id b23mr24748353eds.277.1642515883562;
        Tue, 18 Jan 2022 06:24:43 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id h11sm12361eja.119.2022.01.18.06.24.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 06:24:42 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <743735a5-e9fb-1ae8-27d9-048d35148a38@redhat.com>
Date:   Tue, 18 Jan 2022 15:24:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [kvm-unit-tests PATCH] scripts/arch-run: Mark migration tests as
 SKIP if ncat is not available
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        Laurent Vivier <lvivier@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvm-ppc@vger.kernel.org, Eric Auger <eric.auger@redhat.com>
References: <20211221092130.444225-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211221092130.444225-1-thuth@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/21/21 10:21, Thomas Huth wrote:
> Instead of failing the tests, we should rather skip them if ncat is
> not available.
> While we're at it, also mention ncat in the README.md file as a
> requirement for the migration tests.
> 
> Resolves: https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/issues/4
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>   README.md             | 4 ++++
>   scripts/arch-run.bash | 2 +-
>   2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/README.md b/README.md
> index 6e6a9d0..a82da56 100644
> --- a/README.md
> +++ b/README.md
> @@ -54,6 +54,10 @@ ACCEL=name environment variable:
>   
>       ACCEL=kvm ./x86-run ./x86/msr.flat
>   
> +For running tests that involve migration from one QEMU instance to another
> +you also need to have the "ncat" binary (from the nmap.org project) installed,
> +otherwise the related tests will be skipped.
> +
>   # Tests configuration file
>   
>   The test case may need specific runtime configurations, for
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 43da998..cd92ed9 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -108,7 +108,7 @@ run_migration ()
>   {
>   	if ! command -v ncat >/dev/null 2>&1; then
>   		echo "${FUNCNAME[0]} needs ncat (netcat)" >&2
> -		return 2
> +		return 77
>   	fi
>   
>   	migsock=$(mktemp -u -t mig-helper-socket.XXXXXXXXXX)

Queued, thanks.

Paolo
