Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5DF345A1B6
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 12:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236340AbhKWLpE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 06:45:04 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36598 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236331AbhKWLpC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Nov 2021 06:45:02 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AN9VxOX013908;
        Tue, 23 Nov 2021 11:41:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=X/6ikPeTuWrbpkJ7gHg5XjJDLhhXtQCAnMox6JbDQLY=;
 b=dwz7agqdM96YTByPfDGaXAZ2ApCf/KqAGU0L4I+GepS+5WKVOy6RKGQcMpUmzKCTewWD
 n5jaxGXIN0+18gsqXhHnIqndrJjaArgLyokoujOAL9yvW6yrnVntlI7o5ZeWEh41+OmO
 KdIlSZzr+1MCRks0+fA3DY/6OSkTLIkB9khVryBB8slaJTij81OLR+I0nnRQcZcpzOs6
 4cJSFXpDP0RWR8p4sX8pmnMKZO2c5auvNeOqG4K21ziLGa6gv1nVpZCcbV+bl7BQ9Op3
 u5UWsbsS+8LaotsW84hyCwXv+p3VcROoXTDiR2r1NB6zC9GTKu+tzUG/CBaERpSX+F4i zQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cgqcd0yh5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 11:41:54 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1ANBYFn9005415;
        Tue, 23 Nov 2021 11:41:53 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cgqcd0ygv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 11:41:53 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ANBd1Sr024339;
        Tue, 23 Nov 2021 11:41:52 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3cer9jqcuk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 11:41:52 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ANBYePm58851608
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 11:34:40 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B08111C04A;
        Tue, 23 Nov 2021 11:41:49 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B659911C058;
        Tue, 23 Nov 2021 11:41:48 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.4.158])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Nov 2021 11:41:48 +0000 (GMT)
Date:   Tue, 23 Nov 2021 12:14:18 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, seiden@linux.ibm.com, mhartmay@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 6/8] lib: s390: sie: Add PV guest
 register handling
Message-ID: <20211123121418.4f4e7888@p-imbrenda>
In-Reply-To: <20211123103956.2170-7-frankja@linux.ibm.com>
References: <20211123103956.2170-1-frankja@linux.ibm.com>
        <20211123103956.2170-7-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1hKqR5dFHw_GxgM7npdqjoYY5yYrWqwf
X-Proofpoint-ORIG-GUID: vIY8X_O3Sw2KClGQJNcmeyjyS7xm_O9d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-23_04,2021-11-23_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 impostorscore=0 clxscore=1015
 mlxscore=0 priorityscore=1501 mlxlogscore=999 adultscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111230064
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 Nov 2021 10:39:54 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Protected guests have their registers stored to / loaded from offset 0x380
> of the sie control block. So we need to copy over the GRs to/from that
> offset for format 4 (PV) guests before and after we enter SIE.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/sie.c | 8 ++++++++
>  lib/s390x/sie.h | 2 ++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
> index 51d3b94e..00aff713 100644
> --- a/lib/s390x/sie.c
> +++ b/lib/s390x/sie.c
> @@ -44,6 +44,10 @@ void sie_handle_validity(struct vm *vm)
>  
>  void sie(struct vm *vm)
>  {
> +	if (vm->sblk->sdf == 2)
> +		memcpy(vm->sblk->pv_grregs, vm->save_area.guest.grs,
> +		       sizeof(vm->save_area.guest.grs));
> +
>  	/* Reset icptcode so we don't trip over it below */
>  	vm->sblk->icptcode = 0;
>  
> @@ -53,6 +57,10 @@ void sie(struct vm *vm)
>  	}
>  	vm->save_area.guest.grs[14] = vm->sblk->gg14;
>  	vm->save_area.guest.grs[15] = vm->sblk->gg15;
> +
> +	if (vm->sblk->sdf == 2)
> +		memcpy(vm->save_area.guest.grs, vm->sblk->pv_grregs,
> +		       sizeof(vm->save_area.guest.grs));
>  }
>  
>  void sie_guest_sca_create(struct vm *vm)
> diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
> index 6d209793..de91ea5a 100644
> --- a/lib/s390x/sie.h
> +++ b/lib/s390x/sie.h
> @@ -198,6 +198,8 @@ union {
>  	uint64_t	itdba;			/* 0x01e8 */
>  	uint64_t   	riccbd;			/* 0x01f0 */
>  	uint64_t	gvrd;			/* 0x01f8 */
> +	uint64_t	reserved200[48];	/* 0x0200 */
> +	uint64_t	pv_grregs[16];		/* 0x0380 */
>  } __attribute__((packed));
>  
>  struct vm_uv {

