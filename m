Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 265B05BE001
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 10:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbiITI3K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 04:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231396AbiITI1x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 04:27:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5659696F2;
        Tue, 20 Sep 2022 01:26:02 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28K8DrTh025801;
        Tue, 20 Sep 2022 08:26:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=UDzkbnD66p8Er9WZd2o/NMugtvzk0/WLEycMDcZBuC8=;
 b=KF3KS0zo9S++guFnpfgf5k91hPion1s8uhVhRHOT+Bs+LZ9Z0amuCLOlu4ZAlETvW1TW
 OahHCduaOl+dJAYB85/RvrHdi7GPmR/M/TIEAPxxw2yPyQtBJru+wa3pfIEX/E7PxkGe
 I5GM6iMy9CdRysZCORKisCf4X/SpKTms8CppCJKpRQItTJHcZnAag1NJbtwF1kh90wRu
 zpcSSm/+su98NFIqh9s6lpjo7vPWOND8XaTFaoKB0a1bQ5RB8YU75hmWyyKjA8qJH20h
 2XIyqHKMv41SgQBNspLzVAe6Uj2DTL7N880KtjHtRpYRcBBWlWC2LGabhzoYLjfV37vi hA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jq9trgct1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 08:26:01 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28K8FHSK032159;
        Tue, 20 Sep 2022 08:26:01 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jq9trgcs1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 08:26:01 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28K8LLJ1015414;
        Tue, 20 Sep 2022 08:25:59 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3jn5v93hu7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 08:25:59 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28K8Pubh34931136
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 08:25:56 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4E1252051;
        Tue, 20 Sep 2022 08:25:55 +0000 (GMT)
Received: from [9.171.60.222] (unknown [9.171.60.222])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 46CBB5204E;
        Tue, 20 Sep 2022 08:25:55 +0000 (GMT)
Message-ID: <8b8eb1d8-a8ae-d57f-559f-5e9d0fc981b9@linux.ibm.com>
Date:   Tue, 20 Sep 2022 10:25:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH] KVM: s390: pci: fix GAIT physical vs virtual pointers
 usage
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     nrb@linux.ibm.com, pmorel@linux.ibm.com, schnelle@linux.ibm.com,
        farman@linux.ibm.com, borntraeger@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com, svens@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220907155952.87356-1-mjrosato@linux.ibm.com>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220907155952.87356-1-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TmlArscMU7N6LQGiHGFn0By2ZJrVtUOZ
X-Proofpoint-ORIG-GUID: TqWAQ-Tp0UBpljdVtmcMJ92IiZc5-AP9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-20_02,2022-09-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209200049
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/7/22 17:59, Matthew Rosato wrote:
> The GAIT and all of its entries must be represented by physical
> addresses as this structure is shared with underlying firmware.
> We can keep a virtual address of the GAIT origin in order to
> handle processing in the kernel, but when traversing the entries
> we must again convert the physical AISB stored in that GAIT entry
> into a virtual address in order to process it.
> 
> Note: this currently doesn't fix a real bug, since virtual addresses
> are indentical to physical ones.
> 
> Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
> Acked-by: Nico Boehr <nrb@linux.ibm.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

Thanks, applied

