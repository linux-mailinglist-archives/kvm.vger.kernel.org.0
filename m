Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2740363765A
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 11:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiKXK1d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 05:27:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiKXK1b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 05:27:31 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3AFB60E1;
        Thu, 24 Nov 2022 02:27:27 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AOA4Nnb010307;
        Thu, 24 Nov 2022 10:27:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=bZmt9F2QFPDg9RfOcLRTpMW9cZG31Npju4rqsm0z3Nc=;
 b=Hb1tzQwuybeDfMU7qhlvC/W+oF4pRmCKcwRp4kYbZYNX/XPbDLjxJqQoAEHAT4UllTuz
 srnEua8SLe2Y4BYc6JctwWrRHzgoWvOJoWnTEfi94toOBXBMGKMW+RyHRcx7x7drJllM
 e/LCNfUTHCJSmq74BzQVWv+KbxAKqahR2cb9RmstOW1lET0qqHQdQ9Nv76acv1NXcsyr
 ooREK2S9jS1XrOydS7jl0aYJyVFKzIOTiHDMFjD6XgIkPXtF5qWCqlgDa+oTECSi66M4
 yZNvL25Dk20yh3xySAACZ/k42IrmPa6HdQ2tmaAMmmmtQyQmp9mquguDHAgaTbj/Rs6f zA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m1n2w7jbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Nov 2022 10:27:27 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AOA4OnA010427;
        Thu, 24 Nov 2022 10:27:26 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m1n2w7jb8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Nov 2022 10:27:26 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AOAKxkQ018760;
        Thu, 24 Nov 2022 10:27:24 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3kxps8ns2f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Nov 2022 10:27:24 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AOARLnq59310542
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Nov 2022 10:27:21 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3DC4652054;
        Thu, 24 Nov 2022 10:27:21 +0000 (GMT)
Received: from [9.152.224.253] (unknown [9.152.224.253])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id EF50C52050;
        Thu, 24 Nov 2022 10:27:20 +0000 (GMT)
Message-ID: <4d46020f-f33a-474c-b791-be11c2ce2aa6@linux.ibm.com>
Date:   Thu, 24 Nov 2022 11:27:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] KVM: s390: vsie: Fix the initialization of the epoch
 extension (epdx) field
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        "Collin L. Walling" <walling@linux.ibm.com>,
        Jason J Herne <jjherne@linux.ibm.com>
References: <20221123090833.292938-1-thuth@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20221123090833.292938-1-thuth@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MsngLNbAC4-9Xn2BmNnR1dCcJ9mp15pq
X-Proofpoint-GUID: hazaGeK5oRVNANFYWbyRBS4ILxLi7g9k
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-24_07,2022-11-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 adultscore=0 suspectscore=0 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 mlxlogscore=866 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211240079
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/23/22 10:08, Thomas Huth wrote:
> We recently experienced some weird huge time jumps in nested guests when
> rebooting them in certain cases. After adding some debug code to the epoch
> handling in vsie.c (thanks to David Hildenbrand for the idea!), it was
> obvious that the "epdx" field (the multi-epoch extension) did not get set
> to 0xff in case the "epoch" field was negative.
> Seems like the code misses to copy the value from the epdx field from
> the guest to the shadow control block. By doing so, the weird time
> jumps are gone in our scenarios.
> 
> Link: https://bugzilla.redhat.com/show_bug.cgi?id=2140899
> Fixes: 8fa1696ea781 ("KVM: s390: Multiple Epoch Facility support")
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Could you please add a test for this to the KVM unit tests?
I'd guess you might already have some code for it from your debugging 
sessions.

