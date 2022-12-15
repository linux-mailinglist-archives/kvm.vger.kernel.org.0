Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57A1764E09D
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 19:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiLOSXY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 13:23:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiLOSXW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 13:23:22 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C0346675
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 10:23:21 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id fa4-20020a17090af0c400b002198d1328a0so6936154pjb.0
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 10:23:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6ps7F2wtazuqd/8UG+Qg+AEGKlpQMHafoSNSpV8XR7M=;
        b=Sfnl4iRnd8fnUUtku+UMxH4iF+MaAdvAcWfbZuQFecO4Lh9TAdpmbzdFBSO/8IFo7W
         KVYadcLURnqDc4ZP6A9zuE8bLgKSTB5d2PDGVYvMzVqVIpJYu7LRF9b6GL2to2u6BLzn
         WHr9XsqVnTYp+1+Zev+myNM0thITfeZRNdnXkjtYaFsmcsXUm96+4PlAGD85EqsO1qwo
         l6C4F400/SNMpkiHGpzELNWEo8dhRGv1SlnDhILIue6UBwc1yj+H9bQgSs+QpJgwFgw+
         4lJmJl28WZGdI9l5IJCPi+WgRzvOaqDNH55hCEj2+WRGz254pdviqZ0Xkt3r2WCeRYCp
         h1ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6ps7F2wtazuqd/8UG+Qg+AEGKlpQMHafoSNSpV8XR7M=;
        b=0itvxMiWfV4HrgDTT07iMOjEPOSQQrGL9ZkzEDMljldBs3v4siUOVAfEnXuNc4AyLZ
         NxOGmhYwsS/2scqumYyjD7t+xPPP7wi3QDHMQOcDmyUKgmQx4CDwWL3rBjQQSME/AdCR
         amFPt47fbRPZJ5wL3oqKq6nIf+3XSnV8S/kJUVvvWWSlaX8jaizRooWZOHA/bN1R55zQ
         WNhjhApzuu0MwY2eSaeVQDIRsS983bTH2LI7QbDEci/EvYIoBh9Ed9Nc/Xe7bq2OhcQi
         lx2Tk+/FvPXq9fORUt8YQAtAWt0/VmuuB10i9u8Jnc6+VfqmOyjh4BP0IN3gP6LF1V96
         /GzA==
X-Gm-Message-State: AFqh2krKjqiC3O/2E2MXK9ZrkS7+GD8O9E7d0xTENWyDUfVX3pPwgK40
        CeiUhjNX7lyvaNFRiiQgpY3N7g==
X-Google-Smtp-Source: AMrXdXuoTNwlK++PEjw1jJrNEkChbZKiM0gyIEsmeH2nJQp28LYdCjlreqRWm6d1ghJQlLMuuN5O2g==
X-Received: by 2002:a05:6a20:6701:b0:a7:882e:3a18 with SMTP id q1-20020a056a20670100b000a7882e3a18mr153717pzh.1.1671128601225;
        Thu, 15 Dec 2022 10:23:21 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f17-20020a170902ce9100b00188c04258c9sm4186679plg.52.2022.12.15.10.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 10:23:20 -0800 (PST)
Date:   Thu, 15 Dec 2022 18:23:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Remove outdated comments in
 nested_vmx_setup_ctls_msrs().
Message-ID: <Y5tmFKPj8ZX2GgUY@google.com>
References: <20221215100558.1202615-1-yu.c.zhang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215100558.1202615-1-yu.c.zhang@linux.intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 15, 2022, Yu Zhang wrote:
> nested_vmx_setup_ctls_msrs() initializes the vmcs_conf.nested,
> which stores the global VMX MSR configurations when nested is
> supported, regardless of any particular CPUID settings for one
> VM.
> 
> Commit 6defc591846d ("KVM: nVMX: include conditional controls
> in /dev/kvm KVM_GET_MSRS") added the some feature flags for
> secondary proc-based controls, so that those features can be
> available in KVM_GET_MSRS. Yet this commit did not remove the
> obsolete comments in nested_vmx_setup_ctls_msrs().
> 
> Just fix the comments, and no functional change intended.
> 
> Fixes: 6defc591846d ("KVM: nVMX: include conditional controls in /dev/kvm KVM_GET_MSRS")
> Reported-by: Sean Christopherson <seanjc@google.com>

I appreciate the nod, but you found this, not me :-)

> Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index b6f4411b613e..76cca5d5aa6b 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -6854,11 +6854,7 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
>  	msrs->procbased_ctls_low &=
>  		~(CPU_BASED_CR3_LOAD_EXITING | CPU_BASED_CR3_STORE_EXITING);
>  
> -	/*
> -	 * secondary cpu-based controls.  Do not include those that
> -	 * depend on CPUID bits, they are added later by
> -	 * vmx_vcpu_after_set_cpuid.
> -	 */
> +	/* secondary cpu-based controls */

Eh, just drop the comment.  Pretty obvious this is for secondary execution controls.

>  	msrs->secondary_ctls_low = 0;
>  
>  	msrs->secondary_ctls_high = vmcs_conf->cpu_based_2nd_exec_ctrl;
> -- 
> 2.17.1
> 
