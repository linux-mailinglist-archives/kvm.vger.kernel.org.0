Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38CB251C05E
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 15:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378824AbiEENUd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 09:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354075AbiEENU0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 09:20:26 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5093A2D1F5;
        Thu,  5 May 2022 06:16:47 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 245DBWdx008219;
        Thu, 5 May 2022 13:16:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=3cuje6dIgYB9zhygo9KLi7P5+wm00L+7Whjh/0kyp70=;
 b=q0tbWy00eL4tGui3fgbNXAjFbdOMVduZh0JI09v9YtD2ptir63vBgmCIsa2YwR7RosW2
 I66QF4NV+IJeTlNGmWmLemu8eV0U4UcTIjkeT8A7siU/Fx21ShcAbLAsg/M2MvJH42m7
 KKrE0TP92O66WQWT1bskpLia8WMFeDLeLbEBTVSc5v2d1Kt1s3njJWnJWYYjW6tRC1cr
 oqz4EGxc0R28uU49dJOBsSm24328LI7sPTDLEAho9nyIkvyPho4R8DsG0WwsEquB3Wbn
 W0+pVdxoLlYEZfUGgzoi6HYf7yi+xn5o8fv71/1ApRjFg2fKGbOQ2i2wXtVl5e+LZAUR Hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fvf8d03cq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 13:16:46 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 245DD0gS011906;
        Thu, 5 May 2022 13:16:46 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fvf8d03c3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 13:16:46 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 245DCNDw014549;
        Thu, 5 May 2022 13:16:44 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3fscdk57dj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 13:16:43 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 245DGedc50921744
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 May 2022 13:16:40 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BAE2D4C044;
        Thu,  5 May 2022 13:16:40 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58B754C040;
        Thu,  5 May 2022 13:16:40 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.15.58])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  5 May 2022 13:16:40 +0000 (GMT)
Date:   Thu, 5 May 2022 15:16:38 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v7 0/3] s390x: Test effect of storage
 keys on some instructions
Message-ID: <20220505151638.09d5a91e@p-imbrenda>
In-Reply-To: <20220502154101.3663941-1-scgl@linux.ibm.com>
References: <20220502154101.3663941-1-scgl@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1WruRxmGnn4hs3BCksysIGUlYb1xnOiU
X-Proofpoint-ORIG-GUID: EiH5RzkSDNVgTJd2TkvrCYhuYqhrhZsz
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-05_05,2022-05-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 adultscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 priorityscore=1501 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205050095
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  2 May 2022 17:40:58 +0200
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> See range diff below for changes. Since I messed up the addressees
> for the cover letter for the last version, the diff is against v5.

looks good, if there are no objections I would queue this

