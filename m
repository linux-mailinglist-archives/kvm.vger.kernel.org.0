Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8583D125F
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 17:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238948AbhGUOrl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 10:47:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41276 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239858AbhGUOrg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Jul 2021 10:47:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626881292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FdvVljLxaRoKu02p/XKHt8pLC1+aQhmZqpHxlBYeaQA=;
        b=EnFABkCBlEpTRx22j5dbH5LNiTrSfZmp030dnCwscwek56a1jN8q/BBrjBAHMglx43TV9t
        e3lIG89HXy7zIIyHnB5wQxMeiK4SKdNs/Wr4Y5dmDjHLKainX2ezEh1Du5KJ5/Y/msM/Cl
        THNCTvr+vgIqLlan07um0BFrZvLFjUs=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-498-2wmls2rGNLyIKH7QUOSlWw-1; Wed, 21 Jul 2021 11:28:11 -0400
X-MC-Unique: 2wmls2rGNLyIKH7QUOSlWw-1
Received: by mail-io1-f72.google.com with SMTP id t10-20020a6b5f0a0000b029052c7ba9d3c3so1817332iob.17
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 08:28:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FdvVljLxaRoKu02p/XKHt8pLC1+aQhmZqpHxlBYeaQA=;
        b=hMpiilwFU5VFF6Qop520jB1qIQESXGiqqMI06+aclmPdbYFCc4tJDuUISIKqGhOzY1
         QVCB3whEq5bSSJ21azje7J5ALdGJ19Vd3jykNJFy7ieSgEOs4RqEEKrin7Cc+XSRScuP
         2Te4NyA5Z805Ot9ps2JyeXeWXLGFSu7eTgzjvULmzq0IOhTDFi7WfWGofHBIn7NYG23s
         JB8OlAFDDYb7xbnOCCMPFgjUuJUAO9I/I967u+IMtPNc2fvyiExNAT9wjhyDs93rL+8t
         ZWsg0UifOzg2BGkY76iChnnV7aaRJvObk3xwB5TXsxC9Xdl/BS03QPuQOd9Tz1/7Qfir
         W3Hg==
X-Gm-Message-State: AOAM530NTtTqNp8bqOxCsGxV50xuJeODpWeE8TBnB4uwRV68aJpWKJVw
        9fYWCQEp3stCgmtu/IqY6DJ4lDf00rwEZfWQbC/un0247bnhnOVUKs5ZMdOwvbnEeWUaYrhB/pJ
        g9hEm8jtSx9l/
X-Received: by 2002:a02:cf31:: with SMTP id s17mr31776935jar.46.1626881291060;
        Wed, 21 Jul 2021 08:28:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyXsUlUSfaaSu/VgVW9B0i+z/O7lclfXTzWxt6V521RZmWaIu4pVkdUyLATZI2zGAntaYUAnw==
X-Received: by 2002:a02:cf31:: with SMTP id s17mr31776920jar.46.1626881290789;
        Wed, 21 Jul 2021 08:28:10 -0700 (PDT)
Received: from gator ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id k4sm1848796ilu.67.2021.07.21.08.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 08:28:10 -0700 (PDT)
Date:   Wed, 21 Jul 2021 17:28:08 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Marc Zyngier <maz@kernel.org>,
        Raghavendra Rao Anata <rananta@google.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 00/12] KVM: Add idempotent controls for migrating
 system counter state
