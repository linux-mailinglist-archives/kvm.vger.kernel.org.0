Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C73584EDC86
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 17:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238057AbiCaPRV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 11:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238016AbiCaPRU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 11:17:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729C014D7B1;
        Thu, 31 Mar 2022 08:15:32 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22VEKIO5029650;
        Thu, 31 Mar 2022 15:15:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=PbvCQoK8/jeaxCJQEpBPkUcNZt8OvwZscVv4Z2AL1sc=;
 b=cVpWoWsZSa3BhyXP7NVRxe/vwyh/sCmVCwqsSSr4WIPZhPtzeIeALjgvFq4VLjdRCllP
 iMwwPJi8sMjex6+ab0Le3PNAbD4OQ3fYXRbEX7cicEoSh5GXAFa1bSV9AtoRVy2UasWM
 /mQgmrS6dPrinnjAhkNJOMAYN6xrLpwz/sB//AHTgKr1iDN+LyjIdQrYofEe/c3mIurN
 jHsVym+Ic0mH2bC1vrbMMQdcS8teQnaKVOlOQtnbrp2jjDO9RG+CYK73VVS2MWFLaTe7
 v956TqV5skTmXCvO0IqMJYcrVqWF/rZ4cTU4cUOOmXOdG3ieX30sUQ/NOMfMzAAfuirA yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f556tn26e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 15:15:32 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22VEUZhK026088;
        Thu, 31 Mar 2022 15:15:31 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f556tn25p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 15:15:31 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22VFCXlB006907;
        Thu, 31 Mar 2022 15:15:29 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3f1tf932he-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 15:15:29 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22VFFQP041484608
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Mar 2022 15:15:26 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26BE811C04C;
        Thu, 31 Mar 2022 15:15:26 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7CCE11C050;
        Thu, 31 Mar 2022 15:15:25 +0000 (GMT)
Received: from [9.145.159.108] (unknown [9.145.159.108])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 31 Mar 2022 15:15:25 +0000 (GMT)
Message-ID: <ea22f0a6-090d-5a9c-5de6-8992902ee107@linux.ibm.com>
Date:   Thu, 31 Mar 2022 17:15:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, scgl@linux.ibm.com,
        borntraeger@de.ibm.com, pmorel@linux.ibm.com, pasic@linux.ibm.com,
        nrb@linux.ibm.com, thuth@redhat.com, david@redhat.com
References: <20220330144339.261419-1-imbrenda@linux.ibm.com>
 <20220330144339.261419-3-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 2/4] lib: s390: rename and refactor
 vm.[ch]
In-Reply-To: <20220330144339.261419-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MxStofaRR8THowYuJ-wll-ObpTrGwwlJ
X-Proofpoint-ORIG-GUID: myOTbixFlksbo4PlFc6P2gG96Mwlf36K
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-31_05,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 impostorscore=0 adultscore=0 spamscore=0
 priorityscore=1501 malwarescore=0 mlxscore=0 phishscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203310084
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/30/22 16:43, Claudio Imbrenda wrote:
> Refactor and rename vm.[ch] to hardware.[ch]
> 
> * Rename vm.[ch] to hardware.[ch]
> * Consolidate all detection functions into detect_host, which returns
>    what host system the test is running on
> * Move host_is_zvm6 to the library (was in a testcase)

We can drop that function, we don't need to fence this anymore.
