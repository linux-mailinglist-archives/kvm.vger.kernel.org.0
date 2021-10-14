Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0901442D65B
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 11:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbhJNJsX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 05:48:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27658 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229468AbhJNJsW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Oct 2021 05:48:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634204778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PylHmPl0SG/ZoxPAA6fPJqlLgNo18jKHe8Um3g+bA5Y=;
        b=Jw+7hI0VfBJUApq+wgMA5l82brcHp+UQWS2IpZNI8WWw2nbB8SYOqRJqwmntipP7bioaRP
        aNpYUSS5S6GEGu/NEFhZTfcXh2Br2sAls1jcG9MTeJ+YmJPUQI8GHtrXWpvfXP4nf4ksUF
        TsYHGbMCjEvxpkFJN9bESZWJcY8Uw6A=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-178-mcEX2gOONDWF_Bbk6fQCkw-1; Thu, 14 Oct 2021 05:46:16 -0400
X-MC-Unique: mcEX2gOONDWF_Bbk6fQCkw-1
Received: by mail-ed1-f71.google.com with SMTP id d11-20020a50cd4b000000b003da63711a8aso4640523edj.20
        for <kvm@vger.kernel.org>; Thu, 14 Oct 2021 02:46:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PylHmPl0SG/ZoxPAA6fPJqlLgNo18jKHe8Um3g+bA5Y=;
        b=rPPaNTVOvcCxMZVaNc8uyX1EkxKzL/3/ELKvEjW5jgAW+b7VowgDfcLiCQBP4HI8jW
         EIDRabPcV+CJQThFtKaxDJX2KZNsMgEGEAyj+izCo1uUGk3gW56hEk7guFRG7YidiRjh
         40t6c6V0/RKGdk3cmAtsCyzFN3UNHpUadTkx2OPjPbZFpZUkdoEXLqKgcVa4eLMEhtYR
         TPLo33RA5jagGVrefndyhXwwtzfe+9/Ujs4/MhQpQsEKgSOQ53PQYevt12EGdawkJIQj
         OEBgN6nk6UzRKSHE6XkhGt7X0iI5G938DFQR8vSSFvEmM0efKI7Oe48FoqHz59KSrKQ6
         Uj9g==
X-Gm-Message-State: AOAM5309D0L6T5m7psXYbcVb8ctrfpNSiRqdkqrm+dH3jsV+toXes9xR
        jFVPYX1iCQC3YYwSSon/99jbT01RKHcGB5OMaQiTfnvOocHLuYlIBNtn7OHo/leZuy/jucgy7sh
        2OHzxd0cDgh9g
X-Received: by 2002:a17:906:3542:: with SMTP id s2mr2593133eja.379.1634204775414;
        Thu, 14 Oct 2021 02:46:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzOgCLWmlm5MOCVVA6YxDujZIjE3h0etTvc1U7zsLegPhP22dW9U+g1/6pZq5RjKKaGxfKpFA==
X-Received: by 2002:a17:906:3542:: with SMTP id s2mr2593114eja.379.1634204775260;
        Thu, 14 Oct 2021 02:46:15 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id oz11sm1440208ejc.72.2021.10.14.02.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 02:46:14 -0700 (PDT)
Date:   Thu, 14 Oct 2021 11:46:13 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, will@kernel.org,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, mark.rutland@arm.com, pbonzini@redhat.com,
        oupton@google.com, qperret@google.com, kernel-team@android.com,
        tabba@google.com
Subject: Re: [PATCH v9 17/22] KVM: arm64: pkvm: Handle GICv3 traps as required
Message-ID: <20211014094613.tnx4xwyqrxj4jmnq@gator.home>
References: <20211010145636.1950948-12-tabba@google.com>
 <20211013120346.2926621-1-maz@kernel.org>
 <20211013120346.2926621-7-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013120346.2926621-7-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 13, 2021 at 01:03:41PM +0100, Marc Zyngier wrote:
> Forward accesses to the ICV_*SGI*_EL1 registers to EL1, and
> emulate ICV_SRE_EL1 by returning a fixed value.
> 
> This should be enough to support GICv3 in a protected guest.

Out of curiosity, has the RVIC work / plans been dropped?

Thanks,
drew

