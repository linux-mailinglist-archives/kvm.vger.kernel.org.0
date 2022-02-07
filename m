Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D31C64AC467
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 16:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235307AbiBGPxj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 10:53:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385641AbiBGPot (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 10:44:49 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C076C0401E6;
        Mon,  7 Feb 2022 07:44:46 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 217Esqsd030207;
        Mon, 7 Feb 2022 15:44:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=jOhZpDNAvGlx7JL+JuWldFRo7QkbLt/2NFIFiLXgya8=;
 b=AqaFISx6+gUOBnC0vR5PiJCz4h3L4LakeVoLlFxq/TETQLIoFVLnhQENrF36ySUXOL2y
 eKAy9xLeAQH3iQVWd2CPa66aGlBEL/pJvSwyXC2yULIUS8TDbNOA+pbggLs6SamLaqmY
 arUWLDWAhjpAEcMqDr/ckFTbGt9SkYgYWnUPDgAm2WLN+aFOrySeOgu1xbMs7IkaGckb
 9LocmVsOR81w9PXjqf0+Yqq8yDOeNa8rqcENH/VyUPc7GRUnL3h1v1r5XvndmyrY6Yqq
 0mS983Av1lYa9rNYyzZChDLKVkR7f2RrOuFrPdp9O24hjlWt3pZv9rwqL9mNbJTFWrxK Lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e22st02wm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 15:44:46 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 217FJkHp027799;
        Mon, 7 Feb 2022 15:44:45 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e22st02w0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 15:44:45 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 217FhWnM011652;
        Mon, 7 Feb 2022 15:44:44 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02wdc.us.ibm.com with ESMTP id 3e2f8mjcxf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 15:44:44 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 217Fig8v35389830
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Feb 2022 15:44:42 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C02CA6A063;
        Mon,  7 Feb 2022 15:44:42 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CCBC46A058;
        Mon,  7 Feb 2022 15:44:40 +0000 (GMT)
Received: from [9.211.136.120] (unknown [9.211.136.120])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  7 Feb 2022 15:44:40 +0000 (GMT)
Message-ID: <f0a3fc18-aedc-7215-06f1-7a8e68032155@linux.ibm.com>
Date:   Mon, 7 Feb 2022 10:44:40 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 30/30] MAINTAINERS: additional files related kvm s390
 pci passthrough
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
 <20220204211536.321475-31-mjrosato@linux.ibm.com>
 <9a186055-2637-0113-18be-ab08b5db1c74@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <9a186055-2637-0113-18be-ab08b5db1c74@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Sk1YmCfl_cCtPj7dVZB7Q2HNaotvq7Jn
X-Proofpoint-ORIG-GUID: esDzGk1kIB0F5c_Gy_mzP4RmcPDmmcY5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_05,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 impostorscore=0 bulkscore=0 adultscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202070097
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/7/22 8:04 AM, Christian Borntraeger wrote:
> 
> 
> Am 04.02.22 um 22:15 schrieb Matthew Rosato:
>> Add entries from the s390 kvm subdirectory related to pci passthrough.
>>
>> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
> 
> 
> Can you change that to  borntraeger@linux.ibm.com ?
> 

Sure.  It looks like this happened on some of the earlier patches in 
this series too, I'll go ahead and adjust them all.
