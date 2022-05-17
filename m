Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEE0352A48A
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 16:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348574AbiEQOQp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 10:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348904AbiEQOQa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 10:16:30 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D4011817;
        Tue, 17 May 2022 07:15:52 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HDMnAQ013111;
        Tue, 17 May 2022 14:15:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=pyKP/5JDb0JVYS+Jab+jhaLeJXXeiqGdzv459YijEXk=;
 b=bEQSrRyro5o4uQQlW39IEekd0z9lizL2JIj9R+n/t2HVSovblrvWMyhnQhZHgNc3jcm4
 pkI3g3LSRsBZx09FVzktEvkmXgnQIDqwgwQz26XBsmGBMjltQVYM3of097lW3FIw7kV2
 Ewk4Mqs7ENlzghHQXMRr+/UteF/sdnqniiMppZwEpE43WwbhzYQcw4QMBygav2xGHBRV
 t/C0J6C01MVGrP/XG4VCxGSQKU7d3nlNG+wDkS+psYCj8RmZ15oP07fIstuF4t0xTVND
 dq2IE+6O5g5x21AthylNvL0Nqy7w9OGme1f++s1HJeGj8R2UdNC1/Zyj2QtsFCi0RiWa XA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4chqsh5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 14:15:52 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HE8Taf026439;
        Tue, 17 May 2022 14:15:50 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3g2429cb6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 14:15:49 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HEFk7940304926
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 14:15:47 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D4A5FA404D;
        Tue, 17 May 2022 14:15:46 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E6F0A4040;
        Tue, 17 May 2022 14:15:46 +0000 (GMT)
Received: from [9.152.224.153] (unknown [9.152.224.153])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 14:15:46 +0000 (GMT)
Message-ID: <ffd3a38f-da9f-4c94-0f28-40aa061ff685@linux.ibm.com>
Date:   Tue, 17 May 2022 16:15:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v5 04/10] KVM: s390: pv: Add dump support definitions
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, borntraeger@linux.ibm.com,
        imbrenda@linux.ibm.com
References: <20220516090817.1110090-1-frankja@linux.ibm.com>
 <20220516090817.1110090-5-frankja@linux.ibm.com>
From:   Steffen Eiden <seiden@linux.ibm.com>
Organization: IBM
In-Reply-To: <20220516090817.1110090-5-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: E_i46uljC0dr9q3qIQpAqQ9ooSO6brEc
X-Proofpoint-ORIG-GUID: E_i46uljC0dr9q3qIQpAqQ9ooSO6brEc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_03,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=865 spamscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 clxscore=1015 phishscore=0
 suspectscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170087
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/16/22 11:08, Janosch Frank wrote:
> Let's add the constants and structure definitions needed for the dump
> support.
> 
> Signed-off-by: Janosch Frank<frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda<imbrenda@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
