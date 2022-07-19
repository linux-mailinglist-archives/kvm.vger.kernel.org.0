Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5890B578EBB
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 02:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbiGSAJR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 20:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236223AbiGSAJH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 20:09:07 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C9FEB0
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 17:09:06 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id fz10so13220347pjb.2
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 17:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aL26XSe7TlyFx0R1ZNuZYZl6oihQKckpfly/lvNScXs=;
        b=dzoOBAaUlg5xVdN3BP2tUxwQlT+n4KoLrreNTvI2qUqJpz1hW8Z1JX0yid8uIoXmk8
         05e5n7iMPJT1wFNQTyeP7CGZrnBp0kldRIrOUdwDrTQ1im4uQTFZDL9m2/SFWNMvs5VW
         zLgsR6cyw3CJ4UTGKHVSlzoxSmyyHrEmhQi8KIQ7hPQIiarQaSqicJes8+sHEQjrddkv
         264rS8Wsrk3KfQs3eczpHUA9yUWOD1dDuzMXyqxubkPwVaygtrb7RDort6xHxddEBoHM
         WsCpR02MDDt9mzXVWWlrYPVSn+u+Dl4e4jpMYmxXl+QwdkpnpkyFvcH1Ggskh+rsbFVp
         bl3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aL26XSe7TlyFx0R1ZNuZYZl6oihQKckpfly/lvNScXs=;
        b=zRrL8bH0DF4CA1uwydFBbeyCIdBQTYGelrOnWiYD2pZ4SOz6VYWpbjOmNw8MqxN86/
         G+V/p5+yhGltdxO9IAFXOdkY4iKNH+oCvpVkgl/Kr6zPfiyz01SHtp87zMTRyA1I2MMq
         4ptAIZzmycTAAul4KwaUO5P5Ua7S8L+4XxJS18lCFMwCnLYBgCvNQ8RknqEXSEwTwALx
         Mmvk7aef0mK5Mb4bwYLlt119lnJPYdlw9ANYrA/fpNLE20R600QiMjtaVWO0UdfhZGta
         6OGWLzFIYQe5dm5gZ7QHCaG1Kg3X1aep5tG7K+qcwaayKFbXrRkqy6pprY7TafZ7xG4Y
         myPg==
X-Gm-Message-State: AJIora/s0NW2AYczshxpD2NVxFMbiIuiXqZXD5J/LvAv86LrhY1mVpA2
        cvTOSfA8S50DaTsy2m7sOqIMSw==
X-Google-Smtp-Source: AGRyM1sVkGwJrw5bf7DBV8J9y7oBOIYgpIKih3kt8i4DiRq27MykyJW0SM4PA/wKU8niE/892pIl8g==
X-Received: by 2002:a17:902:e5c6:b0:16c:3c8d:3804 with SMTP id u6-20020a170902e5c600b0016c3c8d3804mr30057695plf.30.1658189345534;
        Mon, 18 Jul 2022 17:09:05 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id k4-20020a170902ce0400b0016c4e4538c9sm10011237plg.7.2022.07.18.17.09.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 17:09:05 -0700 (PDT)
Date:   Tue, 19 Jul 2022 00:09:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, jmattson@google.com,
        joro@8bytes.org, wanpengli@tencent.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: X86: Fix the comments in prepare_vmcs02_rare()
Message-ID: <YtX2HbOI+QO3+2+J@google.com>
References: <20220715114211.53175-1-yu.c.zhang@linux.intel.com>
 <20220715114211.53175-3-yu.c.zhang@linux.intel.com>
 <YtGOL4jIMQwoW5vb@google.com>
 <20220718075815.enldntoehbiphhpv@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718075815.enldntoehbiphhpv@linux.intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 18, 2022, Yu Zhang wrote:
