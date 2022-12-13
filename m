Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65AF364BB37
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 18:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235940AbiLMRkj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 12:40:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236256AbiLMRk1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 12:40:27 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3FFD2315A
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 09:40:26 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDH0sif011703;
        Tue, 13 Dec 2022 17:40:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Xh1ip6VDpOoE3GMyZTRGQntByek6xZsT9F3J00FBhWw=;
 b=DLM8iP7XP3a0iUMAiJBNlRG8bRu4/JedyK3KjkLVRi/vhR3EZEHtb3iwzLpJEUaMnKED
 c8yaMOhp1cCKqki+z4AilSkbp1tFK6SpTj9gPd6dQE9eIGxbx+iu0vhChUddNVT1L9Cr
 SBW+0+srzW7nZJwTOvPc+vjlLcieJewR6xtFS3EA5PYSOCjNriLQKN41TDuCPdmpSMfU
 uuzSJVhLqHDOLG5WDqB/BEpHvdCOelUmkhHaThQ7wJ0M5JtcImQ70MUMZ0VAxtB1RO6k
 +mjpwjFH3nLwQdQgITPezTRJBcdR6KbaanzoJBHGnnz+rJ/X/gL+/0Cs8MjHxhz+l2+v Gg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mewe0s2rk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 17:40:19 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BDH13cQ013139;
        Tue, 13 Dec 2022 17:40:18 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mewe0s2qc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 17:40:18 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BD606a9030249;
        Tue, 13 Dec 2022 17:40:16 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3mchr5vh7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 17:40:16 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BDHeC4v5571038
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 17:40:12 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 846F020043;
        Tue, 13 Dec 2022 17:40:12 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0612C20040;
        Tue, 13 Dec 2022 17:40:11 +0000 (GMT)
Received: from [9.171.23.219] (unknown [9.171.23.219])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 13 Dec 2022 17:40:10 +0000 (GMT)
Message-ID: <ca338024-4e00-6e45-2eea-ffb034c854a9@linux.ibm.com>
Date:   Tue, 13 Dec 2022 18:40:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v13 4/7] s390x/cpu_topology: CPU topology migration
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
References: <20221208094432.9732-1-pmorel@linux.ibm.com>
 <20221208094432.9732-5-pmorel@linux.ibm.com>
 <65b704e7-ee3a-c9de-45fa-b59c9731cb54@de.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <65b704e7-ee3a-c9de-45fa-b59c9731cb54@de.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: B3JdRGT2_GgnEW400oIh_7xLQbSeOS16
X-Proofpoint-ORIG-GUID: 1sLm1x_Oa2XEgO_kI1NmyvogJxOHr6AT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 mlxscore=0
 priorityscore=1501 clxscore=1015 mlxlogscore=999 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212130155
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/13/22 14:26, Christian Borntraeger wrote:
> Am 08.12.22 um 10:44 schrieb Pierre Morel:
>> The migration can only take place if both source and destination
>> of the migration both use or both do not use the CPU topology
>> facility.
>>
>> We indicate a change in topology during migration postload for the
>> case the topology changed between source and destination.
> 
> I dont get why we need this? If the target QEMU has topology it should
> already create this according to the configuration. WHy do we need a
> trigger?

We do not.
The first idea was to migrate the topology with a dedicated object but 
after today discussion, it will be recreated by the admin on the target 
and the MTCR will not be migrated but simply set to 1 on target start.

So next spin will not get migration included.

Regards,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
