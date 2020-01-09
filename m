Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 598D3135815
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 12:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbgAILg4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 06:36:56 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38978 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725308AbgAILgz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jan 2020 06:36:55 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 009BWvgZ024125
        for <kvm@vger.kernel.org>; Thu, 9 Jan 2020 06:36:54 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xe061g0g4-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 06:36:54 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Thu, 9 Jan 2020 11:36:52 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 9 Jan 2020 11:36:49 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 009Ba0Ck16187746
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Jan 2020 11:36:00 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A664AE053;
        Thu,  9 Jan 2020 11:36:48 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1FF7AE04D;
        Thu,  9 Jan 2020 11:36:47 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.108])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Jan 2020 11:36:47 +0000 (GMT)
Date:   Thu, 9 Jan 2020 12:36:46 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v5 3/4] s390x: lib: add SPX and STPX
 instruction wrapper
In-Reply-To: <ff1041f2-0262-ed89-4c5e-386f69d21cd0@redhat.com>
References: <20200108161317.268928-1-imbrenda@linux.ibm.com>
        <20200108161317.268928-4-imbrenda@linux.ibm.com>
        <ff1041f2-0262-ed89-4c5e-386f69d21cd0@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20010911-0012-0000-0000-0000037BE261
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20010911-0013-0000-0000-000021B8037B
Message-Id: <20200109123646.6b79194e@p-imbrenda>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-09_02:2020-01-09,2020-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 impostorscore=0 clxscore=1015 phishscore=0
 spamscore=0 malwarescore=0 adultscore=0 mlxlogscore=928 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-2001090103
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 8 Jan 2020 19:58:27 +0100
Thomas Huth <thuth@redhat.com> wrote:

> On 08/01/2020 17.13, Claudio Imbrenda wrote:
> > Add a wrapper for the SET PREFIX and STORE PREFIX instructions, and
> > use it instead of using inline assembly everywhere.  
> 
> Either some hunks are missing in this patch, or you should update the
> patch description and remove the second part of the sentence ? ... at
> least I did not spot the changes where you "use it instead of using
> inline assembly everywhere".


oops sorry, the description is a little misleading. I meant
everywhere in the specific unit test, not everywhere in the whole
source tree. 

I should either change the description or actually patch the remaining
users of inline assembly to use the wrappers instead. (any preference?)

