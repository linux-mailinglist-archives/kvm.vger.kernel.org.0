Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F81949D023
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 17:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243376AbiAZQ6I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 11:58:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243345AbiAZQ6H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jan 2022 11:58:07 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD51C06173B
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 08:58:07 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id e6so251370pfc.7
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 08:58:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vpWt628TPdkdXgGSYImAnYHf3KiGj2SlSqiD1/oEPZc=;
        b=V8Gv93HeYbkF1KZCJqJ5nH0oqBoi7i/e1m2/4FpD7gtKKjp/9VVDCEpPIQQnnLqmal
         ByWAngDgYFfQi7CRXZquFHej/EzCUgGneqdePd29r85+UutrNIYc9jLpytOhC6V1SvV8
         gYZkCPyd7QypkBOYyvx2jVmmTUNsRuWr7hDX2YrHGRoId3jVpv9pzjPHTJKr7cmVjVFd
         fo+UPLZw6iSubHy1fF+UoFyeG//MXtB3172YXFuMLYgPhYVDBxUry/2udvXlukYZ55KS
         5STkE7ik3Cr53ejafOMX7SGmPafDGs8RGq9qQ2uexgdGaZ63R2pDuU5/BpLX6sGaa0Ds
         gX2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vpWt628TPdkdXgGSYImAnYHf3KiGj2SlSqiD1/oEPZc=;
        b=QHSou7sUWvA00RbHDWze/NGp+gPbUs+HAszto/fylVbnJm9UZ9Pofb1lYuj0A/8t7d
         r9swmV9fwf3Qwgrhj08bFbzOydJKkX2VGvoN0xpuXw+nYEhJc1MWJTquZ8I/jkcx5JwP
         r+vB+6CFek1wqNSK7pUe1klt/gpfEpyMnr/P44SZkHO9C8PAff8eraIR5O0ty34wVKo+
         QwtYyesv3OIOUUzxiIr71hkLr4TVTjks19kYhNFD7NfB5vHwiMPqWjsJ4WIJNaS88fCt
         s2e4AbRUOyCdxxeISAF4HLaUkgmouNxWFRq2zOSeDbwaLLRnxmhokj0iLYaf/CVxgKk6
         b+Lw==
X-Gm-Message-State: AOAM530jlQ7PIwi2WsjYSH25q02T2QmVMu70WHeTRAWE9mIW4QMj96aW
        EZOhRb96ju4j6/aGlVma5uFVOg==
X-Google-Smtp-Source: ABdhPJxJkzWgbsthpBvaD4/PZ95cGf1Q+zracQWe1XXFdkJpwNfWXMBY8msoimUSYVQ2to0e0CscuA==
X-Received: by 2002:a05:6a00:c88:b0:4c8:cc0d:6da with SMTP id a8-20020a056a000c8800b004c8cc0d06damr15689770pfv.36.1643216286370;
        Wed, 26 Jan 2022 08:58:06 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id gb5sm3668675pjb.16.2022.01.26.08.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 08:58:05 -0800 (PST)
Date:   Wed, 26 Jan 2022 16:58:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        kvm@vger.kernel.org
Subject: Re: orphan section warnings while building v5.17-rc1
Message-ID: <YfF9mqcNVYLVERjl@google.com>
References: <97ce2686-205b-8c46-fd24-116b094a7265@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97ce2686-205b-8c46-fd24-116b094a7265@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 25, 2022, Pavel Skripkin wrote:
> Hi kvm developers,
> 
> while building newest kernel (0280e3c58f92b2fe0e8fbbdf8d386449168de4a8) with
> mostly random config I met following warnings:
> 
>   LD      .tmp_vmlinux.btf
> ld: warning: orphan section `.fixup' from `arch/x86/kvm/xen.o' being placed
> in section `.fixup'
>   BTF     .btf.vmlinux.bin.o
>   LD      .tmp_vmlinux.kallsyms1
> ld: warning: orphan section `.fixup' from `arch/x86/kvm/xen.o' being placed
> in section `.fixup'
>   KSYMS   .tmp_vmlinux.kallsyms1.S
>   AS      .tmp_vmlinux.kallsyms1.S
>   LD      .tmp_vmlinux.kallsyms2
> ld: warning: orphan section `.fixup' from `arch/x86/kvm/xen.o' being placed
> in section `.fixup'
>   KSYMS   .tmp_vmlinux.kallsyms2.S
>   AS      .tmp_vmlinux.kallsyms2.S
>   LD      vmlinux
> ld: warning: orphan section `.fixup' from `arch/x86/kvm/xen.o' being placed
> in section `.fixup'

Yep, xen.c has unnecessary usage of .fixup.  I'll get a patch sent.

Thanks!
