Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB9964CA7A6
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 15:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234056AbiCBOL4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 09:11:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241670AbiCBOLz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 09:11:55 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 464DC89CC2;
        Wed,  2 Mar 2022 06:11:00 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 222CO7u4010978;
        Wed, 2 Mar 2022 14:10:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : reply-to : subject : to : cc : references : from :
 in-reply-to : content-type : content-transfer-encoding; s=pp1;
 bh=8nwZjKbGsA01hndn3erwFvpVFCQkET2EruMAUiO8drk=;
 b=QoliAwyYG5VNgmPd98Ph8MjHIlKjsEbd+Tv0Y3FUdqRaQDLTEcSg6tmG5LBtB96na9lZ
 SkrNXh+GDGqYmj4amq3wpDIYTm7y30b3GTd0Z7byeKBB1xJWkpY7Kj6bDO/AVHxQvacN
 7cLW0IktgXxy67EPYEutnVS/+xxY7WB2MY1YXrUQs+Wi8AR3YUO0zCUbkDVQNKHCIJ5m
 I8k1gRTlj5l0iCbfqNoJ37jPEf2sKZf309i+h0X/Hy580jMHQICgc0KJ1zI/y4QbaS2x
 7eAZwl64I7Hxmj/Bx0810XsbTQTdBgC4B8hAs4D/uuWWUvUERG1MnOaXDq7lvLe9c9pz 1Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ej8hxt7vx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 14:10:34 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 222D0Gca005590;
        Wed, 2 Mar 2022 14:10:34 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ej8hxt7vb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 14:10:33 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 222E2X8x003331;
        Wed, 2 Mar 2022 14:10:32 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01wdc.us.ibm.com with ESMTP id 3efbu9vy4y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 14:10:32 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 222EAVrJ52494808
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Mar 2022 14:10:31 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 474F312405E;
        Wed,  2 Mar 2022 14:10:31 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E946A124066;
        Wed,  2 Mar 2022 14:10:29 +0000 (GMT)
Received: from [9.65.246.177] (unknown [9.65.246.177])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  2 Mar 2022 14:10:29 +0000 (GMT)
Message-ID: <bc46e89f-c446-d4a5-e067-8b280d16d09a@linux.ibm.com>
Date:   Wed, 2 Mar 2022 09:10:29 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Reply-To: jjherne@linux.ibm.com
Subject: Re: [PATCH v18 00/17] s390/vfio-ap: dynamic configuration support
Content-Language: en-US
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20220215005040.52697-1-akrowiak@linux.ibm.com>
 <97f95ab8-3613-1552-51fa-74f69a431bcc@linux.ibm.com>
From:   "Jason J. Herne" <jjherne@linux.ibm.com>
Organization: IBM
In-Reply-To: <97f95ab8-3613-1552-51fa-74f69a431bcc@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zVD4B5dxHADiv8INipgNUs4AiXkoP5i1
X-Proofpoint-GUID: WbeNtJrKJqITS5L3jOiNEAZRHxCpq-WH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-02_06,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 clxscore=1011 mlxscore=0 bulkscore=0 spamscore=0
 impostorscore=0 mlxlogscore=976 suspectscore=0 phishscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203020061
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/28/22 10:53, Tony Krowiak wrote:
> PING!! Any takers?
I'm taking a look, starting where I left off on v17, patch #7.

-- 
-- Jason J. Herne (jjherne@linux.ibm.com)
