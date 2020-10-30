Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F5B2A0CE9
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 18:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgJ3R4r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 13:56:47 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21952 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725808AbgJ3R4q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Oct 2020 13:56:46 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09UHWtKF078426;
        Fri, 30 Oct 2020 13:56:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=ZYNnNaSApJHx4sx5l+K+HK6ka0FoPn3LtDoSJjmz/BE=;
 b=VTLOjI/M3yCFPCvQFIc7qvrUz8RIoQqk7bWs8yrqBVdrr2cdZFaZavAVY0ty6pFK2hik
 5Fa6sgs1cpu+8KvPQ3oti1hTjel5gH4mmhqEJjA08xtgueO4TNUK4Hu6EyzBCB0CzYse
 RlRMSRN3zB5AAl/+y1ujUZStalS+KSWtPY3Tx1A4wXkB168LQWVYOR6Hvn89XmyYyrtU
 wlNUeBw5PmSC1Lyeud6wRDVaXkxti7LCXg6Ato8ldMTPhyW0rnEJdd7jp5bzZjv2xRih
 c/jlOCXr56z2pelKXnw50C1WgLYlnNIOqHewGNH3a+lxF1JrBwRg/JJwFZHwj5jvWTF8 1A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34gp9hjrm7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 13:56:44 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09UHXEtv082150;
        Fri, 30 Oct 2020 13:56:44 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34gp9hjrkh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 13:56:44 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09UHqodA027038;
        Fri, 30 Oct 2020 17:56:42 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 34fv15rr2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 17:56:42 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09UHudx225887078
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Oct 2020 17:56:39 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10DC7AE045;
        Fri, 30 Oct 2020 17:56:39 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 57A8EAE055;
        Fri, 30 Oct 2020 17:56:38 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.172.93])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 30 Oct 2020 17:56:38 +0000 (GMT)
Date:   Fri, 30 Oct 2020 18:56:36 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v11 01/14] s390/vfio-ap: No need to disable IRQ after
 queue reset
Message-ID: <20201030185636.60fcca52.pasic@linux.ibm.com>
In-Reply-To: <7a2c5930-9c37-8763-7e5d-c08a3638e6a1@linux.ibm.com>
References: <20201022171209.19494-1-akrowiak@linux.ibm.com>
        <20201022171209.19494-2-akrowiak@linux.ibm.com>
        <20201027074846.30ee0ddc.pasic@linux.ibm.com>
        <7a2c5930-9c37-8763-7e5d-c08a3638e6a1@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-30_08:2020-10-30,2020-10-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 priorityscore=1501 phishscore=0 impostorscore=0 mlxlogscore=999
 adultscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010300127
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 29 Oct 2020 19:29:35 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> >> +void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
> >> +{
> >> +	struct vfio_ap_queue *q;
> >> +	struct ap_queue *queue;
> >> +	int apid, apqi;
> >> +
> >> +	queue = to_ap_queue(&apdev->device);  
> > What is the benefit of rewriting this? You introduced
> > queue just to do queue->ap_dev to get to the apdev you
> > have in hand in the first place.  
> 
> I'm not quite sure what you're asking. This function is
> the callback function specified via the function pointer
> specified via the remove field of the struct ap_driver
> when the vfio_ap device driver is registered with the
> AP bus. That callback function takes a struct ap_device
> as a parameter. What am I missing here?

Please compare the removed function vfio_ap_queue_dev_remove() with the
added function vfio_ap_mdev_remove_queue() line by line. It should
become clear.

Regards,
Halil
