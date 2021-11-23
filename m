Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAFC45A1BA
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 12:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236383AbhKWLpK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 06:45:10 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47736 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236302AbhKWLpI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Nov 2021 06:45:08 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ANBHCNe032392;
        Tue, 23 Nov 2021 11:42:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=TjLoZFIxjwp3Xi3HmEZe05sdK4UwRvXhQYlYwN7sWAQ=;
 b=O2ow3ZntJFCtuqv38PS73eeNcX3PsJgo3yFVUAniyrsueA5ChF5K1XriqsckqcKnAryJ
 VdSN8Cbet/2nttKgEFqiuekWRsXjRSZF71WG54IbGVfyJiVwzfR3wuQHmZtjDfPu1lWV
 3mK+klw4zsXV3C6DnwErdQgG+Lbd71heoCO/5CTav+wssdW626+TuMJMhjej7NqPx2dC
 Oyv4ElaP4u60je05o/cEKBwagPw7Ye6WwNk59eaR8bhF1vBfInKGBWCiUvXBp7xYizp9
 gO7EhB2IkRuPd3U+o3alz+kQgOvZQ/G7MGt1B+P0eMVltJN3TQKI+DXLX+3udcE0Hy9o zA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cgy9vgdqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 11:42:00 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1ANBWXvb019982;
        Tue, 23 Nov 2021 11:41:59 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cgy9vgdq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 11:41:59 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ANBd4o4024454;
        Tue, 23 Nov 2021 11:41:57 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3cer9jqcv9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 11:41:57 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ANBfsXo30146898
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 11:41:54 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E20E11C069;
        Tue, 23 Nov 2021 11:41:54 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96CC811C070;
        Tue, 23 Nov 2021 11:41:53 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.4.158])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Nov 2021 11:41:53 +0000 (GMT)
Date:   Tue, 23 Nov 2021 11:56:43 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, seiden@linux.ibm.com, mhartmay@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 4/8] s390x: uv: Add more UV call
 functions
Message-ID: <20211123115643.57829808@p-imbrenda>
In-Reply-To: <20211123103956.2170-5-frankja@linux.ibm.com>
References: <20211123103956.2170-1-frankja@linux.ibm.com>
        <20211123103956.2170-5-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mameacX7cGcpj--Xz0C33Zes7UNkJ3g-
X-Proofpoint-ORIG-GUID: DjjJ58qmE8AXSNEN3w4SWrFvpDgYkHfs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-23_04,2021-11-23_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111230064
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 Nov 2021 10:39:52 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> To manage protected guests we need a few more UV calls:
>    * import / export
>    * destroy page
>    * set SE header
>    * set cpu state
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/asm/uv.h | 85 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 85 insertions(+)
> 
> diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
> index 8baf896f..6e331211 100644
> --- a/lib/s390x/asm/uv.h
> +++ b/lib/s390x/asm/uv.h
> @@ -33,6 +33,7 @@
>  #define UVC_CMD_DESTROY_SEC_CPU		0x0121
>  #define UVC_CMD_CONV_TO_SEC_STOR	0x0200
>  #define UVC_CMD_CONV_FROM_SEC_STOR	0x0201
> +#define UVC_CMD_DESTR_SEC_STOR		0x0202
>  #define UVC_CMD_SET_SEC_CONF_PARAMS	0x0300
>  #define UVC_CMD_UNPACK_IMG		0x0301
>  #define UVC_CMD_VERIFY_IMG		0x0302
> @@ -256,6 +257,63 @@ static inline int uv_remove_shared(unsigned long addr)
>  	return share(addr, UVC_CMD_REMOVE_SHARED_ACCESS);
>  }
>  
> +static inline int uv_cmd_nodata(uint64_t handle, uint16_t cmd, uint16_t *rc, uint16_t *rrc)
> +{
> +	struct uv_cb_nodata uvcb = {
> +		.header.cmd = cmd,
> +		.header.len = sizeof(uvcb),
> +		.handle = handle,
> +	};
> +	int cc;
> +
> +	assert(handle);
> +	cc = uv_call(0, (uint64_t)&uvcb);
> +	*rc = uvcb.header.rc;
> +	*rrc = uvcb.header.rrc;
> +	return cc;
> +}
> +
> +static inline int uv_import(uint64_t handle, unsigned long gaddr)
> +{
> +	struct uv_cb_cts uvcb = {
> +		.header.cmd = UVC_CMD_CONV_TO_SEC_STOR,
> +		.header.len = sizeof(uvcb),
> +		.guest_handle = handle,
> +		.gaddr = gaddr,
> +	};
> +
> +	return uv_call(0, (uint64_t)&uvcb);
> +}
> +
> +static inline int uv_export(unsigned long paddr)
> +{
> +	struct uv_cb_cfs uvcb = {
> +		.header.cmd = UVC_CMD_CONV_FROM_SEC_STOR,
> +		.header.len = sizeof(uvcb),
> +		.paddr = paddr
> +	};
> +
> +	return uv_call(0, (u64)&uvcb);
> +}
> +
> +/*
> + * Requests the Ultravisor to destroy a guest page and make it
> + * accessible to the host. The destroy clears the page instead of
> + * exporting.
> + *
> + * @paddr: Absolute host address of page to be destroyed
> + */
> +static inline int uv_destroy_page(unsigned long paddr)
> +{
> +	struct uv_cb_cfs uvcb = {
> +		.header.cmd = UVC_CMD_DESTR_SEC_STOR,
> +		.header.len = sizeof(uvcb),
> +		.paddr = paddr
> +	};
> +
> +	return uv_call(0, (uint64_t)&uvcb);
> +}
> +
>  struct uv_cb_cpu_set_state {
>  	struct uv_cb_header header;
>  	u64 reserved08[2];
> @@ -270,4 +328,31 @@ struct uv_cb_cpu_set_state {
>  #define PV_CPU_STATE_CHKSTP	3
>  #define PV_CPU_STATE_OPR_LOAD	5
>  
> +static inline int uv_set_cpu_state(uint64_t handle, uint8_t state)
> +{
> +	struct uv_cb_cpu_set_state uvcb = {
> +		.header.cmd = UVC_CMD_CPU_SET_STATE,
> +		.header.len = sizeof(uvcb),
> +		.cpu_handle = handle,
> +		.state = state,
> +	};
> +
> +	assert(handle);
> +	return uv_call(0, (uint64_t)&uvcb);
> +}
> +
> +static inline int uv_set_se_hdr(uint64_t handle, void *hdr, size_t len)
> +{
> +	struct uv_cb_ssc uvcb = {
> +		.header.cmd = UVC_CMD_SET_SEC_CONF_PARAMS,
> +		.header.len = sizeof(uvcb),
> +		.sec_header_origin = (uint64_t)hdr,
> +		.sec_header_len = len,
> +		.guest_handle = handle,
> +	};
> +
> +	assert(handle);
> +	return uv_call(0, (uint64_t)&uvcb);
> +}
> +
>  #endif

