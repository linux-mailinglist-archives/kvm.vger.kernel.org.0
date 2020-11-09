Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DAC52AB357
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 10:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729881AbgKIJOe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 04:14:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50564 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727920AbgKIJOe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Nov 2020 04:14:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604913273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KihTEpPcQ9L598DE5g+gOSNJvgiBXCjZmgQm64yE1sM=;
        b=eyxTZQy6kVXp1XPi6O0b8+s6CPM/2WmcSvC5oB2n2VDfGBnstM7NMBCX/4Wpi8DP+eV+tx
        o4+dwwjEdx1Qt2VFsD6PH9/i85B7so2RckfPonItP0LE2hY3U5jiBibTp2OnEn4XA/3d25
        jKWWHuF1VhgC6tdWYRbAkDCTCZ7y3Es=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-131-j2dZGLI5P1KQahwIHa-MKg-1; Mon, 09 Nov 2020 04:14:29 -0500
X-MC-Unique: j2dZGLI5P1KQahwIHa-MKg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C3931868416;
        Mon,  9 Nov 2020 09:14:28 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.176])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E70845D9D2;
        Mon,  9 Nov 2020 09:14:22 +0000 (UTC)
Date:   Mon, 9 Nov 2020 10:14:20 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, Dave.Martin@arm.com,
        peter.maydell@linaro.org, eric.auger@redhat.com
Subject: Re: [PATCH 0/4] KVM: selftests: Add get-reg-list regression test
Message-ID: <20201109091420.s2ie4ae3ffsvupx2@kamzik.brq.redhat.com>
References: <20201029201703.102716-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201029201703.102716-1-drjones@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 29, 2020 at 09:16:59PM +0100, Andrew Jones wrote:
> Since Eric complained in his KVM Forum talk that there weren't any
> aarch64-specific KVM selftests, now he gets to review one. This test
> was inspired by recent regression report about get-reg-list losing
> a register between an old kernel version and a new one.
> 
> Thanks,
> drew
> 
> 
> Andrew Jones (4):
>   KVM: selftests: Don't require THP to run tests
>   KVM: selftests: Add aarch64 get-reg-list test
>   KVM: selftests: Update aarch64 get-reg-list blessed list
>   KVM: selftests: Add blessed SVE registers to get-reg-list
>

Paolo,

I see you silently applied this series to kvm/master, but there's a
v2 of the series on the list which incorporates Marc's comments. And,
the application of the series is bad, because you've squashed "Update
aarch64 get-reg-list blessed list" into "Add aarch64 get-reg-list test".
Those were created as separate patches on purpose in order for the
commit message of "Add aarch64 get-reg-list test" to reflect the kernel
version from which the blessed reg list was primed and the commit
message of "Update aarch64 get-reg-list blessed list" to explicitly
point out the new commits that introduce the new registers since the
priming kernel version up to the current kernel version. The division
was also done to ensure the same pattern is used for future updates of
the list.

Thanks,
drew

