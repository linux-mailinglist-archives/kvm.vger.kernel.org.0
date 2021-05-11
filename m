Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C29D37ACC7
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 19:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbhEKRNS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 13:13:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10768 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231230AbhEKRNR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 13:13:17 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14BH3jJ7122889;
        Tue, 11 May 2021 13:12:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=f6cE/r5SIT0mTzPM7k0IeWzsRyiE8OtV/7Z553FS4x8=;
 b=L/I4NMHWAG0WK9Cn3A4eFro/49+co5G1AGI12sQBQ5qmKfjP/ONuYUZ2l2hKrb8pnPAi
 tudc613jufmewmn8hW0eaAyCyWDlJRk8Yuqmr2ynUytqwcMQ2oCP9lXPLliqE4nKCF6w
 aqb5IC+0UKtvhTAyMSmUSyIvqEqD0oQEb7XysyKSqBloTM20g75k5xy1EJRc2YUI+Mep
 C3DlNnI2/YNFmNDrmFv1rjOcG3vHAf7hd7tSvSGG0nDgEYnytaMMOIALxs7ud2RyMhKZ
 t3Kq11LduNlWk3pBaDpUNrvbm947pbJIFDX4mNvoWUNTW6YR3SWOwo5ezxzxfXS6r2sV ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38fvu2ajna-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 13:12:11 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14BH4G4D129200;
        Tue, 11 May 2021 13:12:10 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38fvu2ajmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 13:12:10 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14BGveHA022106;
        Tue, 11 May 2021 17:12:08 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 38dj989skk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 17:12:08 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14BHBduk38076764
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 17:11:39 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C3037A4054;
        Tue, 11 May 2021 17:12:05 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6AB11A4060;
        Tue, 11 May 2021 17:12:05 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.13.244])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 May 2021 17:12:05 +0000 (GMT)
Date:   Tue, 11 May 2021 19:12:03 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 5/6] s390x: uv-guest: Test invalid
 commands
Message-ID: <20210511191203.79a08cbf@ibm-vm>
In-Reply-To: <20210510135148.1904-6-frankja@linux.ibm.com>
References: <20210510135148.1904-1-frankja@linux.ibm.com>
        <20210510135148.1904-6-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2H_RJ0QGmZt8HphTlA_Kq3Nou4T2g91e
X-Proofpoint-GUID: BKKTPps-wFo57TbfF_zyUVzFszfPLxgN
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-11_04:2021-05-11,2021-05-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 spamscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 phishscore=0 clxscore=1015 adultscore=0 priorityscore=1501 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110118
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 10 May 2021 13:51:47 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Let's check if the UV calls that should not be available in a
> protected guest 2 are actually not available. Also let's check if they
> are falsely indicated to be available.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

but see below for a nit

