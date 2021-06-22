Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 314823B0A5A
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 18:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhFVQbp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 12:31:45 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10272 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229501AbhFVQbl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 12:31:41 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15MGKHWq160495;
        Tue, 22 Jun 2021 12:29:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=jrQ19dvX6qTOstkz/+yCfb9mJg/TCLwStq9MinTa68M=;
 b=M9bbsWjS++C2cpQSFjxlSyBEL3hMykQFzA83oFh8I+eZWkH8RDWJ0/UsrkzmVghBx8eL
 vRmseHp3lVA2sm4bUjfn0wTq9Prq4QrLV7SZHx1iv+EHD0m7TwrLH4sNQCZwn5U1fSqi
 Yd7i1DdZke6HKTqNUorB+xYsKiaNUjQ4/TCLUoCeccrDCtVL1aOZi8B90a5mct1EDxNn
 FxYJnkgvJLIFhz3+2obGhWMayFRmoG5DnShXfClzR76G29JFIgX8KwPDieQj7G6s2zzs
 aSZDcU6KRVwXbaI39AXBNHfV22niUmrbUZS25m2bb2W+pi6hpEO3Ba71+IlrHBeK0GZp rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39bj5sk2md-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 12:29:25 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15MGKK2H160822;
        Tue, 22 Jun 2021 12:29:25 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39bj5sk2kq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 12:29:25 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15MGRGMb029152;
        Tue, 22 Jun 2021 16:29:22 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3997uh9jdq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 16:29:22 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15MGTKJ333161666
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 16:29:20 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5866911C04C;
        Tue, 22 Jun 2021 16:29:20 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF7B611C04A;
        Tue, 22 Jun 2021 16:29:19 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.9.205])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Jun 2021 16:29:19 +0000 (GMT)
Date:   Tue, 22 Jun 2021 18:28:16 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH 2/2] KVM: s390: allow facility 192
 (vector-packed-decimal-enhancement facility 2)
Message-ID: <20210622182816.544674ee@ibm-vm>
In-Reply-To: <20210622143412.143369-3-borntraeger@de.ibm.com>
References: <20210622143412.143369-1-borntraeger@de.ibm.com>
        <20210622143412.143369-3-borntraeger@de.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: sIRT-7HYvrtzeA0WHiRPvlbUt0rkDZ71
X-Proofpoint-ORIG-GUID: yAT0TTgzhKeQxfbkjFNQqcQVvlzZqMMA
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-22_11:2021-06-22,2021-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 impostorscore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 adultscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106220100
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 22 Jun 2021 16:34:12 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> pass through newer vector instructions if vector support is enabled.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/kvm/kvm-s390.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 1296fc10f80c..0d59f9331649 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -713,6 +713,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> struct kvm_enable_cap *cap)
> set_kvm_facility(kvm->arch.model.fac_mask, 152);
> set_kvm_facility(kvm->arch.model.fac_list, 152); }
> +			if (test_facility(192)) {
> +
> set_kvm_facility(kvm->arch.model.fac_mask, 192);
> +
> set_kvm_facility(kvm->arch.model.fac_list, 192);
> +			}
>  			r = 0;
>  		} else
>  			r = -EINVAL;

