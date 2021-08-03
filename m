Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8A43DE89B
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 10:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234487AbhHCInA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 04:43:00 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50816 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234455AbhHCIm7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Aug 2021 04:42:59 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1738ZrGQ118745;
        Tue, 3 Aug 2021 04:42:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=LacMOoxP/ugcb5vEg+pEg2VIYYJm6jmWdhnABrCyD20=;
 b=aHQULUAtkpIMrod7wCF/J1Uu6OCa1HaU6IlHZq7ebCrO+DZVlKrERiMUTafSAjcAotes
 ahj42k3KDcBbAmuNu/fvdKRKAJMA8Y6xRvvousFsU6cJbaxFeFtZnAIa+JW4dIhRT0JH
 Ycs01fFYNKlNWXLBJnJKj4UVl8Zy9rtEfIIxSK2sXqOAkSvIB/pJO4uRWWYGpKC4i4jx
 jRnmefRmVaSkzwhjeNgqRmhlnsDYPdwIR/BUt2HS+TcAqoQee316Q7mZS98RV7BTQTOi
 38gmtwES/O8mShJn2ZLHpy6nKoP09hB2EuuA0CPTzTUq7N3mbPOh1HfnU/p47npNSMDi yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a5qquu0kd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Aug 2021 04:42:48 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1738aXmF122497;
        Tue, 3 Aug 2021 04:42:47 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a5qquu0hu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Aug 2021 04:42:47 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1738ghaO028012;
        Tue, 3 Aug 2021 08:42:43 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 3a4x58p0tv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Aug 2021 08:42:42 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1738gd3j57409896
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 Aug 2021 08:42:39 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 85410A4064;
        Tue,  3 Aug 2021 08:42:39 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 13D53A405C;
        Tue,  3 Aug 2021 08:42:39 +0000 (GMT)
Received: from osiris (unknown [9.145.48.2])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue,  3 Aug 2021 08:42:39 +0000 (GMT)
Date:   Tue, 3 Aug 2021 10:42:37 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, cohuck@redhat.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v3 3/3] s390x: optimization of the check for CPU topology
 change
Message-ID: <YQkBfal/OiI2y1lA@osiris>
References: <1627979206-32663-1-git-send-email-pmorel@linux.ibm.com>
 <1627979206-32663-4-git-send-email-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1627979206-32663-4-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _zBAYTduUOhsfzH8ZF1Yxt6t7wWKx4R4
X-Proofpoint-GUID: 65WDoWgONNZ_myn3wcbaz-9JspD4ZldW
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-03_02:2021-08-03,2021-08-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 bulkscore=0 phishscore=0 malwarescore=0 clxscore=1015 priorityscore=1501
 adultscore=0 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108030059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 03, 2021 at 10:26:46AM +0200, Pierre Morel wrote:
> Now that the PTF instruction is interpreted by the SIE we can optimize
> the arch_update_cpu_topology callback to check if there is a real need
> to update the topology by using the PTF instruction.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  arch/s390/kernel/topology.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/s390/kernel/topology.c b/arch/s390/kernel/topology.c
> index 26aa2614ee35..741cb447e78e 100644
> --- a/arch/s390/kernel/topology.c
> +++ b/arch/s390/kernel/topology.c
> @@ -322,6 +322,9 @@ int arch_update_cpu_topology(void)
>  	struct device *dev;
>  	int cpu, rc;
>  
> +	if (!ptf(PTF_CHECK))
> +		return 0;
> +

We have a timer which checks if topology changed and then triggers a
call to arch_update_cpu_topology() via rebuild_sched_domains().
With this change topology changes would get lost.
