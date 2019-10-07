Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18417CE65C
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2019 17:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbfJGPEe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Oct 2019 11:04:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34834 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727490AbfJGPEd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Oct 2019 11:04:33 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7173C3D95A
        for <kvm@vger.kernel.org>; Mon,  7 Oct 2019 15:04:33 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id n18so7650769wro.11
        for <kvm@vger.kernel.org>; Mon, 07 Oct 2019 08:04:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YEg7lP4ev+eAmAASdNoP10CUj57rL6PdHoSSAKLurOY=;
        b=rniemfl+86XxX7Tr0qjXcxiv4yKZCfIJciHo/+xcVO8rXfhU6gRTo7DXS7qJEIN5q/
         AeTi+7r6uVwT8xHZGyj2HwJ68zAbKaD1PYdPrLXrS0/Us6HaAmQSGCb8kr5D3SRhPNDs
         dPyJBQDAoZkwXU6FGckhYbxfdEBsdjww47JB0lulQMHpGIv4Mn141u9V9ycGPCMdO3Gi
         O5f34HEdn2nefEfImw8ceeI04Pj46F9pvdVJZH5sF7TOilIvnXmfV+oiqKl+dln3h3LV
         PrOuuXawqepN5qys7IbpuIqr7CzdVZwRmtI4UqnS4Okw5xda2/GagtY+JxX774TSm6JA
         vbxw==
X-Gm-Message-State: APjAAAU50kCgmmb+j7J6LAaozK3hmu7h3PRsDPc08M4YMCv2SzCDlbiO
        Vhc1kzhlNmtGutnRGUc8XnAdy5dhAWVqe4cZWo+tWCrVzfOTdvHLu9p1U7w6SKST4lmmGITXgaf
        1gSrb7cHOWlVO
X-Received: by 2002:adf:f58c:: with SMTP id f12mr19924705wro.38.1570460672081;
        Mon, 07 Oct 2019 08:04:32 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzbyjiYR4AmtE+5fVQPV+uPZDcw6cypBQAOklECNdtSUHSRDFZcE+tmq5pGKtPDMoWdHRURJw==
X-Received: by 2002:adf:f58c:: with SMTP id f12mr19924688wro.38.1570460671800;
        Mon, 07 Oct 2019 08:04:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9dd9:ce92:89b5:d1f2? ([2001:b07:6468:f312:9dd9:ce92:89b5:d1f2])
        by smtp.gmail.com with ESMTPSA id a71sm13969531wme.11.2019.10.07.08.04.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2019 08:04:31 -0700 (PDT)
Subject: Re: [PATCH] selftests: kvm: synchronize .gitignore to Makefile
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <20191007132656.19544-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <19953c09-96c1-0b7b-9146-3ad38bb765b6@redhat.com>
Date:   Mon, 7 Oct 2019 17:04:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191007132656.19544-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/10/19 15:26, Vitaly Kuznetsov wrote:
> Because "Untracked files:" are annoying.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  tools/testing/selftests/kvm/.gitignore | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index b35da375530a..409c1fa75e03 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -1,4 +1,5 @@
>  /s390x/sync_regs_test
> +/s390x/memop
>  /x86_64/cr4_cpuid_sync_test
>  /x86_64/evmcs_test
>  /x86_64/hyperv_cpuid
> @@ -9,6 +10,7 @@
>  /x86_64/state_test
>  /x86_64/sync_regs_test
>  /x86_64/vmx_close_while_nested_test
> +/x86_64/vmx_dirty_log_test
>  /x86_64/vmx_set_nested_state_test
>  /x86_64/vmx_tsc_adjust_test
>  /clear_dirty_log_test
> 

Queued, thanks.

Paolo
