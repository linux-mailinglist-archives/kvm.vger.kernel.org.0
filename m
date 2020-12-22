Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D58EA2E0DAC
	for <lists+kvm@lfdr.de>; Tue, 22 Dec 2020 18:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbgLVRI2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Dec 2020 12:08:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727225AbgLVRI1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Dec 2020 12:08:27 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CBCEC0613D6
        for <kvm@vger.kernel.org>; Tue, 22 Dec 2020 09:07:47 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id v1so1621179pjr.2
        for <kvm@vger.kernel.org>; Tue, 22 Dec 2020 09:07:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eYVylPqwemqXOslD5KTOspouQ/CKku7Ir0MIRXKYdl4=;
        b=SHriiGIO4oPPjHu02sMqcFbmeoYJm/ALL6gfOe0aBUamwsLNtnRnVrxJ8V0qz/8Eie
         MhNbBxt9Uit6gzkDxfWUVldl2nk1+7s8Pp63ACbaS2kWCq82EvJVxSTHirLGx+NQSUz4
         lj2p558wUdvWa50igzjl0CVwKrVOIMLeFuNO5s6PctWBnyN3vz/zu3EhooA27HakRXy4
         BGv5Ozhgt4O6/t+e5cz9MBGyhOf5txJajLUEzT07FNhj5R1rb/Ve/swAV55PYQrQ7QVH
         bHB8XdrLx7Ub1qeMOwoMiTK5YFJBpQDK21oY39BSjnD5W7g79Fc9KLbijYQcnO3GmudQ
         tBKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eYVylPqwemqXOslD5KTOspouQ/CKku7Ir0MIRXKYdl4=;
        b=BdJ8EM1FzWGVqUgCr5gFd2REi3mqLoVITEYJH9c5RiffxwM3IuZc7aNEGJwBgioM3N
         dtOLImrRvbCD1ALToGyGvAldT5lmbEv/ZCEQS0zzYrsTmsWvhJf7HtE5Y6St/bE70uwR
         mQAltMVodsAssT4ksQzmPg1kPj7F7DeOPrZjKkN3Ol/++Bi2uE6XjlHIt58NF8mHEA1Y
         BcZqleQ5J1Ga0ykobumBBYh+DGrrEfrjQcb5VzDdgDK/CeMvNWh2V5HuJ6rUeZKAfIjl
         0+2sz1tQ3VANodWsqwPI6CkVVL7Uo/NOQXAgbEX/7oZPZzwIyAgWwizJnFYgTCZBF+fZ
         /8WA==
X-Gm-Message-State: AOAM530Rl5MfaSRnZkH5qMZdRNqS6R7Wpqu/VvuA8+g7w5uQVhat6fyT
        RHZuC3/vK9eTStcOtYTHOfteNQ==
X-Google-Smtp-Source: ABdhPJzdNtfPlqe6hr1hOYL7wBudkmUafNfeuCl3NgoSBaM77WGCB5ufcnNuw4bb4N7xVgQPHP4+LQ==
X-Received: by 2002:a17:90b:4b8b:: with SMTP id lr11mr22630396pjb.85.1608656866946;
        Tue, 22 Dec 2020 09:07:46 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id p17sm10225489pfn.52.2020.12.22.09.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 09:07:46 -0800 (PST)
Date:   Tue, 22 Dec 2020 09:07:39 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Zdenek Kaspar <zkaspar82@gmail.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: Bad performance since 5.9-rc1
Message-ID: <X+In2zIA40Ku19cM@google.com>
References: <20201119040526.5263f557.zkaspar82@gmail.com>
 <20201201073537.6749e2d7.zkaspar82@gmail.com>
 <20201218203310.5025c17e.zkaspar82@gmail.com>
 <X+D6eJn92Vt6v+U1@google.com>
 <20201221221339.030684c4.zkaspar82@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201221221339.030684c4.zkaspar82@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 21, 2020, Zdenek Kaspar wrote:
> [  179.364305] WARNING: CPU: 0 PID: 369 at kvm_mmu_zap_oldest_mmu_pages+0xd1/0xe0 [kvm]
> [  179.365415] Call Trace:
> [  179.365443]  paging64_page_fault+0x244/0x8e0 [kvm]

This means the shadow page zapping is occuring because KVM is hitting the max
number of allowed MMU shadow pages.  Can you provide your QEMU command line?  I
can reproduce the performance degredation, but only by deliberately overriding
the max number of MMU pages via `-machine kvm-shadow-mem` to be an absurdly low
value.

> [  179.365596]  kvm_mmu_page_fault+0x376/0x550 [kvm]
> [  179.365725]  kvm_arch_vcpu_ioctl_run+0xbaf/0x18f0 [kvm]
> [  179.365772]  kvm_vcpu_ioctl+0x203/0x520 [kvm]
> [  179.365938]  __x64_sys_ioctl+0x338/0x720
> [  179.365992]  do_syscall_64+0x33/0x40
> [  179.366013]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
