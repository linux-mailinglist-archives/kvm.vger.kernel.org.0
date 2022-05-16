Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A910B528C8D
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 20:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344572AbiEPSGp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 14:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344570AbiEPSGj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 14:06:39 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C8F237E4;
        Mon, 16 May 2022 11:06:39 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GHflm6021266;
        Mon, 16 May 2022 18:06:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Vm9ynAXF2s9PEBjtzIV/m8k/DNjgTPnJCAww7PnACSg=;
 b=aU9ZpEMZKmQDW8G0HO4jj57YHBhkJ2SdSyVRxczzbGJ85hGeVT2TIOC+EvBuZ6Zse4Yl
 sAf3UFgNiyBJQQngqu/i5jO26CVIXBYjJTs7WkQ3foKojY0KpHLArE/DzznuVljk0Gsn
 Bpu+DPRy7+X5HAwOV7cjTQHkr10qG47cUpiFVPo/HjhC5OhQQGHAq2kA+AcIfL74GEHL
 7hzpf2a3gSWgBJ2QLEMPHJqT2lPkAdr4TnYFETLWU9ZczoIOP1ErmVGHSDqlmaAjCGKV
 OwDkUV659XPichKDQOFaF0MV1tD6dIIXReESOMHwUyacErwRgGWRjwMqPhb2WshR3wTr GA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3u82rec4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 18:06:37 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24GI1wE6000803;
        Mon, 16 May 2022 18:06:36 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3u82rebp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 18:06:36 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24GHvjLD029513;
        Mon, 16 May 2022 18:06:35 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma03dal.us.ibm.com with ESMTP id 3g242a3ukj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 18:06:35 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24GI6Y5Q14287496
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 18:06:34 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 493DF6A04D;
        Mon, 16 May 2022 18:06:34 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 338E56A05F;
        Mon, 16 May 2022 18:06:33 +0000 (GMT)
Received: from [9.65.254.31] (unknown [9.65.254.31])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 16 May 2022 18:06:33 +0000 (GMT)
Message-ID: <89fce9f5-4708-5208-ecfd-fb5dbc658d04@linux.ibm.com>
Date:   Mon, 16 May 2022 14:06:32 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v19 05/20] s390/vfio-ap: refresh guest's APCB by filtering
 AP resources assigned to mdev
Content-Language: en-US
To:     jjherne@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
 <20220404221039.1272245-6-akrowiak@linux.ibm.com>
 <fc760c00-0559-68d8-fd2d-f29e014a6685@linux.ibm.com>
 <62668577-bf0c-eda5-56a0-9ca56e5f9ce6@linux.ibm.com>
 <6720e18e-0638-7f2f-533e-beca8a990404@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <6720e18e-0638-7f2f-533e-beca8a990404@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xkaP2pNtfCv_qoeqQrac9Zvi9DoH-umD
X-Proofpoint-GUID: j33ma-arGqsD73kbkTGRsqnj7TJhw7RD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_15,2022-05-16_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 bulkscore=0 spamscore=0 impostorscore=0
 suspectscore=0 malwarescore=0 priorityscore=1501 mlxscore=0 adultscore=0
 mlxlogscore=897 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205160097
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks for the review

On 5/16/22 1:50 PM, Jason J. Herne wrote:
> Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>

