Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC5221A26A
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 16:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgGIOrs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 10:47:48 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35306 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726517AbgGIOrs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jul 2020 10:47:48 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 069EWbET029312;
        Thu, 9 Jul 2020 10:47:40 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32637wcf4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jul 2020 10:47:39 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 069EWnJ0030541;
        Thu, 9 Jul 2020 10:47:39 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32637wcf3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jul 2020 10:47:39 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 069Eir4R013124;
        Thu, 9 Jul 2020 14:47:36 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 325k2qrfw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jul 2020 14:47:36 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 069ElXWW57868576
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Jul 2020 14:47:33 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B5E29AE055;
        Thu,  9 Jul 2020 14:47:33 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0D72AAE051;
        Thu,  9 Jul 2020 14:47:33 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.152.61])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Jul 2020 14:47:32 +0000 (GMT)
Date:   Thu, 9 Jul 2020 16:47:00 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, mst@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v5 2/2] s390: virtio: PV needs VIRTIO I/O device
 protection
Message-ID: <20200709164700.09a83069.pasic@linux.ibm.com>
In-Reply-To: <270d8674-0f73-0a38-a2a7-fbc1caa44301@linux.ibm.com>
References: <1594283959-13742-1-git-send-email-pmorel@linux.ibm.com>
        <1594283959-13742-3-git-send-email-pmorel@linux.ibm.com>
        <20200709105733.6d68fa53.cohuck@redhat.com>
        <270d8674-0f73-0a38-a2a7-fbc1caa44301@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-09_08:2020-07-09,2020-07-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 mlxlogscore=999 clxscore=1015 malwarescore=0
 priorityscore=1501 spamscore=0 suspectscore=0 phishscore=0 mlxscore=0
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007090104
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 9 Jul 2020 12:51:58 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> >> +int arch_validate_virtio_features(struct virtio_device *dev)
> >> +{
> >> +	if (!is_prot_virt_guest())
> >> +		return 0;
> >> +
> >> +	if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1)) {
> >> +		dev_warn(&dev->dev, "device must provide VIRTIO_F_VERSION_1\n");  
> > 
> > I'd probably use "legacy virtio not supported with protected
> > virtualization".
> >   
> >> +		return -ENODEV;
> >> +	}
> >> +
> >> +	if (!virtio_has_feature(dev, VIRTIO_F_IOMMU_PLATFORM)) {
> >> +		dev_warn(&dev->dev,
> >> +			 "device must provide VIRTIO_F_IOMMU_PLATFORM\n");  
> > 
> > "support for limited memory access required for protected
> > virtualization"
> > 
> > ?
> > 
> > Mentioning the feature flag is shorter in both cases, though.  
> 
> And I think easier to look for in case of debugging purpose.
> I change it if there is more demands.

Not all our end users are kernel and/or qemu developers. I find the
messages from v4 less technical, more informative, and way better.

Regards,
Halil
