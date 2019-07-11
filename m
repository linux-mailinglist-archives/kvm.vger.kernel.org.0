Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE3AE66160
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 23:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728286AbfGKVtG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 17:49:06 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40268 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726181AbfGKVtF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Jul 2019 17:49:05 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6BLlEdN123474;
        Thu, 11 Jul 2019 17:48:53 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tpag8p9d8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Jul 2019 17:48:53 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x6BLj3G9024794;
        Thu, 11 Jul 2019 21:48:52 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma01wdc.us.ibm.com with ESMTP id 2tjk96xvew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Jul 2019 21:48:52 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6BLmo8B54198590
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 21:48:50 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 654FC112063;
        Thu, 11 Jul 2019 21:48:50 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 78D1C112061;
        Thu, 11 Jul 2019 21:48:45 +0000 (GMT)
Received: from morokweng.localdomain (unknown [9.85.149.188])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTPS;
        Thu, 11 Jul 2019 21:48:45 +0000 (GMT)
References: <20190612111236.99538-1-pasic@linux.ibm.com> <20190612111236.99538-2-pasic@linux.ibm.com>
User-agent: mu4e 1.2.0; emacs 26.2
From:   Thiago Jung Bauermann <bauerman@linux.ibm.com>
To:     virtualization@lists.linux-foundation.org
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        Sebastian Ott <sebott@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Jason J. Herne" <jjherne@linux.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
Subject: Re: [PATCH v5 1/8] s390/mm: force swiotlb for protected virtualization
In-reply-to: <20190612111236.99538-2-pasic@linux.ibm.com>
Date:   Thu, 11 Jul 2019 18:48:40 -0300
Message-ID: <87k1codyyv.fsf@morokweng.localdomain>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-11_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=13 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907110238
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hello Halil,

Halil Pasic <pasic@linux.ibm.com> writes:

> On s390, protected virtualization guests have to use bounced I/O
> buffers.  That requires some plumbing.
>
> Let us make sure, any device that uses DMA API with direct ops correctly
> is spared from the problems, that a hypervisor attempting I/O to a
> non-shared page would bring.
>
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/Kconfig                   |  4 +++
>  arch/s390/include/asm/mem_encrypt.h | 18 +++++++++++
>  arch/s390/mm/init.c                 | 47 +++++++++++++++++++++++++++++
>  3 files changed, 69 insertions(+)
>  create mode 100644 arch/s390/include/asm/mem_encrypt.h
>
> diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> index 109243fdb6ec..88d8355b7bf7 100644
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -1,4 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0
> +config ARCH_HAS_MEM_ENCRYPT
> +        def_bool y
> +
>  config MMU
>  	def_bool y
>  

ARCH_HAS_MEM_ENCRYPT is already defined in arch/Kconfig, so I think you
can just select it in config S390 like you do with SWIOTLB.

> @@ -187,6 +190,7 @@ config S390
>  	select VIRT_CPU_ACCOUNTING
>  	select ARCH_HAS_SCALED_CPUTIME
>  	select HAVE_NMI
> +	select SWIOTLB
>  
>  
>  config SCHED_OMIT_FRAME_POINTER

-- 
Thiago Jung Bauermann
IBM Linux Technology Center
