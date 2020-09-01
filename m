Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 422E9258D05
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 12:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbgIAKuP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 06:50:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31815 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725989AbgIAKuM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 06:50:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598957410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0Fbx3HtDgDwoy6VUvyMLJHxJtjj7AUVDGgoI6t2FUsU=;
        b=FYfBU9warbOkhs56UQ+RwPDWnaSJVFo5Lm536ymejVNupsPj7ovshfotpeov0WSDAsnG8n
        /fGqHLyRar2awdlgyzr1Xh5PuqyHFktBhCPAXFSrNlrbrCDpjMMjAOtY9usMBIX1bUHI0C
        dYsEnas/9Du5R6A+jZFK4tn5ZUoGplo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-eHZhEsD3P9OYkqV8MFw-SA-1; Tue, 01 Sep 2020 06:50:07 -0400
X-MC-Unique: eHZhEsD3P9OYkqV8MFw-SA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA4652FD03;
        Tue,  1 Sep 2020 10:50:04 +0000 (UTC)
Received: from [10.36.112.51] (ovpn-112-51.ams2.redhat.com [10.36.112.51])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 64E945C1A3;
        Tue,  1 Sep 2020 10:50:01 +0000 (UTC)
Subject: Re: [kvm-unit-tests RFC 0/4] KVM: arm64: Statistical Profiling
 Extension Tests
To:     Alexandru Elisei <alexandru.elisei@arm.com>,
        eric.auger.pro@gmail.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org,
        drjones@redhat.com, andrew.murray@arm.com, sudeep.holla@arm.com,
        maz@kernel.org, will@kernel.org, haibo.xu@linaro.org
References: <20200831193414.6951-1-eric.auger@redhat.com>
 <b5eb2cd0-9798-6e40-7690-78992eca30fd@arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <817f34fb-9476-e3b8-d9a1-bebf6be11683@redhat.com>
Date:   Tue, 1 Sep 2020 12:49:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <b5eb2cd0-9798-6e40-7690-78992eca30fd@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alexandru,

On 9/1/20 11:24 AM, Alexandru Elisei wrote:
> Hi Eric,
> 
> These patches are extremely welcome! I took over the KVM SPE patches from Andrew
> Murray, and I was working on something similar to help with development.
Cool.
> 
> The KVM series on the public mailing list work only by chance because it is
> impossible to reliably map the SPE buffer at EL2 when profiling triggers a stage 2
> data abort. That's because the DABT is reported asynchronously via the buffer
> management interrupt and the faulting IPA is not reported anywhere. I'm trying to
> fix this issue in the next iteration of the series, and then I'll come back to
> your patches for review and testing.
Sure. Looking forward to reviewing your respin.

Thanks

Eric
> 
> Thanks,
> 
> Alex
> 
> On 8/31/20 8:34 PM, Eric Auger wrote:
>> This series implements tests exercising the Statistical Profiling
>> Extensions.
>>
>> This was tested with associated unmerged kernel [1] and QEMU [2]
>> series.
>>
>> Depending on the comments, I can easily add other tests checking
>> more configs, additional events and testing migration too. I hope
>> this can be useful when respinning both series.
>>
>> All SPE tests can be launched with:
>> ./run_tests.sh -g spe
>> Tests also can be launched individually. For example:
>> ./arm-run arm/spe.flat -append 'spe-buffer'
>>
>> The series can be found at:
>> https://github.com/eauger/kut/tree/spe_rfc
>>
>> References:
>> [1] [PATCH v2 00/18] arm64: KVM: add SPE profiling support
>> [2] [PATCH 0/7] target/arm: Add vSPE support to KVM guest
>>
>> Eric Auger (4):
>>   arm64: Move get_id_aa64dfr0() in processor.h
>>   spe: Probing and Introspection Test
>>   spe: Add profiling buffer test
>>   spe: Test Profiling Buffer Events
>>
>>  arm/Makefile.common       |   1 +
>>  arm/pmu.c                 |   1 -
>>  arm/spe.c                 | 463 ++++++++++++++++++++++++++++++++++++++
>>  arm/unittests.cfg         |  24 ++
>>  lib/arm64/asm/barrier.h   |   1 +
>>  lib/arm64/asm/processor.h |   5 +
>>  6 files changed, 494 insertions(+), 1 deletion(-)
>>  create mode 100644 arm/spe.c
>>
> 