Message-ID: <20210721152808.lsnphkl3urz6bu3v@gator>
References: <20210716212629.2232756-1-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210716212629.2232756-1-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 16, 2021 at 09:26:17PM +0000, Oliver Upton wrote:
> KVM's current means of saving/restoring system counters is plagued with
> temporal issues. At least on ARM64 and x86, we migrate the guest's
> system counter by-value through the respective guest system register
> values (cntvct_el0, ia32_tsc). Restoring system counters by-value is
> brittle as the state is not idempotent: the host system counter is still
> oscillating between the attempted save and restore. Furthermore, VMMs
> may wish to transparently live migrate guest VMs, meaning that they
> include the elapsed time due to live migration blackout in the guest
> system counter view. The VMM thread could be preempted for any number of
> reasons (scheduler, L0 hypervisor under nested) between the time that
> it calculates the desired guest counter value and when KVM actually sets
> this counter state.
> 
> Despite the value-based interface that we present to userspace, KVM
> actually has idempotent guest controls by way of system counter offsets.
> We can avoid all of the issues associated with a value-based interface
> by abstracting these offset controls in new ioctls. This series
> introduces new vCPU device attributes to provide userspace access to the
> vCPU's system counter offset.
> 
> Patch 1 adopts Paolo's suggestion, augmenting the KVM_{GET,SET}_CLOCK
> ioctls to provide userspace with a (host_tsc, realtime) instant. This is
> essential for a VMM to perform precise migration of the guest's system
> counters.
> 
> Patches 2-3 add support for x86 by shoehorning the new controls into the
> pre-existing synchronization heuristics.
> 
> Patches 4-5 implement a test for the new additions to
> KVM_{GET,SET}_CLOCK.
> 
> Patches 6-7 implement at test for the tsc offset attribute introduced in
> patch 3.
> 
> Patch 8 adds a device attribute for the arm64 virtual counter-timer
> offset.
> 
> Patch 9 extends the test from patch 7 to cover the arm64 virtual
> counter-timer offset.
> 
> Patch 10 adds a device attribute for the arm64 physical counter-timer
> offset. Currently, this is implemented as a synthetic register, forcing
> the guest to trap to the host and emulating the offset in the fast exit
> path. Later down the line we will have hardware with FEAT_ECV, which
> allows the hypervisor to perform physical counter-timer offsetting in
> hardware (CNTPOFF_EL2).
> 
> Patch 11 extends the test from patch 7 to cover the arm64 physical
> counter-timer offset.
> 
> Patch 12 introduces a benchmark to measure the overhead of emulation in
> patch 10.
> 
> Physical counter benchmark
> --------------------------
> 
> The following data was collected by running 10000 iterations of the
> benchmark test from Patch 6 on an Ampere Mt. Jade reference server, A 2S
> machine with 2 80-core Ampere Altra SoCs. Measurements were collected
> for both VHE and nVHE operation using the `kvm-arm.mode=` command-line
> parameter.
> 
> nVHE
> ----
> 
> +--------------------+--------+---------+
> |       Metric       | Native | Trapped |
> +--------------------+--------+---------+
> | Average            | 54ns   | 148ns   |
> | Standard Deviation | 124ns  | 122ns   |
> | 95th Percentile    | 258ns  | 348ns   |
> +--------------------+--------+---------+
> 
> VHE
> ---
> 
> +--------------------+--------+---------+
> |       Metric       | Native | Trapped |
> +--------------------+--------+---------+
> | Average            | 53ns   | 152ns   |
> | Standard Deviation | 92ns   | 94ns    |
> | 95th Percentile    | 204ns  | 307ns   |
> +--------------------+--------+---------+
> 
> This series applies cleanly to the following commit:
> 
> 1889228d80fe ("KVM: selftests: smm_test: Test SMM enter from L2")
> 
> v1 -> v2:
>   - Reimplemented as vCPU device attributes instead of a distinct ioctl.
>   - Added the (realtime, host_tsc) instant support to
>     KVM_{GET,SET}_CLOCK
>   - Changed the arm64 implementation to broadcast counter offset values
>     to all vCPUs in a guest. This upholds the architectural expectations
>     of a consistent counter-timer across CPUs.
>   - Fixed a bug with traps in VHE mode. We now configure traps on every
>     transition into a guest to handle differing VMs (trapped, emulated).
>

Oops, I see there's a v3 of this series. I'll switch to reviewing that. I
think my comments / r-b's apply to that version as well though.

Thanks,
drew 

