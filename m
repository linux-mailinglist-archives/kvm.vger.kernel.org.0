Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03D1E725EF3
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 14:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240752AbjFGMVk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 08:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240713AbjFGMVc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 08:21:32 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB901BD4;
        Wed,  7 Jun 2023 05:21:31 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 357C9MoU012437;
        Wed, 7 Jun 2023 12:21:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=i33jXZoWanDQaKOfHcPYacxIWimcuCh4CpB/KgHUtAU=;
 b=n/nIINSmeKYBoti5K0sXizPdFDHmuik7teVLTmHSLwjTNVsl+09LwXpRskyoEfuWH4kS
 MvAwmVEpHPoluMrI3zxw5QBxPj5Phuz7fC1sCo5bwIRjkxorp1zbcUOnawM7mGBZXDjF
 kzUbWxof76txcIh912TTeTFwTbyO3+mRzh+z0pGSDIcTYmbryvUxn3u1FEEvBo33Y91S
 iNrOmV2hFMmM+4KyXe5tdO5KxWIQYZaAhfqOGymKWaoz/nqfWNPY6TdVqnBRaz5dGKdq
 Ss2hr8Qj4f8vNxb3OxwuyYIBqqTdYSt7J8Csq2XXboIs5hO2KlaTnS70ftzB8hZOQC7G AQ== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r2sakgr23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jun 2023 12:21:30 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3574Kbu1032550;
        Wed, 7 Jun 2023 12:21:28 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3r2a7a0aux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jun 2023 12:21:28 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 357CLOLt42205588
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Jun 2023 12:21:24 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B8F920043;
        Wed,  7 Jun 2023 12:21:24 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1EDE72004D;
        Wed,  7 Jun 2023 12:21:24 +0000 (GMT)
Received: from [9.179.8.138] (unknown [9.179.8.138])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  7 Jun 2023 12:21:24 +0000 (GMT)
Message-ID: <1ed002c3-c8d3-3649-af8c-b053f98625ca@linux.ibm.com>
Date:   Wed, 7 Jun 2023 14:21:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v4 3/6] s390/uvdevice: Add 'List Secrets' UVC
Content-Language: en-US
To:     Steffen Eiden <seiden@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>
References: <20230606180817.3019077-1-seiden@linux.ibm.com>
 <20230606180817.3019077-4-seiden@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20230606180817.3019077-4-seiden@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7VSBtYM-yrSZAIixVwMNEckRQyvj7Zuv
X-Proofpoint-ORIG-GUID: 7VSBtYM-yrSZAIixVwMNEckRQyvj7Zuv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-07_06,2023-06-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 phishscore=0 clxscore=1015 suspectscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 mlxlogscore=776
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306070100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/6/23 20:08, Steffen Eiden wrote:
> Userspace can call the List Secrets Ultravisor Call
> using IOCTLs on the uvdevice. The List Secrets UV call lists the
> identifier of the secrets in the UV secret store.
> 
> The uvdevice is merely transporting the request from userspace to
> Ultravisor. It's neither checking nor manipulating the request or
> response data.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
