Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37E022B32E
	for <lists+kvm@lfdr.de>; Mon, 27 May 2019 13:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbfE0L0y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 07:26:54 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43852 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726322AbfE0L0y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 May 2019 07:26:54 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4RBHKBa145995
        for <kvm@vger.kernel.org>; Mon, 27 May 2019 07:26:53 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2srdcrnt2m-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 27 May 2019 07:26:52 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <mimu@linux.ibm.com>;
        Mon, 27 May 2019 12:26:51 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 27 May 2019 12:26:48 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4RBQkjq57278554
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 May 2019 11:26:46 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2EE7CA405B;
        Mon, 27 May 2019 11:26:46 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9AA0AA4054;
        Mon, 27 May 2019 11:26:45 +0000 (GMT)
Received: from [9.152.98.56] (unknown [9.152.98.56])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 May 2019 11:26:45 +0000 (GMT)
Reply-To: mimu@linux.ibm.com
Subject: Re: [PATCH v2 2/8] s390/cio: introduce DMA pools to cio
To:     Sebastian Ott <sebott@linux.ibm.com>
Cc:     KVM Mailing List <kvm@vger.kernel.org>,
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
References: <20190523162209.9543-1-mimu@linux.ibm.com>
 <20190523162209.9543-3-mimu@linux.ibm.com>
 <alpine.LFD.2.21.1905251115590.3359@schleppi>
From:   Michael Mueller <mimu@linux.ibm.com>
Organization: IBM
Date:   Mon, 27 May 2019 13:26:45 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.21.1905251115590.3359@schleppi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19052711-0012-0000-0000-0000031FE1DC
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19052711-0013-0000-0000-00002158A50B
Message-Id: <a42a0d7d-fd0b-b1bf-d4d9-3d64a8ff31f1@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-27_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905270081
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 25.05.19 11:22, Sebastian Ott wrote:
> 
> On Thu, 23 May 2019, Michael Mueller wrote:
>> +static void __init cio_dma_pool_init(void)
>> +{
>> +	/* No need to free up the resources: compiled in */
>> +	cio_dma_pool = cio_gp_dma_create(cio_get_dma_css_dev(), 1);
> 
> This can return NULL.

css_bus_init() will fail with -ENOMEM in v3

> 
>> +/**
>> + * Allocate dma memory from the css global pool. Intended for memory not
>> + * specific to any single device within the css. The allocated memory
>> + * is not guaranteed to be 31-bit addressable.
>> + *
>> + * Caution: Not suitable for early stuff like console.
>> + *
>> + */
> 
> drivers/s390/cio/css.c:1121: warning: Function parameter or member 'size' not described in 'cio_dma_zalloc'

will complete param description in v3

> 
> Reviewed-by: Sebastian Ott <sebott@linux.ibm.com>

Thanks!

> 

Michael

