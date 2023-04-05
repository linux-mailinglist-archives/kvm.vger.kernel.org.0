Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63FF26D7553
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 09:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237012AbjDEH2N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 03:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236991AbjDEH2L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 03:28:11 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7092D55
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 00:28:10 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3356wPef028599;
        Wed, 5 Apr 2023 07:28:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Xo9VOJ8yvghNYez/k0nhjqw9JSOSv9fvbZJWf5yeNFE=;
 b=cWZZ6NzHtBPjwc0x90ZDHHE8LaGQaApCcj/V00QP4JgMFDkxdJDzVukak2PzNb2XLbuG
 JBh9mXpjU3LgIGGHmDiXydL6j4+d70LyTP2JdFBtSO9kRgBTA2rvOm+6cvESMsyYk28M
 7GbkgMNwZ0kkzltFL7mSjlG/WDnX42VLUfw7yiyZv/imUQZeQNoqS9SjIrnpEL40rODX
 MaL0Ur8jao/g4qNT0H6+ONEwsa2nsXZi3AubSdJrpRz+LXCHcxpEoHEhn/z1o4yVFSzU
 JQgtXwG3GfW7x/mY/bKLvNU4s4U/xVeO1ihANIVzeBYeIBtHeNPHag19+GZQGE8bz8p5 SA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ps4698p9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 07:28:07 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 335704BL006410;
        Wed, 5 Apr 2023 07:28:07 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ps4698p98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 07:28:07 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3355SF2h004244;
        Wed, 5 Apr 2023 07:28:04 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3ppc86tbut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 07:28:04 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3357S1M329229724
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Apr 2023 07:28:01 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26E2520040;
        Wed,  5 Apr 2023 07:28:01 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B5BE52004B;
        Wed,  5 Apr 2023 07:28:00 +0000 (GMT)
Received: from [9.171.60.228] (unknown [9.171.60.228])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  5 Apr 2023 07:28:00 +0000 (GMT)
Message-ID: <c7de835c-6a0f-4190-a428-a0fdfeb3b8f9@linux.ibm.com>
Date:   Wed, 5 Apr 2023 09:28:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [kvm-unit-tests PATCH] MAINTAINERS: Add a catch-all entry for the
 kvm mailing list
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
References: <20230404125103.200027-1-thuth@redhat.com>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20230404125103.200027-1-thuth@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nggfIZuqBtJUIaiYW5EvRrvm3_zIeVQD
X-Proofpoint-ORIG-GUID: ejRgpZOuzJca91xxjdzBl6exPJSRt6v-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-05_03,2023-04-04_05,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 phishscore=0 clxscore=1015 suspectscore=0 priorityscore=1501
 mlxlogscore=999 mlxscore=0 lowpriorityscore=0 adultscore=0 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304050065
X-Spam-Status: No, score=-2.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/4/23 14:51, Thomas Huth wrote:
> The scripts/get_maintainer.pl currently fails to suggest sending
> patches to kvm@vger.kernel.org if a patch only touches files that
> are not part of any target specific code (e.g. files in the script
> folder). All patches should be CC:-ed to the kvm list, so we should
> have an entry here that covers all files.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Acked-by: Janosch Frank <frankja@linux.ibm.com>

