Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC25357EB02
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 03:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234190AbiGWBOx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 21:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbiGWBOw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 21:14:52 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510C78AB3C
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 18:14:51 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id gq7so5689666pjb.1
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 18:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mlhuJjsagpUtxAvday6D2ZpIOCEYXdAj2hQUheI+5sE=;
        b=oBpAgdi1U4gV+6QmYklwJBD5Y+RvGZkwdNbv9T7ie/YkMoWrcaJIN1JrIP3WQQwGvN
         8PKzrb5seQIn/dr8BJPrnWg6rtulowOeqMZspDGYd7wZcCsyoVhp2SXqCDDn9H1M+/Gz
         RysbsMT2tsO6qLRN/qjq4qHWlALjguSRT4mU/iwRSsFKWg++c7KsXgWtso2g1wflFt8c
         JheHxsoXiCv92eJkxbI+Ek4NTy1Q0cqVH3WtJL8205BXxHkA0ZM2282eH9pWVPq08AaH
         sskBda21dVnh4QxVeWkDt4yxUinjmCP7+f7GbpUCuYbPrVPsvoaO+Q1S+pxz06QmYxIC
         u7eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mlhuJjsagpUtxAvday6D2ZpIOCEYXdAj2hQUheI+5sE=;
        b=Q1DD4jjL3rO9naiJzZEGVU+jBEd3z3UWSIpvIBkkKIJZiLBjVThbD1DXmk7BcYW1RV
         ecQwSlnX40S+4OuWdBswuOqbIcJaMuv92iPa1q6kmKxvqhY5SRd5+ljtJn6q6BnGlZQN
         NdjecoSuR+86SQfZ8sM2wf5RIXSBJ2muiIGXx3FDy3Io88Yc/OJ0GEleGy5dxMLHUxH+
         wC97a4artT5SsKo9IQf4NzvOgfH+fBBbem4XdWWw5fJ4Txmyfsm62Xkaz7wEh9DJg5Ed
         oHdDnaXrkuPzizKRCHFQe4uGrQ8V9A1uXly1W/Bb9E4I5IJuxmt6ONGuaLA6eaCdCORX
         zp7A==
X-Gm-Message-State: AJIora+oF/3BEvk6QdJazpYcKwuO+eOVUhMiWoKEK9IDNGReDXBvheE4
        /qCkwPlREbR3k5IiepE+Sb8WWQ==
X-Google-Smtp-Source: AGRyM1vydYxRZ4i8BecNEhnMklgRKF6JCGsAtC9dc7lPgALEPKB+OxynXk32WAO6N4fZX8yNSwUzyA==
X-Received: by 2002:a17:90a:8c88:b0:1f2:12b0:ae9e with SMTP id b8-20020a17090a8c8800b001f212b0ae9emr20513747pjo.42.1658538890580;
        Fri, 22 Jul 2022 18:14:50 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id h5-20020a654045000000b00413d592af6asm4058346pgp.50.2022.07.22.18.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 18:14:50 -0700 (PDT)
Date:   Sat, 23 Jul 2022 01:14:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Yang Weijiang <weijiang.yang@intel.com>,
        Manali Shukla <manali.shukla@amd.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [kvm-unit-tests GIT PULL] x86: Fixes, cleanups, and new sub-tests
Message-ID: <YttLhpaAwft0PnbI@google.com>
References: <YtnBbb1pleBpIl2J@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtnBbb1pleBpIl2J@google.com>
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

On Thu, Jul 21, 2022, Sean Christopherson wrote:
> Please pull/merge a pile of x86 cleanups and fixes, most of which have been
> waiting for review/merge for quite some time.  The only non-trivial changes that
> haven't been posted are the massaged version of the PMU cleanup patches.
> 
> Note, the very last commit will fail spectacularly on kvm/queue due to a KVM
> bug: https://lore.kernel.org/all/20220607213604.3346000-4-seanjc@google.com.
> 
> Other than that, tested on Intel and AMD, both 64-bit and 32-bit.

Argh, don't pull this.

Commit b89a09f ("x86: Provide a common 64-bit AP entrypoint for EFI and non-EFI")
broke the SVM tests on Rome.  I'll look into it next week and spin a new version.
