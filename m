Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D60A842BBB7
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 11:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239057AbhJMJh5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 05:37:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49478 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235811AbhJMJhx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 05:37:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634117750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZTKRszVVxh4cNNNrBxZ/ELkjttXYs1zNHg2NC0pK2Rs=;
        b=TzxeUJ+hwKkxkJb4tCFfwL+o3SBBeG4CjxBu16aEoRHot7OBLEyNmI5LQziQaQFokU8F5B
        zMRNP9TLWHg3EanOX5QFXXsLYRIh5zko4V4/u+m5VRVlyVB9f+yf+oVg9ezkKkHGQmq/Jx
        ZxFvXO3bqwoQC79li1A08+9P08/dKYA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-9ng6Z4VxMkiO80hr7nSUKQ-1; Wed, 13 Oct 2021 05:32:29 -0400
X-MC-Unique: 9ng6Z4VxMkiO80hr7nSUKQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B19A6A40C1;
        Wed, 13 Oct 2021 09:32:28 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0FF89196F8;
        Wed, 13 Oct 2021 09:32:26 +0000 (UTC)
Message-ID: <aff9dc19c1cc0b2fc40ca795a44b5cf32d2d97d0.camel@redhat.com>
Subject: Re: [PATCH 0/3] KVM: qemu patches for few KVM features I developed
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Philippe =?ISO-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>,
        kvm@vger.kernel.org,
        Alex =?ISO-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Date:   Wed, 13 Oct 2021 12:32:25 +0300
In-Reply-To: <20210914155214.105415-1-mlevitsk@redhat.com>
References: <20210914155214.105415-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-09-14 at 18:52 +0300, Maxim Levitsky wrote:
> These patches implement the qemu side logic to support
> the KVM features I developed recently.
> 
> First two patches are for features that are already accepted
> upstream, and I already posted them on the qemu mailing list once.
> 
> And the 3rd patch is for nested TSC scaling on SVM
> which isn't yet accepted in KVM but can already be added to qemu since
> it is conditional on KVM supporting it, and ABI wise it only relies
> on SVM spec.
> 
> Best regards,
>     Maxim Levitsky
> 
> Maxim Levitsky (3):
>   KVM: use KVM_{GET|SET}_SREGS2 when supported.
>   gdbstub: implement NOIRQ support for single step on KVM
>   KVM: SVM: add migration support for nested TSC scaling
> 
>  accel/kvm/kvm-all.c   |  30 +++++++++++
>  gdbstub.c             |  60 +++++++++++++++++----
>  include/sysemu/kvm.h  |  17 ++++++
>  target/i386/cpu.c     |   5 ++
>  target/i386/cpu.h     |   7 +++
>  target/i386/kvm/kvm.c | 122 +++++++++++++++++++++++++++++++++++++++++-
>  target/i386/machine.c |  53 ++++++++++++++++++
>  7 files changed, 282 insertions(+), 12 deletions(-)
> 
> -- 
> 2.26.3
> 
> 
Kind ping on these patches.

Best regards,
	Maxim Levitsky

