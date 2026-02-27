Return-Path: <kvm+bounces-72169-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6MdPHve+oWnPwAQAu9opvQ
	(envelope-from <kvm+bounces-72169-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 16:57:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E8CDB1BA69E
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 16:57:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2F952302FEB3
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 15:53:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 747FA449ED9;
	Fri, 27 Feb 2026 15:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hFyOZZ8b"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4B74418D0;
	Fri, 27 Feb 2026 15:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772207590; cv=none; b=rA/+wFb/C2uCyPM15564G3urX89taTeEPSxmxm0fXeSqAIik7PQUjKi4RXrGV78C5tm9jbRypt43+g/Hzam87xe2yb+X78ACsdQP3aBbmkuZmtC/gnZ8IiooTpaGZWeoTE8F7Z8qRMguyIff6XoexV9bEm8kbisv3z5DhsuLFRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772207590; c=relaxed/simple;
	bh=OKqwYquAXKtOqKuFZoRUW4MYZ6Jd1JIOjcINb66fDDw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jSIhYOHg99iHPoPhzPAfkqPUQb0SSvpZDasZI0I2TlzNlLVkJZkD0HNhrSOM1pF6ysruNFpHVAvsAfpLKF+paccqqSm60Rj7OA1EcRkwqOZ2g7+IkvORp+cjIb4nBUSv5yGbOhjcF3m9I9heRSyKH4R5qxjwbHArAhuwecy2WdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hFyOZZ8b; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61R8tJfZ1299140;
	Fri, 27 Feb 2026 15:53:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=C6u3vW
	R//L5vfuf3o96lImw0rTQKxc8dky5ASVYxB1U=; b=hFyOZZ8bbx3CPGiMLjzMxH
	mCWurZrCYhi3ALp0796RJT84mo2edRk9H3SpCM1silPrp4X0b4s3+YRDwZhU9Jff
	Y1yeiKMlVojrbsB6lLVcOJrDGSKEnEYGUsq5fSeIZH6/X3Is1AitcBDH+IVOScqT
	+/c+TtFTcQV030gKLLBM88fdzaDsp1FRNGGXSvy+a9V5rJUAx1g2HIBZaPd7W0bk
	8BbjrUb0Qutfmr+M/p1lJRfaCqJKv0fPwAr5un8gMmGsw2NAzDYZgED73XF0SsDe
	TaG0JdHYBD9Fnweg3fK86Kn5nYePioNP3bQhskTl4rh9f5zsMb2iAUHk/oBTSdeg
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cf4crde4p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Feb 2026 15:53:00 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61REvPMn030414;
	Fri, 27 Feb 2026 15:52:59 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cfrhkttpu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Feb 2026 15:52:59 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61RFqtV240894792
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Feb 2026 15:52:55 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1C98320040;
	Fri, 27 Feb 2026 15:52:55 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9E66B20043;
	Fri, 27 Feb 2026 15:52:54 +0000 (GMT)
Received: from [9.111.149.16] (unknown [9.111.149.16])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 27 Feb 2026 15:52:54 +0000 (GMT)
Message-ID: <5e10827b-e87e-43a6-8783-2e5d23a186e1@linux.ibm.com>
Date: Fri, 27 Feb 2026 16:52:54 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] vfio/ism: Implement vfio_pci driver for ISM
 devices
To: Julian Ruess <julianr@linux.ibm.com>, schnelle@linux.ibm.com,
        ts@linux.ibm.com, oberpar@linux.ibm.com, gbayer@linux.ibm.com,
        Alex Williamson <alex@shazbot.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum
 <skolothumtho@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>
Cc: mjrosato@linux.ibm.com, alifm@linux.ibm.com, raspl@linux.ibm.com,
        hca@linux.ibm.com, agordeev@linux.ibm.com, gor@linux.ibm.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-pci@vger.kernel.org
References: <20260224-vfio_pci_ism-v2-0-f010945373fa@linux.ibm.com>
 <20260224-vfio_pci_ism-v2-2-f010945373fa@linux.ibm.com>
Content-Language: en-US
From: Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <20260224-vfio_pci_ism-v2-2-f010945373fa@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Xmy9W0ysS5Grj_CYVN-s0vT5xCnsvFgJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI3MDE0MCBTYWx0ZWRfXwu93331gY1l+
 Ge+R+MHf8RrLkA0wMwP0QFH4YrSVPsj3tvEguYsTZDn74DcM5eiehUnp3uVCvtycAdG2St5Lck4
 XZ2etVNdwS8bZT0AwIoQcdctursR5JyQ0Pc9hlH6L6e7n9GcPg0qDHLQ4rOedl5NUHYBOgmRkR1
 4AwtTaq7SnRh1F4lzAU97MIyhwcGI5wEDLTJhy963wTuFbRGGmf4Tq4tY/OR7ZKGSKvlXx9XHQO
 Av1/OCkB/1fj7EuEMuDk2f2KVzfX0NZP0+amTS6WruTFEhkUAsAv2ytPyIzkQu1HwciREnQnBZT
 nXG2q2A7ZYR9tZ4U23hhY3JLPnmk8re1L/xk9571hGX3TAGWVabSfgdSj9raZDYSdVYTLuef1im
 E6BIcL/a2oBYowX4sYJNwrpk4WiZaQ2okGSMlNBSa59Gm3koXMmudYwZ9I4jcAFc1SRd3wE7qP1
 qlUoNIQMeUnUEUf08GA==
