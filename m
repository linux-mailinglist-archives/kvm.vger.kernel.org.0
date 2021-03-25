Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09CF634940D
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 15:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbhCYO3n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 10:29:43 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32110 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231153AbhCYO3L (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 10:29:11 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12PEN7uN066501;
        Thu, 25 Mar 2021 10:29:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=TBwC6f2X3LnahJRm4qTMEd+GJ4sV6n4jmZnnwkyjeLA=;
 b=OKdV4+767MCbPt1f5dmXx3I2p/vC2PIsQSz/k6sORDG1cd6HUuv8jBVit3w7wZCvltTo
 2dW1Of2bY5aKYQlTJTuokZigb0Ox0L69lk1o0NQMaGwgbeHW9wdG8kCha2t2rIdLb31Q
 Fs0SWMnJoYH0YC4bPcZE0mx6BFpWtITiesAay9YrFogiWZ4nAKFL4FynadXXEX1YHOpd
 VU1b/JUaAjn7Bxic0YkcDtVPltKHLxSwN3TI+3L+VvU4EdS+vlK3BKZ0mEwhgxmbZCHF
 Cn49krK1edNB7HBkt+UTva3vYO4vtGgMGgaeFqvBd6BlmelVgdUSwkg3HL36uhPtqc/7 Gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37gurvs08y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 10:29:10 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12PENLda067727;
        Thu, 25 Mar 2021 10:29:10 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37gurvs087-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 10:29:10 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12PEIktT013493;
        Thu, 25 Mar 2021 14:22:13 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 37d9byauux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 14:22:13 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12PEMA3g48693622
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 14:22:10 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BE1842049;
        Thu, 25 Mar 2021 14:22:10 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64F4142042;
        Thu, 25 Mar 2021 14:22:09 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.84.230])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Thu, 25 Mar 2021 14:22:09 +0000 (GMT)
Date:   Thu, 25 Mar 2021 15:22:07 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        borntraeger@de.ibm.com, farman@linux.ibm.com,
        jjherne@linux.ibm.com, akrowiak@linux.ibm.com,
        pmorel@linux.ibm.com, cohuck@redhat.com, hca@linux.ibm.com,
        gor@linux.ibm.com, alex.williamson@redhat.com
Subject: Re: [PATCH] MAINTAINERS: add backups for s390 vfio drivers
Message-ID: <20210325152207.0ae68a21.pasic@linux.ibm.com>
In-Reply-To: <1616679712-7139-1-git-send-email-mjrosato@linux.ibm.com>
References: <1616679712-7139-1-git-send-email-mjrosato@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-25_03:2021-03-24,2021-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=891
 bulkscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0 adultscore=0
 clxscore=1015 impostorscore=0 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250106
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 25 Mar 2021 09:41:52 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> Add a backup for s390 vfio-pci, an additional backup for vfio-ccw
> and replace the backup for vfio-ap as Pierre is focusing on other
> areas.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

Acked-by: Halil Pasic <pasic@linux.ibm.com>
