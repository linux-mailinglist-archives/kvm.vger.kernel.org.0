Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F084517A933
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 16:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgCEPtV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 10:49:21 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20253 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726111AbgCEPtU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 10:49:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583423359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cXuIpqJI7rTjh/BFJajlRtBWEXkuawKoUjndvA3VFKA=;
        b=CRKLx0erMM3FIe8+jeAFxh1Ca14RtpnfFIJCdbwQ4KzLItypjM8Fglj/Gz6hUcncoMcwM7
        FnxXVMEbVyWKfjrAGKF1JyVO0jtIFOrantLdllzWxsX9A9JiF4erYQ0ZcfIqx/fNsq1zNX
        jGkZY8UxjXwd4ix9jVeIx1BN7bWH6Sw=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-MaAjaO6YPP-QBKpCYzAO_A-1; Thu, 05 Mar 2020 10:49:18 -0500
X-MC-Unique: MaAjaO6YPP-QBKpCYzAO_A-1
Received: by mail-qv1-f69.google.com with SMTP id dr18so3266982qvb.14
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2020 07:49:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cXuIpqJI7rTjh/BFJajlRtBWEXkuawKoUjndvA3VFKA=;
        b=nVBmFDCdJI7Gb5BEi39EpmIs1QQ0LytF92okcWGy9IcPq7bCVxMX1JQyY29DjLdWyB
         VQGPCl5oT3w7FF/O89G2a9gv24WAvK4Pnnf+WoKEffF31OvY2ptMe1xhx860tTWzEPMU
         5D01q7M7asbAERLVsHtnuZTaL8VKDtCkdZKhqARpZQAT/qFVd/Y/VjD8BD/M0MQB4EoA
         5EO5hfEoVqhCJ5JoFT5W/wGPJkbqx3FRI+hiwT27I92N7F9Voi41dKcvonAJbpa1NINa
         ySscOKy7EyZTQ+MzoVp8u2x/Pg+uVsnm9FMQ4XJAi7MOjorfpB5jetjUN4rPeAo4BOMs
         FY3w==
X-Gm-Message-State: ANhLgQ1952OQl+1nVn0Dqi9Y9jD7G2IwRfG6XeznUnnf+dEuFWMpNL65
        GcNpIj+yi4V/ibtzLXgKYCteD54o+2Nlvjwq+3InOcbh5bUp7FQZhGlFE1oNaTh3x78ROlg9dNt
        dqDfm7tqGqnaP
X-Received: by 2002:ad4:480f:: with SMTP id g15mr6888251qvy.247.1583423357346;
        Thu, 05 Mar 2020 07:49:17 -0800 (PST)
X-Google-Smtp-Source: ADFU+vughxL1Zr78oB78siwCRXuDqPRslu3YgV7DyjXfzDStD9FiLos09QdINXSzciM7YTSBPMwNVA==
X-Received: by 2002:ad4:480f:: with SMTP id g15mr6888224qvy.247.1583423356972;
        Thu, 05 Mar 2020 07:49:16 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id s56sm310900qtk.9.2020.03.05.07.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 07:49:16 -0800 (PST)
Date:   Thu, 5 Mar 2020 10:49:14 -0500
From:   Peter Xu <peterx@redhat.com>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: Drop gfn_to_pfn_atomic()
Message-ID: <20200305154914.GE7146@xz-x1>
References: <2256821e496c45f5baf97f3f8f884d59@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2256821e496c45f5baf97f3f8f884d59@huawei.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 05, 2020 at 01:52:24AM +0000, linmiaohe wrote:
> Peter Xu <peterx@redhat.com> writes:
> >It's never used anywhere now.
> >
> >Signed-off-by: Peter Xu <peterx@redhat.com>
> >---
> > include/linux/kvm_host.h | 1 -
> > virt/kvm/kvm_main.c      | 6 ------
> > 2 files changed, 7 deletions(-)
> 
> It seems we prefer to use kvm_vcpu_gfn_to_pfn_atomic instead now. :)
> Patch looks good, but maybe we should update Documentation/virt/kvm/locking.rst too:
> In locking.rst:
> 	For direct sp, we can easily avoid it since the spte of direct sp is fixed
> 	to gfn. For indirect sp, before we do cmpxchg, we call gfn_to_pfn_atomic()
> 	to pin gfn to pfn, because after gfn_to_pfn_atomic()
> 
> Thanks.
> Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

Yes we should update the document, however instead of replacing with
the vcpu helper, I'd rather reorganize the locking doc for a bit more
because the fast page fault is not enabled for indirect sp at all,
afaict...

I'll add a pre-requisite patch to refine the document, and keep your
r-b for this patch.

Thanks,

-- 
Peter Xu

