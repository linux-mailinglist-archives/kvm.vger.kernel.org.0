Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 305785A1BA8
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 23:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243847AbiHYVv3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 17:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244087AbiHYVvJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 17:51:09 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C563214D0F
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 14:51:08 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id p9-20020a17090a2d8900b001fb86ec43aaso6193978pjd.0
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 14:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=6TzZqSTswKWkrKXrw4GvF3KZyrP2u5SV3aBzpxhHj7g=;
        b=hoACoRaN8eK2+RV68v2MdME7o4zVuw7PGUD/yOP93LOvSglTFMhxi3xdQlYtgC9Dp3
         rKopUukowWTmm1TsxxDXFivEfunZqZ42e9d8bMZ8j1FVWjhBshrgprEZUdaq/cK5rVev
         Pnz7Z9f0G53RchzPKGAcYhzj7gvVSbexhMEprTL9neshS7dtyyk+4SZhjmNfqtNxHCFi
         36v21m6CXmcuyfTjjJh36JvgRPb54YqJgg1GhTLO6MZqeUefffJwmyw3nl3cXlRVMuTF
         oVeS2f9ZRJqAOAZSV73ZtxxMApLjsPWJ0H9h6B0dRxM1j/ySbBBaZcmXt6Lcj9CIkBS4
         f6PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=6TzZqSTswKWkrKXrw4GvF3KZyrP2u5SV3aBzpxhHj7g=;
        b=oRUDGnkwlFotlFpcAnqaPCgzzf/1aZDKE+n7bN1OV0Ux6McqwvIbJVhRRhUe6KNbhP
         wX3EAoWjI8w1A/Pi4phrYIO/asHEI5iADnYzGzeDz4Y6/BcL3bwMfnDJ8VAjdK/vux3A
         X8VP75MGOqnMDPWt9cwx/QZ0qd2wkdGxJzuTO3Kal3AoQzKJ1awcd+oB4TcpscCWa30d
         gn1t7fLJ9Io9+W21wOscSgrROBj3Ee0bl3Er9lJxPIYb+LTh2wqttecYF0o97lUBWzwI
         c8xGegWOeK5okk/PHvl2PK2lj/jbeu2AgKk8OYyist/tYFOcN16JHaRcYgt9JRi4jyvd
         SORA==
X-Gm-Message-State: ACgBeo3Gv0VRxgRifQqCMsUh3+Tf2660bOMl8BlSUzHAaOzsaEy3Gw+r
        d4o7eOY5VBGH+4d9av1bnzHd4Q==
X-Google-Smtp-Source: AA6agR66sfUV3BLYXbYmBJjWyhfmcxpKF+KXq9MQ8RCG9OGEd5cBJGLQXuda/cmeE6x1mQ8edV16/w==
X-Received: by 2002:a17:902:bd08:b0:16e:e00c:dd48 with SMTP id p8-20020a170902bd0800b0016ee00cdd48mr972291pls.93.1661464267859;
        Thu, 25 Aug 2022 14:51:07 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id s12-20020a17090302cc00b00172ea8ff334sm63695plk.7.2022.08.25.14.51.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 14:51:07 -0700 (PDT)
Date:   Thu, 25 Aug 2022 21:51:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vasant Karasulli <vkarasulli@suse.de>
Cc:     kvm@vger.kernel.org, Thomas.Lendacky@amd.com, bp@alien8.de,
        erdemaktas@google.com, jroedel@suse.de, marcorr@google.com,
        pbonzini@redhat.com, rientjes@google.com, varad.gautam@suse.com,
        zxwang42@gmail.com
Subject: Re: [kvm-unit-tests PATCH v1] x86: efi: set up the IDT before
 accessing MSRs.
Message-ID: <YwfuxxgGFVDpLOOR@google.com>
References: <20220823094328.8458-1-vkarasulli@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823094328.8458-1-vkarasulli@suse.de>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 23, 2022, Vasant Karasulli wrote:
> Reading or writing MSR_IA32_APICBASE is typically an intercepted
> operation and causes #VC exception when the test is launched as
> an SEV-ES guest.
> 
> So calling pre_boot_apic_id() and reset_apic() before the IDT is
> set up in setup_idt() and load_idt() might cause problems.
> 
> Hence move percpu data setup and reset_apic() call after
> setup_idt() and load_idt().
> 
> Fixes: 3c50214c97f173f5e0f82c7f248a7c62707d8748 (x86: efi: Provide percpu storage)
> Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

>  lib/x86/setup.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/lib/x86/setup.c b/lib/x86/setup.c
> index 7df0256..712e292 100644
> --- a/lib/x86/setup.c
> +++ b/lib/x86/setup.c
> @@ -192,8 +192,6 @@ static void setup_segments64(void)
>  	write_gs(KERNEL_DS);
>  	write_ss(KERNEL_DS);
> 
> -	/* Setup percpu base */
> -	wrmsr(MSR_GS_BASE, (u64)&__percpu_data[pre_boot_apic_id()]);
> 
>  	/*
>  	 * Update the code segment by putting it on the stack before the return
> @@ -322,7 +320,7 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
>  		}
>  		return status;
>  	}
> -
> +

Huh.  This causes a conflict for me.  My local repo has a tab here that is
presumably being removed, but this patch doesn't have anything.  If I manually
add back the tab, all is well.  I suspect your client may be stripping trailing
whitespace.
