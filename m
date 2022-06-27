Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C90F955C43D
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232501AbiF0KrN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 06:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232633AbiF0KrM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 06:47:12 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B494641B;
        Mon, 27 Jun 2022 03:47:12 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25RAaTPY005669;
        Mon, 27 Jun 2022 10:47:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=SoK8OpT4tC9h6rVXIPk1TfPr3teIYh0dUTwgTFTcs8I=;
 b=TXFVUl++G0RQPyDHilq/bdmU4UdtgXcI7Vs2mHUrxAIUmtjSn2elW0BRDh2dfE1B+j4r
 Stnrnp09Xtq4t8uAigutvlZgegx5R0//qWhXn7ojk8g+rRoMeOhxNXmBJOH7+GSVAbsi
 6mLBz7D24UbGT2LNZdpQUccW9MM8x60h0AMnAi31rSfdSKinjZq67rWYO7PiwG6sU9yS
 j17pLniV/AMPDvXIRnbarLuBN9PkiGCdLurQykqwFFoan7GdinqAUvcKy0PgLlJj7P4b
 brgWX6x7+rpiI5xYxMJKf85TIkw5LjuN44wcNfHijmURvCTCYKmdUfcHtf2NKbWm4MSt Tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gy9q22tb2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 10:47:11 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25RAadJD006753;
        Mon, 27 Jun 2022 10:47:11 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gy9q22ta5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 10:47:10 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25RAaUkx020970;
        Mon, 27 Jun 2022 10:47:08 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3gwt0924je-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 10:47:08 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25RAl5Fk10879358
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jun 2022 10:47:05 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3783E4C044;
        Mon, 27 Jun 2022 10:47:05 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E55F14C040;
        Mon, 27 Jun 2022 10:47:04 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.40])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 Jun 2022 10:47:04 +0000 (GMT)
Date:   Mon, 27 Jun 2022 12:47:03 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        scgl@linux.ibm.com, nrb@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 1/3] lib: s390x: add functions to set
 and clear PSW bits
Message-ID: <20220627124703.2835a11e@p-imbrenda>
In-Reply-To: <6e6e4e06-a32f-c5b7-0b3a-f9f62ed164df@linux.ibm.com>
References: <20220624144518.66573-1-imbrenda@linux.ibm.com>
        <20220624144518.66573-2-imbrenda@linux.ibm.com>
        <6e6e4e06-a32f-c5b7-0b3a-f9f62ed164df@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RfHgFxpqfX8mMfgKq-Bsz9o8LnXlPFZw
X-Proofpoint-GUID: Lxla8KcD3M6czRNtEmFUdEJcBpEpEdvz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-27_06,2022-06-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 mlxscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206270046
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 27 Jun 2022 10:35:11 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 6/24/22 16:45, Claudio Imbrenda wrote:
> > Add some functions to set and/or clear bits in the PSW.
> > This should improve code readability.
> >   
> 
> Also we introduce PSW_MASK_KEY and re-order the PSW_MASK_* constants so 
> they are descending in value.

will fix the description

> 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >   lib/s390x/asm/arch_def.h | 58 +++++++++++++++++++++++++++++++++++-----
> >   lib/s390x/asm/pgtable.h  |  2 --
> >   lib/s390x/mmu.c          | 14 +---------
> >   lib/s390x/sclp.c         |  7 +----
> >   s390x/diag288.c          |  6 ++---
> >   s390x/selftest.c         |  4 +--
> >   s390x/skrf.c             | 12 +++------
> >   s390x/smp.c              | 18 +++----------
> >   8 files changed, 63 insertions(+), 58 deletions(-)
> > 
> > diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> > index 78b257b7..b0052848 100644
> > --- a/lib/s390x/asm/arch_def.h
> > +++ b/lib/s390x/asm/arch_def.h
> > @@ -46,9 +46,10 @@ struct psw {
> >   #define AS_SECN				2
> >   #define AS_HOME				3
> >   
> > -#define PSW_MASK_EXT			0x0100000000000000UL
> > -#define PSW_MASK_IO			0x0200000000000000UL
> >   #define PSW_MASK_DAT			0x0400000000000000UL
> > +#define PSW_MASK_IO			0x0200000000000000UL
> > +#define PSW_MASK_EXT			0x0100000000000000UL
> > +#define PSW_MASK_KEY			0x00F0000000000000UL
> >   #define PSW_MASK_WAIT			0x0002000000000000UL
> >   #define PSW_MASK_PSTATE			0x0001000000000000UL
> >   #define PSW_MASK_EA			0x0000000100000000UL
> > @@ -313,6 +314,53 @@ static inline void load_psw_mask(uint64_t mask)
> >   		: "+r" (tmp) :  "a" (&psw) : "memory", "cc" );
> >   }
> >   
> > +/**
> > + * psw_mask_set_clear_bits - sets and clears bits from the current PSW mask
> > + * @clear: bitmask of bits that will be cleared
> > + * @set: bitmask of bits that will be set
> > + *
> > + * Bits will be cleared first, and then set, so if (@clear & @set != 0) then
> > + * the bits in the intersection will be set.
> > + */
> > +static inline void psw_mask_set_clear_bits(uint64_t clear, uint64_t set)  
> 
> This function isn't used at all, no?

not currently, but it's useful to have in the lib
