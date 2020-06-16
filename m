Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F72E1FAFAC
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 13:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728716AbgFPL6D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 07:58:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45776 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728481AbgFPL6D (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Jun 2020 07:58:03 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05GBVkN5176896;
        Tue, 16 Jun 2020 07:57:56 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31pc7qdxth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jun 2020 07:57:56 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05GBlCB6032338;
        Tue, 16 Jun 2020 07:57:56 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31pc7qdxsc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jun 2020 07:57:55 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05GBtjk4016289;
        Tue, 16 Jun 2020 11:57:53 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 31mpe7w980-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jun 2020 11:57:53 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05GBvoDl60555284
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jun 2020 11:57:50 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A55BC4C046;
        Tue, 16 Jun 2020 11:57:50 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC4D14C040;
        Tue, 16 Jun 2020 11:57:49 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.56.227])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 16 Jun 2020 11:57:49 +0000 (GMT)
Date:   Tue, 16 Jun 2020 13:57:26 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, mst@redhat.com, jasowang@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        David Gibson <david@gibson.dropbear.id.au>,
        Ram Pai <linuxram@us.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH v2 1/1] s390: virtio: let arch accept devices without
 IOMMU feature
Message-ID: <20200616135726.04fa8314.pasic@linux.ibm.com>
In-Reply-To: <ef235cc9-9d4b-1247-c01a-9dd1c63f437c@linux.ibm.com>
References: <1592224764-1258-1-git-send-email-pmorel@linux.ibm.com>
        <1592224764-1258-2-git-send-email-pmorel@linux.ibm.com>
        <20200616115202.0285aa08.pasic@linux.ibm.com>
        <ef235cc9-9d4b-1247-c01a-9dd1c63f437c@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-16_04:2020-06-15,2020-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 impostorscore=0 suspectscore=0 priorityscore=1501
 malwarescore=0 mlxlogscore=999 adultscore=0 spamscore=0 mlxscore=0
 clxscore=1015 cotscore=-2147483648 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006160084
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 16 Jun 2020 12:52:50 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> >>   int virtio_finalize_features(struct virtio_device *dev)
> >>   {
> >>   	int ret = dev->config->finalize_features(dev);
> >> @@ -179,6 +184,10 @@ int virtio_finalize_features(struct virtio_device *dev)
> >>   	if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1))
> >>   		return 0;
> >>   
> >> +	if (arch_needs_iommu_platform(dev) &&
> >> +		!virtio_has_feature(dev, VIRTIO_F_IOMMU_PLATFORM))
> >> +		return -EIO;
> >> +  
> > 
> > Why EIO?  
> 
> Because I/O can not occur correctly?
> I am open to suggestions.

We use -ENODEV if feature when the device rejects the features we
tried to negotiate (see virtio_finalize_features()) and -EINVAL when
the F_VERSION_1 and the virtio-ccw revision ain't coherent (in
virtio_ccw_finalize_features()). Any of those seems more fitting
that EIO to me. BTW does the error code itself matter in any way,
or is it just OK vs some error?

Regards,
Halil
