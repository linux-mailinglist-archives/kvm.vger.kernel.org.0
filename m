Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91C361E6128
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 14:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389812AbgE1Mml (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 May 2020 08:42:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47492 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389746AbgE1Mmk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 May 2020 08:42:40 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04SCXaG6110428;
        Thu, 28 May 2020 08:42:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=M0hfDGewQoQ31f3l+JSTrKuhyQz6otPKo5AUUBr9EGA=;
 b=nzcQkiSwl0UiwxQ0wwKtcn0PzQ2XtYZTrWjqham5WsxYZn+f5FYq6BzhCVRgDB3eJ5SF
 Vi3os5ezpfQSP4aUQKUDJ5F1ct6qEHPm/7ftYH4OOxg3WQZ6Y6wPaMg8y93oq1a3ArHA
 0+h4sEVZrmVrXubHWSAf/r24iBZKvfrJeUytxqqMIYxU2SAzkQYuVRAOV7i5zQkQ1wgV
 qDHT7lb9Q9yREudw6NFihkEU8OcP1uiHRMZDbOv+7hwV7dBuDLjfRPuCFcvMJdnPy/ho
 TJVHcytKzHr+eVCdpvm3KcTq+bit8uJSKYJ0nUG77hjC7q6Fda6N6RvIqMFg4Ow1/EQP AQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 319sqft542-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 May 2020 08:42:39 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04SCZ0SJ118055;
        Thu, 28 May 2020 08:42:39 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 319sqft53e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 May 2020 08:42:38 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 04SCet6q018500;
        Thu, 28 May 2020 12:42:36 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 316uf8m156-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 May 2020 12:42:36 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04SCgX1R57409910
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 May 2020 12:42:33 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6226E11C050;
        Thu, 28 May 2020 12:42:33 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E0C2911C054;
        Thu, 28 May 2020 12:42:32 +0000 (GMT)
Received: from localhost (unknown [9.145.63.210])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 28 May 2020 12:42:32 +0000 (GMT)
Date:   Thu, 28 May 2020 14:42:31 +0200
From:   Vasily Gorbik <gor@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PULL 00/10] vfio-ccw patches for 5.8
Message-ID: <your-ad-here.call-01590669751-ext-3257@work.hours>
References: <20200525094115.222299-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200525094115.222299-1-cohuck@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-28_03:2020-05-28,2020-05-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=909
 suspectscore=0 bulkscore=0 phishscore=0 cotscore=-2147483648
 priorityscore=1501 lowpriorityscore=0 spamscore=0 clxscore=1015
 malwarescore=0 adultscore=0 impostorscore=0 mlxscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005280086
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 25, 2020 at 11:41:05AM +0200, Cornelia Huck wrote:
> The following changes since commit 6a8b55ed4056ea5559ebe4f6a4b247f627870d4c:
> 
>   Linux 5.7-rc3 (2020-04-26 13:51:02 -0700)
> 
> are available in the Git repository at:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/vfio-ccw tags/vfio-ccw-20200525

Hello Conny,

s390/features is based on v5.7-rc2 rather than on v5.7-rc3 as your
tags/vfio-ccw-20200525. Are there any pre-requisites in between for
vfio-ccw changes? It does cleanly rebase onto v5.7-rc2.

Could you please rebase onto v5.7-rc2 or s390/features if that's possible?

Thank you.
