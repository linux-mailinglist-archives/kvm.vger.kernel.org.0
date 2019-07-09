Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30FB5638A2
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 17:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbfGIPaz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 11:30:55 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54374 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726055AbfGIPaz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Jul 2019 11:30:55 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x69FDfg1089438
        for <kvm@vger.kernel.org>; Tue, 9 Jul 2019 11:30:54 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tmvngk75r-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 09 Jul 2019 11:30:53 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Tue, 9 Jul 2019 16:30:52 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 9 Jul 2019 16:30:49 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x69FUmUd50790458
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Jul 2019 15:30:48 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E78B4A405F;
        Tue,  9 Jul 2019 15:30:47 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80931A4040;
        Tue,  9 Jul 2019 15:30:47 +0000 (GMT)
Received: from oc2783563651 (unknown [9.152.224.228])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  9 Jul 2019 15:30:47 +0000 (GMT)
Date:   Tue, 9 Jul 2019 17:30:46 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, frankja@linux.ibm.com, david@redhat.com,
        mjrosato@linux.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com
Subject: Re: [PATCH v4 0/7] s390: vfio-ap: dynamic configuration support
In-Reply-To: <1560454780-20359-1-git-send-email-akrowiak@linux.ibm.com>
References: <1560454780-20359-1-git-send-email-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19070915-0020-0000-0000-00000351B118
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19070915-0021-0000-0000-000021A56158
Message-Id: <20190709173046.0a622f3a.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-09_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=878 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907090180
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 13 Jun 2019 15:39:33 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> The current design for AP pass-through does not support making dynamic
> changes to the AP matrix of a running guest

Sorry guys, I currently don't have the bandwidth to participate in this
discussion. Please proceed without me ;)

Regards,
Halil

