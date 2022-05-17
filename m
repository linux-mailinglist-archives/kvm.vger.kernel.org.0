Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89DE752A48C
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 16:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348630AbiEQOQm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 10:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348916AbiEQOQc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 10:16:32 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F35BB84A;
        Tue, 17 May 2022 07:16:30 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HEBrnZ001891;
        Tue, 17 May 2022 14:16:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=poQ0fLGeTUMqcgsQcFOgOQUX0YzDAx/XXbaudYffUW4=;
 b=G2n80nGUZCUzR+wWm54A7//zzyHfT9OffPf7n5u5wok5NStttggX04V2PteDMnkfM55s
 1ERzhQCBZ3oqhlYT/TyFdLB56hz4DrYUH7Sn7d3LYxDnHT8gJtEW8tYiSVWuXm+iCeex
 B0JV45FZD2mXOE7Gxnq/bTGRhOedA7bekSGnTLmYE+fIYOPMVRb4YcCkX2mfqkKCinvy
 tIQML7Qmdx4vs1BgbSGEKIM3JpYE4QP6KwM/IqqxMSiGrgRcJfg9YPBxVDYSj+bv6CqV
 vkTLGZ/1HHtJgnfIPDwqhNbbHyCZ4ge+zJfa5iFbLoZ8SC+2629iPm8cU8WSDGJp9A35 0A== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4d8mg3rn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 14:16:29 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HE8Q26001124;
        Tue, 17 May 2022 14:16:27 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3g2428kg0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 14:16:27 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HEGOtO45285782
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 14:16:24 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41C3FA404D;
        Tue, 17 May 2022 14:16:24 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B97AA4040;
        Tue, 17 May 2022 14:16:24 +0000 (GMT)
Received: from [9.152.224.153] (unknown [9.152.224.153])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 14:16:23 +0000 (GMT)
Message-ID: <0bdd55d1-536f-802f-a938-5999d5287e6b@linux.ibm.com>
Date:   Tue, 17 May 2022 16:16:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v5 05/10] KVM: s390: pv: Add query dump information
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, borntraeger@linux.ibm.com,
        imbrenda@linux.ibm.com
References: <20220516090817.1110090-1-frankja@linux.ibm.com>
 <20220516090817.1110090-6-frankja@linux.ibm.com>
From:   Steffen Eiden <seiden@linux.ibm.com>
Organization: IBM
In-Reply-To: <20220516090817.1110090-6-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NozlinstRYgn69gxzuj2uVTf4jIDUxVQ
X-Proofpoint-ORIG-GUID: NozlinstRYgn69gxzuj2uVTf4jIDUxVQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_03,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 mlxlogscore=731 lowpriorityscore=0 adultscore=0 suspectscore=0 spamscore=0
 bulkscore=0 priorityscore=1501 malwarescore=0 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
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
> The dump API requires userspace to provide buffers into which we will
> store data. The dump information added in this patch tells userspace
> how big those buffers need to be.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
