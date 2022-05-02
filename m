Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4689051730A
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 17:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385965AbiEBPov (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 11:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385948AbiEBPot (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 11:44:49 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C09EEE28;
        Mon,  2 May 2022 08:41:20 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 242FYeKs019142;
        Mon, 2 May 2022 15:41:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=xoy6xM262qGLX/dAmGncvgEeh+f1uPvBcosoTcR0alc=;
 b=gSnz+Ml1eNV/hXLG7HeHX0ITPSVhhZt6bSXA9QSQZfksVX025lMQcUYV2/ikw2YWG02K
 agKtpLRR9z8sE1uLuWDw/yh4JCzWUSyPXx4mz095BpJ3Em4flmyLLFCh/dPHsgyRk3VX
 JxEXe1ckM+MruOiBB8mVoe4kR6oHfiuj6fOZyOevamxFcFdxzWaZZ6H3sadWTnk+otXa
 20AxxT4QXUDKryPRXCIxfkFCmVA3bL6h2yY7aKzMZ6glPLZnpN+iReP2WXxMNAUJ2tf/
 AMv5kZUEymGuhgp6EaKct5R8VH4KcxJEkshqrHbolXdw60YXdn7UorRJa7J3RSwb/i6C ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fthqsrn33-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 15:41:20 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 242FYlUj019744;
        Mon, 2 May 2022 15:41:19 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fthqsrn1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 15:41:19 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 242FW7I8004530;
        Mon, 2 May 2022 15:41:17 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3frvcj2cb8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 15:41:17 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 242FfFtC23789968
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 May 2022 15:41:15 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A9354C044;
        Mon,  2 May 2022 15:41:14 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 879F24C040;
        Mon,  2 May 2022 15:41:13 +0000 (GMT)
Received: from [9.171.12.235] (unknown [9.171.12.235])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  2 May 2022 15:41:13 +0000 (GMT)
Message-ID: <249d0100-fa58-bf48-b1d2-f28e94c3a5f2@linux.ibm.com>
Date:   Mon, 2 May 2022 17:41:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [GIT PULL 0/1] KVM: s390: Fix lockdep issue in vm memop
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
References: <20220502153053.6460-1-borntraeger@linux.ibm.com>
 <47855c4c-dc85-3ee8-b903-4acf0b94e4a9@redhat.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <47855c4c-dc85-3ee8-b903-4acf0b94e4a9@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wtQQV_qhJPexIMV0DfGIeUR7Rn-kSkIg
X-Proofpoint-ORIG-GUID: S-9SNC5xbenPAqIcgG2hVhSxR6w_wJKF
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-02_04,2022-05-02_03,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 suspectscore=0 adultscore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205020122
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 02.05.22 um 17:39 schrieb Paolo Bonzini:
> On 5/2/22 17:30, Christian Borntraeger wrote:
>> Paolo,
>>
>> one patch that is sitting already too long in my tree (sorry, was out of
>> office some days).
> 
> Hi Christian,
> 
> at this point I don't have much waiting for 5.18.  Feel free to send it through the s390 tree.

OK.

Heiko, Vasily, can you queue this for your next pull request?

Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
for carrying this via the s390 tree.

> 
> Paolo
> 
>> The following changes since commit 3bcc372c9865bec3ab9bfcf30b2426cf68bc18af:
>>
>>    KVM: s390: selftests: Add error memop tests (2022-03-14 16:12:27 +0100)
>>
>> are available in the Git repository at:
>>
>>    git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-master-5.18-1
>>
>> for you to fetch changes up to 4aa5ac75bf79cbbc46369163eb2e3addbff0d434:
>>
>>    KVM: s390: Fix lockdep issue in vm memop (2022-03-23 10:41:04 +0100)
>>
>> ----------------------------------------------------------------
>> KVM: s390: fix lockdep warning in new MEMOP call
>>
>> ----------------------------------------------------------------
>> Janis Schoetterl-Glausch (1):
>>        KVM: s390: Fix lockdep issue in vm memop
>>
>>   arch/s390/kvm/kvm-s390.c | 11 ++++++++++-
>>   1 file changed, 10 insertions(+), 1 deletion(-)
>>
> 
