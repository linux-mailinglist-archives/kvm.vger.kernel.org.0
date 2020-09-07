Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C1C2606F8
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 00:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbgIGWh3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 18:37:29 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46702 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727847AbgIGWh2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Sep 2020 18:37:28 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 087MXAeD099931;
        Mon, 7 Sep 2020 18:37:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=BcgkjGw3jUcEDjS4EdUvb/Ujr7WSNppz/N64wzWxzfM=;
 b=c0pEUhxC3k3H/6Xq7Zr89wwXaSQYbeElZAsdY5Un+hvmpPMzSUTcM7EijNjzEmDGu7VI
 A+QiZHfO0nTlqH4QozRhu20mRUWkEqaFGzavdJ6l3s+trAnpEBuG9j87lda5hnLcotfp
 MpO8IkmCqI1p+Mx3gjP4AaBa2esndCALWAY/DHWBWaQORvUpM34VyvKTZ50nCZDIZijx
 CZb63XGLfCSTeHWiGxigyh1WTeDfvsisXd1nkKDvGsgy49ZmKyuvRxvlhcqOwVp/KEAH
 32jcb1MMX1yD4QBCIbUThZo1oS0lyK4Kyheb6hINXfewS4+bzf0j0ht4nRmXELqjqo/2 1Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33dwffrcea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Sep 2020 18:37:22 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 087MXkb7100914;
        Mon, 7 Sep 2020 18:37:22 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33dwffrcdm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Sep 2020 18:37:22 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 087MW4xL004327;
        Mon, 7 Sep 2020 22:37:20 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 33c2a8at2n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Sep 2020 22:37:19 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 087MZiHq49807660
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Sep 2020 22:35:44 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05CE74C066;
        Mon,  7 Sep 2020 22:37:17 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E9964C073;
        Mon,  7 Sep 2020 22:37:16 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.173.93])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Sep 2020 22:37:16 +0000 (GMT)
Date:   Tue, 8 Sep 2020 00:37:14 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, mst@redhat.com, jasowang@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v11 2/2] s390: virtio: PV needs VIRTIO I/O device
 protection
Message-ID: <20200908003714.6233107d.pasic@linux.ibm.com>
In-Reply-To: <1599471547-28631-3-git-send-email-pmorel@linux.ibm.com>
References: <1599471547-28631-1-git-send-email-pmorel@linux.ibm.com>
        <1599471547-28631-3-git-send-email-pmorel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-07_11:2020-09-07,2020-09-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 mlxscore=0 clxscore=1015 spamscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 suspectscore=0 adultscore=0 impostorscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009070218
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  7 Sep 2020 11:39:07 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> If protected virtualization is active on s390, VIRTIO has only retricted
> access to the guest memory.
> Define CONFIG_ARCH_HAS_RESTRICTED_VIRTIO_MEMORY_ACCESS and export
> arch_has_restricted_virtio_memory_access to advertize VIRTIO if that's
> the case, preventing a host error on access attempt.

The description is a little inaccurate, but I don't care hence the r-b.

The function arch_has_restricted_virtio_memory_access() returning true
can not prevent the host from attempting to access memory if it decides
to do so. And as far as I know there was no host error on access attempt.
The page gets exported, and the host will operate on the encrypted
page. But in the end we do run into trouble, which is usually fatal for
the guest (not the host).

What we actually do here is the following. If we detect
an ill configured device we fail it (device status field), because
attempting to drive it is a recipe for disaster.

> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>

Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
