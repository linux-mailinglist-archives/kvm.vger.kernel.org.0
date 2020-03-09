Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBD517DF0D
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 12:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgCILxJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 07:53:09 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:46319 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725796AbgCILxJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Mar 2020 07:53:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583754788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KBLLFAeCjCkZQxE+M1dfsu6NPU5v8sNcOYuqxDc862s=;
        b=eYl96P4Zuy5RbKGX7vPU1G4gc9TkRS3jr8AKcaSTDVB6rW3t3GumTk8f30PYRogyaTWj8l
        08NKR3ynpL2rNm5aa0IUb5wSDL1UpzHOJCSbDrQwzzzXobGChg1+igBLJKKAOTUVBh/HUV
        2TczM5ULTvlZrg4dHyRbX8erjiM6K+w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-0VGg1kgrM-SYTigNxxjiNg-1; Mon, 09 Mar 2020 07:53:06 -0400
X-MC-Unique: 0VGg1kgrM-SYTigNxxjiNg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 815AD1401;
        Mon,  9 Mar 2020 11:53:04 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C2F1F1001B30;
        Mon,  9 Mar 2020 11:52:59 +0000 (UTC)
Date:   Mon, 9 Mar 2020 12:52:56 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Auger Eric <eric.auger@redhat.com>
Cc:     peter.maydell@linaro.org, thuth@redhat.com, kvm@vger.kernel.org,
        maz@kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        andre.przywara@arm.com, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu,
        eric.auger.pro@gmail.com
Subject: Re: [kvm-unit-tests PATCH v4 07/13] arm/arm64: ITS:
 its_enable_defaults
Message-ID: <20200309115256.beb3uwc2lyukavey@kamzik.brq.redhat.com>
References: <20200309102420.24498-1-eric.auger@redhat.com>
 <20200309102420.24498-8-eric.auger@redhat.com>
 <20200309113914.pg5522tvwazgrfec@kamzik.brq.redhat.com>
 <73691fc7-45f3-6274-019f-aa5b0d2a0c1b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73691fc7-45f3-6274-019f-aa5b0d2a0c1b@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 09, 2020 at 12:45:34PM +0100, Auger Eric wrote:
> >> -	for_each_present_cpu(cpu) {
> >> +	for (cpu = 0; cpu < nr_cpus; cpu++) {
> > 
> > You don't mention this change in the changelog.
> Hey, you can see the changelog is pretty long already & accurate. But
> you're right I missed that one and listing those changes too would have
> avoided me to put those changes in that patch.
> 
>  What's wrong with
> > using for_each_present_cpu() here?
> As you encouraged me to move the alloc into the it, I tried to do so but
> then discovered this was feasible for such kind of issue. At init time,
> CPUs have nott booted yet.

They may not have booted, but for_each_present_cpu() should still work
because the present mask is initialized at setup() time before the unit
test even starts.

Thanks,
drew

