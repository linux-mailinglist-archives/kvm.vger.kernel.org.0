Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8E3A240553
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 13:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbgHJLZL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 07:25:11 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:55424 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726379AbgHJLVl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Aug 2020 07:21:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597058494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1wbjRsGzwJSEIgmC6+jZ5HmKMMdsjr2TIwdTADa3P68=;
        b=KJCkJkb0jjDc5tCbiZLFEeDefar3p3nzvGoOgPEWWPsPSYw1iTonmAL1/i0LKaFlUhuRDp
        BzCNj8XPpltMuGLEmHlfsB5xA4rQ584zPNRdKJES/b5h2q3ISLXVEVr73Ia4+E5L7G3HIa
        PR7lGCi5k69zElt5JvmEhT8rf1EyyFE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-mx_32Rv_NMuDkcyHGVZWyA-1; Mon, 10 Aug 2020 07:21:32 -0400
X-MC-Unique: mx_32Rv_NMuDkcyHGVZWyA-1
Received: by mail-wr1-f69.google.com with SMTP id z12so4099672wrl.16
        for <kvm@vger.kernel.org>; Mon, 10 Aug 2020 04:21:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1wbjRsGzwJSEIgmC6+jZ5HmKMMdsjr2TIwdTADa3P68=;
        b=pG/CRQ0tZcRzDHkbEo3iMBadfnbjWbipj7g3wvjOpsbIGD6OkQbgxE4nlmX+zVyu9M
         16IWmB4vklYhFcO8LHCNWhk8r/1UwqNM13mgmt8bvc0SlX0ktdubkGTkzjwkiuGX3m68
         r3dmefvJTW8Fghb1Uqe+l1B/5Xc1e5wPcxhgJs5SGsHJifUsN2RifKW+19hIlvF9ysT3
         FP9PXdF+R0XwGRNo5ZmrckZAduK36WuLOPARk2wTtU7u9T105+7MrxMumw0rO7c50z5G
         0B45YufMLgkdr7Hjx8k8J81EyD2oA7jVg3olmTvtbvoWgY+cgun1uEhQyCE0u08ECKCg
         W5Rg==
X-Gm-Message-State: AOAM532d1FsC8/Za0OBUMl939PBGlMOq6rDrSAiD7ammjhv4uFOEINyl
        NRuLJ/rnYZK14/tTQbOWa632qSAV6tN5qcswKCSPQyUkOEOXf8pMIGYgTml+77m2MfJtxAufXR1
        n4k4mlBhcgBT2
X-Received: by 2002:a1c:4d12:: with SMTP id o18mr24714532wmh.55.1597058491536;
        Mon, 10 Aug 2020 04:21:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy4UxkLVkYR0qaII68uf1rniVKRN+p8dcjGLxPoccx8ZjhNhB4Iqyr7JqQEeHpxQbiDZVqm6Q==
X-Received: by 2002:a1c:4d12:: with SMTP id o18mr24714515wmh.55.1597058491320;
        Mon, 10 Aug 2020 04:21:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5d6c:f50:4462:5103? ([2001:b07:6468:f312:5d6c:f50:4462:5103])
        by smtp.gmail.com with ESMTPSA id o125sm23557595wma.27.2020.08.10.04.21.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 04:21:30 -0700 (PDT)
Subject: Re: [PATCH] kvm: selftests: fix spelling mistake: "missmatch" ->
 "missmatch"
To:     Colin King <colin.king@canonical.com>,
        Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200810101647.62039-1-colin.king@canonical.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bb65571b-555d-c5e6-1242-a12881a13e01@redhat.com>
Date:   Mon, 10 Aug 2020 13:21:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200810101647.62039-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/08/20 12:16, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in an error message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  tools/testing/selftests/kvm/lib/sparsebit.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/sparsebit.c b/tools/testing/selftests/kvm/lib/sparsebit.c
> index 031ba3c932ed..59ffba902e61 100644
> --- a/tools/testing/selftests/kvm/lib/sparsebit.c
> +++ b/tools/testing/selftests/kvm/lib/sparsebit.c
> @@ -1866,7 +1866,7 @@ void sparsebit_validate_internal(struct sparsebit *s)
>  		 * of total bits set.
>  		 */
>  		if (s->num_set != total_bits_set) {
> -			fprintf(stderr, "Number of bits set missmatch,\n"
> +			fprintf(stderr, "Number of bits set mismatch,\n"
>  				"  s->num_set: 0x%lx total_bits_set: 0x%lx",
>  				s->num_set, total_bits_set);
>  
> 

If you have a script that generates the commit message, that needs a
fix. :)  Queued though.

Paolo

