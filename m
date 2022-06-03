Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0C4E53CC30
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 17:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245430AbiFCPUS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 11:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbiFCPUQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 11:20:16 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D159D50472;
        Fri,  3 Jun 2022 08:20:12 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 253EoREu021560;
        Fri, 3 Jun 2022 15:20:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=OyJKdtXGWQ0cMruYZbsIyBZTXt3E2exsfuYrebzAd4I=;
 b=ZfpgbDFthcE8lIlmm3ZCYoD5qdgvP7792V0vulovrRd4nI54SWSx32QN0ZDEHXh78m9O
 eFiOtv+GO+mHCWaJ/t9/5uo0ZCm94yISBQTvBORYHo8VcUPh50ahuwh2Gu9vdtR/nFWN
 9CGKbfnLLuHKo/zoSuI1sEwpp8HYH7cTpsaZmh5KaMcXj+t2CGsrfxwBRJWYGQHSdBJJ
 T57AWqZMPxDwtSdMw7v0B2k8KXHyrN+ngWRoIQ0k06kjF7w+9v0WQEV7VPXOiW9jDCiZ
 l4LZcpHHGntRzETKcm4kAinv760DlGdovo3e0Ccm1qpRY3g1jArqsVMF5ISuvfaitAIi Zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gfmdr8kf3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 15:20:11 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 253EsOvG003535;
        Fri, 3 Jun 2022 15:20:11 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gfmdr8kek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 15:20:11 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 253F6Sg0016777;
        Fri, 3 Jun 2022 15:20:09 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 3gf2afgw6x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 15:20:09 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 253FK59l19333476
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Jun 2022 15:20:05 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90E42A405C;
        Fri,  3 Jun 2022 15:20:05 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 594F5A4054;
        Fri,  3 Jun 2022 15:20:05 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.40])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  3 Jun 2022 15:20:05 +0000 (GMT)
Date:   Fri, 3 Jun 2022 17:20:03 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 3/3] s390x: Rework TEID decoding and
 usage
Message-ID: <20220603172003.0eacd9d0@p-imbrenda>
In-Reply-To: <c5eb73b0-776d-d0eb-7040-09fcbb603a8f@linux.ibm.com>
References: <20220520190850.3445768-1-scgl@linux.ibm.com>
        <20220520190850.3445768-4-scgl@linux.ibm.com>
        <20220524164030.6adb45bf@p-imbrenda>
        <c5eb73b0-776d-d0eb-7040-09fcbb603a8f@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: T1OYNcfnqol5cDJA557Lghm9ZJgISk2q
X-Proofpoint-GUID: LqkZfSKOeu-oAitEteYM0raUvpcXVrYF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-03_05,2022-06-03_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 adultscore=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 clxscore=1015 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206030067
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 3 Jun 2022 15:49:33 +0200
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

[...]

