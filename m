Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A05905ED7B6
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 10:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbiI1I2a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 04:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233055AbiI1I23 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 04:28:29 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F3EC74CD5
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 01:28:25 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28S7rEjl025315;
        Wed, 28 Sep 2022 08:28:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=NSqB2aUNr3ZNNK4I1eq9F6pOPyiilpuqM8qAVQup/9g=;
 b=MwxQqhPzQf8d/YyJmM37jM1nLQBEHDrqFvSgcr3L+PdI8RxNzPrbdEgfx3q6Y9xqjMmq
 cjjnOspU0Fn44qqetkT+BVmwrms7vp0STnsTT8BPfJpMIA5bBwqVGymqgjjpe1KIhP6t
 MjnYl8z5vLDk3kpX+Yrb5wDaTobSiMaIL7tom7s02NoghuWvljR6VcHwZ4CZtPZaLhPH
 COhwKKLThOtbit6hoEMNcYuEOGAXDslze9qKHaTK+rYzuN8W9EKwnU3o2jx1em9VlBzw
 e2fQF8WZVBH7gJ9uawAgiccgIeAoSuURd3f9xY0gjkBLutV0tnh5hY8ENYEILHo425hT Qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jvf8rds2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 08:28:20 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28S7i12p016806;
        Wed, 28 Sep 2022 08:28:19 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jvf8rds2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 08:28:19 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28S8LbbU001225;
        Wed, 28 Sep 2022 08:28:17 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3juapujk7g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 08:28:17 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28S8SElQ4195048
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Sep 2022 08:28:14 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 76F884C044;
        Wed, 28 Sep 2022 08:28:14 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 85B6A4C040;
        Wed, 28 Sep 2022 08:28:13 +0000 (GMT)
Received: from [9.171.31.212] (unknown [9.171.31.212])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Sep 2022 08:28:13 +0000 (GMT)
Message-ID: <a7fe4dbe-1f5a-e530-fcc8-6072b441bb61@linux.ibm.com>
Date:   Wed, 28 Sep 2022 10:28:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v9 00/10] s390x: CPU Topology
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
References: <20220902075531.188916-1-pmorel@linux.ibm.com>
 <d8fbb30bbc8dc3d5d512fbeac257c38effbe1dc2.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <d8fbb30bbc8dc3d5d512fbeac257c38effbe1dc2.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: QylD9XYoJ3p0HtJ8JJA93AaeT2OWoRSY
X-Proofpoint-GUID: 2fuKjw86iKYDlNeyuDngANmuPPLBFKfT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-28_03,2022-09-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 spamscore=0 mlxlogscore=793 suspectscore=0 phishscore=0 priorityscore=1501
 impostorscore=0 clxscore=1015 adultscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209280048
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/12/22 16:38, Janis Schoetterl-Glausch wrote:
> I found this version much easier to understand than the previous one.
> 
> You could consider splitting up the series into two.
> One that introduces support for STSI, PTF, migration, etc.
> And a second one that adds support for the maximum-MNist facility and
> drawers and books.

I agree, sending the first part as supporting only sockets already is an 
enhancement that could be proposed on its own.

> 
> This would also make bisecting a bit nicer because it moves the feature
> enablement closer to the commits adding the support.
> 
> Right now, with this series, the topology is static and cannot change.

If we ignore changes on hotplug, yes we consider the topology fixed and 
that the vCPU does not migrate.

> Most of the value of making the topology visible to the guest is for it
> to mirror reality, and a static topology is a hindrance for that.
> I'm completely fine with having a static topology as a stepping stone
> to a dynamic one.
> However I think we should have a rough plan or maybe even a prototype
> for how we turn a static into a dynamic topology before we merge this
> series in order to avoid designing us into a corner.
> What do you think?

Yes, we can discuss this internally before moving there.

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
