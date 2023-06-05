Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39F6D7221B1
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 11:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbjFEJDb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 05:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjFEJD3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 05:03:29 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C527199;
        Mon,  5 Jun 2023 02:03:27 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3558qbg5017256;
        Mon, 5 Jun 2023 09:03:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=huYYXU8WTeOaiiUjj+/dTgKB1kjZU3fvDUrMeny2c0A=;
 b=OqoIuMqWYBiXC6xdkrPFYj8hW+iIbafNBCPJRiGHTcU1mwug+sdf3y23mxTYT44R7Dro
 Jc0EiznjnYwQGBzGlsqBZKYeA5V/3ce5QLoes0rzS8GodY8TtOAKFO1XYQG81lSbQW/i
 LQe62meMtA0voU40iqyX5pcJxXktDlox0G7z2/nwAIcTvrxK74LplobmwvUEP4XuHbP1
 ZLv+TQbkqsKt55KdZqwk4HR7xpg4P0oeyQ+pSEyfHAFtOjsEvphk7PqcUiSD7zwQhBO2
 J44vTCwIvMgsIm5/qomyxzMg8eYdxNuM4qX45y3LmWTTDagILx1LtZ3OAUFYKPv5bAQw dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r1cju08r3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 09:03:26 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3558s1xN020980;
        Mon, 5 Jun 2023 09:03:26 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r1cju08qc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 09:03:26 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3550sfFk016654;
        Mon, 5 Jun 2023 09:03:23 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3qyxbu901r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 09:03:23 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35593K2a24379962
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Jun 2023 09:03:20 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 109B62004D;
        Mon,  5 Jun 2023 09:03:20 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B935120043;
        Mon,  5 Jun 2023 09:03:19 +0000 (GMT)
Received: from [9.171.39.161] (unknown [9.171.39.161])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  5 Jun 2023 09:03:19 +0000 (GMT)
Message-ID: <ecbaf984-a3b7-1681-b3f9-e8ce86121f8d@linux.ibm.com>
Date:   Mon, 5 Jun 2023 11:03:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, imbrenda@linux.ibm.com,
        thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230601070202.152094-1-nrb@linux.ibm.com>
 <20230601070202.152094-4-nrb@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 3/6] s390x: sie: switch to home space
 mode before entering SIE
In-Reply-To: <20230601070202.152094-4-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: il71Zz5fhjRKXlqkWXyUATh7lB81uL7X
X-Proofpoint-ORIG-GUID: 0GRG7Wy3Dvhs04WW0xQGHyw-CdaX0SRR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-03_08,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 clxscore=1015 impostorscore=0 phishscore=0 spamscore=0 suspectscore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306050081
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/1/23 09:01, Nico Boehr wrote:
> This is to prepare for running guests without MSO/MSL, which is
> currently not possible.

This is a preparation patch for non-MSO/MSL guest support.

> 
> We already have code in sie64a to setup a guest primary ASCE before
> entering SIE, so we can in theory switch to the page tables which
> translate gpa to hpa.

The important information that's missing here is that SIE always uses 
the prim space for guest to host translations.

> 
> But the host is running in primary space mode already, so changing the
> primary ASCE before entering SIE will also affect the host's code and
> data.

And that's why this is an issue.

For the time being we'll copy the primary ASCE into the home space ASCE. 
No functional change is intended. But if a test intends to....

> 
> To make this switch useful, the host should run in a different address
> space mode. Hence, set up and change to home address space mode before
> installing the guest ASCE.
> 
> The home space ASCE is just copied over from the primary space ASCE, so
> no functional change is intended, also for tests that want to use
> MSO/MSL. If a test intends to use a different primary space ASCE, it can
> now just set the guest.asce in the save_area.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   lib/s390x/asm/arch_def.h |  1 +
>   lib/s390x/sie.c          | 18 ++++++++++++++++++
>   2 files changed, 19 insertions(+)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 84f6996c4d8c..099289e7550e 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -90,6 +90,7 @@ struct cpu {
>   #define AS_HOME				3
>   
>   #define PSW_MASK_DAT			0x0400000000000000UL
> +#define PSW_MASK_HOME			0x0000C00000000000UL
>   #define PSW_MASK_IO			0x0200000000000000UL
>   #define PSW_MASK_EXT			0x0100000000000000UL
>   #define PSW_MASK_KEY			0x00F0000000000000UL
> diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
> index 9241b4b4a512..ffa8ec91a423 100644
> --- a/lib/s390x/sie.c
> +++ b/lib/s390x/sie.c
> @@ -46,6 +46,8 @@ void sie_handle_validity(struct vm *vm)
>   
>   void sie(struct vm *vm)
>   {
> +	uint64_t old_cr13;
> +
>   	if (vm->sblk->sdf == 2)
>   		memcpy(vm->sblk->pv_grregs, vm->save_area.guest.grs,
>   		       sizeof(vm->save_area.guest.grs));
> @@ -53,6 +55,16 @@ void sie(struct vm *vm)
>   	/* Reset icptcode so we don't trip over it below */
>   	vm->sblk->icptcode = 0;
>   
> +	/* set up home address space to match primary space */
> +	old_cr13 = stctg(13);
> +	lctlg(13, stctg(1));
> +
> +	/* switch to home space so guest tables can be different from host */
> +	psw_mask_set_bits(PSW_MASK_HOME);
> +
> +	/* also handle all interruptions in home space while in SIE */
> +	irq_set_dat_mode(IRQ_DAT_ON, AS_HOME);

I'm wondering why this needs to be two calls when you clearly want to 
have a convenience function that does a full space change.

We could introduce:

#define AS_REAL 4

static void mmu_set_addr_space(uint8_t space)
{
	if (space < 4)
		psw_mask_set_bits(space);
	irq_set_dat_mode(space);
}

The "addr" in the function name is optional in my opinion.
@Claudio: What's your opinion?

> +
>   	while (vm->sblk->icptcode == 0) {
>   		sie64a(vm->sblk, &vm->save_area);
>   		sie_handle_validity(vm);
> @@ -60,6 +72,12 @@ void sie(struct vm *vm)
>   	vm->save_area.guest.grs[14] = vm->sblk->gg14;
>   	vm->save_area.guest.grs[15] = vm->sblk->gg15;
>   
> +	irq_set_dat_mode(IRQ_DAT_ON, AS_PRIM);
> +	psw_mask_clear_bits(PSW_MASK_HOME);
> +
> +	/* restore the old CR 13 */
> +	lctlg(13, old_cr13);
> +
>   	if (vm->sblk->sdf == 2)
>   		memcpy(vm->save_area.guest.grs, vm->sblk->pv_grregs,
>   		       sizeof(vm->save_area.guest.grs));

