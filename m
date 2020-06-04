Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4291EEAB6
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 20:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729310AbgFDS6L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 14:58:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40142 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728119AbgFDS6L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 14:58:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591297090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ltc7AAOMOPUPkUttvlRhefl/zKjkU15T+NRuGo1EozI=;
        b=AFPXnvtE6pegC5hFenIzgFjxHysipNz6D26fPI3UOX5zhEA5peqdraZwqvQJOJJhk+Qp4F
        w1LY856EuVW0XcDCv9yksJovZzk+0UbFW4RLAJVx/GTab1GsQdr5QjSiqd+g67ojzc8/sR
        EkTUfZD6pDqMSpYJfIiv9Vrsf2jTeR8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-nTKI732MNDSddMFR1WmXQA-1; Thu, 04 Jun 2020 14:58:08 -0400
X-MC-Unique: nTKI732MNDSddMFR1WmXQA-1
Received: by mail-wm1-f70.google.com with SMTP id g84so2254466wmf.4
        for <kvm@vger.kernel.org>; Thu, 04 Jun 2020 11:58:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ltc7AAOMOPUPkUttvlRhefl/zKjkU15T+NRuGo1EozI=;
        b=GbSe0SgvY7V4GhTmVqwWEAMIp1SXcw4oxKI4NumX5kjsKPm4fcE+74amuLZEWZTfT4
         BkkWIzAcIgQuyunqwFw3xssNIBTxMRNc5kP4hmQ7hpt9p5C4csfFc6GZgQMlJ00Lcszs
         KzBrwGl2co/KodMAVgBvD2NV/ZrhkbZf9Xzum15B6qmtWXVuZTtd3CdDqFt8dAGhy/FJ
         o5FpG5/xb7RYZS8GcMd8VNWBecnsIKp4rth+sBKKzNGE/o5U9NL6HKxNbfcv8o19v0/S
         KA0bTGij6B4CuNBSQZkgtTUmIOCAIf70WAjqjRJ+isky+UStm/R/Ty2DYDqswNrHdd/3
         gw1A==
X-Gm-Message-State: AOAM533V3LmTtfsLSZPayshslIMT3baUd2nMMIiQS8POPhUOK9wUKqP0
        UQUdPmEJj8TUHoQ9DiJC+EABZFU6wq0Ezhe2ksu4SXePz/1PrwRm9LM3AsXX9NmUDY3rCMdFDZ2
        EL8yvOIpTtIkQ
X-Received: by 2002:adf:ef83:: with SMTP id d3mr5430079wro.145.1591297087321;
        Thu, 04 Jun 2020 11:58:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw6Mh2tZEK9h1YhyPsdCcQG+RuzgRYNiaLHzFsWDjE7ghjh9VxuCSIkvZCInTNo/mgS+4OFpQ==
X-Received: by 2002:adf:ef83:: with SMTP id d3mr5430071wro.145.1591297087081;
        Thu, 04 Jun 2020 11:58:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:a0c0:5d2e:1d35:17bb? ([2001:b07:6468:f312:a0c0:5d2e:1d35:17bb])
        by smtp.gmail.com with ESMTPSA id u7sm9235367wrm.23.2020.06.04.11.58.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2020 11:58:06 -0700 (PDT)
