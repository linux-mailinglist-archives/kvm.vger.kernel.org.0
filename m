Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 504D6732AA6
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 10:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244744AbjFPI42 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 04:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242847AbjFPI40 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 04:56:26 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67AE826A2;
        Fri, 16 Jun 2023 01:56:24 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35G8p3jR007233;
        Fri, 16 Jun 2023 08:56:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=9z3tMyvgoNrYBEOFFAQ+HLSRNHIqHXEfc6q8uZ5rIUE=;
 b=mmYvBYx9bwnHsjwk/oHLhSlLhlq7WXZn5l8a5FOS6JGsOemNFB56lQoIOXH4rLJIrOPY
 mU2UWXuOu8zxO/2Se9GXf4BOlSWA+bzgUg/PcidJE8fmCorKMTBJ5vBoZwwX4GBKFA4F
 nnStSmh2DBnPi4NGi47khSl9+CkYB7ZasIm3oOyVhxpnFPcjDcf7GbO50LUbTL4SaFPN
 jvd9XjiY3sAImuN5UZAxBkDCMCMsuy8h8TFGjHmsCkNhSOQKf3UZxJovDnExw8rZfMzC
 xbu3CcaWNX40YTjoYzIftAcL/YoI5OnycZXpmegTe4080UVi+V7U4OZFGuyHlwu0VS18 Lw== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r8mfu0dgt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 16 Jun 2023 08:56:23 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35G5jioS024210;
        Fri, 16 Jun 2023 08:56:21 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3r4gedu4sc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 16 Jun 2023 08:56:21 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35G8uHFr20382460
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Jun 2023 08:56:17 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD37220043;
        Fri, 16 Jun 2023 08:56:17 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7856320040;
        Fri, 16 Jun 2023 08:56:17 +0000 (GMT)
Received: from [9.179.5.100] (unknown [9.179.5.100])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 16 Jun 2023 08:56:17 +0000 (GMT)
Message-ID: <08ed39eb-b1cf-7c15-83a4-dd59cc29732b@linux.ibm.com>
Date:   Fri, 16 Jun 2023 10:56:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.1
Subject: Re: [PATCH v5 1/7] s390/uv: Always export uv_info
To:     Steffen Eiden <seiden@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
References: <20230615100533.3996107-1-seiden@linux.ibm.com>
 <20230615100533.3996107-2-seiden@linux.ibm.com>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20230615100533.3996107-2-seiden@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rSK6T5LhdkXwFqRf0825EV8BGdNPrD2K
X-Proofpoint-ORIG-GUID: rSK6T5LhdkXwFqRf0825EV8BGdNPrD2K
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-16_05,2023-06-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 impostorscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306160076
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/15/23 12:05, Steffen Eiden wrote:
> KVM needs the struct's values to be able to provide PV support.
> 
> The uvdevice is currently guest only and will need the struct's values
> for call support checking and potential future expansions.
> 
> As uv.c is only compiled with CONFIG_PGSTE or
> CONFIG_PROTECTED_VIRTUALIZATION_GUEST we don't need a second check in
> the code. Users of uv_info will need to fence for these two config
> options for the time being.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
> 
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

In the long term we'll remove the config checks and always compile uv.o 
in kernel/ and boot/ so we won't be running in these issues again.

