Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCEE037AB11
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 17:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbhEKPsC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 11:48:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26500 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231764AbhEKPsB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 11:48:01 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14BFWnx8065318;
        Tue, 11 May 2021 11:46:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=uXO05UFzDX2kOyKxIHxz7GAoCbbFq4yyVqiOFNRnihM=;
 b=gd3GqF4TdsfnmTb65T1UwLkssp6XKPBcW++zSpHPKdOBib8DTweJj8bKssmpCN5Q9yLh
 2pBfOiCzG9ZNeS3dxE1UggUA0jcQIP8YAeUz5NaNPbh6O7LFkE9BHyZMvncOsnIKGKOp
 gnebyoJNw2N711c46an76JH6e724r4v/aw+2hpyLOrh2fkupTvG1jIT9n+8Kg93rkE9h
 4oQt5YSfGbqnpueXS+DTgG24/xhFAlxtXncFFpsRolGFtnscr/QO+DVMRxMi6bj6ntpG
 Nhhh1WuelHIb6/4baJfGq7TABY5PJ9yW/u/xrEvPHEpkLkarXtXQ9vrEcwllbZqZK2K4 Ww== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38fsr5y5kg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 11:46:54 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14BFWnVw065306;
        Tue, 11 May 2021 11:46:53 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38fsr5y5hw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 11:46:53 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14BFh5YV009068;
        Tue, 11 May 2021 15:46:51 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 38dj988xw4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 15:46:50 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14BFkLxj34734346
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 15:46:21 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 653C14C040;
        Tue, 11 May 2021 15:46:48 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE6B14C044;
        Tue, 11 May 2021 15:46:47 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.13.244])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 May 2021 15:46:47 +0000 (GMT)
Date:   Tue, 11 May 2021 17:46:45 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        cohuck@redhat.com, linux-s390@vger.kernel.org, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH 2/4] lib: s390x: sclp: Extend feature
 probing
Message-ID: <20210511174645.550c741d@ibm-vm>
In-Reply-To: <2f0284e1-b1e0-39d6-1fe0-3be808be1849@redhat.com>
References: <20210510150015.11119-1-frankja@linux.ibm.com>
        <20210510150015.11119-3-frankja@linux.ibm.com>
        <b0db681f-bfe3-5cf3-53f8-651bba04a5c5@redhat.com>
        <20210511164137.0bba2493@ibm-vm>
        <2f0284e1-b1e0-39d6-1fe0-3be808be1849@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2TAF1BV_n3EykHt4V4g_nZSnNELbbFc8
X-Proofpoint-ORIG-GUID: cfIqKpPfDtsfkyoparEfkTRV3s-LG0Rj
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-11_02:2021-05-11,2021-05-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 mlxlogscore=999 malwarescore=0 suspectscore=0 impostorscore=0 bulkscore=0
 adultscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110112
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 May 2021 17:38:04 +0200
David Hildenbrand <david@redhat.com> wrote:

> On 11.05.21 16:41, Claudio Imbrenda wrote:
> > On Tue, 11 May 2021 13:43:36 +0200
> > David Hildenbrand <david@redhat.com> wrote:
> >   
> >> On 10.05.21 17:00, Janosch Frank wrote:  
> >>> Lets grab more of the feature bits from SCLP read info so we can
> >>> use them in the cpumodel tests.
> >>>
> >>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> >>> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> >>> ---
> >>>    lib/s390x/sclp.c | 20 ++++++++++++++++++++
> >>>    lib/s390x/sclp.h | 38 +++++++++++++++++++++++++++++++++++---
> >>>    2 files changed, 55 insertions(+), 3 deletions(-)
> >>>
> >>> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
> >>> index f11c2035..f25cfdb2 100644
> >>> --- a/lib/s390x/sclp.c
> >>> +++ b/lib/s390x/sclp.c
> >>> @@ -129,6 +129,13 @@ CPUEntry *sclp_get_cpu_entries(void)
> >>>    	return (CPUEntry *)(_read_info +
> >>> read_info->offset_cpu); }
> >>>    
> >>> +static bool sclp_feat_check(int byte, int mask)
> >>> +{
> >>> +	uint8_t *rib = (uint8_t *)read_info;
> >>> +
> >>> +	return !!(rib[byte] & mask);
> >>> +}  
> >>
> >> Instead of a mask, I'd just check for bit (offset) numbers within
> >> the byte.
> >>
> >> static bool sclp_feat_check(int byte, int bit)
> >> {
> >> 	uint8_t *rib = (uint8_t *)read_info;
> >>
> >> 	return !!(rib[byte] & (0x80 >> bit));
> >> }  
> > 
> > using a mask might be useful to check multiple facilities at the
> > same time, but in that case the check should be  
> 
> IMHO checking with a mask here multiple facilities will be very error 
> prone either way ... and we only have a single byte to check for.

as I said, I do not have a strong opinion either way :)


