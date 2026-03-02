Return-Path: <kvm+bounces-72361-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ACJRN0eApWl1CgYAu9opvQ
	(envelope-from <kvm+bounces-72361-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 13:19:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 62B761D82C0
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 13:19:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 89052303049C
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 12:19:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB02C36C9CC;
	Mon,  2 Mar 2026 12:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="r57jjUwy"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2BB36C5A1;
	Mon,  2 Mar 2026 12:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772453943; cv=none; b=h0BsbHsGMv4nNTt6fgNcpTLjB1JpnTXACmiSCaVU1q5q2ItxNr4UyUFWUm7W8oxoByg9mLLy0ikCYcIL4eyesZyREdrMdPc3OU8U2bwJrWktqco8twXCf6SikUvG/3LwcI/1+3OGHoMSKxGZ6jSLkS15G0UVjNNICadtlCHs6Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772453943; c=relaxed/simple;
	bh=bcrjr1d6fD8bBnwj113X9LyIuLKYHv/X4T7ncxtiUuE=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=GEP9gvEEb0KVv5BewtocM6SUzeCvhtRvB9iHlkiQpeJBBGf5wqEdqGhTSOFIB9ddurFolWnjVqoPxiyfWQJTOL+e2uO/VwOfKB6hFaD8L4Vlqr6FWMrND4nnPDCB4bA4hCJYoeXrLfkLGn17Q8nU4yJ40cBdumcJJsNziF+WGCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=r57jjUwy; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 621KjCEi1884906;
	Mon, 2 Mar 2026 12:18:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=r3fDwR
	A5ezyOmF4FNQu28ms0n57mCjbDDtVqzyuVZ5M=; b=r57jjUwyObiu+VXOHpnlIZ
	lHmoRkJJnocjCgbAuJG4mDtGp58jork8dm/xSMW3foQH4M9O2okrKWlQZbYYZsXl
	7LG69l4xDVY0++wNIb++U1UyxqMH3ZAaSjG1JnMvgDgKact8XTIMcvMLkKYl2fC/
	J7yCoK2P5SxYcFbSDmbpjqsvp3/QWBzKR71tFsazz+G8Q5na5IcaF2uxMmwGzv6h
	vUwqCkoG9ZDtPrMJodDqLtk0c1y368bB6UqZa1BBlbQCDpOElh4sZzs0P9L/U8xG
	0YwyeUrJJuvJQGIrY6N5laPYVzqdOLLnK8W22dBMIaz/kNJA+5zc1JRPOjrwx3PQ
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ckskcpf9y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Mar 2026 12:18:57 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 6229BRe9003284;
	Mon, 2 Mar 2026 12:18:56 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cmb2xx2ck-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Mar 2026 12:18:55 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 622CIpMQ44630434
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 Mar 2026 12:18:51 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C998620043;
	Mon,  2 Mar 2026 12:18:51 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7D4732004B;
	Mon,  2 Mar 2026 12:18:51 +0000 (GMT)
Received: from localhost (unknown [9.52.203.172])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  2 Mar 2026 12:18:51 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 02 Mar 2026 13:18:51 +0100
Message-Id: <DGSAHB6FS2D4.1KN7KTIF0EWE5@linux.ibm.com>
From: "Julian Ruess" <julianr@linux.ibm.com>
To: "Alexandra Winter" <wintera@linux.ibm.com>,
        "Julian Ruess"
 <julianr@linux.ibm.com>, <schnelle@linux.ibm.com>,
        <ts@linux.ibm.com>, <oberpar@linux.ibm.com>, <gbayer@linux.ibm.com>,
        "Alex Williamson"
 <alex@shazbot.org>,
        "Jason Gunthorpe" <jgg@ziepe.ca>, "Yishai Hadas"
 <yishaih@nvidia.com>,
        "Shameer Kolothum" <skolothumtho@nvidia.com>,
        "Kevin
 Tian" <kevin.tian@intel.com>
Cc: <mjrosato@linux.ibm.com>, <alifm@linux.ibm.com>, <raspl@linux.ibm.com>,
        <hca@linux.ibm.com>, <agordeev@linux.ibm.com>, <gor@linux.ibm.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-s390@vger.kernel.org>, <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] vfio/ism: Implement vfio_pci driver for ISM
 devices
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260224-vfio_pci_ism-v2-0-f010945373fa@linux.ibm.com>
 <20260224-vfio_pci_ism-v2-2-f010945373fa@linux.ibm.com>
 <5e10827b-e87e-43a6-8783-2e5d23a186e1@linux.ibm.com>
