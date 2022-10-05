Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F09E5F5B94
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 23:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiJEVSD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 17:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiJEVSB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 17:18:01 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B72682608
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 14:18:00 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id o9-20020a17090a0a0900b0020ad4e758b3so3137927pjo.4
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 14:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xHwaHLvCRoxdzhv7DmmwKONfeJUv2k+/PmeuTCRRIrQ=;
        b=EV69oa++c0Tq4nsdwppydfdgmaL/QXt9xNACcx1oZtoSfaINpMf2WoHeiBTy4TejWe
         T28k21oxMcMoL0AClknl+bYCG88ayFLXgPcDcCe/Vbz4hf7dXR2pT2zkOA7fnkMXPva0
         3T0JJ3MkhUfOKZ/cYe+6KCC+ask4GgiRBzowGZ7Abs2lkPqik+edWjxGOOOT9P/E+M+W
         eMGOcz1ozbsgyGQogQGw1jvPPqYvk1cXgPh5iaq2bDzxkUHzlu0FNpXLo1UyjharzuY/
         H85CqWhoJwIpjqDcN60wN22sbnl2FRLKyDycaGzMZaOBZ3pjqGl74wWrcl488uXBb6R/
         ss9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xHwaHLvCRoxdzhv7DmmwKONfeJUv2k+/PmeuTCRRIrQ=;
        b=pLFkHUjRrMacPrRBuNljldM4DV4sNiKx017rQWoWqGCuBbO/MJTa7g3yTaZGitiEzS
         gvSewWUUWtqQnIiMDO/tIfJ26RfVrX6tjmn8U8ZNqSVzt1OiwXSjqIenCdN2cZp4lM1d
         rDNU7z3sTIiVff8zaz4suikZh/jEJKCI6O1gCy4FwqnJgJiciJq/9Va8z/c2VTvQdcRL
         g7t73RwqziSWqqfolOUjoPD1hxKdYnWMmH/6lMB5zQDO/FRktXVt3RtFgy63AGid3mQh
         gq/+uCRznrP+RCT28BXd3S4W289q4pAT+WM+ml7dF6dPbl5wiGTcdGqsmErCWH8KXV5k
         85rA==
X-Gm-Message-State: ACrzQf0i6jIwM3e3ViRky7m6B5nE06Xuy2acEI7Tx8YJb/hwOm6f0+Zd
        qgRbyKe7+B1OnE//QGSeunJlSQ==
X-Google-Smtp-Source: AMsMyM71fxbn1KpjTzoyPv+TviHNmt2QO6pbBAJXfydOuvg8XlAPBk7rBMc8ryAibaTpBP5Shm3MmQ==
X-Received: by 2002:a17:90b:4b89:b0:20a:c168:6865 with SMTP id lr9-20020a17090b4b8900b0020ac1686865mr1705555pjb.130.1665004679843;
        Wed, 05 Oct 2022 14:17:59 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d2-20020a655ac2000000b0043ba3d6ea3fsm198913pgt.54.2022.10.05.14.17.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 14:17:59 -0700 (PDT)
Date:   Wed, 5 Oct 2022 21:17:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Manali Shukla <manali.shukla@amd.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, aaronlewis@google.com
Subject: Re: [kvm-unit-tests PATCH v2 4/4] x86: nSVM: Move part of #NM test
 to exception test framework
Message-ID: <Yz30g71onyicnu0Y@google.com>
References: <20220810050738.7442-1-manali.shukla@amd.com>
 <20220810052313.7630-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220810052313.7630-1-manali.shukla@amd.com>
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

On Wed, Aug 10, 2022, Manali Shukla wrote:
>  static void svm_nm_test(void)

IMO, this should be renamed to svm_no_nm_test().

>  {
>  	handle_exception(NM_VECTOR, guest_test_nm_handler);
>  	write_cr0(read_cr0() & ~X86_CR0_TS);
>  	test_set_guest(svm_nm_test_guest);
>  
> -	vmcb->save.cr0 = vmcb->save.cr0 | X86_CR0_TS;
> -	report(svm_vmrun() == SVM_EXIT_VMMCALL && nm_test_counter == 1,
> -	       "fnop with CR0.TS set in L2, #NM is triggered");
> -
> -	vmcb->save.cr0 = (vmcb->save.cr0 & ~X86_CR0_TS) | X86_CR0_EM;
> -	report(svm_vmrun() == SVM_EXIT_VMMCALL && nm_test_counter == 2,
> -	       "fnop with CR0.EM set in L2, #NM is triggered");
> -
>  	vmcb->save.cr0 = vmcb->save.cr0 & ~(X86_CR0_TS | X86_CR0_EM);
> -	report(svm_vmrun() == SVM_EXIT_VMMCALL && nm_test_counter == 2,
> +	report(svm_vmrun() == SVM_EXIT_VMMCALL && nm_test_counter == 0,
>  	       "fnop with CR0.TS and CR0.EM unset no #NM excpetion");

No need to keep the #NM handler, just rely on the VMMCAL assertion and the fact
that an unexpected #NM will also cause a test failure.
