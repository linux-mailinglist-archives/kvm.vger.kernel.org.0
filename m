Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 589DE45A1B0
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 12:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236324AbhKWLo6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 06:44:58 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36262 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229939AbhKWLo5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Nov 2021 06:44:57 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ANAkmKX034909;
        Tue, 23 Nov 2021 11:41:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Kq3al4We2gODy88OVolahDTCFHMijeoBWgn9Uy3hzm4=;
 b=gwRJxWPrvHuEwZLWln0t9XFwdGT3gFZEmRSNNL0A74H5k4WKc1Cy2twyhmaFdKioM/qq
 lauPpEZkNh/ojlRdGmJbBZ/pN9q3nnDSndktPMXuhSwhBWVHOQokD/oVeBMuaPYiqUpH
 FOk4KmhRTa7iZjN2+MPN8RMu6EpUamIywoVaYYNvgur0bNVT+FM5SyWjphRTgNv23M2W
 DYVY/dYcPy2j6KsfVZOyDzcM8aeaqOir14HS4tk4e+DkyI3kagCB5OdIeQpDFkNHd+LX
 mGVyPId+My0AIejZXR95p/AWFUzRK83i1gWy2e8GrHA3EPYLmBSsWO5DJFh3iMMhm2Lc vA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cgxun133u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 11:41:48 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1ANBLjLQ038257;
        Tue, 23 Nov 2021 11:41:48 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cgxun1339-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 11:41:48 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ANBd8xw014013;
        Tue, 23 Nov 2021 11:41:46 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3cernaq990-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 11:41:45 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ANBYXv750790696
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 11:34:33 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6ABC011C066;
        Tue, 23 Nov 2021 11:41:42 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F244B11C05E;
        Tue, 23 Nov 2021 11:41:41 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.4.158])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Nov 2021 11:41:41 +0000 (GMT)
Date:   Tue, 23 Nov 2021 11:52:49 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, seiden@linux.ibm.com, mhartmay@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 2/8] s390x: sie: Add PV fields to SIE
 control block
Message-ID: <20211123115249.4c8e1f2a@p-imbrenda>
In-Reply-To: <20211123103956.2170-3-frankja@linux.ibm.com>
References: <20211123103956.2170-1-frankja@linux.ibm.com>
        <20211123103956.2170-3-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: L6tR0kKgyYepF9S4tj-S2Gv8vl2U5_17
X-Proofpoint-GUID: NUSO31I-Z3V73im2nSX1b8Lr7CMrqig5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-23_04,2021-11-23_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 spamscore=0 adultscore=0 clxscore=1011 mlxscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111230063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 Nov 2021 10:39:50 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> We need those fields for format 4 SIE tests (protected VMs).
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/sie.h | 41 ++++++++++++++++++++++++++++++++++-------
>  1 file changed, 34 insertions(+), 7 deletions(-)
> 
> diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
> index f34e3c80..c6eb6441 100644
> --- a/lib/s390x/sie.h
> +++ b/lib/s390x/sie.h
> @@ -38,7 +38,13 @@ struct kvm_s390_sie_block {
>  	uint8_t		reserved08[4];		/* 0x0008 */
>  #define PROG_IN_SIE (1<<0)
>  	uint32_t	prog0c;			/* 0x000c */
> -	uint8_t		reserved10[16];		/* 0x0010 */
> +union {
> +		uint8_t	reserved10[16];		/* 0x0010 */
> +		struct {
> +			uint64_t	pv_handle_cpu;
> +			uint64_t	pv_handle_config;
> +		};
> +	};
>  #define PROG_BLOCK_SIE	(1<<0)
>  #define PROG_REQUEST	(1<<1)
>  	uint32_t 	prog20;		/* 0x0020 */
> @@ -87,10 +93,22 @@ struct kvm_s390_sie_block {
>  #define ICPT_PARTEXEC	0x38
>  #define ICPT_IOINST	0x40
>  #define ICPT_KSS	0x5c
> +#define ICPT_INT_ENABLE	0x64
> +#define ICPT_PV_INSTR	0x68
> +#define ICPT_PV_NOTIFY	0x6c
> +#define ICPT_PV_PREF	0x70
>  	uint8_t		icptcode;		/* 0x0050 */
>  	uint8_t		icptstatus;		/* 0x0051 */
>  	uint16_t	ihcpu;			/* 0x0052 */
> -	uint8_t		reserved54[2];		/* 0x0054 */
> +	uint8_t		reserved54;		/* 0x0054 */
> +#define IICTL_CODE_NONE		 0x00
> +#define IICTL_CODE_MCHK		 0x01
> +#define IICTL_CODE_EXT		 0x02
> +#define IICTL_CODE_IO		 0x03
> +#define IICTL_CODE_RESTART	 0x04
> +#define IICTL_CODE_SPECIFICATION 0x10
> +#define IICTL_CODE_OPERAND	 0x11
> +	uint8_t		iictl;			/* 0x0055 */
>  	uint16_t	ipa;			/* 0x0056 */
>  	uint32_t	ipb;			/* 0x0058 */
>  	uint32_t	scaoh;			/* 0x005c */
> @@ -112,7 +130,7 @@ struct kvm_s390_sie_block {
>  #define ECB3_RI  0x01
>  	uint8_t    	ecb3;			/* 0x0063 */
>  	uint32_t	scaol;			/* 0x0064 */
> -	uint8_t		reserved68;		/* 0x0068 */
> +	uint8_t		sdf;			/* 0x0068 */
>  	uint8_t    	epdx;			/* 0x0069 */
>  	uint8_t    	reserved6a[2];		/* 0x006a */
>  	uint32_t	todpr;			/* 0x006c */
> @@ -128,9 +146,15 @@ struct kvm_s390_sie_block {
>  #define HPID_KVM	0x4
>  #define HPID_VSIE	0x5
>  	uint8_t		hpid;			/* 0x00b8 */
> -	uint8_t		reservedb9[11];		/* 0x00b9 */
> -	uint16_t	extcpuaddr;		/* 0x00c4 */
> -	uint16_t	eic;			/* 0x00c6 */
> +	uint8_t		reservedb9[7];		/* 0x00b9 */
> +	union {
> +		struct {
> +			uint32_t	eiparams;	/* 0x00c0 */
> +			uint16_t	extcpuaddr;	/* 0x00c4 */
> +			uint16_t	eic;		/* 0x00c6 */
> +		};
> +		uint64_t	mcic;			/* 0x00c0 */
> +	} __attribute__ ((__packed__));
>  	uint32_t	reservedc8;		/* 0x00c8 */
>  	uint16_t	pgmilc;			/* 0x00cc */
>  	uint16_t	iprcc;			/* 0x00ce */
> @@ -152,7 +176,10 @@ struct kvm_s390_sie_block {
>  #define CRYCB_FORMAT2 0x00000003
>  	uint32_t	crycbd;			/* 0x00fc */
>  	uint64_t	gcr[16];		/* 0x0100 */
> -	uint64_t	gbea;			/* 0x0180 */
> +	union {
> +		uint64_t	gbea;			/* 0x0180 */
> +		uint64_t	sidad;
> +	};
>  	uint8_t		reserved188[8];		/* 0x0188 */
>  	uint64_t   	sdnxo;			/* 0x0190 */
>  	uint8_t    	reserved198[8];		/* 0x0198 */

