Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 465A64923D7
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 11:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237508AbiARKec (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 05:34:32 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24488 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235295AbiARKea (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 05:34:30 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20I9lErX009136;
        Tue, 18 Jan 2022 10:34:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=tSVwhv6KvUgFZFcqMpFQL3G61shedVfXckl5g8U2Gaw=;
 b=IY4iG4OBkUPj4Kd70rejwH55WxzmqgLH9yVCml/orDfpzbL59TaZCI6f+L50kijHhgfF
 wP8lwjyb+kUoVRnpZLURGvwSWsg+6P1kR41J/Q90Eg5lz2n4hGlyLLYWpOJANoDj44Us
 9UftFknGFCU6dQ+pMCHfQhGNJ5h2N+w1PNgJHqBp2WRqUkO9NbDTD/7mRX57gjKyM++L
 KKTB6/arIeMyjPJYlx1m9LhUKc42kQF1wMLIV7s6GW5wApSiFPwN//SgVZeKX93+XP0m
 BjBmSlzmT1uOo/UQaV+0RK6AAZ3wik9F80z7dEkMFmo6F0FqbFm6tS+TrXytPSPm+hqE hQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dngcqdm7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 10:34:29 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20IALe0d031956;
        Tue, 18 Jan 2022 10:34:29 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dngcqdm78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 10:34:29 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20IAHdWe027532;
        Tue, 18 Jan 2022 10:34:27 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3dknhjb23q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 10:34:27 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20IAYOID48169310
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 10:34:24 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 696CEAE061;
        Tue, 18 Jan 2022 10:34:24 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6495EAE07D;
        Tue, 18 Jan 2022 10:34:23 +0000 (GMT)
Received: from [9.171.70.230] (unknown [9.171.70.230])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 10:34:23 +0000 (GMT)
Message-ID: <a0fbd50c-bfa4-5f62-6dea-18b85562fff6@linux.ibm.com>
Date:   Tue, 18 Jan 2022 11:36:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2 12/30] s390/pci: get SHM information from list pci
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
 <20220114203145.242984-13-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220114203145.242984-13-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: iSZpcFo1SgaMBMGB2mkIrH4JRsBkWD2Y
X-Proofpoint-ORIG-GUID: o8EdmgbNPgyFWcePUSoV9Ib0nyJlA8om
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_02,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 lowpriorityscore=0
 suspectscore=0 spamscore=0 impostorscore=0 clxscore=1015 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180064
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/14/22 21:31, Matthew Rosato wrote:
> KVM will need information on the special handle mask used to indicate
> emulated devices.  In order to obtain this, a new type of list pci call
> must be made to gather the information.  Extend clp_list_pci_req to
> also fetch the model-dependent-data field that holds this mask.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   arch/s390/include/asm/pci.h     |  1 +
>   arch/s390/include/asm/pci_clp.h |  2 +-
>   arch/s390/pci/pci_clp.c         | 28 +++++++++++++++++++++++++---
>   3 files changed, 27 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
> index 00a2c24d6d2b..f3cd2da8128c 100644
> --- a/arch/s390/include/asm/pci.h
> +++ b/arch/s390/include/asm/pci.h
> @@ -227,6 +227,7 @@ int clp_enable_fh(struct zpci_dev *zdev, u32 *fh, u8 nr_dma_as);
>   int clp_disable_fh(struct zpci_dev *zdev, u32 *fh);
>   int clp_get_state(u32 fid, enum zpci_state *state);
>   int clp_refresh_fh(u32 fid, u32 *fh);
> +int zpci_get_mdd(u32 *mdd);
>   
>   /* UID */
>   void update_uid_checking(bool new);
> diff --git a/arch/s390/include/asm/pci_clp.h b/arch/s390/include/asm/pci_clp.h
> index 124fadfb74b9..d6bc324763f3 100644
> --- a/arch/s390/include/asm/pci_clp.h
> +++ b/arch/s390/include/asm/pci_clp.h
> @@ -76,7 +76,7 @@ struct clp_req_list_pci {
>   struct clp_rsp_list_pci {
>   	struct clp_rsp_hdr hdr;
>   	u64 resume_token;
> -	u32 reserved2;
> +	u32 mdd;
>   	u16 max_fn;
>   	u8			: 7;
>   	u8 uid_checking		: 1;
> diff --git a/arch/s390/pci/pci_clp.c b/arch/s390/pci/pci_clp.c
> index bc7446566cbc..308ffb93413f 100644
> --- a/arch/s390/pci/pci_clp.c
> +++ b/arch/s390/pci/pci_clp.c
> @@ -328,7 +328,7 @@ int clp_disable_fh(struct zpci_dev *zdev, u32 *fh)
>   }
>   
>   static int clp_list_pci_req(struct clp_req_rsp_list_pci *rrb,
> -			    u64 *resume_token, int *nentries)
> +			    u64 *resume_token, int *nentries, u32 *mdd)
>   {
>   	int rc;
>   
> @@ -354,6 +354,8 @@ static int clp_list_pci_req(struct clp_req_rsp_list_pci *rrb,
>   	*nentries = (rrb->response.hdr.len - LIST_PCI_HDR_LEN) /
>   		rrb->response.entry_size;
>   	*resume_token = rrb->response.resume_token;
> +	if (mdd)
> +		*mdd = rrb->response.mdd;
>   
>   	return rc;
>   }
> @@ -365,7 +367,7 @@ static int clp_list_pci(struct clp_req_rsp_list_pci *rrb, void *data,
>   	int nentries, i, rc;
>   
>   	do {
> -		rc = clp_list_pci_req(rrb, &resume_token, &nentries);
> +		rc = clp_list_pci_req(rrb, &resume_token, &nentries, NULL);
>   		if (rc)
>   			return rc;
>   		for (i = 0; i < nentries; i++)
> @@ -383,7 +385,7 @@ static int clp_find_pci(struct clp_req_rsp_list_pci *rrb, u32 fid,
>   	int nentries, i, rc;
>   
>   	do {
> -		rc = clp_list_pci_req(rrb, &resume_token, &nentries);
> +		rc = clp_list_pci_req(rrb, &resume_token, &nentries, NULL);
>   		if (rc)
>   			return rc;
>   		fh_list = rrb->response.fh_list;
> @@ -468,6 +470,26 @@ int clp_get_state(u32 fid, enum zpci_state *state)
>   	return rc;
>   }
>   
> +int zpci_get_mdd(u32 *mdd)
> +{
> +	struct clp_req_rsp_list_pci *rrb;
> +	u64 resume_token = 0;
> +	int nentries, rc;
> +
> +	if (!mdd)
> +		return -EINVAL;

I think this tests is not useful.
The caller must take care not to call with a NULL pointer,
what the only caller today make sure.


> +
> +	rrb = clp_alloc_block(GFP_KERNEL);
> +	if (!rrb)
> +		return -ENOMEM;
> +
> +	rc = clp_list_pci_req(rrb, &resume_token, &nentries, mdd);
> +
> +	clp_free_block(rrb);
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(zpci_get_mdd);
> +
>   static int clp_base_slpc(struct clp_req *req, struct clp_req_rsp_slpc *lpcb)
>   {
>   	unsigned long limit = PAGE_SIZE - sizeof(lpcb->request);
> 

-- 
Pierre Morel
IBM Lab Boeblingen
