Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE3576C5FEF
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 07:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjCWGuA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 02:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbjCWGtv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 02:49:51 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE822D148
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 23:49:49 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32N6DOkN019335;
        Thu, 23 Mar 2023 06:49:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=0a9LAvzonueI0MupVIGSyowgzowsVlewk6znxeKrZZE=;
 b=BeZDBk10+BuHC8YGylSIAbiYP6SZSlhOXDTE4eBWIn3rfZfmvQoIcGtOYxYm/5BlJO0Y
 MssWUgW1KScP5Q7gsHRMlzaX+VAQQUqHM5Ybhan+EJgtSoxWZ2M+s6jhHnedzYoz1dA2
 Yq8ESOc8tVEgCtEOvYgi3yJZysdeKWGWBbWuIRDvMwDsreYe24evXx/pnAcXOVRXNT27
 YVKWbwgkOne3gNSFisGLoeID5yv6Tsn/CMSsy/a4F+4Jooe2una/B3x/oC7P5kjveuLY
 v2iNzNP43M8NyJURFxnWY4pcLfRn3vGnQ81z4RgS6djyaufT1VbeOA7hllsurZoIQnPq Eg== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pgha88n5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 06:49:44 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32MGZCgE017149;
        Thu, 23 Mar 2023 06:49:41 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3pd4x6ex16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 06:49:41 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32N6nd6r34472472
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Mar 2023 06:49:39 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D9AF20040;
        Thu, 23 Mar 2023 06:49:39 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54A7C20043;
        Thu, 23 Mar 2023 06:49:38 +0000 (GMT)
Received: from li-2f07f74c-278c-11b2-a85c-b11db323798e.ibm.com (unknown [9.43.46.250])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Thu, 23 Mar 2023 06:49:38 +0000 (GMT)
Date:   Thu, 23 Mar 2023 12:19:09 +0530
From:   Narayana Murty <nnmlinux@linux.vnet.ibm.com>
To:     Timothy Pearson <tpearson@raptorengineering.com>
Cc:     kvm <kvm@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 0/4] Reenable VFIO support on POWER systems
Message-ID: <ZBv2ZQyF36dJueYY@li-2f07f74c-278c-11b2-a85c-b11db323798e.ibm.com>
References: <8398361.16996856.1678123793664.JavaMail.zimbra@raptorengineeringinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8398361.16996856.1678123793664.JavaMail.zimbra@raptorengineeringinc.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: H0GqXic8qRkRTMfeGsrahGrikhmhkH-0
X-Proofpoint-GUID: H0GqXic8qRkRTMfeGsrahGrikhmhkH-0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-22_21,2023-03-22_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 impostorscore=0 clxscore=1011 suspectscore=0 lowpriorityscore=0
 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=788 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303230050
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 06, 2023 at 11:29:53AM -0600, Timothy Pearson wrote:
> This patch series reenables VFIO support on POWER systems.  It
> is based on Alexey Kardashevskiys's patch series, rebased and
> successfully tested under QEMU with a Marvell PCIe SATA controller
> on a POWER9 Blackbird host.
> 
> Alexey Kardashevskiy (3):
>   powerpc/iommu: Add "borrowing" iommu_table_group_ops
>   powerpc/pci_64: Init pcibios subsys a bit later
>   powerpc/iommu: Add iommu_ops to report capabilities and allow blocking
>     domains
> 
> Timothy Pearson (1):
>   Add myself to MAINTAINERS for Power VFIO support
> 
>  MAINTAINERS                               |   5 +
>  arch/powerpc/include/asm/iommu.h          |   6 +-
>  arch/powerpc/include/asm/pci-bridge.h     |   7 +
>  arch/powerpc/kernel/iommu.c               | 246 +++++++++++++++++++++-
>  arch/powerpc/kernel/pci_64.c              |   2 +-
>  arch/powerpc/platforms/powernv/pci-ioda.c |  36 +++-
>  arch/powerpc/platforms/pseries/iommu.c    |  27 +++
>  arch/powerpc/platforms/pseries/pseries.h  |   4 +
>  arch/powerpc/platforms/pseries/setup.c    |   3 +
>  drivers/vfio/vfio_iommu_spapr_tce.c       |  96 ++-------
>  10 files changed, 338 insertions(+), 94 deletions(-)
> 
> -- 
> 2.30.2
The Alexey Kardashevskiy (3) patchs  series tested on powerNV denali power9 system with 
NetXtreme BCM5719 Gigabit Ethernet PCIe  card.The vfio passthrough 
is working fine 

Tested-by : Narayana Murty <nnmlinux@linux.vnet.ibm.com>
