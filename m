Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D81E17AD3D
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 18:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgCER27 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 12:28:59 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27526 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726049AbgCER27 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 12:28:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583429338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ceF3GiUSQK1WEq8w5MgfVzcliLUcA5FO9ZKOb5pgtv0=;
        b=ZMWXkI0zPhxvURTRzBbDivlJnQC9sUmU7AXFc1zubi9V3uAWQBo71w6v6nhvL03yozD38/
        Jc4aGw2bbLBFYRI2xmQIguDokm25daAcoNYvVhWebT+W1IyyDsKitNSFnZiHaJoYFzLU5u
        vDhKswLMHgdc49Ho1WmbEW/vLAsfaVs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-zdol9FGxPg-n7qACMpVp1Q-1; Thu, 05 Mar 2020 12:28:56 -0500
X-MC-Unique: zdol9FGxPg-n7qACMpVp1Q-1
Received: by mail-wr1-f72.google.com with SMTP id m18so2537853wro.22
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2020 09:28:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ceF3GiUSQK1WEq8w5MgfVzcliLUcA5FO9ZKOb5pgtv0=;
        b=ZpMQRgGho+1jQfQDA8ICTE3K5loixU05xnEjuLYm45OO2lu4Zcz4OLv/Pv5LUN6YRa
         WySgGVQy85i9mGD738cJ6DQJs2xKqEG33b36HyTV42QUxgZQ1nP7EZMUfPaI8knC7WQj
         UDnSz/BIQASpCiP3jjHtf9v2A40Lv5LlWrdbP1mK8joufNsELTD7LhuAHKJ3PNReMw5x
         pRKMKVE3sMdWPJHKOJ2JaENRiSqBX26NFDKklPbEQGQpWazmH2Me+HsotWon77DskMGS
         MnMhu+SCJFifoU4+f6HUboNSRT4ZiM8bIE8CXoVgZq4T3Ry8vX1buHCrKD8N2C2XAweI
         9b7Q==
X-Gm-Message-State: ANhLgQ1AKMExuLOV+cdYg84z69LTbskThcfl7mUGQpHJ7khPWUxPqFQs
        n1G7L7PcPapg8W9XoHG0a8ygsbTfnRPysGBnLj+g7xOu+HkQa+6OIHRC0Jp/bU4cL+kKxkrERSK
        JHtFgRq0wwaNk
X-Received: by 2002:adf:a505:: with SMTP id i5mr3858wrb.33.1583429335374;
        Thu, 05 Mar 2020 09:28:55 -0800 (PST)
X-Google-Smtp-Source: ADFU+vsQoFH7kzyx+gM+glwSlc10vMgCj0V9akWbUaOT9igFNEYotJGKzGObcS79C1ILPoEQ5igBZg==
X-Received: by 2002:adf:a505:: with SMTP id i5mr3844wrb.33.1583429335147;
        Thu, 05 Mar 2020 09:28:55 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:9def:34a0:b68d:9993? ([2001:b07:6468:f312:9def:34a0:b68d:9993])
        by smtp.gmail.com with ESMTPSA id o8sm9617441wmh.15.2020.03.05.09.28.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Mar 2020 09:28:54 -0800 (PST)
Subject: Re: [RFC PATCH 0/1] kvm: selftests: Add TEST_FAIL macro
To:     Wainer dos Santos Moschetta <wainersm@redhat.com>,
        kvm@vger.kernel.org
Cc:     shuah@kernel.org, tglx@linutronix.de, thuth@redhat.com,
        sean.j.christopherson@intel.com, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200305172532.9360-1-wainersm@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e7bacea1-6964-aeb2-633e-371ad1231881@redhat.com>
Date:   Thu, 5 Mar 2020 18:28:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200305172532.9360-1-wainersm@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/03/20 18:25, Wainer dos Santos Moschetta wrote:
> The following patch's commit message is self-explanatory about this proposal.
> 
> I adjusted to use TEST_FAIL only a few source files, in reality it will
> need to change all the ones listed below. I will proceed with the
> adjustments if this new macro idea is accepted.
> 
> $ find . -type f -name "*.c" -exec grep -l "TEST_ASSERT(false" {} \;
> ./lib/kvm_util.c
> ./lib/io.c
> ./lib/x86_64/processor.c
> ./lib/aarch64/ucall.c
> ./lib/aarch64/processor.c
> ./x86_64/vmx_dirty_log_test.c
> ./x86_64/state_test.c
> ./x86_64/vmx_tsc_adjust_test.c
> ./x86_64/svm_vmcall_test.c
> ./x86_64/evmcs_test.c
> ./x86_64/vmx_close_while_nested_test.c
> 
> Wainer dos Santos Moschetta (1):
>   kvm: selftests: Add TEST_FAIL macro
> 
>  tools/testing/selftests/kvm/dirty_log_test.c             | 7 +++----
>  tools/testing/selftests/kvm/include/test_util.h          | 3 +++
>  tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c | 4 ++--
>  3 files changed, 8 insertions(+), 6 deletions(-)
> 

Yes, why not.

Paolo

