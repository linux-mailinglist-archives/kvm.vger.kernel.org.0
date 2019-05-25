Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAE472A3C1
	for <lists+kvm@lfdr.de>; Sat, 25 May 2019 11:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbfEYJor (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 May 2019 05:44:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43464 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726464AbfEYJoq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 25 May 2019 05:44:46 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4P9h67o127688
        for <kvm@vger.kernel.org>; Sat, 25 May 2019 05:44:45 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sq01d4rch-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Sat, 25 May 2019 05:44:45 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <sebott@linux.ibm.com>;
        Sat, 25 May 2019 10:44:43 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 25 May 2019 10:44:41 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4P9idZA42533104
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 May 2019 09:44:39 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58CC9A4055;
        Sat, 25 May 2019 09:44:39 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54223A404D;
        Sat, 25 May 2019 09:44:38 +0000 (GMT)
Received: from sig-9-145-26-217.uk.ibm.com (unknown [9.145.26.217])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Sat, 25 May 2019 09:44:38 +0000 (GMT)
Date:   Sat, 25 May 2019 11:44:37 +0200 (CEST)
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
Subject: Re: [PATCH v2 3/8] s390/cio: add basic protected virtualization
 support
In-Reply-To: <20190523162209.9543-4-mimu@linux.ibm.com>
References: <20190523162209.9543-1-mimu@linux.ibm.com> <20190523162209.9543-4-mimu@linux.ibm.com>
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
x-cbid: 19052509-0012-0000-0000-0000031F493A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19052509-0013-0000-0000-000021580869
Message-Id: <alpine.LFD.2.21.1905251124230.3359@schleppi>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-25_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905250069
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On Thu, 23 May 2019, Michael Mueller wrote:
>  static struct ccw_device * io_subchannel_allocate_dev(struct subchannel *sch)
>  {
>  	struct ccw_device *cdev;
> +	struct gen_pool *dma_pool;
>  
>  	cdev  = kzalloc(sizeof(*cdev), GFP_KERNEL);
> -	if (cdev) {
> -		cdev->private = kzalloc(sizeof(struct ccw_device_private),
> -					GFP_KERNEL | GFP_DMA);
> -		if (cdev->private)
> -			return cdev;
> -	}
> +	if (!cdev)
> +		goto err_cdev;
> +	cdev->private = kzalloc(sizeof(struct ccw_device_private),
> +				GFP_KERNEL | GFP_DMA);
> +	if (!cdev->private)
> +		goto err_priv;
> +	cdev->dev.coherent_dma_mask = sch->dev.coherent_dma_mask;
> +	cdev->dev.dma_mask = &cdev->dev.coherent_dma_mask;
> +	dma_pool = cio_gp_dma_create(&cdev->dev, 1);

This can return NULL. gen_pool_alloc will panic in this case.
[...]

> +err_dma_area:
> +		kfree(io_priv);

Indentation.

> +err_priv:
> +	put_device(&sch->dev);
> +	return ERR_PTR(-ENOMEM);
>  }
[...]
>  void ccw_device_update_sense_data(struct ccw_device *cdev)
>  {
>  	memset(&cdev->id, 0, sizeof(cdev->id));
> -	cdev->id.cu_type   = cdev->private->senseid.cu_type;
> -	cdev->id.cu_model  = cdev->private->senseid.cu_model;
> -	cdev->id.dev_type  = cdev->private->senseid.dev_type;
> -	cdev->id.dev_model = cdev->private->senseid.dev_model;
> +	cdev->id.cu_type   =
> +		cdev->private->dma_area->senseid.cu_type;
> +	cdev->id.cu_model  =
> +		cdev->private->dma_area->senseid.cu_model;
> +	cdev->id.dev_type  =
> +		cdev->private->dma_area->senseid.dev_type;
> +	cdev->id.dev_model =
> +		cdev->private->dma_area->senseid.dev_model;

These fit into one line.

> +/**
> + * Allocate zeroed dma coherent 31 bit addressable memory using
> + * the subchannels dma pool. Maximal size of allocation supported
> + * is PAGE_SIZE.
> + */
drivers/s390/cio/device_ops.c:708: warning: Function parameter or member 'cdev' not described in 'ccw_device_dma_zalloc'
drivers/s390/cio/device_ops.c:708: warning: Function parameter or member 'size' not described in 'ccw_device_dma_zalloc'


Reviewed-by: Sebastian Ott <sebott@linux.ibm.com>

