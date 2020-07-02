Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03565212372
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 14:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729036AbgGBMgh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 08:36:37 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:46238 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728861AbgGBMgh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Jul 2020 08:36:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593693395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eu+kJ7Ihi6JK3py5LXu63NgxsOOft47n07UKf0C3e2o=;
        b=dniBuTXP1Xqy4cBMYX0ew/P6A9pEXWT0HkKWRnhZJ4+xJLLqJTuLaOjxpy//QkpAMbqgxV
        NbdsFBtlbOAx4rgPCWsPUlDMByM09CKxxDn6Bo52VVSrl5wpIJkDkK9/dIj3beRLw8n7LS
        dszV5pZjMipXu9uWjaL1iIG3elcX0L4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-e9ZQNIuSODy3s9yfzPHlpA-1; Thu, 02 Jul 2020 08:36:34 -0400
X-MC-Unique: e9ZQNIuSODy3s9yfzPHlpA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C90BB107ACF8;
        Thu,  2 Jul 2020 12:36:32 +0000 (UTC)
Received: from [10.36.112.70] (ovpn-112-70.ams2.redhat.com [10.36.112.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 983D773FD1;
        Thu,  2 Jul 2020 12:36:31 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 3/8] arm64: microbench: gic: Add gicv4.1
 support for ipi latency test.
To:     Marc Zyngier <maz@kernel.org>,
        Jingyi Wang <wangjingyi11@huawei.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
 <20200702030132.20252-4-wangjingyi11@huawei.com>
 <fe9699e3ee2131fe800911aea1425af4@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <dabc2406-4a7f-61cf-cdbd-b0b79d97bf2c@redhat.com>
Date:   Thu, 2 Jul 2020 14:36:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <fe9699e3ee2131fe800911aea1425af4@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 7/2/20 10:22 AM, Marc Zyngier wrote:
> On 2020-07-02 04:01, Jingyi Wang wrote:
>> If gicv4.1(sgi hardware injection) supported, we test ipi injection
>> via hw/sw way separately.
> 
> nit: active-less SGIs are not strictly a feature of GICv4.1 (you could
> imagine a GIC emulation offering the same thing). Furthermore, GICv4.1
> isn't as such visible to the guest itself (it only sees a GICv3).

By the way, I have just downloaded the latest GIC spec from the ARM
portal and I still do not find the GICD_CTLR_ENABLE_G1A,
GICD_CTLR_nASSGIreq and GICD_TYPER2_nASSGIcap. Do I miss something?

Thanks

Eric


> 
> Thanks,
> 
>         M.

