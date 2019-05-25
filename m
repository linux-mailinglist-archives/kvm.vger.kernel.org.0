Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 053AE2A3B0
	for <lists+kvm@lfdr.de>; Sat, 25 May 2019 11:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfEYJWS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 May 2019 05:22:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41544 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726464AbfEYJWS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 25 May 2019 05:22:18 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4P9MFTK092013
        for <kvm@vger.kernel.org>; Sat, 25 May 2019 05:22:16 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sq1uvspn5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Sat, 25 May 2019 05:22:16 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <sebott@linux.ibm.com>;
        Sat, 25 May 2019 10:22:08 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 25 May 2019 10:22:05 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4P9M4Sl31326410
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 May 2019 09:22:04 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B4954C046;
        Sat, 25 May 2019 09:22:04 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E4744C04A;
        Sat, 25 May 2019 09:22:03 +0000 (GMT)
Received: from sig-9-145-26-217.uk.ibm.com (unknown [9.145.26.217])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Sat, 25 May 2019 09:22:03 +0000 (GMT)
Date:   Sat, 25 May 2019 11:22:02 +0200 (CEST)
From:   Sebastian Ott <sebott@linux.ibm.com>
X-X-Sender: sebott@schleppi
To:     Michael Mueller <mimu@linux.ibm.com>
cc:     KVM Mailing List <kvm@vger.kernel.org>,
        Linux-S390 Mailing List <linux-s390@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Subject: Re: [PATCH v2 2/8] s390/cio: introduce DMA pools to cio
In-Reply-To: <20190523162209.9543-3-mimu@linux.ibm.com>
References: <20190523162209.9543-1-mimu@linux.ibm.com> <20190523162209.9543-3-mimu@linux.ibm.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
Organization: =?ISO-8859-15?Q?=22IBM_Deutschland_Research_&_Development_GmbH?=
 =?ISO-8859-15?Q?_=2F_Vorsitzende_des_Aufsichtsrats=3A_Matthias?=
 =?ISO-8859-15?Q?_Hartmann_Gesch=E4ftsf=FChrung=3A_Dirk_Wittkopp?=
 =?ISO-8859-15?Q?_Sitz_der_Gesellschaft=3A_B=F6blingen_=2F_Reg?=
 =?ISO-8859-15?Q?istergericht=3A_Amtsgericht_Stuttgart=2C_HRB_2432?=
 =?ISO-8859-15?Q?94=22?=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-TM-AS-GCONF: 00
x-cbid: 19052509-0028-0000-0000-000003714BC5
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19052509-0029-0000-0000-0000243103CD
Message-Id: <alpine.LFD.2.21.1905251115590.3359@schleppi>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-25_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=11 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905250066
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On Thu, 23 May 2019, Michael Mueller wrote:
> +static void __init cio_dma_pool_init(void)
> +{
> +	/* No need to free up the resources: compiled in */
> +	cio_dma_pool = cio_gp_dma_create(cio_get_dma_css_dev(), 1);

This can return NULL.

> +/**
> + * Allocate dma memory from the css global pool. Intended for memory not
> + * specific to any single device within the css. The allocated memory
> + * is not guaranteed to be 31-bit addressable.
> + *
> + * Caution: Not suitable for early stuff like console.
> + *
> + */

drivers/s390/cio/css.c:1121: warning: Function parameter or member 'size' not described in 'cio_dma_zalloc'

Reviewed-by: Sebastian Ott <sebott@linux.ibm.com>

