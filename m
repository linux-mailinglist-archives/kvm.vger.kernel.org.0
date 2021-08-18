Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77EA03F0077
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 11:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232482AbhHRJbS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 05:31:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24504 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232879AbhHRJap (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Aug 2021 05:30:45 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17I94KTU149006;
        Wed, 18 Aug 2021 05:30:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=rrwoT9lQw3iJLAday0YaBLJiNIrt6O/boGqB5QPpshg=;
 b=BlyB4FN4sfxN0P1PyrM3+pivFr5Iu5dM2Py2UFW2ZJ8jXus7A2YVLRBYaUWl16S4ZsaH
 qsHrOfFgNHn6IDg3thbiP0tus+6aVBynTH5lFkcR4M2Vadl3Gzu5naxZ3Op6LsIoz4wO
 nenTSQ3O3CKpvfybjeq/FOJh50W0X52NpJcIr6KZ4afFCR5WhJ1ZMdP86sQT5WVnrGzN
 XcD75GFGXU9JElXcuVwl5POiL8seLfkhqWMg5tbmZrCJ6rPRpdqFB93omDTCh8I+Vt8s
 N2ZkntpFK5GE3fBWah6/i2fBXetGAR9xEUjFDMyny5+MlwuuqQH+/sVyfsxy4IL30SNJ Rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3agcdxfjg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 05:30:07 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17I94TJ1151435;
        Wed, 18 Aug 2021 05:30:06 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3agcdxfjf9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 05:30:06 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17I9SAPM029785;
        Wed, 18 Aug 2021 09:30:05 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3ae5f8eac8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 09:30:04 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17I9U1gv49611232
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 09:30:01 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 730A1A4098;
        Wed, 18 Aug 2021 09:30:01 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19751A4090;
        Wed, 18 Aug 2021 09:30:01 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.14.177])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Aug 2021 09:30:01 +0000 (GMT)
Date:   Wed, 18 Aug 2021 11:29:58 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, david@redhat.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH 3/8] lib: s390x: Print addressing related
 exception information
Message-ID: <20210818112958.730f9ee3@p-imbrenda>
In-Reply-To: <1f99e6f8-27d1-7e4a-f706-12912e84f6f4@redhat.com>
References: <20210813073615.32837-1-frankja@linux.ibm.com>
        <20210813073615.32837-4-frankja@linux.ibm.com>
        <1f99e6f8-27d1-7e4a-f706-12912e84f6f4@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: gazWIKywtqLpAJo5AhsjGcAq7mSZiIdS
X-Proofpoint-GUID: kUsYpn9RgNxBx5KuThd0I__mwcB4gXOv
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-18_03:2021-08-17,2021-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 impostorscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108180056
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 18 Aug 2021 11:12:57 +0200
Thomas Huth <thuth@redhat.com> wrote:

> On 13/08/2021 09.36, Janosch Frank wrote:
> > Right now we only get told the kind of program exception as well as
> > the PSW at the point where it happened.
> > 
> > For addressing exceptions the PSW is not always enough so let's
> > print the TEID which contains the failing address and flags that
> > tell us more about the kind of address exception.
> > 
> > Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> > ---
> >   lib/s390x/asm/arch_def.h |  4 +++
> >   lib/s390x/interrupt.c    | 72
> > ++++++++++++++++++++++++++++++++++++++++ 2 files changed, 76
> > insertions(+)
> > 
> > diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> > index 4ca02c1d..39c5ba99 100644
> > --- a/lib/s390x/asm/arch_def.h
> > +++ b/lib/s390x/asm/arch_def.h
> > @@ -41,6 +41,10 @@ struct psw {
> >   	uint64_t	addr;
> >   };
> >   
> > +/* Let's ignore spaces we don't expect to use for now. */
> > +#define AS_PRIM				0
> > +#define AS_HOME				3
> > +
> >   #define PSW_MASK_EXT			0x0100000000000000UL
> >   #define PSW_MASK_IO			0x0200000000000000UL
> >   #define PSW_MASK_DAT			0x0400000000000000UL
> > diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> > index 01ded49d..1248bceb 100644
> > --- a/lib/s390x/interrupt.c
> > +++ b/lib/s390x/interrupt.c
> > @@ -12,6 +12,7 @@
> >   #include <sclp.h>
> >   #include <interrupt.h>
> >   #include <sie.h>
> > +#include <asm/page.h>
> >   
> >   static bool pgm_int_expected;
> >   static bool ext_int_expected;
> > @@ -126,6 +127,73 @@ static void fixup_pgm_int(struct
> > stack_frame_int *stack) /* suppressed/terminated/completed point
> > already at the next address */ }
> >   
> > +static void decode_pgm_prot(uint64_t teid)
> > +{
> > +	/* Low-address protection exception, 100 */
> > +	if (test_bit_inv(56, &teid) && !test_bit_inv(60, &teid) &&
> > !test_bit_inv(61, &teid)) {  
> 
> Likely just a matter of taste, but I'd prefer something like:
> 
> 	if ((teid & 0x8c) == 0x80) {

or even better:

	switch (teid & TEID_MASK) {

> 
> > +		printf("Type: LAP\n");
> > +		return;
> > +	}
> > +
> > +	/* Instruction execution prevention, i.e. no-execute, 101
> > */
> > +	if (test_bit_inv(56, &teid) && !test_bit_inv(60, &teid) &&
> > test_bit_inv(61, &teid)) {
> > +		printf("Type: IEP\n");
> > +		return;
> > +	}
> > +
> > +	/* Standard DAT exception, 001 */
> > +	if (!test_bit_inv(56, &teid) && !test_bit_inv(60, &teid)
> > && test_bit_inv(61, &teid)) {
> > +		printf("Type: DAT\n");
> > +		return;
> > +	}  
> 
> What about 010 (key controlled protection) and 011 (access-list
> controlled protection)? Even if we do not trigger those yet, it might
> make sense to add them right from the start, too?
> 
> > +}
> > +
> > +static void decode_teid(uint64_t teid)
> > +{
> > +	int asce_id = lc->trans_exc_id & 3;  
> 
> Why are you referencing the lc->trans_exc_id here again? It's already
> passed as "teid" parameter.
> 
> > +	bool dat = lc->pgm_old_psw.mask & PSW_MASK_DAT;
> > +
> > +	printf("Memory exception information:\n");
> > +	printf("TEID: %lx\n", teid);
> > +	printf("DAT: %s\n", dat ? "on" : "off");
> > +	printf("AS: %s\n", asce_id == AS_PRIM ? "Primary" :
> > "Home");  
> 
> Could "secondary" or "AR" mode really never happen here? I'd rather
> like to see a switch-case statement here that is able to print all
> four modes, just to avoid confusion.
> 
> > +	if (lc->pgm_int_code == PGM_INT_CODE_PROTECTION)
> > +		decode_pgm_prot(teid);
> > +
> > +	/*
> > +	 * If teid bit 61 is off for these two exception the
> > reported
> > +	 * address is unpredictable.
> > +	 */
> > +	if ((lc->pgm_int_code == PGM_INT_CODE_SECURE_STOR_ACCESS ||
> > +	     lc->pgm_int_code ==
> > PGM_INT_CODE_SECURE_STOR_VIOLATION) &&
> > +	    !test_bit_inv(61, &teid)) {
> > +		printf("Address: %lx, unpredictable\n ", teid &
> > PAGE_MASK);
> > +		return;
> > +	}
> > +	printf("Address: %lx\n\n", teid & PAGE_MASK);
> > +}
> > +
> > +static void print_storage_exception_information(void)
> > +{
> > +	switch (lc->pgm_int_code) {
> > +	case PGM_INT_CODE_PROTECTION:
> > +	case PGM_INT_CODE_PAGE_TRANSLATION:
> > +	case PGM_INT_CODE_SEGMENT_TRANSLATION:
> > +	case PGM_INT_CODE_ASCE_TYPE:
> > +	case PGM_INT_CODE_REGION_FIRST_TRANS:
> > +	case PGM_INT_CODE_REGION_SECOND_TRANS:
> > +	case PGM_INT_CODE_REGION_THIRD_TRANS:
> > +	case PGM_INT_CODE_SECURE_STOR_ACCESS:
> > +	case PGM_INT_CODE_NON_SECURE_STOR_ACCESS:
> > +	case PGM_INT_CODE_SECURE_STOR_VIOLATION:
> > +		decode_teid(lc->trans_exc_id);
> > +		break;
> > +	default:
> > +		return;  
> 
> I think you could drop that default case.
> 
> > +	}
> > +}
> > +
> >   static void print_int_regs(struct stack_frame_int *stack)
> >   {
> >   	printf("\n");
> > @@ -155,6 +223,10 @@ static void print_pgm_info(struct
> > stack_frame_int *stack) lc->pgm_int_code, stap(),
> > lc->pgm_old_psw.addr, lc->pgm_int_id); print_int_regs(stack);
> >   	dump_stack();
> > +
> > +	/* Dump stack doesn't end with a \n so we add it here
> > instead */
> > +	printf("\n");
> > +	print_storage_exception_information();
> >   	report_summary();
> >   	abort();
> >   }
> >   
> 

