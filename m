Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7CA44C2EF1
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 16:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235806AbiBXPFC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 10:05:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235793AbiBXPFA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 10:05:00 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F931B755F;
        Thu, 24 Feb 2022 07:04:29 -0800 (PST)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OF3YHH032064;
        Thu, 24 Feb 2022 15:04:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=RMG3ehRk1VSDQYv/JtuOSXHUXBu9+l6KQXiz8RdBsr0=;
 b=cRtfbcL0G4QfaUgHdXWK5QgIOJaXk/W+ltLgdv22r+e6SJCFKn3J0Dwxoi50xW+9wmxc
 e8X9/Uy1az9odGCJctDgZM9YvYWGZzn4Nldvj36LtnHh/IMJCaZlMrVu/K8DnubVJsMJ
 fXdXasHhCB58u6MLeFy2nP/QjPLmziCtFoCpM/ubW92rFQan0huhP6X0xs7XMlzVDLOQ
 qFCJXN+Qe2Cxloq8DYr43QTBR6PbQ2R2yntT++1bpFyDzQqoha9RyL5k1uL+1t8qAeP2
 rh5RBA3dhYnZvUvPH9Ku+AKrR58HuC+7LAnn1JqWX5vGDdPgYrvblCeC+9v878uytbKx yQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edxf71ty5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Feb 2022 15:04:29 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21OF44uo002211;
        Thu, 24 Feb 2022 15:04:28 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edxf71tx0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Feb 2022 15:04:28 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21OEscfq004533;
        Thu, 24 Feb 2022 15:04:26 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3eaqtjjnvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Feb 2022 15:04:26 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21OErdbg47186284
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 14:53:39 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 957CA42041;
        Thu, 24 Feb 2022 15:04:21 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46ADD42042;
        Thu, 24 Feb 2022 15:04:21 +0000 (GMT)
Received: from [9.145.90.75] (unknown [9.145.90.75])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 24 Feb 2022 15:04:21 +0000 (GMT)
Message-ID: <f0dfd041-8be4-8569-27ac-63f5a7635823@linux.ibm.com>
Date:   Thu, 24 Feb 2022 16:04:20 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH v4 0/2] KVM: s390: make use of ultravisor AIV support
Content-Language: en-US
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, borntraeger@linux.ibm.com, pasic@linux.ibm.com,
        Janosch Frank <frankja@linux.ibm.com>
References: <20220223102000.3733712-1-mimu@linux.ibm.com>
From:   Michael Mueller <mimu@linux.ibm.com>
In-Reply-To: <20220223102000.3733712-1-mimu@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XMfAxPb63U1WjY67QeNjNPWiyL3Ip21_
X-Proofpoint-ORIG-GUID: 4OJ6CoXeFF4VIim0GVP63HJs-n-69JTL
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-24_03,2022-02-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 spamscore=0 impostorscore=0 phishscore=0 clxscore=1015 mlxlogscore=575
 lowpriorityscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202240087
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 23.02.22 11:19, Michael Mueller wrote:
> This patch enables the ultravisor adapter interruption vitualization
> support.
> 
> Changes in v4:
> - All vcpus are pulled out of SIE and disbled before the control
>    blocks are changed to disable/enable the gisa and re-enabled
>    afterwards instead of taking the vcpu specific lock.


Christian,

I'm pulling back this v4 and ask for v3 to be re-applied as it turned
out that the described issue is related to kvm_s390_set_tod_clock()
being called in SIE intercepted context.

> 
> Changes in v3:
> - cache and test GISA descriptor only once in kvm_s390_gisa_enable()
> - modified some comments
> - removed some whitespace issues
> 
> Changes in v2:
> - moved GISA disable into "put CPUs in PV mode" routine
> - moved GISA enable into "pull CPUs out of PV mode" routine
> 
> [1] https://lore.kernel.org/lkml/ae7c65d8-f632-a7f4-926a-50b9660673a1@linux.ibm.com/T/#mcb67699bf458ba7482f6b7529afe589d1dbb5930
> [2] https://lore.kernel.org/all/20220208165310.3905815-1-mimu@linux.ibm.com/
> [3] https://lore.kernel.org/all/20220209152217.1793281-2-mimu@linux.ibm.com/
> 
> Michael Mueller (2):
>    KVM: s390: pv: pull all vcpus out of SIE before converting to/from pv
>      vcpu
>    KVM: s390: pv: make use of ultravisor AIV support
> 
>   arch/s390/include/asm/uv.h |  1 +
>   arch/s390/kvm/interrupt.c  | 54 +++++++++++++++++++++++++++++++++-----
>   arch/s390/kvm/kvm-s390.c   | 19 +++++++++-----
>   arch/s390/kvm/kvm-s390.h   | 11 ++++++++
>   4 files changed, 72 insertions(+), 13 deletions(-)
> 
