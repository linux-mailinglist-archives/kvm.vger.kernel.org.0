Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA514B6B57
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 12:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbiBOLnf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 06:43:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236704AbiBOLnc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 06:43:32 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 973C12BB3C
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 03:43:22 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21FBfpfQ022357
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 11:43:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=iUgfFZ2ACLKExum5wAeuRHpiIJJzbho+MnWhn2gie+E=;
 b=ntxnxHfr2d2/TOB8+q4R6124p4RQ2D9Pvy6sgJbPch7sxbiBsqSqqXJFQONV18kzVBrj
 0rLEC9F5v0mheGJtPz72klslRkgi9tCnj4irsdJENxxdHWraTePWfE3dr52RFzcssxVy
 6RdFTtJbKtKCskL5sjGHZk0ElfxP2ZHWpTvF1R1c0JlGIvIlmhO166HbJyoUBEi6Hz/z
 juO+QSE7AxbQftDzuRNtaWReULVeQu5Z7KYGJJCzxrfcT5DDoy63P1DplbK3AzBdNdIb
 RGgDO+P8ytD2pCVB84V6WqvNlzQGe0jMbuChp2Ul/RryMSPcTvhbTDqyUIkBVRKkV8Wr 3A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e8bhcg0t0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 11:43:22 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21FBgmuc024513
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 11:43:21 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e8bhcg0rw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 11:43:21 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21FBXYmJ024642;
        Tue, 15 Feb 2022 11:43:19 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3e64h9wcpm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 11:43:19 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21FBhFcT44237142
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 11:43:15 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA75711C04C;
        Tue, 15 Feb 2022 11:43:15 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 813E011C054;
        Tue, 15 Feb 2022 11:43:15 +0000 (GMT)
Received: from [9.145.18.32] (unknown [9.145.18.32])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 15 Feb 2022 11:43:15 +0000 (GMT)
Message-ID: <eab9527a-a64d-dade-116c-ab725c4667d8@linux.ibm.com>
Date:   Tue, 15 Feb 2022 12:43:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH v2 2/6] lib: s390x: smp: refactor smp
 functions to accept indexes
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nrb@linux.ibm.com, scgl@linux.ibm.com
References: <20220204130855.39520-1-imbrenda@linux.ibm.com>
 <20220204130855.39520-3-imbrenda@linux.ibm.com>
 <698c33f2-7549-3420-ce97-d15c86b4dc02@linux.ibm.com>
 <20220215122342.62efd8b8@p-imbrenda>
From:   Steffen Eiden <seiden@linux.ibm.com>
Organization: IBM
In-Reply-To: <20220215122342.62efd8b8@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ElQ5ZMwlhbK_UDIWd29xJ-KfgZyRqQ7r
X-Proofpoint-GUID: 79a_73Y88YtFlvN4EsEBjfn_F8WMrlOO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-15_04,2022-02-14_04,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 bulkscore=0 spamscore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202150065
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/15/22 12:23, Claudio Imbrenda wrote:
> On Tue, 15 Feb 2022 12:09:53 +0100
> Steffen Eiden <seiden@linux.ibm.com> wrote:
> 
> [...]
> 
>> What about using the smp wrapper 'smp_sigp(idx, SIGP_RESTART, 0, NULL)'
>> here as well?
> 
> [...]
> 
>> With my nits fixed:
> 
> maybe I should add a comment explaining why I did not use the smp_
> variants.
> 
> the reason is that the smp_ variants check the validity of the CPU
> index. but in those places, we have already checked (directly or
> indirectly) that the index is valid, so I save one useless check.
> > on the other hand, I don't know if it makes sense to optimize for that,
> since it's not a hot path, and one extra check will not kill the
> performance.
>
I would prefer the use of the smp_ variant. The extra assert won't 
clutter the output and the code is more consistent.
However, a short comment is also fine for me if you prefer that.


>>
>> Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
> 
