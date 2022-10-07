Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16C705F727F
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 03:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232142AbiJGBPQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 21:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbiJGBPP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 21:15:15 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024BA40E1A
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 18:15:14 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id g28so3603237pfk.8
        for <kvm@vger.kernel.org>; Thu, 06 Oct 2022 18:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=h4XgRZp03/RQpMaeNuS7Q56rf+wF1PU/JtpGOuJoPr0=;
        b=VL9k24462zz+D9/UiiuhNgxBOX1et1sbkRv5FtkMGNxGOpkB1T/ngf2K1O6P3lv9fv
         FYjZWYZwNvlyKHvJGXclNcEWp/yTx9uOg40Qg+q7GqC5ZLYM1bXgTwkQtagyPf/QrhG6
         cTrWppXmWyfMNeUviaXmQMMA6F9vG+6NfbTV5TC23fUyi3kEpoJ7EZUJ7bF3hGncYykU
         gqQ3SLZ7YMpyxCZNYRiXaYwjK7PT7uv9y5B5dhJ4HKkpKz9Ddz1ARTGXOIKjDoXrxWdT
         kJf34VYvc07BncSQfRm7sgZrJD2hZd0dN2scstqqtwgGrdkep7ARe+QjVxHNtmwXRoCk
         /RXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h4XgRZp03/RQpMaeNuS7Q56rf+wF1PU/JtpGOuJoPr0=;
        b=xBlixFW0KN2p7x/wUrVXcrrTWJ2okL2CC+psUEZPjtIpHh2HWIr6nUte2IzkrCGlZV
         AdDOl4xJugG7A46TVwEq/vCAGVfGE16KaZRjy4V2pF5ezxBgjVz0340iejOoLRDoZ9vS
         pXmY1iUBTmYlrtWXy+T2wIcgjvqyhXCe6UfrzJKK7uxQce2DS/nRQBhRKsNOi33//Lh4
         wnS2hkKA18Bvrr7L6TlC5lSuPCWeupgrXITW8vtXUiOug9bazN6oFxAwC9npCyWjrxj6
         cB7/Nt2aPbyrMbtWTHc711n2ATWMdmD7WfP8pEkPdYl4x/Pl7vJPNmb40BfyQ7aANoXJ
         QOiw==
X-Gm-Message-State: ACrzQf1dRliZaoTw0ftI8y0sT15LoUc4EJuambC5FPXH7YdP2/yx2ZHf
        IUrbMslTq9W/yZtHYzJ5Q61teA==
X-Google-Smtp-Source: AMsMyM7/UvQoNoJu0mp5Jq7zF/a1fahnuy7Re5M3UTVKOeP0t3IZIkO9E67buUdjHm0f13W0pocYYg==
X-Received: by 2002:a65:6753:0:b0:438:e83a:bebc with SMTP id c19-20020a656753000000b00438e83abebcmr2246733pgu.602.1665105313419;
        Thu, 06 Oct 2022 18:15:13 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id p18-20020a1709028a9200b0017d97d13b18sm263133plo.65.2022.10.06.18.15.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 18:15:12 -0700 (PDT)
Date:   Fri, 7 Oct 2022 01:15:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Kalra, Ashish" <ashish.kalra@amd.com>
Cc:     ovidiu.panait@windriver.com, kvm@vger.kernel.org,
        liam.merwick@oracle.com, mizhang@google.com, pbonzini@redhat.com,
        thomas.lendacky@amd.com, michael.roth@amd.com, pgonda@google.com,
        marcorr@google.com, alpergun@google.com, jarkko@kernel.org,
        jroedel@suse.de, bp@alien8.de, rientjes@google.com
Subject: Re: [PATCH 5.4 1/1] KVM: SEV: add cache flush to solve SEV cache
 incoherency issues
Message-ID: <Yz99nF+d6D+37efE@google.com>
References: <20220926145247.3688090-1-ovidiu.panait@windriver.com>
 <20220927000729.498292-1-Ashish.Kalra@amd.com>
 <YzJFvWPb1syXcVQm@google.com>
 <215ee1ce-b6eb-9699-d682-f2e592cde448@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <215ee1ce-b6eb-9699-d682-f2e592cde448@amd.com>
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

On Thu, Oct 06, 2022, Kalra, Ashish wrote:
> For the MMU invalidation notifiers we are going to make two changes
> currently:
> 
> 1). Use clflush/clflushopt instead of wbinvd_on_all_cpus() for range <= 2MB.

IMO, this isn't worth pursuing, to the point where I might object to this code
being added upstream.  Avoiding WBINVD for the mmu_notifiers doesn't prevent a
malicious userspace from using SEV-induced WBINVD to effectively DoS the host,
e.g. userspace can simply ADD+DELETE memslots, or mprotect() chunks > 2mb.

Using clfushopt also effectively puts a requirement on mm/ that the notifiers
be invoked _before_ PTEs are modified in the primary MMU, otherwise KVM may not
be able to resolve the VA=>PFN, or even worse, resolve the wrong PFN.

And no sane VMM should be modifying userspace mappings that cover SEV guest memory
at any reasonable rate.

In other words, switching to CLFUSHOPT for SEV+SEV-ES VMs is effectively a
band-aid for the NUMA balancing issue.  A far better solution for NUMA balancing
would be to pursue a fix for the underlying problem, e.g. disable NUMA balancing
entirely for SEV/SEV-ES VMs.  That might already be doable from userspace by
manipulating memory policy, and if not there's a WIP patch[*] that would make it
trivial for the userspace VMM to disable NUMA balancing.

As for guarding against DoS, /dev/sev should really be locked down so that only
sufficiently privileged users can create SEV VMs.

[*] https://lore.kernel.org/all/20220929064359.46932-1-ligang.bdlg@bytedance.com
