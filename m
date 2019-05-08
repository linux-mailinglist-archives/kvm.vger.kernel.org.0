Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF2D617AFA
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 15:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfEHNq4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 09:46:56 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37444 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725910AbfEHNq4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 May 2019 09:46:56 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x48DNAIY003636
        for <kvm@vger.kernel.org>; Wed, 8 May 2019 09:46:53 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sbxqw5sm3-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 08 May 2019 09:46:52 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <sebott@linux.ibm.com>;
        Wed, 8 May 2019 14:46:47 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 8 May 2019 14:46:44 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x48DkhgB34144498
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 May 2019 13:46:43 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 199D0AE055;
        Wed,  8 May 2019 13:46:43 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E1C4AE051;
        Wed,  8 May 2019 13:46:42 +0000 (GMT)
Received: from dyn-9-152-212-30.boeblingen.de.ibm.com (unknown [9.152.212.30])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed,  8 May 2019 13:46:42 +0000 (GMT)
Date:   Wed, 8 May 2019 15:46:42 +0200 (CEST)
From:   Sebastian Ott <sebott@linux.ibm.com>
X-X-Sender: sebott@schleppi
To:     Halil Pasic <pasic@linux.ibm.com>
cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
Subject: Re: [PATCH 06/10] s390/cio: add basic protected virtualization
 support
In-Reply-To: <20190426183245.37939-7-pasic@linux.ibm.com>
References: <20190426183245.37939-1-pasic@linux.ibm.com> <20190426183245.37939-7-pasic@linux.ibm.com>
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
x-cbid: 19050813-0008-0000-0000-000002E48C64
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050813-0009-0000-0000-000022510DCF
Message-Id: <alpine.LFD.2.21.1905081522300.1773@schleppi>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-08_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=785 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905080086
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On Fri, 26 Apr 2019, Halil Pasic wrote:
>  static struct ccw_device * io_subchannel_allocate_dev(struct subchannel *sch)
>  {
[..]
> +	cdev->private = kzalloc(sizeof(struct ccw_device_private),
> +				GFP_KERNEL | GFP_DMA);

Do we still need GFP_DMA here (since we now have cdev->private->dma_area)?

> @@ -1062,6 +1082,14 @@ static int io_subchannel_probe(struct subchannel *sch)
>  	if (!io_priv)
>  		goto out_schedule;
>  
> +	io_priv->dma_area = dma_alloc_coherent(&sch->dev,
> +				sizeof(*io_priv->dma_area),
> +				&io_priv->dma_area_dma, GFP_KERNEL);

This needs GFP_DMA.
You use a genpool for ccw_private->dma and not for iopriv->dma - looks
kinda inconsistent.

