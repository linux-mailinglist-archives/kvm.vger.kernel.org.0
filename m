Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C89CDF43CE
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 10:46:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731387AbfKHJqu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 8 Nov 2019 04:46:50 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40714 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730645AbfKHJqt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 Nov 2019 04:46:49 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xA89gZ5I127541
        for <kvm@vger.kernel.org>; Fri, 8 Nov 2019 04:46:48 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2w541c49qa-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2019 04:46:47 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Fri, 8 Nov 2019 09:46:46 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 8 Nov 2019 09:46:43 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xA89kfXW9830592
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 Nov 2019 09:46:41 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 775AAA405B;
        Fri,  8 Nov 2019 09:46:41 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3EAF5A404D;
        Fri,  8 Nov 2019 09:46:41 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.39])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  8 Nov 2019 09:46:41 +0000 (GMT)
Date:   Fri, 8 Nov 2019 10:46:40 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 5/5] s390x: SCLP unit test
In-Reply-To: <b4344967-54d2-5b57-8d36-dd1361654c8e@redhat.com>
References: <1572023194-14370-1-git-send-email-imbrenda@linux.ibm.com>
        <1572023194-14370-6-git-send-email-imbrenda@linux.ibm.com>
        <191dbc7f-74b2-6f78-a721-aaac49895948@linux.ibm.com>
        <20191104121901.3b3ab68b@p-imbrenda.boeblingen.de.ibm.com>
        <b4344967-54d2-5b57-8d36-dd1361654c8e@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-TM-AS-GCONF: 00
x-cbid: 19110809-4275-0000-0000-0000037BEBA3
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19110809-4276-0000-0000-0000388F3F9C
Message-Id: <20191108104640.246412bd@p-imbrenda.boeblingen.de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-08_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911080095
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 8 Nov 2019 10:35:32 +0100
Thomas Huth <thuth@redhat.com> wrote:

> On 04/11/2019 12.19, Claudio Imbrenda wrote:
> > On Mon, 4 Nov 2019 10:45:07 +0100
> > Janosch Frank <frankja@linux.ibm.com> wrote:  
> [...]
> >>> +static void test_toolong(void)
> >>> +{
> >>> +	uint32_t cmd = SCLP_CMD_WRITE_EVENT_DATA;
> >>> +	uint16_t res = SCLP_RC_SCCB_BOUNDARY_VIOLATION;  
> >>
> >> Why use variables for constants that are never touched?  
> > 
> > readability mostly. the names of the constants are rather long.
> > the compiler will notice it and do the Right Thing™  
> 
> I'd like to suggest to add the "const" keyword to both variables in
> that case, then it's clear that they are not used to be modified.

good point

> >>> +		h->length = 4096;
> >>> +
> >>> +		valid_code = commands[i];
> >>> +		cc = sclp_service_call(commands[i], h);
> >>> +		if (cc)
> >>> +			break;
> >>> +		if (h->response_code ==
> >>> SCLP_RC_NORMAL_READ_COMPLETION)
> >>> +			return;
> >>> +		if (h->response_code !=
> >>> SCLP_RC_INVALID_SCLP_COMMAND)
> >>> +			break;  
> >>
> >> Depending on line length you could add that to the cc check.
> >> Maybe you could also group the error conditions before the success
> >> conditions or the other way around.  
> > 
> > yeah it woud fit, but I'm not sure it would be more readable:
> > 
> > if (cc || (h->response_code != SCLP_RC_INVALID_SCLP_COMMAND))
> >                          break;  
> 
> In case you go with that solution, please drop the innermost
> parentheses.

why so much hatred for parentheses? :D

but no, I'm not going to do it, it's not just less readable, it's
actually wrong!

SCLP_RC_NORMAL_READ_COMPLETION != SCLP_RC_INVALID_SCLP_COMMAND

the correct version would be:

if (cc ||
	h->response_code != SCLP_RC_INVALID_SCLP_COMMAND &&
	h->response_code != SCLP_RC_NORMAL_READ_COMPLETION)

which is more lines, and significantly less readable.

