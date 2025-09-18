Return-Path: <kvm+bounces-58010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FC64B853E4
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 16:30:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE8E456271E
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 14:24:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9872F311C2A;
	Thu, 18 Sep 2025 14:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TrwZjWrG"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCA2220686;
	Thu, 18 Sep 2025 14:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758205158; cv=none; b=h7/vHpNmRS+HWDjZ9vC2JdUbJrVFZzpKoBgs1aigZhQy6/uvEKgPLxfR7O2nZ8hTDg+tzbSceZxdo79T2SGE4kLuvUd4BEX5LUZHuANiMI2vJFSXInaUl+LY/L5Mz3UJHiQb8GHYG4mvxyujaQeQbJShb4HER6Maea1vVndVhvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758205158; c=relaxed/simple;
	bh=5q7uBa8PkaVEZgQ1xOcWTLo2Ls+KbcGA2jyqi+n0z7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZWM+yx8rF+SZiTFIn5o5w3xxHw7h38jq/uq+BTKeZYBqsll05OvF4cP6/4wvNhhtkjzb9ZKezAY99Pm8p97f0q9MTSdUuG63SRTD63og6u11+ISHz5QwMwUSfFkDFX6kGdWn8oX0UY5mkMPw6QaGEuvvvXgWkQqEsspbIT1qAMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TrwZjWrG; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58I7ZloY000601;
	Thu, 18 Sep 2025 14:19:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=hhGFsb0T4xoqcvNcpsCg/Pj4hFw5tm
	Tgo0dLHx4/IA4=; b=TrwZjWrG5w7+uWccNNMLRnlCKyzlwIYtWb12gV/u43J8Nx
	3ShD+3hNh9nZzQUzL/ny+Do0X6lGZn9V3QHwto+KNKu6PLgSYdbXzci5u669Lg49
	oxrmAn+FMJM+10Pmc8gSycZ6gCWpIxSLKK1H0z2rXmAsY76IS3aJc2sbmrXNA69w
	QFMxmRg1w63cNiLWxzFDofDbn0L4dhl6ZNowJubA0yFFxUyqLEs1Su1pxAZez0CX
	SUkmaZTGtf+kvaExoMkymyCRVC5AVOFww9604aBTxfw1yKKD9HuMkzVP79ff45Kk
	U0vwTt2oYx+RcFSZduP4V9nYezaa0RyMcVKxv3Mw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 498dtwj0t5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Sep 2025 14:19:13 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58IAmDPr022290;
	Thu, 18 Sep 2025 14:19:13 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 495kxpy19w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Sep 2025 14:19:13 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58IEJ96414287356
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 14:19:09 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 356B420043;
	Thu, 18 Sep 2025 14:19:09 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C0AC620040;
	Thu, 18 Sep 2025 14:19:08 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.155.204.135])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 18 Sep 2025 14:19:08 +0000 (GMT)
Date: Thu, 18 Sep 2025 16:19:07 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com, schlameuss@linux.ibm.com, hca@linux.ibm.com,
        svens@linux.ibm.com, david@redhat.com, gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v2 05/20] KVM: s390: Add helper functions for fault
 handling
Message-ID: <a4998d82-223f-4894-888d-bf97ef8c78d0-agordeev@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
 <20250910180746.125776-6-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910180746.125776-6-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=EYvIQOmC c=1 sm=1 tr=0 ts=68cc14e1 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=PLhQFr6zaicG7cuCuYgA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: sa8Dl87Do7zndAwS0_S9TOv4gGjEjCse
X-Proofpoint-GUID: sa8Dl87Do7zndAwS0_S9TOv4gGjEjCse
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE4MDA2NSBTYWx0ZWRfX50vgQQD/tFrh
 cKE/snH0IPhA+uICqqu8RCbb8jS3JsOj1LX6klL8y/fjA+F5P81q4bvTubYCIzUQvOhMN0GUxux
 pAMfET2kXr69udpUOOhvHvfG2Su+S7Ccf6CRwSjqTL+nrzlKxjpXGxhR1GyY9cv2mXVCMmc0qaM
 W1G2Rn/mV+Ztbvjn0yFQzOF3Jc1V1MgmwdxccUSVYZBu7QEbAjo9Lj7vgvmWnkmXoa15A4rEZBn
 A97cMABW1H85m/OymVzAuiByn7FaivQOa5tDpC1nrFwpV5NiRyORP7p/5fXzTReG1MsZTxnptep
 xP+knQuEZOWG5ObEzFw8m6J9kQzglzrU6LCq6ebYukHfP5ETj4MuB5sjx8WJY7XtLCT05mtA3S3
 aIuvJsEv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-18_01,2025-09-18_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1011 suspectscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509180065

On Wed, Sep 10, 2025 at 08:07:31PM +0200, Claudio Imbrenda wrote:
> +static inline int __kvm_s390_faultin_read_gpa(struct kvm *kvm, struct guest_fault *f, gpa_t gaddr,
> +					      unsigned long *val)
> +{
> +	phys_addr_t phys_addr;
> +	int rc;
> +
> +	rc = __kvm_s390_faultin_gfn(kvm, f, gpa_to_gfn(gaddr), false);
> +	if (!rc) {
> +		phys_addr = PFN_PHYS(f->pfn) | offset_in_page(gaddr);

                            pfn_to_phys() is more consistent with the phys_to_virt() below ;)

> +		*val = *(unsigned long *)phys_to_virt(phys_addr);
> +	}
> +	return rc;
> +}
> +
>  #endif /* __KVM_S390_GACCESS_H */
...
> +static inline void release_faultin_multiple(struct kvm *kvm, struct guest_fault *guest_faults,
> +					    int n, bool ignore)
> +{
> +	int i;
> +
> +	for (i = 0; i < n; i++) {
> +		kvm_release_faultin_page(kvm, guest_faults[i].page, ignore,
> +					 guest_faults[i].write_attempt);
> +		guest_faults[i].page = NULL;
> +	}
> +}
> +
> +static inline bool __kvm_s390_multiple_faults_need_retry(struct kvm *kvm, unsigned long seq,
> +							 struct guest_fault *guest_faults, int n,
> +							 bool unsafe)
> +{
> +	int i;
> +
> +	for (i = 0; i < n; i++) {
> +		if (!guest_faults[i].valid)
> +			continue;
> +		if ((unsafe && mmu_invalidate_retry_gfn_unsafe(kvm, seq, guest_faults[i].gfn)) ||
> +		    (!unsafe && mmu_invalidate_retry_gfn(kvm, seq, guest_faults[i].gfn))) {
> +			release_faultin_multiple(kvm, guest_faults, n, true);


Calling release_faultin_multiple() on the whole range, before all gfns invalidated?
Tolerate invalidation of entries that are (!guest_faults[i].valid)? But then why the
continue above?

This function is a mistery to me, but that is - I am sure - due to my KVM ignorance...

> +			return true;
> +		}
> +	}
> +	return false;
> +}
> +
> +static inline int __kvm_s390_faultin_gfn_range(struct kvm *kvm, struct guest_fault *guest_faults,
> +					       gfn_t start, int n_pages, bool write_attempt)
> +{
> +	int i, rc = 0;
> +
> +	for (i = 0; !rc && i < n_pages; i++)

Unless n_pages could ever be zero, the below reads better.

> +		rc = __kvm_s390_faultin_gfn(kvm, guest_faults + i, start + i, write_attempt);

		if (rc)
			break;

> +	return rc;
> +}
...

Thanks!

