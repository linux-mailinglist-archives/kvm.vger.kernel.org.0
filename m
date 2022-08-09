Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E08CA58DB22
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 17:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244930AbiHIPaF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 11:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244931AbiHIPaE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 11:30:04 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C9218E12
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 08:30:03 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id t22so12045192pjy.1
        for <kvm@vger.kernel.org>; Tue, 09 Aug 2022 08:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=eC2Xvm7XGduM7P0+goSB66wa3BoJE1sk0D7l/4M1jiU=;
        b=R4+GwzrHsDnUgP3Q911vq1xy77RZe3XJTR35S+pyDTjiUGfB07Bh8QeHQ8y6MhS0pi
         RoCLYsmI7EEMlfBdaGL6MXafefwE1snhCpfpcBnY2E9fqW6LXyVqUQGwBQO8tpiD0E0I
         feS6/N13M/OHBuqDDqIZfbQUcZrOH96WUE0PBgrWys7+SrPmsge5Tbclu1ABAu3CklcM
         k7s+GgQ2taZcmGGTW37X96fVrKSfL59FGO2vYSpkF0wAPZXrWTRMX2YY+rcU6nNS8PAo
         6h2V+NR+c5p19qiVoFXFEh5jvwBm1lYzZ2TYONneD5Eo7tkyISiRuKPKTEsntkd0s6uJ
         O+YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=eC2Xvm7XGduM7P0+goSB66wa3BoJE1sk0D7l/4M1jiU=;
        b=zQxGfub2co72TonXQN9p22tIf9fj0tG204T7gCeU93vNNtcV94zVwzzbbq+1mHnLyh
         0z7ULALvCBwiKU3fDvHxhcF/NhtVN/pWR3SBH30frHcLHasjz+GuF7cz7FB5p+xeyuoI
         pAtGyh8XS1op1AH8sS8heXsGHHamaTWtVq6ITnsc9pKaNTiVpGckKme53EJhTj4neRWS
         IlO+sH1G2xO48T5h/oXCKAmpeYD0FCq0TvXS9P30CBkJJc3Uy2bV21KpwLthduza9+Rt
         tjgKzsI/zb2UGA3khCOmspKXUKZ6s71OH6oQS9gE8Fg1GzZO6oIhV/wl/UO+3+OXS9vY
         hpyw==
X-Gm-Message-State: ACgBeo0xbJuvcAnfzfVZe4U87mEo5rTxMeqphOJeiV3J5dfxdTbhYsNK
        f1+W2qbps/7ARB0o62u3g7229A==
X-Google-Smtp-Source: AA6agR75C6Q/KocHhErr8Gn4V4J5Za1g5YkbJGaeRUsL2A8GauLdvMQ949+wgkJ5lCyvdqdIvryp5w==
X-Received: by 2002:a17:902:d4c7:b0:16e:df4b:89b4 with SMTP id o7-20020a170902d4c700b0016edf4b89b4mr23335176plg.142.1660059003017;
        Tue, 09 Aug 2022 08:30:03 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a67-20020a624d46000000b0052d8405bcd2sm21221pfb.163.2022.08.09.08.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 08:30:02 -0700 (PDT)
Date:   Tue, 9 Aug 2022 15:29:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        andrew.jones@linux.dev, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, ricarkol@google.com, zixuanwang@google.com
Subject: Re: [kvm-unit-tests PATCH v3 00/27] EFI and ACPI support for arm64
Message-ID: <YvJ9dni3JCUHNsF1@google.com>
References: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
 <YvJB/KCLSQK836ae@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvJB/KCLSQK836ae@monolith.localdoman>
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

On Tue, Aug 09, 2022, Alexandru Elisei wrote:
> Hi,
> 
> Adding Sean and Zixuan, as they were involved in the initial x86 UEFI
> support.
> 
> This version of the UEFI support for arm64 jumps to lib/efi.c::efi_main
> after performing the relocation. I'll post an abbreviated/simplified
> version of efi_main() for reference:
> 
> efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
> {
> 	/* Get image, cmdline and memory map parameters from UEFI */
> 
>         efi_exit_boot_services(handle, &efi_bootinfo.mem_map);
> 
>         /* Set up arch-specific resources */
>         setup_efi(&efi_bootinfo);
> 
>         /* Run the test case */
>         ret = main(__argc, __argv, __environ);
> 
>         /* Shutdown the guest VM */
>         efi_exit(ret);
> 
>         /* Unreachable */
>         return EFI_UNSUPPORTED;
> }
> 
> Note that the assumption that efi_main() makes is that setup_efi() doesn't
> change the stack from the stack that the UEFI implementation allocated, in
> order for setup_efi() to be able to return to efi_main().

On the x86 side, efi_main() now runs with a KUT-controlled stack since commit

  d316d12a ("x86: efi: Provide a stack within testcase memory")

> If we want to keep the UEFI allocated stack, then both mechanism must be
> forbidden when running under UEFI. I dislike this idea, because those two
> mechanisms allow kvm-unit-tests to run tests which otherwise wouldn't have
> been possible with a normal operating system, which, except for the early
> boot code, runs with the MMU enabled.

Agreed.  IMO, KUT should stop using UEFI-controlled data as early as possible.
The original x86 behavior was effectively a temporary solution to get UEFI working
without needing to simultaneously rework the common early boot flows.

Side topic, I think the x86 code now has a benign bug.  The old code contained an
adjustment to RSP to undo some stack shenanigans (can't figure out why those
shenanigans exist), but now the adjustment happens on the KUT stack, which doesn't
need to be fixed up.

It's a moot point since efi_main() should never return, but it looks odd.  And it
seems like KUT should intentionally explode if efi_main() returns, e.g. do this
over two patches:

diff --git a/x86/efi/crt0-efi-x86_64.S b/x86/efi/crt0-efi-x86_64.S
index 1708ed55..e62891bc 100644
--- a/x86/efi/crt0-efi-x86_64.S
+++ b/x86/efi/crt0-efi-x86_64.S
@@ -62,10 +62,7 @@ _start:
        lea stacktop(%rip), %rsp
 
        call efi_main
-       addq $8, %rsp
-
-.exit: 
-       ret
+       ud2
 
        // hand-craft a dummy .reloc section so EFI knows it's a relocatable executable:
