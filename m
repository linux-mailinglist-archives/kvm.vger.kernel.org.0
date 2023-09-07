Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B954D7977DD
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 18:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241644AbjIGQgQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 12:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239757AbjIGQgJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 12:36:09 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C56C4482;
        Thu,  7 Sep 2023 09:11:31 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 387EAO36019995;
        Thu, 7 Sep 2023 14:14:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to; s=pp1;
 bh=s9HV8diUqDOQrTE3JNEdBLu6p4DbQ9pK5JrPyoCSgJg=;
 b=Gq4TAZHEnN+I/4gytBAaewan8K5VF+WlUga4wCcHRte2f1mwIoQLar5XMEHfQc02FWKK
 BJ6BZYEBUa8AhV/Tj2rQNht4rs19gVhjknytXcOO0Xc0bLI44TJ2jsmS5rT+DeKNyG5M
 GsPHltH3bSIaUQnkVcrJ0yzj7d38kAobwY+5CUArMOxuvPMstpf6aAajYz7a8vEb+l5s
 OSOAkU378Xvg6kaRCL4iwarTRpoLClIlwBgMYq6rcpX8QTz2CrfDy/tyvzFN3d1qSKaU
 r9Gwkw1fYI0jicafe7mj2OOoqnydRFAI4FQpRMbHjeDpF2afgxTDMOMfl1L0zmN4pDzh hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3syeyjj2qt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Sep 2023 14:14:36 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 387EAhwb022712;
        Thu, 7 Sep 2023 14:14:36 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3syeyjj2qb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Sep 2023 14:14:36 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 387DsZn4026750;
        Thu, 7 Sep 2023 14:14:35 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3svgcnv5bt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Sep 2023 14:14:35 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 387EEWAQ59703694
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Sep 2023 14:14:32 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68C8220043;
        Thu,  7 Sep 2023 14:14:32 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB40B2004B;
        Thu,  7 Sep 2023 14:14:29 +0000 (GMT)
Received: from smtpclient.apple (unknown [9.43.34.62])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  7 Sep 2023 14:14:29 +0000 (GMT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.700.6\))
Subject: Re: [PATCH v4 00/11] KVM: PPC: Nested APIv2 guest support
From:   Sachin Sant <sachinp@linux.ibm.com>
In-Reply-To: <20230905034658.82835-1-jniethe5@gmail.com>
Date:   Thu, 7 Sep 2023 19:44:18 +0530
Cc:     linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        mikey@neuling.org, paulus@ozlabs.org, vaibhav@linux.ibm.com,
        sbhat@linux.ibm.com, gautam@linux.ibm.com,
        kconsul@linux.vnet.ibm.com, amachhiw@linux.vnet.ibm.com,
        "David.Laight@aculab.com" <David.Laight@ACULAB.COM>,
        mpe@ellerman.id.au
Content-Transfer-Encoding: 7bit
Message-Id: <AE7EB275-86E6-45BB-9B55-701FA316B382@linux.ibm.com>
References: <20230905034658.82835-1-jniethe5@gmail.com>
To:     Jordan Niethe <jniethe5@gmail.com>
X-Mailer: Apple Mail (2.3731.700.6)
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rBLSi0StDILLBUdKH55EV0XZfsRJMFbv
X-Proofpoint-ORIG-GUID: V6F8EIVxjjIH080WUL2zIBVy2QwZ8PKJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-07_07,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 clxscore=1011 spamscore=0 malwarescore=0 adultscore=0
 mlxscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309070125
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 05-Sep-2023, at 9:16 AM, Jordan Niethe <jniethe5@gmail.com> wrote:
> 
> A nested-HV API for PAPR has been developed based on the KVM-specific
> nested-HV API that is upstream in Linux/KVM and QEMU. The PAPR API had
> to break compatibility to accommodate implementation in other
> hypervisors and partitioning firmware. The existing KVM-specific API
> will be known as the Nested APIv1 and the PAPR API will be known as the
> Nested APIv2. 
> 

I tested the Nested APIv2 support on a Power server. Was able to
bringup a L2 guest successfully. Additionally also tested the code
with avocado-vt based cpu, guest lifecycle and ras bucket.
The test completed successfully.

Based on this testing for patches 1 to 10

Tested-by: Sachin Sant <sachinp@linux.ibm.com>

- Sachin
