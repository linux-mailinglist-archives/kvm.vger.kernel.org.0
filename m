Return-Path: <kvm+bounces-493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37BBF7E0474
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 15:14:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 72114B21444
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 14:14:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A590E19466;
	Fri,  3 Nov 2023 14:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Rl39bsEW"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C5118C2A
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 14:14:16 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37EA1B9;
	Fri,  3 Nov 2023 07:14:15 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A3EBWU3010631;
	Fri, 3 Nov 2023 14:14:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=07VcEgIX04u09j4bgmH1b6x0AqhnB/w3j9JJb/QxZF8=;
 b=Rl39bsEWu6gVBiHLAKNJ018ck5ajQZwLj4fU8KnQI4yxHMObrbedTXs76ZS4aj1K8euX
 +7dx5DYXQO3MtKbG17NKYFdnqP5ESIeF3KaGE9k1An+QWRJWtBXSKObkZQ5xApeXEJQ9
 i94pk72+tA6TPeVuLButfmEbaVQxksN7UwJEBw/D3w29sGGoVmg0kEb0mKc0gj4e3Cg2
 9do2B0lS35Ww0WccZ55+pwlFQn8wafSdSR2Ene7GiCvaathJD5ERGbogGzKV75cI8RNx
 87EzxsyI/HfxoTICei5klISKLpSvsUtsPXAy7PWKbtVc26TexjgKDW5rG7APrjkmaU1K PQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u5160ug3u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 14:14:15 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A3EC9ro015648;
	Fri, 3 Nov 2023 14:14:15 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u5160ug3c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 14:14:15 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A3D8l5H011310;
	Fri, 3 Nov 2023 14:14:14 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u1eukp23s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 14:14:14 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A3EEBkE19792542
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 3 Nov 2023 14:14:11 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 450672004B;
	Fri,  3 Nov 2023 14:14:11 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2369220043;
	Fri,  3 Nov 2023 14:14:11 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  3 Nov 2023 14:14:11 +0000 (GMT)
Date: Fri, 3 Nov 2023 14:48:50 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Nico Boehr <nrb@linux.ibm.com>
Cc: frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v7 5/8] s390x: lib: sie: don't reenter
 SIE on pgm int
Message-ID: <20231103144850.3f823ce0@p-imbrenda>
In-Reply-To: <20231103092954.238491-6-nrb@linux.ibm.com>
References: <20231103092954.238491-1-nrb@linux.ibm.com>
	<20231103092954.238491-6-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Cscv7kxJIqBbgETHRl-PQPTXrgVVCHQE
X-Proofpoint-GUID: rt87BMu3iC6S5mpI6B9N_YEaX1g_Ea9a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-03_13,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 spamscore=0 clxscore=1015 impostorscore=0 mlxscore=0 bulkscore=0
 mlxlogscore=687 lowpriorityscore=0 malwarescore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311030120

On Fri,  3 Nov 2023 10:29:34 +0100
Nico Boehr <nrb@linux.ibm.com> wrote:

[...]

> diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
> index d01f8a89641a..7f73d473b346 100644
> --- a/lib/s390x/asm/interrupt.h
> +++ b/lib/s390x/asm/interrupt.h
> @@ -97,4 +97,18 @@ static inline void low_prot_disable(void)
>  	ctl_clear_bit(0, CTL0_LOW_ADDR_PROT);
>  }
>  
> +/**
> + * read_pgm_int_code - Get the program interruption code of the last pgm int
> + * on the current CPU.
> + *
> + * This is similar to clear_pgm_int(), except that it doesn't clear the
> + * interruption information from lowcore.
> + *
> + * Returns 0 when none occurred.

 * Return:

with that fixed:

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

[...]

