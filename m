Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E17B27D378
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 18:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgI2QTZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 12:19:25 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12928 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728401AbgI2QTY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 12:19:24 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08TG2Cdw047552;
        Tue, 29 Sep 2020 12:19:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=yBrupHevIMwKgyyBuD4mcVM4xD+mgqDE3i4mmOQ/JRU=;
 b=U9OeUmVNAf5//JaKiW2Yaw1KlOx3DNQ0av8egtY5VUKVdG31zcYeDJNTBez3SEtD5Poa
 t8ffFpqOG8Xf+h4Amo3By0QNR3bfZ2NsSxEn6KY/XyaAMuf5imKeRjMebmLWDJdDU0O2
 Ua4q7TUrRZFLkM3Xia4/kTr+XcAYAZxVr/6iYl0/7RbIMO2NqVh7Mjf2qkX37OhfJn5M
 GQm8xkyTTd457qdu6xmcIX5mpNETz0UKxeWhEuiefi+8z70K0buECmIkSVHFQmch/cfV
 5M6nVj+ZtAWZoFSX8ZSH08E/yS3aNhi34ScLeIKXQ/qNhjgWRpHKakLzZRgxBULRNtYh mQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33v7hahuwj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 12:19:22 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08TG3ChW053136;
        Tue, 29 Sep 2020 12:19:22 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33v7hahuvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 12:19:21 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08TGHG81007907;
        Tue, 29 Sep 2020 16:19:20 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 33sw983hgu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 16:19:20 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08TGJHb526083780
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Sep 2020 16:19:17 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3939842045;
        Tue, 29 Sep 2020 16:19:17 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C04B42059;
        Tue, 29 Sep 2020 16:19:16 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.92.67])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 29 Sep 2020 16:19:16 +0000 (GMT)
Date:   Tue, 29 Sep 2020 18:19:14 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v10 06/16] s390/vfio-ap: introduce shadow APCB
Message-ID: <20200929181914.64da90fd.pasic@linux.ibm.com>
In-Reply-To: <5cca8962-4f08-9c92-032c-9b6d1b514e33@linux.ibm.com>
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
        <20200821195616.13554-7-akrowiak@linux.ibm.com>
        <20200926033808.07e9d04f.pasic@linux.ibm.com>
        <5cca8962-4f08-9c92-032c-9b6d1b514e33@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_07:2020-09-29,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 adultscore=0 mlxscore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009290135
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 29 Sep 2020 12:04:25 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> >
> > I suppose this is probably about no guest unolies no resources passed
> > through at the moment. If that is the case maybe we can document it
> > below.  
> 
> I'm not quite sure what you are saying here or what I should be
> documenting below.

No wonder, took me like 10 seconds to figure it out myself. The solution
is s/unolies/implies. I was one off to the left when typing 'imp'. 
