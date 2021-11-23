Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C40EA45A1BC
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 12:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236379AbhKWLpM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 06:45:12 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33906 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236352AbhKWLpK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Nov 2021 06:45:10 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ANBH8sR032103;
        Tue, 23 Nov 2021 11:42:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=T4LUQFJr/WJaDgzr4WF6CIMTXenpMXE+tBCAswMerfQ=;
 b=qiRLC2R2otCVityYsxy/TJLNr03/y9N9itpDBdQ6ZTlZ8qSVi+esOBk3fL3beM31GvX2
 Y2Ofhqba4X8VpoXItZTAeH/i1r1gnWTj9VA0ymxTxRK/f16w0xJl4CtecbQBzDHiY0Le
 fLZsjENIoToXL8tJoPzwz9HBLLKPfj42AaqWh0e8kvJmJQGoGIdHi4j8VFMdxNLTaFoJ
 ijz0PIiBk38Bu2N+NM6N50gKU+JVpmQ92CE2KV0mIq9jgSX579t9UbqFLtuRil/yEEHS
 AId5oGkDkyB0goLbtEZ/oHEwvBoqVjX0qS1WB3fCoc5lDpHWyKgvvgfhHNhBB1V6mwi0 5Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cgy9v0fp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 11:42:01 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1ANBIOls005529;
        Tue, 23 Nov 2021 11:42:01 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cgy9v0fnj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 11:42:01 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ANBcsTA007558;
        Tue, 23 Nov 2021 11:41:59 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3cern9y9ra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 11:41:59 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ANBYlC137159206
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 11:34:47 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6AAC411C054;
        Tue, 23 Nov 2021 11:41:56 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0841C11C04C;
        Tue, 23 Nov 2021 11:41:56 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.4.158])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Nov 2021 11:41:55 +0000 (GMT)
Date:   Tue, 23 Nov 2021 11:54:47 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, seiden@linux.ibm.com, mhartmay@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 3/8] s390x: sie: Add UV information into
 VM struct
Message-ID: <20211123115447.25d9ab9c@p-imbrenda>
In-Reply-To: <20211123103956.2170-4-frankja@linux.ibm.com>
References: <20211123103956.2170-1-frankja@linux.ibm.com>
        <20211123103956.2170-4-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HNsz9kWdptxkdRcNmqJcGx2yoT1pw3it
X-Proofpoint-ORIG-GUID: d1iViBmQrsKN5N_3YeLVOWECprUtdxOg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-23_04,2021-11-23_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 impostorscore=0 suspectscore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111230064
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 Nov 2021 10:39:51 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> We need to save the handles for the VM and the VCPU so we can retrieve
> them easily after their creation. Since the SIE lib is single guest

multiple guest CPUs will be needed for testing some functions, but I
guess that's something for me to do :)

> cpu only we only save one vcpu handle.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/sie.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
> index c6eb6441..1a12faa7 100644
> --- a/lib/s390x/sie.h
> +++ b/lib/s390x/sie.h
> @@ -200,6 +200,11 @@ union {
>  	uint64_t	gvrd;			/* 0x01f8 */
>  } __attribute__((packed));
>  
> +struct vm_uv {
> +	uint64_t vm_handle;
> +	uint64_t vcpu_handle;
> +};
> +
>  struct vm_save_regs {
>  	uint64_t grs[16];
>  	uint64_t fprs[16];
> @@ -220,6 +225,7 @@ struct vm {
>  	struct vm_save_area save_area;
>  	void *sca;				/* System Control Area */
>  	uint8_t *crycb;				/* Crypto Control Block */
> +	struct vm_uv uv;			/* PV UV information */
>  	/* Ptr to first guest page */
>  	uint8_t *guest_mem;
>  };

