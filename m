Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F207E6CC1C8
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 16:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232766AbjC1OOX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 10:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbjC1OOV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 10:14:21 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95346CC0D;
        Tue, 28 Mar 2023 07:13:39 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32SDWMNq015465;
        Tue, 28 Mar 2023 14:13:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=dzzcA/WQ7WZwWBQ+RpT1wvuz570NK9wVKmUOXD1/hJk=;
 b=FBpLIKOOt1XXkzM9scKWSR5Z+j237EZu1X8byAZijC74ayUTb8Jd+/Z/Em8kxy0H58pP
 PMnyt5Pw4XvLxbRiMg95zV+KIm6xkUNVXf82eXq5G1tyvyooUpePDJO3NBMGH5gRbBjY
 +JCVv4k6bwBT8/SxFeljA3CkJICO4idtpjs2lBvF+N/Fjg/PceRp0cPSmWsG5wab+va9
 ROlaWFp05UWlic+z9oXVg7RpIftj3ypykttQJoWi23YbreoloFcZc8ZGP2GhECanD6eT
 4YdqVgWgAJPQB6k+stB/thtwtovwnBReUcT/cS8OlguEeMEAuQSo8++OzI+bBzeALphh RQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pm177sfqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Mar 2023 14:13:10 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32SDXFJD022379;
        Tue, 28 Mar 2023 14:13:10 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pm177sfpc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Mar 2023 14:13:10 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32S4dJYB010672;
        Tue, 28 Mar 2023 14:13:08 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3phr7fuftm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Mar 2023 14:13:08 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32SED5T527132610
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Mar 2023 14:13:05 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 028392004E;
        Tue, 28 Mar 2023 14:13:05 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B127720040;
        Tue, 28 Mar 2023 14:13:04 +0000 (GMT)
Received: from [9.179.1.68] (unknown [9.179.1.68])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 28 Mar 2023 14:13:04 +0000 (GMT)
Message-ID: <afcf5186-c3f2-d777-be5f-408318039f2d@linux.ibm.com>
Date:   Tue, 28 Mar 2023 16:13:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, imbrenda@linux.ibm.com,
        thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230327082118.2177-1-nrb@linux.ibm.com>
 <20230327082118.2177-2-nrb@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 1/4] s390x: sie: switch to home space
 mode before entering SIE
In-Reply-To: <20230327082118.2177-2-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ydDKxu80fzuESgSFWwBsJ61SfTj-YZHV
X-Proofpoint-ORIG-GUID: enmTvZwD1l6tmX6rNJO3e-HZntLoEiSZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-28_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303280111
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/27/23 10:21, Nico Boehr wrote:
> This is to prepare for running guests without MSO/MSL, which is
> currently not possible.
> 
> We already have code in sie64a to setup a guest primary ASCE before
> entering SIE, so we can in theory switch to the page tables which
> translate gpa to hpa.
> 
> But the host is running in primary space mode already, so changing the
> primary ASCE before entering SIE will also affect the host's code and
> data.
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
[...]
> +	/* set up home address space to match primary space */
> +	old_cr13 = stctg(13);
> +	lctlg(13, stctg(1));
> +
> +	/* switch to home space so guest tables can be different from host */
> +	psw_mask_set_bits(PSW_MASK_HOME);
> +
> +	/* also handle all interruptions in home space while in SIE */
> +	lowcore.pgm_new_psw.mask |= PSW_MASK_DAT_HOME;

> +	lowcore.ext_new_psw.mask |= PSW_MASK_DAT_HOME;
> +	lowcore.io_new_psw.mask |= PSW_MASK_DAT_HOME;
We didn't enable DAT in these two cases as far as I can see so this is 
superfluous or we should change the mmu code. Also it's missing the svc 
and machine check.

The whole bit manipulation thing looks a bit crude. It might make more 
sense to drop into real mode for a few instructions and have a dedicated 
storage location for an extended PSW mask and an interrupt ASCE as part 
of the interrupt call code instead.

Opinions?

> +	mb();
> +
>   	while (vm->sblk->icptcode == 0) {
>   		sie64a(vm->sblk, &vm->save_area);
>   		sie_handle_validity(vm);
> @@ -60,6 +75,17 @@ void sie(struct vm *vm)
>   	vm->save_area.guest.grs[14] = vm->sblk->gg14;
>   	vm->save_area.guest.grs[15] = vm->sblk->gg15;
>   
> +	lowcore.pgm_new_psw.mask &= ~PSW_MASK_HOME;
> +	lowcore.ext_new_psw.mask &= ~PSW_MASK_HOME;
> +	lowcore.io_new_psw.mask &= ~PSW_MASK_HOME;
> +	mb();
> +
> +	psw_mask_clear_bits(PSW_MASK_HOME);
> +
> +	/* restore the old CR 13 */
> +	lctlg(13, old_cr13);
> +
> +
>   	if (vm->sblk->sdf == 2)
>   		memcpy(vm->save_area.guest.grs, vm->sblk->pv_grregs,
>   		       sizeof(vm->save_area.guest.grs));
> diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
> index 147cb0f2a556..0b00fb709776 100644
> --- a/lib/s390x/sie.h
> +++ b/lib/s390x/sie.h
> @@ -284,5 +284,6 @@ void sie_handle_validity(struct vm *vm);
>   void sie_guest_sca_create(struct vm *vm);
>   void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t guest_mem_len);
>   void sie_guest_destroy(struct vm *vm);
> +bool sie_had_pgm_int(struct vm *vm);
>   
>   #endif /* _S390X_SIE_H_ */

