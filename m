Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 804634981C3
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 15:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238782AbiAXOGm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 09:06:42 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36648 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238660AbiAXOGl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Jan 2022 09:06:41 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20OE68fw005568;
        Mon, 24 Jan 2022 14:06:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=tdtbvqPv4g1N2hZ6zbSuMnxoPUPRln7YqGOxvMovGFY=;
 b=aDnnE4VD4i8QE3UhHBjHx/m5YAy1aAlPzB1liU6gjv9WJ7UoBLvkh5st7JGyDgz0JO1w
 C15DJ7tbq0UNA4iuMSMEPeHgfD/s+gQRe5YAgJ8/3FzY/uvWHxYdUBUX28NTg41FFViE
 FFlpS4JqZbsq5W68gQVNuMZ7ZkJEZZF0FfmWZCYmZq7J9W6uXT/ko/De7YYav276hBSI
 IUzvQHOKiotEAPemIXCGLJ78UvIn+B/Sw/sWkBg5sL8NuhS8ylIInzhqxVagS9LqjOpz
 Dq6NXZOJu0Rl0pQgLhn8AI5nc5l6d6RluVkJztJrYKTqxMFjAOeXICqdtSKmCRbDJeL1 iA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dsvduhvtv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jan 2022 14:06:40 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20OE6ecA007608;
        Mon, 24 Jan 2022 14:06:40 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dsvduhvsx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jan 2022 14:06:40 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20OE3BoB025365;
        Mon, 24 Jan 2022 14:06:38 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3dr96j4an9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jan 2022 14:06:38 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20OE6W7j46858694
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jan 2022 14:06:32 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67F3052065;
        Mon, 24 Jan 2022 14:06:32 +0000 (GMT)
Received: from [9.171.67.78] (unknown [9.171.67.78])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 516955205F;
        Mon, 24 Jan 2022 14:06:31 +0000 (GMT)
Message-ID: <8bef8c96-219e-3c40-246b-b974c45a5315@linux.ibm.com>
Date:   Mon, 24 Jan 2022 15:08:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2 08/30] s390/pci: stash associated GISA designation
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
 <20220114203145.242984-9-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220114203145.242984-9-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0saFj80rLb-OvTylP6lAGZG_0aDoZlss
