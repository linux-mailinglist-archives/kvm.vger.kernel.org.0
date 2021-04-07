Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58EA4356CE9
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 15:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243965AbhDGNHV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 09:07:21 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1504 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233590AbhDGNHQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Apr 2021 09:07:16 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 137D2uMn099195;
        Wed, 7 Apr 2021 09:07:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=pp1;
 bh=SRzaWR+IRgqpnFF/lwZ2IoLOPZTIQfj893lxH0bxszw=;
 b=Pnu3z6LfLWqEn9Etmukm1oYwQRKUYFa6HmVy9GgNCJA86P0Bj8UMwku7bXwOLDerBl+S
 S80NXXGCqCx/ioC5P9P6JEra3dwkhWFDFSExP9DSeDqgZABWtnpffD+alYJTKgHU3ylq
 ardRcnbCPSoSzElZ4NsrnQn7FB9iZkbq8F1Yj/FwFS5oZxXwzezrJl7D8Z5YG1hKCgAW
 VLP+MWumzDASUIDOPIl8DZjadjgrHGEDTX1GtZuJgPChDdsOxZTKea1Jy840S48xF7b/
 zdmXxz25S8WkfXihtowcw4kv9pwenKN3fmmgx5T8rPnQqv3kcpaegvtvkYZj7RKsZ/vq bw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37rw7jh1e2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Apr 2021 09:07:04 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 137D30QO026851;
        Wed, 7 Apr 2021 13:07:02 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 37rvbqgr17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Apr 2021 13:07:02 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 137D6cuu31981940
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Apr 2021 13:06:38 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D21E42041;
        Wed,  7 Apr 2021 13:06:59 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D58684203F;
        Wed,  7 Apr 2021 13:06:58 +0000 (GMT)
Received: from osiris (unknown [9.171.27.208])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed,  7 Apr 2021 13:06:58 +0000 (GMT)
Date:   Wed, 7 Apr 2021 15:06:57 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     "weiyongjun (A)" <weiyongjun1@huawei.com>
Cc:     zhongbaisong <zhongbaisong@huawei.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH -next] s390/protvirt: fix error return code in
 uv_info_init()
Message-ID: <YG2ucbm3YziNrD2l@osiris>
References: <2f7d62a4-3e75-b2b4-951b-75ef8ef59d16@huawei.com>
 <0210417d-23df-1fdc-2af8-b2664ed2c484@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0210417d-23df-1fdc-2af8-b2664ed2c484@huawei.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pGbDLSZTBePRQus2mUi1CxIWkfJDjn9n
X-Proofpoint-ORIG-GUID: pGbDLSZTBePRQus2mUi1CxIWkfJDjn9n
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-07_08:2021-04-07,2021-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 suspectscore=0
 phishscore=0 adultscore=0 priorityscore=1501 spamscore=0 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104070090
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 07, 2021 at 08:48:19PM +0800, weiyongjun (A) wrote:
> > Fix to return a negative error code from the error handling
> > case instead of 0, as done elsewhere in this function.
> > 
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: Baisong Zhong <zhongbaisong@huawei.com>
> > ---
> >  arch/s390/kernel/uv.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> > index cbfbeab57c3b..370f664580af 100644
> > --- a/arch/s390/kernel/uv.c
> > +++ b/arch/s390/kernel/uv.c
> > @@ -460,8 +460,10 @@ static int __init uv_info_init(void)
> >          goto out_kobj;
> > 
> >      uv_query_kset = kset_create_and_add("query", NULL, uv_kobj);
> > -    if (!uv_query_kset)
> > +    if (!uv_query_kset) {
> > +        rc = -ENOMEM;
> >          goto out_ind_files;
> > +    }
> 
> Your patch is corrupted, please resend with correct format.

Fixed up, and applied anyway. Thanks.
