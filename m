Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8733C17A35
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 15:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbfEHNSV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 09:18:21 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53652 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727506AbfEHNSU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 May 2019 09:18:20 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x48DGhgO064489
        for <kvm@vger.kernel.org>; Wed, 8 May 2019 09:18:19 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sby19jtkr-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 08 May 2019 09:18:18 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <sebott@linux.ibm.com>;
        Wed, 8 May 2019 14:18:16 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 8 May 2019 14:18:13 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x48DIBm448955618
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 May 2019 13:18:11 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C1EEA4057;
        Wed,  8 May 2019 13:18:11 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C6BAEA405B;
        Wed,  8 May 2019 13:18:10 +0000 (GMT)
Received: from dyn-9-152-212-30.boeblingen.de.ibm.com (unknown [9.152.212.30])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed,  8 May 2019 13:18:10 +0000 (GMT)
Date:   Wed, 8 May 2019 15:18:10 +0200 (CEST)
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
Subject: Re: [PATCH 05/10] s390/cio: introduce DMA pools to cio
In-Reply-To: <20190426183245.37939-6-pasic@linux.ibm.com>
References: <20190426183245.37939-1-pasic@linux.ibm.com> <20190426183245.37939-6-pasic@linux.ibm.com>
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
x-cbid: 19050813-0028-0000-0000-0000036B90E7
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050813-0029-0000-0000-0000242B0E18
Message-Id: <alpine.LFD.2.21.1905081447280.1773@schleppi>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-08_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=11 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=860 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905080085
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On Fri, 26 Apr 2019, Halil Pasic wrote:
> @@ -224,6 +228,9 @@ struct subchannel *css_alloc_subchannel(struct subchannel_id schid,
>  	INIT_WORK(&sch->todo_work, css_sch_todo);
>  	sch->dev.release = &css_subchannel_release;
>  	device_initialize(&sch->dev);
> +	sch->dma_mask = css_dev_dma_mask;
> +	sch->dev.dma_mask = &sch->dma_mask;
> +	sch->dev.coherent_dma_mask = sch->dma_mask;

Could we do:
	sch->dev.dma_mask = &sch->dev.coherent_dma_mask;
	sch->dev.coherent_dma_mask = css_dev_dma_mask;
?

> +#define POOL_INIT_PAGES 1
> +static struct gen_pool *cio_dma_pool;
> +/* Currently cio supports only a single css */
> +#define  CIO_DMA_GFP (GFP_KERNEL | __GFP_ZERO)

__GFP_ZERO has no meaning with the dma api (since all implementations do
an implicit zero initialization) but let's keep it for the sake of
documentation.

We need GFP_DMA here (which will return addresses < 2G on s390)!

> +void cio_gp_dma_free(struct gen_pool *gp_dma, void *cpu_addr, size_t size)
> +{
> +	if (!cpu_addr)
> +		return;
> +	memset(cpu_addr, 0, size);

Hm, normally I'd do the memset during alloc not during free - but maybe
this makes more sense here with your usecase in mind.

> @@ -1063,6 +1163,7 @@ static int __init css_bus_init(void)
>  		unregister_reboot_notifier(&css_reboot_notifier);
>  		goto out_unregister;
>  	}
> +	cio_dma_pool_init();

This is too late for early devices (ccw console!).

