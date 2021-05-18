Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9991387DF4
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 18:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350925AbhERQ4N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 12:56:13 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18074 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1350921AbhERQ4K (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 May 2021 12:56:10 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14IGXCOK093854;
        Tue, 18 May 2021 12:54:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=HZhH9XcAVtvzJ3MjEaaWljjyMwNM1vD7cRb5rJX3WME=;
 b=Wqye7yL4rWyG4TZWii9laSKQPUr4qhcqkD8iV8eps6nVFzmQLtt7j627XPHbEYQoKzQ4
 pRFJU+n0/LbdNXK4Y65QzPUZukHQm5Hup+S5eWVMYG/oLw3KR/ucs40rD1qTWWHa0ll9
 GKGyqBwoS6rpW5+t7I0U9Z3dcKIqfOP76pnyOMJwuGiv7VUBa6DtgP32F7HwKnqkXlpB
 L/mVgVFuc/HOrri1hOhNpmOdE5XuiANoSVka7Tgs+7XmTbj5yKD74p3llrCm83wnuTPX
 tBYV1AjyI0RtOKNaFxQ5vhjc2M7hvRHBQnrAGLAjnpF5FyMw8esGbsxYyfKAGqlncfVw 4w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38mh5xrk65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 12:54:48 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14IGYZA7098391;
        Tue, 18 May 2021 12:54:47 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38mh5xrk5q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 12:54:47 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14IGqtFl009318;
        Tue, 18 May 2021 16:54:45 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 38m19sr8wu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 16:54:45 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14IGsgH815073696
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 May 2021 16:54:42 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F2F5AE04D;
        Tue, 18 May 2021 16:54:42 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AFF3CAE053;
        Tue, 18 May 2021 16:54:41 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.17.64])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Tue, 18 May 2021 16:54:41 +0000 (GMT)
Date:   Tue, 18 May 2021 18:54:39 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
Subject: Re: [PATCH v16 00/14] s390/vfio-ap: dynamic configuration support
Message-ID: <20210518185439.72a4d37e.pasic@linux.ibm.com>
In-Reply-To: <60e91bd2-0802-a3af-11a3-fa6dd8146d90@linux.ibm.com>
References: <20210510164423.346858-1-akrowiak@linux.ibm.com>
        <60e91bd2-0802-a3af-11a3-fa6dd8146d90@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tX4ghSEMO8Nk_e444TKSa5C11W7acrzp
X-Proofpoint-ORIG-GUID: k21VCz2pxeSy25ww5OcBb9gVr-6NKgIg
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-18_08:2021-05-18,2021-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 priorityscore=1501 bulkscore=0 spamscore=0 mlxscore=0 clxscore=1015
 adultscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105180113
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 May 2021 09:26:01 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> Ping!

I'm already working on it. I went trough the all the changes once, and
I'm currently trying to understand the new usages of 
matrix_mdev->wait_for_kvm and matrix_mdev->kvm_busy. You seem to be
using these a new purpose...

Regards,
Halil
