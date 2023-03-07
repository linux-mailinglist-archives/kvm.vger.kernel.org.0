Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29D206AD37A
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 01:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjCGAvo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 19:51:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjCGAvj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 19:51:39 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1AF65C13B
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 16:51:37 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id c4so7104495pfl.0
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 16:51:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20210112.gappssmtp.com; s=20210112; t=1678150297;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wsioy8YQ3ef0OYXv0f7Vnj0EbcAmvBSGfdorprLbJW4=;
        b=muySL/VhVKsYAWt04ZF9CGXG6QTc6kss3k6hWPN+YONdDLxY+5fKCqpCpwsJh5bi9W
         JoeIL7rOVrgLgtgZltzKJSzd+sY9hDcfRRcTBqlxVBp/QMHMCyMFpKiAY1IrmY1TOPyX
         IFGKXJ9s50VLQfgiQKdIKkAvw5WyNjE44HIm/FQ0SN7JUVlD3bxztPdcyzj2+zF2SRsm
         X8f4nscd/PPw3FCqDo2cjR1SyE0DRKDYgxumcjrwR5GSWdAD2vteiS4lzh1QSqXZUw1r
         VWDrBgSMyeCIdWusyZfMHtAvmq26OSpWHz0gSJP77GFiCk7drT5vdR6k9PG1+54tVuVr
         eIaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678150297;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wsioy8YQ3ef0OYXv0f7Vnj0EbcAmvBSGfdorprLbJW4=;
        b=4YoVDcrGS7Lr2Wx+EFnCsKpx1YNZJIxASYnmnubq/fyWRfZeE2HWS5dHDHrVCaFGwo
         nUcyjGTzJiH0OEv6Jrj2qRh26kNnAA7xS/5DYAJIuaotXiyQE1lvpYYT/Z0+6fOZj3vp
         1gnxYZkjt6RvdBHR7krTbqfTjPK9O9Cc02cvrEiYe7LnGRAQOfAXze8a4N4NyNp4WvFb
         jE3b2sTr6HCbFPVhPEunZplsqWixVOTyO6HXlUPHWzzQx9w9aKWH2rwYbsboZKXwkDCs
         +bpJrHWa0hlrdR/ldAwdt8046abQsUKUs9m7C78rxT8IReca8Q/Dx+yLnZKhChazwVe+
         aE3g==
X-Gm-Message-State: AO0yUKXCGyhU7oAtYExntSLYdxQ5k8WByyPW3zuxCKT8zhMy20K5ykVt
        Q2F+BRTUlruX+JUQkyl/l0g0hBKneQUyHSTht64=
X-Google-Smtp-Source: AK7set+uFltOs1KHmf9btICVwkCk7dCtXIeaSLBg5SFcZ+fSVx0nzri/1pV4bqayxV2ChQKguhCCIA==
X-Received: by 2002:a62:5251:0:b0:619:b116:d1f5 with SMTP id g78-20020a625251000000b00619b116d1f5mr8597698pfb.7.1678150297304;
        Mon, 06 Mar 2023 16:51:37 -0800 (PST)
Received: from [192.168.10.153] (ppp118-208-169-253.cbr-trn-nor-bras39.tpg.internode.on.net. [118.208.169.253])
        by smtp.gmail.com with ESMTPSA id v15-20020a62a50f000000b005b02ddd852dsm6992618pfm.142.2023.03.06.16.51.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 16:51:36 -0800 (PST)
Message-ID: <04c9ac5e-cd1b-034a-2c97-01a376e9564c@ozlabs.ru>
Date:   Tue, 7 Mar 2023 11:51:31 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:108.0) Gecko/20100101
 Thunderbird/108.0
Subject: Re: [PATCH v2 0/4] Reenable VFIO support on POWER systems
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>,
        Timothy Pearson <tpearson@raptorengineering.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm <kvm@vger.kernel.org>
References: <8398361.16996856.1678123793664.JavaMail.zimbra@raptorengineeringinc.com>
 <20230306164607.1455ee81.alex.williamson@redhat.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <20230306164607.1455ee81.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 07/03/2023 10:46, Alex Williamson wrote:
> On Mon, 6 Mar 2023 11:29:53 -0600 (CST)
> Timothy Pearson <tpearson@raptorengineering.com> wrote:
> 
>> This patch series reenables VFIO support on POWER systems.  It
>> is based on Alexey Kardashevskiys's patch series, rebased and
>> successfully tested under QEMU with a Marvell PCIe SATA controller
>> on a POWER9 Blackbird host.
>>
>> Alexey Kardashevskiy (3):
>>    powerpc/iommu: Add "borrowing" iommu_table_group_ops
>>    powerpc/pci_64: Init pcibios subsys a bit later
>>    powerpc/iommu: Add iommu_ops to report capabilities and allow blocking
>>      domains
>>
>> Timothy Pearson (1):
>>    Add myself to MAINTAINERS for Power VFIO support
>>
>>   MAINTAINERS                               |   5 +
>>   arch/powerpc/include/asm/iommu.h          |   6 +-
>>   arch/powerpc/include/asm/pci-bridge.h     |   7 +
>>   arch/powerpc/kernel/iommu.c               | 246 +++++++++++++++++++++-
>>   arch/powerpc/kernel/pci_64.c              |   2 +-
>>   arch/powerpc/platforms/powernv/pci-ioda.c |  36 +++-
>>   arch/powerpc/platforms/pseries/iommu.c    |  27 +++
>>   arch/powerpc/platforms/pseries/pseries.h  |   4 +
>>   arch/powerpc/platforms/pseries/setup.c    |   3 +
>>   drivers/vfio/vfio_iommu_spapr_tce.c       |  96 ++-------
>>   10 files changed, 338 insertions(+), 94 deletions(-)
>>
> 
> For vfio and MAINTAINERS portions,
> 
> Acked-by: Alex Williamson <alex.williamson@redhat.com>
> 
> I'll note though that spapr_tce_take_ownership() looks like it copied a
> bug from the old tce_iommu_take_ownership() where tbl and tbl->it_map
> are tested before calling iommu_take_ownership() but not in the unwind
> loop, ie. tables we might have skipped on setup are unconditionally
> released on unwind.  Thanks,


Ah, true, a bug. Thanks for pointing out.


-- 
Alexey
