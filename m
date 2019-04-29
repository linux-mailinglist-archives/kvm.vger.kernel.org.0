Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16544E819
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2019 18:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728829AbfD2QuM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Apr 2019 12:50:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45548 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728621AbfD2QuM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Apr 2019 12:50:12 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3TGhnxG122996
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2019 12:50:10 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2s62dh7ek4-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2019 12:50:10 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Mon, 29 Apr 2019 17:50:08 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 29 Apr 2019 17:50:05 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x3TGo4rD38994060
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Apr 2019 16:50:04 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27AF011C052;
        Mon, 29 Apr 2019 16:50:04 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AAE7611C04A;
        Mon, 29 Apr 2019 16:50:03 +0000 (GMT)
Received: from oc2783563651 (unknown [9.152.224.116])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 29 Apr 2019 16:50:03 +0000 (GMT)
Date:   Mon, 29 Apr 2019 18:50:02 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     borntraeger@de.ibm.com, alex.williamson@redhat.com,
        cohuck@redhat.com, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        frankja@linux.ibm.com, akrowiak@linux.ibm.com, david@redhat.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        freude@linux.ibm.com, mimu@linux.ibm.com
Subject: Re: [PATCH v7 3/4] s390: ap: implement PAPQ AQIC interception in
 kernel
In-Reply-To: <1556283688-556-4-git-send-email-pmorel@linux.ibm.com>
References: <1556283688-556-1-git-send-email-pmorel@linux.ibm.com>
        <1556283688-556-4-git-send-email-pmorel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19042916-4275-0000-0000-0000032F9E92
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19042916-4276-0000-0000-0000383EF4DA
Message-Id: <20190429185002.6041eecc.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-29_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=877 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904290114
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 26 Apr 2019 15:01:27 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> +static struct ap_queue_status vfio_ap_setirq(struct vfio_ap_queue *q)
> +{
> +	struct ap_qirq_ctrl aqic_gisa = {};
> +	struct ap_queue_status status = {};
> +	struct kvm_s390_gisa *gisa;
> +	struct kvm *kvm;
> +	unsigned long h_nib, h_pfn;
> +	int ret;
> +
> +	q->a_pfn = q->a_nib >> PAGE_SHIFT;
> +	ret = vfio_pin_pages(mdev_dev(q->matrix_mdev->mdev), &q->a_pfn, 1,
> +			     IOMMU_READ | IOMMU_WRITE, &h_pfn);
> +	switch (ret) {
> +	case 1:
> +		break;
> +	case -EINVAL:
> +	case -E2BIG:
> +		status.response_code = AP_RESPONSE_INVALID_ADDRESS;
> +		/* Fallthrough */
> +	default:
> +		return status;

Can we actually hit the default label? AFICT you would return an
all-zero status, i.e. status.response_code == 0 'Normal completion'.

> +	}
> +
> +	kvm = q->matrix_mdev->kvm;
> +	gisa = kvm->arch.gisa_int.origin;
> +
> +	h_nib = (h_pfn << PAGE_SHIFT) | (q->a_nib & ~PAGE_MASK);
> +	aqic_gisa.gisc = q->a_isc;
> +	aqic_gisa.isc = kvm_s390_gisc_register(kvm, q->a_isc);
> +	aqic_gisa.ir = 1;
> +	aqic_gisa.gisa = gisa->next_alert >> 4;

Why gisa->next_alert? Isn't this supposed to get set to gisa origin
(without some bits on the left)?

> +
> +	status = ap_aqic(q->apqn, aqic_gisa, (void *)h_nib);
> +	switch (status.response_code) {
> +	case AP_RESPONSE_NORMAL:
> +		/* See if we did clear older IRQ configuration */
> +		if (q->p_pfn)
> +			vfio_unpin_pages(mdev_dev(q->matrix_mdev->mdev),
> +					 &q->p_pfn, 1);
> +		if (q->p_isc != VFIO_AP_ISC_INVALID)
> +			kvm_s390_gisc_unregister(kvm, q->p_isc);
> +		q->p_pfn = q->a_pfn;
> +		q->p_isc = q->a_isc;
> +		break;
> +	case AP_RESPONSE_OTHERWISE_CHANGED:
> +		/* We could not modify IRQ setings: clear new configuration */
> +		vfio_unpin_pages(mdev_dev(q->matrix_mdev->mdev), &q->a_pfn, 1);
> +		kvm_s390_gisc_unregister(kvm, q->a_isc);

Hm, see below. Wouldn't you want to set a_isc to VFIO_AP_ISC_INVALID?

> +		break;
> +	default:	/* Fall Through */

Is it 'break' or is it 'Fall Through'?

> +		pr_warn("%s: apqn %04x: response: %02x\n", __func__, q->apqn,
> +			status.response_code);
> +		vfio_ap_free_irq_data(q);
> +		break;
> +	}
> +
> +	return status;
> +}

