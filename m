Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0CCD21A2FE
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 17:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgGIPHX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 11:07:23 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8328 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726615AbgGIPHX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jul 2020 11:07:23 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 069F3WmU001750;
        Thu, 9 Jul 2020 11:07:15 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 325r2cm6kb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jul 2020 11:07:14 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 069F3thV004462;
        Thu, 9 Jul 2020 11:07:13 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 325r2cm6j6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jul 2020 11:07:13 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 069F17MF021314;
        Thu, 9 Jul 2020 15:07:11 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 325u410ntv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jul 2020 15:07:11 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 069F78sO65208640
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Jul 2020 15:07:08 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C36DB4C063;
        Thu,  9 Jul 2020 15:07:08 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 060C34C044;
        Thu,  9 Jul 2020 15:07:08 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.152.61])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Jul 2020 15:07:07 +0000 (GMT)
Date:   Thu, 9 Jul 2020 17:06:15 +0200
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
Message-ID: <20200709170615.468236da.pasic@linux.ibm.com>
In-Reply-To: <c9be019f-236e-5e44-64b6-0875cd40ab11@linux.ibm.com>
References: <1594283959-13742-1-git-send-email-pmorel@linux.ibm.com>
        <1594283959-13742-3-git-send-email-pmorel@linux.ibm.com>
        <20200709105733.6d68fa53.cohuck@redhat.com>
        <270d8674-0f73-0a38-a2a7-fbc1caa44301@linux.ibm.com>
        <20200709164700.09a83069.pasic@linux.ibm.com>
        <c9be019f-236e-5e44-64b6-0875cd40ab11@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-09_08:2020-07-09,2020-07-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 spamscore=0 phishscore=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007090112
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 9 Jul 2020 16:51:04 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> 
> 
> On 2020-07-09 16:47, Halil Pasic wrote:
> > On Thu, 9 Jul 2020 12:51:58 +0200
> > Pierre Morel <pmorel@linux.ibm.com> wrote:
> > 
> >>>> +int arch_validate_virtio_features(struct virtio_device *dev)
> >>>> +{
> >>>> +	if (!is_prot_virt_guest())
> >>>> +		return 0;
> >>>> +
> >>>> +	if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1)) {
> >>>> +		dev_warn(&dev->dev, "device must provide VIRTIO_F_VERSION_1\n");
> >>>
> >>> I'd probably use "legacy virtio not supported with protected
> >>> virtualization".
> >>>    
> >>>> +		return -ENODEV;
> >>>> +	}
> >>>> +
> >>>> +	if (!virtio_has_feature(dev, VIRTIO_F_IOMMU_PLATFORM)) {
> >>>> +		dev_warn(&dev->dev,
> >>>> +			 "device must provide VIRTIO_F_IOMMU_PLATFORM\n");
> >>>
> >>> "support for limited memory access required for protected
> >>> virtualization"
> >>>
> >>> ?
> >>>
> >>> Mentioning the feature flag is shorter in both cases, though.
> >>
> >> And I think easier to look for in case of debugging purpose.
> >> I change it if there is more demands.
> > 
> > Not all our end users are kernel and/or qemu developers. I find the
> > messages from v4 less technical, more informative, and way better.
> > 
> > Regards,
> > Halil
> > 
> 
> Can you please tell me the messages you are speaking of, because for me 
> the warning's messages are exactly the same in v4 and v5!?
> 
> I checked many times, but may be I still missed something.
> 

Sorry, my bad. My brain is over-generating. The messages where discussed
at v3 and Connie made a very similar proposal to the one above which I
seconded (for reference look at Message-ID:
<833c71f2-0057-896a-5e21-2c6263834402@linux.ibm.com>). I was under the
impression that it got implemented in v4, but it was not. That's why I
ended up talking bs.

Regards,
Halil

