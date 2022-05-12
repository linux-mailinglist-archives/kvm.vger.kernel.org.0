Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38D0A524BE1
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 13:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353371AbiELLmH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 07:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351802AbiELLmE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 07:42:04 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03ECC37BFD;
        Thu, 12 May 2022 04:42:04 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24CBLhTV024029;
        Thu, 12 May 2022 11:42:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=2HThL5e0p57DZEmje+L+wRf4APcvYg3CjZSZeahaRoQ=;
 b=GQxUeXmGnb/gCcx0NEMR9SQXxyP/3X5NUmZQtfKEEUXtUYnZbwpUJ5PjeevYXTk/xfeE
 1AH+WKpASyhZpDgOL0KViO/3pZ7EFa13UmbfgUCLguV1bKNcbWE6aOWZsCnzKvANn96b
 6+M+WM3glgYhsxQ2FqR4KVdRAnoc3wWDIOB2T6KoxeMk+4Fn+qA/jwfVycdsBbmKRTdp
 zcDSSVKBM5IyxRPg44NozM/w21Uc+6GzzGDNaOBfpoaR31IhQkaE98a6yhRnfuk1CW3w
 lOnmM5Y2Z6Zz+IYBUtrrZt4o/ifBGvOvolfUN7PC0iH5BjOAeYzdr9qD+zOP2gAYtY1w zQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g119xgavr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 11:42:03 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24CBQZxB010065;
        Thu, 12 May 2022 11:42:02 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g119xgaus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 11:42:02 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24CBc2jH002228;
        Thu, 12 May 2022 11:42:00 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3fyrkk2uds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 11:42:00 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24CBfvNZ56230220
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 11:41:57 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5626FA4040;
        Thu, 12 May 2022 11:41:57 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EAE5EA404D;
        Thu, 12 May 2022 11:41:56 +0000 (GMT)
Received: from [9.152.224.243] (unknown [9.152.224.243])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 May 2022 11:41:56 +0000 (GMT)
Message-ID: <ecf827ee-4b07-c999-064d-96d77607cf1c@linux.ibm.com>
Date:   Thu, 12 May 2022 13:41:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, wintera@linux.ibm.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com
References: <20220506092403.47406-1-pmorel@linux.ibm.com>
 <20220506092403.47406-3-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v9 2/3] s390x: KVM: guest support for topology function
In-Reply-To: <20220506092403.47406-3-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4W7oIOnb_eCQykAqfrgFBO8sFj4xES6F
X-Proofpoint-ORIG-GUID: WZNU0cAi9OojDenHDJIpNKFJkW1pCIuG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_02,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 mlxscore=0 clxscore=1015 phishscore=0 impostorscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2205120052
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/6/22 11:24, Pierre Morel wrote:
> We let the userland hypervisor know if the machine support the CPU
> topology facility using a new KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.

Nope, we indicate KVM's support which is based on the machine's support.

On the same note: Shouldn't the CAP indication be part of the last 
patch? The resets are needed for a full support of this feature, no?
