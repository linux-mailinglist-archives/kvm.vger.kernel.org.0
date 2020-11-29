Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15C6A2C7726
	for <lists+kvm@lfdr.de>; Sun, 29 Nov 2020 02:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbgK2BSI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Nov 2020 20:18:08 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52232 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725862AbgK2BSI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 28 Nov 2020 20:18:08 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AT11oHN179305;
        Sat, 28 Nov 2020 20:17:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=gcYMb9L+JpBSA2IQC6btSmBpNhEjPPtDns0l1/dUaxY=;
 b=iUtO14fYm4k3CZkqWIfaFbBBwOXZRTC72RT1tpLradyUJ51+MpnHn2Pi26B/RKTyLq0B
 vy6+Vzzcji4shq4BW8Dc3PpGK8iucO6oa/VHx567HDUjgwqbBeZSC5yPHhM4Pc09P00E
 c+MZea5UN1B6g5Xd85VIDO8lBbhTlv7dSLUWGi7R+FRIG7x1ObeVxV99pLz3uEXQSt94
 yJ9l/QhaG4SkZlJtavEQLHjWqZaJKuDv8RVUG2EySebRYhTrq8/oIQTUuc4NGxm5xZa4
 B6rM6SCQaNunZJUoli7sfj6bUU0Z9lxybvfBwpXLYczuphHedVz+GDL7JKA3WV7aHk40 VQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 353utwdfeq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 28 Nov 2020 20:17:26 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AT11urI179937;
        Sat, 28 Nov 2020 20:17:25 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 353utwdfe8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 28 Nov 2020 20:17:25 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AT1HNVJ014297;
        Sun, 29 Nov 2020 01:17:23 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 353e688ctj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 29 Nov 2020 01:17:23 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AT1HKtg42926530
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Nov 2020 01:17:20 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6ADBEAE04D;
        Sun, 29 Nov 2020 01:17:20 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2872AE051;
        Sun, 29 Nov 2020 01:17:19 +0000 (GMT)
Received: from oc2783563651 (unknown [9.171.47.217])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Sun, 29 Nov 2020 01:17:19 +0000 (GMT)
Date:   Sun, 29 Nov 2020 02:17:17 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v12 11/17] s390/vfio-ap: allow assignment of unavailable
 AP queues to mdev device
Message-ID: <20201129021717.5683e779.pasic@linux.ibm.com>
In-Reply-To: <20201124214016.3013-12-akrowiak@linux.ibm.com>
References: <20201124214016.3013-1-akrowiak@linux.ibm.com>
        <20201124214016.3013-12-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-28_18:2020-11-26,2020-11-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 suspectscore=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 adultscore=0
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011290001
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 24 Nov 2020 16:40:10 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> The current implementation does not allow assignment of an AP adapter or
> domain to an mdev device if each APQN resulting from the assignment
> does not reference an AP queue device that is bound to the vfio_ap device
> driver. This patch allows assignment of AP resources to the matrix mdev as
> long as the APQNs resulting from the assignment:
>    1. Are not reserved by the AP BUS for use by the zcrypt device drivers.
>    2. Are not assigned to another matrix mdev.
> 
> The rationale behind this is twofold:
>    1. The AP architecture does not preclude assignment of APQNs to an AP
>       configuration that are not available to the system.
>    2. APQNs that do not reference a queue device bound to the vfio_ap
>       device driver will not be assigned to the guest's CRYCB, so the
>       guest will not get access to queues not bound to the vfio_ap driver.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>

Again code looks good. I'm still worried about all the incremental
changes (good for review) and their testability.
