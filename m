Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3C71EE30F
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 13:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgFDLOK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 07:14:10 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3784 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725995AbgFDLOJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Jun 2020 07:14:09 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 054B2X4L066652;
        Thu, 4 Jun 2020 07:14:09 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31efd5kwfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Jun 2020 07:14:09 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 054B2XUk066675;
        Thu, 4 Jun 2020 07:14:08 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31efd5kwem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Jun 2020 07:14:08 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 054BAVB9025849;
        Thu, 4 Jun 2020 11:14:06 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 31bf481vfn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Jun 2020 11:14:06 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 054BE3en8389010
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 Jun 2020 11:14:03 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F85E52050;
        Thu,  4 Jun 2020 11:14:03 +0000 (GMT)
Received: from localhost (unknown [9.145.37.112])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 2F0A352052;
        Thu,  4 Jun 2020 11:14:03 +0000 (GMT)
Date:   Thu, 4 Jun 2020 13:14:01 +0200
From:   Vasily Gorbik <gor@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PULL v2 00/10] vfio-ccw patches for 5.8
Message-ID: <your-ad-here.call-01591269241-ext-6441@work.hours>
References: <20200603112716.332801-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200603112716.332801-1-cohuck@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-04_07:2020-06-02,2020-06-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 cotscore=-2147483648 malwarescore=0
 adultscore=0 spamscore=0 clxscore=1015 impostorscore=0 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006040073
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 03, 2020 at 01:27:06PM +0200, Cornelia Huck wrote:
> The following changes since commit e1750a3d9abbea2ece29cac8dc5a6f5bc19c1492:
> 
>   s390/pci: Log new handle in clp_disable_fh() (2020-05-28 12:26:03 +0200)
> 
> are available in the Git repository at:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/vfio-ccw tags/vfio-ccw-20200603-v2
> 
> for you to fetch changes up to b2dd9a44a1098c96935c495570b663bd223a087e:
> 
>   vfio-ccw: Add trace for CRW event (2020-06-03 11:28:19 +0200)
> 
> ----------------------------------------------------------------
> vfio-ccw updates:
> - accept requests without the prefetch bit set
> - enable path handling via two new regions

Merged into features, thank you.
https://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git/log/?h=features
