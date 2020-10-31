Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B472A1801
	for <lists+kvm@lfdr.de>; Sat, 31 Oct 2020 14:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727708AbgJaNzd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 31 Oct 2020 09:55:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34952 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727672AbgJaNzc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 31 Oct 2020 09:55:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604152530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hh4MsCm2rBowc2pjMMqCIiyjHN9eExNYCxDhkaiPBbs=;
        b=Ml9fpt3WNOpBu/6zDScTC7u6AT2FANV9wGZOxV95/vyAwRyiPKUgGhPyk7x+1qpF+TyTQZ
        X7cDkFGIyKf5uI/56I2dzdPXETZqYH6pnkTD7lPgogVUhBVYu/jwnSfSR2BcDVzYwugcUA
        FJS5bC+CDp8XDq/Qm8rK/AGEoAN4SYE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-DN27Dgg0MoG46ha6C63GsQ-1; Sat, 31 Oct 2020 09:55:28 -0400
X-MC-Unique: DN27Dgg0MoG46ha6C63GsQ-1
Received: by mail-wr1-f70.google.com with SMTP id h8so4047603wrt.9
        for <kvm@vger.kernel.org>; Sat, 31 Oct 2020 06:55:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Hh4MsCm2rBowc2pjMMqCIiyjHN9eExNYCxDhkaiPBbs=;
        b=a9shp3k53KTt5weVZrmQlm0YE1Ug/wGQyMvqomCF2GgtaaJnk4rnsuQ4IY+K1W8zoq
         sH27xEuhX+DLuuREBIitanAgOsa8h7cSlw079MRdOz70BZ13vHmQ7UEpPV54LZZI24TG
         1R9BA0INvCPVYyYKBdFR0/E6fdSZnavZpaLwWoKioePFcLy1tcv8BLGds3sCR4EKOc31
         0ugG/kEx+6UDuCAdZo2IgPk7+1ma5dAeWlBtbAfEivZWNlEe5yNpoKE8xsAbfCx9qaAj
         pXZaioSkqls4R0S1uElhUESh6wK0uK6jwX9bvhwFN6XHGu1ibbkh2BblBQonGj+LSUzA
         J+3Q==
X-Gm-Message-State: AOAM5331UW38fidknRL4/6qyh35djxvdjSIxFYxyZ8B+/Kli60lR2wTe
        Ch13RiaRbWzBrRFSfAsgrGRTK+5mlUmZfOpKZ/aHYRVAVPrMAzfEMh+7Cf2jUhRusXOqfgSVzTa
        bwzTJT3LkgLRV
X-Received: by 2002:adf:e685:: with SMTP id r5mr10214299wrm.340.1604152527439;
        Sat, 31 Oct 2020 06:55:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz/zRoa3ciao6dX4d4rXMA8Z8IaTOXE7RIH3nKoTQcFc9m9R0J91Lam2HxjoxvtgTczq4a4vQ==
X-Received: by 2002:adf:e685:: with SMTP id r5mr10214282wrm.340.1604152527211;
        Sat, 31 Oct 2020 06:55:27 -0700 (PDT)
Received: from [192.168.178.64] ([151.20.250.56])
        by smtp.gmail.com with ESMTPSA id l1sm16155386wrb.1.2020.10.31.06.55.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Oct 2020 06:55:26 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 2/2] x86: svm: Add test for L2 change of
 CR4.OSXSAVE
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Ricardo Koller <ricarkol@google.com>,
        Peter Shier <pshier@google.com>
References: <20201029171024.486256-1-jmattson@google.com>
 <20201029171024.486256-2-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ff7e75cf-02ed-5abf-a30f-73f9e9c0516b@redhat.com>
Date:   Sat, 31 Oct 2020 14:55:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201029171024.486256-2-jmattson@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/10/20 18:10, Jim Mattson wrote:
> If L1 allows L2 to modify CR4.OSXSAVE, then L0 kvm recalculates the
> guest's CPUID.01H:ECX.OSXSAVE bit when the L2 guest changes
> CR4.OSXSAVE via MOV-to-CR4. Verify that kvm also recalculates this
> CPUID bit when loading L1's CR4 from the save.cr4 field of the
> hsave area.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Ricardo Koller <ricarkol@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> ---
>  x86/svm_tests.c | 35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index 3b0424a..e2455c8 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -1917,6 +1917,40 @@ static bool reg_corruption_check(struct svm_test *test)
>   * v2 tests
>   */
>  
> +/*
> + * Ensure that kvm recalculates the L1 guest's CPUID.01H:ECX.OSXSAVE
> + * after VM-exit from an L2 guest that sets CR4.OSXSAVE to a different
> + * value than in L1.
> + */
> +
> +static void svm_cr4_osxsave_test_guest(struct svm_test *test)
> +{
> +	write_cr4(read_cr4() & ~X86_CR4_OSXSAVE);
> +}
> +
> +static void svm_cr4_osxsave_test(void)
> +{
> +	if (!this_cpu_has(X86_FEATURE_XSAVE)) {
> +		report_skip("XSAVE not detected");
> +		return;
> +	}
> +
> +	if (!(read_cr4() & X86_CR4_OSXSAVE)) {
> +		unsigned long cr4 = read_cr4() | X86_CR4_OSXSAVE;
> +
> +		write_cr4(cr4);
> +		vmcb->save.cr4 = cr4;
> +	}
> +
> +	report(cpuid_osxsave(), "CPUID.01H:ECX.XSAVE set before VMRUN");
> +
> +	test_set_guest(svm_cr4_osxsave_test_guest);
> +	report(svm_vmrun() == SVM_EXIT_VMMCALL,
> +	       "svm_cr4_osxsave_test_guest finished with VMMCALL");
> +
> +	report(cpuid_osxsave(), "CPUID.01H:ECX.XSAVE set after VMRUN");
> +}
> +
>  static void basic_guest_main(struct svm_test *test)
>  {
>  }
> @@ -2301,6 +2335,7 @@ struct svm_test svm_tests[] = {
>      { "reg_corruption", default_supported, reg_corruption_prepare,
>        default_prepare_gif_clear, reg_corruption_test,
>        reg_corruption_finished, reg_corruption_check },
> +    TEST(svm_cr4_osxsave_test),
>      TEST(svm_guest_state_test),
>      { NULL, NULL, NULL, NULL, NULL, NULL, NULL }
>  };
> 

Queued both, thanks.

Paolo

