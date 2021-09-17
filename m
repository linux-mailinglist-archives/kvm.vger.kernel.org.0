Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC7940FAEC
	for <lists+kvm@lfdr.de>; Fri, 17 Sep 2021 16:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239195AbhIQO7I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 10:59:08 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:2948 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236034AbhIQO7H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Sep 2021 10:59:07 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18HEsirx025491;
        Fri, 17 Sep 2021 10:57:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=OPmAXWDDT6mpkYX81WXwDayugIiACXQbp3UZf0I+Mh8=;
 b=T4WYvE4gBvFy0iYpxfZFSOjbGvnu6hGkcd+1dMZWcOmENOwVlKGtR16Hj6ixSX7bUCuJ
 etcEKgoxoSG46MJnhPj7MZjXjRPD4w/J9DEgOK36J+Z2CoWT2MCwKwk8DeUeKx9k4yR0
 Mfpei5xBexe8mTCJcl3Vql0Xl09tV0AFXQQFRo7Z33+9RQLvd0c6m5V0JQDST3pbTt58
 6CT/WF6Ti0hspPB5Ogt1ltNyqbiUZ73Tt+JzeFfg7BcPddFXGpLAOQd7iRNCnqRYujIx
 uSrJloHX+XRO0oIpH1WkJq8hZ0S841z0w/C2lIDRgRw4EJ3utIw+lHcMateGF1k+vTww ZA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b4k5r6ghq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 10:57:44 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18HEt0RN026358;
        Fri, 17 Sep 2021 10:57:44 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b4k5r6gh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 10:57:44 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18HEulk5027932;
        Fri, 17 Sep 2021 14:57:42 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3b0m3adphu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 14:57:42 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18HEvcd555116064
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Sep 2021 14:57:38 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4ADB652063;
        Fri, 17 Sep 2021 14:57:38 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.1.138])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id C643E5204E;
        Fri, 17 Sep 2021 14:57:37 +0000 (GMT)
Date:   Fri, 17 Sep 2021 16:57:35 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     kvm@vger.kernel.org, cohuck@redhat.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich.Weigand@de.ibm.com,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Subject: Re: [PATCH v4 06/14] KVM: s390: pv: properly handle page flags for
 protected guests
Message-ID: <20210917165735.1e86d02b@p-imbrenda>
In-Reply-To: <35e4b7a3-42d8-6b8f-e2e7-5b6a81dfcfa3@de.ibm.com>
References: <20210818132620.46770-1-imbrenda@linux.ibm.com>
        <20210818132620.46770-7-imbrenda@linux.ibm.com>
        <1a44ff5c-f59f-2f37-2585-084294ed5e11@de.ibm.com>
        <20210906175618.4ce0323f@p-imbrenda>
        <35e4b7a3-42d8-6b8f-e2e7-5b6a81dfcfa3@de.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: KmcHDqXiD8Sl-rBswjkfDOQsNx4XgGUM
X-Proofpoint-GUID: JLssg89AUaE9N8_YjYkcfv6fdO2NH29d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-17_06,2021-09-17_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 adultscore=0 bulkscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 mlxscore=0 mlxlogscore=999 phishscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109170093
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 6 Sep 2021 18:16:10 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 06.09.21 17:56, Claudio Imbrenda wrote:
> > On Mon, 6 Sep 2021 17:46:40 +0200
> > Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> >   
> >> On 18.08.21 15:26, Claudio Imbrenda wrote:  
> >>> Introduce variants of the convert and destroy page functions that also
> >>> clear the PG_arch_1 bit used to mark them as secure pages.
> >>>
> >>> These new functions can only be called on pages for which a reference
> >>> is already being held.
> >>>
> >>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> >>> Acked-by: Janosch Frank <frankja@linux.ibm.com>  
> >>
> >> Can you refresh my mind? We do have over-indication of PG_arch_1 and this
> >> might result in spending some unneeded cycles but in the end this will be
> >> correct. Right?
> >> And this patch will fix some unnecessary places that add overindication.  
> > 
> > correct, PG_arch_1 will still overindicate, but with this patch it will
> > happen less.
> > 
> > And PG_arch_1 overindication is perfectly fine from a correctness point
> > of view.  
> 
> Maybe add something like this to the patch description then.
> 
> >>> +/*
> >>> + * The caller must already hold a reference to the page
> >>> + */
> >>> +int uv_destroy_owned_page(unsigned long paddr)
> >>> +{
> >>> +	struct page *page = phys_to_page(paddr);  
> 
> Do we have to protect against weird mappings without struct page here? I have not
> followed the discussion about this topic. Maybe Gerald knows if we can have memory
> without struct pages.

at first glance, it seems we can't have mappings without a struct page

> 
> >>> +	int rc;
> >>> +
> >>> +	get_page(page);
> >>> +	rc = uv_destroy_page(paddr);
> >>> +	if (!rc)
> >>> +		clear_bit(PG_arch_1, &page->flags);
> >>> +	put_page(page);
> >>> +	return rc;
> >>> +}
> >>> +
> >>>    /*
> >>>     * Requests the Ultravisor to encrypt a guest page and make it
> >>>     * accessible to the host for paging (export).
> >>> @@ -154,6 +170,22 @@ int uv_convert_from_secure(unsigned long paddr)
> >>>    	return 0;
> >>>    }
> >>>    
> >>> +/*
> >>> + * The caller must already hold a reference to the page
> >>> + */
> >>> +int uv_convert_owned_from_secure(unsigned long paddr)
> >>> +{
> >>> +	struct page *page = phys_to_page(paddr);  
> 
> Same here. If this is not an issue (and you add something to the patch description as
> outlined above)
> 
> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
> 
> 

