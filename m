Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 196F960CB06
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 13:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbiJYLg5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 07:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbiJYLg4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 07:36:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C2E21E07;
        Tue, 25 Oct 2022 04:36:55 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29PB8AZB028230;
        Tue, 25 Oct 2022 11:36:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=TqWgIcJI1kuf4CfYw4HZMpEAHRdVbvZFOo90ejsChLc=;
 b=czrk3pGfzmHQfthVO1s0UpFZI6CzOD8lnbDdZmk0osD/Ol/PiGtaRg7bKb01PEmC9MTp
 78a8YWSxAQqMfTWQOKoiq25T38RGx3pX6+3pFLoXd3ZiY/mw7V67HxSvCm6Vzh4Ga9Cf
 rsqH8eAGKV+FwJNk0oQ/CbdO1SfHMnW1hXgWfyF6TTnknteE+CdmaLZEtDlgmV2BSgMQ
 Xs+oVfzl9Xny4y480Gt4hz5XoTusu77/Mtl8Knvl6P7cHXSnlrfZCwgAEw9r3ku0hDQJ
 FbD5X7YBRPU+j+Waxzoid/7BZQIro28iqusL/Pz2nCpMfMgxV+F6vXdQDZNE9JzOSbYY FQ== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kee35t22d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 11:36:54 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29PBYeKU020156;
        Tue, 25 Oct 2022 11:36:52 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3kdugat4wu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 11:36:52 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29PBanSq2949824
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 11:36:49 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 237F4A404D;
        Tue, 25 Oct 2022 11:36:49 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D5A75A4040;
        Tue, 25 Oct 2022 11:36:48 +0000 (GMT)
Received: from [9.171.40.53] (unknown [9.171.40.53])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Oct 2022 11:36:48 +0000 (GMT)
Message-ID: <33b68d13-a3b4-dfd7-b5ce-d65fced98e98@linux.ibm.com>
Date:   Tue, 25 Oct 2022 13:36:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, borntraeger@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20221025082039.117372-1-nrb@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [v2 0/1] KVM: s390: VSIE: sort out virtual/physical address in
 pin_guest_page
In-Reply-To: <20221025082039.117372-1-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WekWnm3sAk6gn3mcv1v3KDCtzEKnhhG6
X-Proofpoint-GUID: WekWnm3sAk6gn3mcv1v3KDCtzEKnhhG6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_05,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=900
 suspectscore=0 adultscore=0 mlxscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 phishscore=0
 bulkscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210250067
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/25/22 10:20, Nico Boehr wrote:
> v1->v2:
> ---
> * remove useless cast (thanks Christian)
> 
> Nico Boehr (1):
>    KVM: s390: VSIE: sort out virtual/physical address in pin_guest_page
> 
>   arch/s390/kvm/vsie.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 

I'll put this on devel since the initial patch set is already there to 
get as much CI coverage as possible.
