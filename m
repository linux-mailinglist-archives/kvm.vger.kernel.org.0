Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82624130F59
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 10:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbgAFJYX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 04:24:23 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:39531 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725996AbgAFJYX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Jan 2020 04:24:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578302661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fSPVgoG8nSOQFecs0y2cFcNF0Dl0NQMBbgDK+MFMyEQ=;
        b=ZOBKiycirCQ/4f04RYb7uESo630nGC1ApWvGdzg49x94xpdFe6cPSIrI2G2JvLpxDXtgGi
        2s+2b+9uffqMSiskr6l+gh+QcispD4oqK9EvxZEfLnpEnjmZwysg2IQzKz9+YAwWDHuhr4
        2loyU/HzP9ALY+HZQg9Jl7djcu4hSPw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-qrWhIv16Pi-zL9oe8DlsZw-1; Mon, 06 Jan 2020 04:24:17 -0500
X-MC-Unique: qrWhIv16Pi-zL9oe8DlsZw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4175C8018C7;
        Mon,  6 Jan 2020 09:24:16 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BAA54272A6;
        Mon,  6 Jan 2020 09:24:14 +0000 (UTC)
Date:   Mon, 6 Jan 2020 10:24:12 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: Re: [kvm-unit-tests PATCH v3 10/18] arm/arm64: selftest: Add
 prefetch abort test
Message-ID: <20200106092412.xbluliqpemim6swj@kamzik.brq.redhat.com>
References: <1577808589-31892-1-git-send-email-alexandru.elisei@arm.com>
 <1577808589-31892-11-git-send-email-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1577808589-31892-11-git-send-email-alexandru.elisei@arm.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 31, 2019 at 04:09:41PM +0000, Alexandru Elisei wrote:
> When a guest tries to execute code from MMIO memory, KVM injects an
> external abort into that guest. We have now fixed the psci test to not
> fetch instructions from the I/O region, and it's not that often that a
> guest misbehaves in such a way. Let's expand our coverage by adding a
> proper test targetting this corner case.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/arm64/asm/esr.h |   3 ++
>  arm/selftest.c      | 112 +++++++++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 113 insertions(+), 2 deletions(-)
>

I like this test, but I have a few idea on how to make it more robust.
I'll send something out for review soon.

Thanks,
drew 

