Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFD6058EEDE
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 16:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232597AbiHJO6W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 10:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbiHJO6U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 10:58:20 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 249986E8B5
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 07:58:20 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id y1so8848756plb.2
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 07:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=u5XVkf0EYBmOZMZ4QqpdZ8N9KNJQU43zLWwGe6tSl0w=;
        b=tFqBrhySE5EUAwqP870vuZtReVSDEWa5nefk8Y7yARP6bIiuDEEG8OHAeMUHsRmE2h
         cbiaoqDxhOaMkvivDweIWXgzKQvm8HtLqtijuHZ++LFHRVgI/TfNddx38TSp5xyw8XvB
         z97SFxDrAzPmG8/Xk/egNGRwVR4ASE/FZvjT4ouZp3AmevS3tu6k9nslYp38nieu8s26
         /hJJTYwcbaq/0IhvV8vRD8fjIQlzZu4TxZ+0AI7QRKtfIcy/OwQ6SvLTmoKv4XM8z9xE
         0FfeVaPLCvk38TNxKb3Vx6MMDc7krrtPwPFfijML+wKirOKFxs5vYvy3Cz9lq7iODmN3
         L7tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=u5XVkf0EYBmOZMZ4QqpdZ8N9KNJQU43zLWwGe6tSl0w=;
        b=efqHcbEE3iNLiCC5XjpGWQbh0XCbHdVoeQZYX2BVZ/0YGVdp7bEN80EeZEDedGI8aH
         gpKkV2SUDHDghbpiGR0qIEPAxoV7hsTd3BBuGO2p4uoBzOwBMUWysvlEYMlZY+kVqle5
         BZHrA1A5MzRBuaffMJsQ60L3JAXZt4kc8rIKMIaCFHhBXg3kuYeuAePO34hsTzWc1Of6
         HLWuS8aedJFj8brwBa0pLLNWNk5mE+txACyrk7SeDh505kzhyPns54zgJzFW4E6sw5pW
         76FzkI87UHhVKVOf4vyWHlEFcuTDGQM7guAr1hFMalBZ3P+hZa+a/Su9lrkjcvHAB42M
         lU6g==
X-Gm-Message-State: ACgBeo0M86hDiCpE8vUowQY0YjkAS3wEAuuILpL251FhZkdsJdvf9WPv
        bcMJb30SLMhw01f7gt5bYBCmAA==
X-Google-Smtp-Source: AA6agR7/KUk753NyiulJ8++NHVkL40lnlxk1XXg22+3GF2ZetMagYJ+Jkl0xw8Ag0a0+V2kTPvtI5Q==
X-Received: by 2002:a17:90b:4c8d:b0:1f5:409b:b017 with SMTP id my13-20020a17090b4c8d00b001f5409bb017mr4293298pjb.52.1660143499428;
        Wed, 10 Aug 2022 07:58:19 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id hg6-20020a17090b300600b001f069352d73sm1752720pjb.25.2022.08.10.07.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 07:58:19 -0700 (PDT)
Date:   Wed, 10 Aug 2022 14:58:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        andrew.jones@linux.dev, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, ricarkol@google.com, zixuanwang@google.com
Subject: Re: [kvm-unit-tests PATCH v3 00/27] EFI and ACPI support for arm64
Message-ID: <YvPHhwtc6LX62Y+E@google.com>
References: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
 <YvJB/KCLSQK836ae@monolith.localdoman>
 <YvJ9dni3JCUHNsF1@google.com>
 <YvN3jk4VUD9Dhl0H@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvN3jk4VUD9Dhl0H@monolith.localdoman>
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

On Wed, Aug 10, 2022, Alexandru Elisei wrote:
> Hi Sean,
> 
> On Tue, Aug 09, 2022 at 03:29:58PM +0000, Sean Christopherson wrote:
> > On Tue, Aug 09, 2022, Alexandru Elisei wrote:
> > > Note that the assumption that efi_main() makes is that setup_efi() doesn't
> > > change the stack from the stack that the UEFI implementation allocated, in
> > > order for setup_efi() to be able to return to efi_main().
> > 
> > On the x86 side, efi_main() now runs with a KUT-controlled stack since commit
> > 
> >   d316d12a ("x86: efi: Provide a stack within testcase memory")
> > 
> > > If we want to keep the UEFI allocated stack, then both mechanism must be
> > > forbidden when running under UEFI. I dislike this idea, because those two
> > > mechanisms allow kvm-unit-tests to run tests which otherwise wouldn't have
> > > been possible with a normal operating system, which, except for the early
> > > boot code, runs with the MMU enabled.
> > 
> > Agreed.  IMO, KUT should stop using UEFI-controlled data as early as possible.
> > The original x86 behavior was effectively a temporary solution to get UEFI working
> > without needing to simultaneously rework the common early boot flows.
> 
> Yes, this is also what I am thinking, the stack is poorly specified in the
> specification because the specification doesn't expect an application to
> keep using it after calling EFI_BOOT_SERVICES.Exit(). Plus, using the UEFI
> allocated stack makes the test less reproducible, as even EDK2 today
> diverges from the spec wrt the stack, and other UEFI implementations might
> do things differently. And with just like all software, there might be bugs
> in the firmware. IMO, the more control kvm-unit-tests has over its
> resources, the more robust the tests are.
> 
> What I was thinking is rewriting efi_main to return setup_efi(),
> something like this:
> 
> void efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
> {
> 	/* Get image, cmdline and memory map parameters from UEFI */
> 
>         efi_exit_boot_services(handle, &efi_bootinfo.mem_map);
> 
>         /* Set up arch-specific resources, not expected to return. */
>         setup_efi(&efi_bootinfo);
> }
> 
> Which would allow all architectures to change their environment as they see
> fit, as setup_efi() is not expected to return. Architectures would have to
> be made aware of the efi_exit() function though.

And they'd also have to invoke the test's main().  Why can't ARM switch to a KUT
stack before calling efi_main()?  The stack is a rather special case, I don't think
it's unreasonable to require architectures to handle that before efi_main().
