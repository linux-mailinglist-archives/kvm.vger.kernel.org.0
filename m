Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45739161453
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 15:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728375AbgBQOPW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 09:15:22 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:26362 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726760AbgBQOPW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Feb 2020 09:15:22 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01HEFFwp109493
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2020 09:15:20 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y6dh3yxa5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2020 09:15:20 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <uweigand@de.ibm.com>;
        Mon, 17 Feb 2020 14:15:18 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 17 Feb 2020 14:15:13 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01HEFCEs4915318
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Feb 2020 14:15:12 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45DB74C076;
        Mon, 17 Feb 2020 14:15:12 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 331A54C06F;
        Mon, 17 Feb 2020 14:15:12 +0000 (GMT)
Received: from oc3748833570.ibm.com (unknown [9.152.214.26])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Feb 2020 14:15:12 +0000 (GMT)
Received: by oc3748833570.ibm.com (Postfix, from userid 1000)
        id F3736D802EA; Mon, 17 Feb 2020 15:15:11 +0100 (CET)
Date:   Mon, 17 Feb 2020 15:15:11 +0100
From:   Ulrich Weigand <uweigand@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        Will Deacon <will@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v2 40/42] example for future extension: mm:gup/writeback:
 add callbacks for inaccessible pages: source indication
References: <20200214222658.12946-1-borntraeger@de.ibm.com>
 <20200214222658.12946-41-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214222658.12946-41-borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 20021714-0020-0000-0000-000003AAF3BB
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021714-0021-0000-0000-00002202EB10
Message-Id: <20200217141511.GA14704@oc3748833570.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-17_08:2020-02-17,2020-02-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 phishscore=0 adultscore=0
 mlxlogscore=682 clxscore=1015 malwarescore=0 lowpriorityscore=0
 impostorscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2002170118
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 14, 2020 at 05:26:56PM -0500, Christian Borntraeger wrote:
> +enum access_type {
> +	MAKE_ACCESSIBLE_GENERIC,
> +	MAKE_ACCESSIBLE_GET,
> +	MAKE_ACCESSIBLE_GET_FAST,
> +	MAKE_ACCESSIBLE_WRITEBACK
> +};
>  #ifndef HAVE_ARCH_MAKE_PAGE_ACCESSIBLE
> -static inline int arch_make_page_accessible(struct page *page)
> +static inline int arch_make_page_accessible(struct page *page, int where)

If we want to make this distinction, wouldn't it be simpler to just
use different function names, like
  arch_make_page_accessible_for_writeback
  arch_make_page_accessible_for_gup
etc.

Bye,
Ulrich

-- 
  Dr. Ulrich Weigand
  GNU/Linux compilers and toolchain
  Ulrich.Weigand@de.ibm.com

