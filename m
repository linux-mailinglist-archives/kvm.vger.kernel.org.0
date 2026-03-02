Return-Path: <kvm+bounces-72425-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IFv5Ji0UpmnlJgAAu9opvQ
	(envelope-from <kvm+bounces-72425-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 23:50:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A0EB61E5EF5
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 23:50:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B94F3303F5E9
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 22:07:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4736531B114;
	Mon,  2 Mar 2026 22:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lZ/v9LTl"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D667282F0D;
	Mon,  2 Mar 2026 22:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772489234; cv=none; b=RHoZw5HbZG4kab/L2GbYQlTsJEpCKEgt6X3lxK9MWCTAibQ3Q13Y/OpLmXQ7PR6DG2ke8DdtTLYhXavqCR3CIwPmtoqtwNnei9cphh7SiVZWW++unfmulRe1Wlrio7Ih6rx4NS/C34wg6jsMcQJogHArg8So0X3lAoaFBV0ue4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772489234; c=relaxed/simple;
	bh=S+774mm1EeK5jbLqwATzSdBMWxYbxOszAJUPkaegO1s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GhexaewFkJFxWtlZDMKBdkuCwzRcPNDhxm5Jp+Gv2BTnhL4gcsCoEvH/g5G++tvtMyy5Fz0cgPPtwAXKuMNM4LY8vTIXOJyRLs9xqUbQGZ8pc5a0FSxTFSQAZOfJIT8HbUSOvOTgN0ZPUEvwOUq58Hl0rM4H6ZPPy89TeTJ7zXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lZ/v9LTl; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622F5Rnb2104912;
	Mon, 2 Mar 2026 22:07:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=odGQCO
	pWRy8fJtng74GofJD9co7PEAYxnqmwYGVJICk=; b=lZ/v9LTl0tJ7uv+bQuJMF0
	QpTtADYB2P/R433Tb9Ifq7m50zBZe4Jrb9Lj7gwaimRBhCB0e/ksVbtRWwU5WCFh
	UUXLBfMVEmmNJbh+LRFzD8VXhrQbzfIUKqusqTFc/f4UECcTBMO/5zc1IVjqnaD5
	/CO+8AMlJze+NDr6Ckcde5ycSzKa61b6USBkNNiJgzHMTxwWczO+ukc+z+0oZR/Y
	j9OsbqB6IVVeLFblz0p0sqmVk+kN2WNM9cRQHQ5Eql3QTKzcaQydkVw/0ERByIpo
	AT8s7CqxOA0cql1IdYsaQWdwMWceLo8qcVTdB/1b77VWIdPxmEwiRz3riQ6P+5zA
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ckskcrmvx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Mar 2026 22:07:06 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 622HQe1o010305;
	Mon, 2 Mar 2026 22:07:05 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cmc6jysjx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Mar 2026 22:07:05 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 622M73So24642288
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 Mar 2026 22:07:04 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DC4BD58050;
	Mon,  2 Mar 2026 22:07:03 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E34055805E;
	Mon,  2 Mar 2026 22:07:01 +0000 (GMT)
Received: from [9.61.253.18] (unknown [9.61.253.18])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  2 Mar 2026 22:07:01 +0000 (GMT)
Message-ID: <6df57227-4fe9-4e6c-a169-3e28cb534518@linux.ibm.com>
Date: Mon, 2 Mar 2026 14:07:01 -0800
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
        wintera@linux.ibm.com, ts@linux.ibm.com, oberpar@linux.ibm.com,
        gbayer@linux.ibm.com, Alex Williamson <alex@shazbot.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <skolothumtho@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>
Cc: mjrosato@linux.ibm.com, raspl@linux.ibm.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-pci@vger.kernel.org
References: <20260224-vfio_pci_ism-v2-0-f010945373fa@linux.ibm.com>
 <20260224-vfio_pci_ism-v2-2-f010945373fa@linux.ibm.com>
Content-Language: en-US
From: Farhan Ali <alifm@linux.ibm.com>
In-Reply-To: <20260224-vfio_pci_ism-v2-2-f010945373fa@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: inGojawel2g7ijeoAQY36aFvaqTUiEpm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDE2MiBTYWx0ZWRfX94ZfC/2Veu2c
 OZbOh+ZWXKE9bSu2iqaAHtCHiZioIImMe8Ecmb6bU7wDUSB/Cjq/fip7wOHklAsWhBkMo88e5Uz
 rhwEJ4uyHotLselgtc6k3hKYqTJKH6hbiRKIHj/LUYa39AIDv0AW7agj4iMYcM7nlkxDFPzaxC0
 RUNz+HqOuJp5ZxbSJBKI59rXIf/2MUwGuBwibfJplI7OH1B2TOdoeMh8xmUcvVN9ex3hF6uhYq6
 VSgACTzopCj/pdwqn1UcwD0YnqZxVfJEICZxyHRL7Lk4/qm1Qd6zsNA+7Pa+NluZHRknzeNPxoH
 DBn6KSOddE3SGepNkD/gKaVoPMGwHcjUJ+mWM7QpLZaytNgzDxOHek9LqqKTmrTyZt4TEgRK9Ry
 TLEFYjKsLaLBRj8KYtL71+PHq8qVhfioE3+g8ECiSTwL5jI5qftHyQ0snLnbt0C36N/uuFdTpUH
 q612ck+lObgpPJdbTuQ==
X-Authority-Analysis: v=2.4 cv=H7DWAuYi c=1 sm=1 tr=0 ts=69a60a0a cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=iXc_gk3ecELjrQ0JrgkA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: inGojawel2g7ijeoAQY36aFvaqTUiEpm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 phishscore=0 clxscore=1011 priorityscore=1501
 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603020162
X-Rspamd-Queue-Id: A0EB61E5EF5
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[20];
	TAGGED_FROM(0.00)[bounces-72425-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alifm@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Action: no action

<..snip..>

On 2/24/2026 4:34 AM, Julian Ruess wrote:
> +static const struct pci_device_id ism_device_table[] = {
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_IBM,
> +					  PCI_DEVICE_ID_IBM_ISM) },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(pci, ism_device_table);
> +
> +static struct pci_driver ism_vfio_pci_driver = {
> +	.name = KBUILD_MODNAME,
> +	.id_table = ism_device_table,
> +	.probe = ism_vfio_pci_probe,
> +	.remove = ism_vfio_pci_remove,
> +	.driver_managed_dma = true,
> +};

I think we should also define an err_handler callback for the driver? 
IIUC this driver will also be the default driver for passthrough ISM 
devices and it wouldn't support the basic error recovery we do with vfio 
today. I think we can set the err_handler to vfio_pci_core_err_handlers 
as we don't need anything specific for error recovery for ISM devices.

Thanks

Farhan


> +
> +module_pci_driver(ism_vfio_pci_driver);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("vfio-pci variant driver for the IBM Internal Shared Memory (ISM) device");
> +MODULE_AUTHOR("IBM Corporation");
>
> -- 

