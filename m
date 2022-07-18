Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20FD3577EC0
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 11:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234181AbiGRJeR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 05:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234044AbiGRJeQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 05:34:16 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53EBB1057C;
        Mon, 18 Jul 2022 02:34:14 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26I9OJwC013534;
        Mon, 18 Jul 2022 09:34:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=CLtnuMZn0IaIeUfNRVokFsAu9Vmt+6KkmjlqpPstuWE=;
 b=PgWIVighlvRiymHGqWnzV5Rv+2l2kHDAaNYvDHRaOIcV1SSKTaxzvfQsSZ75zmBaOQHc
 uIwq+0WZRVyKHdP+VxlL6lo3gRUZXXU/vFshDRcbOIBxFNbtTGC6f5iLiB55dDEpJHSl
 jT5MQ8HOGGImR6ZxkqT8YcfQlcnyMu/rthXQ2WhH7FQodZH0G9p29v52F6sp1MZlcQnZ
 IvShXHJyo/T7QwTu+J/6TqJ+AodoAEjfno0mWmBUGVSW9f/GDsx1lNbG2Y8qZEx0J694
 bizSCsRpRouMidnlQnf0CuWtWZYI3bQ1lSDGCYB4ac43jy3xPNln9TAcZ+DNDBm+aotN 9A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hd4uyr810-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Jul 2022 09:34:13 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26I9QJOF025620;
        Mon, 18 Jul 2022 09:34:13 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hd4uyr804-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Jul 2022 09:34:12 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26I9KRsm017554;
        Mon, 18 Jul 2022 09:34:11 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3hbmy8tb70-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Jul 2022 09:34:11 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26I9Y8Cm11665912
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Jul 2022 09:34:09 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0CCE5204E;
        Mon, 18 Jul 2022 09:34:08 +0000 (GMT)
Received: from [9.171.53.146] (unknown [9.171.53.146])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 918825204F;
        Mon, 18 Jul 2022 09:34:08 +0000 (GMT)
Message-ID: <90e2ebcd-f411-8d44-bf44-5df80fb59b51@linux.ibm.com>
Date:   Mon, 18 Jul 2022 11:34:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] kvm: stats: tell userspace which values are boolean
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Amneesh Singh <natto@weirdnatto.in>
References: <20220714120330.1410308-1-pbonzini@redhat.com>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <20220714120330.1410308-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ShPBIaQuF6uMl3ehzNI5XhMv0L9pGx99
X-Proofpoint-GUID: be1TbGoNuk6AVmzsBfJfTR1nMuPj0o6m
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_08,2022-07-15_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 clxscore=1011 adultscore=0 suspectscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207180038
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/14/22 14:03, Paolo Bonzini wrote:
> Some of the statistics values exported by KVM are always only 0 or 1.
> It can be useful to export this fact to userspace so that it can track
> them specially (for example by polling the value every now and then to
> compute a % of time spent in a specific state).
> 
> Therefore, add "boolean value" as a new "unit".  While it is not exactly
> a unit, it walks and quacks like one.  In particular, using the type
> would be wrong because boolean values could be instantaneous or peak
> values (e.g. "is the rmap allocated?") or even two-bucket histograms
> (e.g. "number of posted vs. non-posted interrupt injections").
> 
> Suggested-by: Amneesh Singh <natto@weirdnatto.in>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  Documentation/virt/kvm/api.rst |  6 ++++++
>  arch/x86/kvm/x86.c             |  2 +-
>  include/linux/kvm_host.h       | 11 ++++++++++-
>  include/uapi/linux/kvm.h       |  1 +
>  4 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 11e00a46c610..48bf6e49a7de 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5657,6 +5657,7 @@ by a string of size ``name_size``.
>  	#define KVM_STATS_UNIT_BYTES		(0x1 << KVM_STATS_UNIT_SHIFT)
>  	#define KVM_STATS_UNIT_SECONDS		(0x2 << KVM_STATS_UNIT_SHIFT)
>  	#define KVM_STATS_UNIT_CYCLES		(0x3 << KVM_STATS_UNIT_SHIFT)
> +	#define KVM_STATS_UNIT_BOOLEAN		(0x4 << KVM_STATS_UNIT_SHIFT)
>  	#define KVM_STATS_UNIT_MAX		KVM_STATS_UNIT_CYCLES
> 
>  	#define KVM_STATS_BASE_SHIFT		8

[...]

> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 5088bd9f1922..811897dadcae 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -2083,6 +2083,7 @@ struct kvm_stats_header {
>  #define KVM_STATS_UNIT_BYTES		(0x1 << KVM_STATS_UNIT_SHIFT)
>  #define KVM_STATS_UNIT_SECONDS		(0x2 << KVM_STATS_UNIT_SHIFT)
>  #define KVM_STATS_UNIT_CYCLES		(0x3 << KVM_STATS_UNIT_SHIFT)
> +#define KVM_STATS_UNIT_BOOLEAN		(0x4 << KVM_STATS_UNIT_SHIFT)
>  #define KVM_STATS_UNIT_MAX		KVM_STATS_UNIT_CYCLES

Shouldn't KVM_STATS_UNIT_MAX be KVM_STATS_UNIT_BOOLEAN then?

The selftest has:
	TEST_ASSERT((pdesc->flags & KVM_STATS_UNIT_MASK)
                                <= KVM_STATS_UNIT_MAX, "Unknown KVM stats unit");
> 
>  #define KVM_STATS_BASE_SHIFT		8

