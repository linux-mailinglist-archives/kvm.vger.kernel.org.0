Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 134E81C803F
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 05:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgEGDBp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 23:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726218AbgEGDBo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 23:01:44 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 990FEC061A0F;
        Wed,  6 May 2020 20:01:44 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id z8so4513658wrw.3;
        Wed, 06 May 2020 20:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7lHijG7kJKcvh9RhaW60Q+wKQLIalhsG6MVgu5X4mh0=;
        b=WFPilxvGjaDG4Atcy8hZkeOuq932UBlSKEXIMP/nUP7zskAZTC3+/Emg799YBKmdU/
         9n/7CretFd07FTLOB+MtyzHdAHtNw5mNFQmM1fP2OXE5zx/ShkH+ezHwajDTjHon8fCl
         12cWolpA/O5dp6E6tbrgQ9NL+nqHWWCWqBlnlp1zrWwx8E8ZJcmwiRB27QFAJx0pD7/5
         5BNrKvca9FxEixgerraKcwCCPTlKrI7tD3e2Jtr0dzpd2wZZf4THSbIcnPHECJF01K/J
         XBuHUFuCfKmzJ2xRCK+pFgtnQaarWGoxsAUCewy1Gn6/XD1EeYd4avV7MTH9gyND/k5h
         +O0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7lHijG7kJKcvh9RhaW60Q+wKQLIalhsG6MVgu5X4mh0=;
        b=EfM3fEVj9puQsUoUSorRsL7Eb00FUbGBD0VE8fcF47ijNi2/7S7O1gkGnBI/Pb6uSo
         cbO1DRkTgUBCg311jD8daurakzWTwHgSsDZeH5WZ3a9WFIcxgtZKIJJM9UfShTd8Uqnl
         siF5qNF4Sg5002kAdKOT/OkG1MSyteVm10tdyuifoCB6gbMhctUHIDVCDVEnQeKXGSRo
         TEL0k39BiuSrR6eiAtg02/lFgkOFZfraIfNJatbfXXppcCrH530/Jr9/36RvFLie32Kg
         hoqmTHKUuctk8njGVvpiL4N42dOpiaAmwSO0F1cz48tgXfGrayI1Oq61dEyJTatETxHQ
         HAiA==
X-Gm-Message-State: AGi0PuY8GMnmT/sYtzmRpn1NfOVvd8P1XB9772yKsmc/KlUoha4km7RP
        0lCfG/iUWSBZUkJNMPHPnM6c+MyCsUA=
X-Google-Smtp-Source: APiQypJTfcA289r6sAaoZu0fgYrVqFSEojOTv8ZpsuS8yUdl0RyDcxsop97nsxDd6kpWJQT6SHhgkQ==
X-Received: by 2002:a5d:6b8a:: with SMTP id n10mr12314616wrx.36.1588820503144;
        Wed, 06 May 2020 20:01:43 -0700 (PDT)
Received: from jondnuc (IGLD-84-229-154-20.inter.net.il. [84.229.154.20])
        by smtp.gmail.com with ESMTPSA id q187sm5881188wma.41.2020.05.06.20.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 20:01:42 -0700 (PDT)
Date:   Thu, 7 May 2020 06:01:41 +0300
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, pbonzini@redhat.com
Subject: Re: [PATCH v11 0/7] x86/kvm/hyper-v: add support for synthetic
 debugger
Message-ID: <20200507030141.GF2862@jondnuc>
References: <20200424113746.3473563-1-arilou@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200424113746.3473563-1-arilou@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo was this merged in or by any chance in the queue?

Thanks,
-- Jon.

On 24/04/2020, Jon Doron wrote:
>Add support for the synthetic debugger interface of hyper-v, the
>synthetic debugger has 2 modes.
>1. Use a set of MSRs to send/recv information (undocumented so it's not
>   going to the hyperv-tlfs.h)
>2. Use hypercalls
>
>The first mode is based the following MSRs:
>1. Control/Status MSRs which either asks for a send/recv .
>2. Send/Recv MSRs each holds GPA where the send/recv buffers are.
>3. Pending MSR, holds a GPA to a PAGE that simply has a boolean that
>   indicates if there is data pending to issue a recv VMEXIT.
>
>The first mode implementation is to simply exit to user-space when
>either the control MSR or the pending MSR are being set.
>Then it's up-to userspace to implement the rest of the logic of sending/recving.
>
>In the second mode instead of using MSRs KNet will simply issue
>Hypercalls with the information to send/recv, in this mode the data
>being transferred is UDP encapsulated, unlike in the previous mode in
>which you get just the data to send.
>
>The new hypercalls will exit to userspace which will be incharge of
>re-encapsulating if needed the UDP packets to be sent.
>
>There is an issue though in which KDNet does not respect the hypercall
>page and simply issues vmcall/vmmcall instructions depending on the cpu
>type expecting them to be handled as it a real hypercall was issued.
>
>It's important to note that part of this feature has been subject to be
>removed in future versions of Windows, which is why some of the
>defintions will not be present the the TLFS but in the kvm hyperv header
>instead.
>
>v11:
>Fixed all reviewed by and rebased on latest origin/master
>
>Jon Doron (6):
>  x86/kvm/hyper-v: Explicitly align hcall param for kvm_hyperv_exit
>  x86/kvm/hyper-v: Simplify addition for custom cpuid leafs
>  x86/hyper-v: Add synthetic debugger definitions
>  x86/kvm/hyper-v: Add support for synthetic debugger capability
>  x86/kvm/hyper-v: enable hypercalls without hypercall page with syndbg
>  x86/kvm/hyper-v: Add support for synthetic debugger via hypercalls
>
>Vitaly Kuznetsov (1):
>  KVM: selftests: update hyperv_cpuid with SynDBG tests
>
> Documentation/virt/kvm/api.rst                |  18 ++
> arch/x86/include/asm/hyperv-tlfs.h            |   6 +
> arch/x86/include/asm/kvm_host.h               |  14 +
> arch/x86/kvm/hyperv.c                         | 242 ++++++++++++++++--
> arch/x86/kvm/hyperv.h                         |  33 +++
> arch/x86/kvm/trace.h                          |  51 ++++
> arch/x86/kvm/x86.c                            |  13 +
> include/uapi/linux/kvm.h                      |  13 +
> .../selftests/kvm/x86_64/hyperv_cpuid.c       | 143 +++++++----
> 9 files changed, 468 insertions(+), 65 deletions(-)
>
>-- 
>2.24.1
>
