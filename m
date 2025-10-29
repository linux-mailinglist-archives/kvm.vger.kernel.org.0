Return-Path: <kvm+bounces-61407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E061C1C3CF
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 17:51:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B574F5A491A
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 16:33:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A7572F0676;
	Wed, 29 Oct 2025 16:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tniaFuJp"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B6D2F0C6F;
	Wed, 29 Oct 2025 16:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761755578; cv=none; b=U8EMeL2Sp7JzP5xvS+2Kc2QqKS8SOWXm/Cbl56iyYSn4MTF91l6IKlx36W6TngE53MX9RoUS8jm3jkzm/T07rJX2i4BYKSUubpmyt8bO1Y8e7rS+IkLx3AqidNAGNH4J5nXFVcYWdWb8bgsp+Bt1YnmT0uebr3j9yP/hDALakZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761755578; c=relaxed/simple;
	bh=7IQeSGwPOqTO7jWGk962mBxUJYCy7pPJe+iho7a0ghE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RaoxeQZG4cglWcaQ/LfcLVV4BSgtwTZ7JSLXXeRGVfsEZrhjh6+rFNku9sb0fA/fdVw8pdMIywEoBth+VejjhgYkSh+3vBoDzPuBYEP4DpY6y00eZc28Xo5PceYm4+mMyvJdNJ5j7VGGUCnEu0S1v/zIX+OObhqtjEWoUZwG3Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tniaFuJp; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59TC2Dp3026032;
	Wed, 29 Oct 2025 16:32:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=14YbyJ
	fLp/xusokbv9KzpdzRIDFWEkavJbiiTdXNqjQ=; b=tniaFuJpdVbjgnCNxniOAl
	t2qRDtGlEsRiJlrLzlV+4BYbRVyxQuM/d7FVsS/igCDHLr7g2d/LsPur4zYxyxyM
	YDQSSIOIqK+plMAQI6TS1pXpHH0er5Xl5YWNgWOasJoYYRzvhfnQ+f4wNs3yWjGQ
	YJtPJN0gOup7OF2XLCQjxHDN4tG8ao9TE5ldNZYDw5CdAp+OjLbUPequjVkeayH7
	PTcjiU/G+mQszZtOiDAJ8SmbkjYnvSVyuzFBqcbYkVWwIv38FeVwjfMpfAE52sZJ
	w7KTv9wZZQtIjzqQjPL8N1aVwmymW1H+V9fR/VDjEGC3tQ6yiomd/3HtHtHELHjA
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a34aam8sg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Oct 2025 16:32:55 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59TDcHWg030714;
	Wed, 29 Oct 2025 16:32:55 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4a33wwmcc4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Oct 2025 16:32:55 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59TGWpD716318838
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Oct 2025 16:32:51 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 260D12004B;
	Wed, 29 Oct 2025 16:32:51 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D3B1620043;
	Wed, 29 Oct 2025 16:32:50 +0000 (GMT)
Received: from [9.111.53.31] (unknown [9.111.53.31])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 29 Oct 2025 16:32:50 +0000 (GMT)
Message-ID: <1d167707-c946-46d7-8a12-a97b4a31a0ec@linux.ibm.com>
Date: Wed, 29 Oct 2025 17:32:50 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: s390: Add capability that forwards operation
 exceptions
To: Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
References: <20251029130744.6422-1-frankja@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20251029130744.6422-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=ALkgKXG8 c=1 sm=1 tr=0 ts=690241b7 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=R39a7-YhG-dWXkH9HqAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: UsFpsk1XddFCUdFeRQVY5Vo_OeOCj7yy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI4MDE2NiBTYWx0ZWRfX+MXdqiUOlQK+
 0UqQSuk7H4aUMG3eZy2lTDli9GUyn64sXtZHJ4Dmf3gwCtOqXGe69IZ4XtYe6wva2L7k496MpdH
 hND2Ba8F/R9/foy8b5EoXwwi2R4FFTYn5uR5N9WzNW/XbECGnCYKxPC1iWRN9SVfFRgF3QyxhWu
 QhOzkZLYLP+VNQ8zfopyyaE8VI6w/XEZLuY0BYvkLoGlNWYXTkDMaAh3IX3ef9o+OpFpPbxuTNj
 l9IVeIQa04fzH0GUvV8C05nFsSTMRj1pUa+GZM9ZsS/4Vs+2h22LMmgBExuzJbcfoNy6WTFb+mB
 N4O7ZYBpHYXFuvPEnqrjfbM4wqUQlIezfbzJQPwF4FEP/71x05YuXWMFIiPuclTzVgUHoby4lNp
 qOxWLa0ONoWiVWfFEUHlBbZAma+5NA==
X-Proofpoint-GUID: UsFpsk1XddFCUdFeRQVY5Vo_OeOCj7yy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-29_06,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 impostorscore=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2510280166

Am 29.10.25 um 14:04 schrieb Janosch Frank:
> Setting KVM_CAP_S390_USER_OPEREXEC will forward all operation
> exceptions to user space. This also includes the 0x0000 instructions
> managed by KVM_CAP_S390_USER_INSTR0. It's helpful if user space wants
> to emulate instructions which do not (yet) have an opcode.
> 
> While we're at it refine the documentation for
> KVM_CAP_S390_USER_INSTR0.

An alternative would be to add a flag to KVM_CAP_S390_USER_INSTR0, but I am not sure if this
has any real benefit or downside.> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

But this looks good,

Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>


