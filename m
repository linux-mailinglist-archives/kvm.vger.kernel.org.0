Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944D946EC1D
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 16:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240304AbhLIPuq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 10:50:46 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63588 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240139AbhLIPuo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 10:50:44 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B9FaHSW026478;
        Thu, 9 Dec 2021 15:47:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=G8Ca7Hw/V7biRkUk+N5XIe2++zImpgDnYLvmqxc8hnE=;
 b=EHhs5FB8dxVCAhyvfVpiudBhT5oZxXCW7r31BKuf1sox8GCBIZnR+wZ0Bqvo6lRSyhI7
 9BO4YFz6YSZAy+9ebVOXRkpcJCYS2G8RyWoIoVU3lpTeziHI3iIP6I3uySuHDG3F2IBo
 47GDvcFZVCs525HKJpxtcHVJD6D11bqHZo3HILPdnf7bK1ADFS5dg+1q4dqlLmDqakEz
 sYUtBMAhbnwNk9EtZSjWwn3n37+yRlZpxwN34EvnFN+ZIrZC0Rn2npSjw6G5F8w5DEBm
 xPl8atePTALYUUPAQsBbc/wkY/PBumLtVCC/QsW3VTaZ7NjXoWiSCLgdFqIT4WRBQRQJ Ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cujwqtwt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 15:47:10 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B9FaSHA029323;
        Thu, 9 Dec 2021 15:47:09 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cujwqtwsg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 15:47:09 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B9FjebC015618;
        Thu, 9 Dec 2021 15:47:07 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3cqyybb2s2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 15:47:07 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B9Fl3Kw24248664
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Dec 2021 15:47:03 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4760A42047;
        Thu,  9 Dec 2021 15:47:03 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6225442049;
        Thu,  9 Dec 2021 15:47:02 +0000 (GMT)
Received: from [9.171.49.66] (unknown [9.171.49.66])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Dec 2021 15:47:02 +0000 (GMT)
Message-ID: <cabce091-531a-de77-5b90-9ee1f1482da7@linux.ibm.com>
Date:   Thu, 9 Dec 2021 16:47:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 12/32] s390/pci: get SHM information from list pci
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
 <20211207205743.150299-13-mjrosato@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20211207205743.150299-13-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: HVCH-W2tim0-IJqouvBTUE473H3BpnvD
X-Proofpoint-GUID: 8YxXMetPUvrLdlvdxtgkt_B8RhfjP5e0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-09_07,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 suspectscore=0
 mlxlogscore=999 priorityscore=1501 mlxscore=0 adultscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112090084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 07.12.21 um 21:57 schrieb Matthew Rosato:
> KVM will need information on the special handle mask used to indicate
> emulated devices.  In order to obtain this, a new type of list pci call
> must be made to gather the information.  Remove the unused data pointer
> from clp_list_pci and __clp_add and instead optionally pass a pointer to
> a model-dependent-data field.  Additionally, allow for clp_list_pci calls
> that don't specify a callback - in this case, just do the first pass of
> list pci and exit.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   arch/s390/include/asm/pci.h     |  6 ++++++
>   arch/s390/include/asm/pci_clp.h |  2 +-
>   arch/s390/pci/pci.c             | 19 +++++++++++++++++++
>   arch/s390/pci/pci_clp.c         | 16 ++++++++++------
>   4 files changed, 36 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
> index 00a2c24d6d2b..86f43644756d 100644
> --- a/arch/s390/include/asm/pci.h
> +++ b/arch/s390/include/asm/pci.h
> @@ -219,12 +219,18 @@ int zpci_unregister_ioat(struct zpci_dev *, u8);
>   void zpci_remove_reserved_devices(void);
>   void zpci_update_fh(struct zpci_dev *zdev, u32 fh);
>   
> +int zpci_get_mdd(u32 *mdd);
> +
>   /* CLP */
> +void *clp_alloc_block(gfp_t gfp_mask);
> +void clp_free_block(void *ptr);
>   int clp_setup_writeback_mio(void);
>   int clp_scan_pci_devices(void);
>   int clp_query_pci_fn(struct zpci_dev *zdev);
>   int clp_enable_fh(struct zpci_dev *zdev, u32 *fh, u8 nr_dma_as);
>   int clp_disable_fh(struct zpci_dev *zdev, u32 *fh);
> +int clp_list_pci(struct clp_req_rsp_list_pci *rrb, u32 *mdd,
> +		 void (*cb)(struct clp_fh_list_entry *));
>   int clp_get_state(u32 fid, enum zpci_state *state);
>   int clp_refresh_fh(u32 fid, u32 *fh);
>   
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
> diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
> index af1c0ae017b1..175854c861cd 100644
> --- a/arch/s390/pci/pci.c
> +++ b/arch/s390/pci/pci.c
> @@ -531,6 +531,25 @@ void zpci_update_fh(struct zpci_dev *zdev, u32 fh)
>   		zpci_do_update_iomap_fh(zdev, fh);
>   }
>   
> +int zpci_get_mdd(u32 *mdd)
> +{
> +	struct clp_req_rsp_list_pci *rrb;
> +	int rc;
> +
> +	if (!mdd)
> +		return -EINVAL;
> +
> +	rrb = clp_alloc_block(GFP_KERNEL);
> +	if (!rrb)
> +		return -ENOMEM;
> +
> +	rc = clp_list_pci(rrb, mdd, NULL);
> +
> +	clp_free_block(rrb);
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(zpci_get_mdd);

Maybe move this into pci_clp.c to avoid the export of clp_alloc_block and void clp_free_block?
Niklas?
In any case the code looks correct from a HW perspective.

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>


> +
>   static struct resource *__alloc_res(struct zpci_dev *zdev, unsigned long start,
>   				    unsigned long size, unsigned long flags)
>   {
> diff --git a/arch/s390/pci/pci_clp.c b/arch/s390/pci/pci_clp.c
> index bc7446566cbc..e18a548ac22d 100644
> --- a/arch/s390/pci/pci_clp.c
> +++ b/arch/s390/pci/pci_clp.c
> @@ -84,12 +84,12 @@ static __always_inline int clp_req(void *data, unsigned int lps)
>   	return cc;
>   }
>   
> -static void *clp_alloc_block(gfp_t gfp_mask)
> +void *clp_alloc_block(gfp_t gfp_mask)
>   {
>   	return (void *) __get_free_pages(gfp_mask, get_order(CLP_BLK_SIZE));
>   }
>   
> -static void clp_free_block(void *ptr)
> +void clp_free_block(void *ptr)
>   {
>   	free_pages((unsigned long) ptr, get_order(CLP_BLK_SIZE));
>   }
> @@ -358,8 +358,8 @@ static int clp_list_pci_req(struct clp_req_rsp_list_pci *rrb,
>   	return rc;
>   }
>   
> -static int clp_list_pci(struct clp_req_rsp_list_pci *rrb, void *data,
> -			void (*cb)(struct clp_fh_list_entry *, void *))
> +int clp_list_pci(struct clp_req_rsp_list_pci *rrb, u32 *mdd,
> +		 void (*cb)(struct clp_fh_list_entry *))
>   {
>   	u64 resume_token = 0;
>   	int nentries, i, rc;
> @@ -368,8 +368,12 @@ static int clp_list_pci(struct clp_req_rsp_list_pci *rrb, void *data,
>   		rc = clp_list_pci_req(rrb, &resume_token, &nentries);
>   		if (rc)
>   			return rc;
> +		if (mdd)
> +			*mdd = rrb->response.mdd;
> +		if (!cb)
> +			return 0;
>   		for (i = 0; i < nentries; i++)
> -			cb(&rrb->response.fh_list[i], data);
> +			cb(&rrb->response.fh_list[i]);
>   	} while (resume_token);
>   
>   	return rc;
> @@ -398,7 +402,7 @@ static int clp_find_pci(struct clp_req_rsp_list_pci *rrb, u32 fid,
>   	return -ENODEV;
>   }
>   
> -static void __clp_add(struct clp_fh_list_entry *entry, void *data)
> +static void __clp_add(struct clp_fh_list_entry *entry)
>   {
>   	struct zpci_dev *zdev;
>   
> 
