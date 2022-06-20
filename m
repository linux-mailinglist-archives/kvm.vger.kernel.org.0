Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3CDD55150E
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 12:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240707AbiFTKBK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 06:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240668AbiFTKBJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 06:01:09 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C5612AEC;
        Mon, 20 Jun 2022 03:01:08 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25K8BBZC005951;
        Mon, 20 Jun 2022 10:00:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version : date :
 from : to : cc : subject : reply-to : in-reply-to : references :
 message-id : content-type : content-transfer-encoding; s=pp1;
 bh=qdXJT9im5QV0plqMUSLWm0Wcj6DXIK8niv/AQOm1Cs0=;
 b=ei6bMxd/ZEDAOlWMSOpCGiRZXL8FCPCN+pV6DeazIe5uRrFugd/LTO8EScJ97+fU9dIb
 7Dv45n8CS2fbwzOSwlPZXyQajBkzpi542cRS+CjQz6LjgGh/GZTDAxP/LRTG29/scmFC
 UTYGtsbDfQTva7wkZZppinpflFjRRklfCY0pgqVhdV0dZtxD+5UMW7hAw4Sfh5huPXaB
 3STtzqlfTHrNeQsXwIP1g4QbBo/jJ7gwsWliLeXkyu4El7zak1cqJggStslCdjc9ZuNQ
 ybQ5vfKg4APvpSLFsB+xefpoKbIXGkhU0teQRZBXVu+AW/dBUKWDgWYbG1b85CNMX6jc zQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gsrrrcqsf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 10:00:59 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25K9jCgn040650;
        Mon, 20 Jun 2022 10:00:58 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gsrrrcqr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 10:00:58 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25K9pepv013082;
        Mon, 20 Jun 2022 10:00:57 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03dal.us.ibm.com with ESMTP id 3gs6b97mnx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 10:00:57 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25KA0tES35717564
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jun 2022 10:00:55 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7C66F136053;
        Mon, 20 Jun 2022 10:00:55 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21EE0136061;
        Mon, 20 Jun 2022 10:00:54 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 20 Jun 2022 10:00:54 +0000 (GMT)
MIME-Version: 1.0
Date:   Mon, 20 Jun 2022 12:00:53 +0200
From:   Harald Freudenberger <freude@linux.ibm.com>
To:     Nicolin Chen <nicolinc@nvidia.com>
Cc:     kwankhede@nvidia.com, corbet@lwn.net, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com,
        borntraeger@linux.ibm.com, svens@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, tvrtko.ursulin@linux.intel.com,
        airlied@linux.ie, daniel@ffwll.ch, farman@linux.ibm.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, akrowiak@linux.ibm.com,
        jjherne@linux.ibm.com, alex.williamson@redhat.com,
        cohuck@redhat.com, jgg@nvidia.com, kevin.tian@intel.com,
        jchrist@linux.ibm.com, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: Re: [RFT][PATCH v1 1/6] vfio/ap: Pass in physical address of ind to
 ap_aqic()
Reply-To: freude@linux.ibm.com
In-Reply-To: <20220616235212.15185-2-nicolinc@nvidia.com>
References: <20220616235212.15185-1-nicolinc@nvidia.com>
 <20220616235212.15185-2-nicolinc@nvidia.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <fd564e6270a4bfcd9249559a797365ae@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gLGI1jIr9iGSdbYfRFpp2XaL_luy8a7-
