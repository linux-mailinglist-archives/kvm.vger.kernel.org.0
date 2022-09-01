Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 486995A9B0B
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 17:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233680AbiIAO7d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 10:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232776AbiIAO7b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 10:59:31 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 388DC8305B;
        Thu,  1 Sep 2022 07:59:31 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 281EZ1VM018136;
        Thu, 1 Sep 2022 14:59:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 subject : from : cc : message-id : date; s=pp1;
 bh=iJvuO64PnMjL0wxS7f7jBo3qFQJ02f+9N+ab5vVFITU=;
 b=EM7juAjKaMXhb/jGuCdMEsqEAKeYAX7+/gaonpy11It/dRVitTjBEn6KaFbox4Wd0Otx
 vohqo7rR5rEDrMPHYR+BgwPf4lGRXpWyiNM3n6N2mKwedn7yTSCCsLGwsRxjc7rNYLRA
 fGNIwqqHb3Let+ZGe7+4nYLnqff8YSHp7rewxhCIEfazpr9z28yN5Ahzt4t6vzPpt7ZT
 otj31tMerRRR0LP6+EySDFGUIJWfKvsBCGDwM+BYUKmPxoLb+KBSdNKz2VKego3EuStp
 v3JAaLlJLDnsWQvpHM1cvU1B5itWUwTlotLMSv1Wp+eSYWkPhAffm98NXHYV05bm72SL 0g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jax0mccph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Sep 2022 14:59:30 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 281EZOww021778;
        Thu, 1 Sep 2022 14:59:30 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jax0mccn9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Sep 2022 14:59:29 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 281Eq6re009027;
        Thu, 1 Sep 2022 14:59:27 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3j7aw9d3q8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Sep 2022 14:59:27 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 281ExOlQ37552608
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Sep 2022 14:59:24 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77FC211C052;
        Thu,  1 Sep 2022 14:59:24 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A6CA11C04C;
        Thu,  1 Sep 2022 14:59:24 +0000 (GMT)
Received: from t14-nrb (unknown [9.155.203.253])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  1 Sep 2022 14:59:24 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220826161112.3786131-3-scgl@linux.ibm.com>
References: <20220826161112.3786131-1-scgl@linux.ibm.com> <20220826161112.3786131-3-scgl@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v6 2/2] s390x: Test specification exceptions during transaction
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Message-ID: <166204436392.25136.10832970166586747913@t14-nrb>
User-Agent: alot/0.8.1
Date:   Thu, 01 Sep 2022 16:59:23 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LZINprhJQkMTCYPOMTXmQj9P4RrDX_RU
X-Proofpoint-ORIG-GUID: R-Ps10IIUOYaNlb41krSQ7_KSxJz4lNF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_10,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 bulkscore=0 clxscore=1015 adultscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janis Schoetterl-Glausch (2022-08-26 18:11:12)
> diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
> index 68469e4b..56f26564 100644
[...]
> +#define TRANSACTION_COMPLETED 4
> +#define TRANSACTION_MAX_RETRIES 5
> +
> +/*
> + * NULL must be passed to __builtin_tbegin via constant, forbid diagnose=
 from
> + * being NULL to keep things simple
> + */

For some reason, it took me a while to get this, because the context was no=
t clear to me. Maybe rephrase it a tiny bit:

If diagnose should be NULL, it must be passed to __builtin_tbegin via const=
ant, so forbid NULL to keep things simple

[...]
> +static void test_spec_ex_trans(struct args *args, const struct spec_ex_t=
rigger *trigger)
> +{
[...]
> +       case TRANSACTION_MAX_RETRIES:
> +               report_skip("Transaction retried %lu times with transient=
 failures, giving up",
> +                           args->max_retries);

Hmhm, I am unsure whether a skip is the right thing here. On one hand, it m=
ight hide bugs, on the other hand, it might cause spurious failures. Why di=
d you decide for the skip?
