Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD7549C72E
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 11:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239714AbiAZKNK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 05:13:10 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44814 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239696AbiAZKNK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Jan 2022 05:13:10 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20Q9BeuI021032;
        Wed, 26 Jan 2022 10:13:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=fr03d1QtoSV4P1iKf8EIoNKIGMqI22svBljx88QhQGQ=;
 b=llF1PfRgNTuHCDMAhYObA4eXtqdTBSqhbF0CUUlkZWbfMU1KvqT8dmKxRDiBrnFBcrds
 ZmIcVqUz5abnrLAUjSmPZLCoFN9scT9lSCgdbBD4fl/J8yrZ25BxehUX9Lxl0iXtUDtw
 HjJKm6i+DG/FPx0VNenRTa36WY5SjalOGYyXc+BxSMh05Szxk6G/Z0SzkuLr+32eSYnw
 oJ//7yvZ/IcDh/cd60SmvgIs7O1PyhB8W64pQgz9G/yMC8gVxgul3iOB1sX8zTOhKqNn
 h7Feb+WiyK7vHRwGPLSPphquTjvBSVQQ6yUGPMY/mEpuXESrqhqTKA3VnjvrdGUegyv0 vA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3du3evh412-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jan 2022 10:13:09 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20Q9SAtQ005155;
        Wed, 26 Jan 2022 10:13:08 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3du3evh40h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jan 2022 10:13:08 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20QACEoS016113;
        Wed, 26 Jan 2022 10:13:07 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3dr9j9k9es-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jan 2022 10:13:06 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20QAD3cm42795296
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jan 2022 10:13:03 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 89C4011C04A;
        Wed, 26 Jan 2022 10:13:03 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7314811C05B;
        Wed, 26 Jan 2022 10:13:02 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.7.24])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 Jan 2022 10:13:02 +0000 (GMT)
Date:   Wed, 26 Jan 2022 11:13:00 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        linux-s390@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, schnelle@linux.ibm.com, farman@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 12/30] s390/pci: get SHM information from list pci
Message-ID: <20220126111300.1084623e@p-imbrenda>
In-Reply-To: <a0fbd50c-bfa4-5f62-6dea-18b85562fff6@linux.ibm.com>
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
        <20220114203145.242984-13-mjrosato@linux.ibm.com>
        <a0fbd50c-bfa4-5f62-6dea-18b85562fff6@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OSDI8uQpHJD909NtC4dsJHFWgdSUtxq8
