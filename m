Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D00A621ED8C
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 12:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgGNKDJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 06:03:09 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52010 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725906AbgGNKDJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Jul 2020 06:03:09 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06EA1wxQ128354;
        Tue, 14 Jul 2020 06:03:08 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3279k43cbp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 06:03:07 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06EA253p130665;
        Tue, 14 Jul 2020 06:03:07 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3279k43cac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 06:03:07 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06EA0kVB005630;
        Tue, 14 Jul 2020 10:03:04 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 327527u6v0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 10:03:04 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06EA32OO61800692
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 10:03:02 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 473B94C044;
        Tue, 14 Jul 2020 10:03:02 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D4C1C4C04E;
        Tue, 14 Jul 2020 10:03:01 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.7.230])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Jul 2020 10:03:01 +0000 (GMT)
Date:   Tue, 14 Jul 2020 12:02:59 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Andrew Jones <drjones@redhat.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [kvm-unit-tests PATCH] lib/alloc_page: Revert to 'unsigned
 long' for @size params
Message-ID: <20200714120259.72dce987@ibm-vm>
In-Reply-To: <db6d8b2d-147b-d732-b638-b78a3fd980d2@redhat.com>
References: <20200714042046.13419-1-sean.j.christopherson@intel.com>
        <db6d8b2d-147b-d732-b638-b78a3fd980d2@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-14_02:2020-07-13,2020-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=999 priorityscore=1501 impostorscore=0
 suspectscore=2 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007140072
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 14 Jul 2020 09:12:52 +0200
Thomas Huth <thuth@redhat.com> wrote:

> On 14/07/2020 06.20, Sean Christopherson wrote:
> > Revert to using 'unsigned long' instead of 'size_t' for
> > free_pages() and get_order().  The recent change to size_t for
> > free_pages() breaks i386 with -Werror as the assert_msg() formats
> > expect unsigned longs, whereas size_t is an 'unsigned int' on i386
> > (though both longs and ints are 4 bytes).
> > 
> > Message formatting aside, unsigned long is the correct choice given
> > the current code base as alloc_pages() and free_pages_by_order()
> > explicitly expect, work on, and/or assert on the size being an
> > unsigned long.
> > 
> > Fixes: 73f4b202beb39 ("lib/alloc_page: change some parameter types")
> > Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > Cc: Andrew Jones <drjones@redhat.com>
> > Cc: Jim Mattson <jmattson@google.com>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---  
> [...]
> > diff --git a/lib/bitops.h b/lib/bitops.h
> > index 308aa86..dd015e8 100644
> > --- a/lib/bitops.h
> > +++ b/lib/bitops.h
> > @@ -79,7 +79,7 @@ static inline bool is_power_of_2(unsigned long n)
> >  	return n && !(n & (n - 1));
> >  }
> >  
> > -static inline unsigned int get_order(size_t size)
> > +static inline unsigned int get_order(unsigned long size)
> >  {
> >  	return size ? fls(size) + !is_power_of_2(size) : 0;
> >  }
> >   
> 
> get_order() already used size_t when it was introduced in commit
> f22e527df02ffaba ... is it necessary to switch it to unsigned long
> now?
> 
> Apart from that, this patch fixes the compilation problems, indeed, I
> just checked it in the travis-CI.
> 
> Tested-by: Thomas Huth <thuth@redhat.com>

Yeah I don't think there is any reason to change get_order...

