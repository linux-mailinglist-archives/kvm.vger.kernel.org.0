Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1887A3B0A58
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 18:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbhFVQbk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 12:31:40 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57270 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229501AbhFVQbk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 12:31:40 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15MG3INZ027345;
        Tue, 22 Jun 2021 12:29:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=AlSvS6/j8WtIKfsoCPqprGMMO5RF5YeWz5gVfhr6J74=;
 b=fhC5HUso6+W1Y3oD7OdAMqmnpUxcL2QZQA8ncKCrCtxWsN+nhqYS4qYXOhUKdY0tW+HS
 YYXXeUJ+qMHUhB1E7IqyI29vXatTO9VGXwS7mBWBLRlEKuiRldf64YDrkPARN5KdbGxf
 1/g9O/nAxp9kwuD2Vmwucmb6frJB1XqUWsmmBEjJ51VpGGylqPP7s8uMRrQ/LjGfDyQc
 ZaUkCYz31nTU8LUA6hNnTuZkwacFhyylrSNKmUQh1ez6fMAEe5TVOp7S07ey0I/Rehtf
 VEYhU850wkuO+j2vTMTW+DFm3lZ2Ac08X6LvdC1FRwZj79DWrCluLUBsIMV91WAnGQxM Ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39bj1gudah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 12:29:24 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15MG3Niv027747;
        Tue, 22 Jun 2021 12:29:24 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39bj1gud9h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 12:29:23 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15MGScWT021551;
        Tue, 22 Jun 2021 16:29:21 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 3998788uxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 16:29:21 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15MGRwPB35914036
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 16:27:58 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E288411C04C;
        Tue, 22 Jun 2021 16:29:18 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8EED911C04A;
        Tue, 22 Jun 2021 16:29:18 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.9.205])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Jun 2021 16:29:18 +0000 (GMT)
Date:   Tue, 22 Jun 2021 18:24:11 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH 1/2] KVM: s390: gen_facilities: allow facilities 165,
 193, 194 and 196
Message-ID: <20210622182411.7ce350ad@ibm-vm>
In-Reply-To: <20210622143412.143369-2-borntraeger@de.ibm.com>
References: <20210622143412.143369-1-borntraeger@de.ibm.com>
        <20210622143412.143369-2-borntraeger@de.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Z8MHEhrYG0yszFdyoWEcCq09BUYyMevR
X-Proofpoint-ORIG-GUID: As9AIMADLIwkPDaxP_Ih8xNTWDxt4fkJ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-22_08:2021-06-22,2021-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 phishscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106220100
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 22 Jun 2021 16:34:11 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> This enables the neural NNPA, BEAR enhancement,reset DAT protection
> and processor activity counter facilities via the cpu model.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/tools/gen_facilities.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/s390/tools/gen_facilities.c
> b/arch/s390/tools/gen_facilities.c index 61ce5b59b828..606324e56e4e
> 100644 --- a/arch/s390/tools/gen_facilities.c
> +++ b/arch/s390/tools/gen_facilities.c
> @@ -115,6 +115,10 @@ static struct facility_def facility_defs[] = {
>  			12, /* AP Query Configuration Information */
>  			15, /* AP Facilities Test */
>  			156, /* etoken facility */
> +			165, /* nnpa facility */
> +			193, /* bear enhancement facility */
> +			194, /* rdp enhancement facility */
> +			196, /* processor activity instrumentation
> facility */ -1  /* END */
>  		}
>  	},