X-Proofpoint-ORIG-GUID: R97uy2NP1fMqMX2HuHh_VvZ-0k-lkXIt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-24_07,2022-01-24_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 mlxlogscore=999 spamscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 mlxscore=0 adultscore=0
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201240094
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/14/22 21:31, Matthew Rosato wrote:
> For passthrough devices, we will need to know the GISA designation of the
> guest if interpretation facilities are to be used.  Setup to stash this in
> the zdev and set a default of 0 (no GISA designation) for now; a subsequent
> patch will set a valid GISA designation for passthrough devices.
> Also, extend mpcific routines to specify this stashed designation as part
> of the mpcific command.
> 
> Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Reviewed-by: Eric Farman <farman@linux.ibm.com>
> Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   arch/s390/include/asm/pci.h     | 1 +
>   arch/s390/include/asm/pci_clp.h | 3 ++-
>   arch/s390/pci/pci.c             | 6 ++++++
>   arch/s390/pci/pci_clp.c         | 1 +
>   arch/s390/pci/pci_irq.c         | 5 +++++
>   5 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
> index 90824be5ce9a..2474b8d30f2a 100644
> --- a/arch/s390/include/asm/pci.h
> +++ b/arch/s390/include/asm/pci.h
> @@ -123,6 +123,7 @@ struct zpci_dev {
>   	enum zpci_state state;
>   	u32		fid;		/* function ID, used by sclp */
>   	u32		fh;		/* function handle, used by insn's */
> +	u32		gd;		/* GISA designation for passthrough */

I already gave my R-B, and do not want to remove it, but wouldn't it be 
possible to use more explicit names like gisa_designation instead of 
just gd.
It would not change anything to the functionality but would facilitate 
the maintenance?

>   	u16		vfn;		/* virtual function number */
>   	u16		pchid;		/* physical channel ID */
>   	u8		pfgid;		/* function group ID */
> diff --git a/arch/s390/include/asm/pci_clp.h b/arch/s390/include/asm/pci_clp.h
> index 1f4b666e85ee..3af8d196da74 100644
> --- a/arch/s390/include/asm/pci_clp.h
> +++ b/arch/s390/include/asm/pci_clp.h
> @@ -173,7 +173,8 @@ struct clp_req_set_pci {
>   	u16 reserved2;
>   	u8 oc;				/* operation controls */
>   	u8 ndas;			/* number of dma spaces */
> -	u64 reserved3;
> +	u32 reserved3;
> +	u32 gd;				/* GISA designation */

here too.


>   } __packed;
>   
>   /* Set PCI function response */
> diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
> index 792f8e0f2178..0c9879dae752 100644
> --- a/arch/s390/pci/pci.c
> +++ b/arch/s390/pci/pci.c
> @@ -119,6 +119,7 @@ int zpci_register_ioat(struct zpci_dev *zdev, u8 dmaas,
>   	fib.pba = base;
>   	fib.pal = limit;
>   	fib.iota = iota | ZPCI_IOTA_RTTO_FLAG;
> +	fib.gd = zdev->gd;
>   	cc = zpci_mod_fc(req, &fib, &status);
>   	if (cc)
>   		zpci_dbg(3, "reg ioat fid:%x, cc:%d, status:%d\n", zdev->fid, cc, status);
> @@ -132,6 +133,8 @@ int zpci_unregister_ioat(struct zpci_dev *zdev, u8 dmaas)
>   	struct zpci_fib fib = {0};
>   	u8 cc, status;
>   
> +	fib.gd = zdev->gd;
> +
>   	cc = zpci_mod_fc(req, &fib, &status);
>   	if (cc)
>   		zpci_dbg(3, "unreg ioat fid:%x, cc:%d, status:%d\n", zdev->fid, cc, status);
> @@ -159,6 +162,7 @@ int zpci_fmb_enable_device(struct zpci_dev *zdev)
>   	atomic64_set(&zdev->unmapped_pages, 0);
>   
>   	fib.fmb_addr = virt_to_phys(zdev->fmb);
> +	fib.gd = zdev->gd;
>   	cc = zpci_mod_fc(req, &fib, &status);
>   	if (cc) {
>   		kmem_cache_free(zdev_fmb_cache, zdev->fmb);
> @@ -177,6 +181,8 @@ int zpci_fmb_disable_device(struct zpci_dev *zdev)
>   	if (!zdev->fmb)
>   		return -EINVAL;
>   
> +	fib.gd = zdev->gd;
> +
>   	/* Function measurement is disabled if fmb address is zero */
>   	cc = zpci_mod_fc(req, &fib, &status);
>   	if (cc == 3) /* Function already gone. */
> diff --git a/arch/s390/pci/pci_clp.c b/arch/s390/pci/pci_clp.c
> index be077b39da33..e9ed0e4a5cf0 100644
> --- a/arch/s390/pci/pci_clp.c
> +++ b/arch/s390/pci/pci_clp.c
> @@ -240,6 +240,7 @@ static int clp_set_pci_fn(struct zpci_dev *zdev, u32 *fh, u8 nr_dma_as, u8 comma
>   		rrb->request.fh = zdev->fh;
>   		rrb->request.oc = command;
>   		rrb->request.ndas = nr_dma_as;
> +		rrb->request.gd = zdev->gd;
>   
>   		rc = clp_req(rrb, CLP_LPS_PCI);
>   		if (rrb->response.hdr.rsp == CLP_RC_SETPCIFN_BUSY) {
> diff --git a/arch/s390/pci/pci_irq.c b/arch/s390/pci/pci_irq.c
> index 2f675355fd0c..17e5adfe1273 100644
> --- a/arch/s390/pci/pci_irq.c
> +++ b/arch/s390/pci/pci_irq.c
> @@ -43,6 +43,7 @@ static int zpci_set_airq(struct zpci_dev *zdev)
>   	fib.fmt0.aibvo = 0;	/* each zdev has its own interrupt vector */
>   	fib.fmt0.aisb = virt_to_phys(zpci_sbv->vector) + (zdev->aisb / 64) * 8;
>   	fib.fmt0.aisbo = zdev->aisb & 63;
> +	fib.gd = zdev->gd;
>   
>   	return zpci_mod_fc(req, &fib, &status) ? -EIO : 0;
>   }
> @@ -54,6 +55,8 @@ static int zpci_clear_airq(struct zpci_dev *zdev)
>   	struct zpci_fib fib = {0};
>   	u8 cc, status;
>   
> +	fib.gd = zdev->gd;
> +
>   	cc = zpci_mod_fc(req, &fib, &status);
>   	if (cc == 3 || (cc == 1 && status == 24))
>   		/* Function already gone or IRQs already deregistered. */
> @@ -72,6 +75,7 @@ static int zpci_set_directed_irq(struct zpci_dev *zdev)
>   	fib.fmt = 1;
>   	fib.fmt1.noi = zdev->msi_nr_irqs;
>   	fib.fmt1.dibvo = zdev->msi_first_bit;
> +	fib.gd = zdev->gd;
>   
>   	return zpci_mod_fc(req, &fib, &status) ? -EIO : 0;
>   }
> @@ -84,6 +88,7 @@ static int zpci_clear_directed_irq(struct zpci_dev *zdev)
>   	u8 cc, status;
>   
>   	fib.fmt = 1;
> +	fib.gd = zdev->gd;
>   	cc = zpci_mod_fc(req, &fib, &status);
>   	if (cc == 3 || (cc == 1 && status == 24))
>   		/* Function already gone or IRQs already deregistered. */
> 

-- 
Pierre Morel
IBM Lab Boeblingen