> ---
>  s390x/uv-guest.c | 46 +++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 39 insertions(+), 7 deletions(-)
> 
> diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
> index e99029a7..ce2ef79b 100644
> --- a/s390x/uv-guest.c
> +++ b/s390x/uv-guest.c
> @@ -121,16 +121,48 @@ static void test_sharing(void)
>  	report_prefix_pop();
>  }
>  
> +static struct {
> +	const char *name;
> +	uint16_t cmd;
> +	uint16_t len;
> +	int call_bit;
> +} invalid_cmds[] = {
> +	{ "bogus", 0x4242, sizeof(struct uv_cb_header), -1 },
> +	{ "init", UVC_CMD_INIT_UV, sizeof(struct uv_cb_init),
> BIT_UVC_CMD_INIT_UV },
> +	{ "create conf", UVC_CMD_CREATE_SEC_CONF, sizeof(struct
> uv_cb_cgc), BIT_UVC_CMD_CREATE_SEC_CONF },
> +	{ "destroy conf", UVC_CMD_DESTROY_SEC_CONF, sizeof(struct
> uv_cb_nodata), BIT_UVC_CMD_DESTROY_SEC_CONF },
> +	{ "create cpu", UVC_CMD_CREATE_SEC_CPU, sizeof(struct
> uv_cb_csc), BIT_UVC_CMD_CREATE_SEC_CPU },
> +	{ "destroy cpu", UVC_CMD_DESTROY_SEC_CPU, sizeof(struct
> uv_cb_nodata), BIT_UVC_CMD_DESTROY_SEC_CPU },
> +	{ "conv to", UVC_CMD_CONV_TO_SEC_STOR, sizeof(struct
> uv_cb_cts), BIT_UVC_CMD_CONV_TO_SEC_STOR },
> +	{ "conv from", UVC_CMD_CONV_FROM_SEC_STOR, sizeof(struct
> uv_cb_cfs), BIT_UVC_CMD_CONV_FROM_SEC_STOR },
> +	{ "set sec conf", UVC_CMD_SET_SEC_CONF_PARAMS, sizeof(struct
> uv_cb_ssc), BIT_UVC_CMD_SET_SEC_PARMS },
> +	{ "unpack", UVC_CMD_UNPACK_IMG, sizeof(struct uv_cb_unp),
> BIT_UVC_CMD_UNPACK_IMG },
> +	{ "verify", UVC_CMD_VERIFY_IMG, sizeof(struct uv_cb_nodata),
> BIT_UVC_CMD_VERIFY_IMG },
> +	{ "cpu reset", UVC_CMD_CPU_RESET, sizeof(struct
> uv_cb_nodata), BIT_UVC_CMD_CPU_RESET },
> +	{ "cpu initial reset", UVC_CMD_CPU_RESET_INITIAL,
> sizeof(struct uv_cb_nodata), BIT_UVC_CMD_CPU_RESET_INITIAL },
> +	{ "conf clear reset", UVC_CMD_PERF_CONF_CLEAR_RESET,
> sizeof(struct uv_cb_nodata), BIT_UVC_CMD_PREPARE_CLEAR_RESET },
> +	{ "cpu clear reset", UVC_CMD_CPU_RESET_CLEAR, sizeof(struct
> uv_cb_nodata), BIT_UVC_CMD_CPU_PERFORM_CLEAR_RESET },
> +	{ "cpu set state", UVC_CMD_CPU_SET_STATE, sizeof(struct
> uv_cb_cpu_set_state), BIT_UVC_CMD_CPU_SET_STATE },
> +	{ "pin shared", UVC_CMD_PIN_PAGE_SHARED, sizeof(struct
> uv_cb_cfs), BIT_UVC_CMD_PIN_PAGE_SHARED },
> +	{ "unpin shared", UVC_CMD_UNPIN_PAGE_SHARED, sizeof(struct
> uv_cb_cts), BIT_UVC_CMD_UNPIN_PAGE_SHARED },
> +	{ NULL, 0, 0 },
> +};
> +
>  static void test_invalid(void)
>  {
> -	struct uv_cb_header uvcb = {
> -		.len = 16,
> -		.cmd = 0x4242,
> -	};
> -	int cc;
> +	struct uv_cb_header *hdr = (void *)page;
> +	int cc, i;
>  
> -	cc = uv_call(0, (u64)&uvcb);
> -	report(cc == 1 && uvcb.rc == UVC_RC_INV_CMD, "invalid
> command");
> +	report_prefix_push("invalid");
> +	for (i = 0; invalid_cmds[i].name; i++) {
> +		hdr->cmd = invalid_cmds[i].cmd;
> +		hdr->len = invalid_cmds[i].len;
> +		cc = uv_call(0, (u64)hdr);
> +		report(cc == 1 && hdr->rc == UVC_RC_INV_CMD &&
> +		       invalid_cmds[i].call_bit == -1 ? true :
> !uv_query_test_call(invalid_cmds[i].call_bit),

maybe this is more readable:

(invalid_cmds[i].call_bit == -1 ||
 !uv_query_test_call(invalid_cmds[i].call_bit))

> +		       "%s", invalid_cmds[i].name);
> +	}
> +	report_prefix_pop();
>  }
>  
>  int main(void)

