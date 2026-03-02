Return-Path: <kvm+bounces-72370-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ECcFFLmPpWmoDgYAu9opvQ
	(envelope-from <kvm+bounces-72370-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 14:25:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 578D91D9B43
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 14:25:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 43A9A3013FCA
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 13:24:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC3B63E5578;
	Mon,  2 Mar 2026 13:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VhrGVyEp"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59EF83E7165;
	Mon,  2 Mar 2026 13:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772457830; cv=none; b=SFBvVXWb/kTC/wkJBkL4wvS7mk1K4DPEy2BMyZXrGcBWe0udMb/KiGvlMPC95+Kal5Dj2g1q526t1tSvSusNthm+4XYki7luLOTvijjVknvTIAsZV78O30cEsQAPvE8QfuHxQ4zw/04/qI+KF97+s75wToEY+MRPmRxIIzYrn+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772457830; c=relaxed/simple;
	bh=N+tnx8WWF8pCSyywrl44J5+kQYdBQLh8rR4igmMR9GQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C7u4xEQOMw31kdWHj9xHZsA8j5DXi5p8GBCkTMlETSe/Pvg+3ow2TRhGIK4RnXnKwTa5P3YTVYyx4lyfc8S9fgcXJz+YBwRI3RsitpavSPI63TcYOpP78b4iENCR8PxEY+aNKdb6edP7vRgLI4gmVREyjmAS7ezaDg5a9LRSMzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VhrGVyEp; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 621Nulli2246261;
	Mon, 2 Mar 2026 13:23:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=m5eZb7
	dbXw8DApMgFS3qRxehYGTCtVaX4Oq3XuZhuQg=; b=VhrGVyEpiKwW4de2kt2H4t
	uJq6FLJOI8W0sSy4g/DdZJqn/vl1Ql7/wF3oxzE5FdUCZMDzGN6FGKaNE8YOqoaW
	0popfeHAGdZG+oF03X4EuGVkd4/sdhnzmF46tYuCcKrml+b2fvpYLCiU63AfBS1W
	YQNVjAZxc2dInNyjI585PnBF01tQpWFxoTF3pzYgChgGNlkn1HqSmJcFWb7hYYEB
	TpfFrduu6epwUd8sv6hYvoAU7UnFW0p1MxWtV3By1fANT/+I5JjLYW7az9VjhMxk
	japgGARNKlCzOIkD5xVRxzw8rpUVhNZQANVXtFlG7Q6qC4B/ckxeoQ4UC9loZeug
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cksk3pk2t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Mar 2026 13:23:41 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 622D3bGf010305;
	Mon, 2 Mar 2026 13:23:40 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cmc6jx6jc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Mar 2026 13:23:40 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 622DNaOn45613410
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 Mar 2026 13:23:36 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8CF5F20043;
	Mon,  2 Mar 2026 13:23:36 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3A4E820040;
	Mon,  2 Mar 2026 13:23:36 +0000 (GMT)
Received: from [9.52.217.119] (unknown [9.52.217.119])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  2 Mar 2026 13:23:36 +0000 (GMT)
Message-ID: <253d0c0a-ee6f-4bfc-ad19-4fbd794a6c82@linux.ibm.com>
Date: Mon, 2 Mar 2026 14:23:36 +0100
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
 <5e10827b-e87e-43a6-8783-2e5d23a186e1@linux.ibm.com>
 <DGSAHB6FS2D4.1KN7KTIF0EWE5@linux.ibm.com>
Content-Language: en-US
From: Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <DGSAHB6FS2D4.1KN7KTIF0EWE5@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: P7E2GibNP_-aWJwYOtp1VHjK1-NkjLwE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDExMSBTYWx0ZWRfX+kl7S5bpmnwk
 ObKKjCRhrvwDJTOEhgkyJp9Ww/sfnvHbNm953WJPSsspVveQic5T19Hk7uBeMVVaubeokJ3zoIS
 dvym3GyMjsBR9OVjJQ2bxnHnB9iLQZH/V2IeNIryAcJ585TgKLu8sunyyWCrrE83B0NucsFBoPg
 131EC9u9qx03W07s8RDEv54Pf8RWADYmR/GV6BDtawCiz8R/Bt+9iQroEMqh5VNlX8uts+qRn7W
 qKPq43Z2s39/qCpJvPxlUzLwT8578QFKXgV4Te4YIh5QLC9nFViW2ztCv67WkrYCkZ/yCxNeRGa
 LNanV8nbeiAtw7V0WDK/hPpzuupMoD+0Ridd5hJuqX8WY6WI3/JZTecYG3Vg1R251GtsojczHR8
 uNx3k/Q1JzNSbIw+mxmsx1CbH4YfzDMw1rIjE9bXbq7MhQGlbdWkW95O1YAcTu48g/QCRMqR34Z
 84WXTKY+QEq9MFC6oYA==
X-Authority-Analysis: v=2.4 cv=csCWUl4i c=1 sm=1 tr=0 ts=69a58f5d cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=jeZ6-WCPrn04vPXoU0QA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: P7E2GibNP_-aWJwYOtp1VHjK1-NkjLwE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 suspectscore=0 malwarescore=0 adultscore=0
 clxscore=1015 bulkscore=0 phishscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603020111
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[20];
	TAGGED_FROM(0.00)[bounces-72370-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,linux.ibm.com:mid];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[wintera@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 578D91D9B43
X-Rspamd-Action: no action



On 02.03.26 13:18, Julian Ruess wrote:
>>> +struct ism_vfio_pci_core_device {
>>> +	struct vfio_pci_core_device core_device;
>>> +};
>>> +
>>> +static int ism_pci_open_device(struct vfio_device *core_vdev)
>>> +{
>>> +	struct ism_vfio_pci_core_device *ivdev;
>>> +	struct vfio_pci_core_device *vdev;
>>
>> Why do you need 'struct ism_vfio_pci_core_device'?
>> Unlike other vfio_pci variant drivers your struct only has a single member.
>> I see it is used below as well, but couldn't you directly use 'struct vfio_pci_core_device'
>> in all places?
> Theoretically yes, but functions like vfio_alloc_device() expect this parent
> struct.


Couldn't you do something like:

static int ism_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
{
	struct vfio_pci_core_device *vdev;
	int ret;

	vdev = vfio_alloc_device(vfio_pci_core_device, vdev, &pdev->dev,
				 &ism_pci_ops);
	...


But I'm just thinking out loud. No strong feelings.
If you think it's worth to define an additional struct, so your driver looks more like the others - that's fine with me.



>> Where do you free 'data' ?
> void *data __free(kfree) = NULL;

Thank you; I learned something.

