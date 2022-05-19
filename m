Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAEFE52CDE8
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 10:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbiESIHy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 04:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiESIHx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 04:07:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299155C36C;
        Thu, 19 May 2022 01:07:50 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24J7hF6a004808;
        Thu, 19 May 2022 08:07:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=iRj/Gszk9ghOKWLuRnZse6pbLKKupbc4uksy72r7C4w=;
 b=aGpSO0vLGWTIPkUgSHHnDacxHN07A7U4pMF3q43N7p/QPnop7dWd1ojHVOP4h4maVdUN
 fW9pxNzVUpZqY2LaOI5tBRabmTRble/nVt8DdodEhtnhQDl5FrWP/7h82d08LLvjSqjN
 pHgROwrBSbDvM15ploOi7DKHclfVGScmr3wYnta/+6RZgkz0Y6e6bmnT9Z9YzgE6ToCl
 OeIpBtgnvRhRY0JpfxkSX3iCMoI3DnvNcokGZBbk7wV9bsR185kRsZ6FJC6ApXtCDneJ
 7jWRxOWmsFbzGpdfEYfrRYVT/7BuZLevytYSfF8LYFjbKFuFusXHTpPmSc50962uItJf Cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g5hrg0h3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 May 2022 08:07:47 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24J7ows7032306;
        Thu, 19 May 2022 08:07:45 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g5hrg0h1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 May 2022 08:07:45 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24J7vtb5029034;
        Thu, 19 May 2022 08:07:40 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3g2429evkk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 May 2022 08:07:40 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24J870As33882478
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 08:07:00 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 76E1B5204E;
        Thu, 19 May 2022 08:07:37 +0000 (GMT)
Received: from [9.171.1.168] (unknown [9.171.1.168])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id CB85E5204F;
        Thu, 19 May 2022 08:07:36 +0000 (GMT)
Message-ID: <1e2bfeeb-6514-a55d-61eb-6391dcc96256@de.ibm.com>
Date:   Thu, 19 May 2022 10:07:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v9 0/3] s390x: KVM: CPU Topology
Content-Language: en-US
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        frankja@linux.ibm.com, cohuck@redhat.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, gor@linux.ibm.com,
        wintera@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com
References: <20220506092403.47406-1-pmorel@linux.ibm.com>
 <f9cb28d5-2aa5-f902-53ab-592b08672c62@de.ibm.com> <YoXZxhindugH4WxI@osiris>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <YoXZxhindugH4WxI@osiris>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VJZ-r-nzt2sWRlmRrpOwbDBdCyo7LfWn
X-Proofpoint-ORIG-GUID: P-vkWWeKdImBT3l5LZe-oRt9yS-Tv8Pf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-19_01,2022-05-19_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 suspectscore=0 spamscore=0 clxscore=1015 phishscore=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 mlxlogscore=606
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205190048
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 19.05.22 um 07:46 schrieb Heiko Carstens:
> On Wed, May 18, 2022 at 05:26:59PM +0200, Christian Borntraeger wrote:
>> Pierre,
>>
>> please use "KVM: s390x:" and not "s390x: KVM:" for future series.
> 
> My grep arts ;) tell me that you probably want "KVM: s390:" without
> "x" for the kernel.

yes :-)
