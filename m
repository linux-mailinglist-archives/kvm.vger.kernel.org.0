Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15790139178
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2020 13:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgAMM6t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 07:58:49 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7046 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726074AbgAMM6t (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Jan 2020 07:58:49 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00DCvwSw140924
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2020 07:58:48 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xfa2592kk-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2020 07:58:45 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Mon, 13 Jan 2020 12:58:36 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 13 Jan 2020 12:58:35 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00DCwXnI61014150
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jan 2020 12:58:33 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B9146A4051;
        Mon, 13 Jan 2020 12:58:33 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7DCABA404D;
        Mon, 13 Jan 2020 12:58:33 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.108])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 13 Jan 2020 12:58:33 +0000 (GMT)
Date:   Mon, 13 Jan 2020 13:58:32 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v7 4/4] s390x: SCLP unit test
In-Reply-To: <1b86b00a-261e-3d8c-fa52-c30e67463ad5@redhat.com>
References: <20200110184050.191506-1-imbrenda@linux.ibm.com>
        <20200110184050.191506-5-imbrenda@linux.ibm.com>
        <8d7fb5c4-9e2c-e28a-16c0-658afcc8178d@redhat.com>
        <20200113133325.417bf657@p-imbrenda>
        <1b86b00a-261e-3d8c-fa52-c30e67463ad5@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20011312-0020-0000-0000-000003A03EA9
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20011312-0021-0000-0000-000021F7ADC5
Message-Id: <20200113135832.1c6d3bb8@p-imbrenda>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-13_03:2020-01-13,2020-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 phishscore=0 mlxlogscore=553
 malwarescore=0 impostorscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001130108
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 13 Jan 2020 13:48:17 +0100
David Hildenbrand <david@redhat.com> wrote:

[...]
	    
> >>
> >> I wonder if something like the following would be possible:
> >>
> >> expect_pgm_int();
> >> ...
> >> asm volatiole();
> >> ...
> >> sclp_wait_busy();
> >> check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);  
> > 
> > we do not expect a specification exception, if that happens it's
> > a bug and the test should rightfully fail.  
> 
> Which one do we expect? (you're not checking for a specific one,
> should you?)

nothing, the call should succeed :)

> >   
> >> We would have to clear "sclp_busy" when we get a progam interrupt
> >> on a servc instruction - shouldn't be too hard to add to the
> >> program exception handler.  
> > 
> > Sure that could be done, but is it worth it to rework the program
> > interrupt handler only for one unit test?  
> 
> Good point. I don't like this particular code, but I can live with it
> :)
> 

