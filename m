Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 899C9524EC9
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 15:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354698AbiELNvi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 09:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344474AbiELNve (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 09:51:34 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9366541F;
        Thu, 12 May 2022 06:51:33 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24CDN8Td010744;
        Thu, 12 May 2022 13:51:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=s2kDKq2rLM1QKEd3r2BYZiAh3eI78iqwpoQJAzLbmug=;
 b=N5ukWU/a1bDmPjOpAOcmyMcVvxTf4WvSKOrzF4G7nHP75Y9xm/toK1a4/jZR7JgYNWzO
 4zWMz5dHiLI3hGPTgTNSKLtS++zxuIkSOmWfp5pPp8eJitck6Q1/QtFG/KCSa4iXTPGz
 hkDG/7h2N99Zs1X5o4kjasEbgJlebyqqpE/BTjV6NpEaNZcnGGu3/nbladVOIfo5WACv
 by1xL4yJchTehXzBcHf1oTs72Y56OsIRW6UtQRn7NO1fx+UsnEqVDtaNM68bt9Y8r2EF
 5XvsCUC228Z13JBtXLNTp7zuxIYvnFLTjXbIG1C9Og80QykjHv5qyzsLys5b9+/1/jK0 Tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g132urt66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 13:51:31 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24CDlU3N015069;
        Thu, 12 May 2022 13:51:30 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g132urt5k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 13:51:30 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24CDlp2l020747;
        Thu, 12 May 2022 13:51:28 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3g0ma1gw8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 13:51:28 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24CDpPxG50397490
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 13:51:25 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3929352059;
        Thu, 12 May 2022 13:51:25 +0000 (GMT)
Received: from [9.152.224.232] (unknown [9.152.224.232])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id BC2FD52050;
        Thu, 12 May 2022 13:51:24 +0000 (GMT)
Message-ID: <4a06e3e8-4453-9204-eb66-d435860c5714@linux.ibm.com>
Date:   Thu, 12 May 2022 15:51:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v3 1/2] KVM: s390: Don't indicate suppression on dirtying,
 failing memop
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220512131019.2594948-1-scgl@linux.ibm.com>
 <20220512131019.2594948-2-scgl@linux.ibm.com>
 <77f6f5e7-5945-c478-0e41-affed62252eb@redhat.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <77f6f5e7-5945-c478-0e41-affed62252eb@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kq_VLsc2Cch67QIG5wsRW5eoIlK90DKA
X-Proofpoint-ORIG-GUID: AeBPgQQ8VBajH6WfXZ2xqDRCkTTHhqVR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_10,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 bulkscore=0 mlxscore=0 clxscore=1015 adultscore=0 spamscore=0
 mlxlogscore=846 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2205120065
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 12.05.22 um 15:22 schrieb David Hildenbrand:
> On 12.05.22 15:10, Janis Schoetterl-Glausch wrote:
>> If user space uses a memop to emulate an instruction and that
>> memop fails, the execution of the instruction ends.
>> Instruction execution can end in different ways, one of which is
>> suppression, which requires that the instruction execute like a no-op.
>> A writing memop that spans multiple pages and fails due to key
>> protection may have modified guest memory, as a result, the likely
>> correct ending is termination. Therefore, do not indicate a
>> suppressing instruction ending in this case.
> 
> I think that is possibly problematic handling.
> 
> In TCG we stumbled in similar issues in the past for MVC when crossing
> page boundaries. Failing after modifying the first page already
> seriously broke some user space, because the guest would retry the
> instruction after fixing up the fault reason on the second page: if
> source and destination operands overlap, you'll be in trouble because
> the input parameters already changed.
> 
> For this reason, in TCG we make sure that all accesses are valid before
> starting modifications.
> 
> See target/s390x/tcg/mem_helper.c:do_helper_mvc with access_prepare()
> and friends as an example.
> 
> Now, I don't know how to tackle that for KVM, I just wanted to raise
> awareness that injecting an interrupt after modifying page content is
> possible dodgy and dangerous.

this is really special and only for key protection crossing pages.
Its been done since the 70ies in that way on z/VM. The architecture
is and was always written in a way to allow termination for this
case for hypervisors.
