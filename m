Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E96D44F9823
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 16:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236966AbiDHOhO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 10:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234505AbiDHOhN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 10:37:13 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36BB72102A4
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 07:35:09 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id u14so8850756pjj.0
        for <kvm@vger.kernel.org>; Fri, 08 Apr 2022 07:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yF7UvXpP57D7IJuK12EjXv5kwF1+YqL7OrkNck1y0Kw=;
        b=mczBsOyLp+kfWcpSEKE1Rrh6fqyNhKMn0RCksTc/7VvDsmg1sPSuZ97uuRDzC05i6j
         zcYKaeThW/oG8Ki2rIJynNLNV96Aj6/ONumQxEzlNvZLEDZz8oD835y5aFcx1TgdCm0R
         bAiOx8LJdiWBkuVIAaQS6Bax0rWOYMLcDw1JMGqa75Vlp5owYpM6+Gvq13hKgeFOhxuV
         jSIgIa8PBTSU/zRvvfq+UoWqLCW8kExyj2AkG8yY5sqe7WJf20uGAMZWfR1oWmd6j46c
         mvwZMc9bclzlq7Mpd+VF+NPFwrKfg/k66cVpagiG5GD1m5MjyhXYbd4eqXY8flB8nXUg
         yaYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yF7UvXpP57D7IJuK12EjXv5kwF1+YqL7OrkNck1y0Kw=;
        b=yGNHgaZ6h1CRadKNJ5qa66UxokL0n8QXmbFnwTALIbKH86M2pMKnt2mysAdWNTeWCR
         FZST9GTsTaCj9JW3HjSYSMjcxnDVm6aksERZpeMjSRqQdANmHDDMXxsBn3jxOH6H4LdV
         93SERjFrogBsW7Mmr4yVroEmE/vapeYbHLhMj4vvtOg68wf5FsAgc8x9s8qOZ6hsVpZI
         RX+UJ0rHRVmh+a5rTpRZWhF3jn9YPsoVaduKR7mIXQ/tRCd60D/6xQ6oxFme1SpUlxcJ
         y293cTZL4DIjyhLywkmEeo1aAiVsnjsaGFCzKuxdk25I4h0H98NlKrk93BqEm3X0hrdW
         zduQ==
X-Gm-Message-State: AOAM532KsGvOS33aL6bWS/KV6jTTpcrN68nhPCMMHBqo//eKhKWLxDk3
        DDWAcVa5Zs1YX/EVdn6mRr8VFIGhtwpCXw==
X-Google-Smtp-Source: ABdhPJyo9YuNM1jUBcN+cwYiLXKmHO/V2gYRqaK7Nyy8PrQkgzCP/sVb2fsVr2lKncZIT9bb948lxw==
X-Received: by 2002:a17:902:9887:b0:151:6e1c:7082 with SMTP id s7-20020a170902988700b001516e1c7082mr19158275plp.162.1649428508516;
        Fri, 08 Apr 2022 07:35:08 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p28-20020aa79e9c000000b004fafa48f430sm26324417pfq.92.2022.04.08.07.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 07:35:07 -0700 (PDT)
Date:   Fri, 8 Apr 2022 14:35:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de
Subject: Re: [kvm-unit-tests PATCH 0/9] SMP Support for x86 UEFI Tests
Message-ID: <YlBIGDreEtR9u+lh@google.com>
References: <20220408103127.19219-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408103127.19219-1-varad.gautam@suse.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 08, 2022, Varad Gautam wrote:
> This series brings multi-vcpu support to UEFI tests on x86.
> 
> Most of the necessary AP bringup code already exists within kvm-unit-tests'
> cstart64.S, and has now been either rewritten in C or moved to a common location
> to be shared between EFI and non-EFI test builds.
> 
> A call gate is used to transition from 16-bit to 32-bit mode, since EFI may
> not load the 32-bit entrypoint low enough to be reachable from the SIPI vector.
> 
> Git branch: https://github.com/varadgautam/kvm-unit-tests/commits/ap-boot-v1
> 
> Varad Gautam (9):
>   x86: Move ap_init() to smp.c
>   x86: Move load_idt() to desc.c
>   x86: desc: Split IDT entry setup into a generic helper
>   x86: efi, smp: Transition APs from 16-bit to 32-bit mode
>   x86: Move 32-bit bringup routines to start32.S
>   x86: efi, smp: Transition APs from 32-bit to 64-bit mode
>   x86: Move load_gdt_tss() to desc.c
>   x86: Provide a common 64-bit AP entrypoint for EFI and non-EFI
>   x86: setup: Serialize ap_start64 with a spinlock

This series doesn't apply cleanly on upstream master.  I feel bad for asking, but
in addition to rebasing to master, can you also rebase on top of my series[*] that
fixes SMP bugs that were introduced by the initial UEFI support?  I don't think
there will be semantic conflicts, but the whitespace cleanups (spaces => tabs) do
conflict, and I'd really like to start purging the spaces mess from KUT.

Paolo / Andrew, ping on my series, it still applies cleanly.

[*] https://lore.kernel.org/all/20220121231852.1439917-1-seanjc@google.com
