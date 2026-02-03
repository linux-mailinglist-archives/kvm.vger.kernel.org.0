Return-Path: <kvm+bounces-70020-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GFerHOoZgmmZPAMAu9opvQ
	(envelope-from <kvm+bounces-70020-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 16:53:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E6DB8DB8C6
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 16:53:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CFB903046DF5
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 15:53:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C482A3BFE3D;
	Tue,  3 Feb 2026 15:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lF/e/bwL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997433AE6E9;
	Tue,  3 Feb 2026 15:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770133989; cv=none; b=eI/U0JaPFNQlb4Qmg0ROMPlv0eDfxk08nx9ZhRPG6EjKWwvJiDOHNdAZP2qM1DBaXk6IRHK4WjRLjCuxLtHD04qhP4HGhnY7wQcH7S04gpYSEl1FE4WiAOziuiG6ENZuewx9yC4/QQM/a/a5BjtyfrkjJQpaQCEzgSMKEQ+tOWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770133989; c=relaxed/simple;
	bh=jrRTZcyBcrvN7sMJWqW04sU/onDh3CMwQpJikxoq5no=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=Q52QjV3VaHNjxHEGJkgf71VCqzALWL2OgrCuq2ITMTRCuPReROIsuBd/P2PtgRh996GP9WuP9ko0i5Rc45/zSMQSKTa7Ez+8Eq0pqvSxK6ORCWsLZ3slKEVYnNR9MMXfHr0bmyQN236Nl5iUXUg4yWJbHQDnWRxVxQ3Ly5auAPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lF/e/bwL; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 6138iuEk007530;
	Tue, 3 Feb 2026 15:52:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=+IN/rZ
	S09RmqSJcz3mq9tilgotyCw9gelQNf+laH/bg=; b=lF/e/bwLVDpBaBIxq5Z2WT
	OJQu1UhMylC8zjsI5XF3dVOp3jlVhvu9c2Qw9vAlFUQMstadl1j7mW3I6Plr+wJJ
	ofZ9XWpRlvOm3ADpZpdbdt4cHXsuN6jihSBd/a3Jt4wRMR1YlMp/nKQv6K2YAaVe
	wXG92UUZkyOfG4MtmKmwwMo2kvNzJstdVKZBUWq7fQwwSp7dCmL6ptTmVygpsVJ1
	vIRV+SeHLBEA0pEYuKSBFAr2sr9sn62GZE5Vh0VEKQE07rbFsIZvVDDaUk+SENFx
	o81BcpOkE3CV48P2eHw5c58mklQrRww5AdGtlt6Uc5Xo0teAHExCNSyMSTc0Qdaw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c175mv106-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Feb 2026 15:52:24 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 613FqO3v028480;
	Tue, 3 Feb 2026 15:52:24 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c175mv104-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Feb 2026 15:52:24 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 613FMTfX025706;
	Tue, 3 Feb 2026 15:52:23 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c1w2msqka-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Feb 2026 15:52:23 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 613FqI9e50463178
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 3 Feb 2026 15:52:18 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7F5ED20043;
	Tue,  3 Feb 2026 15:52:18 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BFDCA20040;
	Tue,  3 Feb 2026 15:52:14 +0000 (GMT)
Received: from [9.39.23.245] (unknown [9.39.23.245])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  3 Feb 2026 15:52:14 +0000 (GMT)
Message-ID: <2127b181-2c3a-4470-9b79-b508a18275c9@linux.ibm.com>
Date: Tue, 3 Feb 2026 21:22:13 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Subject: Re: [RFC PATCH] powerpc: iommu: Initial IOMMUFD support for PPC64
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, iommu@lists.linux.dev, chleroy@kernel.org,
        mpe@ellerman.id.au, maddy@linux.ibm.com, npiggin@gmail.com,
        alex@shazbot.org, joerg.roedel@amd.com, kevin.tian@intel.com,
        gbatra@linux.ibm.com, clg@kaod.org, vaibhav@linux.ibm.com,
        brking@linux.vnet.ibm.com, nnmlinux@linux.ibm.com,
        amachhiw@linux.ibm.com, tpearson@raptorengineering.com
References: <176953894915.725.1102545144304639827.stgit@linux.ibm.com>
 <20260127191643.GQ1134360@nvidia.com>
Content-Language: en-US
In-Reply-To: <20260127191643.GQ1134360@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: pWb_DcVWnKcehlEza_1Eg7EunqW9zHFk
X-Authority-Analysis: v=2.4 cv=VcX6/Vp9 c=1 sm=1 tr=0 ts=698219b8 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=QKzg-OcEkSzzUhcykKgA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: WqHfrzIaLJB0eb712i9ZnJpDaRgynrjK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAzMDEyMyBTYWx0ZWRfX8hSWMsUf6TZA
 cJA/2Ti1RfFBzsi2+8VKb9ioe4oBfl6/3kmn8TkWIzIIWvRYbqxSQAxbSfHca4quSPe672aCZwS
 +/ZCPOjf/r0NzHC+PtEYs7PHi2Fw8icoFXD4GX+jJtGH5sxmKs3R5dRo2f7V+U5zibHRO2TGJMy
 PCaARCFiNpvoEPRAtimrOZnfXjJju52Lcj/nT2edErYOJ+bRANYL3/fpPj15JiyWyq9TTPxuvMe
 YprzV2er9pLSx+04UPaO0lKyMD1ywJ2Mo3ZiiKslUtQIeXHXrsRun6eRCXipafHnQI+RWOJx3UB
 qNd2YYO5B9O7ERkzEOFAMehFCbrrFm0v/cj58t7wGJds8Xhixfr5H6+TM3U0J404Oz/DOdYHKP7
 iZXv5h5qXsuQxQ8Zkw4EOkTdijtejFHrHrQw6Gmh091uNOLr7euureQXcJho5CfPvJhyWqOq00w
 0gS9Lm7w2T34tgGAY1g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-03_04,2026-02-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2601150000 definitions=main-2602030123
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.ozlabs.org,lists.linux.dev,kernel.org,ellerman.id.au,linux.ibm.com,gmail.com,shazbot.org,amd.com,intel.com,kaod.org,linux.vnet.ibm.com,raptorengineering.com];
	TAGGED_FROM(0.00)[bounces-70020-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[ibm.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sbhat@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_TWELVE(0.00)[13];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux.ibm.com:mid]
X-Rspamd-Queue-Id: E6DB8DB8C6
X-Rspamd-Action: no action

Hi Jason,


Thanks for reviewing this patch.


On 1/28/26 12:46 AM, Jason Gunthorpe wrote:
> On Tue, Jan 27, 2026 at 06:35:56PM +0000, Shivaprasad G Bhat wrote:
>> The RFC attempts to implement the IOMMUFD support on PPC64 by
>> adding new iommu_ops for paging domain. The existing platform
>> domain continues to be the default domain for in-kernel use.
> It would be nice to see the platform domain go away and ppc use the
> normal dma-iommu.c stuff, but I don't think it is critical to making
> it work with iommufd.


I agree. I have started on this. I will send incremental changes

as follow-up after this.


>> On PPC64, IOVA ranges are based on the type of the DMA window
>> and their properties. Currently, there is no way to expose the
>> attributes of the non-default 64-bit DMA window, which the platform
>> supports. The platform allows the operating system to select the
>> starting offset(at 4GiB or 512PiB default offset), pagesize and
>> window size for the non-default 64-bit DMA window. For example,
>> with VFIO, this is handled via VFIO_IOMMU_SPAPR_TCE_GET_INFO
>> and VFIO_IOMMU_SPAPR_TCE_CREATE|REMOVE ioctls. While I am exploring
>> the ways to expose and configure these DMA window attributes as
>> per user input, any suggestions in this regard will be very helpful.
> You can pass in driver specific information during HWPT creation, so
> any properties you need can be specified there.


Sure. I think IOMMU_GET_HW_INFO would be useful for getting the

platform supported configuration in this case.


> Then you'd want to introduce a new domain op to get the apertures
> instead of the single range hard coded into the domain struct. The new
> op would be able to return a list. We can use this op to return
> apertures for sign extension page tables too.
>
> Update iommufd to calculate the reserved regions by evaluating the
> whole list.
>
> I think you'll find this pretty straight forward, I'd do it as a
> followup patch to this one.


Thanks. I will wait for that patch.


>
>> Currently existing vfio type1 specific vfio-compat driver even
>> with this patch will not work for PPC64. I believe we need to have
>> a separate "vfio-spapr-compat" driver to make it work.
> Yes, vfio-compat doesn't support the special spapr ioctls.
>
> I don't think you need a new driver, just implement whatever they do
> with the existing interfaces, probably in its own .c file though.

There are ioctl number conflicts like

# grep -n "VFIO_BASE + 1[89]" include/uapi/linux/vfio.h | grep define
940:#defineVFIO_DEVICE_BIND_IOMMUFD_IO(VFIO_TYPE, VFIO_BASE + 18)
976:#defineVFIO_DEVICE_ATTACH_IOMMUFD_PT_IO(VFIO_TYPE, VFIO_BASE + 19)
1833:#defineVFIO_IOMMU_SPAPR_UNREGISTER_MEMORY_IO(VFIO_TYPE, VFIO_BASE + 18)
1856:#defineVFIO_IOMMU_SPAPR_TCE_CREATE_IO(VFIO_TYPE, VFIO_BASE + 19)
# grep -n "VFIO_BASE + 20" include/uapi/linux/vfio.h | grep define
999:#defineVFIO_DEVICE_DETACH_IOMMUFD_PT_IO(VFIO_TYPE, VFIO_BASE + 20)
1870:#defineVFIO_IOMMU_SPAPR_TCE_REMOVE_IO(VFIO_TYPE, VFIO_BASE + 20)

> However, I have no idea what is required to implement those ops, or if
> it is even possible.. It may be easier to just leave the old vfio
> stuff around instead of trying to compat it. The purpose of compat was
> to be able to build kernels without type1 at all. It isn't necessary
> to start using iommufd in new apps with the new interfaces.
>
> Given you are mainly looking at a VMM that already will have iommufd
> support it may not be worthwhile.


You are right. We do have some use cases beyond VMM, I will consider 
compat driver

only if it is helpful there.


>> @@ -1201,7 +1201,15 @@ spapr_tce_blocked_iommu_attach_dev(struct iommu_domain *platform_domain,
>>   	 * also sets the dma_api ops
>>   	 */
>>   	table_group = iommu_group_get_iommudata(grp);
>> +
>> +	if (old && old->type == IOMMU_DOMAIN_DMA) {
> I'm trying to delete IOMMU_DOMAIN_DMA please don't use it in
> drivers.
Sure.
>>   static const struct iommu_ops spapr_tce_iommu_ops = {
>>   	.default_domain = &spapr_tce_platform_domain,
>>   	.blocked_domain = &spapr_tce_blocked_domain,
>> @@ -1267,6 +1436,14 @@ static const struct iommu_ops spapr_tce_iommu_ops = {
>>   	.probe_device = spapr_tce_iommu_probe_device,
>>   	.release_device = spapr_tce_iommu_release_device,
>>   	.device_group = spapr_tce_iommu_device_group,
>> +	.domain_alloc_paging = spapr_tce_domain_alloc_paging,
>> +	.default_domain_ops = &(const struct iommu_domain_ops) {
>> +		.attach_dev     = spapr_tce_iommu_attach_device,
>> +		.map_pages      = spapr_tce_iommu_map_pages,
>> +		.unmap_pages    = spapr_tce_iommu_unmap_pages,
>> +		.iova_to_phys   = spapr_tce_iommu_iova_to_phys,
>> +		.free           = spapr_tce_domain_free,
>> +	}
> Please don't use default_domain_ops in a driver that is supporting
> multiple domain types and platform, it becomes confusing to guess
> which domain type those ops are linked to.


Sure.


> You should also implement the BLOCKING domain type to make VFIO work
> better


I am not sure how this could help making VFIO better. May be, I am not able

to imagine the advantages with the current platform domain approach

in place. Could you please elaborate more on this?


> I wouldn't try to guess if this is right or not, but it looks pretty
> reasonable as a first start.


Thanks, I will iterate this as RFC till i get to reasonable shape.


Regards,

Shivaprasad

> Jason

