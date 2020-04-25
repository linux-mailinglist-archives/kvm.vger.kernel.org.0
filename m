Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 721FE1B849C
	for <lists+kvm@lfdr.de>; Sat, 25 Apr 2020 10:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgDYIWc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 04:22:32 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25264 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725837AbgDYIWc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 25 Apr 2020 04:22:32 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03P83PuE111256;
        Sat, 25 Apr 2020 04:22:28 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30mhbfgbtx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 25 Apr 2020 04:22:28 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03P8DVZ1132674;
        Sat, 25 Apr 2020 04:22:28 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30mhbfgbtj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 25 Apr 2020 04:22:28 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03P8K1dn013682;
        Sat, 25 Apr 2020 08:22:26 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 30mcu7r8uy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 25 Apr 2020 08:22:26 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03P8MNdh10617338
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Apr 2020 08:22:23 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D32F5205A;
        Sat, 25 Apr 2020 08:22:23 +0000 (GMT)
Received: from localhost (unknown [9.145.167.115])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id D93145204E;
        Sat, 25 Apr 2020 08:22:22 +0000 (GMT)
Date:   Sat, 25 Apr 2020 10:22:21 +0200
From:   Vasily Gorbik <gor@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, cohuck@redhat.com, david@redhat.com,
        kbuild test robot <lkp@intel.com>,
        Philipp Rudo <prudo@linux.ibm.com>
Subject: Re: [PATCH v1 1/1] s390/protvirt: fix compilation issue
Message-ID: <your-ad-here.call-01587802941-ext-4058@work.hours>
References: <20200423120114.2027410-1-imbrenda@linux.ibm.com>
 <your-ad-here.call-01587646462-ext-4177@work.hours>
 <a12b704f-b9b8-6ce8-0f65-5751a69bfdd2@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a12b704f-b9b8-6ce8-0f65-5751a69bfdd2@de.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-25_03:2020-04-24,2020-04-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 phishscore=0 adultscore=0 spamscore=0 clxscore=1011 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 mlxlogscore=788 suspectscore=1
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004250068
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 24, 2020 at 03:17:11PM +0200, Christian Borntraeger wrote:
> 
> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
> 
> Vasily, I guess you have a pull request soon? Do you want to pick this?

yes, I'll pick this up.
