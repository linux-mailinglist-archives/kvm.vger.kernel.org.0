Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22B02347BCF
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 16:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236536AbhCXPMK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 11:12:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36803 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236429AbhCXPLn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Mar 2021 11:11:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616598703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=COLoYEzhl8p7Nd5f4N2/IVzBYYsgsv5l6H2MtrNaU6w=;
        b=SayNzyB5EW7WG7TRt70m2qLx/OQ9E3e2ivQpWRJMuw5neoSlnAnaLS7Vu2Wh7EXFIiNYpZ
        Rs+G6S4RFeXCi/4EGOuR3HTt2P3BoAkdO7BxklB0xxYv/xb13Zo9fApCHdLkhjSkUg6kgf
        hx/XW/mps9xWB7TVgSEikz0r6PJEViE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-Nlo_pYyJOp2zdxFjiEIUyg-1; Wed, 24 Mar 2021 11:11:40 -0400
X-MC-Unique: Nlo_pYyJOp2zdxFjiEIUyg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BDBE6187D7EF;
        Wed, 24 Mar 2021 15:11:04 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9932C2B0DC;
        Wed, 24 Mar 2021 15:11:01 +0000 (UTC)
Date:   Wed, 24 Mar 2021 16:10:58 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, Paolo Bonzini <pbonzini@redhat.com>,
        Eric Auger <eric.auger@redhat.com>, qperret@google.com,
        kernel-team@android.com, Andrew Walbran <qwandor@google.com>
Subject: Re: [kvm-unit-tests PATCH] arm: pmu: Fix failing PMU test when no
 PMU is available
Message-ID: <20210324151058.7as6ndvaz7ocho7y@kamzik.brq.redhat.com>
References: <20210324143856.2079220-1-maz@kernel.org>
 <23046a95-5876-e7a2-e4a4-6012a760815d@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23046a95-5876-e7a2-e4a4-6012a760815d@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 24, 2021 at 02:50:05PM +0000, Alexandru Elisei wrote:
> Hi Marc,
> 
> Thank you for the patch! I have already sent a patch for this [1], which was
> queued by Drew [2], but apparently has not landed in master yet.
> 
> [1] https://www.spinics.net/lists/kvm-arm/msg44084.html
> [2]
> https://gitlab.com/rhdrjones/kvm-unit-tests/-/commit/241dac4cadfd7d7ace8c8c3f0613376311b4e785

Thanks to you both for the patch and sorry for not getting Alexandru's
patch in early enough to avoid the double reporting and fixing. I
plan to send Paolo an MR as soon as tomorrow that includes the
patch and many others.

Thanks,
drew

