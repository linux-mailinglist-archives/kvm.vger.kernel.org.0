Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8F8A58899E
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 11:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235631AbiHCJqO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 05:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232303AbiHCJqM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 05:46:12 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C72918B22;
        Wed,  3 Aug 2022 02:46:11 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2739OgQL005580;
        Wed, 3 Aug 2022 09:46:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=L5SXeILL+cADSClDKSrDEjrCd0p4L2lZX5Oeb6kPn0M=;
 b=gPAkCMBMnLPCDX6omSWo58aIc4AMe3Gu/HRNM45D5E42qQ6ZUKrNdhguvVLF9BVjvX9w
 rUntzWUB9hSlVCgOetoPtLu9GlziC80AdTbAImy3ZqmkM0f/I2dpLymZSRNJyBF+BdbE
 MchC1pT36dp79oSznRsvDvL/kVC/fmKNBHEkNStcgaqwUkoniMjwj/eDJuyQiJDQwd4k
 IdHdGPh+XJaKyUViQWcqducUGfwS8LdD+oa8m1VoFv5xtr24ytgond/LulZvySCaWVET
 rh6QJcsHpd/0afcbowdmMvokMOiVukF+EE0q5wtbATHPAv8o25Tz/dwWtHhqeiVgS3Yu Sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hqpc5gjba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 09:46:10 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2739Ogg1005564;
        Wed, 3 Aug 2022 09:46:10 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hqpc5gjaj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 09:46:09 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2739ZiVx006956;
        Wed, 3 Aug 2022 09:46:08 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3hmuwhvryu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 09:46:08 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2739k4tS22479180
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 Aug 2022 09:46:05 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D92C1A4054;
        Wed,  3 Aug 2022 09:46:04 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 638BEA405C;
        Wed,  3 Aug 2022 09:46:04 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.1.230])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  3 Aug 2022 09:46:04 +0000 (GMT)
Date:   Wed, 3 Aug 2022 11:46:02 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v3] s390x: uv-host: Add access checks for
 donated memory
Message-ID: <20220803114602.5359a8a4@p-imbrenda>
In-Reply-To: <20220725130859.48740-1-frankja@linux.ibm.com>
References: <20220707111912.51ecc0f2@p-imbrenda>
        <20220725130859.48740-1-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mvOMMXvaDq55fGcJaSi8Utn9vVfiP_u2
X-Proofpoint-GUID: GzBHZjreVctGfYL6WOTbxId_DL1xLXeg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_03,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 spamscore=0 lowpriorityscore=0 adultscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 clxscore=1015 impostorscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208030044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 25 Jul 2022 13:08:59 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Let's check if the UV really protected all the memory we donated.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/uv-host.c | 37 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
> 
> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
> index dfcebe10..ba6c9008 100644
> --- a/s390x/uv-host.c
> +++ b/s390x/uv-host.c
> @@ -45,6 +45,32 @@ static void cpu_loop(void)
>  	for (;;) {}
>  }
>  
> +/*
> + * Checks if a memory area is protected as secure memory.
> + * Will return true if all pages are protected, false otherwise.
> + */
> +static bool access_check_3d(uint64_t *access_ptr, uint64_t len)
> +{
> +	assert(!(len & ~PAGE_MASK));
> +	assert(!((uint64_t)access_ptr & ~PAGE_MASK));
> +
> +	while (len) {
> +		expect_pgm_int();
> +		READ_ONCE(*access_ptr);
> +		if (clear_pgm_int() != PGM_INT_CODE_SECURE_STOR_ACCESS)
> +			return false;
> +		expect_pgm_int();
> +		WRITE_ONCE(*access_ptr, 42);
> +		if (clear_pgm_int() != PGM_INT_CODE_SECURE_STOR_ACCESS)
> +			return false;
> +
> +		access_ptr += PAGE_SIZE / sizeof(access_ptr);

this looks ugly, although in principle the correct way to handle a
pointer. In this specific case it's techically wrong though (you
actually want sizeof(*access_ptr) )

what about making access_ptr a char*?

then you can do just

	access_ptr += PAGE_SIZE;

and you can keep the READ_ONCE and WRITE_ONCE as they are

> +		len -= PAGE_SIZE;
> +	}
> +
> +	return true;
> +}
> +
>  static struct cmd_list cmds[] = {
>  	{ "init", UVC_CMD_INIT_UV, sizeof(struct uv_cb_init), BIT_UVC_CMD_INIT_UV },
>  	{ "create conf", UVC_CMD_CREATE_SEC_CONF, sizeof(struct uv_cb_cgc), BIT_UVC_CMD_CREATE_SEC_CONF },
> @@ -332,6 +358,10 @@ static void test_cpu_create(void)
>  	report(rc == 0 && uvcb_csc.header.rc == UVC_RC_EXECUTED &&
>  	       uvcb_csc.cpu_handle, "success");
>  
> +	rc = access_check_3d((uint64_t *)uvcb_csc.stor_origin,
> +			     uvcb_qui.cpu_stor_len);
> +	report(rc, "Storage protection");
> +
>  	tmp = uvcb_csc.stor_origin;
>  	uvcb_csc.stor_origin = (unsigned long)memalign(PAGE_SIZE, uvcb_qui.cpu_stor_len);
>  	rc = uv_call(0, (uint64_t)&uvcb_csc);
> @@ -430,6 +460,13 @@ static void test_config_create(void)
>  	rc = uv_call(0, (uint64_t)&uvcb_cgc);
>  	report(rc == 0 && uvcb_cgc.header.rc == UVC_RC_EXECUTED, "successful");
>  
> +	rc = access_check_3d((uint64_t *)uvcb_cgc.conf_var_stor_origin, vsize);
> +	report(rc, "Base storage protection");
> +
> +	rc = access_check_3d((uint64_t *)uvcb_cgc.conf_base_stor_origin,
> +			     uvcb_qui.conf_base_phys_stor_len);
> +	report(rc, "Variable storage protection");
> +
>  	uvcb_cgc.header.rc = 0;
>  	uvcb_cgc.header.rrc = 0;
>  	tmp = uvcb_cgc.guest_handle;

