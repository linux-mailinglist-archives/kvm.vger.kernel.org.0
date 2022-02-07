Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97AE44AB896
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 11:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241707AbiBGKQ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 05:16:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352694AbiBGKGW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 05:06:22 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0663CC043181;
        Mon,  7 Feb 2022 02:06:21 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2177oU7u008056;
        Mon, 7 Feb 2022 10:06:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=1FY6QZ6AyYWPw6itCdOhO0U4ydXl/PtDArPK4sLgVOQ=;
 b=qEg74JSy+TX7At9xGRfCZA4BnJdoGDDhenYlVTEyTSTSliProWmLm+ZYwduIUtV2G9vw
 cYo71XkqbfnU37US9IpzgURNU7AuIM6dnAVcXO9Rwm9vtG5MYopouRybBRCi7K+EUoyI
 OnPLA87YJXwN11eiIvPJr1/ad4Mrkhbx0mBHX0uGGg8sxBCEMUORsosid3l8boKBFlFp
 1K/WBJmDid8Tb3UsMR0yo98s3j417tmyfFtindqd28Xvgu9Lji82VTf2c8NmVVwdBRAU
 zHc4TxMKgpAGLDubfhXtM54SG/zxnO3wdNBdnIfPpHhT6GWkbHLwghFXcmsGB7NtGjgJ +w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e22vkftmd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 10:06:21 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2179qYHb000460;
        Mon, 7 Feb 2022 10:06:20 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e22vkftm1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 10:06:20 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 217A2d5P018193;
        Mon, 7 Feb 2022 10:06:18 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3e1gv921yy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 10:06:18 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2179uCYv45810110
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Feb 2022 09:56:12 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3528CAE045;
        Mon,  7 Feb 2022 10:06:15 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3DFCBAE04D;
        Mon,  7 Feb 2022 10:06:14 +0000 (GMT)
Received: from [9.171.30.247] (unknown [9.171.30.247])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Feb 2022 10:06:14 +0000 (GMT)
Message-ID: <865145fd-026c-89f0-3b3b-1a3eb2ccf333@linux.ibm.com>
Date:   Mon, 7 Feb 2022 11:08:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v3 12/30] s390/pci: get SHM information from list pci
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
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
 <20220204211536.321475-13-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220204211536.321475-13-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _NBNv3WmjxPLFM2Msjv2Y-1aFl2rumf4
X-Proofpoint-ORIG-GUID: QUmS8NPxz9WH19hd5HRXSBs4dquqdRsD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_03,2022-02-07_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 mlxscore=0 impostorscore=0 phishscore=0 suspectscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202070065
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/4/22 22:15, Matthew Rosato wrote:
> KVM will need information on the special handle mask used to indicate
> emulated devices.  In order to obtain this, a new type of list pci call
> must be made to gather the information.  Extend clp_list_pci_req to
> also fetch the model-dependent-data field that holds this mask.
> 
> Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   arch/s390/include/asm/pci.h     |  1 +
>   arch/s390/include/asm/pci_clp.h |  2 +-
>   arch/s390/pci/pci_clp.c         | 25 ++++++++++++++++++++++---
>   3 files changed, 24 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
> index 3c0b9986dcdc..e8a3fd5bc169 100644
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
> index d6189ed14f84..dc2041e97de4 100644
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
> index dc733b58e74f..7477956be632 100644
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

mdd is a central value for ZPCI like zpci_unique_uid, I think both 
should be treated the same, i.e. belong to a central ZPCI structure or 
as today with zpci_unique_uid be global.
An aventage of the design is that the clp_list_pci_req signature does 
not need to be modified and we do not need extra clp call.

However I come here late with this demand so I guess this simplification 
can be done later.

Acked-by: Pierre Morel <pmorel@linux.ibm.com>


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
> @@ -468,6 +470,23 @@ int clp_get_state(u32 fid, enum zpci_state *state)
>   	return rc;
>   }
>   
> +int zpci_get_mdd(u32 *mdd)
> +{
> +	struct clp_req_rsp_list_pci *rrb;
> +	u64 resume_token = 0;
> +	int nentries, rc;
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
