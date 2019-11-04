Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01929EDDF8
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 12:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbfKDLtV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 06:49:21 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24956 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726100AbfKDLtV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Nov 2019 06:49:21 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xA4BmkGl048338
        for <kvm@vger.kernel.org>; Mon, 4 Nov 2019 06:49:20 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w14m35vdh-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2019 06:49:19 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Mon, 4 Nov 2019 11:49:16 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 4 Nov 2019 11:49:15 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xA4BnDga45351378
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Nov 2019 11:49:13 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 84434AE051;
        Mon,  4 Nov 2019 11:49:13 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4282EAE053;
        Mon,  4 Nov 2019 11:49:13 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.39])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  4 Nov 2019 11:49:13 +0000 (GMT)
Date:   Mon, 4 Nov 2019 12:49:12 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 5/5] s390x: SCLP unit test
In-Reply-To: <56ce2fe9-1a6a-ffd6-3776-0be1b622032b@redhat.com>
References: <1572023194-14370-1-git-send-email-imbrenda@linux.ibm.com>
        <1572023194-14370-6-git-send-email-imbrenda@linux.ibm.com>
        <1df14176-20a7-a9af-5622-2853425d973e@redhat.com>
        <20191104122931.0774ff7a@p-imbrenda.boeblingen.de.ibm.com>
        <56ce2fe9-1a6a-ffd6-3776-0be1b622032b@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19110411-0028-0000-0000-000003B27D1F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19110411-0029-0000-0000-00002474D06D
Message-Id: <20191104124912.7cb58664@p-imbrenda.boeblingen.de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-04_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=672 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1911040119
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 4 Nov 2019 12:31:32 +0100
David Hildenbrand <david@redhat.com> wrote:

> On 04.11.19 12:29, Claudio Imbrenda wrote:
> > On Mon, 4 Nov 2019 11:58:20 +0100
> > David Hildenbrand <david@redhat.com> wrote:
> > 
> > [...]
> >   
> >> Can we just please rename all "cx" into something like "len"? Or is
> >> there a real need to have "cx" in there?  
> > 
> > if cx is such a nuisance to you, sure, I can rename it to i  
> 
> better than random characters :)

will be in v3

> >   
> >> Also, I still dislike "test_one_sccb". Can't we just just do
> >> something like
> >>
> >> expect_pgm_int();
> >> rc = test_one_sccb(...)
> >> report("whatever pgm", rc == WHATEVER);
> >> report("whatever rc", lc->pgm_int_code == WHATEVER);
> >>
> >> In the callers to make these tests readable and cleanup
> >> test_one_sccb(). I don't care if that produces more LOC as long as
> >> I can actually read and understand the test cases.  
> > 
> > if you think that makes it more readable, ok I guess...
> > 
> > consider that the output will be unreadable, though
> >   
> 
> I think his will turn out more readable.

two output lines per SCLP call? I  don't think so