In-Reply-To: <5e10827b-e87e-43a6-8783-2e5d23a186e1@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fyH1UyPGuqZQtvPrHQHVDorJEVQgoUYQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDEwMSBTYWx0ZWRfX8wVefU8Vwgqu
 fuiVbb3SN6uiHDnsE0E3ZUzfcX3gJGFy0vcRx7fgWnZSM5yygU5GB5WrBHaYK1wtWcBXMtfyyEn
 H5hlj/4Qr1iW+uK8nVgTFwAPpox/6mcV8trDpDguw5U09eAt3HunH33bAUudhmHCAa1oyxSGj2F
 Zxu9OqYnkdj65YR1qmTe6UpagHVRwDm9dXH/o1WvymBYoByIlNg4cMN1lo/9yxCJpbvxJAAH+aY
 WycvC/StSP7WRvP81h2Iyd5wxoi4OugGMttPc1dJJ8GDiEzhgAlC8a8/4XcGkcGKGkBZriiCuwk
 P/vEj86EO11rQfcopv/sjGwYPD8ZcWKGeIucpxVKQd50vPjlcQSziMmJ9sOEESmjeNa7M+NGZ4X
 1NR0f+Pci/VrRsWR/CanYNZeQiHTcpJdrlJuanqgmsCG0h1DHV/nm78qMcEl5EyOI1z2ZbFBIxt
 2c+8KYJnZ33uFuGKREg==
