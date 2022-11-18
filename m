Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 700C762F2D0
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 11:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241615AbiKRKni (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 05:43:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241614AbiKRKnZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 05:43:25 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301769708D;
        Fri, 18 Nov 2022 02:43:24 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AI8I1MR018332;
        Fri, 18 Nov 2022 10:43:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=HHQzg5NjDFV8RZEfHK+gQgAu7fWEh8nE4zoa8Xwjlzk=;
 b=VelkNprgwXXKyz3pSBHO7JbgIz57VIaQSHyGOhJ25WnwNb8CFvUo+tN6X4wR2Nk8MfuZ
 pNKI03VNIKitDrsp/pzUyvl8xpf+2MzN67D2fk2JUVFb3fqfeIj4HVHw/j3+dh17s73k
 DUJ7CAo9gi1stVmZ0WGsYWYYOxDjyDW994E4DEIxzm1D6Kg/dtW+3wQGkQ9YpHaLhPXE
 60L2oq+Rop/M8hmj05kvNEim8Qa+YJa7Y/aQ/d0QCY09u07ZDxD8pkF/BbCvFBIwQECf
 n9l05UykyMqVYrRgxkJcqw8KP3CGItOnhHouM/mmIDmdO+GVMzg0SJj1vQWu5cJrK4Mq iw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kx6dwu83m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Nov 2022 10:43:23 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AIAaCZJ028141;
        Fri, 18 Nov 2022 10:43:21 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3kwthe0ufd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Nov 2022 10:43:21 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AIAhHXl64029108
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Nov 2022 10:43:18 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB7454203F;
        Fri, 18 Nov 2022 10:43:17 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3119C42042;
        Fri, 18 Nov 2022 10:43:17 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.43.4])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Fri, 18 Nov 2022 10:43:17 +0000 (GMT)
Date:   Fri, 18 Nov 2022 11:43:15 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     pasic@linux.ibm.com, akrowiak@linux.ibm.com, jjherne@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com
Subject: Re: [PATCH v2] s390/vfio-ap: GISA: sort out physical vs virtual
 pointers usage
Message-ID: <20221118114315.57bc2ad6@p-imbrenda>
In-Reply-To: <20221118100429.70453-1-nrb@linux.ibm.com>
References: <20221118100429.70453-1-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Zi29z_4anAkzMoLMoylNqEi3hG5ovT6B
X-Proofpoint-ORIG-GUID: Zi29z_4anAkzMoLMoylNqEi3hG5ovT6B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-17_06,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 suspectscore=0 mlxscore=0
 impostorscore=0 mlxlogscore=999 adultscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211180063
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 18 Nov 2022 11:04:29 +0100
Nico Boehr <nrb@linux.ibm.com> wrote:

> Fix virtual vs physical address confusion (which currently are the same)
> for the GISA when enabling the IRQ.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> Reviewed-by: Halil Pasic <pasic@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
> v1->v2:
> * remove useless cast
> 
>  drivers/s390/crypto/vfio_ap_ops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 0b4cc8c597ae..205a00105858 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -429,7 +429,7 @@ static struct ap_queue_status vfio_ap_irq_enable(struct vfio_ap_queue *q,
>  
>  	aqic_gisa.isc = nisc;
>  	aqic_gisa.ir = 1;
> -	aqic_gisa.gisa = (uint64_t)gisa >> 4;
> +	aqic_gisa.gisa = virt_to_phys(gisa) >> 4;
>  
>  	status = ap_aqic(q->apqn, aqic_gisa, h_nib);
>  	switch (status.response_code) {

