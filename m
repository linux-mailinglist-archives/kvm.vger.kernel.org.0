Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BEDF640E5B
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 20:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234329AbiLBTWC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 14:22:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234777AbiLBTVv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 14:21:51 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1FD5EF8AA
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 11:21:50 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id n3so1516211pfq.10
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 11:21:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XmGr6IMGfo2tMfDpCqJrMiDrr3EvSVygSViq3ogxpYI=;
        b=Yu90jyYBWPrF58JWX0HHlWqJThjCHQu20npkNI0DigSvcJI2PWbNBGIKbCBuME7NdH
         b6U0QZCURXdmJhHlECGXdeVmkUapasCqblZfrK4k0/nXbSnyOHUWZZypD4pEPMGDVLzo
         PxNZEF3ifgH611Atm+5EYQmxKmrJrF1A0DNXDBou4H8jtGjsulq6SyibBTtABuUiG5Cq
         g1Qt7gEZL0poIEUQKkQjRbK0oqi0e5Bfbx51ELNHyDQxobuYOXrN++nR1ZwgHT3EEn5r
         JV3MTrhMKQHDxxZOBCZSQJ1K/mvMrEeIWVCtcYjv1USN/JY6Di5YkryZdWDLDzV+jjzw
         e+iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XmGr6IMGfo2tMfDpCqJrMiDrr3EvSVygSViq3ogxpYI=;
        b=xfuGQ3cppY5HRF9Qz8vrUejJshvSdtwp0w/3PvOa7XXD98WrmlBHW/zLFrOMW7C3Qo
         PO1TkB3TcCG9uAx57tu9Kr87KV2Kqjm+ellrmj8xln680OYwraJITj/i+QTE+1llBTmf
         rlDE8oWPJFnuLFKPx0eRrmdnXvbkBnjZLrIUOrPTITQTA8/vUteLZ2mjkyzV68rhQShD
         qTZEyWNPEBT/9W9CRoaSovZc1EeoS3rgr3XL4T0A1SGBnWMDul5qXrG3pMcxaB0wUVXE
         QSq8X0y1CuxPLg9jyhGupKK/UVV6N5+xXUFdflveWluHMmcHA7g9ibYPHOIFPeHQKHY1
         ratA==
X-Gm-Message-State: ANoB5pmpsu+kP97uw0Ay9AMJOwTxxn3ua+w/DeeV3BrxlZYr1iSjRVGu
        neIHgJPcmLzzwX6hKl1HYCtJ5g==
X-Google-Smtp-Source: AA0mqf6xcJMEfBB5YbMEy5Eqxv+P3sit8edMqNYtGIiqPUN61aN3+A5Qg8fLH+EPFOfPvinlxqIGDw==
X-Received: by 2002:a63:f241:0:b0:46f:da0:f093 with SMTP id d1-20020a63f241000000b0046f0da0f093mr46647516pgk.441.1670008910077;
        Fri, 02 Dec 2022 11:21:50 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c5-20020a170903234500b0017f48a9e2d6sm5946847plh.292.2022.12.02.11.21.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 11:21:49 -0800 (PST)
Date:   Fri, 2 Dec 2022 19:21:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH v2 0/2] KVM: nVMX: Add IBPB between L2 and L1 to
Message-ID: <Y4pQSnFOQSoB80K1@google.com>
References: <20221019213620.1953281-1-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019213620.1953281-1-jmattson@google.com>
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

On Wed, Oct 19, 2022, Jim Mattson wrote:
> Since L1 and L2 share branch prediction modes (guest {kernel,user}), the
> hardware will not protect indirect branches in L1 from steering by a
> malicious agent in L2. However, IBRS guarantees this protection. (For
> basic IBRS, a value of 1 must be written to IA32_SPEC_CTRL.IBRS after
> the transition  from L2 to L1.)
> 
> Fix the regression introduced in commit 5c911beff20a ("KVM: nVMX: Skip
> IBPB when switching between vmcs01 and vmcs02") by issuing an IBPB when
> emulating a VM-exit from L2 to L1.
> 
> This is CVE-2022-2196.
> 
> v2: Reworded some comments [Sean].
> 
> Jim Mattson (2):
>   KVM: VMX: Guest usage of IA32_SPEC_CTRL is likely
>   KVM: VMX: Execute IBPB on emulated VM-exit when guest has IBRS
> 
>  arch/x86/kvm/vmx/nested.c | 11 +++++++++++
>  arch/x86/kvm/vmx/vmx.c    | 10 ++++++----
>  2 files changed, 17 insertions(+), 4 deletions(-)
> 
> -- 

Merged to kvm/queue, thanks!

https://lore.kernel.org/all/Y4lHxds8pvBhxXFX@google.com
