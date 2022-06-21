Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83914553659
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 17:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352974AbiFUPkg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 11:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353061AbiFUPkf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 11:40:35 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8662C643;
        Tue, 21 Jun 2022 08:40:33 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25LEnvFQ035892;
        Tue, 21 Jun 2022 15:40:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=KJ1i0nDuJEDGYGxoNMQmD+/FkYRh5qQBq9Bxds14Dzs=;
 b=UW13b01o0xbmzeqGwsUnV89wxL+SpRFRBMnIx2igWC2naoe4r5w13elTdX/oFAQ6Zw3K
 1IcXhWzrMMoe6bWU1qK8FET3mJjuKshwZ/Pj6OCVTmqdiy+5HPgyuLQbG+vwwHFEJj/u
 IIUlEFoRwXkdDYFv5gpzQgREBU5mqjzya6HwqBnY10VH2Y66EfoOPSHSwJTVU8Oo10L/
 X1lRNS/vklbCfw04khnpIQHZSn4Sbfqx4p+cVqrjwonJwrrEdfwqprrrLYLK/a/widW2
 jGSCheDKaL9L1rSSfgocnFZeKYIdAJcHw7tHkf4Qn4bt3AMRh772fI6/a9D487eodUrO 3A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gug3mhjq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:40:32 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25LEodIb038129;
        Tue, 21 Jun 2022 15:40:32 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gug3mhjp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:40:32 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25LFZuVZ021475;
        Tue, 21 Jun 2022 15:40:30 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3gs6b949g0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:40:30 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25LFeRCo10551802
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jun 2022 15:40:27 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 56C294C046;
        Tue, 21 Jun 2022 15:40:27 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2D234C044;
        Tue, 21 Jun 2022 15:40:26 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.4.76])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jun 2022 15:40:26 +0000 (GMT)
Date:   Tue, 21 Jun 2022 17:40:24 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v5 0/3] More skey instr. emulation test
Message-ID: <20220621174024.0cfffed7@p-imbrenda>
In-Reply-To: <20220621143609.753452-1-scgl@linux.ibm.com>
References: <20220621143609.753452-1-scgl@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7n-zoi37RAMB3x1sj5OscmUOgGmOCzzS
X-Proofpoint-GUID: tFKLya83jOH5xF4zXP-2gIZpqRx2gxhN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-21_08,2022-06-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 adultscore=0 impostorscore=0 bulkscore=0 priorityscore=1501
 phishscore=0 spamscore=0 clxscore=1015 mlxscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206210066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 21 Jun 2022 16:36:06 +0200
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> Add test cases similar to those testing the effect of storage keys on
> instructions emulated by KVM, but test instructions emulated by user
> space/qemu instead.
> Test that DIAG 308 is not subject to key protection.
> Additionally, check the transaction exception identification on
> protection exceptions.

thanks, queued

> 
> This series is based on v3 of s390x: Rework TEID decoding and usage .
> 
> v4 -> v5
>  * rebase onto v3 of TEID series
>  * ignore ancient machines without at least ESOP-1
> 
> v3 -> v4
>  * rebase on newest TEID decoding series
>  * pick up r-b's (Thanks Claudio)
>  * add check for protection code validity in case of basic SOP
> 
> v2 -> v3
>  * move sclp patch and part of TEID test to series
>        s390x: Rework TEID decoding and usage
>  * make use of reworked TEID union in skey TEID test
>  * get rid of pointer to array for diag 308 test
>  * use lowcore symbol and mem_all
>  * don't reset intparm when expecting exception in msch test
> 
> v1 -> v2
>  * don't mixup sclp fix with new bits for the TEID patch
>  * address feedback
>        * cosmetic changes, i.e. shortening identifiers
>        * remove unconditional report_info
>  * add DIAG 308 test
> 
> Janis Schoetterl-Glausch (3):
>   s390x: Test TEID values in storage key test
>   s390x: Test effect of storage keys on some more instructions
>   s390x: Test effect of storage keys on diag 308
> 
>  s390x/skey.c        | 379 +++++++++++++++++++++++++++++++++++++++++++-
>  s390x/unittests.cfg |   1 +
>  2 files changed, 374 insertions(+), 6 deletions(-)
> 
> Range-diff against v4:
> 1:  fbfd7e3b ! 1:  a30f2b45 s390x: Test TEID values in storage key test
>     @@ s390x/skey.c: static void test_test_protection(void)
>      +{
>      +	union teid teid;
>      +	int access_code;
>     -+	bool dat;
>      +
>      +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
>      +	report_prefix_push("TEID");
>      +	teid.val = lowcore.trans_exc_id;
>      +	switch (get_supp_on_prot_facility()) {
>      +	case SOP_NONE:
>     -+		break;
>      +	case SOP_BASIC:
>     -+		dat = extract_psw_mask() & PSW_MASK_DAT;
>     -+		report(!teid.sop_teid_predictable || !dat || !teid.sop_acc_list,
>     -+		       "valid protection code");
>     ++		/* let's ignore ancient/irrelevant machines */
>      +		break;
>      +	case SOP_ENHANCED_1:
>      +		report(!teid.sop_teid_predictable, "valid protection code");
>     ++		/* no access code in case of key protection */
>      +		break;
>      +	case SOP_ENHANCED_2:
>      +		switch (teid_esop2_prot_code(teid)) {
>      +		case PROT_KEY:
>     -+			access_code = teid.acc_exc_f_s;
>     ++			/* ESOP-2: no need to check facility */
>     ++			access_code = teid.acc_exc_fetch_store;
>      +
>      +			switch (access_code) {
>      +			case 0:
>     @@ s390x/skey.c: static void test_test_protection(void)
>      +				break;
>      +			}
>      +			/* fallthrough */
>     -+		case PROT_KEY_LAP:
>     ++		case PROT_KEY_OR_LAP:
>      +			report_pass("valid protection code");
>      +			break;
>      +		default:
> 2:  868bb863 = 2:  b194f716 s390x: Test effect of storage keys on some more instructions
> 3:  d49934c0 = 3:  460d77ec s390x: Test effect of storage keys on diag 308
> 
> base-commit: 610c15284a537484682adfb4b6d6313991ab954f
> prerequisite-patch-id: bebbc71ca3cc8d085e36a049466dba5a420c9c75
> prerequisite-patch-id: d38a4fc7bc1fa6e352502f294cb9413f0b738b99
> prerequisite-patch-id: 15d25aaab40e81ad60a13218eaba370585c4a87e