> On Fri, Jul 15, 2022 at 03:56:31PM +0000, Sean Christopherson wrote:
> > On Fri, Jul 15, 2022, Yu Zhang wrote:
> > Oof!  I was going to respond with a variety of nits (about the existing comment),
> > and even suggest that we address the TODO just out of sight, but looking at all
> > of this made me realize there's a bug here!  vmx_update_exception_bitmap() doesn't
> > update MASK and MATCH!
> > 
> > Hitting the bug is extremely unlikely, as it would require changing the guest's
> > MAXPHYADDR via KVM_SET_CPUID2 _after_ KVM_SET_NESTED_STATE, but before KVM_RUN
> > (because KVM now disallows changin CPUID after KVM_RUN).
> > 
> > During KVM_SET_CPUID2, KVM will invoke vmx_update_exception_bitmap() to refresh
> > the exception bitmap to handle the ept=1 && allow_smaller_maxphyaddr=1 scenario.
> > But when L2 is active, vmx_update_exception_bitmap() assumes vmcs02 already has
> > the correct MASK+MATCH because of the "clear both if KVM and L1 both want #PF"
> > behavior.  But if KVM's desire to intercept #PF changes from 0=>1, then KVM will
> > run L2 with the MASK+MATCH from vmcs12 because vmx_need_pf_intercept() would have
> > returned false at the time of prepare_vmcs02_rare().
> 
> And then the #PF could be missed in L0 because previously both L1 and L0 has no
> desire to intercept it, meanwhile KVM fails to update this after migration(I guess
> the only scenario for this to happen is migration?). Is this understanding correct? 

Yes, I think that will be the scenario (I hadn't thought too much about the actual
result).

> > Fixing the bug is fairly straightforward, and presents a good opportunity to
> > clean up the code (and this comment) and address the TODO.
> > 
> > Unless someone objects to my suggestion for patch 01, can you send a new version
> > of patch 01?  I'll send a separate series to fix this theoretical bug, avoid
> > writing MASK+MATCH when vmcs0x.EXCEPTION_BITMAP.PF+0, and to address the TODO.
> 
> Sure, I will send another version of patch 01.
> 
> > 
> > E.g. I believe this is what we want to end up with:
> > 
> > 	if (vmcs12)
> > 		eb |= vmcs12->exception_bitmap;
> > 
> > 	/*
> > 	 * #PF is conditionally intercepted based on the #PF error code (PFEC)
> > 	 * combined with the exception bitmap.  #PF is intercept if:
> > 	 *
> > 	 *    EXCEPTION_BITMAP.PF=1 && ((PFEC & MASK) == MATCH).
> > 	 *
> > 	 * If any #PF is being intercepted, update MASK+MATCH, otherwise leave
> > 	 * them alone they do not affect interception (EXCEPTION_BITMAP.PF=0).
> > 	 */
> > 	if (eb & (1u << PF_VECTOR)) {
> > 		/*
> > 		 * If EPT is enabled, #PF is only intercepted if MAXPHYADDR is
> > 		 * smaller on the guest than on the host.  In that case, KVM
> > 		 * only needs to intercept present, non-reserved #PF.  If EPT
> > 		 * is disabled, i.e. KVM is using shadow paging, KVM needs to
> > 		 * intercept all #PF.  Note, whether or not KVM wants to
> > 		 * intercept _any_ #PF is handled below.
> > 		 */
> > 		if (enable_ept) {
> > 			pfec_mask = PFERR_PRESENT_MASK | PFERR_RSVD_MASK;
> > 			pfec_match = PFERR_PRESENT_MASK;
> > 		} else {
> > 			pfec_mask = 0;
> > 			pfec_match = 0;
> > 		}
> > 
> > 		if (!(vmcs12->exception_bitmap & (1u << PF_VECTOR))) {
> > 			/* L1 doesn't want to intercept #PF, use KVM's MASK+MATCH. */
> > 		} else if (!kvm_needs_pf_intercept) {
> > 			/* KVM doesn't want to intercept #PF, use L1's MASK+MATCH. */
> > 			pfec_mask = vmcs12->page_fault_error_code_mask;
> > 			pfec_match = vmcs12->page_fault_error_code_match;
> > 		} else if (pfec_mask != vmcs12->page_fault_error_code_mask ||
> > 			   pfec_match != vmcs12->page_fault_error_code_mask) {
> > 			/*
> > 			 * KVM and L1 want to intercept #PF with different MASK
> > 			 * and/or MATCH.  For simplicity, intercept all #PF by
> > 			 * clearing MASK+MATCH.  Merging KVM's and L1's desires
> > 			 * is quite complex, while the odds of meaningfully
> > 			 * reducing what #PFs are intercept are low.
> > 			 */
> > 			pfec_mask = 0;
> > 			pfec_match = 0;
> > 		} else {
> > 			/* KVM and L1 have identical MASK+MATCH. */
> > 		}
> > 		vmcs_write32(PAGE_FAULT_ERROR_CODE_MASK, pfec_mask);
> > 		vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH, pfec_match);
> > 	}
> 
> And we do not need to update the PFEC_MASK & PFEC_MATCH in prepare_vmcs02_rare()
> anymore, right? Thanks!

Yep!

Also, IIRC I have a goof or two in the above, i.e. don't waste any time trying to test it.