> >   
> >> +			uint64_t asce_id		: 64 - 62;
> >> +		};
> >> +		/* DAT exc */
> >> +		struct {
> >> +			uint64_t /* pad */		: 61 -  0;
> >> +			uint64_t dat_move_page		: 62 - 61;
> >> +		};
> >> +		/* suppression on protection */
> >> +		struct {
> >> +			uint64_t /* pad */		: 60 -  0;
> >> +			uint64_t sop_acc_list		: 61 - 60;
> >> +			uint64_t sop_teid_predictable	: 62 - 61;
> >> +		};
> >> +		/* enhanced suppression on protection 1 */
> >> +		struct {
> >> +			uint64_t /* pad */		: 61 -  0;  
> > 
> > 60 - 0
> >   
> >> +			uint64_t esop1_acc_list_or_dat	: 62 - 61;  
> > 
> > 61 - 60
> > 
> > and then:
> > 
> > uint64_t esop1_teid_predictable : 62 - 61;
> >   
> Ah, no, but I see how it is confusing.
> If bit 61 is one then the exception is due to access list or DAT.

ok

> That's why its called acc_list_or_dat.
> If it is zero it's due to low address or key and the rest of the TEID
> is unpredictable. So this is an alias of sop_teid_predictable.

ok, but then you need a definition for bit 60, which tells whether it
is DAT or ACL. (but see below)

> 
> >> +		};
> >> +		/* enhanced suppression on protection 2 */
> >> +		struct {
> >> +			uint64_t /* pad */		: 56 -  0;
> >> +			uint64_t esop2_prot_code_0	: 57 - 56;
> >> +			uint64_t /* pad */		: 60 - 57;
> >> +			uint64_t esop2_prot_code_1	: 61 - 60;
> >> +			uint64_t esop2_prot_code_2	: 62 - 61;
> >> +		};
> >>  	};
> >>  };
> >>  
> >> +enum prot_code {
> >> +	PROT_KEY_LAP,
> >> +	PROT_DAT,
> >> +	PROT_KEY,
> >> +	PROT_ACC_LIST,
> >> +	PROT_LAP,
> >> +	PROT_IEP,  
> > 
> > I would still also define two PROT_INVALID or PROT_RESERVED
> > 
> > just to avoid surprises
> >   
> I guess the values are reserved, but maybe an assert would be better?

ok

> Then we'd be notified to fix the test.
> 

[...]

> >> @@ -65,10 +93,10 @@ void print_decode_teid(uint64_t teid)
> >>  	 */
> >>  	if ((lowcore.pgm_int_code == PGM_INT_CODE_SECURE_STOR_ACCESS ||
> >>  	     lowcore.pgm_int_code == PGM_INT_CODE_SECURE_STOR_VIOLATION) &&
> >> -	    !test_bit_inv(61, &teid)) {
> >> -		printf("Address: %lx, unpredictable\n ", teid & PAGE_MASK);
> >> +	    !teid.sop_teid_predictable) {
> >> +		printf("Address: %lx, unpredictable\n ", raw_teid & PAGE_MASK);
> >>  		return;
> >>  	}
> >> -	printf("TEID: %lx\n", teid);
> >> -	printf("Address: %lx\n\n", teid & PAGE_MASK);
> >> +	printf("TEID: %lx\n", raw_teid);
> >> +	printf("Address: %lx\n\n", raw_teid & PAGE_MASK);  
> > 
> > teid.addr << PAGE_SHIFT ?  
> 
> I got compiler warnings because teid.addr is 52 bit.

oufff... ok forget it then, keep it as it is

> >   
> >>  }
> >> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> >> index 6da20c44..ac3d1ecd 100644
> >> --- a/lib/s390x/interrupt.c
> >> +++ b/lib/s390x/interrupt.c
> >> @@ -77,7 +77,7 @@ static void fixup_pgm_int(struct stack_frame_int *stack)
> >>  		break;
> >>  	case PGM_INT_CODE_PROTECTION:
> >>  		/* Handling for iep.c test case. */
> >> -		if (prot_is_iep(lowcore.trans_exc_id))
> >> +		if (prot_is_iep((union teid) { .val = lowcore.trans_exc_id }))
> >>  			/*
> >>  			 * We branched to the instruction that caused
> >>  			 * the exception so we can use the return
> >> diff --git a/s390x/edat.c b/s390x/edat.c
> >> index c6c25042..af442039 100644
> >> --- a/s390x/edat.c
> >> +++ b/s390x/edat.c
> >> @@ -37,14 +37,20 @@ static bool check_pgm_prot(void *ptr)
> >>  		return false;
> >>  
> >>  	teid.val = lowcore.trans_exc_id;
> >> -
> >> -	/*
> >> -	 * depending on the presence of the ESOP feature, the rest of the
> >> -	 * field might or might not be meaningful when the m field is 0.
> >> -	 */
> >> -	if (!teid.m)
> >> +	switch (get_supp_on_prot_facility()) {
> >> +	case SOP_NONE:
> >>  		return true;
> >> -	return (!teid.acc_list_prot && !teid.asce_id &&
> >> +	case SOP_BASIC:
> >> +		if (!teid.sop_teid_predictable)
> >> +			return true;  
> >   
> This function is mostly correct, except it's missing
> break; statements (so not correct at all :)).
> 
> > add:
> > 
> > if (teid.sop_acc_list)
> > 	return false;
> >   
> Will be taken care of by the return statement at the very bottom.
> 
> >> +	case SOP_ENHANCED_1:  
> > 
> > you need to handle the unpredictable case here too
> >   
> >> +		if (!teid.esop1_acc_list_or_dat)
> >> +			return false;  
> >
> > so you return false the it is DAT... but if it is not DAT, it's
> > access-control-list... 
> >   
> So this makes sense if instead you think about bit 61.
> It also shows the rational for the variable name if you read it as
> "if the exception was not due to either access list or DAT", so we
> return false in case we know it was not DAT.

ahh I see.

at this point I think it would be better to simply remove that bit, and
only use sop_teid_predictable and sop_acc_list

> 
> > you might want to replace this whole case with:
> > 
> > return !teid.esop1_teid_predictable;
> > 
> > (although I don't understand why you want to exclude DAT here)
> >   
> >> +	case SOP_ENHANCED_2:
> >> +		if (teid_esop2_prot_code(teid) != 1)  
> > 
> > why not using the PROT_DAT enum?  
> 
> Just forgot.
> 
> > also, handle the PROT_ACC_LIST too
> > 
> > also, add:
> > 
> > if (PROT_KEY_LAP)
> > 	return true;  
> 
> Am I misunderstanding the edat test? We're expecting nothing but
> DAT protection exceptions, no? So everything else is a test failure.

then return false

currently you would not handle that correctly, I think

> > 
> > because in that case you don't have the address part.
> > 
> > 
> > 
> > but at this point I wonder if you can't just rewrite this function with
> > an additional enum prot_code parameter, to specify the exact type of
> > exception you're expecting  
> 
> Maybe, but I don't think it's worth it. The logic is complicated and I'd

fair enough

> prefer to keep it as simple as possible and keeping it specific to the test
> helps with that, instead of generalizing it to all possibilities.
> >   
> >> +			return false;
> >> +	}
> >> +	return (!teid.sop_acc_list && !teid.asce_id &&
> >>  		(teid.addr == ((unsigned long)ptr >> PAGE_SHIFT)));
> >>  }
> >>    
> >   
> 

