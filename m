Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D708E213D7F
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 18:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgGCQVl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 12:21:41 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1214 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726147AbgGCQVl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Jul 2020 12:21:41 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 063G32OY135854;
        Fri, 3 Jul 2020 12:21:40 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32041h2w15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 12:21:39 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 063G3Ft4136392;
        Fri, 3 Jul 2020 12:21:39 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32041h2w0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 12:21:39 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 063GG4N1005760;
        Fri, 3 Jul 2020 16:21:36 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 31wwr8bgx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 16:21:36 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 063GLXGW58261734
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Jul 2020 16:21:34 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE1E44204C;
        Fri,  3 Jul 2020 16:21:33 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E90D42047;
        Fri,  3 Jul 2020 16:21:33 +0000 (GMT)
Received: from osiris (unknown [9.171.46.77])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri,  3 Jul 2020 16:21:33 +0000 (GMT)
Date:   Fri, 3 Jul 2020 18:21:32 +0200
From:   Heiko Carstens <heiko.carstens@de.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PULL 0/1] vfio-ccw fix
Message-ID: <20200703162132.GB5294@osiris>
References: <20200703095253.620719-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200703095253.620719-1-cohuck@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-03_13:2020-07-02,2020-07-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 spamscore=0 mlxscore=0 suspectscore=1 adultscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 mlxlogscore=959
 malwarescore=0 impostorscore=0 cotscore=-2147483648 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007030110
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 03, 2020 at 11:52:52AM +0200, Cornelia Huck wrote:
> The following changes since commit 9e9f85e029a2ee4167aacf3ff04e4288a5e5c74e:
> Sean Christopherson (1):
>   vfio-ccw: Fix a build error due to missing include of linux/slab.h
> 
>  drivers/s390/cio/vfio_ccw_chp.c | 1 +
>  1 file changed, 1 insertion(+)

Pulled, however it would have been nice if the commit log would have
contained some words how to trigger the build error.

Thanks!