X-Authority-Analysis: v=2.4 cv=H7DWAuYi c=1 sm=1 tr=0 ts=69a58031 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=rE24V_v0tVX_uz8SPO8A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: fyH1UyPGuqZQtvPrHQHVDorJEVQgoUYQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603020101
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72361-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[ibm.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[julianr@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 62B761D82C0
X-Rspamd-Action: no action

On Fri Feb 27, 2026 at 4:52 PM CET, Alexandra Winter wrote:
>
>
> On 24.02.26 13:34, Julian Ruess wrote:
> [...]
>> diff --git a/drivers/vfio/pci/ism/main.c b/drivers/vfio/pci/ism/main.c
>> new file mode 100644
>> index 0000000000000000000000000000000000000000..5f9674f6dd1d44888c4e1e41=
6d05edfd89fd09fe
>> --- /dev/null
>> +++ b/drivers/vfio/pci/ism/main.c
>> @@ -0,0 +1,297 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * vfio-ISM driver for s390
>> + *
>> + * Copyright IBM Corp.
>> + */
>> +
>> +#include "../vfio_pci_priv.h"
>> +
>> +#define ISM_VFIO_PCI_OFFSET_SHIFT   48
>> +#define ISM_VFIO_PCI_OFFSET_TO_INDEX(off) (off >> ISM_VFIO_PCI_OFFSET_S=
HIFT)
>> +#define ISM_VFIO_PCI_INDEX_TO_OFFSET(index) ((u64)(index) << ISM_VFIO_P=
CI_OFFSET_SHIFT)
>> +#define ISM_VFIO_PCI_OFFSET_MASK (((u64)(1) << ISM_VFIO_PCI_OFFSET_SHIF=
T) - 1)
>> +
>> +struct ism_vfio_pci_core_device {
>> +	struct vfio_pci_core_device core_device;
>> +};
>> +
>> +static int ism_pci_open_device(struct vfio_device *core_vdev)
>> +{
>> +	struct ism_vfio_pci_core_device *ivdev;
>> +	struct vfio_pci_core_device *vdev;
>
>
> Why do you need 'struct ism_vfio_pci_core_device'?
> Unlike other vfio_pci variant drivers your struct only has a single membe=
r.
> I see it is used below as well, but couldn't you directly use 'struct vfi=
o_pci_core_device'
> in all places?

Theoretically yes, but functions like vfio_alloc_device() expect this paren=
t
struct.

>
>
>> +	int ret;
>> +
>> +	ivdev =3D container_of(core_vdev, struct ism_vfio_pci_core_device,
>> +			     core_device.vdev);
>> +	vdev =3D &ivdev->core_device;
>> +
>> +	ret =3D vfio_pci_core_enable(vdev);
>> +	if (ret)
>> +		return ret;
>> +
>> +	vfio_pci_core_finish_enable(vdev);
>> +	return 0;
>> +}
>> +
>> +static ssize_t ism_vfio_pci_do_io_r(struct vfio_pci_core_device *vdev,
>> +				    char __user *buf, loff_t off, size_t count,
>> +				    int bar)
>> +{
>> +	struct zpci_dev *zdev =3D to_zpci(vdev->pdev);
>> +	ssize_t ret, done =3D 0;
>> +	u64 req, length, tmp;
>> +
>> +	while (count) {
>> +		if (count >=3D 8 && IS_ALIGNED(off, 8))
>> +			length =3D 8;
>> +		else if (count >=3D 4 && IS_ALIGNED(off, 4))
>> +			length =3D 4;
>> +		else if (count >=3D 2 && IS_ALIGNED(off, 2))
>> +			length =3D 2;
>> +		else
>> +			length =3D 1;
>
> As you know something like
>> +		if (count >=3D 8 && IS_ALIGNED(off, 8)) {
>> +			length =3D 8;
> 		} else {
> 			unsigned missing_bytes =3D 8 - (off % 8);
> 			length =3D min(count, missing_bytes);
> 		}
>
> would suffice to fullfill the requirements for pcilg to BARs.
> But your code works as well.

I think my version is easier to read and better aligned to common code.

>
>> +		req =3D ZPCI_CREATE_REQ(READ_ONCE(zdev->fh), bar, length);
>> +		/* use pcilg to prevent using MIO instructions */
>> +		ret =3D __zpci_load(&tmp, req, off);
>> +		if (ret)
>> +			return ret;
>> +		if (copy_to_user(buf, &tmp, length))
>> +			return -EFAULT;
>> +		count -=3D length;
>> +		done +=3D length;
>> +		off +=3D length;
>> +		buf +=3D length;
>> +	}
>> +	return done;
>> +}
>> +
>> +static ssize_t ism_vfio_pci_do_io_w(struct vfio_pci_core_device *vdev,
>> +				    char __user *buf, loff_t off, size_t count,
>> +				    int bar)
>> +{
>> +	struct zpci_dev *zdev =3D to_zpci(vdev->pdev);
>> +	void *data __free(kfree) =3D NULL;
>> +	ssize_t ret;
>> +	u64 req;
>> +
>> +	if (count > zdev->maxstbl)
>> +		return -EINVAL;
>
> I think you also need to check for off+count not crossing 4k

Thanks! Will introduce this check in the next version.

>
>
>> +	data =3D kzalloc(count, GFP_KERNEL);
>
>
> Where do you free 'data' ?

void *data __free(kfree) =3D NULL;

>
>> +	if (!data)
>> +		return -ENOMEM;
>> +	if (copy_from_user(data, buf, count))
>> +		return -EFAULT;
>> +	req =3D ZPCI_CREATE_REQ(READ_ONCE(zdev->fh), bar, count);
>  > +	ret =3D __zpci_store_block(data, req, off);
>> +	if (ret)
>> +		return ret;
>> +	return count;
>> +}
>> +


