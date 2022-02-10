Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90CAC4B13F5
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 18:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245070AbiBJRNs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 12:13:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245065AbiBJRNr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 12:13:47 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3188E6F
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 09:13:47 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id y7so2388840plp.2
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 09:13:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ufezr4OVBurDd4Q4oYSIprjRSIK8S02QvmSB/NEG1dk=;
        b=iCpwVI5+r82ZSdUgiX0pZ8n1oIMG4njjfges8mMZJhT64d2S4TJleAe0KPTXLpXVBX
         //5dTP5pRA0RdKUIWYjlSNnhlPg/ecMEa3KQsMJf0JAK7N2CUXWnfz5m8gUHQVgQ4Hvc
         Omt7w+8eJAv4UunHTNyGwGP1wJfTBZB4lBMDL+JJ6LI/0/sQh9PFDMqxEmy79X4eh5fM
         fXg1qB1HdSXdXktsWUtI4cj5KN7xqOlQHcIYTCBgH1UwYP6tvY/MavdQxpMCNkFy8lN3
         1tI1CmCtVHyiqIlTcDNz9vDUaGxZff2F6piA9I/kYQiBv207hpx/s70E2yePYhtr31to
         govA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ufezr4OVBurDd4Q4oYSIprjRSIK8S02QvmSB/NEG1dk=;
        b=cX79q3zq/I69annDZoOjaM6Sr68qzY+4erYLOy75V/MqsJ3/zyehOcTRb5Zg5GmrAi
         oJtzQ87QKiRahZFo+XfyZyVXCqXOdhO4crmjpg5TQES5Y/xUzRqPnEKsxnxy+KCg1X/r
         rGzb5N86G9jJbL6Mxue/OLQqp4+erM1jE7H85cnmyWHC+cyQ6kCDX0xis537BndM0Fk1
         DgCXm4okFt/51aIWq9NFvAx0VywStQ7P+EdKIAvYhLfPM8hpRtHMISR7uLP5hi5I3LXk
         kZHX2F/3/KSoUpwOjdRxsvu0+QFm3vSrdb2hWuZ9LNZmiIq8hsNwliIxAq4Gf2zOh4wy
         6PXA==
X-Gm-Message-State: AOAM531a+NiHQh6qQTu7HaCFy0dNwYSYU7Izjjjuz9EyryOoxnsl2hkb
        W4NP6OTLkzQxU1hSgR6S+GX2yA==
X-Google-Smtp-Source: ABdhPJz5/jxR8N2Y9jzI9wGmQCojj3edxPT46IowQxz9/jpmrUMf4INdyvqAFgG+adm7GhygbeO6eA==
X-Received: by 2002:a17:90a:7e15:: with SMTP id i21mr3890912pjl.74.1644513227155;
        Thu, 10 Feb 2022 09:13:47 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x9sm3571400pfu.101.2022.02.10.09.13.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 09:13:46 -0800 (PST)
Date:   Thu, 10 Feb 2022 17:13:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     pbonzini@redhat.com, thuth@redhat.com, drjones@redhat.com,
        kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests BUG] x86: debug.c compilation error with
 --target-efi
Message-ID: <YgVHx2GV/MbKu57I@google.com>
References: <YgT9ZIEkSSWJ+YTX@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgT9ZIEkSSWJ+YTX@monolith.localdoman>
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

On Thu, Feb 10, 2022, Alexandru Elisei wrote:
> When compiling kvm-unit-tests configured with --target-efi I get the following
> error:
> 
> [..]
> gcc -mno-red-zone -mno-sse -mno-sse2  -fcf-protection=full -m64 -O1 -g -MMD -MF x86/.debug.d -fno-strict-aliasing -fno-common -Wall -Wwrite-strings -Wempty-body -Wuninitialized -Wignored-qualifiers -Werror -Wno-missing-braces  -fno-omit-frame-pointer  -fno-stack-protector    -Wno-frame-address  -DTARGET_EFI -maccumulate-outgoing-args -fshort-wchar -fPIC  -Wclobbered  -Wunused-but-set-parameter  -Wmissing-parameter-type  -Wold-style-declaration -Woverride-init -Wmissing-prototypes -Wstrict-prototypes -std=gnu99 -ffreestanding -I /path/to/kvm-unit-tests/lib -I /path/to/kvm-unit-tests/lib/x86 -I lib   -c -o x86/debug.o x86/debug.c
> ld -T /path/to/kvm-unit-tests/x86/efi/elf_x86_64_efi.lds -Bsymbolic -shared -nostdlib -o x86/debug.so \
> 	x86/debug.o x86/efi/efistart64.o lib/libcflat.a
> ld: x86/debug.o: relocation R_X86_64_32S against `.text' can not be used when making a shared object; recompile with -fPIC
> make: *** [/path/to/kvm-unit-tests/x86/Makefile.common:51: x86/debug.so] Error 1
> rm x86/emulator.o x86/tsc.o x86/msr.o x86/tsc_adjust.o x86/idt_test.o x86/sieve.o x86/s3.o x86/asyncpf.o x86/rmap_chain.o x86/init.o x86/xsave.o x86/debug.o x86/pmu.o x86/kvmclock_test.o x86/pcid.o x86/umip.o x86/setjmp.o x86/eventinj.o x86/hyperv_connections.o x86/apic.o x86/dummy.o x86/hypercall.o x86/vmexit.o x86/tsx-ctrl.o x86/hyperv_synic.o x86/smap.o x86/hyperv_stimer.o x86/efi/efistart64.o x86/smptest.o
> 
> The error does not happen if the test is not configured with --target-efi.
> 
> I bisected the error to commit 9734b4236294 ("x86/debug: Add framework for
> single-step #DB tests"). Changing the Makefile to build x86/debug.o when
> !TARGET_EFI has fixed the issue for me (it might be that the inline assembly
> added by the commit contains absolute addresses, but my knowledge of x86
> assembly is sketchy at best):

Fix posted: https://lore.kernel.org/all/20220210092044.18808-1-zhenzhong.duan@intel.com
