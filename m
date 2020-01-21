Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5632E143CD8
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 13:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbgAUMaA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 07:30:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48124 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726968AbgAUM37 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jan 2020 07:29:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579609798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ivYbYcO8r0pyGFQ/Sjwf30q/WD5IZx+f3gEYjrbALQk=;
        b=NBBIU4LJP0S0dBo7XTYSud88YOOmsd+9M5zhKQoCxdxMzyxObiW/CWyMnwFnezzRpKfxT1
        SWK+T/QywLj+V4sK2GdgLrtf1pbaQrwZns7G+W8XJ/Atl46PzCejAHIThuGHAyrKnr8nia
        CjKmMa8bTK0RF5K4f0RTdx3DywciYlk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-dC5UvxJ8O52_kZ5s6pQLLw-1; Tue, 21 Jan 2020 07:29:56 -0500
X-MC-Unique: dC5UvxJ8O52_kZ5s6pQLLw-1
Received: by mail-wr1-f72.google.com with SMTP id z15so1258801wrw.0
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2020 04:29:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ivYbYcO8r0pyGFQ/Sjwf30q/WD5IZx+f3gEYjrbALQk=;
        b=t05RyJpUV6Fkh1iWfKgfsF87HkXkTnMjaw24DA7Gl53Jup7nI52m9GE7BGrf1H1SFe
         rPmE4PufvqTP/sPgnl/31N4QVJ0oSPgGxR3OejjmZlIghGoKYaWIDLhk6oWHeUkD/23D
         5INpt0ZMTY6849OyzPLh9l/9RN+roNP7TXjjc7RZnoJRoRJ06Lojja1XjXzyDBBevufB
         EwB5lqyLd1Qx/Y+z070RR84sjsnzMukC/VELQncViaqglMsPxMHiyYbq2MGVVAvHbkOS
         TPCv2GOCI49GLsODvVJVzWnfnpXNVzXDypO6hYvgblMDBXg0e6e8Zr+EYEaheagPyJjW
         GrIQ==
X-Gm-Message-State: APjAAAV1VUPSfjBnmW1594bCax6KfAJz1+m0aC573fDpSNm+nM6AYreE
        V5xk0dOMPak3bfI8qBG7RsTRGi+oYPyd0MljLfZqow1Gxm1xt3EfyaM1ySacqD+QaPH6Lo1tz4p
        7W7d96Gjo/e9t
X-Received: by 2002:a1c:770e:: with SMTP id t14mr4108003wmi.101.1579609795002;
        Tue, 21 Jan 2020 04:29:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqydNnqJSij4k3aEKjoA4ozKsMvex+vGhdbNxwu/R2D21umv1eEh5iWZZeaUz/NtWsjYQmjyqw==
X-Received: by 2002:a1c:770e:: with SMTP id t14mr4107986wmi.101.1579609794794;
        Tue, 21 Jan 2020 04:29:54 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b509:fc01:ee8a:ca8a? ([2001:b07:6468:f312:b509:fc01:ee8a:ca8a])
        by smtp.gmail.com with ESMTPSA id r6sm53506565wrq.92.2020.01.21.04.29.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 04:29:54 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH] x86: VMX: Check EPT AD bits when enabled
 in ept_access_paddr()
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Peter Shier <pshier@google.com>
References: <20191128095422.26757-1-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <07f09d7b-b97d-1cb9-fc7c-417182c82b80@redhat.com>
Date:   Tue, 21 Jan 2020 13:29:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191128095422.26757-1-oupton@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/11/19 10:54, Oliver Upton wrote:
> Modify the test helper, ept_access_paddr(), to test the correctness
> of the L1's EPT AD bits when enabled. After a successful guest access,
> assert that the accessed bit (bit 8) has been set on all EPT entries
> which were used in the translation of the guest-physical address.
> 
> Since ept_access_paddr() tests an EPT mapping that backs a guest paging
> structure, processor accesses are treated as writes and the dirty bit
> (bit 9) is set accordingly. Assert that the dirty bit is set on the leaf
> EPT entry.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  x86/vmx_tests.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index a456bd1..325dde7 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -1135,6 +1135,11 @@ static void ept_disable_ad_bits(void)
>  	vmcs_write(EPTP, eptp);
>  }
>  
> +static int ept_ad_enabled(void)
> +{
> +	return eptp & EPTP_AD_FLAG;
> +}
> +
>  static void ept_enable_ad_bits_or_skip_test(void)
>  {
>  	if (!ept_ad_bits_supported())
> @@ -2500,6 +2505,8 @@ static void ept_access_paddr(unsigned long ept_access, unsigned long pte_ad,
>  	unsigned long *ptep;
>  	unsigned long gpa;
>  	unsigned long orig_epte;
> +	unsigned long epte;
> +	int i;
>  
>  	/* Modify the guest PTE mapping data->gva according to @pte_ad.  */
>  	ptep = get_pte_level(current_page_table(), data->gva, /*level=*/1);
> @@ -2536,6 +2543,17 @@ static void ept_access_paddr(unsigned long ept_access, unsigned long pte_ad,
>  		do_ept_access_op(op);
>  	} else {
>  		do_ept_access_op(op);
> +		if (ept_ad_enabled()) {
> +			for (i = EPT_PAGE_LEVEL; i > 0; i--) {
> +				TEST_ASSERT(get_ept_pte(pml4, gpa, i, &epte));
> +				TEST_ASSERT(epte & EPT_ACCESS_FLAG);
> +				if (i == 1)
> +					TEST_ASSERT(epte & EPT_DIRTY_FLAG);
> +				else
> +					TEST_ASSERT_EQ(epte & EPT_DIRTY_FLAG, 0);
> +			}
> +		}
> +
>  		ept_untwiddle(gpa, /*level=*/1, orig_epte);
>  	}
>  
> 

Queued, thanks.

Paolo

