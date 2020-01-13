Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7755113910E
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2020 13:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbgAMM1s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 07:27:48 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29302 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726399AbgAMM1s (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Jan 2020 07:27:48 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00DCMYwj101753
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2020 07:27:47 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xfvpntuy7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2020 07:27:46 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Mon, 13 Jan 2020 12:27:45 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 13 Jan 2020 12:27:41 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00DCReos56426580
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jan 2020 12:27:40 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39B8FAE053;
        Mon, 13 Jan 2020 12:27:40 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F2D7FAE04D;
        Mon, 13 Jan 2020 12:27:39 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.108])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 13 Jan 2020 12:27:39 +0000 (GMT)
Date:   Mon, 13 Jan 2020 13:27:38 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, borntraeger@de.ibm.com
Subject: Re: [kvm-unit-tests PATCH v7 3/4] s390x: lib: add SPX and STPX
 instruction wrapper
In-Reply-To: <656129b7-68f2-d3ab-7428-91999c896ca5@linux.ibm.com>
References: <20200110184050.191506-1-imbrenda@linux.ibm.com>
        <20200110184050.191506-4-imbrenda@linux.ibm.com>
        <656129b7-68f2-d3ab-7428-91999c896ca5@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20011312-0028-0000-0000-000003D0A549
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20011312-0029-0000-0000-00002494C31A
Message-Id: <20200113132738.3c786c63@p-imbrenda>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-13_03:2020-01-13,2020-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 phishscore=0
 mlxscore=0 bulkscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 spamscore=0 clxscore=1015 suspectscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-2001130103
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 13 Jan 2020 10:42:01 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 1/10/20 7:40 PM, Claudio Imbrenda wrote:
> > Add a wrapper for the SET PREFIX and STORE PREFIX instructions, and
> > use it instead of using inline assembly.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > Reviewed-by: Thomas Huth <thuth@redhat.com>  
> 
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> 
> > @@ -63,14 +60,10 @@ static void test_spx(void)
> >  	 * some facility bits there ... at least some of them
> > should be
> >  	 * set in our buffer afterwards.
> >  	 */
> > -	asm volatile (
> > -		" stpx	%0\n"
> > -		" spx	%1\n"
> > -		" stfl	0\n"
> > -		" spx	%0\n"
> > -		: "+Q"(old_prefix)
> > -		: "Q"(new_prefix)
> > -		: "memory");
> > +	old_prefix = get_prefix();
> > +	set_prefix(new_prefix);
> > +	asm volatile("	stfl 0" : : : "memory");  
> 
> Couldn't we also use stfl from facility.h here?
> And do we need to add a memory clobber to it?

will do both

> > +	set_prefix(old_prefix);
> >  	report(pagebuf[GEN_LC_STFL] != 0, "stfl to new prefix");
> >  
> >  	expect_pgm_int();
> >   
> 
> 

