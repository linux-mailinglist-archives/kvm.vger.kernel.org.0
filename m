Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 043BC2FDC0F
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 22:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbhATVpP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 16:45:15 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46034 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731658AbhATNnb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Jan 2021 08:43:31 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10KDWm22007041;
        Wed, 20 Jan 2021 08:42:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=dqxosd4g7zKlZH1v7XCpXwwjC2AU8t7alZYxMUwmWMA=;
 b=Oj3O7horl4OTYOpzQa9es3FugrJ1/y8YEuFWH9PP29O7frX2m4yccSDjjL7PON9RcQj8
 NUokeW0eIrTjlQ1IG6sOB0Hc1rHrFrM79lSRPkfMOiuGLUVJR5I06ITYLQzdMpltzEqI
 Ob1UAst2IvLYL6jyB4zEq+md4awjD6uU64CgAs0/4aYf2DSqDvuGU5gaXczKGFbkebpy
 KbNtNZpF35rhWw4aityN9Qq9HqlYacqQlUMVLIXTtR4muXCYMb4nOPXknsDhY84G8f7v
 C4tSmeKJ2qzd2Nyhw429ONd1/YGyQN21qiTyUwE7WDP+Ops8bXeUANsxjHv+mxSBMwvV Pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 366n78rurt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 08:42:16 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10KDZL2C018617;
        Wed, 20 Jan 2021 08:42:15 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 366n78rur3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 08:42:15 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10KDWjS0005681;
        Wed, 20 Jan 2021 13:42:13 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3668ny0b7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 13:42:13 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10KDgAiI41484674
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jan 2021 13:42:10 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3521BA4040;
        Wed, 20 Jan 2021 13:42:10 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AFEBEA4053;
        Wed, 20 Jan 2021 13:42:09 +0000 (GMT)
Received: from osiris (unknown [9.171.38.241])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 20 Jan 2021 13:42:09 +0000 (GMT)
Date:   Wed, 20 Jan 2021 14:42:08 +0100
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        thuth@redhat.com, david@redhat.com, imbrenda@linux.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org, gor@linux.ibm.com,
        mihajlov@linux.ibm.com
Subject: Re: [PATCH 2/2] s390: mm: Fix secure storage access exception
 handling
Message-ID: <20210120134208.GC8202@osiris>
References: <20210119100402.84734-1-frankja@linux.ibm.com>
 <20210119100402.84734-3-frankja@linux.ibm.com>
 <3e1978c6-4462-1de6-e1aa-e664ffa633c1@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e1978c6-4462-1de6-e1aa-e664ffa633c1@de.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-20_05:2021-01-20,2021-01-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 mlxscore=0 mlxlogscore=798 impostorscore=0 lowpriorityscore=0
 clxscore=1011 malwarescore=0 phishscore=0 spamscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101200079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 19, 2021 at 11:25:01AM +0100, Christian Borntraeger wrote:
> > +		if (user_mode(regs)) {
> > +			send_sig(SIGSEGV, current, 0);
> > +			return;
> > +		} else
> > +			panic("Unexpected PGM 0x3d with TEID bit 61=0");
> 
> use BUG instead of panic? That would kill this process, but it allows
> people to maybe save unaffected data.

It would kill the process, and most likely lead to deadlock'ed
system. But with all the "good" debug information being lost, which
wouldn't be the case with panic().
I really don't think this is a good idea.
