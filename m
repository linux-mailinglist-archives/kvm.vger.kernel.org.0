Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5AD3261E38
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 21:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731746AbgIHTsy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 15:48:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33830 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730809AbgIHPuu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Sep 2020 11:50:50 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 088D3rhN029054;
        Tue, 8 Sep 2020 09:18:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=qRhVAsotMgvOB7IP3QnUDtz1XT5Cou8oexSmJxkX9/U=;
 b=WanNAbs7EkVCgShzuD0l5Yp+R2tH/7aNtVws2PCw/s7IxbeWlLbNyK3sdG3HImxTB0Ls
 B9ArN/Wf/l8aTQ42LUww2ZfnP2zNIGqvMuBXfIHSOVbuh8QeoMJQ+CIuO2XjByXkjrrN
 uhTy/44naPt+MebW5+he/dgjCY/r42E5qIKSYDFL6GajJWcABsk2fKEDvJGSMFeTCjhU
 2kn7d5xIvpmnorFxziwQFC462aJ+QbY8/bHB8DVLyvRTLKO5Z3IA2dVipuR/9eaOvMJd
 hzgErSzZQruBfaLBrovRB1GtUIINQhcffFocyyTwn0T2np41Ah51jRjx/aa1526EvjAA Ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33e9sct9dw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Sep 2020 09:18:58 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 088DDZdp078394;
        Tue, 8 Sep 2020 09:18:58 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33e9sct9cr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Sep 2020 09:18:57 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 088DH7Dq014131;
        Tue, 8 Sep 2020 13:18:55 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 33c2a8a4dq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Sep 2020 13:18:55 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 088DIqiN9109802
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Sep 2020 13:18:52 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6105F11C054;
        Tue,  8 Sep 2020 13:18:52 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EFC1C11C050;
        Tue,  8 Sep 2020 13:18:51 +0000 (GMT)
Received: from osiris (unknown [9.171.47.162])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue,  8 Sep 2020 13:18:51 +0000 (GMT)
Date:   Tue, 8 Sep 2020 15:18:50 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        gor@linux.ibm.com, imbrenda@linux.ibm.com, kvm@vger.kernel.org,
        david@redhat.com, cohuck@redhat.com, thuth@redhat.com
Subject: Re: [PATCH v3] s390x: Add 3f program exception handler
Message-ID: <20200908131850.GG14136@osiris>
References: <20200908075337.GA9170@osiris>
 <20200908130504.24641-1-frankja@linux.ibm.com>
 <20200908130655.GF14136@osiris>
 <6551fde1-e19c-3b97-7a53-5a4dcb97f7bc@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6551fde1-e19c-3b97-7a53-5a4dcb97f7bc@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-08_06:2020-09-08,2020-09-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=1 clxscore=1015 adultscore=0
 malwarescore=0 spamscore=0 mlxscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009080123
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 08, 2020 at 03:09:23PM +0200, Janosch Frank wrote:
> On 9/8/20 3:06 PM, Heiko Carstens wrote:
> > On Tue, Sep 08, 2020 at 09:05:04AM -0400, Janosch Frank wrote:
> >> Program exception 3f (secure storage violation) can only be detected
> >> when the CPU is running in SIE with a format 4 state description,
> >> e.g. running a protected guest. Because of this and because user
> >> space partly controls the guest memory mapping and can trigger this
> >> exception, we want to send a SIGSEGV to the process running the guest
> >> and not panic the kernel.
> >>
> >> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> >> CC: <stable@vger.kernel.org> # 5.7+
> >> Fixes: 084ea4d611a3 ("s390/mm: add (non)secure page access exceptions handlers")
> >> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> >> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> >> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
> >> ---
> >>  arch/s390/kernel/entry.h     |  1 +
> >>  arch/s390/kernel/pgm_check.S |  2 +-
> >>  arch/s390/mm/fault.c         | 20 ++++++++++++++++++++
> >>  3 files changed, 22 insertions(+), 1 deletion(-)
> > 
> > I guess this should go upstream via the s390 tree?
> 
> Christian asked the exact same question.
> I think we picked the secure/non-secure exception handlers via the s390
> tree so bringing these in via s390 would be in line with that.
> 
> > Should I pick this up?
> 
> That would be nice

Done.
