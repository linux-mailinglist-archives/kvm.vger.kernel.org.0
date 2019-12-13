Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0CA511EABC
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 19:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728619AbfLMSwJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 13:52:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48597 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728489AbfLMSwJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 13:52:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576263128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P3ZEIhPIn6Z1Gd4TQtzF4BdjV6X2XjIymWao54He2LU=;
        b=hLmM0Pu4hBN3eqofKq76fZmv7uviMPSiTGiwJS67aMroEwh/OX43zrdpegTN7CkWbqyJQC
        ig7IjeK98beOiP1vStDLfVQgZQpXelS3vpwvZHoNV24KTdo/gAowo8hjVajuvHLCgse8hS
        Y8K2VsE1Hu3jv8RgMop+/JqXB2BIQXc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-p3zr2D7mOIuZ-rkiLB8eZQ-1; Fri, 13 Dec 2019 13:52:07 -0500
X-MC-Unique: p3zr2D7mOIuZ-rkiLB8eZQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C4754DB2D;
        Fri, 13 Dec 2019 18:52:05 +0000 (UTC)
Received: from kamzik.brq.redhat.com (ovpn-204-115.brq.redhat.com [10.40.204.115])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6976610016DA;
        Fri, 13 Dec 2019 18:51:51 +0000 (UTC)
Date:   Fri, 13 Dec 2019 19:51:41 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com,
        maz@kernel.org, andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 00/18] arm/arm64: Various fixes
Message-ID: <20191213185141.swqwi3jbkheakk3f@kamzik.brq.redhat.com>
References: <20191128180418.6938-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191128180418.6938-1-alexandru.elisei@arm.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 28, 2019 at 06:04:00PM +0000, Alexandru Elisei wrote:
> This is a combination of the fixes from my EL2 series [1] and other new
> fixes.
> 
> Changes in v2:
> * Fixed the prefetch abort test on QEMU by changing the address used to
>   cause the abort.
> 
> Summary of the patches:
> * Patch 1 adds coherent translation table walks for ARMv7 and removes
>   unneeded dcache maintenance.
> * Patches 2-4 make translation table updates more robust.
> * Patches 5-6 fix a pretty serious bug in our PSCI test, which was causing
>   an infinite loop of prefetch aborts.
> * Patches 7-10 add a proper test for prefetch aborts. The test now uses
>   mmu_clear_user.
> * Patches 11-13 are fixes for the timer test.
> * Patches 14-15 fix turning the MMU off.
> * Patches 16-18 are small fixes to make the code more robust, and perhaps
>   more important, remove unnecessary operations that might hide real bugs
>   in KVM.
> 
> Patches 1-4, 9, 18 are new. The rest are taken from the EL2 series, and
> I've kept the Reviewed-by tag where appropriate. There are no major
> changes, only those caused by rebasing on top of the current kvm-unit-tests
> version.

This series looks good to me, but it needs another rebase due to 
a299895b7abb ("Switch the order of the parameters in report() and
report_xfail()") and there are a few minor comments to address.

> 
> Please review.
> 
> [1] https://www.spinics.net/lists/kvm/msg196797.html

It's almost at the top of the TODO! I might even get to it during the
holidays. Of course it could probably use a rebase now too.

Thanks,
drew

