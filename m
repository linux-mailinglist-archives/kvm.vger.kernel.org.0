Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 671C63931B2
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 17:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235124AbhE0PGp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 11:06:45 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14398 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229774AbhE0PGo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 May 2021 11:06:44 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14RF3sHj079795;
        Thu, 27 May 2021 11:05:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=nIPdJ+FRa7U9Yatl5ghlocd7ojAdQJ+SLaNmWFFXnSY=;
 b=ZYsnGola19lRZLGlbIGzjYrrwxAUZuDzorQHq2uuXIREbps+lLfvADvQrLCM/EQrDORc
 3pAKkLEx+6FZ1B2z6BzTHEQUI6r8kgomZ/w+nbrLdLAM5aUDJTT+9NynWMdaS65wf60s
 2l5lALND3E9OqofoPVFVCGvdlOQ3Hgx840xGK2YpqxXJzwAZOj5mU77plo0rnEbvKmEE
 N5Zx74QcQEyx23T0wR24nrVv0ObEO2V3nAlhSpJh4lbJ9iTqCBYFkQQwO9ZrRH9rdnN3
 ZMf1mK1W2/AgT7dDwU4w7D7S9fnBaOWwiQ4I0W7zIbhrjKDrBGetkZ2LTY/Y+MYNHnP5 Vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38tcmqar78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 11:05:11 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14RF3wgc080092;
        Thu, 27 May 2021 11:05:11 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38tcmqar5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 11:05:11 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 14RF3Ife017061;
        Thu, 27 May 2021 15:05:09 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 38sba2s18a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 15:05:08 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14RF56kP12517816
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 May 2021 15:05:06 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 99DC5AE055;
        Thu, 27 May 2021 15:05:06 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10C73AE056;
        Thu, 27 May 2021 15:05:06 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.7.194])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 May 2021 15:05:05 +0000 (GMT)
Date:   Thu, 27 May 2021 17:05:04 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 5/7] s390x: lib: add teid union and
 clear teid from lowcore
Message-ID: <20210527170504.33a82226@ibm-vm>
In-Reply-To: <3afb626a-35d0-a1af-c99f-92e4d4ae5cba@linux.ibm.com>
References: <20210526134245.138906-1-imbrenda@linux.ibm.com>
        <20210526134245.138906-6-imbrenda@linux.ibm.com>
        <3afb626a-35d0-a1af-c99f-92e4d4ae5cba@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bM3VR6co51rHZOelEqvRoq4vzEyiXI70
X-Proofpoint-ORIG-GUID: yulGzT6H2MKAglPDW5H22eQeZXDxa8mg
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-27_07:2021-05-27,2021-05-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 impostorscore=0 spamscore=0 phishscore=0 adultscore=0
 clxscore=1015 suspectscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105270099
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 27 May 2021 16:52:48 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 5/26/21 3:42 PM, Claudio Imbrenda wrote:
> > Add a union to represent Translation-Exception Identification
> > (TEID).
> > 
> > Clear the TEID in expect_pgm_int clear_pgm_int.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>  
> 
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> 
> > ---
> >  lib/s390x/asm/interrupt.h | 22 ++++++++++++++++++++++
> >  lib/s390x/interrupt.c     |  2 ++
> >  2 files changed, 24 insertions(+)
> > 
> > diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
> > index bf0eb40d..b40def65 100644
> > --- a/lib/s390x/asm/interrupt.h
> > +++ b/lib/s390x/asm/interrupt.h
> > @@ -13,6 +13,28 @@
> >  #define EXT_IRQ_EXTERNAL_CALL	0x1202
> >  #define EXT_IRQ_SERVICE_SIG	0x2401
> >  
> > +#define TEID_ASCE_PRIMARY	0
> > +#define TEID_ASCE_AR		1
> > +#define TEID_ASCE_SECONDARY	2
> > +#define TEID_ASCE_HOME		3
> > +
> > +union teid {
> > +	unsigned long val;
> > +	struct {
> > +		unsigned long addr:52;
> > +		unsigned long fetch:1;
> > +		unsigned long store:1;
> > +		unsigned long reserved:6;
> > +		unsigned long acc_list_prot:1;
> > +		/* depending on the exception and the installed
> > facilities,
> > +		 * the m field can indicate severel different
> > things,  
> 
> several

fixed

> > +		 * including whether the exception was triggered
> > by a MVPG
> > +		 * instruction, or whether the addr field is
> > meaningful */  
> 
> Could you please convert the comment style to this?
> 
> /*
>  * Text
>  */

and fixed

> > +		unsigned long m:1;
> > +		unsigned long asce_id:2;
> > +	};
> > +};
> > +
> >  void register_pgm_cleanup_func(void (*f)(void));
> >  void handle_pgm_int(struct stack_frame_int *stack);
> >  void handle_ext_int(struct stack_frame_int *stack);
> > diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> > index ce0003de..b627942f 100644
> > --- a/lib/s390x/interrupt.c
> > +++ b/lib/s390x/interrupt.c
> > @@ -22,6 +22,7 @@ void expect_pgm_int(void)
> >  {
> >  	pgm_int_expected = true;
> >  	lc->pgm_int_code = 0;
> > +	lc->trans_exc_id = 0;
> >  	mb();
> >  }
> >  
> > @@ -39,6 +40,7 @@ uint16_t clear_pgm_int(void)
> >  	mb();
> >  	code = lc->pgm_int_code;
> >  	lc->pgm_int_code = 0;
> > +	lc->trans_exc_id = 0;
> >  	pgm_int_expected = false;
> >  	return code;
> >  }
> >   
> 

