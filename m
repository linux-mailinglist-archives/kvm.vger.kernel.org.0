Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6515B1B2C6D
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 18:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgDUQRx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 12:17:53 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45545 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726115AbgDUQRw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Apr 2020 12:17:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587485871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5YOZr7Q/X05k6PIRR6Ti/Q1ZNNX9zjeYXgkZzWVXzCY=;
        b=JpGmRU7iZi6zeWA99rEzKjsfoW8GP42Kk885pTqSlH0tqa0ocWCQIlFFDBXcMRHCAt1xMv
        l26rva3lkNwnpT4uA0R3IF+Jxl3cv4ZggW4u2A3JJDDeBMmgqyYNUQizWH+GwrnSaij/m/
        pxxWUJZvZM9NWri+qEjAZ8gJI7xvQHU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-BhFzuvNTNM2QczQf_cHh2A-1; Tue, 21 Apr 2020 12:17:46 -0400
X-MC-Unique: BhFzuvNTNM2QczQf_cHh2A-1
Received: by mail-wr1-f71.google.com with SMTP id f15so7806524wrj.2
        for <kvm@vger.kernel.org>; Tue, 21 Apr 2020 09:17:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5YOZr7Q/X05k6PIRR6Ti/Q1ZNNX9zjeYXgkZzWVXzCY=;
        b=cfKL2G14vdDX8FVrfgo1QtEKUTrk4abMhFD4HROLXfI1oIhoUWK1t7txG120Iwi/ak
         EXaGQe8mu8XBoSh1wrzaBDlBZ04w84GHM5zjszPS+h97Uf/9GosdtNEdDGElqIkeEtvF
         z/XRc+GR12TpJkNKWqnXQRYLkWLZoCy2AkKxnqoJ158PYKXZsGC5O+xCDP5zjw1+KFfh
         vRhOyVpewFW6q48GUDJHqZWJ3vW3DCmwYzWTHy5pBmkgbbpxWVmOA/mKewQpWUXZIxvn
         H2PNR114ZG8QxcxW0a5hROrHocQSPpYwU9gJlBwnkU5lCgLceKp67vg+ZUag5RbbDCwo
         hyPA==
X-Gm-Message-State: AGi0PuaI39wQnreuI0Y8wugGHjZMIFEQmysVsPuOxrtQ8ou8Vxc2NxE1
        wfck9lV/OY5H8i7leoZ0oleAi1FrjHWYCOXur7zq33a1mvfdgcErgp2/ATXio6K+A51s38iwpJ8
        GzKHI/3hyk96q
X-Received: by 2002:adf:fe87:: with SMTP id l7mr26529214wrr.360.1587485865755;
        Tue, 21 Apr 2020 09:17:45 -0700 (PDT)
X-Google-Smtp-Source: APiQypKbKncUpUwr20eI1sz6jN6M23/dxN3/OK5Gt4PhqaDb+opQx0nuEGQfx/4CSKV3tBaqY6UMmA==
X-Received: by 2002:adf:fe87:: with SMTP id l7mr26529200wrr.360.1587485865505;
        Tue, 21 Apr 2020 09:17:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f43b:97b2:4c89:7446? ([2001:b07:6468:f312:f43b:97b2:4c89:7446])
        by smtp.gmail.com with ESMTPSA id t17sm4358952wro.2.2020.04.21.09.17.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2020 09:17:44 -0700 (PDT)
Subject: Re: [PATCH] kvm-unit-tests: nSVM: Test that CR0[63:32] are not set on
 VMRUN of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
References: <20200420225825.3184-1-krish.sadhukhan@oracle.com>
 <20200420225825.3184-2-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <efc415c5-40c6-3cc5-016d-cefb512199a2@redhat.com>
Date:   Tue, 21 Apr 2020 18:17:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200420225825.3184-2-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/04/20 00:58, Krish Sadhukhan wrote:
> According to section "Canonicalization and Consistency Checks" in APM vol. 2,
> the following guest state is illegal:
> 
> 	"CR0[63:32] are not zero."
> 
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> ---
>  x86/svm_tests.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index 8bdefc5..3bfa484 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -1387,6 +1387,20 @@ static void svm_guest_state_test(void)
>  	vmcb->save.cr0 = cr0;
>  	report (svm_vmrun() == SVM_EXIT_ERR, "CR0: %lx", cr0);
>  	vmcb->save.cr0 = cr0_saved;
> +
> +	/*
> +	 * CR0[63:32] are not zero
> +	 */
> +	int i;
> +
> +	cr0 = cr0_saved;
> +	for (i = 32; i < 63; i = i + 4) {
> +		cr0 = cr0_saved | (1ull << i);
> +		vmcb->save.cr0 = cr0;
> +		report (svm_vmrun() == SVM_EXIT_ERR, "CR0[63:32]: %lx",
> +		    cr0 >> 32);
> +	}
> +	vmcb->save.cr0 = cr0_saved;
>  }
>  
>  struct svm_test svm_tests[] = {
> 

Applied, thanks.

Paolo

