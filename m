Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 193783DA453
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 15:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237895AbhG2NaP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 09:30:15 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38268 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237836AbhG2N3N (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Jul 2021 09:29:13 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16TD4Lhl118285;
        Thu, 29 Jul 2021 09:29:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=n/FI01LIc1Yi03z/F59rRDY4CLBKGvjDsox2Mu6xUBI=;
 b=pCi7DDVncmuEieR0EOmwJpLGQmrNUYMSRDNrUzJqqNMmhZPnoxth5cfk6lydCdG0d8i1
 DCKx5uYQMC+j3luGVl3ZlFXaoCTT+FNoRwA1e8si+ELsYotuLbRRDRV3NtE/yK5kIbi0
 WZL0/Uei7rOl1Pp7+kH5Eau8aLspoFOycTL2AwEWXSpvscztllywZCHXV054MiOaJADD
 YZiRk/igf1xfZYeepNeDHdMaZhk1bJKELikDxJ5qtyIUhd8Dx3MQK3AqMcaeB1LHX6xb
 bMKM4MWJfcIuxS/6E4Zy1LOz0mAZwQGAresp8WaJgFDVye08QRuAvf2NqXRPwvt8YB0N Eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a3v5s2sxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 09:29:09 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16TDI7o0190642;
        Thu, 29 Jul 2021 09:29:08 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a3v5s2swv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 09:29:08 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16TDIbhD023522;
        Thu, 29 Jul 2021 13:29:07 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3a235yhr2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 13:29:06 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16TDQIjC29163836
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 13:26:18 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 43923A4062;
        Thu, 29 Jul 2021 13:29:03 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3B59A4054;
        Thu, 29 Jul 2021 13:29:02 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.1.151])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 29 Jul 2021 13:29:02 +0000 (GMT)
Date:   Thu, 29 Jul 2021 15:28:55 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, cohuck@redhat.com, borntraeger@de.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 13/13] KVM: s390: pv: add support for UV feature bits
Message-ID: <20210729152855.5e25aa73@p-imbrenda>
In-Reply-To: <4d26ba27-e235-8f2b-c59c-01d3e0691453@linux.ibm.com>
References: <20210728142631.41860-1-imbrenda@linux.ibm.com>
        <20210728142631.41860-14-imbrenda@linux.ibm.com>
        <4d26ba27-e235-8f2b-c59c-01d3e0691453@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: UUz94RYti661aEkcEtVaLzvX_T7KexiS
X-Proofpoint-GUID: 7Mvun8R3E7JFZfJ0V1yWgAB5x0L0PkIO
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-29_10:2021-07-29,2021-07-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 clxscore=1015 bulkscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 29 Jul 2021 11:52:58 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 7/28/21 4:26 PM, Claudio Imbrenda wrote:
> > Add support for Ultravisor feature bits, and take advantage of the
> > functionality advertised to speed up the lazy destroy mechanism.  
> 
> UV feature bit support is already merged please fix the description
> and subject.

oops, will be fixed

> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >  arch/s390/kernel/uv.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> > index f0af49b09a91..6ec3d7338ec8 100644
> > --- a/arch/s390/kernel/uv.c
> > +++ b/arch/s390/kernel/uv.c
> > @@ -290,7 +290,8 @@ static int make_secure_pte(pte_t *ptep,
> > unsigned long addr, 
> >  static bool should_export_before_import(struct uv_cb_header *uvcb,
> > struct mm_struct *mm) {
> > -	return uvcb->cmd != UVC_CMD_UNPIN_PAGE_SHARED &&
> > +	return !test_bit_inv(BIT_UV_FEAT_MISC,
> > &uv_info.uv_feature_indications) &&
> > +		uvcb->cmd != UVC_CMD_UNPIN_PAGE_SHARED &&
> >  		atomic_read(&mm->context.is_protected) > 1;
> >  }
> >  
> >   
> 

