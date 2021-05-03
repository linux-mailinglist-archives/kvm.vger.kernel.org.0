Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D064A3713ED
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 13:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233062AbhECLD1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 07:03:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44640 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229811AbhECLD0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 May 2021 07:03:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620039753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/EWTxxOMyJ8o5vQqPG2GzHZg6NeXROGBPlWyiCjpcdE=;
        b=R6N9wgYzQSDcmBKSjgF3z4fE8gCGMC6CtwVwNVoW2OZTMVRwHhOyH2qx4Q9Dsq3L7FNdwm
        zDkk60gFvzdo6TlqwrQqZynfnbjmWMrN1/cM7Ls8OVP7bJPi3fRW08yWVM0Wo9ZVUESf+x
        7wqeUGKeBLH+EVy4vwb1w4Aq+md6HSc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-n13-wgSlPherQCuHILKc7Q-1; Mon, 03 May 2021 07:02:31 -0400
X-MC-Unique: n13-wgSlPherQCuHILKc7Q-1
Received: by mail-ed1-f70.google.com with SMTP id r19-20020a05640251d3b02903888eb31cafso3442413edd.13
        for <kvm@vger.kernel.org>; Mon, 03 May 2021 04:02:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/EWTxxOMyJ8o5vQqPG2GzHZg6NeXROGBPlWyiCjpcdE=;
        b=met0cW/U6BOQ6WXhoAf2nJDY2WWdrrHaekLo5+2/gcoCFpx6RFAURf8FYG6LiWFDPP
         qSfoFv/D3de79IFKM/jV9OMAQEMSWt4qvaMIrP23bzZfab81dYCpp3nFjxY+nwJRKZ2h
         n4BdrG7kRGsKaBPhU3JjatmYOjxwVgY1qVnIlMvVh8OLcip5mCPHBxUWaLD7AadmnDZP
         NC0pP/5ao9md11XWk2awGMALcd2IB+KZJEbg6r320yjF9F5mgjFdXip0h9Usnv1zAi5j
         LaYWjRFWevFOE1Mue26zzt3yH8sIXnxX5snQ2QE8hdlASsHxVMfSIRzlucBetCJwhwKa
         JhfQ==
X-Gm-Message-State: AOAM5300cnSjMu6LWeyvGIe4F64o+1oSz/Bu+UQG8tEuxLNcnTIJ47K2
        bHhLOyRN7AodNCMuGcgrzGXaoqrVI24EEsySAqdCQF8IsejIDIektvzGjFtwOOVo5hDgpPEPvgT
        tseAOjoAC3TDY
X-Received: by 2002:a05:6402:105a:: with SMTP id e26mr19293110edu.164.1620039750344;
        Mon, 03 May 2021 04:02:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJylvnp9X0+uVBO9kOzAkvwMm/5iedsAamzZstZykQGU7cKIbzwdsosMtEaYT37CgFxd2xM9kQ==
X-Received: by 2002:a05:6402:105a:: with SMTP id e26mr19293100edu.164.1620039750229;
        Mon, 03 May 2021 04:02:30 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id re14sm11068149ejb.20.2021.05.03.04.02.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 May 2021 04:02:29 -0700 (PDT)
Date:   Mon, 3 May 2021 13:02:28 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com
Subject: Re: [PATCH v2 1/5] KVM: selftests: Rename vm_handle_exception
Message-ID: <20210503110228.646nvqd3ickuolbu@gator.home>
References: <20210430232408.2707420-1-ricarkol@google.com>
 <20210430232408.2707420-2-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210430232408.2707420-2-ricarkol@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 30, 2021 at 04:24:03PM -0700, Ricardo Koller wrote:
> Rename the vm_handle_exception function to a name that indicates more
> clearly that it installs something: vm_install_vector_handler.
> 
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Suggested-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  tools/testing/selftests/kvm/include/x86_64/processor.h    | 2 +-
>  tools/testing/selftests/kvm/lib/x86_64/processor.c        | 4 ++--
>  tools/testing/selftests/kvm/x86_64/kvm_pv_test.c          | 2 +-
>  .../selftests/kvm/x86_64/userspace_msr_exit_test.c        | 8 ++++----
>  tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c       | 2 +-
>  5 files changed, 9 insertions(+), 9 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

