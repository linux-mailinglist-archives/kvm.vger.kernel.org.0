Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E069764828F
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 13:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbiLIMr6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 07:47:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiLIMr4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 07:47:56 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A03F23E8E;
        Fri,  9 Dec 2022 04:47:55 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B9CFUKo022393;
        Fri, 9 Dec 2022 12:47:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=soxIt6cUquCeTNSAbrMSQAEcvR5vm+ZbNFOKQrTRtu8=;
 b=ADSTGcyTTEIgS8F/7GE5844tcF0DkcDI6lA1O9GSeiBccC/2FYk64LrI17TGH+8qQy6F
 2AmOxlgtkrlmXjHtk/tHsQhMhsvkFOhHexRJHNvix/sL4oVcVfwB19ck9n6ikSnNlxO4
 anLoTr7HT4h6sO5VnPzaOAgDZ9rVanmcOlbBxO02JF/MKZOQD/RNI91qDjZANiVZShrP
 DLR+0WTPHB2QQ3Uy0H0V6PMxcLTHT1xx/yQ6KMXn0im8HO4cWFWValbyrMZAhWWxLysK
 HdTR1tr4as8ml5Nsmf5l4ZeLSJ0GmP0BQ4yTLgC4iuLZ+Gzw/ZsOtlDVCBUFRlonGetb 9A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mc29ycc1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Dec 2022 12:47:54 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B9CN6uQ014888;
        Fri, 9 Dec 2022 12:47:54 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mc29ycc0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Dec 2022 12:47:54 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2B9C2Z2w016506;
        Fri, 9 Dec 2022 12:47:51 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3m9m5y5yn6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Dec 2022 12:47:51 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B9Cln0c43778428
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 9 Dec 2022 12:47:49 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D93220043;
        Fri,  9 Dec 2022 12:47:49 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 126B520040;
        Fri,  9 Dec 2022 12:47:49 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.67.167])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
        Fri,  9 Dec 2022 12:47:48 +0000 (GMT)
Date:   Fri, 9 Dec 2022 13:47:47 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        linux-s390@vger.kernel.org, David Hildenbrand <david@redhat.com>
Subject: Re: [kvm-unit-tests v2 PATCH] s390x: sie: Test whether the epoch
 extension field is working as expected
Message-ID: <20221209134747.489ccf94@p-imbrenda>
In-Reply-To: <20221208170502.17984-1-thuth@redhat.com>
References: <20221208170502.17984-1-thuth@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TTMsNvqnlphQF0Ff_DeufyEkRz77qqn8
X-Proofpoint-GUID: O2ZJj9yeQDYAd-tFzYvyCJ6p_5GtaQr_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_07,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 adultscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015 phishscore=0
 bulkscore=0 mlxscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212090098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  8 Dec 2022 18:05:02 +0100
Thomas Huth <thuth@redhat.com> wrote:

> We recently discovered a bug with the time management in nested scenarios
> which got fixed by kernel commit "KVM: s390: vsie: Fix the initialization
> of the epoch extension (epdx) field". This adds a simple test for this
> bug so that it is easier to determine whether the host kernel of a machine
> has already been fixed or not.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  v2: Remove the spurious "2" from the diag 44 opcode
> 
>  s390x/sie.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff --git a/s390x/sie.c b/s390x/sie.c
> index 87575b29..cd3cea10 100644
> --- a/s390x/sie.c
> +++ b/s390x/sie.c
> @@ -58,6 +58,33 @@ static void test_diags(void)
>  	}
>  }
>  
> +static void test_epoch_ext(void)
> +{
> +	u32 instr[] = {
> +		0xb2780000,	/* STCKE 0 */
> +		0x83000044	/* DIAG 0x44 to intercept */
> +	};
> +
> +	if (!test_facility(139)) {
> +		report_skip("epdx: Multiple Epoch Facility is not available");
> +		return;
> +	}
> +
> +	guest[0] = 0x00;
> +	memcpy(guest_instr, instr, sizeof(instr));
> +
> +	vm.sblk->gpsw.addr = PAGE_SIZE * 2;
> +	vm.sblk->gpsw.mask = PSW_MASK_64;
> +
> +	vm.sblk->ecd |= ECD_MEF;
> +	vm.sblk->epdx = 0x47;	/* Setting the epoch extension here ... */
> +
> +	sie(&vm);
> +
> +	/* ... should result in the same epoch extension here: */
> +	report(guest[0] == 0x47, "epdx: different epoch is visible in the guest");
> +}
> +
>  static void setup_guest(void)
>  {
>  	setup_vm();
> @@ -80,6 +107,7 @@ int main(void)
>  
>  	setup_guest();
>  	test_diags();
> +	test_epoch_ext();
>  	sie_guest_destroy(&vm);
>  
>  done:

