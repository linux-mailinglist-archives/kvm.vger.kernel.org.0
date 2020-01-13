Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C058139125
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2020 13:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgAMMdf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 07:33:35 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21212 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725832AbgAMMde (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Jan 2020 07:33:34 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00DCXBMc059790
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2020 07:33:33 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xfve8awft-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2020 07:33:33 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Mon, 13 Jan 2020 12:33:31 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 13 Jan 2020 12:33:29 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00DCXR5n36569248
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jan 2020 12:33:27 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C75075204F;
        Mon, 13 Jan 2020 12:33:27 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.108])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 89D2752051;
        Mon, 13 Jan 2020 12:33:27 +0000 (GMT)
Date:   Mon, 13 Jan 2020 13:33:25 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v7 4/4] s390x: SCLP unit test
In-Reply-To: <8d7fb5c4-9e2c-e28a-16c0-658afcc8178d@redhat.com>
References: <20200110184050.191506-1-imbrenda@linux.ibm.com>
        <20200110184050.191506-5-imbrenda@linux.ibm.com>
        <8d7fb5c4-9e2c-e28a-16c0-658afcc8178d@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20011312-4275-0000-0000-00000397208B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20011312-4276-0000-0000-000038AB164E
Message-Id: <20200113133325.417bf657@p-imbrenda>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-13_03:2020-01-13,2020-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 adultscore=0 phishscore=0 impostorscore=0
 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=548 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001130104
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 13 Jan 2020 12:00:00 +0100
David Hildenbrand <david@redhat.com> wrote:

> > +/**
> > + * Test some bits in the instruction format that are specified to
> > be ignored.
> > + */
> > +static void test_instbits(void)
> > +{
> > +	SCCBHeader *h = (SCCBHeader *)pagebuf;
> > +	int cc;
> > +
> > +	expect_pgm_int();
> > +	sclp_mark_busy();
> > +	h->length = 8;
> > +	sclp_setup_int();
> > +
> > +	asm volatile(
> > +		"       .insn   rre,0xb2204200,%1,%2\n"  /* servc
> > %1,%2 */
> > +		"       ipm     %0\n"
> > +		"       srl     %0,28"
> > +		: "=&d" (cc) : "d" (valid_code), "a"
> > (__pa(pagebuf))
> > +		: "cc", "memory");
> > +	if (lc->pgm_int_code) {
> > +		sclp_handle_ext();
> > +		cc = 1;
> > +	} else if (!cc)
> > +		  
> 
> I wonder if something like the following would be possible:
> 
> expect_pgm_int();
> ...
> asm volatiole();
> ...
> sclp_wait_busy();
> check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);

we do not expect a specification exception, if that happens it's
a bug and the test should rightfully fail.

> We would have to clear "sclp_busy" when we get a progam interrupt on a
> servc instruction - shouldn't be too hard to add to the program
> exception handler.

Sure that could be done, but is it worth it to rework the program
interrupt handler only for one unit test?

[...]

> > +	valid_code = 0;  
> 
> This can be dropped because ...
> 
> > +	report_abort("READ_SCP_INFO failed");  
> 
> ... you abort here.

will fix 

