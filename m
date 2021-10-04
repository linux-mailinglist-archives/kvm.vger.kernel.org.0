Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2165420B1B
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 14:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233163AbhJDMqG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 08:46:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28681 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231965AbhJDMqF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 08:46:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633351456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Uw5NpJXbzzDq6kJP5OT7G1gnqMoSZ/d9kINK/rCAzT8=;
        b=BxHI6+wDN1wv6aCI0K67XaumqqvHCuCiQI4HsCcm72UdyKh0joKL4hFT/qv8VZd4hbByfB
        /bnK0sqczZUu92lpURpxRDtl22AXmz+mrj7JBBvmh+BempPckx8AC7/EN8eOR/KRKoXoyB
        mRaMhcmu5I9aidQnq+hocIcIcrs3mng=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-Y0qbzroBMMWkT3vwSppo1A-1; Mon, 04 Oct 2021 08:44:15 -0400
X-MC-Unique: Y0qbzroBMMWkT3vwSppo1A-1
Received: by mail-wr1-f70.google.com with SMTP id s18-20020adfbc12000000b00160b2d4d5ebso183976wrg.7
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 05:44:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Uw5NpJXbzzDq6kJP5OT7G1gnqMoSZ/d9kINK/rCAzT8=;
        b=CtFzLO9do6uf802XDgFxEFrZrcQDy1pwIKS+GFLOxA6fhhBBUpzyWo+tRV7dzJJWve
         Gj7iwbWU/8dheNQeP1pMAeUTTphsPg/DXIyfIrrPrhM2AiVXDxms25A0jgxtByFno6TA
         HB1k0XNCBxIQo8FFg7eDrAAfDMp8yrm7VOC+VEFbysoIGijayBG7LmFD4HSOn7+xqwE4
         s9iCZzwgpN0OzzWdnBEOHYccTI23ztdsCAHtc+twiSm9lQdwkteXqhXlxTdsq3jMfWka
         dQPx5wj7Lkh5zhdddp5O12xPtCf10IIl2eu9KIkKHwlJMvdQLigwQrp3WSXltye91l+h
         1Ujg==
X-Gm-Message-State: AOAM533uM0Z8cSzPZ1vDCqYBXagKY9zwMWv6d+3paDuHrCIqqsluiHko
        LKiwFqndMRc00uwqG+eRVN358ayfQzHkaD09KgJkhW7iRs3AmqUc4zxsCPsQq4dewNQIJ227I+X
        ZLce12vez3wpJ
X-Received: by 2002:a05:600c:a43:: with SMTP id c3mr1337365wmq.193.1633351454295;
        Mon, 04 Oct 2021 05:44:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz4nEBKHflJAK2AmabY0s2VvyOBAWVL0rQ87qW9vo8k6xnnXuaoOWlGnMLJ2dMtwaNobKrbOA==
X-Received: by 2002:a05:600c:a43:: with SMTP id c3mr1337349wmq.193.1633351454093;
        Mon, 04 Oct 2021 05:44:14 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id d129sm17767301wmd.23.2021.10.04.05.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 05:44:13 -0700 (PDT)
Date:   Mon, 4 Oct 2021 14:44:11 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Zixuan Wang <zixuanwang@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, marcorr@google.com,
        baekhw@google.com, tmroeder@google.com, erdemaktas@google.com,
        rientjes@google.com, seanjc@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, varad.gautam@suse.com, jroedel@suse.de,
        bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v2 03/17] x86 UEFI: Copy code from GNU-EFI
Message-ID: <20211004124411.nqikc4wyvpal73sh@gator>
References: <20210827031222.2778522-1-zixuanwang@google.com>
 <20210827031222.2778522-4-zixuanwang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827031222.2778522-4-zixuanwang@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021 at 03:12:08AM +0000, Zixuan Wang wrote:
> To build x86 test cases with UEFI, we need to borrow some source
> code from GNU-EFI, which includes the initialization code and linker
> scripts. This commit only copies the source code, without any
> modification. These source code files are not used by KVM-Unit-Tests
> in this commit.
> 
> The following source code is copied from GNU-EFI:
>    1. x86/efi/elf_x86_64_efi.lds
>    2. x86/efi/reloc_x86_64.c
>    3. x86/efi/crt0-efi-x86_64.S
> 
> We put these EFI-related files under a new dir `x86/efi` because:
>    1. EFI-related code is easy to find
>    2. EFI-related code is separated from the original code in `x86/`
>    3. EFI-related code can still reuse the Makefile and test case code
>       in its parent dir `x86/`
> 
> GNU-EFI repo and version:
>    GIT URL: https://git.code.sf.net/p/gnu-efi/code
>    Commit ID: 4fe83e102674
>    Website: https://sourceforge.net/p/gnu-efi/code/ci/4fe83e/tree/
> 
> Co-developed-by: Varad Gautam <varad.gautam@suse.com>
> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> Signed-off-by: Zixuan Wang <zixuanwang@google.com>
> ---
>  x86/efi/README.md          |  25 ++++++++++
>  x86/efi/crt0-efi-x86_64.S  |  79 +++++++++++++++++++++++++++++
>  x86/efi/elf_x86_64_efi.lds |  77 ++++++++++++++++++++++++++++
>  x86/efi/reloc_x86_64.c     | 100 +++++++++++++++++++++++++++++++++++++
>  4 files changed, 281 insertions(+)
>  create mode 100644 x86/efi/README.md
>  create mode 100644 x86/efi/crt0-efi-x86_64.S
>  create mode 100644 x86/efi/elf_x86_64_efi.lds
>  create mode 100644 x86/efi/reloc_x86_64.c
> 
> diff --git a/x86/efi/README.md b/x86/efi/README.md
> new file mode 100644
> index 0000000..256ef8c
> --- /dev/null
> +++ b/x86/efi/README.md
> @@ -0,0 +1,25 @@
> +# EFI Startup Code and Linker Script
> +
> +This dir contains source code and linker script copied from
> +[GNU-EFI](https://sourceforge.net/projects/gnu-efi/):
> +   - crt0-efi-x86_64.S: startup code of an EFI application
> +   - elf_x86_64_efi.lds: linker script to build an EFI application
> +   - reloc_x86_64.c: position independent x86_64 ELF shared object relocator
> +
> +EFI application binaries should be relocatable as UEFI loads binaries to dynamic
> +runtime addresses. To build such relocatable binaries, GNU-EFI utilizes the
> +above-mentioned files in its build process:
> +
> +   1. build an ELF shared object and link it using linker script
> +      `elf_x86_64_efi.lds` to organize the sections in a way UEFI recognizes
> +   2. link the shared object with self-relocator `reloc_x86_64.c` that applies
> +      dynamic relocations that may be present in the shared object
> +   3. link the entry point code `crt0-efi-x86_64.S` that invokes self-relocator
> +      and then jumps to EFI application's `efi_main()` function
> +   4. convert the shared object to an EFI binary
> +
> +More details can be found in `GNU-EFI/README.gnuefi`, section "Building
> +Relocatable Binaries".
> +
> +KVM-Unit-Tests follows a similar build process, but does not link with GNU-EFI
> +library.

So, for AArch64, I also want to drop the gnu-efi dependency of my original
PoC. My second PoC, which I haven't finished, took things a bit further
than this does, though. I was integrating a PE/COFF header and linker
script changes directly into the kvm-unit-tests code rather than copying
these files over.

Thanks,
drew