X-Proofpoint-GUID: Xmy9W0ysS5Grj_CYVN-s0vT5xCnsvFgJ
X-Authority-Analysis: v=2.4 cv=bbBmkePB c=1 sm=1 tr=0 ts=69a1bddc cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=_hfN8w5dKUWspHYpKrwA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-27_03,2026-02-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 adultscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 clxscore=1011 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602270140
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[20];
	TAGGED_FROM(0.00)[bounces-72169-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[wintera@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: E8CDB1BA69E
X-Rspamd-Action: no action



On 24.02.26 13:34, Julian Ruess wrote:
[...]
> diff --git a/drivers/vfio/pci/ism/main.c b/drivers/vfio/pci/ism/main.c
> new file mode 100644
> index 0000000000000000000000000000000000000000..5f9674f6dd1d44888c4e1e416d05edfd89fd09fe
> --- /dev/null
> +++ b/drivers/vfio/pci/ism/main.c
> @@ -0,0 +1,297 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * vfio-ISM driver for s390
> + *
> + * Copyright IBM Corp.
> + */
> +
> +#include "../vfio_pci_priv.h"
> +
> +#define ISM_VFIO_PCI_OFFSET_SHIFT   48
> +#define ISM_VFIO_PCI_OFFSET_TO_INDEX(off) (off >> ISM_VFIO_PCI_OFFSET_SHIFT)
> +#define ISM_VFIO_PCI_INDEX_TO_OFFSET(index) ((u64)(index) << ISM_VFIO_PCI_OFFSET_SHIFT)
> +#define ISM_VFIO_PCI_OFFSET_MASK (((u64)(1) << ISM_VFIO_PCI_OFFSET_SHIFT) - 1)
> +
> +struct ism_vfio_pci_core_device {
> +	struct vfio_pci_core_device core_device;
> +};
> +
> +static int ism_pci_open_device(struct vfio_device *core_vdev)
> +{
> +	struct ism_vfio_pci_core_device *ivdev;
> +	struct vfio_pci_core_device *vdev;


Why do you need 'struct ism_vfio_pci_core_device'?
Unlike other vfio_pci variant drivers your struct only has a single member.
I see it is used below as well, but couldn't you directly use 'struct vfio_pci_core_device'
in all places?


> +	int ret;
> +
> +	ivdev = container_of(core_vdev, struct ism_vfio_pci_core_device,
> +			     core_device.vdev);
> +	vdev = &ivdev->core_device;
> +
> +	ret = vfio_pci_core_enable(vdev);
> +	if (ret)
> +		return ret;
> +
> +	vfio_pci_core_finish_enable(vdev);
> +	return 0;
> +}
> +
> +static ssize_t ism_vfio_pci_do_io_r(struct vfio_pci_core_device *vdev,
> +				    char __user *buf, loff_t off, size_t count,
> +				    int bar)
> +{
> +	struct zpci_dev *zdev = to_zpci(vdev->pdev);
> +	ssize_t ret, done = 0;
> +	u64 req, length, tmp;
> +
> +	while (count) {
> +		if (count >= 8 && IS_ALIGNED(off, 8))
> +			length = 8;
> +		else if (count >= 4 && IS_ALIGNED(off, 4))
> +			length = 4;
> +		else if (count >= 2 && IS_ALIGNED(off, 2))
> +			length = 2;
> +		else
> +			length = 1;

As you know something like
> +		if (count >= 8 && IS_ALIGNED(off, 8)) {
> +			length = 8;
		} else {
			unsigned missing_bytes = 8 - (off % 8);
			length = min(count, missing_bytes);
		}

would suffice to fullfill the requirements for pcilg to BARs.
But your code works as well.

> +		req = ZPCI_CREATE_REQ(READ_ONCE(zdev->fh), bar, length);
> +		/* use pcilg to prevent using MIO instructions */
> +		ret = __zpci_load(&tmp, req, off);
> +		if (ret)
> +			return ret;
> +		if (copy_to_user(buf, &tmp, length))
> +			return -EFAULT;
> +		count -= length;
> +		done += length;
> +		off += length;
> +		buf += length;
> +	}
> +	return done;
> +}
> +
> +static ssize_t ism_vfio_pci_do_io_w(struct vfio_pci_core_device *vdev,
> +				    char __user *buf, loff_t off, size_t count,
> +				    int bar)
> +{
> +	struct zpci_dev *zdev = to_zpci(vdev->pdev);
> +	void *data __free(kfree) = NULL;
> +	ssize_t ret;
> +	u64 req;
> +
> +	if (count > zdev->maxstbl)
> +		return -EINVAL;

I think you also need to check for off+count not crossing 4k


> +	data = kzalloc(count, GFP_KERNEL);


Where do you free 'data' ?

> +	if (!data)
> +		return -ENOMEM;
> +	if (copy_from_user(data, buf, count))
> +		return -EFAULT;
> +	req = ZPCI_CREATE_REQ(READ_ONCE(zdev->fh), bar, count);
 > +	ret = __zpci_store_block(data, req, off);
> +	if (ret)
> +		return ret;
> +	return count;
> +}
> +

