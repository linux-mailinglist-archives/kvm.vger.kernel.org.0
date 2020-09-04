Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97EF325D86F
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 14:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730143AbgIDMLL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 08:11:11 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59724 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729297AbgIDMLJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Sep 2020 08:11:09 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 084C2FDw176050;
        Fri, 4 Sep 2020 08:11:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=TC1Uze5H0IFoxrx5DY8HOC94ALovdeKdyLHES3eYa1Y=;
 b=qGHsqMB7Q4oF1ZFtXHvgWVpoInKL6n3ypKe5a9ZnIJ61JEMZ+wBc2dBkuSkIVQhncECz
 LpslXpfwS5GBfK18uIIj9R3wtweUfM/CbGUzeSMFdZ1am1Kd8OnYRbrHjftTOxR04Pv7
 We2NYF+pgZyTUaNms5hv6v12Fq2l0B4aZage9ZdT93HOeFhfSlp6+lfoi2CiSJbTShxi
 /dWzE+dU8e9P/Q81UfIMsbCaIJM61FRhSQp3Q62aCv8NlR3dT41u+gMrCOsgAvGcHBqX
 ebepyKnTvk4sMleVAX+OwMYwjUqZKcCseAXRjjkiqrS1TdnqanYt24qr7lNnxZkQP6GT lQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33bk19bqrv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Sep 2020 08:11:06 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 084C2DHa175882;
        Fri, 4 Sep 2020 08:11:06 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33bk19bqp1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Sep 2020 08:11:06 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 084C9JOr015834;
        Fri, 4 Sep 2020 12:11:00 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 33act59898-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Sep 2020 12:11:00 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 084CAv8063766986
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Sep 2020 12:10:57 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8D532A4053;
        Fri,  4 Sep 2020 12:10:57 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36DA3A4059;
        Fri,  4 Sep 2020 12:10:57 +0000 (GMT)
Received: from osiris (unknown [9.171.25.186])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri,  4 Sep 2020 12:10:57 +0000 (GMT)
Date:   Fri, 4 Sep 2020 14:10:55 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        gor@linux.ibm.com, imbrenda@linux.ibm.com, kvm@vger.kernel.org,
        david@redhat.com
Subject: Re: [PATCH 1/2] s390x: uv: Add destroy page call
Message-ID: <20200904121055.GF6075@osiris>
References: <20200903131435.2535-1-frankja@linux.ibm.com>
 <20200903131435.2535-2-frankja@linux.ibm.com>
 <20200904103939.GE6075@osiris>
 <98237148-bbb4-c6d7-aba2-6fa11fb788b1@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98237148-bbb4-c6d7-aba2-6fa11fb788b1@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-04_06:2020-09-04,2020-09-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=1 adultscore=0 phishscore=0 malwarescore=0
 clxscore=1015 mlxlogscore=999 spamscore=0 mlxscore=0 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009040106
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 04, 2020 at 01:38:53PM +0200, Janosch Frank wrote:
> >>   * Requests the Ultravisor to encrypt a guest page and make it
> >>   * accessible to the host for paging (export).
> >> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> >> index 373542ca1113..cfb0017f33a7 100644
> >> --- a/arch/s390/mm/gmap.c
> >> +++ b/arch/s390/mm/gmap.c
> >> @@ -2679,7 +2679,7 @@ static int __s390_reset_acc(pte_t *ptep, unsigned long addr,
> >>  	pte_t pte = READ_ONCE(*ptep);
> >>  
> >>  	if (pte_present(pte))
> >> -		WARN_ON_ONCE(uv_convert_from_secure(pte_val(pte) & PAGE_MASK));
> >> +		WARN_ON_ONCE(uv_destroy_page(pte_val(pte) & PAGE_MASK));
> > 
> > Why not put the WARN_ON_ONCE() into uv_destroy_page() and make that
> > function return void?
> > 
> If you prefer that, I'll change the patch.

Seems to be better to me. Otherwise you start to sprinkle WARN_ONs all
over the code, _if_ there would be more callers.

> I think we'd need a proper print of the return codes of the UVC anyway,
> the warn isn't very helpful if you want to debug after the fact.

Maybe a new debug feature? Well, but that's something that hasn't do
anything with this code.
