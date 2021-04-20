Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 915BF365C99
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 17:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232929AbhDTPsn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 11:48:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64732 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232504AbhDTPsm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 11:48:42 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13KFZFYs129806;
        Tue, 20 Apr 2021 11:48:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=JPotTaZ5vCwkEmEovJx8O3SJ4HDPi2NAPz9sDay49qY=;
 b=l5kfAmA2c5KH5/khytFzkQ8wA5Pbprpn9pm7W6GeZOF8SiKmpzj929c6wESPrwDgXxNe
 R1C6sHGcVNJrpFujWqmQTSJVUDEzgP8xvMADSLdf16cvmqsgLJdFHmaqhuYQRuq60IJl
 uhpJMho2dELepxdfK/259h8MC0kQurjgixhfgtI7/NWGqeGwpUR1EFAcm7xEFwlv3k5b
 oyeb74nqlnfJsX81zg5eb7DwFOzQ6mgwjj4z5Tqhmz9b0z+4+ti7KIwX17j3kMKzJZRu
 muM130vRicn884RLgPLE0G3t0w6/KThWWx04CsUfcqiTf4OdkimOd5ED42IcH8L/4j5V YA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 381x5ufse3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Apr 2021 11:48:10 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13KFYrqr127617;
        Tue, 20 Apr 2021 11:48:10 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 381x5ufsde-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Apr 2021 11:48:10 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13KFm8Av018239;
        Tue, 20 Apr 2021 15:48:08 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 37yqa8ht9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Apr 2021 15:48:08 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13KFm6dI40567098
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Apr 2021 15:48:06 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1312E4C050;
        Tue, 20 Apr 2021 15:48:06 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BCD6A4C04E;
        Tue, 20 Apr 2021 15:48:05 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.0.91])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 20 Apr 2021 15:48:05 +0000 (GMT)
Date:   Tue, 20 Apr 2021 16:26:49 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com
Subject: Re: [kvm-unit-tests PATCH 5/6] s390x: uv-guest: Test invalid
 commands
Message-ID: <20210420162649.4f9b77a6@ibm-vm>
In-Reply-To: <20210316091654.1646-6-frankja@linux.ibm.com>
References: <20210316091654.1646-1-frankja@linux.ibm.com>
        <20210316091654.1646-6-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: sQkvA78nqKmKkVpk_lTY1DofCBlidr57
X-Proofpoint-GUID: jWfZNwXHG5p7EqJR6nwGiL6nijPFGdek
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-20_07:2021-04-20,2021-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0
 suspectscore=0 impostorscore=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104200114
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 16 Mar 2021 09:16:53 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Let's check if the commands that are not indicated as available
> produce a invalid command error.

you say this, but you don't actually check that the commands are
actually reported as unavailable

> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/uv-guest.c | 44 +++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 37 insertions(+), 7 deletions(-)
> 
> diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
> index 8915b2f1..517e3c66 100644
> --- a/s390x/uv-guest.c
> +++ b/s390x/uv-guest.c
> @@ -120,16 +120,46 @@ static void test_sharing(void)
>  	report_prefix_pop();
>  }
>  
> +static struct {
> +	const char *name;
> +	uint16_t cmd;
> +	uint16_t len;
> +} invalid_cmds[] = {
> +	{ "bogus", 0x4242, sizeof(struct uv_cb_header) },
> +	{ "init", UVC_CMD_INIT_UV, sizeof(struct uv_cb_init) },
> +	{ "create conf", UVC_CMD_CREATE_SEC_CONF, sizeof(struct
> uv_cb_cgc) },
> +	{ "destroy conf", UVC_CMD_DESTROY_SEC_CONF, sizeof(struct
> uv_cb_nodata) },
> +	{ "create cpu", UVC_CMD_CREATE_SEC_CPU, sizeof(struct
> uv_cb_csc) },
> +	{ "destroy cpu", UVC_CMD_DESTROY_SEC_CPU, sizeof(struct
> uv_cb_nodata) },
> +	{ "conv to", UVC_CMD_CONV_TO_SEC_STOR, sizeof(struct
> uv_cb_cts) },
> +	{ "conv from", UVC_CMD_CONV_FROM_SEC_STOR, sizeof(struct
> uv_cb_cfs) },
> +	{ "set sec conf", UVC_CMD_SET_SEC_CONF_PARAMS, sizeof(struct
> uv_cb_ssc) },
> +	{ "unpack", UVC_CMD_UNPACK_IMG, sizeof(struct uv_cb_unp) },
> +	{ "verify", UVC_CMD_VERIFY_IMG, sizeof(struct uv_cb_nodata)
> },
> +	{ "cpu reset", UVC_CMD_CPU_RESET, sizeof(struct
> uv_cb_nodata) },
> +	{ "cpu initial reset", UVC_CMD_CPU_RESET_INITIAL,
> sizeof(struct uv_cb_nodata) },
> +	{ "conf clear reset", UVC_CMD_PERF_CONF_CLEAR_RESET,
> sizeof(struct uv_cb_nodata) },
> +	{ "cpu clear reset", UVC_CMD_CPU_RESET_CLEAR, sizeof(struct
> uv_cb_nodata) },
> +	{ "cpu set state", UVC_CMD_CPU_SET_STATE, sizeof(struct
> uv_cb_cpu_set_state) },
> +	{ "pin shared", UVC_CMD_PIN_PAGE_SHARED, sizeof(struct
> uv_cb_cfs) },
> +	{ "unpin shared", UVC_CMD_UNPIN_PAGE_SHARED, sizeof(struct
> uv_cb_cts) },
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

here you just blindly loop over all the commands, without checking
their actual availability

> +	for (i = 0; invalid_cmds[i].name; i++) {

maybe you can add another field for the availability bit (or even put
them in the right order so the bit is the index) and here add something
like

if (uv_query_test_feature(i))
	continue;

so you will be sure the command is not available

> +		hdr->cmd = invalid_cmds[i].cmd;
> +		hdr->len = invalid_cmds[i].len;
> +		cc = uv_call(0, (u64)hdr);
> +		report(cc == 1 && hdr->rc == UVC_RC_INV_CMD, "%s",
> +		       invalid_cmds[i].name);
> +	}
> +	report_prefix_pop();
>  }
>  
>  int main(void)

