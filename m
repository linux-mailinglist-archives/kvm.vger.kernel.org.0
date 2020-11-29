Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634872C76E7
	for <lists+kvm@lfdr.de>; Sun, 29 Nov 2020 01:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728568AbgK2Aty (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Nov 2020 19:49:54 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64618 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726021AbgK2Aty (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 28 Nov 2020 19:49:54 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AT0XYw5139138;
        Sat, 28 Nov 2020 19:49:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=X9HAO2AxEaOKMVXdHOhn7dedpUbVUQ2FH53VThCmTXA=;
 b=QofprJVB+DTY9DU8lcYjrrUyvnrti4Ud6/ST5X+kwbAnS2xn/CYeiZxDtCPs17ljNzMP
 kmOMbx30/DP549RCaT7r+SuY+GGv0yizqhja9h9p/0792e47VhPKe7NPRi4ifjMJybsm
 sGe5SVxZVxgEVXxtwZvJLfLXcR4L8rIJesuMfdQfqo3rSOqdW1Q5RS2HQv8J11PPX6iu
 0k9GQ0rfBHM4mFKqmUBkC+badPPtAD5u00dpJtSLZoCOTwlNcVU/yLFvCEY8zdQpWQS3
 uho4Bt6Mq/QjuSdGrIo09yzrsQQNvVpQHdviav4aK7EAWEEYHZnV//X0jDEgtaMtKZgK vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 353ten6da5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 28 Nov 2020 19:49:11 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AT0feeX155449;
        Sat, 28 Nov 2020 19:49:11 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 353ten6d9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 28 Nov 2020 19:49:11 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AT0Vdjo009237;
        Sun, 29 Nov 2020 00:49:10 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 353dth8rjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 29 Nov 2020 00:49:09 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AT0n7KY8651476
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Nov 2020 00:49:07 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6287A4057;
        Sun, 29 Nov 2020 00:49:06 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 352ABA4040;
        Sun, 29 Nov 2020 00:49:06 +0000 (GMT)
Received: from oc2783563651 (unknown [9.171.47.217])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Sun, 29 Nov 2020 00:49:06 +0000 (GMT)
Date:   Sun, 29 Nov 2020 01:49:04 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v12 09/17] s390/vfio-ap: sysfs attribute to display the
 guest's matrix
Message-ID: <20201129014904.4fafdbba.pasic@linux.ibm.com>
In-Reply-To: <20201124214016.3013-10-akrowiak@linux.ibm.com>
References: <20201124214016.3013-1-akrowiak@linux.ibm.com>
        <20201124214016.3013-10-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-28_18:2020-11-26,2020-11-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 clxscore=1015
 malwarescore=0 lowpriorityscore=0 adultscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011290001
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 24 Nov 2020 16:40:08 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> The matrix of adapters and domains configured in a guest's APCB may
> differ from the matrix of adapters and domains assigned to the matrix mdev,
> so this patch introduces a sysfs attribute to display the matrix of
> adapters and domains that are or will be assigned to the APCB of a guest
> that is or will be using the matrix mdev. For a matrix mdev denoted by
> $uuid, the guest matrix can be displayed as follows:
> 
>    cat /sys/devices/vfio_ap/matrix/$uuid/guest_matrix
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>

Code looks good, but it may be a little early, since the treatment of
guset_matrix is changed by the following patches.