X-Proofpoint-ORIG-GUID: PLdRf3ErnQsABDOyocwnsMqFxJOQY8FA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-20_05,2022-06-17_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 spamscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 impostorscore=0 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 phishscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206200044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-06-17 01:52, Nicolin Chen wrote:
> The ap_aqic() is called by vfio_ap_irq_enable() where it passes in a
> virt value that's casted from a physical address "h_nib". Inside the
> ap_aqic(), it does virt_to_phys() again.
> 
> Since ap_aqic() needs a physical address, let's just pass in a pa of
> ind directly. So change the "ind" to "pa_ind".
> 
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  arch/s390/include/asm/ap.h        | 6 +++---
>  drivers/s390/crypto/ap_queue.c    | 2 +-
>  drivers/s390/crypto/vfio_ap_ops.c | 7 ++++---
>  3 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/s390/include/asm/ap.h b/arch/s390/include/asm/ap.h
> index b515cfa62bd9..f508f5025e38 100644
> --- a/arch/s390/include/asm/ap.h
> +++ b/arch/s390/include/asm/ap.h
> @@ -227,13 +227,13 @@ struct ap_qirq_ctrl {
>   * ap_aqic(): Control interruption for a specific AP.
>   * @qid: The AP queue number
>   * @qirqctrl: struct ap_qirq_ctrl (64 bit value)
> - * @ind: The notification indicator byte
> + * @pa_ind: Physical address of the notification indicator byte
>   *
>   * Returns AP queue status.
>   */
>  static inline struct ap_queue_status ap_aqic(ap_qid_t qid,
>  					     struct ap_qirq_ctrl qirqctrl,
> -					     void *ind)
> +					     phys_addr_t pa_ind)
>  {
>  	unsigned long reg0 = qid | (3UL << 24);  /* fc 3UL is AQIC */
>  	union {
> @@ -241,7 +241,7 @@ static inline struct ap_queue_status 
> ap_aqic(ap_qid_t qid,
>  		struct ap_qirq_ctrl qirqctrl;
>  		struct ap_queue_status status;
>  	} reg1;
> -	unsigned long reg2 = virt_to_phys(ind);
> +	unsigned long reg2 = pa_ind;
> 
>  	reg1.qirqctrl = qirqctrl;
> 
> diff --git a/drivers/s390/crypto/ap_queue.c 
> b/drivers/s390/crypto/ap_queue.c
> index c48b0db824e3..a32457b4cbb8 100644
> --- a/drivers/s390/crypto/ap_queue.c
> +++ b/drivers/s390/crypto/ap_queue.c
> @@ -34,7 +34,7 @@ static int ap_queue_enable_irq(struct ap_queue *aq, 
> void *ind)
> 
>  	qirqctrl.ir = 1;
>  	qirqctrl.isc = AP_ISC;
> -	status = ap_aqic(aq->qid, qirqctrl, ind);
> +	status = ap_aqic(aq->qid, qirqctrl, virt_to_phys(ind));
>  	switch (status.response_code) {
>  	case AP_RESPONSE_NORMAL:
>  	case AP_RESPONSE_OTHERWISE_CHANGED:
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c
> b/drivers/s390/crypto/vfio_ap_ops.c
> index a7d2a95796d3..bb869b28cebd 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -154,7 +154,7 @@ static struct ap_queue_status
> vfio_ap_irq_disable(struct vfio_ap_queue *q)
>  	int retries = 5;
> 
>  	do {
> -		status = ap_aqic(q->apqn, aqic_gisa, NULL);
> +		status = ap_aqic(q->apqn, aqic_gisa, 0);
>  		switch (status.response_code) {
>  		case AP_RESPONSE_OTHERWISE_CHANGED:
>  		case AP_RESPONSE_NORMAL:
> @@ -245,7 +245,8 @@ static struct ap_queue_status
> vfio_ap_irq_enable(struct vfio_ap_queue *q,
>  	struct kvm_s390_gisa *gisa;
>  	int nisc;
>  	struct kvm *kvm;
> -	unsigned long h_nib, g_pfn, h_pfn;
> +	unsigned long g_pfn, h_pfn;
> +	phys_addr_t h_nib;
>  	int ret;
> 
>  	/* Verify that the notification indicator byte address is valid */
> @@ -290,7 +291,7 @@ static struct ap_queue_status
> vfio_ap_irq_enable(struct vfio_ap_queue *q,
>  	aqic_gisa.ir = 1;
>  	aqic_gisa.gisa = (uint64_t)gisa >> 4;
> 
> -	status = ap_aqic(q->apqn, aqic_gisa, (void *)h_nib);
> +	status = ap_aqic(q->apqn, aqic_gisa, h_nib);
>  	switch (status.response_code) {
>  	case AP_RESPONSE_NORMAL:
>  		/* See if we did clear older IRQ configuration */
Add my Reviewed-By: Harald Freudenberger <freude@linux.ibm.com>
