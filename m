Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE5C76E24B
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 10:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234291AbjHCIA7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 04:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232950AbjHCIAN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 04:00:13 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 534014494;
        Thu,  3 Aug 2023 00:48:32 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3737gpWj031073;
        Thu, 3 Aug 2023 07:48:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=YPFwcTkJCvI8M3nYYBlVngI5KNajrQAqMXUQMy/A6y4=;
 b=tE+kM2YjH3nix04DbuUPIzjf5PG/UVDCiqHycEiAstDXhJHLMRyTZuLqS1Q8bHMUxjnY
 etoY65Mu7PJ4um6LRwFMPPJo40AJ8S/CzDLnPG+2vNjCWDGpD65Lnuwz41lgm8F5MAp1
 ldCI9FcgXy8jrn6xeTAhjdy+5E5Shu/o8TCLxU83voSDdAszpf/FtIl6ux/soN4hye1S
 +hCtcvAoh+jRd3IBroFsoHnjGfOzXtuMWMYykOhql0I5WbsRjuAQza8cF3Ons7U4WlKH
 bV5/Vb8JkVNWd4GrJ94Mo1J3iLHxHCGvDBrlPAOPi6Wgo0OWkK8+wWDlqYAOKe33rtZb ZQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s87x1rbef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Aug 2023 07:48:31 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3737gxlS031943;
        Thu, 3 Aug 2023 07:48:30 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s87x1rbdv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Aug 2023 07:48:30 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3735kmQm014530;
        Thu, 3 Aug 2023 07:48:29 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3s5ft1u2j3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Aug 2023 07:48:29 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3737mQ0Q44565060
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Aug 2023 07:48:27 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D5E102004B;
        Thu,  3 Aug 2023 07:48:26 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 085C320049;
        Thu,  3 Aug 2023 07:48:26 +0000 (GMT)
Received: from [9.171.17.205] (unknown [9.171.17.205])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  3 Aug 2023 07:48:25 +0000 (GMT)
Message-ID: <227357c7-a1c2-a0f9-c57d-536c461f9392@linux.ibm.com>
Date:   Thu, 3 Aug 2023 09:48:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v4 0/6] KVM: s390: interrupt: Fix stepping into interrupt
 handlers
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Freimann <jfreimann@redhat.com>
References: <20230725143857.228626-1-iii@linux.ibm.com>
 <ZMrXoQ0wN5ZyCf6Q@google.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <ZMrXoQ0wN5ZyCf6Q@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lYDjnObvJkLeo-jzVbbppsatD6sHzGim
X-Proofpoint-GUID: b0VuxfuSaLV2NRIfYyeQfAthsiO-0ijp
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-03_06,2023-08-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 spamscore=0 malwarescore=0 suspectscore=0 impostorscore=0 mlxlogscore=646
 priorityscore=1501 adultscore=0 phishscore=0 clxscore=1011 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308030066
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 03.08.23 um 00:24 schrieb Sean Christopherson:
> On Tue, Jul 25, 2023, Ilya Leoshkevich wrote:
>> Ilya Leoshkevich (6):
>>    KVM: s390: interrupt: Fix single-stepping into interrupt handlers
>>    KVM: s390: interrupt: Fix single-stepping into program interrupt
>>      handlers
>>    KVM: s390: interrupt: Fix single-stepping kernel-emulated instructions
>>    KVM: s390: interrupt: Fix single-stepping userspace-emulated
>>      instructions
>>    KVM: s390: interrupt: Fix single-stepping keyless mode exits
>>    KVM: s390: selftests: Add selftest for single-stepping
> 
> FYI, the selftests change silently conflicts with a global s/ASSERT_EQ/TEST_ASSERT_EQ
> rename[1], but the conflicts are very straightforward to resolve (just prepend TEST_).
> If we want to proactively avoid mild pain in linux-next, one option would be to merge
> the full kvm-x86/selftests branch/tag once I've made that immutable[2] (will be done
> Friday if there are no fireworks).  Though we can probably just get away with doing
> nothing other than letting Paolo know there's a silent conflict.
> 
> [1] https://lore.kernel.org/all/169101245511.1754469.7852701829984104093.b4-ty@google.com
> [2] https://lore.kernel.org/all/169101267140.1755771.17089576255751273053.b4-ty@google.com

Thanks for telling. Paolo, do you have a preference?

Janosch, Claudio I think this series is good to go otherwise.
