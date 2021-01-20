Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 119E32FD606
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 17:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403986AbhATQtb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 11:49:31 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34646 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2403876AbhATQtJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Jan 2021 11:49:09 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10KGWL5s121674;
        Wed, 20 Jan 2021 11:48:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=csN/CdyzcdGuEtt9nvmOA/P8K9vfo2K7PctKFnuFUt4=;
 b=PudQP0cjncI8w2GhWKmKYch8Up/fj1DmtBUqSXqdX3YPFaStNTl7vMLSq958x+2ZX//R
 x6knP5uw/xAjgDzyKPzZtZ8ztzgGC4l1B5Ma2QLJBxpQW3CV8FCMR7jXJlymWE2qNvbx
 yVymXN8zFDbULAAxeJqE6pj++fadT8qi5EPhDc37Fh4Opt7ROCWc1ua8PFDsL2GlOjtw
 bJ1q/lkIYMynq2IFCgd9HGg0/VcLgmctOObWyLZlun00fI0TVD0fNqUcImxw6qeYfBJk
 2ouRmYbdo4x2iEzyYbgxvPSF0VTkYZZT/t6gYcpk3nPuQq17rESoM80zE7uwJJPCgy6H aQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 366q88amaq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 11:48:17 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10KGXlWc134296;
        Wed, 20 Jan 2021 11:48:17 -0500
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 366q88am9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 11:48:17 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10KGdP8w009705;
        Wed, 20 Jan 2021 16:48:14 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3668p4gebf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 16:48:14 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10KGmBVM44433832
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jan 2021 16:48:11 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D8AC42042;
        Wed, 20 Jan 2021 16:48:11 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF41842041;
        Wed, 20 Jan 2021 16:48:10 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.4.167])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 20 Jan 2021 16:48:10 +0000 (GMT)
Date:   Wed, 20 Jan 2021 17:48:09 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, drjones@redhat.com,
        pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 1/3] s390x: pv: implement routine to
 share/unshare memory
Message-ID: <20210120174809.64bb8e4d@ibm-vm>
In-Reply-To: <211a4bd3-763a-f8fc-3c08-8d8d1809cc7c@redhat.com>
References: <1611085944-21609-1-git-send-email-pmorel@linux.ibm.com>
        <1611085944-21609-2-git-send-email-pmorel@linux.ibm.com>
        <211a4bd3-763a-f8fc-3c08-8d8d1809cc7c@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-20_06:2021-01-20,2021-01-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 adultscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101200094
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 20 Jan 2021 11:48:52 +0100
Thomas Huth <thuth@redhat.com> wrote:


[...]

> > +/*
> > + * Guest 2 request to the Ultravisor to make a page shared with the
> > + * hypervisor for IO.
> > + *
> > + * @addr: Real or absolute address of the page to be shared  
> 
> When is it real, and when is it absolute?

as far as we are concerned, it's unpredictable

this means that a guest should avoid sharing any prefix (or
reverse prefix) pages.

> > + */
> > +static inline int uv_set_shared(unsigned long addr)
> > +{
> > +	return share(addr, UVC_CMD_SET_SHARED_ACCESS);
> > +}
> > +
> > +/*
> > + * Guest 2 request to the Ultravisor to make a page unshared.
> > + *
> > + * @addr: Real or absolute address of the page to be unshared  
> 
> dito

same

> > + */
> > +static inline int uv_remove_shared(unsigned long addr)
> > +{
> > +	return share(addr, UVC_CMD_REMOVE_SHARED_ACCESS);
> > +}
> > +
> >   #endif  
> 
> Apart from the nits:
> Acked-by: Thomas Huth <thuth@redhat.com>
> 

