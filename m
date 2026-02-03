Return-Path: <kvm+bounces-70021-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0LBoJXobgmmhPQMAu9opvQ
	(envelope-from <kvm+bounces-70021-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 16:59:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E7DFDBA0E
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 16:59:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D5B3D3129618
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 15:55:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1EAF3BFE45;
	Tue,  3 Feb 2026 15:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ciM+hoi5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C3C190462;
	Tue,  3 Feb 2026 15:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770134122; cv=none; b=LhmOrAQaCF7aqtw3s1BLU586u7RScr9XplEUKDtXpaqad/FWfN1BjcoI6cfTwL9FkOPXRwKsMMWEqq4kfVDjXswW0B5TFKUm4/a+5uCK8qhJdD7e2olCDR2qSDFa065KgRr26N+25N69dXTAJY0ocrkRkehWfA4ca7S5fv+hdmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770134122; c=relaxed/simple;
	bh=fThoJunc3ujlK1PonBUvhMdkpRgz6Hfzzs6aB13oaBE=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=L5zXgXuJ4Sw/WtHlx3NYY5JwvDaPNd0Yy4APzGKJj3AWIfBv4dnS3QIMFWCVDlzodXgBBV/FK0iD2PVyquJkeiyYf7k8Zb9fTvgl5HFWKxx6XGX65Oj18l1+MXg/Vnd80vZ3zeh+dVSniFUy3F/zYGBsHiNCD/JwBhtHeD7L2yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ciM+hoi5; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 613Dnorc007618;
	Tue, 3 Feb 2026 15:54:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=UPKj+r
	vhExh7TG8IOzbJLnzxbJjh9vFZ+hHiez4evrc=; b=ciM+hoi5aKDtHH0WfyFpWh
	gqegmf5s3Gk9ZYtB/7tJO5+9ooYlOGmJw16WW/TdVGJgTLtdUljRgbdQcvuVG8dB
	lhD75Yw0osqiYJoBa+knw/hFONaRhTIIRyUaapRvEb9VtXrKWYpwZaBi73i9F6KH
	YgW2BJdygWztpoVc5CbWICtUjaVCaaABC+4fkbdWBjG0n5WORk+NC3ksQ9BixVfq
	thAb7ptmr5DqZvWcp3T1ktK8u2CkQfw9upjGpZ7m1sJklQLXevv1wlqdrjdkrgV+
	vU/JY99yuE+l632Q56sgvmVSvBv531HGGHtoUIMpV+CEfdZffhc3grPP+CWt6wNg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c185guwp4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Feb 2026 15:54:47 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 613Fskjv024313;
	Tue, 3 Feb 2026 15:54:47 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c185guwp2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Feb 2026 15:54:46 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 613CFfhY027353;
	Tue, 3 Feb 2026 15:54:46 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c1xs19eu2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Feb 2026 15:54:45 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 613FsfOE57409922
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 3 Feb 2026 15:54:41 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BF93120043;
	Tue,  3 Feb 2026 15:54:41 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C495820040;
	Tue,  3 Feb 2026 15:54:36 +0000 (GMT)
Received: from [9.39.23.245] (unknown [9.39.23.245])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  3 Feb 2026 15:54:36 +0000 (GMT)
Message-ID: <c6f64344-f211-460d-ae4f-bffdbd96182a@linux.ibm.com>
Date: Tue, 3 Feb 2026 21:24:34 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Subject: Re: [RFC PATCH] powerpc: iommu: Initial IOMMUFD support for PPC64
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, iommu@lists.linux.dev
Cc: mpe@ellerman.id.au, maddy@linux.ibm.com, npiggin@gmail.com,
        alex@shazbot.org, joerg.roedel@amd.com, kevin.tian@intel.com,
        gbatra@linux.ibm.com, jgg@nvidia.com, clg@kaod.org,
        vaibhav@linux.ibm.com, brking@linux.vnet.ibm.com,
        nnmlinux@linux.ibm.com, amachhiw@linux.ibm.com,
        tpearson@raptorengineering.com
References: <176953894915.725.1102545144304639827.stgit@linux.ibm.com>
 <974a95d4-0ae5-400a-992f-9e468a0666d6@kernel.org>
Content-Language: en-US
In-Reply-To: <974a95d4-0ae5-400a-992f-9e468a0666d6@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=UdxciaSN c=1 sm=1 tr=0 ts=69821a47 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=kvopkG0x9FeW82KiyRIA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: KffHkNlso51bdV13BLHUktqqSON0pByT
X-Proofpoint-ORIG-GUID: OTNI4sMCcOLftxtQDAWr9KBeej-K7Llj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAzMDEyNyBTYWx0ZWRfX5qf8s6YLxGlp
 Ufkrq4siEHNQQaqO01YTsdKQ9CQBwxFSkWrCGGh3jNWYhLEcNsXwasq6ko10UqX3PIwJuB0Lmq6
 NVYML7z3W1+3RAyxKngHUxQDznlFTh4LfnU28n0PtM43lSHYXXMr5QITiYnRc4Ih8RRt/zUHTAg
 1vXSF5FMsv/A+JiHS+riwD59mfRXERUAjbwKU/wZQy4uI32i3Qsaa60FfaVPQyB1QDwAPGjaUVA
 rjN3S8KHlXBMCvWHUEsmliL0U0Gyk+pMi2aqROH+Guf23vD15ZuL5l2/IerNfpooKojN+/slC9X
 dgHqzsW6wqPxkR1sci3tRIHRTjAUw9hLULAeo27BplEElANGGxg1S8v49lTVr4bV2i4ytuFgRUe
 o0jQWLlDrLQWCKjA6VShaqGeagJsJfIwhU1W3yhoxFTkcyxKtUJ2Q6t7/YatQborB+wZMLytEnz
 6X1DVb5BV2jmS+tJuwQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-03_05,2026-02-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 impostorscore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 bulkscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2602030127
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[ellerman.id.au,linux.ibm.com,gmail.com,shazbot.org,amd.com,intel.com,nvidia.com,kaod.org,linux.vnet.ibm.com,raptorengineering.com];
	TAGGED_FROM(0.00)[bounces-70021-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[ibm.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sbhat@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_TWELVE(0.00)[13];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3E7DFDBA0E
X-Rspamd-Action: no action

Hi Christophe.


Thanks for trying the patch.


On 1/28/26 4:23 PM, Christophe Leroy (CS GROUP) wrote:
>
>
> Le 27/01/2026 à 19:35, Shivaprasad G Bhat a écrit :
>> The RFC attempts to implement the IOMMUFD support on PPC64 by
>> adding new iommu_ops for paging domain. The existing platform
>> domain continues to be the default domain for in-kernel use.
>> The domain ownership transfer ensures the reset of iommu states
>> for the new paging domain and in-kernel usage.


<snip/>

>> ...
>> root:localhost# mount /dev/nvme0n1 /mnt
>> root:localhost# ls /mnt
>> ...
>>
>> The current patch is based on linux kernel 6.19-rc6 tree.
>
> Getting the following build failure on linuxppc-dev patchwork with 
> g5_defconfig or ppc64_defconfig:
>
> Error: /linux/arch/powerpc/sysdev/dart_iommu.c:325:9: error: 
> initialization of 'int (*)(struct iommu_table *, long int,  long int, 
> long unsigned int,  enum dma_data_direction,  long unsigned int,  
> bool)' {aka 'int (*)(struct iommu_table *, long int,  long int,  long 
> unsigned int,  enum dma_data_direction,  long unsigned int,  _Bool)'} 
> from incompatible pointer type 'int (*)(struct iommu_table *, long 
> int,  long int,  long unsigned int,  enum dma_data_direction,  long 
> unsigned int)' [-Werror=incompatible-pointer-types]
>   .set = dart_build,
>          ^~~~~~~~~~
> /linux/arch/powerpc/sysdev/dart_iommu.c:325:9: note: (near 
> initialization for 'iommu_dart_ops.set')
> cc1: all warnings being treated as errors
> make[5]: *** [/linux/scripts/Makefile.build:287: 
> arch/powerpc/sysdev/dart_iommu.o] Error 1
> make[4]: *** [/linux/scripts/Makefile.build:544: arch/powerpc/sysdev] 
> Error 2


I was trying only pseries and powernv configs. I see the changes would break

pasemi and dart iommus.


The below diff should get it going,

===========================

diff --git a/arch/powerpc/platforms/pasemi/iommu.c 
b/arch/powerpc/platforms/pasemi/iommu.c
index 375487cba874..75b526a560b8 100644
--- a/arch/powerpc/platforms/pasemi/iommu.c
+++ b/arch/powerpc/platforms/pasemi/iommu.c
@@ -77,7 +77,7 @@ static int iommu_table_iobmap_inited;
  static int iobmap_build(struct iommu_table *tbl, long index,
                          long npages, unsigned long uaddr,
                          enum dma_data_direction direction,
-                        unsigned long attrs)
+                        unsigned long attrs, bool is_phys)
  {
         u32 *ip;
         u32 rpn;
diff --git a/arch/powerpc/sysdev/dart_iommu.c 
b/arch/powerpc/sysdev/dart_iommu.c
index c0d10c149661..b424a602d07a 100644
--- a/arch/powerpc/sysdev/dart_iommu.c
+++ b/arch/powerpc/sysdev/dart_iommu.c
@@ -171,7 +171,7 @@ static void dart_flush(struct iommu_table *tbl)
  static int dart_build(struct iommu_table *tbl, long index,
                        long npages, unsigned long uaddr,
                        enum dma_data_direction direction,
-                      unsigned long attrs)
+                      unsigned long attrs, bool is_phys)
  {
         unsigned int *dp, *orig_dp;
         unsigned int rpn;

===========================


I will take care of it in next version.


Thank you!


Regards,

Shivaprasad

>
> Christophe
>
>
<snip/>

