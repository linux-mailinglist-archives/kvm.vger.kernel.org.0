Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA2934BFC48
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 16:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233372AbiBVPTT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 10:19:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233430AbiBVPTR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 10:19:17 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1BE614A075;
        Tue, 22 Feb 2022 07:18:50 -0800 (PST)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21MEhQ3C027100;
        Tue, 22 Feb 2022 15:18:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=u0xXSzZNhiW1oVgyljBFkft3q2auVA72n/7sDFP+tmc=;
 b=e+YVlY/jGs82604bEc3OX0qhYouewRGueNBfbRY/dKqFMU9x8Idjk1hqYKNSX1ILfIix
 em3fDxYsR+qsowBCvQ+n8CbK9u7pvkt544NxNHt8d/7LCDOX/OKy5M6EbYupms1CVMmv
 yhLMOx43hg2IRRAp6ABk+xhqqjWzL69YZjxanYOsDjFVRbSxTN/SxsZee1jrGe4pHsir
 ZY0yWQB8Jr24ZUBE4B9iIQ7twrAZ2F3ZYtCBtobe9nv1EwUoOSQmhZWQeit0LoSqCIN3
 IS/H+vZA+wtM5G8eRaa1ljC+BOy1+mDv8STdXAQwEXgJUN+OKHQxrNfBGeg2A/ix3PF5 8g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ed1uj8xuk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 15:18:50 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21MEv23F022204;
        Tue, 22 Feb 2022 15:18:50 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ed1uj8xtg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 15:18:49 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21MFF04P030213;
        Tue, 22 Feb 2022 15:18:47 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3ear692mdf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 15:18:47 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21MFIi1B47317248
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Feb 2022 15:18:44 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 462234C04E;
        Tue, 22 Feb 2022 15:18:44 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BBF064C04A;
        Tue, 22 Feb 2022 15:18:43 +0000 (GMT)
Received: from [9.171.12.252] (unknown [9.171.12.252])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Feb 2022 15:18:43 +0000 (GMT)
Message-ID: <2a5c5571-3ff3-9c43-1298-39ce5107d318@linux.ibm.com>
Date:   Tue, 22 Feb 2022 16:18:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [GIT PULL 00/13] KVM: s390: Changes for 5.18 part1
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
References: <20220222094910.18331-1-borntraeger@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20220222094910.18331-1-borntraeger@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nk29mHJXS1_FC5B2SJmmPTHtqXidPokM
X-Proofpoint-ORIG-GUID: RQzFCUhZsIwTQDiHONPN9ClvJUr5XKmU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-22_03,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 impostorscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 mlxlogscore=916 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202220091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 22.02.22 um 10:48 schrieb Christian Borntraeger:
> ----------------------------------------------------------------
> Christian Borntraeger (1):
>        KVM: s390: MAINTAINERS: promote Claudio Imbrenda
> 
> Janis Schoetterl-Glausch (11):
>        s390/uaccess: Add copy_from/to_user_key functions

Forgot to mention this: this contains one s390 patch that is acked by the s390 maintainer.