> 
> v6 -> v7:
>  * Add fetch-protection override test case to TPROT test
>  * Change reporting of TPROT test to be more in line with other tests
> 
> v5 -> v6:
>  * Disable skey test in GitLab CI, needs kernel 5.18
>  * Added comment to test_set_prefix
>  * Introduce names for tprot return values
> 
> ...
> 
> v2 -> v3:
>  * fix asm for SET PREFIX zero key test: make input
>  * implement Thomas' suggestions:
>    https://lore.kernel.org/kvm/f050da01-4d50-5da5-7f08-6da30f5dbbbe@redhat.com/
> 
> v1 -> v2:
>  * use install_page instead of manual page table entry manipulation
>  * check that no store occurred if none is expected
>  * try to check that no fetch occurred if not expected, although in
>    practice a fetch would probably cause the test to crash
>  * reset storage key to 0 after test
> 
> 
> Janis Schoetterl-Glausch (3):
>   s390x: Give name to return value of tprot()
>   s390x: Test effect of storage keys on some instructions
>   Disable s390x skey test in GitLab CI
> 
>  lib/s390x/asm/arch_def.h |  31 +++--
>  lib/s390x/sclp.c         |   6 +-
>  s390x/skey.c             | 250 +++++++++++++++++++++++++++++++++++++++
>  s390x/tprot.c            |  24 ++--
>  .gitlab-ci.yml           |   2 +-
>  5 files changed, 286 insertions(+), 27 deletions(-)
> 
> Range-diff against v5:
> -:  -------- > 1:  6b11f01d s390x: Give name to return value of tprot()
> 1:  89e59626 ! 2:  e3df88c6 s390x: Test effect of storage keys on some instructions
>     @@ s390x/skey.c: static void test_invalid_address(void)
>      +	report_prefix_push("TPROT");
>      +
>      +	set_storage_key(pagebuf, 0x10, 0);
>     -+	report(tprot(addr, 0) == 0, "access key 0 -> no protection");
>     -+	report(tprot(addr, 1) == 0, "access key matches -> no protection");
>     -+	report(tprot(addr, 2) == 1, "access key mismatches, no fetch protection -> store protection");
>     ++	report(tprot(addr, 0) == TPROT_READ_WRITE, "zero key: no protection");
>     ++	report(tprot(addr, 1) == TPROT_READ_WRITE, "matching key: no protection");
>     ++
>     ++	report_prefix_push("mismatching key");
>     ++
>     ++	report(tprot(addr, 2) == TPROT_READ, "no fetch protection: store protection");
>     ++
>      +
>      +	set_storage_key(pagebuf, 0x18, 0);
>     -+	report(tprot(addr, 2) == 2, "access key mismatches, fetch protection -> fetch & store protection");
>     ++	report(tprot(addr, 2) == TPROT_RW_PROTECTED,
>     ++	       "fetch protection: fetch & store protection");
>     ++
>     ++	report_prefix_push("fetch-protection override");
>     ++	set_storage_key(0, 0x18, 0);
>     ++	report(tprot(0, 2) == TPROT_RW_PROTECTED, "disabled: fetch & store protection");
>     ++	ctl_set_bit(0, CTL0_FETCH_PROTECTION_OVERRIDE);
>     ++	report(tprot(0, 2) == TPROT_READ, "enabled: store protection");
>     ++	report(tprot(2048, 2) == TPROT_RW_PROTECTED, "invalid: fetch & store protection");
>     ++	ctl_clear_bit(0, CTL0_FETCH_PROTECTION_OVERRIDE);
>     ++	set_storage_key(0, 0x00, 0);
>     ++	report_prefix_pop();
>      +
>      +	ctl_set_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
>      +	set_storage_key(pagebuf, 0x90, 0);
>     -+	report(tprot(addr, 2) == 0, "access key mismatches, storage protection override -> no protection");
>     ++	report(tprot(addr, 2) == TPROT_READ_WRITE,
>     ++	       "storage-protection override: no protection");
>      +	ctl_clear_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
>      +
>     ++	report_prefix_pop();
>      +	set_storage_key(pagebuf, 0x00, 0);
>      +	report_prefix_pop();
>      +}
>     @@ s390x/skey.c: static void test_invalid_address(void)
>      +#define PREFIX_AREA_SIZE (PAGE_SIZE * 2)
>      +static char lowcore_tmp[PREFIX_AREA_SIZE] __attribute__((aligned(PREFIX_AREA_SIZE)));
>      +
>     ++/*
>     ++ * Test accessibility of the operand to SET PREFIX given different configurations
>     ++ * with regards to storage keys. That is, check the accessibility of the location
>     ++ * holding the new prefix, not that of the new prefix area. The new prefix area
>     ++ * is a valid lowcore, so that the test does not crash on failure.
>     ++ */
>      +static void test_set_prefix(void)
>      +{
>      +	uint32_t *prefix_ptr = (uint32_t *)pagebuf;
> -:  -------- > 3:  c3236718 Disable s390x skey test in GitLab CI
> 
> base-commit: 6a7a83ed106211fc0ee530a3a05f171f6a4c4e66

