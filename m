Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1CDB65A37F
	for <lists+kvm@lfdr.de>; Sat, 31 Dec 2022 11:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbiLaKge (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 31 Dec 2022 05:36:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiLaKgc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 31 Dec 2022 05:36:32 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B84F310CC;
        Sat, 31 Dec 2022 02:36:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=TsW62Eh7HZlyUbKA+A/Mar8D1usoJjy+ytSxp2K7qwQ=; b=QA22YSLMn2agfVYH6FSpg1mj3P
        a+qBfYShWXWIUVFauSp93yGBDBapPj68IlXGGmZGXZsRa8ymjcxDuSvaru6yqQTdJRb8qYK5hbnZQ
        K8ykCC5gzrLrzKWe6FG4Fh6hzGzXodczlioEjUVwRBgjMx7tNX3cRaTp6spR1L7bMoI9sPx8ekkX1
        iPhBXhO7zccNwWisoIoBt9thLxUCNdot5J+1YPVitMIEnkRhAOVEr6YkzPSIgHmv4aIUZ7C3PAkmc
        zRzQmj0+s+dKk28uW79LoHJSVRxmn0aoo7+ZNmqp+4beAOEVKxV3lK3bmdEFUOqb43kx4uGhxhEDS
        k/cbqE1A==;
Received: from [2a00:23ee:1340:47e2:1764:351d:ad92:fc1a] (helo=[IPv6:::1])
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pBZDr-00H9Dw-34;
        Sat, 31 Dec 2022 10:36:16 +0000
Date:   Sat, 31 Dec 2022 10:36:11 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Yi Liu <yi.l.liu@intel.com>, Bjorn Helgaas <helgaas@kernel.org>,
        Major Saheb <majosaheb@gmail.com>
CC:     linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Zhenzhong Duan <zhenzhong.duan@gmail.com>
Subject: =?US-ASCII?Q?Re=3A_DMAR=3A_=5BDMA_Read_NO=5FPASID=5D_?= =?US-ASCII?Q?Request_device_=5B0b=3A00=2E0=5D_fault_?= =?US-ASCII?Q?addr_0xffffe000_=5Bfault_reason_0?= =?US-ASCII?Q?x06=5D_PTE_Read_access_is_not_set?=
User-Agent: K-9 Mail for Android
In-Reply-To: <0e5dc3e1-3be2-f7bc-a93c-d3e23739aa3d@intel.com>
References: <20221230192042.GA697217@bhelgaas> <29F6A46D-FBE0-40E3-992B-2C5CC6CD59D7@infradead.org> <0e5dc3e1-3be2-f7bc-a93c-d3e23739aa3d@intel.com>
Message-ID: <0E552CD3-1AD0-41FA-AF8B-186A916894CA@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 31 December 2022 10:13:37 GMT, Yi Liu <yi=2El=2Eliu@intel=2Ecom> wrote:
>On 2022/12/31 04:07, David Woodhouse wrote:
>>=20
>>=20
>> On 30 December 2022 19:20:42 GMT, Bjorn Helgaas <helgaas@kernel=2Eorg> =
wrote:
>>> Hi Major,
>>>=20
>>> Thanks for the report!
>>>=20
>>> On Wed, Dec 21, 2022 at 08:38:46PM +0530, Major Saheb wrote:
>>>> I have an ubuntu guest running on kvm , and I am passing it 10 qemu
>>>> emulated nvme drives
>>>>      <iommu model=3D'intel'>
>>>>        <driver intremap=3D'on' eim=3D'on'/>
>>>>      </iommu>
>>>> <qemu:arg value=3D'pcie-root-port,id=3Dpcie-root-port%d,slot=3D%d'/>
>>>> <qemu:arg value=3D'nvme,drive=3DNVME%d,serial=3D%s_%d,id=3DNVME%d,bus=
=3Dpcie-root-port%d'/>
>>>>=20
>>>> kernel
>>>> Linux node-1 5=2E15=2E0-56-generic #62-Ubuntu SMP ----- x86_64 x86_64
>>>> x86_64 GNU/Linux
>>>>=20
>>>> kernel command line
>>>> intel_iommu=3Don
>>>>=20
>>>> I have attached these drives to vfio-pcie=2E
>>>>=20
>>>> when I try to send IO commands to these drives VIA a userspace nvme
>>>> driver using VFIO I get
>>>> [ 1474=2E752590] DMAR: DRHD: handling fault status reg 2
>>>> [ 1474=2E754463] DMAR: [DMA Read NO_PASID] Request device [0b:00=2E0]
>>>> fault addr 0xffffe000 [fault reason 0x06] PTE Read access is not set
>>>>=20
>>>> Can someone explain to me what's happening here ?
>
>You can enable iommu debugfs (CONFIG_INTEL_IOMMU_DEBUGFS=3Dy) to check
>the mapping=2E In this file, you can see if the 0xffffe000 is mapped or
>not=2E
>
>/sys/kernel/debug/iommu/intel/domain_translation_struct

My first guess would be that it *was* using queues mapped at that address,=
 but was taken out of the IOMMU domain to be given to userspace, without st=
opping them=2E