X-Proofpoint-ORIG-GUID: ftFiqgApH0nzUQ6LFlpTUwctlrBe3NFW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-26_02,2022-01-26_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 suspectscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2201260055
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 Jan 2022 11:36:06 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 1/14/22 21:31, Matthew Rosato wrote:
> > KVM will need information on the special handle mask used to indicate
> > emulated devices.  In order to obtain this, a new type of list pci call
> > must be made to gather the information.  Extend clp_list_pci_req to
> > also fetch the model-dependent-data field that holds this mask.
> > 
> > Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > ---
> >   arch/s390/include/asm/pci.h     |  1 +
> >   arch/s390/include/asm/pci_clp.h |  2 +-
> >   arch/s390/pci/pci_clp.c         | 28 +++++++++++++++++++++++++---
> >   3 files changed, 27 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
> > index 00a2c24d6d2b..f3cd2da8128c 100644
> > --- a/arch/s390/include/asm/pci.h
> > +++ b/arch/s390/include/asm/pci.h
> > @@ -227,6 +227,7 @@ int clp_enable_fh(struct zpci_dev *zdev, u32 *fh, u8 nr_dma_as);
> >   int clp_disable_fh(struct zpci_dev *zdev, u32 *fh);
> >   int clp_get_state(u32 fid, enum zpci_state *state);
> >   int clp_refresh_fh(u32 fid, u32 *fh);
> > +int zpci_get_mdd(u32 *mdd);
> >   
> >   /* UID */
> >   void update_uid_checking(bool new);
> > diff --git a/arch/s390/include/asm/pci_clp.h b/arch/s390/include/asm/pci_clp.h
> > index 124fadfb74b9..d6bc324763f3 100644
> > --- a/arch/s390/include/asm/pci_clp.h
> > +++ b/arch/s390/include/asm/pci_clp.h
> > @@ -76,7 +76,7 @@ struct clp_req_list_pci {
> >   struct clp_rsp_list_pci {
> >   	struct clp_rsp_hdr hdr;
> >   	u64 resume_token;
> > -	u32 reserved2;
> > +	u32 mdd;
> >   	u16 max_fn;
> >   	u8			: 7;
> >   	u8 uid_checking		: 1;
> > diff --git a/arch/s390/pci/pci_clp.c b/arch/s390/pci/pci_clp.c
> > index bc7446566cbc..308ffb93413f 100644
> > --- a/arch/s390/pci/pci_clp.c
> > +++ b/arch/s390/pci/pci_clp.c
> > @@ -328,7 +328,7 @@ int clp_disable_fh(struct zpci_dev *zdev, u32 *fh)
> >   }
> >   
> >   static int clp_list_pci_req(struct clp_req_rsp_list_pci *rrb,
> > -			    u64 *resume_token, int *nentries)
> > +			    u64 *resume_token, int *nentries, u32 *mdd)
> >   {
> >   	int rc;
> >   
> > @@ -354,6 +354,8 @@ static int clp_list_pci_req(struct clp_req_rsp_list_pci *rrb,
> >   	*nentries = (rrb->response.hdr.len - LIST_PCI_HDR_LEN) /
> >   		rrb->response.entry_size;
> >   	*resume_token = rrb->response.resume_token;
> > +	if (mdd)
> > +		*mdd = rrb->response.mdd;
> >   
> >   	return rc;
> >   }
> > @@ -365,7 +367,7 @@ static int clp_list_pci(struct clp_req_rsp_list_pci *rrb, void *data,
> >   	int nentries, i, rc;
> >   
> >   	do {
> > -		rc = clp_list_pci_req(rrb, &resume_token, &nentries);
> > +		rc = clp_list_pci_req(rrb, &resume_token, &nentries, NULL);
> >   		if (rc)
> >   			return rc;
> >   		for (i = 0; i < nentries; i++)
> > @@ -383,7 +385,7 @@ static int clp_find_pci(struct clp_req_rsp_list_pci *rrb, u32 fid,
> >   	int nentries, i, rc;
> >   
> >   	do {
> > -		rc = clp_list_pci_req(rrb, &resume_token, &nentries);
> > +		rc = clp_list_pci_req(rrb, &resume_token, &nentries, NULL);
> >   		if (rc)
> >   			return rc;
> >   		fh_list = rrb->response.fh_list;
> > @@ -468,6 +470,26 @@ int clp_get_state(u32 fid, enum zpci_state *state)
> >   	return rc;
> >   }
> >   
> > +int zpci_get_mdd(u32 *mdd)
> > +{
> > +	struct clp_req_rsp_list_pci *rrb;
> > +	u64 resume_token = 0;
> > +	int nentries, rc;
> > +
> > +	if (!mdd)
> > +		return -EINVAL;  
> 
> I think this tests is not useful.
> The caller must take care not to call with a NULL pointer,
> what the only caller today make sure.

what if the caller does it anyway?

I think the test is useful. if passing NULL is a bug, then maybe
consider using BUG_ON, or WARN_ONCE

> 
> 
> > +
> > +	rrb = clp_alloc_block(GFP_KERNEL);
> > +	if (!rrb)
> > +		return -ENOMEM;
> > +
> > +	rc = clp_list_pci_req(rrb, &resume_token, &nentries, mdd);
> > +
> > +	clp_free_block(rrb);
> > +	return rc;
> > +}
> > +EXPORT_SYMBOL_GPL(zpci_get_mdd);
> > +
> >   static int clp_base_slpc(struct clp_req *req, struct clp_req_rsp_slpc *lpcb)
> >   {
> >   	unsigned long limit = PAGE_SIZE - sizeof(lpcb->request);
> >   
> 

