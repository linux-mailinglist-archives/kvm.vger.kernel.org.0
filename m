Return-Path: <kvm+bounces-72088-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cH23MkC1oGnClwQAu9opvQ
	(envelope-from <kvm+bounces-72088-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 22:04:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 53FE81AF605
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 22:04:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6194F30B3885
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 21:03:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18A113939B3;
	Thu, 26 Feb 2026 21:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pM04yJT6"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF5826AC3;
	Thu, 26 Feb 2026 21:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772139821; cv=none; b=ajUujVxR4EgSgHgzIuRxCPId58hL82NTyVSxZed5KWV2mw9Pj+ae8Lbcma1QYyWrIf7v2TEamd6RLPLcjNm4eVQTGT/YScBgAeA/KdcMRxyfvpnLwd6/+1b/JaCKqRY3I6g3y2IEboEJHO0i9c+HyPAqEP9+Fa+/KNSIzyTv5V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772139821; c=relaxed/simple;
	bh=mVL0taH76zkpOVm5k/iwac0MIl8Bb7Prd6Bsm1BJCd4=;
	h=Message-ID:Subject:From:To:Cc:In-Reply-To:References:Content-Type:
	 Date:MIME-Version; b=iqCfsltnSXj/0RluPo7TmGiQ6DiW4hfBHrBIlfUbPftY3nahMgoSjPyyOBTNUSN71rCi/DwdB00BwbgM+8FUxQgdy5lYx+w9Nji9EmOzVvMMfoz+hBh/CJjxKZCDx35QnIf77Q+OJHl1FswGYn36u5xlQXYvAVh0cZ3efrCv0Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pM04yJT6; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61QGetLl567419;
	Thu, 26 Feb 2026 21:03:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=OU30d1
	YG6zjTAk+7xHE3MmzoVZ0KRXTuCeJeQSDmTr8=; b=pM04yJT6Du1j7TJzifb19L
	v5A3Fwbxtc2B3WUxq6hBHFQKBz0yn75nq/qAewdtfCcwQigckgjU1rgLgdWzyyLl
	5BBFURbX5BnSWNC9r+fYGyFhMnWd863dx/vwJsIAXIXBXVGJ6pIKkf1H2cHKLVoJ
	HFiznckh7UXFnRk+t2ksikgeIBkoV9V6sIX9cfhx1uGXKdLFiiv5tvxLHKejxcjG
	wkBVYVk46TuEDQOzYGQ0pzc5G6uShS+7kVWHl0kk73w+W6l7HxaG+zvXn58ErtHu
	GxnvN4chIobLThaXAGpxMLkLJaeCs7Hh0Ci5h4l1m9jZFL7fCD/IpEz+WDhClhqg
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cf4cr92jm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Feb 2026 21:03:32 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61QJKjOX027812;
	Thu, 26 Feb 2026 21:03:31 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cfsr25wms-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Feb 2026 21:03:31 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61QL3Utc11403794
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Feb 2026 21:03:30 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 19ED158059;
	Thu, 26 Feb 2026 21:03:30 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7904C58053;
	Thu, 26 Feb 2026 21:03:26 +0000 (GMT)
Received: from [9.87.142.49] (unknown [9.87.142.49])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 26 Feb 2026 21:03:26 +0000 (GMT)
Message-ID: <17f20481115758d63e0a839fa9ac6af561f70b6b.camel@linux.ibm.com>
Subject: Re: [PATCH v2 2/3] vfio/ism: Implement vfio_pci driver for ISM
 devices
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: Julian Ruess <julianr@linux.ibm.com>, wintera@linux.ibm.com,
        ts@linux.ibm.com, oberpar@linux.ibm.com, gbayer@linux.ibm.com,
        Alex
 Williamson	 <alex@shazbot.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Yishai
 Hadas	 <yishaih@nvidia.com>,
        Shameer Kolothum <skolothumtho@nvidia.com>,
        Kevin Tian	 <kevin.tian@intel.com>
Cc: mjrosato@linux.ibm.com, alifm@linux.ibm.com, raspl@linux.ibm.com,
        hca@linux.ibm.com, agordeev@linux.ibm.com, gor@linux.ibm.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <20260224-vfio_pci_ism-v2-2-f010945373fa@linux.ibm.com>
References: <20260224-vfio_pci_ism-v2-0-f010945373fa@linux.ibm.com>
	 <20260224-vfio_pci_ism-v2-2-f010945373fa@linux.ibm.com>
Autocrypt: addr=schnelle@linux.ibm.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Feb 2026 22:02:25 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: j3lpEhYJgI4szr8SGvSTXZJRkvgM24K0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI2MDE4NCBTYWx0ZWRfX89UlAW+jWcjf
 RW9ptCmk+a9QkD6VhZ/GwjUg3EtiHWpFU9X1xkaNR8vF76mMz8l2gdcvaG9JjOJ5hGheF12Kqoe
 C/o2pnv+5cOM7CHHp/1N3H5is+xvBqEPto04y1ui06tovcztxNjAjUW7wd1W+2uVaavA1hMwVK6
 168RcoK6tnRGtnW1ImhyW7+gw9eG1bBPibK31Rb0EMiiAahTaXPID+3d+hQRVtiqcdzGhL+1ed9
 5/aRMxxJo3F4AtX9wG1M80Bt8S0tO65F3HIwnfhiizICqB28IP14hCGVOJQq7OvlhUWorYRqYU4
 MHg7l9cUPrvdu5IxG8Nd3kokJ5M3q+0PaigU1+WKr/PetZp+XCbAqJwYfZq+X1/merN9cpbXzCe
 LUx7TfipeIYI6oAK8FutJRCYxSL+uDM2DLkAP2g6Cz5YcPN3w3ID3SBTe5GslEZ+qfHWX67smFC
 68T4pHKtT87xDr7BZWA==
X-Proofpoint-GUID: j3lpEhYJgI4szr8SGvSTXZJRkvgM24K0
X-Authority-Analysis: v=2.4 cv=bbBmkePB c=1 sm=1 tr=0 ts=69a0b524 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=iXMz9YD8DWuSEQOWV1UA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-26_02,2026-02-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 adultscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602260184
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[20];
	TAGGED_FROM(0.00)[bounces-72088-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.ibm.com:mid];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[schnelle@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 53FE81AF605
X-Rspamd-Action: no action

On Tue, 2026-02-24 at 13:34 +0100, Julian Ruess wrote:
> Add a vfio_pci variant driver for the s390-specific Internal Shared
> Memory (ISM) devices used for inter-VM communication.
>=20
> This enables the development of vfio-pci-based user space drivers for
> ISM devices.
>=20
> On s390, kernel primitives such as ioread() and iowrite() are switched
> over from function handle based PCI load/stores instructions to PCI
> memory-I/O (MIO) loads/stores when these are available and not
> explicitly disabled. Since these instructions cannot be used with ISM
> devices, ensure that classic function handle-based PCI instructions are
> used instead.
>=20
> The driver is still required even when MIO instructions are disabled, as
> the ISM device relies on the PCI store block (PCISTB) instruction to
> perform write operations.
>=20
> Stores are not fragmented, therefore one ioctl corresponds to exactly
> one PCISTB instruction. User space must ensure to not write more than
> 4096 bytes at once to an ISM BAR which is the maximum payload of the
> PCISTB instruction.
>=20
> Signed-off-by: Julian Ruess <julianr@linux.ibm.com>
> ---
>  drivers/vfio/pci/Kconfig      |   2 +
>  drivers/vfio/pci/Makefile     |   2 +
>  drivers/vfio/pci/ism/Kconfig  |  11 ++
>  drivers/vfio/pci/ism/Makefile |   3 +
>  drivers/vfio/pci/ism/main.c   | 297 ++++++++++++++++++++++++++++++++++++=
++++++
>  5 files changed, 315 insertions(+)
>=20
--- snip ---
> +
> +static ssize_t ism_vfio_pci_do_io_r(struct vfio_pci_core_device *vdev,
> +				    char __user *buf, loff_t off, size_t count,
> +				    int bar)
> +{
> +	struct zpci_dev *zdev =3D to_zpci(vdev->pdev);
> +	ssize_t ret, done =3D 0;
> +	u64 req, length, tmp;
> +
> +	while (count) {
> +		if (count >=3D 8 && IS_ALIGNED(off, 8))
> +			length =3D 8;
> +		else if (count >=3D 4 && IS_ALIGNED(off, 4))
> +			length =3D 4;
> +		else if (count >=3D 2 && IS_ALIGNED(off, 2))
> +			length =3D 2;
> +		else
> +			length =3D 1;
> +		req =3D ZPCI_CREATE_REQ(READ_ONCE(zdev->fh), bar, length);
> +		/* use pcilg to prevent using MIO instructions */

I think this comment could be improved but it's not wrong either so no
strong opinion. Maybe something like:

/*
 * Use __zpci_load() to bypass automatic use of PCI MIO instructions
 * which are not supported on ISM devices
 */


> +		ret =3D __zpci_load(&tmp, req, off);
> +		if (ret)
> +			return ret;
> +		if (copy_to_user(buf, &tmp, length))
> +			return -EFAULT;
> +		count -=3D length;
> +		done +=3D length;
> +		off +=3D length;
> +		buf +=3D length;
> +	}
> +	return done;
> +}
> +
> +static ssize_t ism_vfio_pci_do_io_w(struct vfio_pci_core_device *vdev,
> +				    char __user *buf, loff_t off, size_t count,
> +				    int bar)
> +{
> +	struct zpci_dev *zdev =3D to_zpci(vdev->pdev);
> +	void *data __free(kfree) =3D NULL;
> +	ssize_t ret;
> +	u64 req;
> +
> +	if (count > zdev->maxstbl)
> +		return -EINVAL;
> +	data =3D kzalloc(count, GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +	if (copy_from_user(data, buf, count))
> +		return -EFAULT;
> +	req =3D ZPCI_CREATE_REQ(READ_ONCE(zdev->fh), bar, count);
> +	ret =3D __zpci_store_block(data, req, off);

Note for the interested reader. ISM devices have relaxed alignment
rules on PCI Store Block so if you compare with other PCI Store Block
uses e.g. in memcpy_toio() don't be alarmed that this doesn't check the
alignment in the same way, or at all. Also we do still get error
returns if the access failed.

> +	if (ret)
> +		return ret;
> +	return count;
> +}
>=20
--- snip ---
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("vfio-pci variant driver for the IBM Internal Shared =
Memory (ISM) device");
> +MODULE_AUTHOR("IBM Corporation");

I'm a bit biased here since I've been quite involved in your work and
the design decisions leading to this variant driver, but this looks
good to me. And in particular the low level PCI accesses  with ISM's
quirks in mind look fine to me.

Feel free to add:

Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>

Thanks,
Niklas

