Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B30DD52A70F
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 17:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345008AbiEQPi4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 11:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350265AbiEQPiW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 11:38:22 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2768517EB
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 08:37:29 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HFGo2D038560;
        Tue, 17 May 2022 15:37:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=DsjSUDujk04Y8wGlsOF5Uhcwas+nD6D2HeSNEj6f3kQ=;
 b=BugM1qpzdrOHbc0pk6x+ExMlw7w21ThH0R9B7YZTzgmi260cGhWNGqYwxCgwPEHzXGV3
 Y7/Ek7ScKzRLla/gHL8wI4PEYbvulvA00fYXrDPB2Uy6lW7Nv6LdmBHGiWo21bgWlLr2
 Q3J51hVkvrqJaWC8gW7N1SrVlmq+xjk2uTcsaCKLiWH/+k0OLMso8d628RY2YIRbrpBH
 tFOcTF5QCyvQxon3vi52h18TlvvWpVXe5eUyGjUta9i+PhvzPQf7l9WOj1Rzwyom/iRD
 2obMZwD8/1l2SMvXe3lezjY80C6kL6U1nQJqgoRDS4pNWMBxrgx32L47vrQyCtYI8sNM 5Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4dtx945n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 15:37:22 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24HFH4Is039606;
        Tue, 17 May 2022 15:37:22 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4dtx944x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 15:37:21 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HFSm05019031;
        Tue, 17 May 2022 15:37:21 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma04dal.us.ibm.com with ESMTP id 3g3r2esk8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 15:37:21 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HFbKnZ21299568
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 15:37:20 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C7B8BE056;
        Tue, 17 May 2022 15:37:20 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4395DBE04F;
        Tue, 17 May 2022 15:37:19 +0000 (GMT)
Received: from [9.211.37.97] (unknown [9.211.37.97])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 15:37:19 +0000 (GMT)
Message-ID: <2363ba6d-0e71-da6a-f8e5-e90c2305f1fe@linux.ibm.com>
Date:   Tue, 17 May 2022 11:37:18 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v2 0/6] Fully lock the container members of struct
 vfio_group
Content-Language: en-US
To:     Nicolin Chen <nicolinc@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Xiao Guangrong <guangrong.xiao@linux.intel.com>,
        Jike Song <jike.song@intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
References: <0-v2-d035a1842d81+1bf-vfio_group_locking_jgg@nvidia.com>
 <YoMunTOPFRrGASWq@Asurada-Nvidia>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <YoMunTOPFRrGASWq@Asurada-Nvidia>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1dNl7q7xc0OWBHMjo5JwJQx8KsVzkFa0
X-Proofpoint-GUID: vHju8oAHqssQ4FqbR9u1UPrJ1potSVEB
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_03,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 clxscore=1011 phishscore=0 malwarescore=0 bulkscore=0 spamscore=0
 mlxscore=0 suspectscore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170095
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/17/22 1:11 AM, Nicolin Chen wrote:
> On Mon, May 16, 2022 at 08:41:16PM -0300, Jason Gunthorpe wrote:
>> The atomic based scheme for tracking the group->container and group->kvm
>> has two race conditions, simplify it by adding a rwsem to protect those
>> values and related and remove the atomics.
>>
>> This is on github: https://github.com/jgunthorpe/linux/commits/vfio_group_locking
>>
>> v2:
>>   - Updated comments and commit messages
>>   - Rebased on vfio next
>>   - Left the dev_warn in place, will adjust it later
>>   - s/singleton_file/opened_file/
>> v1: https://lore.kernel.org/r/0-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com
>>
>> Cc: Nicolin Chen <nicolinc@nvidia.com>
> 
> Sanity tested on x86_64 and ARM64.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>

Also sanity tested this series on s390x (vfio-pci and vfio-ap)

Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