Subject: Re: [GIT PULL] Please pull my kvm-ppc-next-5.8-1 tag
To:     Paul Mackerras <paulus@ozlabs.org>, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org
References: <20200601235357.GB428673@thinks.paulus.ozlabs.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <87d0e310-8714-0104-90ef-d4f82920f502@redhat.com>
Date:   Thu, 4 Jun 2020 20:58:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200601235357.GB428673@thinks.paulus.ozlabs.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/06/20 01:53, Paul Mackerras wrote:
> Hi Paolo,
> 
> Please do a pull from my kvm-ppc-next-5.8-1 tag to get a PPC KVM
> update for 5.8.  It's a relatively small update this time.  Michael
> Ellerman also has some commits in his tree that touch
> arch/powerpc/kvm, but I have not merged them here because there are no
> merge conflicts, and so they can go to Linus via Michael's tree.
> 
> Thanks,
> Paul.
> 
> The following changes since commit 9d5272f5e36155bcead69417fd12e98624e7faef:
> 
>   Merge tag 'noinstr-x86-kvm-2020-05-16' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip into HEAD (2020-05-20 03:40:09 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc tags/kvm-ppc-next-5.8-1
> 
> for you to fetch changes up to 11362b1befeadaae4d159a8cddcdaf6b8afe08f9:
> 
>   KVM: PPC: Book3S HV: Close race with page faults around memslot flushes (2020-05-28 10:56:42 +1000)
> 
> ----------------------------------------------------------------
> PPC KVM update for 5.8
> 
> - Updates and bug fixes for secure guest support
> - Other minor bug fixes and cleanups.
> 
> ----------------------------------------------------------------
> Chen Zhou (1):
>       KVM: PPC: Book3S HV: Remove redundant NULL check
> 
> Laurent Dufour (2):
>       KVM: PPC: Book3S HV: Read ibm,secure-memory nodes
>       KVM: PPC: Book3S HV: Relax check on H_SVM_INIT_ABORT
> 
> Paul Mackerras (2):
>       KVM: PPC: Book3S HV: Remove user-triggerable WARN_ON
>       KVM: PPC: Book3S HV: Close race with page faults around memslot flushes
> 
> Qian Cai (2):
>       KVM: PPC: Book3S HV: Ignore kmemleak false positives
>       KVM: PPC: Book3S: Fix some RCU-list locks
> 
> Tianjia Zhang (2):
>       KVM: PPC: Remove redundant kvm_run from vcpu_arch
>       KVM: PPC: Clean up redundant 'kvm_run' parameters
> 
>  arch/powerpc/include/asm/kvm_book3s.h    | 16 +++----
>  arch/powerpc/include/asm/kvm_host.h      |  1 -
>  arch/powerpc/include/asm/kvm_ppc.h       | 27 ++++++------
>  arch/powerpc/kvm/book3s.c                |  4 +-
>  arch/powerpc/kvm/book3s.h                |  2 +-
>  arch/powerpc/kvm/book3s_64_mmu_hv.c      | 12 ++---
>  arch/powerpc/kvm/book3s_64_mmu_radix.c   | 36 +++++++++++----
>  arch/powerpc/kvm/book3s_64_vio.c         | 18 ++++++--
>  arch/powerpc/kvm/book3s_emulate.c        | 10 ++---
>  arch/powerpc/kvm/book3s_hv.c             | 75 +++++++++++++++++---------------
>  arch/powerpc/kvm/book3s_hv_nested.c      | 15 +++----
>  arch/powerpc/kvm/book3s_hv_uvmem.c       | 14 ++++++
>  arch/powerpc/kvm/book3s_paired_singles.c | 72 +++++++++++++++---------------
>  arch/powerpc/kvm/book3s_pr.c             | 30 ++++++-------
>  arch/powerpc/kvm/booke.c                 | 36 +++++++--------
>  arch/powerpc/kvm/booke.h                 |  8 +---
>  arch/powerpc/kvm/booke_emulate.c         |  2 +-
>  arch/powerpc/kvm/e500_emulate.c          | 15 +++----
>  arch/powerpc/kvm/emulate.c               | 10 ++---
>  arch/powerpc/kvm/emulate_loadstore.c     | 32 +++++++-------
>  arch/powerpc/kvm/powerpc.c               | 72 +++++++++++++++---------------
>  arch/powerpc/kvm/trace_hv.h              |  6 +--
>  22 files changed, 276 insertions(+), 237 deletions(-)
> 

Pulled, thanks.

Paolo

