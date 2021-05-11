Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCD837A9C1
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 16:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231917AbhEKOnh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 10:43:37 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33234 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231907AbhEKOnf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 10:43:35 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14BEXset163153;
        Tue, 11 May 2021 10:42:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=xhQ5gEgTEeMF+s/V9Qj5bWmsYrCIYbh9/ofq4Ybpz8M=;
 b=ePW+ufh/AzL9rnHVKFMpPFYnnQJpufEcz4/yu5ROsqWbYoq43SydEFKVHiGY8DfRhNC4
 ehjgbgl+iIf4kjgcFDRUybRWK2zUeKi27uDynY8WeXOQYGgEqJ3W6F9co8gDgNi+gCiR
 Wb/Vb8kwqaOGFuTo/ynQWXapoPNDvszYLO1DbbYFV7/Te6j+3YlHruMQG6c4uNKEMzkw
 98yBUB4aM6mbSPSS/g4YEQouHDIhDyhCfhUXWgUI3uRyoRq9PLePVMq6iTZxTcMQJonn
 UFwOdUrNWCK2qgXmPYVIlpsJtfvofWrwk+2qNJc7L9N2PfF1A6LdBDsIg3nXdmyFgUKX SA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38ftxdj2nj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 10:42:28 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14BEY2r2164032;
        Tue, 11 May 2021 10:42:28 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38ftxdj2mh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 10:42:28 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14BEcYh5014416;
        Tue, 11 May 2021 14:42:25 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 38dj989que-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 14:42:25 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14BEgN0942205484
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 14:42:23 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 318EB11C052;
        Tue, 11 May 2021 14:42:23 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8AED211C050;
        Tue, 11 May 2021 14:42:22 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.13.244])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 May 2021 14:42:22 +0000 (GMT)
Date:   Tue, 11 May 2021 16:41:37 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        cohuck@redhat.com, linux-s390@vger.kernel.org, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH 2/4] lib: s390x: sclp: Extend feature
 probing
Message-ID: <20210511164137.0bba2493@ibm-vm>
In-Reply-To: <b0db681f-bfe3-5cf3-53f8-651bba04a5c5@redhat.com>
References: <20210510150015.11119-1-frankja@linux.ibm.com>
 <20210510150015.11119-3-frankja@linux.ibm.com>
 <b0db681f-bfe3-5cf3-53f8-651bba04a5c5@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: QAgOKv-2UUEHbWhPpziu3UM8E8gDY0mq
X-Proofpoint-GUID: XlNrX_1PY4GDd7c4qVzDpD-mOTgTy-NZ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-11_02:2021-05-11,2021-05-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0 clxscore=1015
 suspectscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105110110
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 May 2021 13:43:36 +0200
David Hildenbrand <david@redhat.com> wrote:

> On 10.05.21 17:00, Janosch Frank wrote:
> > Lets grab more of the feature bits from SCLP read info so we can use
> > them in the cpumodel tests.
> > 
> > Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> > Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >   lib/s390x/sclp.c | 20 ++++++++++++++++++++
> >   lib/s390x/sclp.h | 38 +++++++++++++++++++++++++++++++++++---
> >   2 files changed, 55 insertions(+), 3 deletions(-)
> > 
> > diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
> > index f11c2035..f25cfdb2 100644
> > --- a/lib/s390x/sclp.c
> > +++ b/lib/s390x/sclp.c
> > @@ -129,6 +129,13 @@ CPUEntry *sclp_get_cpu_entries(void)
> >   	return (CPUEntry *)(_read_info + read_info->offset_cpu);
> >   }
> >   
> > +static bool sclp_feat_check(int byte, int mask)
> > +{
> > +	uint8_t *rib = (uint8_t *)read_info;
> > +
> > +	return !!(rib[byte] & mask);
> > +}  
> 
> Instead of a mask, I'd just check for bit (offset) numbers within the
> byte.
> 
> static bool sclp_feat_check(int byte, int bit)
> {
> 	uint8_t *rib = (uint8_t *)read_info;
> 
> 	return !!(rib[byte] & (0x80 >> bit));
> }

using a mask might be useful to check multiple facilities at the same
time, but in that case the check should be

return (rib[byte] & mask) == mask

I have no strong opinions either way


